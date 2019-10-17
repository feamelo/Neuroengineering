%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Preprocessing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                        %
% Autora: Fernanda Amaral Melo                                           %
% Contato: fernanda.amaral.melo@gmail.com                                %
%                                                                        %
% Função para detectar as faixas de frequencia do sinal de EEG           %
% Parametros:                                                            %
% - time: vetor de tempo                                                 %
% - eegVoltage: tensão de entrada                                        %
% - signal: struct contendo os dados do sinal                            %
%           - Ts: Período de amostragem                                  %
%           - Fs: Frequência de amostragem                               %
%           - N: Número de samples                                       %
%           - Tf: Tempo total (duração dos dados)                        %
% Saida:                                                                 %
% - delta, theta, alpha, beta, gamma: faixas de frequencia               %
%                                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [delta, theta, alpha, beta, gamma] = eeg_frequency(time, eegVoltage, signal)
n=4; %filter order

Wn=[0.5;4]*2/signal.fs; % delta 0.5 ~ 4 Hz
[B,A] = butter(n,Wn,'bandpass');
delta = filtfilt(B,A,eegVoltage); 
%figure; plot(delta)

Wn=[4;8]*2/signal.fs; % theta 4 ~ 8 Hz
[B,A] = butter(n,Wn,'bandpass');
theta = filtfilt(B,A,eegVoltage);
%figure; plot(theta)

Wn=[8;13]*2/signal.fs; % alpha 8 ~ 13 Hz
[B,A] = butter(n,Wn,'bandpass');
alpha = filtfilt(B,A,eegVoltage); 
%figure; plot(alpha)

Wn=[13;20]*2/signal.fs; % beta 13 ~ 20 Hz
[B,A] = butter(n,Wn,'bandpass');
beta = filtfilt(B,A,eegVoltage);
%figure; plot(beta)

Wn=[20;40]*2/signal.fs; % gamma 20 ~ 40 Hz
[B,A] = butter(n,Wn,'bandpass');
gamma = filtfilt(B,A,eegVoltage); 
%figure; plot(gamma)

end