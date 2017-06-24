function [Korrespondenzen] = punkt_korrespondenzen(I1,I2,Mpt1,Mpt2,window_length,min_corr,isplot)
% In dieser Funktion sollen die extrahierten Merkmalspunkte aus einer
% Stereo-Aufnahme mittels NCC verglichen werden um Korrespondenzpunktpaare
% zu ermitteln.
W = zeros(size(Mpt1, 2), 2);
V = zeros(size(Mpt2, 2), 2);

for i = 1 : size(Mpt1, 2)
    isNotEdge = (Mpt1(2, i) > ceil(window_length / 2)) && ...
        (Mpt1(1, i) > ceil(window_length / 2)) && ...
        (Mpt1(2, i) < size(I1, 1) - floor(window_length / 2)) && ...
        (Mpt1(2, i) < size(I1, 1) - floor(window_length / 2));
        
    
end
    
    
end
end


