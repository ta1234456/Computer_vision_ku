load('scramble_code.mat');
scrambledImage = imread('scrambled_image.tif');

[rows, cols, channels] = size(scrambledImage);
decodedImage = zeros(rows, cols, channels, 'uint8');

for channel = 1:channels
    decodedImage(r, c, channel) = scrambledImage(:, :, channel);
end

imshow(decodedImage);