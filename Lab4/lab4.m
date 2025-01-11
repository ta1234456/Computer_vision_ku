folderPath = '/Users/mimoais/Downloads/KU /Computer Vision/Lab4/lab4-images'; 
fileType = '*.jpg'; % ตัวอย่างสำหรับไฟล์ภาพ .jpg

% ดึงรายชื่อไฟล์ที่ตรงกับนามสกุลที่ระบุ
fileList = dir(fullfile(folderPath, fileType));
fileCount = numel(fileList);
for i = 1:fileCount 
    tempim = imread(fileList(i).folder+"/"+fileList(i).name);
    im_hsv = rgb2hsv(tempim);
    bananaPixel = find(im_hsv(:,:,2) > 0.3 | im_hsv(:,:,2) <= 0.3);
    R = tempim(:,:,1); G = tempim(:,:,2); B = tempim(:,:,3);
    feature_vector(i,1) = mean(R(bananaPixel));
    feature_vector(i,2) = mean(G(bananaPixel));
    feature_vector(i,3) = mean(B(bananaPixel));
end
Z = linkage(feature_vector, 'complete', 'euclidean'); 
c = cluster(Z, 'maxclust', 4); 
scatter3(feature_vector(:,1), feature_vector(:,2), feature_vector(:,3),240,c,'fill');