 folderPath = 'lymphomalplzhang03_shade.jpg';
 tempIm = imread(folderPath);
 imGrayScale = rgb2gray(tempIm);

 filterSize = 601; 
 filteredImage = imboxfilt(imGrayScale, filterSize);
 DfilteredImage= double(filteredImage);
 DimGrayScale = double(imGrayScale);

 tempImTh= DimGrayScale./DfilteredImage;

figure;
subplot(3, 3, 1); imshow(tempIm);title('Input Image');
subplot(3, 3, 2); imshow(imGrayScale,[]);title('Gray Scale');
subplot(3, 3, 3); imshow(DfilteredImage,[]);title('Smoothing');
subplot(3, 3, 4); imshow(tempImTh,[]);title('Thresholding');
subplot(3, 3, 5); imshow(BW,[]);title('segment result');