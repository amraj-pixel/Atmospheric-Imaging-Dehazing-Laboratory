function scene = Scene_Detection(img)

brightness = mean(img(:));

if brightness < 0.3

    scene = 'Night Scene';

elseif brightness < 0.6

    scene = 'Indoor Scene';

else

    scene = 'Outdoor Scene';

end

end