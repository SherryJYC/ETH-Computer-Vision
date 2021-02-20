clear;

% load data
% 15 objects in total: 
% 1-5 Heart
% 6-10 Fork
% 11-15 Watch
data = load('dataset.mat');
objects = data.objects;

% choose shape (target and template)
% 1 for heart, 2 for fork, 3 for watch
shape = 1; 

if shape==1 % heart
    target = 1;
    template = 2;
elseif shape==2 % fork
    target = 6;
    template = 7;
else % watch
    target = 11;
    template = 12;
end

% get points and images
target_pt = objects(target).X;
target_img = objects(target).img;
template_pt = objects(template).X;
template_img = objects(template).img;

% check plot
% subplot(1,2,1)
% imshow(target_img);
% title('Target Image')
% subplot(1,2,2)
% imshow(template_img);
% title('Template Image')

nsamp=1000;

if shape==3
    nsamp = 790;
end
target_pt_samp = get_samples(target_pt, nsamp);
template_pt_samp = get_samples(template_pt, nsamp);

display_flag=1;
matchingCost=shape_matching(template_pt_samp,target_pt_samp,display_flag);


%% plot
% iter = 1:6;
% figure(6)
% plot(iter, matchingCost1)
% hold on
% plot(iter, matchingCost2)
% hold on
% plot(iter, matchingCost3)
% title('Energy in Iterations')
% xlabel('Iteration')
% ylabel('Energy')
% legend('heart', 'fork', 'watch')



