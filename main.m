close all;
geneNames = dir( 'ish_images');
conf = configuration();

[geneNames, ~, ~, ~] = readPurkOutput('purkinjeDetectorList.csv');

geneNames = geneNames(1:100);
for i_file = 1: length(geneNames)

%  if geneNames(i_file).isdir && ~any(strcmp(geneNames(i_file).name ,{'.', '..'}));
%    geneName = geneNames(i_file).name;
%    coordinates = markRegion(geneName, conf);
%  end
  
    coordinates = markRegion(geneNames{i_file}, conf);
end