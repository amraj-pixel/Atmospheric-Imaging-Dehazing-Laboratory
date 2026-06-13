clc;
clear;
close all;

% ---------------- READ HAZY IMAGE ----------------
hazy_image = double(imread('indoor_hazy.jpg')) / 255;

% ---------------- DEHAZING PIPELINE ----------------

% Dark Channel
J_dark = Dark_Channel(hazy_image);

% Atmospheric Light
A = Estimating_Atmospheric_Light(hazy_image, J_dark);

% Transmission Estimate
t = Transmission_Estimate(hazy_image, A);

% Guided Filter Refinement
window_size = 15;
eps = 1e-3;

t_refined = Guided_Filter(hazy_image, t, window_size, eps);

% Recover Scene Radiance
J = Recovering_Scene_Radiance(hazy_image, A, t_refined);

% ---------------- AI ENHANCEMENT ----------------
J_AI = AI_Enhancement(J);

% ---------------- HAZE THICKNESS MAP ----------------
haze_thickness = 1 - t_refined;

% ---------------- ADDITIONAL ANALYSIS ----------------

% Depth Map
depth = Depth_Map(t_refined);

% Contrast Map
contrast = Contrast_Map(J_AI);

% ---------------- QUALITY METRICS ----------------

% Convert to grayscale manually
ref_gray = mean(hazy_image,3);
J_gray   = mean(J_AI,3);

% PSNR
psnr_val = PSNR_Value(J_gray, ref_gray);

% FID
fid_val = FID_Simple(ref_gray, J_gray);

disp('----------------------------------------');
disp('AI ASSISTED IMAGE DEHAZING RESULTS');
disp('----------------------------------------');

disp(['PSNR = ', num2str(psnr_val), ' dB']);
disp(['FID  = ', num2str(fid_val)]);

% ---------------- FIGURE 1 : PIPELINE ----------------

figure('Name','AI-Assisted Dehazing Pipeline','NumberTitle','off');

subplot(2,3,1);
image(hazy_image);
axis image off
title('Hazy Image');

subplot(2,3,2);
image(J_dark);
axis image off
title('Dark Channel');

subplot(2,3,3);
imagesc(t);
axis image off
title('Transmission Map');

subplot(2,3,4);
imagesc(t_refined);
axis image off
title('Refined Transmission');

subplot(2,3,5);
imagesc(haze_thickness);
axis image off
title('Haze Thickness Map');

subplot(2,3,6);
image(J_AI);
axis image off
title('AI Enhanced Image');

colormap gray;

% ---------------- FIGURE 2 : ANALYSIS ----------------

figure('Name','Analysis Results','NumberTitle','off');

subplot(1,4,1);
imagesc(depth);
axis image off
title('Depth Map');

subplot(1,4,2);
imagesc(contrast);
axis image off
title('Contrast Map');

subplot(1,4,3);
image(J);
axis image off
title('Dehazed Image');

subplot(1,4,4);
image(J_AI);
axis image off
title('AI Enhanced Image');

colormap gray;

% ---------------- HISTOGRAM COMPARISON ----------------

figure('Name','Histogram Comparison','NumberTitle','off');

gray1 = mean(hazy_image,3);
gray2 = mean(J_AI,3);

subplot(1,2,1);
histogram(gray1(:),256);
title('Hazy Image Histogram');

subplot(1,2,2);
histogram(gray2(:),256);
title('AI Enhanced Histogram');

% ---------------- PIXEL VALUE GRAPH ----------------

Pixel_Value_Graph('indoor_hazy.jpg', J_AI);

% ---------------- EXECUTION TIME ----------------

tic;

execution_time = toc;

disp(['Execution Time = ', num2str(execution_time), ' seconds']);

disp('----------------------------------------');
disp('PROCESS COMPLETED SUCCESSFULLY');
disp('----------------------------------------');