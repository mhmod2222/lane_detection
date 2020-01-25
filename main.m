close;clear;clc;

I = imread('Figure1a.jpg');
% this reads the original image

%---------------------------------------
%---------------------------------------
 bin = im2bw(I, 0.7);
% 0.69 is a luminance value and takes values from 0 to 1
% the value is chosen according to quality of output image
% im2bw changes rgb image to black and white image
imshow(I), title('Original') %this command shows images

%---------------------------------------
%---------------------------------------
bin2 = imdilate(bin,strel('line',2,0));
% strel: line --> is to tell the dilation function it is about to dilate a line
% 3: is the required dilation thickness, original thickness is 1
% 0: is the angle of dialtion, if 90 degs is chosed the dialted lines will be perpindicular on the road
% while 0 degree dialted lines while be tangent and colinear with the road
%figure(2), imshow(bin2), title('Dilated')

%---------------------------------------
%---------------------------------------
bin3 = bwmorph(bin2,'thin',inf);
% bwmorph: this function does morphing to shapes in images here we use it to make lines thinner
% inf is somehow a degree of thinning
%figure(3), imshow(bin3), title('Thinned')

%---------------------------------------
%---------------------------------------
% Hough

% hough is based on 3 steps

%--> first step is to transform the black white color after thinning to its hough transform
[H,theta,rho] = hough(bin3);
%figure(4), imshow(H,[],'XData',theta,'YData',rho,'InitialMagnification','fit');
xlabel('\theta'), ylabel('\rho');
axis on, axis normal, hold on;

%--> second step is to find the peak points (white points) on the hough transform which shouldbe our lines
pek  = houghpeaks(H,5,'threshold',ceil(0.3*max(H(:))));
x = theta(pek(:,2)); y = rho(pek(:,1));
%plot(x,y,'s','color','white');

%--> third step is to use the peak points in hough so that lines in the black white pic can be detected when we reverse the hough transform
lines = houghlines(bin3,theta,rho,pek,'FillGap',5,'MinLength',7);
%figure(5), imshow(bin3), title('Driving Pathes') ,hold on
max_len = 0;
xy(:,:,1) = zeros(2);
for k = 1:length(lines)
   xy(:,:,k) = [lines(k).point1; lines(k).point2];
   plot(xy(:,1,k),xy(:,2,k),'LineWidth',2,'Color','green');
end


