geneNames = dir( 'ish_images');
conf = configuration();

[geneNames, ~, ~, ~] = readPurkOutput('purkinjeDetectorList.csv');

geneNames = geneNames(1:100);
meanDCOexpression = nan(length(geneNames),2);
meanDCOarea = nan(length(geneNames),2);

for i_file = 1: length(geneNames)

    gene_name = geneNames{i_file};
    disp(gene_name);
    %matFiles = dir( fullfile(conf.coordinateFolder,[gene_name,'_*.mat']));
    matFiles = dir( fullfile(conf.dataWithExpressionFiles,[gene_name,'_*.mat']));
    
    meanExpression = nan(length(matFiles),1);
    meanPurkExpression = nan(length(matFiles),1);

    for i_matFile = 1: length(matFiles)
        matFileName = matFiles(i_matFile).name;
        data = load(fullfile(conf.dataWithExpressionFiles,matFileName));
        meanExpression(i_matFile) = mean(data.DCOexpression(data.coordinateFound));
        meanPurkExpression(i_matFile) = mean(data.DCOpurk_expression(data.coordinateFound));
        
    end
    
    meanDCOexpression(i_file,1) = mean(meanExpression);
    meanDCOexpression(i_file,2) = mean(meanPurkExpression);
    
end

meanExpressionRatio = meanDCOexpression(:,2) ./ meanDCOexpression(:,1);

examinedGenes = ~isnan(meanExpressionRatio);
[sortedScores, sortedIndcies] = sort(meanExpressionRatio(examinedGenes),'descend');
sortedGenes = geneNames(examinedGenes);
sortedGenes = sortedGenes(sortedIndcies);
save('sortPurkGenes.mat', 'sortedGenes', 'sortedGenes');