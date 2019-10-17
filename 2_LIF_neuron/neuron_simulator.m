%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Neuron Simulator %%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                        %
% Autora: Fernanda Amaral Melo                                           %
% Contato: fernanda.amaral.melo@gmail.com                                %
%                                                                        %
% Função para simular os disparos do neuronio LIF                        %
% Parametros:                                                            %
% - time: vetor de tempo                                                 %
% - inputCurrent: corrente de entrada (aplicação de ruído gaussiano)     %
% - signal: struct contendo os dados do sinal                            %
%           - Ts: Período de amostragem                                  %
%           - Fs: Frequência de amostragem                               %
%           - N: Número de samples                                       %
%           - Tf: Tempo total (duração dos dados)                        %
%                                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function vMembrane = neuron_simulator(time, inputCurrent, signal)

%% basic parameters
vSpike = 40e-3; % [V]
vRest = -70e-3; % [V]
vThreshold = -50e-3; % [V]
RMembrane = 1e3; % [ohm]
CMembrane = 20e-6; % [F]
tauMembrane = RMembrane * CMembrane; % time constant [s]
tauRefractory = 4e-3; % refractory period [s]

%% output variable
vMembrane = zeros(1, signal.N);
vMembrane(1)=vRest;

%% your LIF simulation code here
n_spikes=0;

for k = 1:signal.N-2
    aux = vRest + inputCurrent(k) * RMembrane; 
    vMembrane(k+1) = aux + (vMembrane(k) - aux) * exp(-signal.Ts/tauMembrane); 
    
    if (vMembrane(k+1) > vThreshold) %cell spiked
        if (n_spikes==0)
            vMembrane(k) = vSpike;  
            vMembrane(k+1) = vRest; %set voltage back to VRest
            t_spike=time(k);
        else
            if (time(k)>=t_spike+tauRefractory)
                vMembrane(k) = vSpike;  
                vMembrane(k+1) = vRest; %set voltage back to VRest
                t_spike=time(k);
            end
        end
    end   
end
