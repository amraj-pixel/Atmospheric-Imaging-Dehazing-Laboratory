function Pixel_Value_Graph(indoor_hazy, J)

    % Read image if filename is given
    if ischar(indoor_hazy)
        I = imread(indoor_hazy);
    else
        I = indoor_hazy;
    end

    % Convert to grayscale safely
    if size(I,3) == 3
        hazy_gray = rgb2gray(I);
    else
        hazy_gray = I;
    end

    if size(J,3) == 3
        J_gray = rgb2gray(J);
    else
        J_gray = J;
    end

    % Select middle row
    row = round(size(hazy_gray,1)/2);

    % Plot pixel intensity
    figure('Name','Pixel Intensity Comparison','NumberTitle','off');

    plot(hazy_gray(row,:), 'LineWidth',1.5);
    hold on;
    plot(J_gray(row,:), 'LineWidth',1.5);

    legend('Hazy Image','Dehazed Image');
    title('Pixel Intensity Comparison (Middle Row)');
    xlabel('Pixel Position');
    ylabel('Intensity Value');
    grid on;

end