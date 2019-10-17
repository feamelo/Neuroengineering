%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Find Peaks %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                        %
% Autora: Fernanda Amaral Melo                                           %
% Contato: fernanda.amaral.melo@gmail.com                                %
%                                                                        %
% Detecção de picos em um sinal de EMG com dois canais                   %
% Parametros:                                                            %
% - time: vetor de tempo                                                 %
% - electrodeVoltage: medidas de EMG                                     %
% - signal: struct contendo os dados do sinal                            %
%           - Ts: Período de amostragem                                  %
%           - Fs: Frequência de amostragem                               %
%           - N: Número de samples                                       %
%           - Tf: Tempo total (duração dos dados)                        %
% Saída:                                                                 %
% spikeTimesA e spikeTimesB: vetores com NspikesA e NspikesB colunas,    % 
% em que Nspikes e o numero de spikes detectados. Cada elemento dos      %
% vetores representam o instante no qual ocorreu o spike.                %
%                                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [spikeTimesA, spikeTimesB] = two_channels_find_peaks(time, electrodeVoltage, signal)

Wn=[800;3500]*2/signal.fs; %cutoff frequency 700 ~ 4000 300~3000
n=50; %filter order
b = fir1(n,Wn,'bandpass');
y=filtfilt(b,1,electrodeVoltage); %Filtro FIR causal

spikeTimesA=0; spikeTimesB=0; spikeTimes=0;
lower_peak = 0.30 * max (y); %Threshold de tens�o para detec��o de picos
min_distance = 0.002; %Menor distancia temporal entre picos

j=1;
for i=2:signal.N-1
   if (y(i) >= y(i-1) && y(i) >= y(i+1)) %Se o valor for maior do que seus vizinhos
      if ( y(i) >= lower_peak && j>1) %Limite Inferior (volts)
        if (time(i) - spikeTimes(j-1) > min_distance) % Menor distancia entre os picos (segundos)
        	peak(j)=y(i);
        	spikeTimes(j)=time(i);
            j=j+1;
        elseif (time(i) - spikeTimes(j-1) < min_distance && y(i) > peak(j-1)) 
            peak(j-1)=y(i);
            spikeTimes(j-1)=time(i);
        end
        
      elseif ( y(i) >= lower_peak && j==1) % Primeiro pico n�o precisa de verifica��o da distancia minima
      	peak(j)=y(i);
      	spikeTimes(j)=time(i);
      	j=j+1;
      end
   end
end

threshold = max(y)/1.8;
j=1; k=1;
for i=1:length(spikeTimes)
    if (peak(i) > threshold)
        spikeTimesA(j)=spikeTimes(i);
        j=j+1;
    else
       spikeTimesB(k)=spikeTimes(i);
        k=k+1;
    end
end
end