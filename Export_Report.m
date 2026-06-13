function Export_Report(psnr,fid,time,scene,visibility)

[file,path] = uiputfile('Scientific_Report.txt');

if isequal(file,0)
    return;
end

report = fopen(fullfile(path,file),'w');

fprintf(report,...
    'AI BASED ATMOSPHERIC VISIBILITY REPORT\n');

fprintf(report,...
    '=====================================\n\n');

fprintf(report,'PSNR : %.2f\n',psnr);

fprintf(report,'FID : %.2f\n',fid);

fprintf(report,'Execution Time : %.2f sec\n',time);

fprintf(report,'Scene Type : %s\n',scene);

fprintf(report,'Visibility : %d meters\n',visibility);

fclose(report);

msgbox('Scientific Report Exported');

end