%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Preprocessing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                        %
% Autora: Fernanda Amaral Melo                                           %
% Contato: fernanda.amaral.melo@gmail.com                                %
%                                                                        %
% Matlab function to analyze ECG firing rate patterns                    %
% Parametros:                                                            %
% - time: vetor de tempo                                                 %
% - spikes: dados neurais                                                %
% Saida:                                                                 %
% - X, Y: Estimativa das velocidades nos dois eixos                      %
%                                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [velX, velY, neurons] = best_channels_decoder(time, spikes)

velX = zeros(length(time),1);
velY = zeros(length(time),1);
neurons = [];

velX = zeros(length(time),1);
velY = zeros(length(time),1);
[A,C,Q,W] = kalman_parametersB();

interval=0.05;
channel=length(spikes);
c=[65   153    45   137   159   169   193    99    59   121];

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

for i=1:10
    y_best(i,:)=y(c(i),:);
end
x_est1=zeros(5,length(y_best));
x_est2=zeros(5,length(y_best));

for t=1:length(time)-1
    b=y_best(:,t) - diag(Q);
    x_est1(:,t)=(C'*C)\(C'*b);
    x_est2(:,t)=x_est1(:,t)-x_est1(:,1);
end

% Assign output variables here
velX = [x_est2(4,:),0]';
velY = [x_est2(3,:),0]';
neurons = c;

end

function [A,C,Q,W] = kalman_parametersB()
% O ajuste dos parametros do filtro pode ser conferido no arquivo
% 'training.m' anexo

    kalman_parameters = load('data/kalman_b.mat');
    A=kalman_parameters.A;
    C=kalman_parameters.C;
    Q=kalman_parameters.Q;
    W=kalman_parameters.W;
end