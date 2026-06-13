function J_dark = Dark_Channel(I)

I = im2double(I);

% Step 1: min over RGB
J = min(I, [], 3);

patch = 7;
pad = floor(patch/2);

[r,c] = size(J);

% -------- Manual replicate padding (FAST) ----------
Jpad = zeros(r+2*pad, c+2*pad);

% center
Jpad(pad+1:pad+r, pad+1:pad+c) = J;

% top & bottom
Jpad(1:pad, pad+1:pad+c) = repmat(J(1,:), pad,1);
Jpad(pad+r+1:end, pad+1:pad+c) = repmat(J(end,:), pad,1);

% left & right
Jpad(:,1:pad) = repmat(Jpad(:,pad+1),1,pad);
Jpad(:,pad+c+1:end) = repmat(Jpad(:,pad+c),1,pad);

% -------- FAST MIN FILTER (O(N)) ----------
% horizontal pass
for i = 1:size(Jpad,1)
    Jpad(i,:) = movmin(Jpad(i,:), patch);
end

% vertical pass
for j = 1:size(Jpad,2)
    Jpad(:,j) = movmin(Jpad(:,j), patch);
end

% remove padding
J_dark = Jpad(pad+1:pad+r, pad+1:pad+c);

end
