function showMarkedImage(I,x,y)
      BW = poly2mask(x,y, size(I,1),size(I,2) );
      scale = 1200 / size(I,1);
      I = imresize(I, scale);
      BW = imresize(BW, scale);
      
      red = I(:,:,1);
      red(BW) = 255;
      
      %colorMask = cat(3,BW, BW ,BW);
      %I(~colorMask) = I(~colorMask) *0.6;
      I(:,:,1) = red;
      imshow(I);
      
end
 