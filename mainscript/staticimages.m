% function staticimages

addpath(genpath('/home/bliu/Desktop/multipleSegmentations/'));
addpath(genpath('/home/bliu/Desktop/project/'));
% semanticpath='./output';
% imagedir='../myCamVid/data/images';
% labeldir='../myCamVid/data/labels';
% imgdir=dir([imagedir,'/*.jpg']);
% framenames=importdata('../myCamVid/images.txt');
% geoclassifier=importdata('./newclassifier/allmyClassifiers.mat');
% % load('./newclassifier/JointTheta.mat');
% load './newclassifier/results.mat' ;
% % load('pg');
% outdir='./';
% load CamVidimsegs;
% load ([outdir,'output/','imagesegstrainn']);
% oncenumber=10;
% classnum=11;
iternumber=200;
% load color2id;
%%%%%%%%%%%%%%%%%%%%%%%% Generate Geometric confidence%%%%%%%%%%%%%%%%%
% geo_pixel_conf=zeros(320*240,5);
% geoimages=uint8(zeros(240*320,3));
% geoimages2=geoimages;
% for iter=1:length(imsegs) 
%     im=imread([imagedir,'/',imsegs(iter).imname]);
% %     imsegs=msCreateSuperpixels(im,imname);
% %     tic
% %     [geo_region_conf,smaps,imsegs]=ijcvTestImage(im,imsegs,geoclassifier);    
%     filename=regexprep(imsegs(iter).imname, '.jpg', '.region.geometric.mat');
%     geo_region_conf=pg{iter};
%     [junl_val geolabel]=max(geo_region_conf,[],2);
%     resultlabel=region2pixel(geolabel,imsegs(iter).segimage);
% %     load([labeldir,'/',regexprep(imname,'jpg','mat')]);
%     reallabel=region2pixel(imsegs(iter).labels,imsegs(iter).segimage);
%     for segiter=1:length(mapping)
%         geoimages(reallabel==segiter,:)=repmat(mapping(segiter,:),[sum(reallabel(:)==segiter) 1]);
%         geoimages2(resultlabel==segiter,:)=repmat(mapping(segiter,:),[sum(resultlabel(:)==segiter) 1]);
%     end   
%     imwrite([reshape(geoimages,240,320,[]) im reshape(geoimages2,240,320,[])],[outdir,'geo_output/',imsegs(iter).imname],'jpg');
%     
%     save([outdir,'geo_output/',filename],'geo_region_conf');
% %     toc
% %     segs=imsegs(iter)(iter).segimage;
%     for segiter=1:imsegs(iter).nseg
%         repnum=sum(imsegs(iter).segimage(:)==segiter);
%         geo_pixel_conf(imsegs(iter).segimage==segiter,:)=repmat(geo_region_conf(segiter,:),repnum,1);
%     end
%     filename=regexprep(imsegs(iter).imname, '.jpg', '.pixel.geometric.mat');
%     save([outdir,'geo_output/',filename],'geo_pixel_conf');   
%     
%     imagesegstrainn(iter).imname=imsegs(iter).imname;
%     segs=superpixel2(im,8,0.01);
%     imagesegstrainn(iter).segimage=segs;
%     imagesegstrainn(iter).nseg=max(max(segs));
%     geo_region_conf=zeros(imagesegstrainn(iter).nseg,5);
%     for segiter=1:imagesegstrainn(iter).nseg
%         geo_region_conf(segiter,:)=mean(geo_pixel_conf(imagesegstrainn(iter).segimage==segiter,:));
%     end
%     filename=regexprep(imagesegstrainn(iter).imname, '.jpg', '.region.geometric.mat');
%     save([outdir,'geo_output/',filename],'geo_region_conf');   
%     fprintf('finished %s image\n',imagesegstrainn(iter).imname);
% end   
% %%%%%%%%%%%%%%%%%%%%%%%% Generate Semantic confidence%%%%%%%%%%%%%%%%%%
%  SAVE IN SEMANTICPATH
% regionconfsemantic(imagesegstrainn,0);
%%%%%%%%%%%%%%%%%%%%%%%% Unary cpnfidence %%%%%%%%%%%%%%%%%%%%%%%%%%%%
theta=jointlabel(iternumber);
% finalunary(imagesegstrainn,theta);
%%%%%%%%%%%%%%%%%%%%%%% Inside Frame Consistency %%%%%%%%%%%%%%%%%%%%
% imagesegstrainn=imagecolor(imagesegstrainn,imagedir,framenames,imgdir);
%%%%%%%%%%%%%%%%%%%%%%% Compute Optical Flows %%%%%%%%%%%%%%%%%%%%%%%
% imagesegstrainn=spatialsmooth(imagesegstrainn,outdir);
trainsppairwise(outdir,imagesegstrainn);
save([outdir,'output/','imagesegstrainn'],'imagesegstrainn');
% end
            
% end