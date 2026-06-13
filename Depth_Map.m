function depth = Depth_Map(t)

t = max(t, 0.1);

depth = -log(t);

% ---- replace mat2gray ----
minv = min(depth(:));
maxv = max(depth(:));

depth = (depth - minv) / (maxv - minv + eps);

end
