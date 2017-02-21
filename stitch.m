function returnImage = stitch(J,K,H)

% Take the original left image
returnImage = J;

% Pad an array of 150 for pixels from second image
returnImage = padarray(returnImage,[10,100],0,'post');

for x = 1:size(K,1)
    for y = 1:size(K,2)
        
        % For each point in right images, get the corresponding location
        % in left image using affine transform.
        transformedPoints = H * [y;x;1];
        transformedPoints = round(transformedPoints);
        % Skip points with negative index
        if transformedPoints(1) <= 0
            continue;
        elseif transformedPoints(2) <= 0
            continue;
        % Place the point from right image to its location
        else
            transformedPoints;
            returnImage(transformedPoints(2),transformedPoints(1))= K(x,y);
        end
    end
end
end