function resizeimgs

mkdir('../myCamVid/data/images');
imdir='../myCamVid/data/rawimage';
outdir='../myCamVid/data/images';
% out2dir='../0016E5/data/othersimages';
imagedir=dir([imdir,'/*.png']);
% cellnames=importdata('../0006R0/framenames.txt');
for iter=1:size(imagedir,1)
    imagename=imagedir(iter).name;
    im=imread([imdir,'/',imagename]);
    if ~isempty(strfind(imagename,'01TP_extract.avi_'))
        filename=regexprep(imagename,'01TP_extract.avi_00', '001TP_');
    else
        if ~isempty(strfind(imagename,'0005VD.MXF_'))
            filename=regexprep(imagename,'0005VD.MXF_0', 'Seq05VD_f');
        else
            if ~isempty(strfind(imagename,'0006R0.MXF_'))
                filename=regexprep(imagename,'0006R0.MXF_0', '0006R0_f');
            else
                if ~isempty(strfind(imagename,'0016E5.MXF_'))
                    filename=regexprep(imagename,'0016E5.MXF_0', '0016E5_');
                end
            end
        end
    end
    finalimage=imresize(im,[240,320],'bicubic');
    imwrite(finalimage,[outdir,'/', filename],'png');
    fprintf('Image %u finished...named %s ...\n',iter,imagename);
end