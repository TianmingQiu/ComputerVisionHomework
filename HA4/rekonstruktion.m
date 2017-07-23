function [T,R, lambdas, P1] = rekonstruktion(T1,T2,R1,R2, Korrespondenzen, K)
%Funktion zur Bestimmung der korrekten euklidischen Transformation, der
%Tiefeninformation und der 3D Punkte der Merkmalspunkte in Bild 1
if size(Korrespondenzen,1)==4
    x1 = K\[Korrespondenzen(1:2,:);ones(1,size(Korrespondenzen,2))];
    x2 = K\[Korrespondenzen(3:4,:);ones(1,size(Korrespondenzen,2))];
else
    x1 = K\Korrespondenzen(1:3,:);
    x2 = K\Korrespondenzen(4:6,:);
end

% calculation for 4 posssible combinations:
RT_combine ={T1,R1;T2,R2;T1,R2;T2,R1};
for i = 1 : 4
    [d(:,:,i),n_d_pos(i)] = depth(RT_combine{i,:},x1,x2);
end

% find the max depth number:
[~,idx] = max(n_d_pos);
T = RT_combine{idx,1};
R = RT_combine{idx,2};
lambdas = d(:,:,idx);

disp('Rotation matrix = ');
disp(R);
disp('Translation vector = ');
disp(T);

P1 = repmat(lambdas(:,1)',[3 1]) .* x1;


% image show
figure();
title('Reconstruction');


hold on
for i = 1:size(x1,2)
    if P1(3,i)>0
        scatter3(P1(1,i), P1(2,i), P1(3,i), '*b');
        text(P1(1,i), P1(2,i), P1(3,i),num2str(i));
    end
end


hold off;


camSize = .2;

camC1 = [-1 1 1 -1; 1 1 -1 -1]*camSize;

camC1 = [camC1; ones(1,4)];

camC2 = R\ (camC1 - T);

cam_trace1 = camC1(:,[1:4 1]);
cam_trace2 = camC2(:,[1:4 1]);
hold on;
plot3(cam_trace1(1,:), cam_trace1(2,:), cam_trace1(3,:), 'k');
text(cam_trace1(1,4), cam_trace1(2,4), cam_trace1(3,4), '1');
plot3(cam_trace2(1,:), cam_trace2(2,:), cam_trace2(3,:), 'r');
text(cam_trace2(1,4), cam_trace2(2,4), cam_trace2(3,4), '2', 'Color', 'r');

axis equal;xlabel('x'); ylabel('y'); zlabel('z');
hold off;

% tune angular in order to show the pic more clear:
campos([40, -20, -90]);
camup([-0.09, -0.9, 0.2]);
camva(3.2)



end

% calculate depth for give R,T combination pair
function [d_out,num] = depth(T,R,x1,x2)
len = size(x1,2);
M1 = zeros(3*len , len+1);
M2 = zeros(3*len , len+1);
for i = 1:len
    
    x2_dach = dach(x2(:,i)) ;
    M1(3*i-2:3*i,i) = x2_dach*R*x1(:,i) ;
    M1(3*i-2:3*i,len+1) = x2_dach*T ;
    
    
    M2(3*i-2:3*i,i) = dach(R * x1(:,i)) * x2(:,i);
    M2(3*i-2:3*i,len+1) = -dach(R * x1(:,i))*T;
end


[~,~,V1] = svd(M1);
d = V1(:,end);
d = d ./ d(end);
d(end) = [];
d_out(:,1) = d;

[~,~,V2] = svd(M2);
d = V2(:,end);
d = d ./ d(end);
d(end) = [];
d_out(:,2) = d;

d_pos = (d_out > 0);
num = sum(d_pos(:));

end

% calculate for x_dach
function A_dach = dach(A)
A_dach = [0 -A(3) A(2);A(3) 0 -A(1);-A(2) A(1) 0] ;
end