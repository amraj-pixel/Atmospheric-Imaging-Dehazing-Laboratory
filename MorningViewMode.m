function MorningViewMode()
clc; clear;

% Input / output folders
input_folder = fullfile('Image_Set','Input_Hazy_Images');
output_folder = fullfile('Image_Set','Results');

% Create results folder if it does not exist
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

% Read all images from input folder
files = dir(fullfile(input_folder,'*.jpg')); % can add *.png etc.

for f = 1:length(files)
    filename = files(f).name;
    hazy_image = im2double(imread(fullfile(input_folder, filename)));
    
    % Dark channel
    J_dark = Dark_Channel(hazy_image);
    
    % Atmospheric light
    A = Estimating_Atmospheric_Light(hazy_image, J_dark);
    
    % Transmission
    t = Transmission_Estimate(hazy_image, A);
    
    % Refine transmission
    window_size = 15;
    eps = 1e-3;
    t_refined = Guided_Filter(hazy_image, t, window_size, eps);
    
    % Recover radiance
    J = Recovering_Scene_Radiance(hazy_image, A, t_refined);
    
    % Save results
    [~, name, ext] = fileparts(filename);
    out_file = fullfile(output_folder, [name '_dehazed' ext]);
    imwrite(J, out_file);
    
    fprintf('Processed: %s\n', filename);
end

disp('All images processed. Results saved in Image_Set/Results.');
end