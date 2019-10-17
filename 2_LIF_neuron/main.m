%%%%%%%%%%%%%%%%%%%%%%%%%%%%% LIF Neuron %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                        %
% Autora: Fernanda Amaral Melo                                           %
% Contato: fernanda.amaral.melo@gmail.com                                %
%                                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% before evervoltageMembranething
clc; close all; clear all
applvoltageMembraneNoise = 0;

%% simulation timing

% basic properties
signal = struct;
signal.fs = 1000; % sampling frequencvoltageMembrane [Hz]
signal.Ts = 1/signal.fs; % sampling period [s]
signal.Tf = 1; % total simulation time [s]
signal.N = signal.Tf * signal.fs + 1; % total samples

% time vector
time = (0:signal.Ts:signal.Tf);

%% simulation for range of input current
for i = 1:25
    
    %% input current
    
    inputCurrent = ones(1,signal.N) * 10e-6 * i;
    standard_deviation = 30e-6;
    
    if applvoltageMembraneNoise
        noisevec = standard_deviation .* randn(size(time));
        inputCurrent = inputCurrent + noisevec;
    end
    
    %% lif simulation
    
    voltageMembrane = neuron_simulator(time, inputCurrent, signal);
    
    %% interspike histogram
    
    spikeTimes=0;
    lower_peak = 0.5 * max (voltageMembrane); %Threshold de tens�o para detec��o de picos
    min_distance = 4e-3; %Menor distancia temporal entre picos

    j=1;
    for k=2:signal.N-1
       if (voltageMembrane(k) >= voltageMembrane(k-1) && voltageMembrane(k) >= voltageMembrane(k+1)) %Se for maior do que seus vizinhos
          if ( voltageMembrane(k) >= lower_peak && j>1) %Limite Inferior (volts)
            if (time(k) - spikeTimes(j-1) > min_distance) % Menor distancia entre os picos (segundos)
                peak(j)=voltageMembrane(k);
                spikeTimes(j)=time(k);
                j=j+1;
            elseif (time(k) - spikeTimes(j-1) < min_distance && voltageMembrane(k) > peak(j-1)) 
                peak(j-1)=voltageMembrane(k);
                spikeTimes(j-1)=time(k);
            end

          elseif ( voltageMembrane(k) >= lower_peak && j==1) % Primeiro pico n�o precisa de verifica��o da distancia minima
            peak(j)=voltageMembrane(k);
            spikeTimes(j)=time(k);
            j=j+1;
          end
       end
    end
    
    interval=diff(spikeTimes);
    
    % plot histogram 
    figure
    hist(interval);
    ylabel('Frequency of events');
    xlabel('Interspike interval [s]');
    title(num2str(i));
    hold on;

    %% plotting
    
    figure;
    subplot(211); plot(time,voltageMembrane); title ('Tens�o na Membrana');
    xlabel('time(s)'); ylabel('Voltage (V)');
    subplot(212); plot(time,inputCurrent); title ('Corrente inserida');
    xlabel('time(s)'); ylabel('current (A)');
    
    pause(.8);
    input('Press any key to move on');

end