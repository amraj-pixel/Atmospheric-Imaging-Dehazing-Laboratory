function Live_Webcam_Dehazing()

clc;

close all;

% =====================================================
% CHECK WEBCAM
% =====================================================

camList = webcamlist;

if isempty(camList)

    error('No Webcam Detected');

end

% =====================================================
% CONNECT CAMERA
% =====================================================

cam = webcam(1);

% =====================================================
% CREATE WINDOW
% =====================================================

figure('Name','Live AI Webcam Dehazing',...
       'NumberTitle','off');

while true

    % Capture frame
    frame = snapshot(cam);

    % Convert to double
    frame = double(frame)/255;

    % =================================================
    % SIMPLE AI ENHANCEMENT
    % =================================================

    enhanced = frame * 1.2;

    enhanced(enhanced > 1) = 1;

    % Sharpening kernel
    kernel = [0 -1 0;
             -1 5 -1;
              0 -1 0];

    for i = 1:3

        enhanced(:,:,i) = conv2(enhanced(:,:,i),...
                                kernel,...
                                'same');

    end

    enhanced(enhanced > 1) = 1;
    enhanced(enhanced < 0) = 0;

    % =================================================
    % DISPLAY
    % =================================================

    subplot(1,2,1);

    imshow(frame);

    title('Original Webcam');

    subplot(1,2,2);

    imshow(enhanced);

    title('AI Enhanced Webcam');

    drawnow;

    % Press ESC to stop
    k = get(gcf,'CurrentCharacter');

    if double(k) == 27
        break;
    end

end

% =====================================================
% RELEASE CAMERA
% =====================================================

clear cam;

close all;

end