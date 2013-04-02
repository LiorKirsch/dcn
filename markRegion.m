
function data = markRegion(gene_name,conf)
    % Load all file in a given directory
    %filenames = dir( fullfile(conf.dir_name,gene_name,'*.jpg'));
    matFiles = dir( fullfile(conf.dir_name,gene_name,'*.mat'));
    for i_matFile = 1: length(matFiles)

        matFileName = matFiles(i_matFile).name;
        data = load(fullfile(conf.dir_name,gene_name,matFileName));
        data.coordinates=cell(length(data.downloadedFilesNames),1);
        data.coordinateFound = false(length(data.downloadedFilesNames),1);

        for i_file = 1: length(data.downloadedFilesNames)
            [~, fileName, ext] = fileparts(data.downloadedFilesNames{i_file}) ;
            fileName = [fileName, ext];
            fileName = fullfile(conf.dir_name,gene_name,fileName);

            I = imread(fileName);
            imshow(I);
            [x,y] = getpts;%get the coorinates, as many as you like. press Enter 
                            %to finish
            data.coordinates{i_file}.x=x;%save the coordinates to the matching pic.
            data.coordinates{i_file}.y=y;
            data.coordinateFound(i_file) = ~isempty(x);
        end
        save(fullfile(conf.coordinateFolder,matFileName), '-struct', 'data')
    end
end