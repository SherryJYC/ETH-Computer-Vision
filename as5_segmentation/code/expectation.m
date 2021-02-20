function P = expectation(mu,var,alpha,X)
% var: 3x3xK
% alpha: 1x3
% mu: Kx3
% X: Lx3
% P: NxK

K = length(alpha);
N = size(X,1);
P = zeros(N, K);

for i = 1:N
    for k = 1:K
        exp_term = -0.5*(X(i,:)-mu(k,:))*pinv(var(:,:,k))*(X(i,:)-mu(k,:)).';
        divide_term = (2*pi)^(3/2)*(det(var(:,:,k)))^(1/2);
        P(i,k) = alpha(k)/ divide_term *exp(exp_term) ;
    end
    % normalize 
    P(i,:) = P(i,:)/sum(P(i,:));
end

end