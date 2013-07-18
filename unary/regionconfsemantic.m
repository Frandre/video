function regionconfsemantic(imsegstrain,train)

% imsegstrain=importdata('valimage.mat');
% imsegsval=importdata('valimage.mat');
% imsegstest=importdata('testimage.mat');
indir='/home/bliu/Desktop/tem/myCamVid/output';
imdir='/home/bliu/Desktop/tem/myCamVid/data/labels';
outdir='/home/bliu/Desktop/tem/videoproject/output';
outdir1='/home/bliu/Desktop/tem/videoproject/semanoutput';
addpath('/home/bliu/Desktop/project/ultility');
labellocation=zeros(size(imsegstrain,2),1);
for iter=1:size(imsegstrain,2)
    filename=regexprep(imsegstrain(iter).imname, '.jpg', '.unary.conf.txt');
    semanconf=importdata([indir,'/',filename]);
    if train
        semanlabel=importdata([imdir,'/',filename]);
        seman_region_conf=zeros(imsegstrain(iter).nseg,size(semanconf,2)+1);
    else
        seman_region_conf=zeros(imsegstrain(iter).nseg,size(semanconf,2));
    end
    filename=regexprep(imsegstrain(iter).imname, '.jpg', '.unary.txt');
    semanresult=importdata([indir,'/',filename]);
    seman_pixel_conf=zeros(size(semanconf));
    for classiter=1:11
        temp=(reshape(semanconf(:,classiter),320,240))';
        seman_pixel_conf(:,classiter)=exp(-temp(:));
    end
    
    [val indx]=max(seman_pixel_conf,[],2);
    ratio(iter)=sum((indx-1)~=semanresult(:))/sum(semanresult(:)>=0);
    filename=regexprep(imsegstrain(iter).imname,'jpg','pixel.semantic.mat');
    save([outdir1,'/',filename],'seman_pixel_conf');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Region %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    filename=regexprep(imsegstrain(iter).imname,'jpg','txt');
    if exist([imdir,'/',filename],'file')
        labelm=zeros(imsegstrain(iter).nseg,1);
        semanlabel=importdata([imdir,'/',filename]);
        for segiter=1:max(max(imsegstrain(iter).segimage))
            findid=find(imsegstrain(iter).segimage==segiter);
            if train
                seman_region_conf(segiter,2:end)=mean(seman_pixel_conf(findid,:));
                seman_region_conf(segiter,1)=majority(semanlabel(findid),1);
            else
                labellocation(iter)=1;
                labelm(segiter)=majority(semanlabel(findid),1);
            end
            seman_region_conf(segiter,:)=mean(seman_pixel_conf(findid,:));
        end
        filename=regexprep(imsegstrain(iter).imname,'jpg','region.label.mat');
        save([outdir1,'/',filename],'labelm');
    else
         for segiter=1:max(max(imsegstrain(iter).segimage))
            findid=find(imsegstrain(iter).segimage==segiter);
            seman_region_conf(segiter,:)=mean(seman_pixel_conf(findid,:));
         end
    end
    
    filename=regexprep(imsegstrain(iter).imname,'jpg','region.semantic.mat');
    save([outdir1,'/',filename],'seman_region_conf');

    fprintf('Finish image %s , number %u \n',imsegstrain(iter).imname,iter);
end
end
