close all; clear; clc;

Image1 = imread('szeneL.jpg');
I1 = rgb_to_gray(Image1);

Image2 = imread('szeneR.jpg');
I2 = rgb_to_gray(Image2);

Mpt1 = harris_detektor(I1,'segment_length',9,'k',0.05,'min_dist',50,'N',20,'do_plot',false);
Mpt2 = harris_detektor(I2,'segment_length',9,'k',0.05,'min_dist',50,'N',20,'do_plot',false);
window_length =25;
min_corr = 0.95;
isplot = 1;

W =cell(1,1);
for i = 1 : size(Mpt1, 2)
    isNotEdge1(i) = (Mpt1(2, i) > ceil(window_length / 2)) && ...
        (Mpt1(1, i) > ceil(window_length / 2)) && ...
        (Mpt1(2, i) < size(I1, 1) - floor(window_length / 2)) && ...
        (Mpt1(1, i) < size(I1, 2) - floor(window_length / 2));
end
Mpt1 = Mpt1(:, isNotEdge1);
for i = 1 : sum(isNotEdge1)
    
   
        
        I1_win = double(I1(Mpt1(2, i) - floor(window_length / 2) : ...
            Mpt1(2, i) + floor(window_length / 2), ...
            Mpt1(1, i) - floor(window_length / 2) : ...
            Mpt1(1, i) + floor(window_length / 2)));
        W{i,1} = (I1_win-mean(I1_win(:))) / std(I1_win(:));
        
   
    
    
    
end

V =cell(1,1);
for i = 1 : size(Mpt2, 2)
    isNotEdge2(i) = (Mpt2(2, i) > ceil(window_length / 2)) && ...
        (Mpt2(1, i) > ceil(window_length / 2)) && ...
        (Mpt2(2, i) < size(I2, 1) - floor(window_length / 2)) && ...
        (Mpt2(1, i) < size(I2, 2) - floor(window_length / 2));
end
Mpt2 = Mpt2(:, isNotEdge2);
for i = 1 : sum(isNotEdge2)
    
    
        
        I2_win = double(I2(Mpt2(2, i) - floor(window_length / 2) : ...
            Mpt2(2, i) + floor(window_length / 2), ...
            Mpt2(1, i) - floor(window_length / 2) : ...
            Mpt2(1, i) + floor(window_length / 2)));
        V{i,1} = (I2_win-mean(I2_win(:))) / std(I2_win(:));
        
   
    
    
    
end

Ncc = [];
Korrespondenzen = [];
for i = 1:size(Mpt2, 2)
    for j = 1:size(Mpt1, 2)
        Ncc(i, j) = trace(W{j,1}' * V{i,1}) / (window_length .^ 2 - 1);
        
        
    end
    [NCC, idx] = max(Ncc(i, :));
    if NCC > min_corr
        Korrespondenzen = [Korrespondenzen, [Mpt1(1 : 2, idx);Mpt2(1 : 2, i)]];
        
    end
end


if isplot
    figure('name', 'Punkt-Korrespondenzen');
    imshow(uint8(I1))
    hold on
    plot(Korrespondenzen(1,:),Korrespondenzen(2,:),'r*')
    imshow(uint8(I2))
    alpha(0.5);
    hold on
    plot(Korrespondenzen(3,:),Korrespondenzen(4,:),'g*')
    for i=1:size(Korrespondenzen,2)
        hold on
        x_1 = [Korrespondenzen(1,i), Korrespondenzen(3,i)];
        x_2 = [Korrespondenzen(2,i), Korrespondenzen(4,i)];
        line(x_1,x_2);
    end
    hold off
end