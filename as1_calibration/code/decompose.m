%% !!! DO NOT CHANGE THE FUNCTION INTERFACE, OTHERWISE, YOU MAY GET 0 POINT !!! %%

function [K, R, t] = decompose(P)
%Decompose P into K, R and t using QR decomposition

% TODO Compute R, K with QR decomposition such M=K*R 
M = P(1:3,1:3);
[Q_,R_] = qr(inv(M));
R = inv(Q_);
K = inv(R_);
scale = K(3,3);
% TODO Compute camera center C=(cx,cy,cz) such P*C=0 
[U_,S_,V_] = svd(P);
C = V_(:,end);
C = C/C(4);
C = C(1:3);

% TODO normalize K such K(3,3)=1
K = K / scale;
% R = R*scale;

% TODO Adjust matrices R and Q so that the diagonal elements of K (= intrinsic matrix) are non-negative values and R (= rotation matrix = orthogonal) has det(R)=1;
% D = diag(sign(diag(R_)));
% Q_ = Q_*D;
% R_ = D*R_;
% R = inv(Q_);
% K = inv(R_);
% K = K / scale;
% R = R*scale;


% TODO Compute translation t=-R*C
t=-R*C;

end