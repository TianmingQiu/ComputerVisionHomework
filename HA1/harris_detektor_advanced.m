
function   [Merkmale,H] = harris_detektor_advanced(Image,varargin) 
% In dieser Funktion soll der Harris-Detektor implementiert werden, der
% Merkmalspunkte aus dem Bild extrahiert
    flag = 0 ; 

    if (varargin{1} == 'do_plot')
        flag = 1 ;
    end;


    [m n] = size(Image);
    segment_length = 3 ;
    
    %% handle with the borders
    % copy pixels at the borders
    I = zeros(m+2,n+2);
    I(2:end-1, 2:end-1) = Image;
    I(1,:) = I(2,:);
    I(end,:) = I(end-1,:);
    I(:,1) = I(:,2);
    I(:,end) = I(:, end-1);
    [Ix,Iy] = sobel_xy(I);
    
    %set the value of parameters
    k = 0.05;
    
    
    w=fspecial('gaussian',segment_length,segment_length);
    Ixx=conv2(Ix.*Ix,w,'same');
    Ixy=conv2(Ix.*Iy,w,'same');
    Iyy=conv2(Iy.*Iy,w,'same');
    
    size(Ixx)
    
    H = (Ixx .* Iyy - Ixy.^2) - k * (Ixx + Iyy).^2;
%------------------------Addition & Delete---------------------------------
    tau = 1e6;
    
    global min_dist; %minimum distance between two feature  point
    min_dist = 10;
    global N; % maximum number of feature point in one tile
    N = 10 ;    
    global length_blk ;
    length_blk = 200;
    global height_blk ;
    height_blk = 200;

    H_extend = zeros( ceil(m/length_blk)*length_blk , ceil(n/height_blk)*height_blk ) ;
    H_extend(1:m,1:n) = H( 2:end-1 , 2:end-1 ) ;
    Im_feature_extract = blockproc( H_extend , [length_blk height_blk] , @feature_ext);

    [Merkmale(:,1), Merkmale(:,2)] = find(Im_feature_extract > tau );
    
    if ( flag == 1 )
        imshow(Image);
        hold on;
        plot(Merkmale(:,2), Merkmale(:,1),'g+');
    end;
    figure,imshow(H)

   
end

function   [B] = feature_ext(block)


A = block.data ;
[length_blk , height_blk] = size(A) ;
B = zeros(length_blk , height_blk) ;
N = 5 ;
x_save = zeros(N) ;
y_save = zeros(N) ;
min_dist = 20 ;
for i = 1 : N
    
    [Value,ind] = sort(A(:),'descend') ;
    val = Value(i) ;
    [x_save(i) , y_save(i)] = find( A(:,:) == val ,1 );
    x = [x_save(i)-min_dist , x_save(i) , x_save(i)+min_dist , x_save(i)] ;
    y = [y_save(i) , y_save(i) + min_dist , y_save(i) , y_save(i)-min_dist] ;
    mask = poly2mask( x , y ,length_blk , height_blk) ;
    mask = abs(mask-1) ;
    A = A .* mask ;
    B(x_save(i) , y_save(i)) = Value(i) ;
   
end;




end