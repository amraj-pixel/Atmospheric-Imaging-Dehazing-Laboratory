function t = Transmission_Estimate(I, A)

omega = 0.95;

I_norm = zeros(size(I));
for k = 1:3
    I_norm(:,:,k) = I(:,:,k) ./ A(k);
end

dark_I = Dark_Channel(I_norm);
t = 1 - omega * dark_I;

end
