function [Gray_image] = rgb_to_gray(Image)
% Diese Funktion soll ein RGB-Bild in ein Graustufenbild umwandeln. Falls
% das Bild bereits in Graustufen vorliegt, soll es direkt zur?ckgegeben werden.


if (numel(size(Image)) > 2 ) 
    Gray_image = 0.299 * Image(:,:,1) + 0.587 * Image(:,:,2) + 0.114 * Image(:,:,3);
else
    Gray_image = Image ;
end;
end
