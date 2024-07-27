clear all;
clc;
%cargar imagen
%a=imread("rgb.png");
a=imread("descarga.jpeg");
s=size(a);%tmano de la imagen

%extraccion de planos
ar=a(:,:,1);
ag=a(:,:,2);
ab=a(:,:,3);

%despliegue de planos
figure(1), subplot(3,3,2),imshow(a),title("imagen original")%imagen original
figure(1), subplot(3,3,4),imshow(ar),title("plano rojo")%plano rojo
figure(1), subplot(3,3,5),imshow(ag),title("plano verde")%plano verde
figure(1), subplot(3,3,6),imshow(ab),title("plano azul")%plano azul

%obtencion de hisograma 2D

hisot12DR=zeros(256);


for f=1:s(1)
    for c=1:s(2)
        ngF=ag(f,c);
        ngC=ab(f,c);
        hisot12DR(ngF+1,ngC+1)=hisot12DR(ngF+1,ngC+1)+1;
    end
end

%visualizacion del histograma 2D

%figure(2), imshow(hisot12DR,[])

%si son muy pequeños
figure(2), imshow(log(hisot12DR+1),[])



