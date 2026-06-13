function A = Estimating_Atmospheric_Light(I, J_dark)

I = im2double(I);
[r,c,~] = size(I);

num_pixels = max(1, floor(0.001 * r * c));

J_vec = J_dark(:);
[~, idx] = sort(J_vec, 'descend');

I_vec = reshape(I, [], 3);
A = max(I_vec(idx(1:num_pixels), :), [], 1);

end
