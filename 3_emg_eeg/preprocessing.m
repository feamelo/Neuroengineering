%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Preprocessing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                        %
% Autora: Fernanda Amaral Melo                                           %
% Contato: fernanda.amaral.melo@gmail.com                                %
%                                                                        %
% Função para realizar o pre processamento dos dados de EMG              %
% Filtro passa faixa, retificacao do sinal e deteccao de envoltoria      %
% Parametros:                                                            %
% - time: vetor de tempo                                                 %
% - emgVoltage: tensão de entrada                                        %
% - signal: struct contendo os dados do sinal                            %
%           - Ts: Período de amostragem                                  %
%           - Fs: Frequência de amostragem                               %
%           - N: Número de samples                                       %
%           - Tf: Tempo total (duração dos dados)                        %
% Saida:                                                                 %
% - emgProcessedVoltage: Sinal processado                                %
%                                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function emgProcessedVoltage = preprocessing(time, emgVoltage, signal)
figure; subplot (4,1,1);
plot(time, emgVoltage); title('Sinal Original'); 
xlabel('Tempo (s)'); ylabel('Tens�o (V)'); grid on;

%% Filtragem
n=5; %filter order

if (signal.fs <= 400)
    Wn=10*2/signal.fs; %cutoff frequency 
    [B,A] = butter(n,Wn,'high');
else 
    Wn=[10;400]*2/signal.fs; %cutoff frequency 
    [B,A] = butter(n,Wn,'bandpass');
end

y=filtfilt(B,A,emgVoltage); %Filtro causal

subplot (4,1,2);
plot(time, y); title('Sinal Filtrado'); 
xlabel('Tempo (s)'); ylabel('Tens�o (V)'); grid on;

%% Retifica��o
y=abs(y);

subplot (4,1,3);
plot(time, y); title('Sinal Retificado'); 
xlabel('Tempo (s)'); ylabel('Tens�o (V)'); grid on;

%% Envolt�rio

window_size = round (0.25 / signal.Ts); %Tamanho da janela 
emgProcessedVoltage = y;

for i=1:signal.N
    if (i <= window_size)
        emgProcessedVoltage(i)=mean(y(1:2*i));
    elseif (signal.N-i <= window_size)
        emgProcessedVoltage(i)=mean(y(2*i-signal.N:signal.N));
    else
        emgProcessedVoltage(i)=mean(y(i-window_size : i+window_size));
    end
end

subplot (4,1,4);
plot(time, emgProcessedVoltage); title('Envolt�rio do Sinal'); 
xlabel('Tempo (s)'); ylabel('Tens�o (V)'); grid on;
end