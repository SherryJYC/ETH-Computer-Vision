function vPoints = grid_points(img,nPointsX,nPointsY,border)
% create a grid 

[w ,h] = size(img) ;
n = nPointsX*nPointsY;
% skip border
w = w - border;
h = h - border;
start = 1 + border;

% create grid points (need convert double to int)
axisx = int32(linspace(start, w, nPointsX)); 
axisy = int32(linspace(start, h, nPointsY));
[gridX,gridY] = meshgrid(axisx,axisy) ;
gridX = reshape(gridX,n,1) ;
gridY = reshape(gridY,n,1) ;
    
% (nPointsX · nPointsY) x 2
vPoints = [gridX, gridY] ; 
    
end
