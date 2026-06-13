function Thermal_Analysis(img)

gray = mean(img,3);

figure;

imagesc(gray);

colormap hot;

colorbar;

title('Thermal Visibility Analysis');

end