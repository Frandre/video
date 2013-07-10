function geometricpotential

addpath(genpath('/home/bliu/Desktop/multipleSegmentations'));
addpath(genpath('/home/bliu/Desktop/project'));
load color2id;
classifier=importdata('/home/bliu/Desktop/tem/videoproject/newclassifier/allmyClassifiers.mat');
imsegs=importdata('/home/bliu/Desktop/tem/videoproject/trainimage.mat');
imsegs1=importdata('/home/bliu/Desktop/tem/videoproject/valimage.mat');
imsegs0=importdata('/home/bliu/Desktop/tem/videoproject/testimage.mat');
for iter=1:size(imsegs1,2)
    imsegs(iter+367)=imsegs1(iter);
end
for iter=1:size(imsegs0,2)
    imsegs(iter+468)=imsegs0(iter);
end
imdir='/home/bliu/Desktop/tem/CamVid/data/images';
outdir='/home/bliu/Desktop/tem/videoproject/output';
imoutdir='/home/bliu/Desktop/tem/videoproject/geo_output';
load pg;
for iter=1:size(imsegs,2)
    im=imread([imdir,'/',imsegs(iter).imname]);
    filename=regexprep(imsegs(iter).imname, '.jpg', '.region.geometric.mat');
%     tic
%     [pg, data, imseg]=ijcvTestImage(im,imsegs(iter),classifier);
%     toc
    geo_region_conf=pg{iter};
    [val idx]=max(geo_region_conf,[],2);
    
    countnum(iter,:)=[sum(idx~=imsegs(iter).labels),imsegs(iter).nseg];
    save([outdir,'/',filename],'geo_region_conf');
    fprintf('Image %s finish, the number is %u\n',imsegs(iter).imname,iter);
    
    labelimage=uint8(zeros(imsegs(iter).imsize));
    resultimage=uint8(zeros(imsegs(iter).imsize(1)*imsegs(iter).imsize(2),3));
    
    for segiter=1:imsegs(iter).nseg
        findid=find(imsegs(iter).segimage==segiter);
        resultimage(findid,:)=ones(length(findid),1)*mapping(idx(segiter),:);
        labelimage(findid)=idx(segiter);
    end
    
    imwrite(reshape(resultimage,size(im,1),size(im,2),3),imsegs(iter).imname);
    movefile(imsegs(iter).imname,imoutdir);
    
    filename=regexprep(imsegs(iter).imname, '.jpg', '.unary.geometric.mat');
    save([imoutdir,'/',filename],'labelimage');   
end

end