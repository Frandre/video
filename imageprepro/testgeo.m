trainlist=importdata('/home/bliu/Desktop/tem/myCamVid/valnames.txt');
% resultlab_dir='/home/bliu/Desktop/geo_output/';
% % lab_files=dir(lab_dir);
% addpath('/home/bliu/Desktop/project/inference/');
relab_dir='/home/bliu/Desktop/tem/myCamVid/data/labels/';
% % re_files=dir(re_dir);
% load CamVidimsegs;
label_real=cell(length(trainlist),1);
label_re=label_real;
iter=1;
mapresult=zeros(240*320,1);
load semanticmapping;
% load('./newclassifier/newresults.mat','pg');
% imagedir='/home/bliu/Desktop/tem/myCamVid/data/images';
% geoclassifier=importdata('./newclassifier/allnewClassifiers.mat');
% load('./newclassifier/allData.mat');
for iter=1:length(trainlist)
%     filename=[trainlist{iter},'.segimage.mat'];
%     load(['./videoset/tem/',filename]);
%     
%     filename=[trainlist{iter},'.region.geometric.mat'];
%     load(['./videoset/geooutput/',filename]);
%     
%      [junk labels]=max(geo_region_conf,[],2);
%     reslabel=region2pixel(labels,segimage);
    filename=[trainlist{iter},'.mat'];
    load(['./videoset/tpimage/tem1/',filename]);
    
    labelnames=[trainlist{iter},'.mat'];
    New_Id=importdata([relab_dir,'/',labelnames])+1;
    
    for mmiter=1:11
        mapresult(New_Id==mmiter)=semanticmapping(mmiter,3);
    end
    
    label_re{iter}=finallabel(:);
    label_real{iter}=New_Id(:);
%     error(iter-367)=sum(mapresult(mapresult>0)~=reslabel(mapresult>0))/sum(mapresult(:)>0);
    fprintf('Image %u finish\n',iter);
end
label_re=cell2mat(label_re);
label_real=cell2mat(label_real);

reallabel=zeros(size(label_re,1),1);
for iter=1:11
    reallabel(label_real==iter)=semanticmapping(iter,3);
end

unraccu=test_accuracy(5,reallabel,label_re);