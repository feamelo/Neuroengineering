%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% FES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                        %
% Autora: Fernanda Amaral Melo                                           %
% Contato: fernanda.amaral.melo@gmail.com                                %
%                                                                        %
% Predição do torque induzido pela estimulacao                           % 
% eletrica com base nas medidas de EMG                                   %
% Parametros:                                                            %
% - time: vetor de tempo                                                 %
% - emgTA: dados da 1a sessao de estimulacao                             %
% - emgGS: dados da 3a sessao de estimulacao                             %
% - signal: struct contendo os dados do sinal                            %
%           - Ts: Período de amostragem                                  %
%           - Fs: Frequência de amostragem                               %
%           - N: Número de samples                                       %
%           - Tf: Tempo total (duração dos dados)                        %
% Saida:                                                                 %
% - Torque estimado                                                      %
%                                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function torque = prediction(time, emgTA, emgGS, signal)

torque = zeros(1,signal.N);

u = abs((filtro(time, emgGS, signal) + filtro(time, emgTA, signal))/2);
u = u/norm(u);

%P value was determined using a 2nd order polyfit
P=[[367622.684963240 -1170.07962001174 8.81925855014828]];
torque=polyval(P,u);
torque = torque; 

end

function emgProcessedVoltage = filtro(time, emgVoltage, signal)
n=5; %filter order

if (signal.fs <= 400)
    Wn=10*2/signal.fs; %cutoff frequency 
    [B,A] = butter(n,Wn,'high');
else 
    Wn=[10;400]*2/signal.fs; %cutoff frequency 
    [B,A] = butter(n,Wn,'bandpass');
end

y=filtfilt(B,A,emgVoltage); %Filtro causal

%% Retifica��o
y=abs(y);

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

end