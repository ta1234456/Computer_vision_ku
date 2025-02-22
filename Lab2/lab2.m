Image = imread('chest.jpg');

grayImage = rgb2gray(Image);
sigma = 2; 

% B2 = imgaussfilt(noiseImage, sigma);
pic1 = imadjust(grayImage, [0.2,0.8], [0.0, 1.0]);

pic2 = histeq(pic1);

pic3 = adapthisteq(grayImage,'clipLimit',0.04);
pic4 = imadjust(grayImage, [20/255, 130/255], [0, 1]);



subplot(1,4,1); imshow(Image);  title('Original Image');
subplot(1,4,2); imshow(pic2);
subplot(1,4,3); imshow(pic3);
subplot(1,4,4); imshow(pic4);
