function Fog_Density_3D(haze)

figure;

surf(haze);

shading interp;

colormap jet;

colorbar;

title('3D Atmospheric Fog Density');

end