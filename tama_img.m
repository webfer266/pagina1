%%tamano imagenes
% Carpeta raíz que contiene todas las subcarpetas con imágenes
folderPath = 'C:\Users\Wilian Sevilla\Downloads\base de datos\Skin cancer ISIC The International Skin Imaging Collaboration - copia';

% Crear el imageDatastore
imds = imageDatastore(folderPath, 'IncludeSubfolders', true, 'LabelSource', 'foldernames');

% Tamaño deseado para las imágenes
nuevoTamano = [150, 150];  % Por ejemplo, 256x256 píxeles

% Recorrer todas las imágenes en el imageDatastore
numImagenes = numel(imds.Files);
for i = 1:numImagenes
    % Leer la imagen actual
    imagen = readimage(imds, i);
    
    % Cambiar el tamaño de la imagen
    imagenRedimensionada = imresize(imagen, nuevoTamano);
    
    % Guardar la imagen redimensionada de nuevo en el imageDatastore
    imds.Files{i} = fullfile(imds.Files{i});
    imwrite(imagenRedimensionada, imds.Files{i});
end