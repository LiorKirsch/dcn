
function data = markRegion(gene_name,conf)
    % Load all file in a given directory
    %filenames = dir( fullfile(conf.dir_name,gene_name,'*.jpg'));
    matFiles = dir( fullfile(conf.dir_name,gene_name,'*.mat'));
    for i_matFile = 1: length(matFiles)

        matFileName = matFiles(i_matFile).name;
        data = load(fullfile(conf.dir_name,gene_name,matFileName));
        data.coordinates=cell(length(data.downloadedFilesNames),1);
        data.coordinateFound = false(length(data.downloadedFilesNames),1);

        imageIndex = 1;
        while imageIndex <= length(data.downloadedFilesNames)
            [~, fileName, ext] = fileparts(data.downloadedFilesNames{imageIndex}) ;
            fileName = [fileName, ext];
            fileName = fullfile(conf.dir_name,gene_name,fileName);
             I = imread(fileName);
             
            if data.coordinateFound(imageIndex)
                showMarkedImage(I,data.coordinates{imageIndex}.x,data.coordinates{imageIndex}.y);
            else
                imshow(I);
            end
            title(imageIndex);
            
            [imageIndex ,data.coordinates{imageIndex}, data.coordinateFound(imageIndex)] = showAndMarkImage(imageIndex, data.coordinates{imageIndex},data.coordinateFound(imageIndex));
            
        end
            
        save(fullfile(conf.coordinateFolder,matFileName), '-struct', 'data')
    end
end

function [nextIndexToShow ,coordinates, coordinateFound] = showAndMarkImage(indexToShow, coordinates, coordinateFound)
    
    if ~coordinateFound
        coordinates.x = [];  coordinates.y = [];
    end
   
    fprintf('press "e[x]it" , "[p]revious" then ENTER to confirm and next\n');
    [x,y,button] = ginput;%get the coorinates, as many as you like. press Enter to finish
    
    if button == 120  % pressed 'x' 
        nextIndexToShow = inf;
    elseif button == 112  % pressed 'p' 
        nextIndexToShow = indexToShow -1;
    else
        if length(x) > 1
            coordinates.x=x;%save the coordinates to the matching pic.
            coordinates.y=y;
            coordinateFound = ~isempty(x);
            nextIndexToShow = indexToShow;
        else
            nextIndexToShow = indexToShow + 1;
        end
    end
    
end
