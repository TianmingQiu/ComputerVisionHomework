function repro_error = rueckprojektion(Korrespondenzen, P1, I2, T, R, K)
% Diese Funktion berechnet die projizierten Punkte in Kamera 2 und den
% mittleren Rueckprojektionsfehler
if size(Korrespondenzen,1)==4
    x1 = K\[Korrespondenzen(1:2,:);ones(1,size(Korrespondenzen,2))];
    x2 = K\[Korrespondenzen(3:4,:);ones(1,size(Korrespondenzen,2))];
else 
    x1 = K\Korrespondenzen(1:3,:);
    x2 = K\Korrespondenzen(4:6,:);
end


P2 = P1*R + T ; 
P2_project = P2 ./ repmat(P2(3,:),[3 1]);

diff = P2_project - x2 ;
diff = diff.^2 ; 
repro_error = sum( diff(:) ) ;


end