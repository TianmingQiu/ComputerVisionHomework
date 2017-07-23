function repro_error = rueckprojektion(Korrespondenzen, P1, I2, T, R, K)
% Diese Funktion berechnet die projizierten Punkte in Kamera 2 und den
% mittleren Rueckprojektionsfehler
N = size(Korrespondenzen,2);

P2 = R * P1 + T ; 
%P2_project = K* P2 ./ repmat(P2(3,:),[3 1]);

P2_project = K* (P2 ./ P2(3,:));

diff = P2_project(1:2,:) - Korrespondenzen(3:4,:) ;
diff = sqrt(diff(1,:).^2 + diff(2,:).^2) ; 
repro_error = 0;
repro_error=sum( diff(:) ) /size(Korrespondenzen,2);

imshow(I2);title('Reprojection')
for i = 1:N;
    hold on;
    % Punkte im zweiten Bild
    plot(Korrespondenzen(3,i), Korrespondenzen(4,i), 'g*');
    text(Korrespondenzen(3,i), Korrespondenzen(4,i), num2str(i)); 
    % Rückprojezierte 3-D-Punkte aus Bild1 in Bild2
    plot(P2_project(1,i), P2_project(2,i), 'r*');
    text(P2_project(1,i), P2_project(2,i), num2str(i));
    line([Korrespondenzen(3,i),P2_project(1,i)],[Korrespondenzen(4,i),P2_project(2,i)]);
   

end




end