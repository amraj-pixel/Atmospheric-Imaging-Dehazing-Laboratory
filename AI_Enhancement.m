function enhanced = AI_Enhancement(dehazed)

% Simple AI-style enhancement without toolbox

% Increase contrast manually
enhanced = dehazed * 1.2;

% Limit pixel values between 0 and 1
enhanced(enhanced > 1) = 1;

% Simple sharpening kernel
kernel = [0 -1 0;
         -1 5 -1;
          0 -1 0];

% Apply sharpening to each channel
for i = 1:3
    enhanced(:,:,i) = conv2(enhanced(:,:,i), kernel, 'same');
end

% Clamp values again
enhanced(enhanced > 1) = 1;
enhanced(enhanced < 0) = 0;

end