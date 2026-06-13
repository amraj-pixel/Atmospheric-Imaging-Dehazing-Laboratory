function GUI_Dehazing()

clc;
close all;

% =========================================================
% BACKGROUND COLOR
% =========================================================

bg = [0.92 0.94 0.97];

% =========================================================
% MAIN WINDOW
% =========================================================

f = figure('Name','Atmospheric Imaging & Visibility Laboratory',...
           'NumberTitle','off',...
           'Units','normalized',...
           'OuterPosition',[0 0 1 1],...
           'Color',bg,...
           'MenuBar','none',...
           'ToolBar','none');

% =========================================================
% TITLE
% =========================================================

uicontrol('Style','text',...
          'Units','normalized',...
          'Position',[0.22 0.93 0.55 0.04],...
          'String','ATMOSPHERIC IMAGING & VISIBILITY LABORATORY',...
          'FontSize',22,...
          'FontWeight','bold',...
          'ForegroundColor',[0 0.35 0.8],...
          'BackgroundColor',bg);

% =========================================================
% DATE & TIME
% =========================================================

clock_text = uicontrol('Style','text',...
                       'Units','normalized',...
                       'Position',[0.82 0.94 0.15 0.025],...
                       'String',datestr(now),...
                       'FontSize',11,...
                       'FontWeight','bold',...
                       'ForegroundColor',[0 0.5 0],...
                       'BackgroundColor',bg);

tmr = timer('ExecutionMode','fixedRate',...
            'Period',1,...
            'TimerFcn',@(~,~) updateClock());

start(tmr);

% =========================================================
% BUTTONS
% =========================================================

btnColor = [0 0.45 0.85];

makeButton('Upload',[0.02 0.85 0.08 0.05],btnColor,@upload_callback);
makeButton('Process',[0.12 0.85 0.08 0.05],btnColor,@process_callback);
makeButton('Save',[0.22 0.85 0.08 0.05],btnColor,@save_callback);

makeButton('3D Fog',[0.34 0.85 0.08 0.05],[0.9 0.5 0],@fog3d_callback);
makeButton('Thermal',[0.44 0.85 0.08 0.05],[1 0.4 0.2],@thermal_callback);
makeButton('Particles',[0.54 0.85 0.08 0.05],[0.2 0.7 0.4],@particle_callback);

makeButton('Radar',[0.64 0.85 0.08 0.05],[0 0.5 0.8],@radar_callback);
makeButton('Report',[0.74 0.85 0.08 0.05],[0.7 0.2 0.7],@report_callback);

makeButton('Exit',[0.84 0.85 0.08 0.05],[0.85 0.2 0.2],...
           @(src,event) closeGUI());

% =========================================================
% STATUS
% =========================================================

status_text = uicontrol('Style','text',...
                        'Units','normalized',...
                        'Position',[0.76 0.79 0.20 0.03],...
                        'String','STATUS : WAITING',...
                        'FontSize',14,...
                        'FontWeight','bold',...
                        'ForegroundColor',[0 0.4 0.9],...
                        'BackgroundColor',bg);

% =========================================================
% METRICS
% =========================================================

psnr_text = metricText([0.76 0.74 0.20 0.03],'PSNR : ');
fog_text = metricText([0.76 0.70 0.20 0.03],'Fog Density : ');
scene_text = metricText([0.76 0.66 0.20 0.03],'Scene : ');
visibility_text = metricText([0.76 0.62 0.20 0.03],'Visibility : ');
quality_text = metricText([0.76 0.58 0.20 0.03],'Quality Score : ');
noise_text = metricText([0.76 0.54 0.20 0.03],'Noise Level : ');

% =========================================================
% SCIENTIFIC PANELS
% =========================================================

panel1 = dashboardPanel([0.74 0.48 0.22 0.035],...
                        'Air Quality Index : NORMAL',...
                        [0.1 0.6 0.2]);

panel2 = dashboardPanel([0.74 0.44 0.22 0.035],...
                        'Fog Density Meter : 0%',...
                        [0.85 0.45 0]);

panel3 = dashboardPanel([0.74 0.40 0.22 0.035],...
                        'Environmental Severity : LOW',...
                        [0.2 0.5 0.8]);

panel4 = dashboardPanel([0.74 0.36 0.22 0.035],...
                        'Atmospheric Condition : CLEAR',...
                        [0.5 0.2 0.8]);

panel5 = dashboardPanel([0.74 0.32 0.22 0.035],...
                        'Scientific Noise Meter : NORMAL',...
                        [0.8 0.2 0.2]);

% =========================================================
% AXES
% =========================================================

ax1 = createAxis([0.03 0.54 0.18 0.20],'Hazy Image');
ax2 = createAxis([0.26 0.54 0.18 0.20],'Dark Channel');
ax3 = createAxis([0.49 0.54 0.18 0.20],'Transmission Map');

ax4 = createAxis([0.03 0.29 0.18 0.20],'Refined Transmission');
ax5 = createAxis([0.26 0.29 0.18 0.20],'Haze Thickness');
ax6 = createAxis([0.49 0.29 0.18 0.20],'Enhanced Image');

ax7 = createAxis([0.74 0.18 0.22 0.10],'Histogram Analysis');
ax8 = createAxis([0.74 0.03 0.22 0.10],'Pixel Comparison');

ax9 = createAxis([0.03 0.04 0.18 0.16],'Contrast Enhancement Map');
ax10 = createAxis([0.26 0.04 0.18 0.16],'Scientific Noise Analysis');
ax11 = createAxis([0.49 0.04 0.18 0.16],'Depth Visibility Map');

% =========================================================
% UPLOAD FUNCTION
% =========================================================

    function upload_callback(~,~)

        [file,path] = uigetfile({'*.jpg;*.png;*.bmp'});

        if isequal(file,0)
            return;
        end

        img = double(imread(fullfile(path,file))) / 255;

        setappdata(f,'hazy',img);

        axes(ax1);

        imshow(img);

        title('Hazy Image');

        set(status_text,...
            'String','STATUS : IMAGE UPLOADED');

    end

% =========================================================
% PROCESS FUNCTION
% =========================================================

    function process_callback(~,~)

        if ~isappdata(f,'hazy')

            msgbox('Upload Image First');

            return;

        end

        img = getappdata(f,'hazy');

        % =================================================
        % DARK CHANNEL
        % =================================================

        dark = min(img,[],3);

        % =================================================
        % ATMOSPHERIC LIGHT
        % =================================================

        A = max(img(:));

        % =================================================
        % TRANSMISSION MAP
        % =================================================

        omega = 0.95;

        tmap = 1 - omega * dark;

        % =================================================
        % REFINED TRANSMISSION
        % =================================================

        kernel = [1 2 1;
                  2 4 2;
                  1 2 1]/16;

        refined = conv2(tmap,kernel,'same');

        % =================================================
        % ENHANCED IMAGE
        % =================================================

        enhanced = zeros(size(img));

        for k = 1:3

            enhanced(:,:,k) = ...
                (img(:,:,k)-A) ./ max(refined,0.2) + A;

        end

        enhanced(enhanced>1)=1;
        enhanced(enhanced<0)=0;

        haze = 1 - refined;

        gray1 = mean(img,3);
        gray2 = mean(enhanced,3);

        % =================================================
        % DISPLAY RESULTS
        % =================================================

        axes(ax2);
        imshow(dark);

        axes(ax3);
        imagesc(tmap);
        axis off;
        colormap(ax3,jet);
        colorbar;

        axes(ax4);
        imagesc(refined);
        axis off;
        colormap(ax4,parula);
        colorbar;

        axes(ax5);
        imagesc(haze);
        axis off;
        colormap(ax5,hot);
        colorbar;

        axes(ax6);
        imshow(enhanced);

        % =================================================
        % HISTOGRAM ANALYSIS
        % =================================================

        axes(ax7);

        cla;

        histogram(gray1(:),64,...
                 'FaceColor','red');

        hold on;

        histogram(gray2(:),64,...
                 'FaceColor','blue');

        legend('Hazy','Enhanced');

        hold off;

        % =================================================
        % PIXEL COMPARISON
        % =================================================

        axes(ax8);

        row = round(size(gray1,1)/2);

        plot(gray1(row,:),...
            'r','LineWidth',1.5);

        hold on;

        plot(gray2(row,:),...
            'b','LineWidth',1.5);

        legend('Hazy','Enhanced');

        hold off;

        % =================================================
        % CONTRAST MAP
        % =================================================

        contrast_map = gray2;

        contrast_map = contrast_map - min(contrast_map(:));

        contrast_map = contrast_map ./ max(contrast_map(:));

        axes(ax9);

        imshow(contrast_map);

        % =================================================
        % SCIENTIFIC NOISE ANALYSIS
        % =================================================

        smooth_img = conv2(gray2,...
                           kernel,...
                           'same');

        noise_img = abs(gray2 - smooth_img);

        axes(ax10);

        imagesc(noise_img);

        axis off;

        colormap(ax10,hot);

        colorbar;

        % =================================================
        % DEPTH MAP
        % =================================================

        depth_map = 1 - refined;

        axes(ax11);

        imagesc(depth_map);

        axis off;

        colormap(ax11,jet);

        colorbar;

        % =================================================
        % METRICS
        % =================================================

        mse = mean((gray1(:)-gray2(:)).^2);

        psnr_val = 10*log10(1/mse);

        fog_density = mean(haze(:))*100;

        visibility = round((1-mean(haze(:)))*100);

        quality = round(psnr_val*5);

        noise_level = std(noise_img(:));

        set(psnr_text,...
            'String',['PSNR : ',num2str(psnr_val,3)]);

        set(fog_text,...
            'String',['Fog Density : ',...
            num2str(fog_density,3),' %']);

        set(visibility_text,...
            'String',['Visibility : ',...
            num2str(visibility),' m']);

        set(quality_text,...
            'String',['Quality Score : ',...
            num2str(quality),' %']);

        set(noise_text,...
            'String',['Noise Level : ',...
            num2str(noise_level,3)]);

        % =================================================
        % SCENE DETECTION
        % =================================================

        brightness = mean(img(:));

        if brightness < 0.3

            scene = 'Night';

        elseif brightness < 0.6

            scene = 'Indoor';

        else

            scene = 'Outdoor';

        end

        set(scene_text,...
            'String',['Scene : ',scene]);

        % =================================================
        % DASHBOARD UPDATE
        % =================================================

        set(panel2,...
            'String',['Fog Density Meter : ',...
            num2str(round(fog_density)),'%']);

        if fog_density > 60

            severity = 'HIGH';

        elseif fog_density > 30

            severity = 'MEDIUM';

        else

            severity = 'LOW';

        end

        set(panel3,...
            'String',['Environmental Severity : ',...
            severity]);

        if noise_level < 0.02

            noise_state = 'LOW';

        elseif noise_level < 0.05

            noise_state = 'MEDIUM';

        else

            noise_state = 'HIGH';

        end

        set(panel5,...
            'String',['Scientific Noise Meter : ',...
            noise_state]);

        set(status_text,...
            'String','STATUS : ANALYSIS COMPLETE');

        setappdata(f,'enhanced',enhanced);

    end

% =========================================================
% SAVE FUNCTION
% =========================================================

    function save_callback(~,~)

        if ~isappdata(f,'enhanced')
            return;
        end

        enhanced = getappdata(f,'enhanced');

        [file,path] = uiputfile('output.jpg');

        if isequal(file,0)
            return;
        end

        imwrite(enhanced,...
                fullfile(path,file));

        msgbox('Image Saved Successfully');

    end

% =========================================================
% 3D FOG
% =========================================================

    function fog3d_callback(~,~)

        if ~isappdata(f,'enhanced')
            return;
        end

        enhanced = getappdata(f,'enhanced');

        gray = mean(enhanced,3);

        figure('Color','white');

        surf(gray);

        shading interp;

        colormap jet;

        colorbar;

        title('3D Atmospheric Fog Visualization');

    end

% =========================================================
% THERMAL MAP
% =========================================================

    function thermal_callback(~,~)

        if ~isappdata(f,'enhanced')
            return;
        end

        enhanced = getappdata(f,'enhanced');

        figure('Color','white');

        imagesc(mean(enhanced,3));

        colormap hot;

        colorbar;

        title('Thermal Visibility Analysis');

    end

% =========================================================
% PARTICLES
% =========================================================

    function particle_callback(~,~)

        figure('Color','black');

        for i = 1:80

            scatter(rand(1,250),...
                    rand(1,250),...
                    15,...
                    rand(1,250),...
                    'filled');

            axis([0 1 0 1]);

            title('Atmospheric Particle Simulation',...
                  'Color','white');

            drawnow;

        end

    end

% =========================================================
% RADAR
% =========================================================

    function radar_callback(~,~)

        figure('Color','white');

        theta = linspace(0,2*pi,300);

        rho = abs(sin(4*theta));

        polarplot(theta,rho,...
                 'LineWidth',3);

        title('Atmospheric Radar Scan');

    end

% =========================================================
% REPORT
% =========================================================

    function report_callback(~,~)

        [file,path] = uiputfile('Scientific_Report.txt');

        if isequal(file,0)
            return;
        end

        report = fopen(fullfile(path,file),'w');

        fprintf(report,...
        'ATMOSPHERIC IMAGING REPORT\n');

        fprintf(report,...
        '==========================\n\n');

        fprintf(report,...
        'Scientific Visibility Enhancement Completed\n');

        fprintf(report,...
        'Generated On : %s\n',datestr(now));

        fclose(report);

        msgbox('Scientific Report Exported');

    end

% =========================================================
% CLOCK UPDATE
% =========================================================

    function updateClock()

        if isvalid(clock_text)

            set(clock_text,...
                'String',...
                datestr(now,'dd-mmm-yyyy | HH:MM:SS'));

        end

    end

% =========================================================
% CLOSE GUI
% =========================================================

    function closeGUI()

        try
            stop(tmr);
            delete(tmr);
        end

        delete(f);

    end

end

% =========================================================
% BUTTON FUNCTION
% =========================================================

function makeButton(name,pos,color,callback)

uicontrol('Style','pushbutton',...
          'Units','normalized',...
          'Position',pos,...
          'String',name,...
          'FontSize',12,...
          'FontWeight','bold',...
          'BackgroundColor',color,...
          'ForegroundColor','white',...
          'Callback',callback);

end

% =========================================================
% METRIC TEXT
% =========================================================

function txt = metricText(pos,str)

txt = uicontrol('Style','text',...
                'Units','normalized',...
                'Position',pos,...
                'String',str,...
                'FontSize',11,...
                'FontWeight','bold',...
                'ForegroundColor','black',...
                'BackgroundColor',[0.92 0.94 0.97]);

end

% =========================================================
% DASHBOARD PANEL
% =========================================================

function p = dashboardPanel(pos,str,color)

p = uicontrol('Style','text',...
              'Units','normalized',...
              'Position',pos,...
              'String',str,...
              'FontSize',11,...
              'FontWeight','bold',...
              'ForegroundColor','white',...
              'BackgroundColor',color);

end

% =========================================================
% AXIS FUNCTION
% =========================================================

function ax = createAxis(pos,name)

ax = axes('Units','normalized',...
          'Position',pos);

title(name,'Color','black');

end