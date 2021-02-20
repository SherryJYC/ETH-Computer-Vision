function particles_w = observe(particles,frame,H,W,hist_bin,hist_target,sigma_observe)
%OBSERVE Summary of this function goes here
%  compute for all particles color histogram describing the bbx defined by 
% the center of the particle and W and H. 
% These observations should be used then to update the weights particles w
% based on the ?2 distance between particle color histogram and hist_target. 

num_par = size(particles, 1);
particles_w = zeros(num_par,1);

% get bbx for each particle
xMin = particles(:,1) - 0.5*W.*ones(num_par,1);
yMin = particles(:,2) - 0.5*H.*ones(num_par,1);
xMax = particles(:,1) + 0.5*W.*ones(num_par,1);
yMax = particles(:,2) + 0.5*H.*ones(num_par,1);

% compute similarity and get weight
for i=1:num_par
    
    % get color hist for current particle
    hist = color_histogram(xMin(i),yMin(i),xMax(i),yMax(i),frame,hist_bin);
    
    % compute similarity
    X2 = chi2_cost(hist_target,hist);
    
    % compute weight with Gaussian
    particles_w(i) = 1/(sqrt(2*pi)*sigma_observe) * exp(-X2^2/(2*sigma_observe^2));
end

% normalized weights
particles_w = particles_w/sum(particles_w);

end

