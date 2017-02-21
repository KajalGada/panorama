function [returnAffine, returnImage] = GetBestAffine(image1,image2)
%ENPM808T Assignment 2 Q10

%Read images
Ia = image1 ;
Ib = image2 ;

%Compute SIFT frames(keypoints) and descriptors
[fa, da] = vl_sift(Ia);
[fb, db] = vl_sift(Ib);

%Best Match for descriptors from img2 in img1
[ma,na] = size(da);
[mb,nb] = size(db);
k = 1;

SSD_VALs = [];
for i=1:nb
    local_ssd = [];
    for j=1:na
        local_ssd = [local_ssd; sqrt(sum((da(:,j) - db(:,i)) .^ 2)), j];
    end
    sorted_local_ssd = sortrows(local_ssd);
    SSD_VALs = [SSD_VALs; i, sorted_local_ssd(1,:)];
end

SSD_sorted = sortrows(SSD_VALs,2);

all_data = [];
for ssd_id = 1:size(SSD_sorted,1)
    fa_id = SSD_sorted(ssd_id, 3);
    fb_id = SSD_sorted(ssd_id, 1);
    score = SSD_sorted(ssd_id, 2);
    all_data = [all_data; fa(1,fa_id), fa(2,fa_id), fb(1, fb_id),...
                                                    fb(2, fb_id), score];
end
all_data; %[img1_x, img1_y, img2_x, img2_y, score/ssd_value];
top_matches = all_data(1:20,:);

RANSAC_ANS = [];

for i=1:1000
    
    %Part(a)
    r1 = randi([1, 20]); 
    r2 = randi([1, 20]); 
    r3 = randi([1, 20]); 
    
    p1 = [all_data(r1,1), all_data(r2,1), all_data(r3,1);...
                all_data(r1,2), all_data(r2,2), all_data(r3,2)];
    p2 = [all_data(r1,3), all_data(r2,3), all_data(r3,3);...
                all_data(r1,4), all_data(r2,4), all_data(r3,4)];
    
    %Part(b)
    A = affine_transformation(p2,p1);

    %Part(c)to(f)
    count = 0;
    for aid = 1:20%size(top_matches,1)
        affine_points = A * [top_matches(aid,3:4) 1]';
        image_1_points = top_matches(aid,1:2);
        dist = sqrt((affine_points(1)-image_1_points(1))^2 + ...
                           (affine_points(2)-image_1_points(2))^2);
        if dist < 2
            count = count + 1;
        end
    end
    
    RANSAC_ANS = [RANSAC_ANS; i count A(1,:) A(2,:)];
    
end

RANSAC_ANS_SORTED = flipud(sortrows(RANSAC_ANS,2));
T = [RANSAC_ANS_SORTED(1,3:5); RANSAC_ANS_SORTED(1,6:8)];
result_stitch = stitch(Ia, Ib, T);
returnImage = result_stitch;
returnAffine = T;
end
