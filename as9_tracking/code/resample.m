function [particles, particles_w] = resample(particles,particles_w)
%RESAMPLE Summary of this function goes here
% resample the particles based on their weights, 
% return these new particles along with their corresponding weights.

num_par = size(particles,1);

% resample with replacement 
new_particles = datasample(particles, num_par, 'replace', true, 'Weights', particles_w); 

% update weights
new_w = zeros(num_par,1) ;
[C,inew,iold] = intersect(new_particles,particles, 'rows');
new_w(inew) = particles_w(iold);

% normalize weights
particles_w = new_w/sum(new_w); 

particles = new_particles ;

end

