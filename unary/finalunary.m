function finalunary(imsegs,theta)

% imsegs=importdata('trainimage.mat');
% imsegs0=importdata('valimage.mat');
% imsegs1=importdata('testimage.mat');
% load ./newclassifier/JointTheta.mat
datadir0='./videoset/geooutput/';
datadir='./videoset/output/';
% for iter=1:size(imsegs0,2)
%     imsegs(iter+367)=imsegs0(iter);
% end
% for iter=1:size(imsegs1,2)
%     imsegs(iter+468)=imsegs1(iter);
% end

for iter=1:size(imsegs,2)
    filename0=regexprep(imsegs(iter).imname, '.jpg', '.region.geometric.mat');    
    filename1=regexprep(imsegs(iter).imname, '.jpg', '.region.semantic.mat'); 
    
    load([datadir0,filename0]);
    load([datadir,filename1]);
    
    tmp=exp([ones(size(seman_region_conf,1),1) seman_region_conf,geo_region_conf]*theta');
    full_region_conf=bsxfun(@times,tmp,1./sum(tmp,2));
    filenamefull=regexprep(imsegs(iter).imname, '.jpg', '.region.full.mat'); 
    save([datadir,filenamefull],'full_region_conf');
    
    fprintf('Finish image %s , number %u \n',imsegs(iter).imname,iter);
    
end