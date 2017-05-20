
function   Merkmale = harris_detektor_advanced(Image,varargin) 
% In dieser Funktion soll der Harris-Detektor implementiert werden, der
% Merkmalspunkte aus dem Bild extrahiert
    flag = 0 ; 

    if (varargin{1} == 'do_plot')
        if (varargin{2} == true)
            flag = 1 ;
        elseif (varargin{2} == false)
            flag = 0 ;
        end;
    end;


    global segment_length;
    global k;
    global tau;
    global min_dist; %minimum distance between two feature  point
    global N; % maximum number of feature point in one tile
    global length_blk ;  
    global height_blk ;
  
    
    
    if (nargin == 3)
        segment_length = 3 ;
        k = 0.05 ;
        tau = 9e5 ;
        min_dist = 20 ;
        N = 5 ;
        length_blk = 200 ;
        height_blk = 200 ;
        
    else
        segment_length = varargin{3} ;
        k = varargin{4} ;
        tau = varargin{5} ;
        min_dist = varargin{6} ;
        N = varargin{7} ;
        if (nargin == 9)
            length_blk = varargin{8} ;
            height_blk = varargin{8} ;
        elseif (nargin == 10)
            length_blk = varargin{8} ;
            height_blk = varargin{9} ;           
        end;
    end;


    [m n] = size(Image);
                   

 
    
    %% handle with the borders
    % copy pixels at the borders
    I = zeros(m+2,n+2);
    I(2:end-1, 2:end-1) = Image;
    I(1,:) = I(2,:);
    I(end,:) = I(end-1,:);
    I(:,1) = I(:,2);
    I(:,end) = I(:, end-1);
    [Ix,Iy] = sobel_xy(I);
    
    w=fspecial('gaussian',segment_length,segment_length);
    Ixx=conv2(Ix.*Ix,w,'same');
    Ixy=conv2(Ix.*Iy,w,'same');
    Iyy=conv2(Iy.*Iy,w,'same');

    
    H = (Ixx .* Iyy - Ixy.^2) - k * (Ixx + Iyy).^2;
%------------------------Addition & Delete---------------------------------
    
    H_extend = zeros( ceil(m/length_blk)*length_blk , ceil(n/height_blk)*height_blk ) ;
    H_extend(1:m,1:n) = H( 2:end-1 , 2:end-1 ) ;
    Im_feature_extract = blockproc( H_extend , [length_blk height_blk] , @feature_ext);

    [Merkmale(:,1), Merkmale(:,2)] = find(Im_feature_extract > tau );
    
    if ( flag == 1 )
        figure,
        imshow(Image);
        hold on;
        plot(Merkmale(:,2), Merkmale(:,1),'gs');
    end;

   
end

function   [B] = feature_ext(block)

    global min_dist; %minimum distance between two feature  point
    global N; % maximum number of feature point in one tile
    global length_blk ;  
    global height_blk ;

    A = block.data ;
    [length_blk , height_blk] = size(A) ;
    B = zeros(length_blk , height_blk) ;
 
    x_save = zeros(N) ;
    y_save = zeros(N) ;
 
    for i = 1 : N
    
        [Value,ind] = sort(A(:),'descend') ;
        val = Value(i) ;
        [x_save(i) , y_save(i)] = find( A(:,:) == val ,1 );
        x = [x_save(i)-min_dist , x_save(i)-round(0.707*min_dist) , x_save(i) , x_save(i)+round(0.707*min_dist) ,x_save(i)+min_dist , x_save(i)+round(0.707*min_dist) , x_save(i) , x_save(i)-round(0.707*min_dist) , x_save(i)-min_dist] ;
        y = [y_save(i) , y_save(i)+round(0.707*min_dist) , y_save(i)+min_dist , y_save(i)+round(0.707*min_dist) , y_save(i) , y_save(i)-round(0.707*min_dist) , y_save(i)-min_dist , y_save(i)-round(0.707*min_dist) , y_save(i)] ;
        mask = poly2mask( x , y ,length_blk , height_blk) ;
        mask = abs(mask-1) ;
        A = A .* mask ;
        B(x_save(i) , y_save(i)) = Value(i) ;
    
    end

end