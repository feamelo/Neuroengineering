%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Shape Plot %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                        %
% Autora: Fernanda Amaral Melo                                           %
% Contato: fernanda.amaral.melo@gmail.com                                %
%                                                                        %
% Funcao auxiliar para plotar o formato de cada disparo identificado     %
% Parametros:                                                            %
% - time: vetor de tempo                                                 %
% - electrodeVoltage: medidas de EMG                                     %
% - spikeTimes : instantes em que ocorreram os disparos                  %
% - signal: struct contendo os dados do sinal                            %
%           - Ts: Período de amostragem                                  %
%           - Fs: Frequência de amostragem                               %
%           - N: Número de samples                                       %
%           - Tf: Tempo total (duração dos dados)                        %
%                                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function shape_plot(time, electrodeVoltage, spikeTimes, signal)

Wn=[700;3000]*2/signal.fs; %cutoff frequency 700 ~ 4000 300~3000
n=50; %filter order
b = fir1(n,Wn,'bandpass');
y=filtfilt(b,1,electrodeVoltage); %Filtro FIR causal
interval = round(0.002/signal.Ts); 

% add each spike
for i=1:length(spikeTimes)
    
    for j=1:length(time)-interval
        if (time(j)==spikeTimes(i))
            break;
        end
    end
    
    plot(((-interval):(+interval)) , y((j-interval):(j+interval)));
    hold on   
end
end
