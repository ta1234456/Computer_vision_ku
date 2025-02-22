for i=1:12
filename = ['./' num2str(i) '.jpg'];
  
im = imread(filename);
  
im_hev = rgb2hsv(im);
banana_pixel = find(im_hev(:,:,2) > 0.3);
  
R = double(im(:,:,1));
G = double(im(:,:,2));
B = double(im(:,:,3));


I= R+G+B;
I(I==0)=1;

R_norm = R ./ I;
G_norm = G ./ I;
B_norm = B ./ I;


feature_vector(i,1) = mean(R_norm(banana_pixel));
feature_vector(i,2) = mean(G_norm(banana_pixel));
feature_vector(i,3) = mean(B_norm(banana_pixel));


end
  
Z = linkage(feature_vector, 'complete', 'euclidean');
c = cluster(Z, 'maxclust', 4);
scatter3(feature_vector(:,1), feature_vector(:,2), feature_vector(:,3),240,c,'fill');
xlabel(' R');
ylabel(' G');
zlabel(' B');