function vCenters = create_codebook(nameDirPos,nameDirNeg,k)
  
  vImgNames = dir(fullfile(nameDirPos,'*.png'));
  vImgNames = [vImgNames; dir(fullfile(nameDirNeg,'*.png'))];
  
  nImgs = length(vImgNames);
  vFeatures = zeros(0,128); % 16 histograms containing 8 bins
  vPatches = zeros(0,16*16); % 16*16 image patches 
  
  cellWidth = 4;
  cellHeight = 4;
  nPointsX = 10;
  nPointsY = 10;
  border = 8;
  
  % Extract features for all images
  for i=1:nImgs
    
    disp(strcat('  Processing image ', num2str(i),'...'));
    
    % load the image
    img = double(rgb2gray(imread(fullfile(vImgNames(i).folder,vImgNames(i).name))));

    % Collect local feature points for each image
    vPoints = grid_points(img,nPointsX,nPointsY,border);
    % and compute a descriptor for each local feature point
    % create hog descriptors and patches
    [descriptors,patches] = descriptors_hog(img,vPoints,cellWidth,cellHeight);	

    vFeatures = [vFeatures; descriptors];
    vPatches = [vPatches; patches];
  end
  disp(strcat('    Number of extracted features:',num2str(size(vFeatures,1))));

  % Cluster the features using K-Means
  disp(strcat('  Clustering...'));
  [~,vCenters] = kmeans(vFeatures,k);
  
  
  % Visualize the code book  
  disp('Visualizing the codebook...');
  visualize_codebook(vCenters,vFeatures,vPatches,cellWidth,cellHeight);
  disp('Press any key to continue...');
%   pause;
  
 

end