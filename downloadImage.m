function imageFilePath = downloadImage(partialPath, fileName)
    
    imageProperties.top = 0;
    imageProperties.left = 0;
    imageProperties.width = 3000000;
    imageProperties.height = 3000000;
    resolution = -1;
    
    imageFile_complete_url = expressionPathToUrl(partialPath,resolution ,imageProperties);
    
    try
        imageFilePath = urlwrite(imageFile_complete_url, fileName);
        % if file size is zero report error
        fileProperties = dir(imageFilePath);
        filesize = fileProperties.bytes ;
        if ( filesize == 0)
            error('fileDown:zeroSize','the file downloaded is of zero size');
        end
    catch exception
        fprintf('problam while saving the file %s from url \n%s \n%s.',fileName,imageFile_complete_url,exception.message );
        rethrow(exception) ;
    end
    
end

function imageFile_complete_url = expressionPathToUrl(imagePath,resolution ,imageProperties)

%   [image] = get_imageFile_ABA(imagePath,resolution ,fileName,imageProperties) 
%   downloads the image provided by imagePath
%   requesting a specific resolution (in order to ask for the highest possible use -1).
%   Saves the image to location provided by fileName.
%   In order not to download the entier image provide a starting point with
%   imageProperties.top , imageProperties.left, imageProperties.width, imageProperties.height 

    if isnan(resolution)% == NaN 
        resolution = -1  ; % highest resolution
    end


   
    url_1of3 = sprintf( 'http://www.brain-map.org/aba/api/image?mime=2&top=%d&left=%d&width=%d&height=%d' ,imageProperties.top , imageProperties.left, imageProperties.width, imageProperties.height) ;
    
    
%     if ~imageProperties.grayScale && ~conf.useISI
%        url_1of3 = sprintf('%s&filter=colormap&filterVals=0.5,0.99,0,255,4' , url_1of3); 
%     end
    imagePathURL = [ '&path=', imagePath ];
    imageResolutionURL = ['&zoom=' , num2str(resolution)];

    imageFile_complete_url = [url_1of3,imageResolutionURL,imagePathURL];
    
end
