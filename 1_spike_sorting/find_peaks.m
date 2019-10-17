%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Find Peaks %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                        %
% Autora: Fernanda Amaral Melo                                           %
% Contato: fernanda.amaral.melo@gmail.com                                %
%                                                                        %
% Detecção de picos em um sinal de eletromiografia                       %
% Parametros:                                                            %
% - time: vetor de tempo                                                 %
% - electrodeVoltage: medidas de EMG                                     %
% - signal: struct contendo os dados do sinal                            %
%           - Ts: Período de amostragem                                  %
%           - Fs: Frequência de amostragem                               %
%           - N: Número de samples                                       %
%           - Tf: Tempo total (duração dos dados)                        %
% Saida:                                                                 %
% - spikeTimes : instantes em que ocorreram os disparos                  %
%                                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function spikeTimes = find_peaks(time, electrodeVoltage, signal)

Wn=[700;3000]*2/signal.fs; %cutoff frequency 700 ~ 4000 300~3000
n=50; %filter order
b = fir1(n,Wn,'bandpass');
y=filtfilt(b,1,electrodeVoltage); %Filtro FIR causal

spikeTimes=0;
lower_peak = 0.5 * max (y); %Threshold de tens�o para detec��o de picos
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Plot %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% figure
% plot(time,y);
% hold on
% plot(spikeTimes,peak,'o ');
% grid on; title ('Spikes detected'); xlabel('Tempo (s)'); ylabel('Tens�o (V)');
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end