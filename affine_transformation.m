function Z = affine_transformation(m1,m2)
m1 = [m1; 1 1 1];
Z = m2*inv(m1);
end