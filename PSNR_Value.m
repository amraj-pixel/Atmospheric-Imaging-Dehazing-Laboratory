function psnr_val = PSNR_Value(ref, test)
    ref = im2double(ref);
    test = im2double(test);
    mse = mean((ref(:) - test(:)).^2);
    psnr_val = 10 * log10(1 / mse);
end