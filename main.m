clc; close all; clear all;

%Load Image
image{1} = imread('ship_1.png') ;
% imshow(image{1},[])
% image{1} = single(rgb2gray(image{1}));
% figure,
% imshow(image{1},[])
image{2} = imread('ship_2.png') ;
image{3} = imread('ship_3.png') ;
image{4} = imread('ship_4.png') ;
image{5} = imread('ship_5.png') ;

%Convert images to class single
NumOfImgs = 5;
for id = 1:NumOfImgs
    image{id} = single(rgb2gray(image{id}));
%     figure,
%     imshow(image{id},[])
end

stitchedImage{1} = image{1};
for s_id = 1:(NumOfImgs-1)
    
    img_a = stitchedImage{s_id};
    img_b = image{s_id+1};
    
    subplot((NumOfImgs-1),3,(3*s_id)-2);
    imshow(img_a,[])
    
    subplot((NumOfImgs-1),3,(3*s_id)-1);
    imshow(img_b,[])
    
    returnImage = GetBestAffine(img_a,img_b);
    stitchedImage{s_id+1} = returnImage;
    
    subplot((NumOfImgs-1),3,(3*s_id));
    imshow(returnImage,[]);
    
end