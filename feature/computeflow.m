function computeflow

% addpath('/home/bliu/Desktop/project/extern/pami2010Matlab/');
mkdir('./videoset/newflow');
imdir='../data/images';
% imagesdir=dir([imdir,'/*.png']);
% load('/home/bliu/Desktop/tem/videoproject/videoset/output/imagesegs');
namecell=importdata('../data/framenames.txt');
% para=get_para_flow(240,320);
% verbose=0;
matlabpool(4);
parfor iter=1:size(namecell,1)-1
%     imfile1=[imdir,'/',imagesdir(iter).name];
%     imfile2=[imdir,'/',imagesdir(iter+1).name];
%     if exist(['./videoset/flow/',imagesdir(iter).name],'file')
%         resultname=regexprep(imagesdir(iter).name, '.png', '_Flow.mat');
%         load(['./videoset/flow/',resultname]);
%         if size(Flow,1)==240
%             continue;
%         end
%     end
    im1name=[namecell{iter},'.png'];
    im2name=[namecell{iter+1},'.png'];
    im1=imread([imdir,'/',im1name]);
    im2=imread([imdir,'/',im2name]);
%     [Flow,c1,c2]=LDOF(imfile1,imfile2,para,verbose);
%   check_flow_correspondence(im1,im2,Flow);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    im1name=[namecell{iter},'.ppm'];
    im2name=[namecell{iter},'.ppm'];
    imwrite(im1,[imdir,'/',im1name],'ppm');
    imwrite(im2,[imdir,'/',im2name],'ppm');
    im1 = double(imread([imdir,'/',im1name]));
    im2 = double(imread([imdir,'/',im2name]));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     flow_warp(im1,im2,Flow,1)
%     flow_view=flowToColor(Flow);
%     imwrite(flow_view,['./videoset/flow/',imagesdir(iter).name],'png');
%     Flow=mex_LDOF(im1,im2);
%     resultname=regexprep(im1name, '.png', '_Flow.mat');
    savefiles(namecell{iter},im1,im2);
%     save(['./videoset/newflow/',resultname],'Flow');
    fprintf('flow from %s to %s finished\n',im1name,im2name);
end
matlabpool close;
end