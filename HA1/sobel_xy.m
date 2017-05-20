function [d_Fx,d_Fy] = sobel_xy(Image)
% In dieser Funktion soll das Sobel-Filter implementiert werden, welches
% ein Graustufenbild einliest und den Bildgradienten in x- sowie in
% y-Richtung zur?ckgibt.




I = Image;
%define the sobel mask
sobel_x = [1 0 -1; 2 0 -2; 1 0 -1];
sobel_y = [1 2 1; 0 0 0; -1 -2 -1];


Fx1 = conv2(sobel_x, I ) ;
Fy1 = conv2(sobel_y, I ) ;


Fx = Fx1(2:end-1,2:end-1) ;
Fy = Fy1(2:end-1,2:end-1) ;
end

