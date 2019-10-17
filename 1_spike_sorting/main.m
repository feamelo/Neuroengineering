%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Spike Sorting %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                        %
% Autora: Fernanda Amaral Melo                                           %
% Contato: fernanda.amaral.melo@gmail.com                                %
%                                                                        %
% Detecção de spikes                                                     %
%                                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% before everything
close all; clear all; clc;

%% loading data
%load data/spikedectection_easypractice.mat; flagSpikeSorting = 0;
load data/spikedectection_hardpractice.mat; flagSpikeSorting = 0;
%load data/spikesorting_practice.mat; flagSpikeSorting = 1;

%% spike detection
if ~flagSpikeSorting
    detectedSpikes = find_peaks(time, electrodeVoltage, signal);
    
    % showing detection results
    disp(' ');
    disp('## Results');
    disp(['detectedSpikes = ', int2str(length(detectedSpikes))]);
    disp(['actualSpikes = ', int2str(length(actualSpikes))]);
    disp(' ');
end

%% spike sorting
if flagSpikeSorting
    [detectedSpikesA, detectedSpikesB] = two_channels_find_peaks(time, electrodeVoltage, signal);
end

input('Press any key to move on');

%% plot raster

Wn=[700;3000]*2/signal.fs; %cutoff frequency 700 ~ 4000 300~3000
n=50; %filter order
b = fir1(n,Wn,'bandpass');
y=filtfilt(b,1,electrodeVoltage); %Filtro FIR causal

figure; % Setting color of lines
set(gca, 'ColorOrder', [0 0 0.8 ; 0.8 0 0; 0 0.8 0], 'NextPlot', 'replacechildren');
plot(time, y); hold on;

if flagSpikeSorting
    raster_plot(time, electrodeVoltage, detectedSpikesA, signal);
    hold on 
    raster_plot(time, electrodeVoltage, detectedSpikesB, signal);
    legend ('Signal','Neuron A','Neuron B');
else
    raster_plot(time, electrodeVoltage, detectedSpikes, signal);
end
title ('Spikes detected'); xlabel('time(s)'); ylabel('Voltage (V)');

input('Press any key to move on');

%% plot individual spike

figure; 

if flagSpikeSorting
    
    % Setting color of lines
    color_order=zeros(length(detectedSpikesA)+length(detectedSpikesB),3);
    colorA=[0 0.8 0];
    colorB=[0.8 0 0];

    for i=1:length(detectedSpikesA)+length(detectedSpikesB)
        if (i<=length(detectedSpikesA))
            color_order(i,:)=colorA;
        else
            color_order(i,:)=colorB;
        end
    end
    
    set(gca, 'ColorOrder', color_order, 'NextPlot', 'replacechildren');
    
   % plotting individual spike
   shape_plot(time, electrodeVoltage, detectedSpikesA, signal); 
   hold on;
   shape_plot(time, electrodeVoltage, detectedSpikesB, signal);
   
else
   % Setting color of lines
   color_order=zeros(length(detectedSpikes),3);
   color_order(1,:)=0; color_order(2,:)=0; color_order(3,:)=1;
   set(gca, 'ColorOrder', color_order, 'NextPlot', 'replacechildren');
    
   % plotting individual spike
   shape_plot(time, electrodeVoltage, detectedSpikes, signal); 
end

title ('Spikes waveform'); xlabel('time(s)'); ylabel('Voltage (V)');

%% the end