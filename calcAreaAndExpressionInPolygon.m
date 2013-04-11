function [areaSize, areaExpression]  = calcAreaAndExpressionInPolygon(I,x,y)
    
    BW = poly2mask(x,y, size(I,1),size(I,2) );
    
    areaSize = sum(BW(:));
    onlyReleventAreas = I(BW);
    
    % number of pixels that above the mask threshold
    areaExpression = sum(onlyReleventAreas(:) > 0);
end 