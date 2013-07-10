function renameimages

imagedir='/home/bliu/Desktop/tem/myCamVid/data/rawimages/';
labeldir='/home/bliu/Desktop/tem/CamVid/data/labels/';
mkdir('../myCamVid/data/labels');
mkdir('../myCamVid/data/images');
imdir=dir([imagedir,'*.png']);
% ladir=dir([labeldir,'*.txt']);
for iter=1:size(imdir,1)
    imagename=imdir(iter).name;
%     im=imread([imagedir,imagename]);
%     finalimage=imresize(im,[240,320],'bicubic');
    if ~isempty(strfind(imagename,'01TP_extract.avi_'))
        str1=regexprep(imagename,'01TP_extract.avi_00', '001TP_');
        str1=regexprep(str1,'.png','');
        
        str2=regexprep(imagename,'01TP_extract.avi_00','');
        str2=regexprep(str2,'.png','');
        
        res=sprintf('%03d',str2num(str2)/30);
        
        labelname=['001TP_',res,'.txt'];
        labelmat=importdata([labeldir,'/',labelname]);
        
        textname=regexprep(regexprep(imagename,'01TP_extract.avi_00', '001TP_'),'.png','.txt');
        dlmwrite(textname,labelmat,'delimiter',' ');
        movefile(textname,'../myCamVid/data/labels/');
        
%         resultname=regexprep(regexprep(imagename,'01TP_extract.avi_00', '001TP_'),'.png','.mat');
%         save(['../myCamVid/data/labels/',resultname],'labelmat');
%         
%         resultname=regexprep(resultname,'mat','png');
%         imwrite(finalimage,['../myCamVid/data/images/',resultname],'png');
    else
        if ~isempty(strfind(imagename,'0005VD.MXF_'))
            str1=regexprep(imagename,'0005VD.MXF_0', 'Seq05VD_f');
            str1=regexprep(str1,'.png','.txt');
            
            labelmat=importdata([labeldir,'/',str1]);
%             resultname=regexprep(regexprep(imagename,'0005VD.MXF_0', 'Seq05VD_f'),'.png','.mat');
%             save(['../myCamVid/data/labels/',resultname],'labelmat');
%             resultname=regexprep(resultname,'mat','png');
%             imwrite(finalimage,['../myCamVid/data/images/',resultname],'png');
            
            textname=regexprep(regexprep(imagename,'0005VD.MXF_0', 'Seq05VD_f'),'.png','.txt');
            dlmwrite(textname,labelmat,'delimiter',' ');
            movefile(textname,'../myCamVid/data/labels/');
        else
            if ~isempty(strfind(imagename,'0006R0.MXF_'))
                str1=regexprep(imagename,'0006R0.MXF_0', '0006R0_f');
                str1=regexprep(str1,'.png','.txt');
            
                labelmat=importdata([labeldir,'/',str1]);
%                 resultname=regexprep(regexprep(imagename,'0006R0.MXF_0','0006R0_f'),'.png','.mat');
%                 save(['../myCamVid/data/labels/',resultname],'labelmat');
%                 resultname=regexprep(resultname,'mat','png');
%                 imwrite(finalimage,['../myCamVid/data/images/',resultname],'png'); 
                
                textname=regexprep(regexprep(imagename,'0006R0.MXF_0','0006R0_f'),'.png','.txt');
                dlmwrite(textname,labelmat,'delimiter',' ');
                movefile(textname,'../myCamVid/data/labels/');      
            else
                if ~isempty(strfind(imagename,'0016E5.MXF_'))
                    str1=regexprep(imagename,'0016E5.MXF_0', '0016E5_');
                    str1=regexprep(str1,'.png','.txt');
            
                    labelmat=importdata([labeldir,'/',str1]);
%                     resultname=regexprep(regexprep(imagename,'0016E5.MXF_0', '0016E5_'),'.png','.mat');
%                     save(['../myCamVid/data/labels/',resultname],'labelmat');
%                     resultname=regexprep(resultname,'mat','png');
%                     imwrite(finalimage,['../myCamVid/data/images/',resultname],'png');
                    
                    textname=regexprep(regexprep(imagename,'0016E5.MXF_0', '0016E5_'),'.png','.txt');
                    dlmwrite(textname,labelmat,'delimiter',' ');
                    movefile(textname,'../myCamVid/data/labels/');              
                end
                
            end
        end
    end
    fprintf('FINISH %u image\n',iter);
end

end
            
                