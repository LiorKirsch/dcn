function showCoordinate(gene_name)

    images_dir = fullfile('/', 'cortex','data','ISH','coronal_mouse', ...
                       'ImageDownloader','dataISH_adult_coronal_-9999-250', ...
                       gene_name);

    coordinate_filename = sprintf('coordinate_%s', gene_name);
    C = load(fullfile('coordinates', coordinate_filename));

    image_filenames = {C.fileOut.name};
    xxx = {C.fileOut.x};
    yyy = {C.fileOut.y};
    num_images = length(image_filenames);

    i_image=1; action = '-';
    while action~='x'
      image_filename = fullfile(images_dir, image_filenames{i_image});
      I = imread(image_filename);
      imshow(I);
      hold on;
      x = xxx{i_image};
      y = yyy{i_image};
      plot(x,y);
      
%       figure;
%       BW = poly2mask(x,y, size(I,1),size(I,2) );
%       Igray = rgb2gray(I);
%       Igray(~BW) = Igray(~BW)*0.8;
%       imshow(Igray);
%       
      action  = input('x=exit, n=next, p=previous: ', 's');
      if isempty(action), action = 'n'; end
      switch action
        case 'n', i_image = min(i_image+1, num_images);
        case 'p', i_image = max(i_image-1, 1);
      end
    end
end