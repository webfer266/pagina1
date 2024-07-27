clear all
clc
    %% Creacion imageDataStore
    folderPath = fullfile('C:\Users\Wilian Sevilla\Desktop\clasificación neumonía\Curated X-Ray Dataset');
    imds = imageDatastore(folderPath, 'LabelSource', 'foldernames', 'IncludeSubfolders', true);
    targetSize = [90 90  3]; % Tamaño objetivo de las imágenes
    imdsResized = augmentedImageDatastore(targetSize, imds, 'ColorPreprocessing', 'gray2rgb');
    
    %% impresión de las imagenes a trabajar 
    figure(1)
    montage(imdsResized.Files(1:50:end))
    %% preaparación del set de entrenamiento y de validación (t:80%) y
    [trainingSet, validationSet] = splitEachLabel(imds, 0.8, 'randomize');
    
    %% Obtener el número de clases
    tbl = countEachLabel(trainingSet);
    numClasses = numel(tbl.Label);
    
    %% Crear y entrenar una red neuronal convolucional (CNN)
    layers = [ %variable que será una lista de capas que formaran la arquitectura de la red neuronal
        imageInputLayer(targetSize) % Ajustar el tamaño de entrada según tus imágene
        convolution2dLayer(4, 3, 'Padding', 'same')% Aquí se agrega una capa convolucional 2D con 4 filtros y un tamaño de kernel de 3x3
        reluLayer()%Se agrega una capa de activación ReLU (Rectified Linear Unit) después de la capa convolucional. Esta capa introduce no linealidad en la red
        maxPooling2dLayer(2, 'Stride', 2)%Agrega una capa de max-pooling 2D con un tamaño de ventana de 2x2 y un paso (stride) de 2. 
                                            % Esto reduce la resolución espacial de lasalida de la capa anterior y ayuda a reducir el número de parámetros.  
        convolution2dLayer(8, 3, 'Padding', 'same')
        reluLayer()
        maxPooling2dLayer(2, 'Stride', 2)    
        convolution2dLayer(32, 3, 'Padding', 'same')
        reluLayer()
        maxPooling2dLayer(2, 'Stride', 2)
        convolution2dLayer(64, 3, 'Padding', 'same')
        reluLayer()
        maxPooling2dLayer(2, 'Stride', 2)
        convolution2dLayer(128, 3, 'Padding', 'same')
        reluLayer()
        maxPooling2dLayer(2, 'Stride', 2)
        fullyConnectedLayer(64)
        reluLayer()
        fullyConnectedLayer(numClasses) % Ajustar numClasses según la cantidad de clases en tu conjunto de datos
        softmaxLayer()
        classificationLayer()%Agrega la capa de clasificación final que se utiliza para calcular la pérdida y la precisión durante el entrenamiento.
        ];
    
    %options contiene las opciones de entrenamiento para la red. 
    options = trainingOptions('adam','Plots','training-progress','MaxEpochs', 7,'MiniBatchSize', 32,'ValidationData',validationSet,'ValidationFrequency',150,'Verbose', true); % Ajustar el número de épocas según tus necesidades
    %% red neuronal
    net = trainNetwork(trainingSet, layers, options);
    %% Eevaluacion del conjunto de datos de entrenamiento
    predictedLabelsTrain = classify(net, trainingSet);
    accuracyTrain = mean(predictedLabelsTrain == trainingSet.Labels);
    fprintf('Average accuracy on the training set: %.2f%%\n', accuracyTrain * 100);
    
    %% Evaluar el rendimiento del clasificador en el conjunto de validación
    predictedLabelsVal = classify(net, validationSet);
    accuracyVal = mean(predictedLabelsVal == validationSet.Labels);
    fprintf('Average accuracy on the validation set: %.2f%%\n', accuracyVal * 100);
    
    %% generar matriz de confucion 
    confusionMat = confusionmat(validationSet.Labels, predictedLabelsVal);
    disp('Matriz de confusion:');
    disp(confusionMat);
    %% Guardar el clasificador de imágenes
    img = imread('validacion\Pneumonia-Viral\Pneumonia-Viral (3).jpg');
    [label, score] = classify(net, img);
    predictedLabel = label;
    
    % Display the prediction result
    fprintf('Predicted label: %s\n', predictedLabel);
    figure(2)
    imshow(img)
    
    %% SAVE
    save('cl3asificador_imagenes4_efectivdad_82,56_todas.mat', 'net');