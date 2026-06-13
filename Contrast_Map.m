function contrast = Contrast_Map(I)

I = im2double(I);

% ---- replace rgb2gray ----
if size(I,3) == 3
    gray = 0.2989*I(:,:,1) + 0.5870*I(:,:,2) + 0.1140*I(:,:,3);
else
    gray = I;
end

% window size
w = 5;
kernel = ones(w,w)/(w*w);

% local mean
meanI = conv2(gray, kernel, 'same');

% local mean of squares
meanI2 = conv2(gray.^2, kernel, 'same');

% local variance
varI = meanI2 - meanI.^2;

% numerical safety
varI(varI < 0) = 0;

% standard deviation
contrast = sqrt(varI);

% ---- replace mat2gray ----
minv = min(contrast(:));
maxv = max(contrast(:));
contrast = (contrast - minv) / (maxv - minv + eps);

end
