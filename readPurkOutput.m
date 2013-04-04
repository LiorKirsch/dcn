function [geneNames, scores, train, mgi] = readPurkOutput(fileName)

[geneNames, scores, train, mgi] = textread(fileName, '%s %f %s %s', 'delimiter', ',','headerlines' ,1);

end