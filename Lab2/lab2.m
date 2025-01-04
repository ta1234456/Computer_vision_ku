imageOriginal = imread("chest.jpg");
whos("imageOriginal")
imageGrayScale = rgb2gray(imageOriginal);
enhancedImage = histeq(imageGrayScale);
adapthisteqImage=adapthisteq(imageGrayScale);
imageAdjust=imadjust(imageGrayScale,[0.0,0.7],[0.4,0.8]);
figure;
subplot(2, 2, 1); imshow(imageGrayScale);title('Original Grayscale Image');
subplot(2, 2, 2); imshow(enhancedImage);title('histeq');
subplot(2, 2, 3); imshow(adapthisteqImage);title('adapthisteq');
subplot(2, 2, 4); imshow(imageAdjust);title('Adjust');