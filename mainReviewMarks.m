close all;
geneNames = dir( 'ish_images');
conf.dir_name = 'ish_images';
conf.coordinateFolder = 'coordinates';
conf.dataWithExpressionFiles = 'afterExpression';

[geneNames, ~, ~, ~] = readPurkOutput('purkinjeDetectorList.csv');

geneNames = geneNames(1:100);
for i_file = 1: length(geneNames)

    gene_name = geneNames{i_file};
    
    matFiles = dir( fullfile(conf.coordinateFolder,[gene_name,'_*.mat']));
%    matFiles = dir( fullfile(conf.dataWithExpressionFiles,[gene_name,'_*.mat']));
    
    for i_matFile = 1: length(matFiles)

        matFileName = matFiles(i_matFile).name;
        data = load(fullfile(conf.dataWithExpressionFiles,matFileName));
        
        markedCoordinates = data.coordinates(data.coordinateFound);
        markedFileNames = data.downloadedFilesNames(data.coordinateFound);
        markedExpressionFileNames = data.expressionImageFile(data.coordinateFound);
        for imageIndex =1:length(markedCoordinates)
             [~, fileName, ext] = fileparts(markedFileNames{imageIndex}) ;
             fileName = [fileName, ext];
             fileName = fullfile(conf.dir_name,gene_name,fileName);
%            fileName = markedExpressionFileNames{imageIndex} ;
            I = imread(fileName);
            scale = 1200 / size(I,1);
            I = imresize(I, scale);
            subplot(1,2,1);
            imshow(I);
            subplot(1,2,2);
            imshow(I);
            title(gene_name);
            showMarkedImage(I,markedCoordinates{imageIndex}.x* scale,markedCoordinates{imageIndex}.y* scale, markedCoordinates{imageIndex}.type);
            saveFigure(gcf,['output/', num2str(i_matFile),'-', matFileName, num2str(imageIndex),'..png'],'png');
            pause(1);
        end
       
    end
end