function q = Guided_Filter(I, p, r, eps)

I = im2double(I);
p = im2double(p);

I_gray = mean(I,3);   % no rgb2gray (toolbox-free)

kernel = ones(r) / (r*r);

mean_I  = conv2(I_gray, kernel, 'same');
mean_p  = conv2(p, kernel, 'same');
mean_Ip = conv2(I_gray .* p, kernel, 'same');

cov_Ip = mean_Ip - mean_I .* mean_p;

mean_II = conv2(I_gray .* I_gray, kernel, 'same');
var_I   = mean_II - mean_I .* mean_I;

a = cov_Ip ./ (var_I + eps);
b = mean_p - a .* mean_I;

mean_a = conv2(a, kernel, 'same');
mean_b = conv2(b, kernel, 'same');

q = mean_a .* I_gray + mean_b;

end
