%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Preprocessing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                        %
% Autora: Fernanda Amaral Melo                                           %
% Contato: fernanda.amaral.melo@gmail.com                                %
%                                                                        %
% Deteccao de sinais provenientes de epilepsia                           %
% Parametros:                                                            %
% - time: vetor de tempo                                                 %
% - eegVoltage: tensão de entrada                                        %
% - signal: struct contendo os dados do sinal                            %
%           - Ts: Período de amostragem                                  %
%           - Fs: Frequência de amostragem                               %
%           - N: Número de samples                                       %
%           - Tf: Tempo total (duração dos dados)                        %
% Saida:                                                                 %
% - classificationResult:                                                % 
%           - 1 sinal proveniente de evento de epilepsia                 %
%           - 0 caso contrario.                                          %
%                                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function classificationResult = epilepsy(time, eegVoltage, signal)

n=4;
Wn=[13;20]*2/signal.fs; % beta 13 ~ 20 Hz
[B,A] = butter(n,Wn,'bandpass');
beta = filtfilt(B,A,eegVoltage);

if (rms(beta)>16)
   classificationResult = 1; % if seizure 
else
   classificationResult = 0; % if healthy
end

end