%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% script utilizado pelo professor para fins de teste
%%% by Antonio P. L. Bo
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% before everything
close all; clear all; clc;

% load data
load('data/q1.mat')

n=1;
time = data(n).Time;
spikes = data(n).Neuron;
interval=0.05;

x=zeros(2,length(time)); %Variavel para guardar a velocidade desejada em x e y
for j=2:length(time)
    x(1,j-1)=data(n).CursorPos{j,1}(2); %Posicao y
    x(2,j-1)=data(n).CursorPos{j,1}(1); %Posicao x
    x(3,j-1)=(data(n).CursorPos{j,1}(2)-data(n).CursorPos{j-1,1}(2))/interval; %Vel y
    x(4,j-1)=(data(n).CursorPos{j,1}(1)-data(n).CursorPos{j-1,1}(1))/interval; %Vel x
    x(5,j-1)=1;    
end

velX = x(4,:);
velY = x(3,:);
            
%% q1a

[velX_est, velY_est] = decoder(time, spikes);

% showing results
disp(' ');
disp('## Results q1a:');
figure
subplot(211)
plot(time,velX_est,'r')
hold on
h=plot(time,velX);
set(h(1),'linewidth',2);
subplot(212)
plot(time,velY_est,'r')
hold on
h=plot(time,velY);
set(h(1),'linewidth',2);
erroX = mse(velX, velX_est)
erroY = mse(velY, velY_est)
            
%% q1b

[velX_est, velY_est, neurons] = best_channels_decoder(time, spikes);
figure

% showing results
disp(' ');
disp('## Results q1b:');
subplot(211)
plot(time,velX_est,'r')
hold on
h=plot(time,velX);
set(h(1),'linewidth',2);
subplot(212)
plot(time,velY_est,'r')
hold on
h=plot(time,velY);
set(h(1),'linewidth',2);
erroX = mse(velX, velX_est)
erroY = mse(velY, velY_est)
% neurons = reshape(neurons,1,length(neurons))
neurons_amount = length(neurons)
            
%% the end