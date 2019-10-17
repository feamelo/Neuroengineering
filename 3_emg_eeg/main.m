%%%%%%%%%%%%%%%%%%%%%%%% EEG and EMG processing %%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                        %
% Autora: Fernanda Amaral Melo                                           %
% Contato: fernanda.amaral.melo@gmail.com                                %
%                                                                        %
% Processamento de sinais EEG e EMG                                      %
%                                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% before everything
close all; clear all; clc;

%% loading data
% load data/emg_practice.mat; flagEMG = 1; flagEEG = 0; flagClassifyEEG = 0;
 load data/eeg_practice_seizure_2.mat; flagEEG = 1; flagEMG = 0; flagClassifyEEG = 1;
% load data/eeg_practice_seizure_1.mat; flagEEG = 1; flagEMG = 0; flagClassifyEEG = 1;
% load data/eeg_practice_healthy_2.mat; flagEEG = 1; flagEMG = 0; flagClassifyEEG = 1;
% load data/eeg_practice_healthy_1.mat; flagEEG = 1; flagEMG = 0; flagClassifyEEG = 1;

%% EMG
if flagEMG
    emgProcessedVoltage = preprocessing(time, emgVoltage, signal);
end

%% EEG
if flagEEG
    [delta, theta, alpha, beta, gamma] = eeg_frequency(time, eegVoltage, signal);
end

%% EEG classification

if flagEEG
    classificationResult = epilepsy(time, eegVoltage, signal);
end

input('Press any key to move on');

%% plot 
figure;
if flagEMG

    subplot(211); plot(time, emgVoltage); title ('EMG Original signal');
    xlabel('time(s)'); ylabel('Voltage (V)');
    subplot(212); plot(time, emgProcessedVoltage); title ('EMG Processed signal');
    xlabel('time(s)'); ylabel('Voltage (V)');
    
end
if flagEEG
    
    subplot(611); plot(time, eegVoltage); title('Original');
    subplot(612); plot(time, delta); title('Delta');
    subplot(613); plot(time, theta); title('Theta');
    subplot(614); plot(time, alpha); title('Alpha');
    subplot(615); plot(time, beta); title('Beta');
    subplot(616); plot(time, gamma); title('Gama');
    
end

%% the end