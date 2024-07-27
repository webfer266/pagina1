%% Crear directorio para almacenar los planos de imágenes
folderPath = fullfile('Curated X-Ray Dataset redimensionada/', 'Curated X-Ray Dataset');
imds = imageDatastore(folderPath, 'LabelSource', 'foldernames', 'IncludeSubfolders', true);
num_archivos = length(imds.Files);
carpeta_redimensionada = '\Curated X-Ray Dataset redimensionada\Curated X-Ray Dataset';

%%
% (asegurarse de que todas las imágenes tengan las mismas dimensiones)
for i = 1:num_archivos
    imagen_original = readimage(imds, i);
    imagen_redimensionada = imresize(imagen_original, [90, 90]);
    imds.Files{i} = fullfile(imds.Files{i});
    redPlane = imagen_redimensionada(:, :, 1);
    imwrite(redPlane, imds.Files{i});
end
