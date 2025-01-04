load("scramble_code.mat");
image = imread("scrambled_image.tif");
imshow(image);
imageGrayScale = rgb2gray(image);
imshow(imageGrayScale);
newimage =zeros(909,1170,"uint8");
newimage2 = zeros(909,1170,"uint8");

j=1;
while j <= 909
    newimage(r(1,j),:)=imageGrayScale(j,:);
    j = 1+j;
end
i=1;
while i <= 1170
     newimage2(:,c(1,i))=newimage(:,i);
     i = 1+i;
end
imshow(newimage2);
