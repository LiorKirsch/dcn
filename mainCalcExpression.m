close all;
geneNames = dir( 'ish_images');
conf = configuration();

[geneNames, ~, ~, ~] = readPurkOutput('purkinjeDetectorList.csv');

geneNames = geneNames(1:100);
for i_file = 1: length(geneNames)

    gene_name = geneNames{i_file};
    disp(gene_name);
    %matFiles = dir( fullfile(conf.coordinateFolder,[gene_name,'_*.mat']));
    matFiles = dir( fullfile(conf.dataWithExpressionFiles,[gene_name,'_*.mat']));
    
    for i_matFile = 1: length(matFiles)

        matFileName = matFiles(i_matFile).name;
        data = load(fullfile(conf.dataWithExpressionFiles,matFileName));
        data.DCOarea = nan(size(data.coordinateFound));
        data.DCOexpression = nan(size(data.coordinateFound));
        data.DCOpurk_area = nan(size(data.coordinateFound));
        data.DCOpurk_expression = nan(size(data.coordinateFound));
        
        markedCoordinates = data.coordinates(data.coordinateFound);
        markedFileNames = data.downloadedFilesNames(data.coordinateFound);
        markedExpressionFileNames = data.expressionImageFile(data.coordinateFound);
        releventIndices = find(data.coordinateFound);
        for imageIndex =1:length(markedCoordinates)
            fileName = markedExpressionFileNames{imageIndex} ;
            I = imread(fileName);
            x = markedCoordinates{imageIndex}.x(markedCoordinates{imageIndex}.type==1);
            y = markedCoordinates{imageIndex}.y(markedCoordinates{imageIndex}.type==1);
            [data.DCOarea(releventIndices(imageIndex)), data.DCOexpression(releventIndices(imageIndex))]  = calcAreaAndExpressionInPolygon(I,x,y);
            
            x = markedCoordinates{imageIndex}.x(markedCoordinates{imageIndex}.type==3);
            y = markedCoordinates{imageIndex}.y(markedCoordinates{imageIndex}.type==3);
            [data.DCOpurk_area(releventIndices(imageIndex)), data.DCOpurk_expression(releventIndices(imageIndex))]  = calcAreaAndExpressionInPolygon(I,x,y);
        end
       save(fullfile(conf.dataWithExpressionFiles,matFileName), '-struct', 'data')
    end
end