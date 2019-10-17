%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% FES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                        %
% Autora: Fernanda Amaral Melo                                           %
% Contato: fernanda.amaral.melo@gmail.com                                %
%                                                                        %
% Predição do torque induzido pela estimulacao                           % 
% eletrica com base nas medidas de EMG                                   %
%                                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all; clc; %clear all; 
load data/fatigueemg_practice_trial1.mat

measuredTorque = torque;

%% torque prediction

predictedTorque = prediction(time, emgTA, emgGS, signal);

rmsError = sqrt( sum( (measuredTorque - predictedTorque) .^ 2 ) / signal.N )

%% plotting data

plot (time, measuredTorque, 'b', time, predictedTorque, 'r'); hold on
axis([0 signal.Tf -12 12])
