close all;
geneNames = dir( 'ish_images');
conf.dir_name = 'ish_images';
conf.coordinateFolder = 'coordinates';
conf.expressionImagesFolder = 'expression';
conf.dataWithExpressionFiles = 'afterExpression';

[geneNames, ~, ~, ~] = readPurkOutput('purkinjeDetectorList.csv');

geneNames = geneNames(1:100);
for i_file = 1: length(geneNames)

    gene_name = geneNames{i_file};
     % Load all file in a given directory
    %filenames = dir( fullfile(conf.dir_name,gene_name,'*.jpg'));
    disp(gene_name);
    matFiles = dir( fullfile(conf.coordinateFolder,[gene_name,'_*.mat']));
    for i_matFile = 1: length(matFiles)

        matFileName = matFiles(i_matFile).name;
        data = load(fullfile(conf.coordinateFolder,matFileName));
        data.expressionImageFile = cell(size(data.coordinateFound));
        
        markedCoordinates = data.coordinates(data.coordinateFound);
        markedFileNames = data.downloadedFilesNames(data.coordinateFound);
        markedExpressionPath = data.imagesPath.expressionImagePath(data.coordinateFound);
        releventIndices = find(data.coordinateFound);
        for imageIndex =1:length(markedCoordinates)
            [~, fileName, ext] = fileparts(markedFileNames{imageIndex}) ;
            fileName = [fileName, ext];
            fileName = fullfile(conf.expressionImagesFolder,fileName);
            
            data.expressionImageFile{ releventIndices(imageIndex)} = fileName;
            if ~exist(fileName,'file')
                fprintf('downloading %s \n' , fileName);
                imageFilePath = downloadImage(markedExpressionPath{imageIndex}, fileName);
            else
                fprintf('file %s exists\n' , fileName);
            end
        end
        save(fullfile(conf.dataWithExpressionFiles,matFileName), '-struct', 'data')
    end
end