function [imShift, predShift] = alignChannels(im, maxShift)
% ALIGNCHANNELS align channels in an image.
%   [IMSHIFT, PREDSHIFT] = ALIGNCHANNELS(IM, MAXSHIFT) aligns the channels in an
%   NxMx3 image IM. The first channel is fixed and the remaining channels
%   are aligned to it within the maximum displacement range of MAXSHIFT (in
%   both directions). The code returns the aligned image IMSHIFT after
%   performing this alignment. The optimal shifts are returned as in
%   PREDSHIFT a 2x2 array. PREDSHIFT(1,:) is the shifts  in I (the first) 
%   and J (the second) dimension of the second channel, and PREDSHIFT(2,:)
%   are the same for the third channel.


% Sanity check
assert(size(im,3) == 3);
assert(all(maxShift > 0));

%Split into r, g, b channels
imred=im(:,:,1);
imgreen=im(:,:,2);
imblue=im(:,:,3);

% imred1=imred;
% imblue1=imblue;
% imgreen1=imgreen;

%Computing edge intensity image(extra credit)
imred1=edge(imred,'Canny');
imgreen1=edge(imgreen,'Canny');
imblue1=edge(imblue,'Canny');


%Calculating offset for Red and Green Channels
c1=normxcorr2(imred1,imgreen1);
[ypeak1, xpeak1] = find(c1==max(c1(:)));
yoffset1=-(ypeak1-size(imgreen1,1));
xoffset1=-(xpeak1-size(imgreen1,2));
offset1= [yoffset1, xoffset1];

%Calculating offset for Red and Blue Channels
c2=normxcorr2(imred1,imblue1);
[ypeak2, xpeak2] = find(c2==max(c2(:)));
yoffset2=-(ypeak2-size(imblue1,1));
xoffset2=-(xpeak2-size(imblue1,2));
offset2= [yoffset2, xoffset2];
    
%Calculate predicted shift
predShift=[offset1; offset2];

%Shift the channels
imgreen=circshift(imgreen,offset1);
imblue=circshift(imblue,offset2);

%Concatenate the image
imShift = cat(3,imred,imgreen,imblue);



