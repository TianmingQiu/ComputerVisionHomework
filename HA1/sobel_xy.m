function [Fx,Fy] = sobel_xy(Image)
% In dieser Funktion soll das Sobel-Filter implementiert werden, welches
% ein Graustufenbild einliest und den Bildgradienten in x- sowie in
% y-Richtung zurückgibt.

I = Image;
%define the sobel mask
sobel_x = [1 0 -1; 2 0 -2; 1 0 -1];
sobel_y = [1 2 1; 0 0 0; -1 -2 -1];

%suppose add zeros at the borders
[m n] = size(I);
Im_in = zeros(m+2,n+2);
Im_out = Im_in;
Im_in(2:end-1,2:end-1) = I;

for i = 2:m-1
    for j = 2:n-1
        for k = -1:1
            for l = -1:1
                Im_out(i,j) = Im_out(i,j) + Im_in(i+k,j+l) * sobel_x(2-k,2-l);
            end
        end
    end
end

Fx = Im_out(2:end,2:end);

Im_out = 0*Im_out;

for i = 2:m-1
    for j = 2:n-1
        for k = -1:1
            for l = -1:1
                Im_out(i,j) = Im_out(i,j) + Im_in(i+k,j+l) * sobel_y(2-k,2-l);
            end
        end
    end
end
Fy = Im_out(2:end,2:end);
end

