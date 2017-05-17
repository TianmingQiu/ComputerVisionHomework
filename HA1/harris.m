close all; clear;clc;

Image=imread('lenna.jpg');  
imshow(Image);  
%img = rgb2gray(img);  
I =double(Image);  
[m n]=size(Image);  

I = zeros(m+2,n+2);
I(2:end-1, 2:end-1) = Image;
I(1,:) = I(2,:);
I(end,:) = I(end-1,:);
I(:,1) = I(:,2);
I(:,end) = I(:, end-1);

Ix=zeros(m+2,n+2);  
Iy=zeros(m+2,n+2);  
Ix(:,1:n-1) = I(:,2:n) - I(:,1:n-1);
Iy(1:m-1,:) = I(2:m,:) - I(1:m-1,:);
%figure;
%imshow(Ix,[0,1]);
%figure;
%imshow(Iy,[0,1]);

Ix2=Ix(2:m+1,2:n+1).^2;  
Iy2=Iy(2:m+1,2:n+1).^2;  
Ixy=Ix(2:m+1,2:n+1).*Iy(2:m+1,2:n+1);  

for i=1:m  
    for j=1:n  
        M=[Ix2(i,j) Ixy(i,j);Ixy(i,j) Iy2(i,j)];  
        R(i,j)=det(M)-0.06*(trace(M))^2;  
         %%%svd? 
        if R(i,j)>Rmax  
            Rmax=R(i,j);  
        end  
    end  
end


