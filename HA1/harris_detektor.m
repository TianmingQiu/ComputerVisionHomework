function  Merkmale = harris_detektor(Image) 
% In dieser Funktion soll der Harris-Detektor implementiert werden, der
% Merkmalspunkte aus dem Bild extrahiert

[m n] = size(Image);

%% handle with the borders
% copy pixels at the borders
I = zeros(m+2,n+2);
I(2:end-1, 2:end-1) = Image;
I(1,:) = I(2,:);
I(end,:) = I(end-1,:);
I(:,1) = I(:,2);
I(:,end) = I(:, end-1);
[Ix,Iy] = sobel_xy(Image);

%set the value of parameters
k = 0.05;
tau = 9e7;

w=fspecial('gaussian',3,3);
Ixx=conv2(Ix.*Ix,w,'same');
Ixy=conv2(Ix.*Iy,w,'same');
Iyy=conv2(Iy.*Iy,w,'same');

size(Ixx)

H = (Ixx .* Iyy - Ixy.^2) - k * (Ixx + Iyy).^2;

[Merkmale(:,1), Merkmale(:,2)] = find(H > tau); 

imshow(Image);
hold on;
plot(Merkmale(:,2), Merkmale(:,1),'g+');

   
end