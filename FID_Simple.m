function fid = FID_Simple(img1, img2)
    m1 = mean(img1(:));  m2 = mean(img2(:));
    v1 = var(img1(:));   v2 = var(img2(:));
    fid = (m1 - m2)^2 + v1 + v2 - 2*sqrt(v1*v2);
end