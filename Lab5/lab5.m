RGB = imread('lymphomalplzhang03_shade.jpg');   % Read RGB image
R = rgb2gray(RGB);           % Convert to grayscale
imshow(R);                   % Display grayscale image


 filterSize = 1025; 
 filteredImage = imboxfilt(R, filterSize);
 DfilteredImage= double(filteredImage);
 DimGrayScale = double(imGrayScale);

 tempImTh= DimGrayScale./DfilteredImage;
 level = graythresh(tempImTh); 
 BW = imbinarize(tempImTh, level);
 BW1 =~BW;
 % BW=drawBoundary(BW1,50);

figure;
subplot(3, 3, 1); imshow(tempIm);title('Input Image');
subplot(3, 3, 2); imshow(imGrayScale,[]);title('Gray Scale');
subplot(3, 3, 3); imshow(DfilteredImage,[]);title('Smoothing');
subplot(3, 3, 4); imshow(BW1,[]);title('Thresholding');
subplot(3, 3, 5); imshow(BW);title('segment result');


