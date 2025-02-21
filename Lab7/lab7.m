folderPath = '/Users/mimoais/Downloads/KU /Computer Vision/Lab7/starbucks35_dataset'; 

I = imread('reference_sm.jpg');  % Read the image
grayI = rgb2gray(I);      % Convert to grayscale if needed
points = detectHarrisFeatures(grayI);  % Detect Harris corners
points2 = detectSURFFeatures(grayI);
points3 = detectMSERFeatures(grayI);

inputImage = imread('starbucks35_dataset/21.jpg');
grayInput = rgb2gray(inputImage); 
points4 = detectSURFFeatures(grayInput);
points5 = detectHarrisFeatures(grayInput);
points6 = detectMSERFeatures(grayInput);

%gray ref
[refFeatures,refValidPoints]= extractFeatures(grayI,points2);
[inputFeatures, inputValidPoints] = extractFeatures(grayInput, points4);

indexPairs = matchFeatures(refFeatures, inputFeatures);

matchedRefPoints = refValidPoints(indexPairs(:, 1));
matchedInputPoints = inputValidPoints(indexPairs(:, 2));


figure;
subplot(1, 4, 1); imshow(I);hold on; plot(points.selectStrongest(50));title('HarrisFeatures');
subplot(1, 4, 2); imshow(I);hold on; plot(points2.selectStrongest(50));title('SURFFeatures');
subplot(1, 4, 3); imshow(I);hold on; plot(points3, 'showEllipses', true);title('MSERFeatures');
subplot(1, 4, 4); imshow(inputImage);hold on; plot(points4.selectStrongest(50));title('SURFFeatures');
figure;
subplot(1, 1, 1); showMatchedFeatures(I, inputImage, matchedRefPoints, matchedInputPoints, 'montage');title('Matched SURF Features');


[refFeaturesHarris,refValidPointsHarris]= extractFeatures(grayI,points);
[inputFeaturesHarris, inputValidPointsHarris] = extractFeatures(grayInput, points5);

indexPairsHarris = matchFeatures(refFeaturesHarris, inputFeaturesHarris, 'MatchThreshold', 5);

matchedRefPointsHarris = refValidPointsHarris(indexPairsHarris(:, 1));
matchedInputPointsHarris = inputValidPointsHarris(indexPairsHarris(:, 2));

figure;
subplot(1, 1, 1); showMatchedFeatures(I, inputImage, matchedRefPointsHarris, matchedInputPointsHarris, 'montage');title('Matched Harris Features');



[refFeaturesMSER,refValidPointsMSER]= extractFeatures(grayI,points3);
[inputFeaturesMSER, inputValidPointsMSER] = extractFeatures(grayInput, points6);

indexPairsMSER = matchFeatures(refFeaturesMSER, inputFeaturesMSER, 'MaxRatio', 0.5);

matchedRefPointsMSER= refValidPointsMSER(indexPairsMSER(:, 1));
matchedInputPointsMSER = inputValidPointsMSER(indexPairsMSER(:, 2));

figure;
subplot(1, 1, 1); showMatchedFeatures(I, inputImage, matchedRefPointsMSER, matchedInputPointsMSER, 'montage');title('Matched MSER Features');

