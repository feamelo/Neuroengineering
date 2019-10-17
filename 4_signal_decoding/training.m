%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Preprocessing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                        %
% Autora: Fernanda Amaral Melo                                           %
% Contato: fernanda.amaral.melo@gmail.com                                %
%                                                                        %
% Treino dos parametros do filtro de kalman para decodificacao neural    %
% O filtro de kalman modela o seguinte sistema                           %
% x = [posy,posx,vely,velx,1]'                                           %
% x(t)=A*x(t-1)+w(t)                                                     %
% y(t)=C*x(t)+q(t)                                                       %
%                                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%% Initialize variables %%%%%%%%%%%%%%%%%%%%%%%%%%%% %%
close all; clear all; clc;
load('data/q1.mat')
melhores = zeros(10,1);
interval=0.05;
y_tot=[];
x_tot=[];

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Coletando dado %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%

for n=1:100 %Coletando dados dos 100 primeiros canais (training database)
    time=data(n).Time;
    channel=length(data(n).Neuron);
    spikes=data(n).Neuron;
    
    x=zeros(2,length(time)-1); %Variavel para guardar a velocidade desejada em x e y
    for j=2:length(time)
        x(1,j-1)=data(n).CursorPos{j,1}(2); %Posicao y
        x(2,j-1)=data(n).CursorPos{j,1}(1); %Posicao x
        x(3,j-1)=(data(n).CursorPos{j,1}(2)-data(n).CursorPos{j-1,1}(2))/interval; %Vel y
        x(4,j-1)=(data(n).CursorPos{j,1}(1)-data(n).CursorPos{j-1,1}(1))/interval; %Vel x
        x(5,j-1)=1;    
    end
    
    y=zeros(channel,length(time)); %variavel para guardar o firing rate
    for l=1:length(time)
        for j=1:channel % Alterna o numero de canais
            for k=1:length(spikes(j).Spike) % Numero de spikes do neuronio j
                aux = spikes(j).Spike(k) - time(l);
                if (abs(aux) <= interval) % Se a distancia entre o instante i e o spike for menor do q o intervalo
                    y(j,l)=y(j,l)+1; % Adiciona 1 no Firing Rate daquele instante
                elseif (aux > interval)
                    break;
                end
            end
        end
    end
    y=y(:,1:length(y)-1); %Subtrai o ultimo elemento para ficar com um vetor do mesmo tamanho de x
    y_tot=[y_tot,y];
    x_tot=[x_tot,x];
end

%% %%%%%%%%%%%%%% Treina parametros do filtro de kalman %%%%%%%%%%%%%% %%

D = length(time)-1;
C = y_tot*x_tot' * (x_tot*x_tot')^-1;
Q = 1/D * (y_tot - C*x_tot) * (y_tot - C*x_tot)';

x1 = x_tot(:,1:length(x_tot)-1);
x2 = x_tot(:,2:length(x_tot));
A = x2*x1' * (x1*x1')^(-1);
W = 1/(D-1) * (x2 - A*x1)*(x2 - A*x1)';

save('kalman_a', 'Q','C','A','W');
%% %%%%%%%%%%%%%%%%%%%%%% Selecao de canais %%%%%%%%%%%%%%%%%%%%%%%%%% %%
    
    for i=1:channel
        canal(i)=abs(C(i,1)+C(i,2)); % O peso de cada canal e associado ao valor 
        posicao(i)=i;                % absoluto da sua contribuicao em Vx e Vy
    end
    
    for i=1:channel % Ordena o vetor de forma crescente e salva as melhores posicoes
        for j=1:channel
            if (canal(i)<canal(j))
                aux=canal(i);
                canal(i)=canal(j);
                canal(j)=aux;
                aux=posicao(i);
                posicao(i)=posicao(j);
                posicao(j)=aux;
            end
        end
    end
    
    %Salva os 10 melhores canais
    for i=0:9
        melhores(i+1)=posicao(channel-i);
    end

%Best channel found 
%c=[99   162   189    65   141   156    68   168   191   121];
c=melhores';

%% Recalcula os parametros do filtro utilizando os 10 melhores canais 

y_best=zeros(10,length(y_tot));
for i=1:10
    y_best(i,:)=y_tot(c(i),:);
end

D = length(time)-1; 
C = y_best*x_tot' * (x_tot*x_tot')^-1;
Q = 1/D * (y_best - C*x_tot) * (y_best - C*x_tot)';

x1 = x_tot(:,1:length(x_tot)-1);
x2 = x_tot(:,2:length(x_tot));
A = x2*x1' * (x1*x1')^(-1);
W = 1/(D-1) * (x2 - A*x1)*(x2 - A*x1)';

save('kalman_b', 'Q','C','A','W');

%% Testa com qualquer amostra
q1_a=false;
if (q1_a)
    load('data/kalman_a.mat');
else
    load('data/kalman_b.mat');
end
    
n=1; % Numero da amostra
interval=0.05;

    time=data(n).Time;
    channel=length(data(n).Neuron);
    spikes=data(n).Neuron;
    
    x=zeros(2,length(time)-1); %Variavel para guardar a velocidade desejada em x e y
    for j=2:length(time)
        x(1,j-1)=data(n).CursorPos{j,1}(2); %Posicao y
        x(2,j-1)=data(n).CursorPos{j,1}(1); %Posicao x
        x(3,j-1)=(data(n).CursorPos{j,1}(2)-data(n).CursorPos{j-1,1}(2))/interval; %Vel y
        x(4,j-1)=(data(n).CursorPos{j,1}(1)-data(n).CursorPos{j-1,1}(1))/interval; %Vel x
        x(5,j-1)=1;    
    end
    
    y=zeros(channel,length(time)); %variavel para guardar o firing rate
    for l=1:length(time)
        for j=1:channel % Alterna o numero de canais
            for k=1:length(spikes(j).Spike) % Numero de spikes do neuronio j
                aux = spikes(j).Spike(k) - time(l);
                if (abs(aux) <= interval) % Se a distancia entre o instante i e o spike for menor do q o intervalo
                    y(j,l)=y(j,l)+1; % Adiciona 1 no Firing Rate daquele instante
                elseif (aux > interval)
                    break;
                end
            end
        end
    end
    
    
    y=y(:,1:length(y)-1); %Subtrai o ultimo elemento para ficar com um vetor do mesmo tamanho de x
    y_best=zeros(10,length(y));
    
    if (q1_a)
        y_best=y;
    else
        for i=1:10
            y_best(i,:)=y(c(i),:);
        end
    end
    
    x_est1=zeros(size(x));
    x_est2=zeros(size(x));
    
    for t=1:length(time)-1
        b=y_best(:,t) - diag(Q);
        x_est1(:,t)=(C'*C)\(C'*b);
        x_est2(:,t)=x_est1(:,t)-x_est1(:,1);
    end
    
    % plota a comparacao entre a velocidade real e a estimada pelo filtro de kalman 

    figure
    subplot(211); plot(x(4,:));
    hold on
    subplot(211); plot(x_est2(4,:));
    hold off
    
    if (q1_a)
        title('Velocity of cursor on X axis - All channels');
    else
        title('Velocity of cursor on X axis - All channels');
    end
    
    xlabel('Time');
    ylabel('Velocity');
    legend('Measured','Estimated');
    
    subplot(212); plot(x(3,:));
    hold on
    subplot(212); plot(x_est2(3,:));
    hold off

        
    if (q1_a)
        title('Velocity of cursor on Y axis - Best 10 channels');
    else
        title('Velocity of cursor on Y axis - Best 10 channels');
    end
    
    xlabel('Time');
    ylabel('Velocity');
    legend('Measured','Estimated');