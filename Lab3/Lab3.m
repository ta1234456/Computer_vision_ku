orignalImage = imread("dark_rays.jpg");
whos("orignalImage")
grayScaleImage= rgb2gray(orignalImage);

B1 = imboxfilt(orignalImage,5);
B2 = imgaussfilt(orignalImage,3);
noisyImage = imnoise(grayScaleImage, 'salt & pepper', 0.02);
B3 = medfilt2(grayScaleImage,[3 5]);

figure;
subplot(1, 4, 1); imshow(orignalImage); title('Original RGB Image');
subplot(1, 4, 2); imshow(B1); title('Smoothed RGB Image (5x5 Box Filter)');
subplot(1, 4, 3); imshow(B2); title('Gaussian Filtering)');
subplot(1, 4, 4); imshow(B3); title('median Filtering)');