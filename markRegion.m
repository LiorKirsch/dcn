
function data = markRegion(gene_name,conf)
    % Load all file in a given directory
    %filenames = dir( fullfile(conf.dir_name,gene_name,'*.jpg'));
    data = [];
    
    matFiles = dir( fullfile(conf.coordinateFolder,[gene_name,'_*.mat']));
    if isempty(matFiles)
        matFiles = dir( fullfile(conf.dir_name,gene_name,'*.mat'));
    end
    
    for i_matFile = 1: length(matFiles)

        matFileName = matFiles(i_matFile).name;
        
        if exist(fullfile(conf.coordinateFolder,matFileName) , 'file')
            data = load(fullfile(conf.coordinateFolder,matFileName));
        else
            data = load(fullfile(conf.dir_name,gene_name,matFileName));
        end
        
        
        
        if ~isfield(data, 'coordinates')
            data.coordinates=cell(length(data.downloadedFilesNames),1);
            data.coordinateFound = false(length(data.downloadedFilesNames),1);
        end

        if any(data.coordinateFound)
            foundIndices = find(data.coordinateFound);
            imageIndex =  foundIndices(1) -1;
        else
            imageIndex = 1;
        end
        
        while imageIndex <= length(data.downloadedFilesNames)
            [~, fileName, ext] = fileparts(data.downloadedFilesNames{imageIndex}) ;
            fileName = [fileName, ext];
            fileName = fullfile(conf.dir_name,gene_name,fileName);
            I = imread(fileName);
            scale = 1200 / size(I,1);
            I = imresize(I, scale);
             
            if data.coordinateFound(imageIndex)
                showMarkedImage(I,data.coordinates{imageIndex}.x* scale,data.coordinates{imageIndex}.y* scale, data.coordinates{imageIndex}.type);
            else
                imshow(I);
            end
            title([gene_name, '      ' ,num2str(imageIndex)]);
            
            [imageIndex ,data.coordinates{imageIndex}, data.coordinateFound(imageIndex)] = showAndMarkImage(imageIndex, data.coordinates{imageIndex},data.coordinateFound(imageIndex),scale);
            
        end
            
        save(fullfile(conf.coordinateFolder,matFileName), '-struct', 'data')
    end
end

function [nextIndexToShow ,coordinates, coordinateFound] = showAndMarkImage(indexToShow, coordinates, coordinateFound,scale)
    
    if ~coordinateFound
        coordinates.x = [];  coordinates.y = []; coordinates.type = [];
    end
   
    fprintf('press "e[x]it" , "[p]revious" ,"[r]edraw", then ENTER to confirm and next\n');
    [x,y,button] = ginput;%get the coorinates, as many as you like. press Enter to finish
    
    if button == 120  % pressed 'x' 
        nextIndexToShow = inf;
    elseif button == 112  % pressed 'p' 
        nextIndexToShow = indexToShow -1;
    elseif button == 114  % pressed 'r' 
        nextIndexToShow = indexToShow;
        coordinates.x=[];
        coordinates.y=[];
        coordinates.type = [];
        coordinateFound = false;
    else
        if length(x) > 1
            coordinates.x=x;%save the coordinates to the matching pic.
            coordinates.y=y;
            coordinates.x = coordinates.x/scale;
            coordinates.y = coordinates.y/scale;
            coordinates.type = button;
            coordinateFound = ~isempty(x);
            nextIndexToShow = indexToShow;
        else
            nextIndexToShow = indexToShow + 1;
        end
    end
    
end
