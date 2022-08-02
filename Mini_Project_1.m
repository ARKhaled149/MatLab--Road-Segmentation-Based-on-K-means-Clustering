clc
clear all
close all
warning off
rgbImage = imread("4.jpg");
figure(1);
imshow(rgbImage);
title("Original Image");
sizeimg = size(rgbImage);

% Cropping the image for the road section
number_of_clusters = 4;
crop_img = rgbImage(143:286,:,:);
figure(3);
imshow(crop_img);
title("Crop Image");

test1(crop_img,number_of_clusters);

% Kmeans Clustering Function
function test1(rgbImage,number_of_clusters)
    redChannel=rgbImage(:, :, 1);
    greenChannel=rgbImage(:, :, 2);
    blueChannel=rgbImage(:, :, 3);
    data = double([redChannel(:), greenChannel(:), blueChannel(:)]);
    numberOfClasses = number_of_clusters;
    C = [100 100 100 ;128 128 128 ;175 175 175 ;255 255 255];
    [m n] = kmeans(data,numberOfClasses,'Start',C);
    m = reshape(m,size(rgbImage,1),size(rgbImage,2));
    n = n/255;
    clusteredImage = m*(255/max(m(:)));
    figure(2);
    imshow(uint8(clusteredImage));
    title("Clustered Image 1");
    
%     Mode the image to find the most common/present value
    cro = modefilt(clusteredImage);
    figure(4);
    imshow(uint8(cro));
    title("Cropped Image");
    kk = zeros(size(cro));
    vv = mode(clusteredImage(:));
    kk(cro==vv) = 255;
    figure(5);
    imshow(kk);
    title("Post Processing");
    
%   Median Filter Step predefined because my function is used on rgb so outputs errors in channels
    filter_size = 5;
    finalout = medfilt2(kk,[filter_size filter_size]);
%     finalout = medianfilter(filter_size, kk);
    figure(6);
    imshow(finalout);
    title("Median Filter");

end

function AfterFilter = medianfilter(s,A)
    r=A(:,:,1);
    g=A(:,:,2);
    b=A(:,:,3);
    [h w]=size(r);
    s2=(s+1)/2;
    s3=s2-1;
    for n=s2:h-s3
        for m=s2:w-s3
            r1=r(n-s3:n+s3,m-s3:m+s3,:);
            med=median(median(r1));
            r(n:n,m:m,:)=med;
            g1=g(n-s3:n+s3,m-s3:m+s3,:);
            med=median(median(g1));
            g(n:n,m:m,:)=med;
            b1=b(n-s3:n+s3,m-s3:m+s3,:);
            med=median(median(b1));
            b(n:n,m:m,:)=med;
        end
    end
    AfterFilter=cat(3,r,g,b);
end


