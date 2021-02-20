function [descriptors,patches] = descriptors_hog(img,vPoints,cellWidth,cellHeight)

    nBins = 8;
    nCellsW = 4; % number of cells, hard coded so that descriptor dimension is 128
    nCellsH = 4; 

    w = cellWidth; % set cell dimensions
    h = cellHeight;   

    pw = w*nCellsW; % patch dimensions
    ph = h*nCellsH; % patch dimensions

    descriptors = zeros(0,nBins*nCellsW*nCellsH); % one histogram for each of the 16 cells
    patches = zeros(0,pw*ph); % image patches stored in rows    
    
    [grad_x,grad_y] = gradient(img);    
    Gdir = (atan2(grad_y, grad_x)); 
    
    for i = [1:size(vPoints,1)] % for all local feature points
        % get current local patch (use vPoints(i,:) as center)
        leftloc = vPoints(i,:);
        leftloc(1) = leftloc(1)- nCellsW/2*w;   
        leftloc(2) = leftloc(2)- nCellsH/2*h;  
        cur_patch = img(leftloc(1):(leftloc(1)+nCellsW*w-1),...
                        leftloc(2):(leftloc(2)+nCellsH*h-1));
        patches(i,:) = cur_patch(:);
        
        % compute HOG (16x8) for curren patch
        hist_patch = zeros(nCellsW*nCellsH,8);
        cellidx = 1;
        for x=1:nCellsW
            for y=1:nCellsH              
                leftx = leftloc(1) + (x-1)*w;
                lefty = leftloc(2) + (y-1)*h;
                % get gradient direction for current cell
                curr_Gdir = Gdir(leftx:leftx+w-1, lefty:lefty+h-1);
                hist_patch(cellidx,:) = histcounts(curr_Gdir,nBins,'BinLimits',[-pi,pi]);
                cellidx = cellidx + 1;
            end
        end
        descriptors(i,:) = reshape(hist_patch',[],1);
    end % for all local feature points
    
end
