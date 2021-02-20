function histo = bow_histogram(vFeatures, vCenters)
  % input:
  %   vFeatures: MxD matrix containing M feature vectors of dim. D
  %   vCenters : NxD matrix containing N cluster centers of dim. D
  % output:
  %   histo    : N-dim. vector containing the resulting BoW
  %              activation histogram.
  
  
  % Match all features to the codebook and record the activated
  % codebook entries in the activation histogram "histo".
  N = size(vCenters,1);
  histo = zeros(1,N);
  % finds the nearest neighbor in X for each query point in Y
  % id are 1:N 
  [id, ~] = knnsearch(vCenters, vFeatures);
  
  % [histo,b]=hist(vCenters,unique(vCenters))
  for i=1:N
      histo(i) = size(find(id == i),1);
  end
  
end
