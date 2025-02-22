folderPath = 'F:\GitSourceTree\Computer_vision_ku\Lab7\starbucks35_dataset'; 
fileType = '*.jpg'; % ตัวอย่างสำหรับไฟล์ภาพ .jpg
fileList = dir(fullfile(folderPath, fileType));
fileCount = numel(fileList);


I_ref = imread('reference_sm.jpg');  % Read the image
grayI_ref = rgb2gray(I_ref);      % Convert to grayscale if needed
HarrispointRef = detectHarrisFeatures(grayI_ref);  % Detect Harris corners
SURFFpointRef = detectSURFFeatures(grayI_ref);
MSERpointsRef = detectMSERFeatures(grayI_ref);

[refFeaturesHarris, refValidPointsHarris] = extractFeatures(grayI_ref, HarrispointRef);
[refFeaturesSURFF, refValidPointsSURFF] = extractFeatures(grayI_ref, SURFFpointRef);
[refFeaturesMSER, refValidPointsMSER] = extractFeatures(grayI_ref, MSERpointsRef);
k=0;
figure;
for i = 1:fileCount 
    list_image= imread(fileList(1).folder+"/"+fileList(i).name);
    grayImageInput=rgb2gray(list_image); 
    HarrispointsInput= detectHarrisFeatures(grayImageInput);
    SURFFpoints= detectSURFFeatures(grayImageInput);
    MSERpoints= detectMSERFeatures(grayImageInput);

    [inputFeaturesHarris, inputValidPointsHarris] = extractFeatures(grayImageInput, HarrispointsInput);
    indexPairsHarris = matchFeatures(refFeaturesHarris, inputFeaturesHarris, 'Method','Threshold','MatchThreshold', 20);
    matchedPointsHarrisRef = refValidPointsHarris(indexPairsHarris(:, 1)); 
    matchedPointsHarrisInput = inputValidPointsHarris(indexPairsHarris(:, 2)); 

    [inputFeaturesSURFF, inputValidPointsSURFF] = extractFeatures(grayImageInput, SURFFpoints);
    indexPairsSURFF = matchFeatures(refFeaturesSURFF, inputFeaturesSURFF);
    matchedPointsSURFFRef = refValidPointsSURFF(indexPairsSURFF(:, 1)); 
    matchedPointsSURFFInput = inputValidPointsSURFF(indexPairsSURFF(:, 2));

    [inputFeaturesMSER, inputValidPointsMSER] = extractFeatures(grayImageInput, MSERpoints);
    indexPairsMSER= matchFeatures(refFeaturesMSER, inputFeaturesMSER,'Method','NearestNeighborRatio', 'MatchThreshold', 4, 'MaxRatio', 0.6);
    matchedPointsMSERRef = refValidPointsMSER(indexPairsMSER(:, 1)); 
    matchedPointsMSERInput = inputValidPointsMSER(indexPairsMSER(:, 2));
    figure
    for j= 1:3
        if j==1 
            subplot(1, 3,1); showMatchedFeatures(I_ref, list_image, matchedPointsHarrisRef, matchedPointsHarrisInput, 'montage');title('Harris');
        elseif j==2 
            subplot(1, 3,2); showMatchedFeatures(I_ref, list_image, matchedPointsSURFFRef, matchedPointsSURFFInput, 'montage');title('SURFF');
        else
            subplot(1, 3,3); showMatchedFeatures(I_ref, list_image, matchedPointsMSERRef, matchedPointsMSERInput, 'montage');title('MSER');
        end 
    end
    k=k+1;
end


