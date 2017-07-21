function [T,R, lambdas, P1] = rekonstruktion(T1,T2,R1,R2, Korrespondenzen, K)
% Funktion zur Bestimmung der korrekten euklidischen Transformation, der
% Tiefeninformation und der 3D Punkte der Merkmalspunkte in Bild 1
if size(Korrespondenzen,1)==4
    x1 = K\[Korrespondenzen(1:2,:);ones(1,size(Korrespondenzen,2))];
    x2 = K\[Korrespondenzen(3:4,:);ones(1,size(Korrespondenzen,2))];
else 
    x1 = K\Korrespondenzen(1:3,:);
    x2 = K\Korrespondenzen(4:6,:);
end

[d1,n1] = depth(T1,R1,x1,x2) ;
[d2,n2] = depth(T2,R2,x1,x2) ;

if n1>n2 
    d = d1; T = T1 ; R = R1 ;
else
    d = d2; T = T2 ; R = R2 ; 
end
lambdas = d(1:end-1);
a = repmat(lambdas',[3 1]) 
x1
P1 = repmat(lambdas',[3 1]) .* x1 ;

end
function [d_out,num] = depth(T,R,x1,x2)
len = size(x1,2) ;
M = zeros(3*len , len+1) ;
for i = 1:len 

    x2_dach = dach(x2(:,i)) ;
    M(3*i-2:3*i,i) = x2_dach*R*x1(:,i) ;
    M_right(3*i-2:3*i) = x2_dach*T ; 
end

M(:,end) = M_right ;
[~,~,V] = svd(M);
d = V(:,end);
d_out = d;
d(end) = [];
d = (d>0) ;
num = sum(d) ;

end
function A_dach = dach(A)
A_dach = [0 -A(3) A(2);A(3) 0 -A(1);-A(2) A(1) 0] ;
end