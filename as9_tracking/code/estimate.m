function meanState = estimate(particles,particles_w)
%ESTIMATE Summary of this function goes here
% estimate the mean state given the particles and their weights.

% particles: nx2
% particles_w: nx1

% (2xn nx1).' = 1x2
meanState=(particles'*particles_w)';

end

