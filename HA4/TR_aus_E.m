function [T1,R1,T2,R2] = TR_aus_E(E)
% In dieser Funktion sollen die moeglichen euklidischen Transformationen
% aus der Essentiellen Matrix extrahiert werden
[U,S,V] = svd(E) ;

if det(U) < 0
	U = U*diag([1 1 -1]);
end
if det(V) < 0
	V = V*diag([1 1 -1]);
end

R_z_pos = [ 0 -1 0 ; 1 0 0 ; 0 0 1 ] ;
R_z_neg = [ 0  1 0 ;-1 0 0 ; 0 0 1 ] ;

T1_dach = U*R_z_pos*S*U';
T1 = [ T1_dach(3,2) ; T1_dach(1,3) ; T1_dach(2,1) ];
R1 = U*R_z_pos'*V'; 

T2_dach = U*R_z_neg*S*U';
T2 = [ T2_dach(3,2) ; T2_dach(1,3) ; T2_dach(2,1) ];
R2 = U*R_z_neg'*V';

end