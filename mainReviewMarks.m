function mainReviewMarks()
close all;

    geneNames = dir( 'ish_images');
    conf.dir_name = 'ish_images';
    conf.coordinateFolder = 'coordinates';
    conf.dataWithExpressionFiles = 'afterExpression';
    conf.outputMaskImageFolder = 'outputMask';
    conf.outputImageFolder = 'output';

    [geneNames, ~, ~, ~] = readPurkOutput('purkinjeDetectorList.csv');

    geneNames = geneNames(1:100);
    for i_file = 1: length(geneNames)

        gene_name = geneNames{i_file};

    %    matFiles = dir( fullfile(conf.coordinateFolder,[gene_name,'_*.mat']));
        matFiles = dir( fullfile(conf.dataWithExpressionFiles,[gene_name,'_*.mat']));

        for i_matFile = 1: length(matFiles)

            matFileName = matFiles(i_matFile).name;
            %data = load(fullfile(conf.coordinateFolder,matFileName));
            data = load(fullfile(conf.dataWithExpressionFiles,matFileName));
            data.outputFiles = cell(size(data.coordinateFound));
            data.outputExpressionFiles = cell(size(data.coordinateFound));

            indecies = find(data.coordinateFound);
            markedCoordinates = data.coordinates(data.coordinateFound);
            markedFileNames = data.downloadedFilesNames(data.coordinateFound);
            markedExpressionFileNames = data.expressionImageFile(data.coordinateFound);
            for imageIndex =1:length(markedCoordinates)
                
                [~, imageFileName, ext] = fileparts(markedFileNames{imageIndex}) ;
                imageFileName = [imageFileName, ext];
                imageFileName = fullfile(conf.dir_name,gene_name,imageFileName);
                outputFileName = ['output/', matFileName, num2str(imageIndex),'.png'];
                showMarksOnImage(imageFileName, outputFileName, gene_name, markedCoordinates{imageIndex});
                data.outputFiles{indecies(imageIndex)} = outputFileName;
                
                imageFileName = markedExpressionFileNames{imageIndex} ;
                outputFileName = ['outputMask/', matFileName, num2str(imageIndex),'.png'];
                showMarksOnImage(imageFileName, outputFileName, gene_name, markedCoordinates{imageIndex});
                data.outputExpressionFiles{indecies(imageIndex)} = outputFileName;
            end

            save(fullfile(conf.dataWithExpressionFiles,matFileName), '-struct', 'data')
        end
    end
end

function showMarksOnImage(imageFileName, outputFileName, geneName, coordinates)

    
        I = imread(imageFileName);
        scale = 1200 / size(I,1);
        I = imresize(I, scale);
         subplot(1,2,1);
         imshow(I);
         subplot(1,2,2);
         imshow(I);
         title(geneName);
        showMarkedImage(I,coordinates.x* scale,coordinates.y* scale,coordinates.type);
        saveFigure(gcf,outputFileName,'png');
        pause(1);

end