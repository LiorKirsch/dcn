function showMarkedImage(I,x,y,type)

    hold on;
%    I = drawWithColor(I,x1,y1,'-b');
    
%    I = drawWithColor(I,x2,y2,'-b');
    
%    I = drawWithColor(I,x3,y3,'-b');
    
    imshow(I);
    drawLine(x,y,type ==1,'-b');
    drawLine(x,y,type ==2,'-r');
    drawLine(x,y,type ==3,'-g');
    hold off;
end
function drawLine(x,y,subset,color)
    if any(subset)
        x = x(subset);
        y = y(subset);
        plot([x;x(1)],[y;y(1)], color,'LineWidth',3);
    end
end
function I = drawWithColor(I,x,y,color)
    BW = poly2mask(x,y, size(I,1),size(I,2) );
      %scale = 1200 / size(I,1);
      %I = imresize(I, scale);
      %BW = imresize(BW, scale);
      
      red = I(:,:,1);
      red(BW) = 255;
      
      %colorMask = cat(3,BW, BW ,BW);
      %I(~colorMask) = I(~colorMask) *0.6;
      I(:,:,1) = red;
     
      
      
end
 