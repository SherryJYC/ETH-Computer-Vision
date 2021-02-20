% Generate initial values for mu
% K is the number of segments

function mu = generate_mu(delta_L, delta_a, delta_b, K)

mu = zeros(K,3);
% A good way to initialize is to spread them equally in the L*a*b* space
for i = 1:K
    mu(i,:)=i*[delta_L delta_a delta_b]/(K+1);
end

end