geneNames = dir( 'ish_images');
conf = configuration();

[geneNames, ~, ~, ~] = readPurkOutput('purkinjeDetectorList.csv');

geneNames = geneNames(1:100);
meanDCOexpression = nan(length(geneNames),2);
expressionImages = cell(size(geneNames));
ishImages = cell(size(geneNames));

ishImagesHD = cell(size(geneNames));

for i_file = 1: length(geneNames)

    gene_name = geneNames{i_file};
    disp(gene_name);
    %matFiles = dir( fullfile(conf.coordinateFolder,[gene_name,'_*.mat']));
    matFiles = dir( fullfile(conf.dataWithExpressionFiles,[gene_name,'_*.mat']));
    
    meanExpression = nan(length(matFiles),1);
    meanPurkExpression = nan(length(matFiles),1);
    
    meanArea = nan(length(matFiles),1);
    meanPurkarea = nan(length(matFiles),1);
    
    for i_matFile = 1: length(matFiles)
        matFileName = matFiles(i_matFile).name;
        data = load(fullfile(conf.dataWithExpressionFiles,matFileName));
        
        meanArea(i_matFile) = mean(data.DCOarea(data.coordinateFound));
        meanPurkarea(i_matFile) = mean(data.DCOpurk_area(data.coordinateFound));
        
        meanExpression(i_matFile) = mean(data.DCOexpression(data.coordinateFound));
        meanPurkExpression(i_matFile) = mean(data.DCOpurk_expression(data.coordinateFound));

        ishImages{i_file} = [ishImages{i_file}; data.outputFiles(data.coordinateFound)];
        expressionImages{i_file} = [expressionImages{i_file}; data.outputExpressionFiles(data.coordinateFound)];
        
        imageIds = data.imagesPath.imageIDs(data.coordinateFound);
        allenExplorerUrl = cell(length(imageIds),1);
        for m=1:length(imageIds)
            allenExplorerUrl{m} = sprintf('http://mouse.brain-map.org/experiment/siv?id=%d&imageId=%s&imageType=ish,expression,nissl&initImage=ish&showSubImage=y&coordSystem=pixel' ,data.imageSeriesID , imageIds{m});
        end
        ishImagesHD{i_file} = [ishImagesHD{i_file}; allenExplorerUrl];
    end
    
    meanDCOexpression(i_file,1) = mean(meanExpression);
    meanDCOarea(i_file,1) = mean(meanArea);
    meanDCOexpression(i_file,2) = mean(meanPurkExpression);
    meanDCOarea(i_file,2) = mean(meanPurkarea);
end

meanExpressionRatio = meanDCOexpression(:,2) ./ meanDCOexpression(:,1);
meanAreaRatio = meanDCOarea(:,2) ./ meanDCOarea(:,1);
purkDensity = meanDCOexpression(:,2) ./ meanDCOarea(:,2) ;
outsideDensity = (meanDCOexpression(:,2) - meanDCOexpression(:,1) ) ./ (meanDCOarea(:,2) - meanDCOarea(:,1));



ratio = purkDensity ./ outsideDensity;

examinedGenes = ~isnan(meanExpressionRatio);
[sortedScores, sortedIndcies] = sort(ratio(examinedGenes),'descend');
sortedGenes = geneNames(examinedGenes);
sortedGenes = sortedGenes(sortedIndcies);

output.purkExpScores = meanDCOexpression(:,2);
output.purkExpScores = output.purkExpScores(examinedGenes);
output.purkExpScores = output.purkExpScores(sortedIndcies);

output.DCOexpScores = meanDCOexpression(:,1);
output.DCOexpScores = output.DCOexpScores(examinedGenes);
output.DCOexpScores = output.DCOexpScores(sortedIndcies);

output.purkAreas = meanDCOarea(:,2);
output.purkAreas = output.purkAreas(examinedGenes);
output.purkAreas = output.purkAreas(sortedIndcies);

output.DCOareas = meanDCOarea(:,1);
output.DCOareas = output.DCOareas(examinedGenes);
output.DCOareas = output.DCOareas(sortedIndcies);

output.purkDensity = purkDensity;
output.purkDensity = output.purkDensity(examinedGenes);
output.purkDensity = output.purkDensity(sortedIndcies);

output.outsideDensity = outsideDensity;
output.outsideDensity = output.outsideDensity(examinedGenes);
output.outsideDensity = output.outsideDensity(sortedIndcies);

expressionImages = expressionImages(examinedGenes);
ishImages = ishImages(examinedGenes);
ishImagesHD = ishImagesHD(examinedGenes);
expressionImages = expressionImages(sortedIndcies);
ishImages = ishImages(sortedIndcies);
ishImagesHD = ishImagesHD(sortedIndcies);


markedGenes = {'Pcp4','3110001A13Rik','Tex261','Calb1','Dgkh','Lxn', 'Large','Grid2','Ptprz1'};

fid = fopen('output.html', 'w');
fprintf(fid,'<html><head><title>Dorsal Cochlear Nucleus expression</title></head><body><table>\n');
fprintf(fid,'<tr> <th>ratio <small>( densityPurk/densityOutside )</small></th>   <th>Name</th>   <th>images</th> <th>expressionPurk</th> <th>expressionDCN</th>  <th>areaPurk</th> <th>areaDCN</th></tr>');
for i = 1:length(sortedGenes)
    if ismember(sortedGenes{i}, markedGenes);
        style = 'background-color: #cfcfcf;';
    else
        style = '';
    end
    
    fprintf(fid, '<tr style="%s"> <td> %.2f <SMALL> (%.4f/%.4f) </SMALL></td> <td> %s <a href="http://www.genecards.org/cgi-bin/carddisp.pl?gene=%s"><small> card</small></a> </td> \n\t<td> ', style, sortedScores(i), output.purkDensity(i), output.outsideDensity(i), sortedGenes{i},sortedGenes{i});
    for j = 1:length(ishImages{i})
        fprintf(fid,' [');
        fprintf(fid, '<a href=%s target="geneImage">ish</a>, ', ishImages{i}{j});
        fprintf(fid, '<a href=%s target="geneImage">mask</a>, ', expressionImages{i}{j});
        fprintf(fid, '<a href=%s target="geneImageHD">HD</a>', ishImagesHD{i}{j});
        fprintf(fid, '] , ');
    end
    fprintf(fid, '</td> \n<td>%g</td><td>%g</td><td>%g</td><td>%g</td></tr>\n' , output.purkExpScores(i), output.DCOexpScores(i), output.purkAreas(i), output.DCOareas(i));
end
fprintf(fid, '</table></body></html>');
fclose(fid);

save('sortPurkGenes.mat', 'sortedGenes', 'sortedGenes');