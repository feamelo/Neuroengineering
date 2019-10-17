%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Raster Plot %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                        %
% Autora: Fernanda Amaral Melo                                           %
% Contato: fernanda.amaral.melo@gmail.com                                %
%                                                                        %
% Funcao auxiliar para plotar o sinal eletrofisiologico                  %
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

function raster_plot(time, electrodeVoltage, spikeTimes, signal)

Wn=[700;3000]*2/signal.fs; %cutoff frequency 700 ~ 4000 300~3000
n=50; %filter order
b = fir1(n,Wn,'bandpass');
y=filtfilt(b,1,electrodeVoltage); %Filtro FIR causal

peaks = zeros (length(spikeTimes),1) + max(y); %Cria vetor para os picos detectados (posicionados no maior valor de y)
plot(spikeTimes,peaks, '+ '); 
axis([time(1) signal.Tf min(y) max(y)*1.1]); grid on; 

end
        
    