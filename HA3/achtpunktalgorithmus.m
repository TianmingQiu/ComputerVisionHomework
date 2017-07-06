function [EF] = achtpunktalgorithmus(Korrespondenzen,varargin)
% Diese Funktion berechnet die Essentielle Matrix oder Fundamentalmatrix
% mittels 8-Punkt-Algorithmus, je nachdem, ob die Kalibrierungsmatrix 'K'
% vorliegt oder nicht

% turn into homogene coordinates
if size(Korrespondenzen,1)==4
    KP_3D  = ones(6,size(Korrespondenzen,2));
    KP_3D(1:2,:) = Korrespondenzen (1:2,:);
    KP_3D(4:5,:) = Korrespondenzen (3:4,:);
else
    KP_3D = Korrespondenzen ;
end

% whether essential or fundamental matrix to calculate:
% depends on whether K is given
flag = nargin-1 ;
if flag == 1
    KP_3D(1:3,:) = varargin{1}\KP_3D(1:3,:);
    KP_3D(4:6,:) = varargin{1}\KP_3D(4:6,:);
end

x1 = KP_3D(1:3,:);
x2 = KP_3D(4:6,:);

% use kronecker product get coeffient matrix A
A_total = kron(x1',x2');
step = size(Korrespondenzen,2) +1;
A = A_total(1:step:end,:);
% find the minimum square by SVD
[U_A , S_A , V_A ] = svd(A) ;

G = reshape(V_A(:,end),[3 3]);
[U_G , S_G, V_G] = svd(G) ;

% use SVD to make E/F satisfying singular charakter
if flag == 1
    EF = U_G*diag([1 1 0])*V_G';
else
    S_G(3,3) = 0;
    EF = U_G*diag([S_G(1,1) S_G(2,2) 0])*V_G' ;
end


end