close all;
filenames = dir( 'ish_images');
conf.dir_name = 'ish_images';
conf.coordinateFolder = 'coordinates';

for i_file = 1: length(filenames)

  if filenames(i_file).isdir && ~any(strcmp(filenames(i_file).name ,{'.', '..'}));
    geneName = filenames(i_file).name;
    coordinates = markRegion(geneName, conf);
  end
  
end