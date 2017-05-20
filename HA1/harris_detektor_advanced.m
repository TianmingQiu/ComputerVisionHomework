function   Merkmale = harris_detektor_advanced(Image,varargin) 
% In dieser Funktion soll der Harris-Detektor implementiert werden, der
% Merkmalspunkte aus dem Bild extrahiert
    flag = 0 ; 
% To judge whether to display the processed image.
    if (varargin{1} == 'do_plot')
        if (varargin{2} == true)
            flag = 1 ;
        elseif (varargin{2} == false)
            flag = 0 ;
        end;
    end;

% Define the global parameter which will be used in the block(tile) processing function 
    global segment_length;
    global k;
    global tau;
    global min_dist; %minimum distance between two feature  point
    global N; % maximum number of feature point in one tile
    global length_blk ;  
    global height_blk ;
  
    
 % Assign default argument or assign the input argument   
    if (nargin == 3)
        segment_length = 15 ;
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
                   

 
    
    %% Border processing 
    % copy pixels at the borders
    I = zeros(m+2,n+2);
    I(2:end-1, 2:end-1) = Image;
    I(1,:) = I(2,:);
    I(end,:) = I(end-1,:);
    I(:,1) = I(:,2);
    I(:,end) = I(:, end-1);
    
    % call the sobel function to calculate the gradient matrix of image
    [Ix,Iy] = sobel_xy(I);
    
    %Use the Gaussian distribution as weight parameter 
    % And also use convolution to get desired G matrix
    w=fspecial('gaussian',segment_length,segment_length);
    Ixx=conv2(Ix.*Ix,w,'same');
    Ixy=conv2(Ix.*Iy,w,'same');
    Iyy=conv2(Iy.*Iy,w,'same');

    % Calculate the Harris matrix     
    H = (Ixx .* Iyy - Ixy.^2) - k * (Ixx + Iyy).^2;

    % Extend to the raw image into proper size (by adding zero)
    H_extend = zeros( ceil(m/length_blk)*length_blk , ceil(n/height_blk)*height_blk ) ;
    H_extend(1:m,1:n) = H( 2:end-1 , 2:end-1 ) ;
    
    % Use the blockproc() function to process the extended image (This function will divide the image into small blocks(tiles) and use the function to process them)
    Im_feature_extract = blockproc( H_extend , [length_blk height_blk] , @feature_ext);

    % Use proper threshold to filter the processed image
    [Merkmale(:,1), Merkmale(:,2)] = find(Im_feature_extract > tau );
    
    %if input 'do_plot' & true then set flag = 1, which means to draw the processed image
    if ( flag == 1 )
        figure,
        imshow(Image);
        hold on;
        plot(Merkmale(:,2), Merkmale(:,1),'gs');
    end;

   
end

% Block processing function
function   [B] = feature_ext(block)

    % Call the global parameter which have been declared in the above function
    global min_dist; %minimum distance between two feature  point
    global N; % maximum number of feature point in one tile
    global length_blk ;  
    global height_blk ;

    % Extract the image data from the block struct
    A = block.data ;
    [length_blk , height_blk] = size(A) ;
    B = zeros(length_blk , height_blk) ;
 
    % The initilalization of coordinate of choosen feature points
    x_save = zeros(N) ;
    y_save = zeros(N) ;
 
 
    for i = 1 : N
        
        % Sort all the feature point according to their correspongding  value with descending order
        [Value,ind] = sort(A(:),'descend') ;
        
        % Chosse the i_th large feature point as central point
        val = Value(i) ;
        
        % Locate the i_th large feature point
        [x_save(i) , y_save(i)] = find( A(:,:) == val ,1 );
        
        % Set the mask area of radius = min_dist ( Actually we use the Octagon to approximate the circle )
        x = [x_save(i)-min_dist , x_save(i)-round(0.707*min_dist) , x_save(i) , x_save(i)+round(0.707*min_dist) ,x_save(i)+min_dist , x_save(i)+round(0.707*min_dist) , x_save(i) , x_save(i)-round(0.707*min_dist) , x_save(i)-min_dist] ;
        y = [y_save(i) , y_save(i)+round(0.707*min_dist) , y_save(i)+min_dist , y_save(i)+round(0.707*min_dist) , y_save(i) , y_save(i)-round(0.707*min_dist) , y_save(i)-min_dist , y_save(i)-round(0.707*min_dist) , y_save(i)] ;
        
        % Use poly2mask function to create the maske area
        mask = poly2mask( x , y ,length_blk , height_blk) ;
        
        % Because the default generated mask area using poly2mask function is inside 1 &outside 0, we need the reverse them, which means inside 0 and outside 1
        mask = abs(mask-1) ;
        
        % Apply the mask to the blocks(tiles)
        A = A .* mask ;
        
        % Save the coordinate of i_th large feature point
        B(x_save(i) , y_save(i)) = Value(i) ;
    
    end

end