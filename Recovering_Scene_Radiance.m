function J = Recovering_Scene_Radiance(I, A, t)

t0 = 0.1;
t = max(t, t0);

J = zeros(size(I));

for k = 1:3
    J(:,:,k) = (I(:,:,k) - A(k)) ./ t + A(k);
end

J = max(min(J,1),0);

end
