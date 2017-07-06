function [Korrespondenzen_robust] = F_ransac(Korrespondenzen,varargin)
% Diese Funktion implementiert den RANSAC-Algorithmus zur Bestimmung von
% robusten Korrespondenzpunktpaaren

k = 8 ; % essential number of parameters

IN = inputParser;
IN.addOptional('p', 0.999, @(x)isnumeric(x) && x > 0 && x < 1)
IN.addOptional('epsilon', 0.5, @(x)isnumeric(x) && x > 0 && x < 1);
IN.addOptional('tolerance', 0.01, @isnumeric);
IN.parse(varargin{:});
p           = IN.Results.p;
epsilon     = IN.Results.epsilon;
tolerance   = IN.Results.tolerance;

% get iteration times
s = ceil( log( 1-p )/log( 1-(1-epsilon).^k ) ) ;

% turn into homogene coordinates
if size(Korrespondenzen,1)==4
    KP_3D  = ones(6,size(Korrespondenzen,2));
    KP_3D(1:2,:) = Korrespondenzen (1:2,:);
    KP_3D(4:5,:) = Korrespondenzen (3:4,:);
else
    KP_3D = Korrespondenzen ;
end

% e3^hat 
e3 = [ 0 -1 0 ; 1 0 0 ; 0 0 0] ;
x1 = KP_3D(1:3,:);
x2 = KP_3D(4:6,:);
Loc_lib = cell(1,s) ;
num_menge = zeros(1,s) ;
sum_menge = zeros(1,s) ;
max_num = 0;
min_sum_dist = Inf;
for i = 1 : s
    
    label = randperm(size(Korrespondenzen,2),k) ;
    KP_in = KP_3D(:,label) ;
    save('KP_in.mat','KP_in');
    
    [F] = achtpunktalgorithmus(KP_in) ;
    
    de = (diag(x2'*F*x1)).^2 ;
    nom = diag( (e3*F*x1)' * (e3*F*x1) ) + diag( (e3*F'*x2)' * (e3*F'*x2) );
    de = de ./ nom ; %Sampson distance
    
    menge = (de < tolerance) ;
    [ V , ~ ] = find ( menge==1 ) ;
    Loc_lib{i} = V ;
    num_menge(i) = sum(menge) ;
    sum_menge(i) = sum(V);
    
    % find the max number in tollerace distance
    % if the number is same, then find the min distance sum
    if ((num_menge(i) > max_num) || ((num_menge(i) == max_num) && (sum_menge(i) < min_sum_dist)))
        max_num = num_menge(i);
        min_sum_dist = sum_menge(i);
        Location = i;
    end
    
    
end


Final_label = Loc_lib{Location} ;
Korrespondenzen_robust = [KP_3D(1:2,Final_label) ;KP_3D(4:5,Final_label)] ;



end