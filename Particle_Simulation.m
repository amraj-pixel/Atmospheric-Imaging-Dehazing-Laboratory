function Particle_Simulation()

figure;

for i = 1:100

    scatter(rand(1,200),rand(1,200),10,'filled');

    axis([0 1 0 1]);

    title('Atmospheric Particle Simulation');

    drawnow;

end

end