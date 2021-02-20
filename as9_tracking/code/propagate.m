function particles = propagate(particles,sizeFrame,params)
%PROPAGATE Summary of this function goes here
% propagate the particles given the system prediction model (matrix A) 
% and the system model noise represented by params.model, 
% params.sigma_position and params.sigma_velocity. 
% Use the parameter sizeFrame to make sure that the center of the particle 
% lies inside the frame.

% particles: params.num_particles x state_length (2 or 4)   nx2 or nx4
% new particles = particles x A + w
% A: 2x2 or 4x4
% w: nx2 or nx4

% define deterministic part and stochastic part
if params.model == 0 
    % model = no motion, only update position
    A = eye(2,2);
    w = normrnd(0,params.sigma_position,params.num_particles,2);
    particles = particles*A + w; 
else
    % model = constant velocity
    % [x, y, vx, vy]
    % [x+vx, y+vy, vx, vy]
    A = [1 0 0 0;
         0 1 0 0;
         1 0 1 0;
         0 1 0 1];
    w_p = normrnd(0,params.sigma_position,params.num_particles,2);
    w_v = normrnd(0,params.sigma_velocity,params.num_particles,2);
    particles = particles*A + [w_p w_v];
end

% avoid index out of frame
particles(:,1) = min(particles(:,1),sizeFrame(2));
particles(:,1) = max(particles(:,1),1);
particles(:,2) = min(particles(:,2),sizeFrame(1));
particles(:,2) = max(particles(:,2),1);

end

