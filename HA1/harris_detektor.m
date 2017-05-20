function   Merkmale = harris_detektor(Image,varargin) 
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
        tau = 9e7 ;
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
    [m,n] = size(Image) ;

    
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
    
    [Merkmale(:,1), Merkmale(:,2)] = find(H > tau);
    
    if ( flag == 1 )
        figure,
        imshow(Image);
        hold on;
        plot(Merkmale(:,2), Merkmale(:,1),'gs');
    end;


   
end