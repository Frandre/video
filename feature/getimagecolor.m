function imsegs=getimagecolor(imsegs,imagedir,framenames,imgdir)

for iter=1:length(framenames)
    imname=imgdir(iter).name; 
    im=imread([imagedir,'/',imname]);
    [L,a,b]=rgb2lab(im);
    imlen=[L(:),a(:),b(:)];
    clear meanlab varlab
    for segiter=1:imsegs(iter).nseg
        idset=find(imsegs(iter).segimage==segiter);
        meanlab(segiter,:)=mean(imlen(idset,:));
        varlab(segiter,:)=var(imlen(idset,:));
    end
    imsegs(iter).imagecolor=[meanlab,varlab];
    filename=regexprep(imsegs(iter).imname, '.png', '.labcolor.mat');
    imagecolor=imsegs(iter).imagecolor;
    save(['./videoset/tem/',filename],'imagecolor');
    fprintf('IMAGE %u FINISH\n',iter);
end
end