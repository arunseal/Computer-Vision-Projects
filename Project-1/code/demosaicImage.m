function output = demosaicImage(im, method)
% DEMOSAICIMAGE computes the color image from mosaiced input
%   OUTPUT = DEMOSAICIMAGE(IM, METHOD) computes a demosaiced OUTPUT from
%   the input IM. The choice of the interpolation METHOD can be 
%   'baseline', 'nn', 'linear', 'adagrad'. 

switch lower(method)
    case 'baseline'
        output = demosaicBaseline(im);
    case 'nn'
        output = demosaicNN(im);         % Implement this
    case 'linear'
        output = demosaicLinear(im);     % Implement this
    case 'adagrad'
        output = demosaicAdagrad(im);    % Implement this
end

%--------------------------------------------------------------------------
%                          Baseline demosaicing algorithm. 
%                          The algorithm replaces missing values with the
%                          mean of each color channel.
%--------------------------------------------------------------------------
function mosim = demosaicBaseline(im)
mosim = repmat(im, [1 1 3]); % Create an image by stacking the input
[imageHeight, imageWidth] = size(im);

% Red channel (odd rows and columns);
redValues = im(1:2:imageHeight, 1:2:imageWidth);
meanValue = mean(mean(redValues));
mosim(:,:,1) = meanValue;
mosim(1:2:imageHeight, 1:2:imageWidth,1) = im(1:2:imageHeight, 1:2:imageWidth);

% Blue channel (even rows and colums);
blueValues = im(2:2:imageHeight, 2:2:imageWidth);
meanValue = mean(mean(blueValues));
mosim(:,:,3) = meanValue;
mosim(2:2:imageHeight, 2:2:imageWidth,3) = im(2:2:imageHeight, 2:2:imageWidth);

% Green channel (remaining places)
% We will first create a mask for the green pixels (+1 green, -1 not green)
mask = ones(imageHeight, imageWidth);
mask(1:2:imageHeight, 1:2:imageWidth) = -1;
mask(2:2:imageHeight, 2:2:imageWidth) = -1;
greenValues = mosim(mask > 0);
meanValue = mean(greenValues);
% For the green pixels we copy the value
greenChannel = im;
greenChannel(mask < 0) = meanValue;
mosim(:,:,2) = greenChannel;

%--------------------------------------------------------------------------
%                           Nearest neighbour algorithm
%--------------------------------------------------------------------------
function mosim = demosaicNN(im)


[imageHeight, imageWidth] = size(im);

%RED CHANNEL
imred=zeros(imageHeight, imageWidth);
imred(1:2:imageHeight, 1:2:imageWidth) = im(1:2:imageHeight, 1:2:imageWidth);

imred(2:2:imageHeight,2:2:imageWidth)=imred(1:2:imageHeight-1,1:2:imageWidth-1);
imred(1:2:imageHeight,2:2:imageWidth)=imred(1:2:imageHeight,1:2:imageWidth-1);
imred(2:2:imageHeight,1:2:imageWidth)=imred(1:2:imageHeight-1,1:2:imageWidth);
% mosim(:,:,1)=imred;

%BLUE CHANNEL
imblue=zeros(imageHeight, imageWidth);
imblue(2:2:imageHeight, 2:2:imageWidth) = im(2:2:imageHeight, 2:2:imageWidth);

imblue(1:2:imageHeight-1, 1:2:imageWidth-1) = imblue(2:2:imageHeight, 2:2:imageWidth);
imblue(1:2:imageHeight-1, 2:2:imageWidth) = imblue(2:2:imageHeight, 2:2:imageWidth);
imblue(2:2:imageHeight, 1:2:imageWidth-1) = imblue(2:2:imageHeight, 2:2:imageWidth);

%GREEN CHANNEL
imgreen=zeros(imageHeight, imageWidth);
mask = ones(imageHeight, imageWidth);
mask(1:2:imageHeight, 1:2:imageWidth) = -1;
mask(2:2:imageHeight, 2:2:imageWidth) = -1;
imtemp=im;
imtemp(mask<0)=0;
imgreen=imtemp;

imgreen(1:2:imageHeight, 1:2:imageWidth-1)=imgreen(1:2:imageHeight, 2:2:imageWidth);
imgreen(2:2:imageHeight, 2:2:imageWidth)=imgreen(2:2:imageHeight, 1:2:imageWidth-1);


mosim=cat(3,imred,imgreen,imblue);


%--------------------------------------------------------------------------
%                           Linear interpolation
%--------------------------------------------------------------------------
function mosim = demosaicLinear(im)
[imageHeight, imageWidth] = size(im);
imred=zeros(imageHeight, imageWidth);
imred(1:2:imageHeight, 1:2:imageWidth) = im(1:2:imageHeight, 1:2:imageWidth);

imblue=zeros(imageHeight, imageWidth);
imblue(2:2:imageHeight, 2:2:imageWidth) = im(2:2:imageHeight, 2:2:imageWidth);

imgreen=zeros(imageHeight, imageWidth);
mask = ones(imageHeight, imageWidth);
mask(1:2:imageHeight, 1:2:imageWidth) = -1;
mask(2:2:imageHeight, 2:2:imageWidth) = -1;
imtemp=im;
imtemp(mask<0)=0;
imgreen=imtemp;

%Create Filters
filterrb=[1 2 1;2 4 2;1 2 1]/4;
filterg=[0 1 0;1 4 1;0 1 0]/4;

%Convolution
imred=conv2(imred,filterrb,'same');
imblue=conv2(imblue,filterrb,'same');
imgreen=conv2(imgreen,filterg,'same');

mosim=cat(3,imred,imgreen,imblue);

%--------------------------------------------------------------------------
%                           Adaptive gradient
%--------------------------------------------------------------------------
function mosim = demosaicAdagrad(im)
[imageHeight, imageWidth] = size(im);
imred=zeros(imageHeight, imageWidth);
imred(1:2:imageHeight, 1:2:imageWidth) = im(1:2:imageHeight, 1:2:imageWidth);

imblue=zeros(imageHeight, imageWidth);
imblue(2:2:imageHeight, 2:2:imageWidth) = im(2:2:imageHeight, 2:2:imageWidth);

imgreen=zeros(imageHeight, imageWidth);
mask = ones(imageHeight, imageWidth);
mask(1:2:imageHeight, 1:2:imageWidth) = -1;
mask(2:2:imageHeight, 2:2:imageWidth) = -1;
imtemp=im;
imtemp(mask<0)=0;
imgreen=imtemp;

%GREEN CHANNEL
imgreen=padarray(imgreen,[1 1],0,'both');
[h,w]=size(imgreen);
for i=2:2:h-1
   for j=2:2:w-1
        if (abs(imgreen(i,j+1)-imgreen(i,j-1))>abs(imgreen(i-1,j)-imgreen(i+1,j)))
            imgreen(i,j)=(imgreen(i-1,j)+imgreen(i+1,j))/2;
        else if (abs(imgreen(i,j+1)-imgreen(i,j-1))<abs(imgreen(i-1,j)-imgreen(i+1,j)))
            imgreen(i,j)= (imgreen(i,j+1)+imgreen(i,j-1))/2;
            else imgreen(i,j)=(imgreen(i,j+1)+imgreen(i,j-1)+imgreen(i-1,j)+imgreen(i+1,j))/4;
            end
        end
    end
end

for i=3:2:h-2
    for j=3:2:w-2
        if (abs(imgreen(i,j+1)-imgreen(i,j-1))>abs(imgreen(i-1,j)-imgreen(i+1,j)))
            imgreen(i,j)=(imgreen(i-1,j)+imgreen(i+1,j))/2;
        else if (abs(imgreen(i,j+1)-imgreen(i,j-1))<abs(imgreen(i-1,j)-imgreen(i+1,j)))
                imgreen(i,j)=(imgreen(i,j+1)+imgreen(i,j-1))/2;
            else imgreen(i,j)=(imgreen(i,j+1)+imgreen(i,j-1)+imgreen(i-1,j)+imgreen(i+1,j))/4;
            end   
        end
    end
end

imgreen=imgreen(2:h-1,2:w-1);


% RED CHANNEL
imred=padarray(imred,[1 1],0,'both');
[h,w]=size(imred);
for i=2:2:h-1
    for j=3:2:w-2
        imred(i,j)=(imred(i,j+1)+imred(i,j-1))/2;
    end
end

for i=3:2:h-2
    for j=2:2:w-1
        imred(i,j)=(imred(i+1,j)+imred(i-1,j))/2;
    end
end

for i=3:2:h-1
    for j=3:2:w-1
        if (abs(imred(i-1,j-1)-imred(i+1,j+1))>abs(imred(i-1,j+1)-imred(i+1,j-1)))
            imred(i,j)=(imred(i-1,j+1)+imred(i+1,j-1))/2;
        else if (abs(imred(i-1,j-1)-imred(i+1,j+1))<abs(imred(i-1,j+1)-imred(i+1,j-1)))
                imred(i,j)=(imred(i+1,j+1)+imred(i-1,j-1))/2;
            else imred(i,j)=(imred(i-1,j-1)+imred(i+1,j+1)+imred(i-1,j+1)+imred(i+1,j-1))/4;
            end
        end
    end
end

imred=imred(2:h-1,2:w-1);


%BLUE CHANNEL
imblue=padarray(imblue,[1 1],0,'both');
[h,w]=size(imblue);

for i=3:2:h-2
    for j=2:2:w-1
        imblue(i,j)=(imblue(i,j-1)+imblue(i,j+1))/2;
    end
end

for i=2:2:h-1
    for j=3:2:w-2
        imblue(i,j)=(imblue(i-1,j)+imblue(i+1,j))/2;
    end
end


for i=2:2:h-1
    for j=2:2:w-1
        if (abs(imblue(i+1,j+1)-imblue(i-1,j-1))>abs(imblue(i-1,j+1)-imblue(i+1,j-1)))
            imblue(i,j)= (imblue(i-1,j+1)+imblue(i+1,j-1))/2;
        else if (abs(imblue(i+1,j+1)-imblue(i-1,j-1))<abs(imblue(i-1,j+1)-imblue(i+1,j-1)))
            imblue(i,j)=(imblue(i+1,j+1)+imblue(i-1,j-1))/2;
            else imblue(i,j)=(imblue(i+1,j+1)+imblue(i-1,j-1)+imblue(i-1,j+1)+imblue(i+1,j-1))/4;
            end
        end
    end
end

imblue=imblue(2:h-1,2:w-1);

mosim=cat(3,imred,imgreen,imblue);


