function  Merkmale = harris_detektor(Image,varargin) 
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

%%
k = 0.05;
tau = 50;
for xx = 2 : m-1 %this border should be considered again
    for yy = 2 : n-1
        for k = 1 : 3
            for l = 1 : 3
                i = xx - (3 + 1)/2 + k;
                j = yy - (3 + 1)/2 + l;
                Harris_matrix = [(I(i+1,j)-I(i,j))^2, (I(i+1,j)-I(i,j))*(I(i,j+1)-I(i,j));
                    (I(i+1,j)-I(i,j))*(I(i,j+1)-I(i,j)),(I(i,j+1)-I(i,j))^2 ];
                [U,S,V] = svd(Harris_matrix);
                H = det(U) - k * trace(U);
                if H > tau
                    Merkmale = [Merkmale;xx, yy];
                end
            end
        end
    end
end

end