# Neuroengineering
Resolução da lista de exercícios da disciplina Neuroengenharia da Universidade de Brasília sob a orientação do professor Antônio Padilha.
[Este projeto foi desenvolvido em outra plataforma de controle de versionamento e exportada para o GitHub após o término da disciplina]

## 1. Detecção e classificação de spikes (spike sorting)

A partir de medições realizadas próximas a neurônios, é possível determinar o instante em que houve o disparo de potenciais de ação. Assim, em geral a primeira etapa de processamento em sistemas realizam medições desse tipo é identificar em sinais de tensão com diferentes níveis de ruído os instantes em que ocorreram tais disparos.

Primeiramente foi aplicado um filtro FIR causal com banda de 700 a 3000 Hz e janela de Hamming. Para a detecção de spikes foi feito um algoritmo que confere a cada ponto se o seu valor é maior do que o dos seus vizinhos, categorizando assim os máximos locais do vetor. Após isso foi definido um limiar mínimo de tensão como 50% do valor máximo registrado e um intervalo de tempo mínimo de 2ms para ocorrência dos spikes.

![spike_sorting](images/spike_sorting.png?raw=true)

## 2. Simulação de Neurônio LIF

Um dos modelos mais simples do neurônio capaz de representar a não-linearidade fundamental do sistema nervoso (potencial de ação), bem como algumas características dinâmicas, é o Leaky Integrate-and-Fire neuron (neurônio LIF). A parte linear que descreve a dinâmica do neurônio LIF pode ser representada por:

![lif_equation](images/lif_equation.png?raw=true)

Foi implementado um neurônio LIF com os parâmetros:

+ Vrest = -70mV
+ Vthresh = -50mV
+ Vspike = 40mV
+ Rm = 1k ohm
+ Cm = 20uF

Cada valor de Vm é comparado com Vthresh para detectar se houve o disparo do potencial de ação, caso haja, o valor Vm é substituído pela tensão de spike e a tensão é “resetada” para o valor inicial Vrest.

![lif](images/lif.png?raw=true)

## 3. Eletromiografia (EMG) e eletroencefalografia (EEG)

Foram realizadas 3 etapas de processamento. Primeiramente foi aplicado um filtro Butterworth causal com banda de 10 Hz a 400 Hz (para um sinal com frequência de amostragem menor do que 400Hz é aplicado um passa altas com fc=10 Hz). Em seguida, o sinal foi retificado e por fim foi utilizado um filtro de Média Móvel simples com janela de 250ms para obter o envoltório do sinal. Este último é responsável por uma queda na amplitude do sinal, mantendo apenas o seu formato, como pode ser conferido na figura.

![emg_preprocessing](images/emg_preprocessing.png?raw=true)

Em seguida, as faixas de frequência do EEG foram separadas utilizando uma série de filtros butterworth passa banda de 4a ordem. O resultado pode ser conferido na imagem.
Para distinguir os sinais epiléticos foi utilizado o valor RMS da faixa de frequências Beta, medindo a energia do sinal e associando valores maiores a EEGs “doentes” a partir de um limite definido empiricamente. Apesar de não ser o melhor método atual para a detecção de ataques epiléticos, a identificação por meio do valor RMS do sinal é bem tradicional, atingindo uma acurácia de 77.71%.

![eeg_freq](images/eeg_freq.png?raw=true)

## 4. Decodificação de sinais

Sinais neurais adquiridos do cérebro podem ser utilizados para se estimar comandos de direção de movimento em Interfaces Cérebro-Máquina. Os dados utilizados nesse exercício referem-se a experimentos em que sinais referentes à atividade de neurônios individuais de primatas não-humanos foram gravados enquanto o indivíduo realizava tarefas de posicionamento de cursor em plano XY.

O algoritmo utilizado foi baseado no filtro de Kalman básico citado no artigo “A High- Performance Neural Prosthesis Enabled by Control Algorithm Design”, que cria um sistema de predição da velocidade do cursor baseado no Firing rate, sendo um método usual para a decodificação neural. O filtro de Kalman modela o sistema como uma relação dinâmica linear entre o estado cinemático do cursor e as observações neurais, de acordo com a equação 1:

![eq2](images/eq2.png?raw=true)

Onde xt = [Posy, Posx, Vely, Velx, 1] é o vetor de estados , contendo a informação a ser decodificada e yt é o vetor que contem a informação neural (Numero de spikes ocorridos
entre +-0.05s de cada frame em cada canal). O problema se resume em encontrar as matrizes A (Matriz de estado), C (Matriz de saída), W e Q (erro) que relacionem a entrada e saída do sistema, que podem ser descritas da seguinte forma:

![eq3](images/eq3.png?raw=true)

As matrizes foram calculadas usando as 100 primeiras amostras como training dataset, após isso, o xt do testing dataset (ultimas 50 amostras) pode ser descoberto resolvendo a equação yt = C xt+ qt para cada tempo t. A figura ilustra o resultado encontrado para a velocidade estimada e medida de uma amostra, apesar do ruído de alta frequência, é possível notar que o formato da onda esperada é mantido.
Em seguida, os 10 melhores canais selecionados foram escolhidos de acordo com a sua contribuição para o vetor estimado, na prática, foram selecionados os canais que possuíam maior valor absoluto na matriz de saída C. Foi observado que a predição é melhor utilizando todos os 196 canais disponíveis quando comparada com o filtro de 10 canais.

![4_results](images/4_results.png?raw=true)

## 5. Estimação de torque e fadiga induzida por FES

Nesse conjunto de experimentos, cujos dados foram fornecidos pela Prof. Qin Zhang, indivíduos paraplégicos receberam estimulação elétrica funcional (FES) no músculo Tibialis anterior, enquanto as seguintes variáveis eram adquiridas: torque no tornozelo em contração isométrica e eletromiografia (EMG) nos músculos Tibialis anterior e Gastrocnemius. O objetivo do exercício é criar algoritmos que forneçam estimativas do torque a partir dos sinais de EMG. Tais estimativas devem ser capazes de prever a evolução da fadiga, i.e., diminuição do torque gerado por meio de um sinal de mesma amplitude.

Primeiramente é aplicado um filtro FIR causal com banda de 700 a 3000 Hz e janela de Hamming. Após a filtragem dos dois sinais disponíveis (emgGS, emgTA), é feita uma média simples entre eles e o sinal final é normalizado. Por fim, o torque desejado é relacionado com o sinal de emg através de uma regressão com um polinômio de grau 2. O resultado pode ser visto na figura abaixo:

![5_results](images/5_results.png?raw=true)
