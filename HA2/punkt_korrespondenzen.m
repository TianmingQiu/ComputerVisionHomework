function [Korrespondenzen] = punkt_korrespondenzen(I1,I2,Mpt1,Mpt2,varargin)
% In dieser Funktion sollen die extrahierten Merkmalspunkte aus einer
% Stereo-Aufnahme mittels NCC verglichen werden um Korrespondenzpunktpaare
% zu ermitteln.

IN = inputParser;
IN.addOptional('window_length', 25, @isnumeric)
IN.addOptional('min_corr', 0.95, @(x)isnumeric(x) && x > 0 && x < 1);
IN.addOptional('do_plot', false, @islogical);
IN.parse(varargin{:});
window_length   = IN.Results.window_length;
min_corr        = IN.Results.min_corr;
do_plot         = IN.Results.do_plot;

win_range = -floor(window_length/2):floor(window_length/2) ;

%% Remove the feature points near edges
[I1_row , I1_col] = size(I1) ;
Index_delete = (( Mpt1(1,:) > floor(window_length/2)+1 )) & (( Mpt1(1,:) < I1_col-floor(window_length/2) ) ) ...
    & (( Mpt1(2,:) > floor(window_length/2)+1  )) & (( Mpt1(2,:) < I1_row-floor(window_length/2) )) ;
Mpt1(:, (Index_delete==0) ) = [] ;

[I2_row , I2_col] = size(I1) ;
Index_delete = (( Mpt2(1,:) > floor(window_length/2)+1 )) & (( Mpt2(1,:) < I2_col-floor(window_length/2) ) ) ...
    & (( Mpt2(2,:) > floor(window_length/2)+1  )) & (( Mpt2(2,:) < I2_row-floor(window_length/2) )) ;
Mpt2(:, (Index_delete==0) ) = [] ;

x1 = Mpt1(1,:) ;
y1 = Mpt1(2,:) ;
x2 = Mpt2(1,:) ;
y2 = Mpt2(2,:) ;

len1 = size(Mpt1,2) ;
len2 = size(Mpt2,2) ;
Merkmale_1_mat = zeros(len1,window_length.^2) ;
Merkmale_2_mat = zeros(len2,window_length.^2) ;

%% Calculate normalized image segment A_s, B_s as vector:
for i = 1 : len1
    % get the segment from whole image
    Merkmale_1_extend = I1( y1(i) + win_range , x1(i) + win_range)  ;
    seg_vec = double(Merkmale_1_extend(:)) ;
    % substract mean and divide by standard error to get normalized image segment
    Merkmale_1_mat(i,:) =  ( seg_vec - mean(seg_vec) )/std(seg_vec);   
end
for i = 1 : len2   
    Merkmale_2_extend = I2( y2(i) + win_range , x2(i) + win_range)  ;
    seg_vec = double(Merkmale_2_extend(:)) ;
    Merkmale_2_mat(i,:) =  ( seg_vec - mean(seg_vec) )/std(seg_vec);   
end

%% Calculate NCC, and find the strong correspondences
Merkmal = Merkmale_1_mat*Merkmale_2_mat'/( window_length.^2-1 ) ;
Merkmal( Merkmal < min_corr) = 0 ; % remove points that ncc < 0.95

[Match_len1 ,Match_len2] = find(Merkmal~=0) ;
[b, m]= unique(Match_len1) ; % remove the repeated corresponding points from Image 1

% get the corresponding pairs coordinates
Korrespondenzen(1,:) = Mpt1(1,Match_len1(m)) ;
Korrespondenzen(2,:) = Mpt1(2,Match_len1(m)) ;
Korrespondenzen(3,:) = Mpt2(1,Match_len2(m)) ;
Korrespondenzen(4,:) = Mpt2(2,Match_len2(m)) ;

%% Draw the corresponding pairs
if do_plot == 1
    figure();
    title('Corresponding Pairs');
    imshow(I1)
    hold on
    plot(Korrespondenzen(1,:),Korrespondenzen(2,:),'r*')
    imshow(I2)
    alpha(0.5);
    hold on
    plot(Korrespondenzen(3,:),Korrespondenzen(4,:),'g*')
    for i=1:size(Korrespondenzen,2)
        hold on
        x_1 = [Korrespondenzen(1,i), Korrespondenzen(3,i)];
        x_2 = [Korrespondenzen(2,i), Korrespondenzen(4,i)];
        line(x_1,x_2);
        hold on;
    text(Korrespondenzen(1,i), Korrespondenzen(2,i),num2str(i));
    hold on;
    text(Korrespondenzen(3,i), Korrespondenzen(4,i),num2str(i));
    end
    
    hold off
end
end