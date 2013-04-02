
function script(directory_name)
% Load all file in a given directory
cd (directory_name)
filenames = dir( '*.jpg');
fileOut=[];
count=0;

for i_file = 1: length(filenames)

  I = imread(filenames(i_file).name);
  imshow(I);

  action = input('what do you want to do? (n/s)')
  switch action
   case 'n',
   case 's',
       count=count+1;
       fileOut(count).name=filenames(i_file).name;%save the name of the pic.
       [x,y] = getpts;%get the coorinates, as many as you like. press Enter 
                        %to finish
       fileOut(count).x=x;%save the coordinates to the matching pic.
       fileOut(count).y=y;
   otherwise
    error('illegal action %s\n', action);
  end

end

save('coordinate.mat', 'fileOut')

end