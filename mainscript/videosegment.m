% function videosegment

addpath(genpath('/home/bliu/Desktop/multipleSegmentations/'));
addpath(genpath('/home/bliu/Desktop/project/'));
% semanticpath='../0016E5/output';
imagedir='../data/images';
imgdir=dir([imagedir,'/*.png']);
framenames=importdata('../data/framenames.txt');
geoclassifier=importdata('./newclassifier/allnewClassifiers.mat');
% load('./newclassifier/JointTheta.mat');

outdir='./videoset/';
oncenumber=10;
classnum=11;
iternumber=400;
% load([outdir,'output/','imagesegs4']);
%%%%%%%%%%%%%%%%%%%%% Generate Geometric confidence%%%%%%%%%%%%%%%%%
geo_pixel_conf=zeros(320*240,5);
% matlabpool(4);
for iter=1:length(framenames)
    imname=[framenames{iter},'.png'];
    im=imread([imagedir,'/',imname]);
    imsegs=msCreateSuperpixels(im,imname);
    [L,a,b]=rgb2lab(im);
    imlen=[L(:),a(:),b(:)];
    clear meanlab varlab
    tic
    [geo_region_conf,smaps,imsegs]=ijcvTestImage(im,imsegs,geoclassifier);    
    filename=regexprep(imsegs(iter).imname, '.png', '.region.geometric.mat');
    save([outdir,'geooutput/',filename],'geo_region_conf');
    toc
    for segiter=1:imsegs.nseg
        repnum=sum(imsegs.segimage(:)==segiter);
        geo_pixel_conf(imsegs.segimage(:)==segiter,:)=repmat(geo_region_conf(segiter,:),repnum,1);
    end
    filename=regexprep(imsegs.imname, '.png', '.pixel.geometric.mat');
    save([outdir,'geooutput/',filename],'geo_pixel_conf');   
    
%     filename=regexprep(imname, '.png', '.segimage.mat');
%     segimage=importdata(['./videoset/tem/',filename]);

    segimage=superpixel2(im,8,0.01);
%     nseg=max(max(segimage));
    geo_region_conf=zeros(nseg,5);
    for segiter=1:nseg
        geo_region_conf(segiter,:)=mean(geo_pixel_conf(segimage(:)==segiter,:));
        idset=find(segimage(:)==segiter);
        meanlab(segiter,:)=mean(imlen(idset,:));
        varlab(segiter,:)=var(imlen(idset,:));
    end
    filename=regexprep(imname, '.png', '.region.geometric.mat');
    save([outdir,'geooutput/',filename],'geo_region_conf');   
    fprintf('finished %s image\n',imname);
    
    filename=regexprep(imname, '.png', '.segimage.mat');
    save(['./videoset/tem/',filename],'segimage');
    
    imagecolor=[meanlab,varlab];
    filename=regexprep(imname, '.png', '.labcolor.mat');
    save(['./videoset/tem/',filename],'imagecolor');
    fprintf('IMAGE %u FINISH\n',iter);

    filename=regexprep(imname, '.png', '.labcolor.mat');
    imagecolor=importdata(['./videoset/tem/',filename]);
    spatialsmooth(imname,nseg,segimage,imagecolor);
%     resultname=regexprep(imname, '.png', '_Flow.mat');
%     Flow=importdata(['./videoset/newflow/',resultname]);
%     computeflow1(imname,nseg,segimage,Flow);
end 
% matlabpool close;
flowd;
 framenames=importdata('../data/framenames.txt');
 matlabpool(4);
 parfor iter=1:length(framenames)-1
     computeflow3(framenames,iter);
     computeflow4(framenames,iter);
     computeflow2(framenames,iter);
     computeflow1(framenames,iter);
 end
 matlabpool close;
%%%%%%%%%%%%%%%%%%%%%%%% Generate Semantic confidence%%%%%%%%%%%%%%%%%%
%  SAVE IN SEMANTICPATH
% regionconfsemantic(imagesegs,0);
%%%%%%%%%%%%%%%%%%%%%%% Unary cpnfidence %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% theta=jointlabel(iternumber);
% finalunary(imagesegs,theta);
%%%%%%%%%%%%%%%%%%%%%% Inside Frame Consistency %%%%%%%%%%%%%%%%%%%%
% imagesegs=getimagecolor(imagesegs,imagedir,framenames,imgdir);
%%%%%%%%%%%%%%%%%%%%%% Compute Optical Flows %%%%%%%%%%%%%%%%%%%%%%%
% computeflow;
% imagesegs=spatialsmooth(imagesegs,outdir);
% adjacantbetweenframes(framenames);
trainsppairwise;
traintppairwise;
showresult(0,1);
showresult(1,1);
showresult(1,0);
traintphigherorder;
%%%%%%%%%%% Compute  Adjacent Matrix Between And Inside Frames %%%%%%%%%%%%
% overalltraining(imsegs,outdir,classnum,1,0);
% overalltraining(imsegs,outdir,classnum,0,1);
% end
            
% end