function   Merkmale = harris_detektor(Image,varargin) 
% In dieser Funktion soll der Harris-Detektor implementiert werden, der
% Merkmalspunkte aus dem Bild extrahiert
    
% To judge whether to display the processed image.
    flag = 0 ; 

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


    
 % Assign default argument or assign the input argument     
    if (nargin == 3)
        segment_length = 15 ;
        k = 0.05 ;
        tau = 9e7 ;
        
    else
        segment_length = varargin{3} ;
        k = varargin{4} ;
        tau = varargin{5} ;

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
    
   % Use the Gaussian distribution as weight parameter, 
   % And also use convolution to get desired G matrix
    w=fspecial('gaussian',segment_length,segment_length);
    Ixx=conv2(Ix.*Ix,w,'same');
    Ixy=conv2(Ix.*Iy,w,'same');
    Iyy=conv2(Iy.*Iy,w,'same');

    % Calculate the Harris matrix 
    H = (Ixx .* Iyy - Ixy.^2) - k * (Ixx + Iyy).^2;
    % use tau als threshold parameter to judge the ecken.
    [Merkmale(:,1), Merkmale(:,2)] = find(H > tau);
    
    %if input 'do_plot' & true then set flag = 1, which means to draw the processed image
    if ( flag == 1 )
        figure,
        imshow(Image);
        hold on;
        plot(Merkmale(:,2), Merkmale(:,1),'gs');
    end;


end