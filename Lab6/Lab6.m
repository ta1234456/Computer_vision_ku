folderPath = 'F:\GitSourceTree\Computer_vision_ku\Lab6\trainset\trainset'; 
fileType = '*.jpg'; % ตัวอย่างสำหรับไฟล์ภาพ .jpg

% ดึงรายชื่อไฟล์ที่ตรงกับนามสกุลที่ระบุ
fileList = dir(fullfile(folderPath, fileType));
fileCount = numel(fileList);
list_imag={};
GrayImage={};
level={};
binaryImage={};
cleanMask={};
STATS={};
for i = 1:fileCount 
    list_image{i}= imread(fileList(i).folder+"/"+fileList(i).name);
    GrayImage{i}=rgb2gray(list_image{i});
    level{i} = graythresh(list_image{i});
    binaryImage{i} = ~imbinarize(GrayImage{i}, level{i});    
    se = strel('disk', 5);
    cleanMask{i} = imclose(binaryImage{i}, se);
    cleanMask{i} = imfill(cleanMask{i}, 'holes');
    STATS{i} = regionprops(cleanMask{i}, 'Area', 'Perimeter', 'Eccentricity'); 
end



figure;
for i = 1:fileCount
        subplot(5, 5, i);
        imshow(binaryImage{i})
end

figure;
for i = 1:fileCount
        subplot(5, 5, i);
        imshow(cleanMask{i})
end

load('trainLabel.mat'); 
Mdl = fitcecoc(X,trainLabel) ;
load('testLabel.mat'); 
predictedLabels = predict(Mdl,XTest); 
table(testLabel(:),predictedLabels (:),'VariableNames',{'TrueLabels','PredictedLabels'}); 