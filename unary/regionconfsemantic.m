function regionconfsemantic(namecell,train)

% namecell=importdata('valimage.mat');
% imsegsval=importdata('valimage.mat');
% imsegstest=importdata('testimage.mat');
indir='/home/bliu/Desktop/tem/data/output';
imdir='/home/bliu/Desktop/tem/myCamVid/data/labels';
regiondir='/home/bliu/Desktop/tem/videoproject/videoset/tem/';
% outdir='/home/bliu/Desktop/tem/videoproject/output';
outdir1='/home/bliu/Desktop/tem/videoproject/semanoutput';
addpath('/home/bliu/Desktop/project/ultility');
namecell=importdata('../data/framenames.txt');
% labellocation=zeros(length(namecell),1);
matlabpool(4);
parfor iter=1:length(namecell)
    sppedupsemantic(iter,namecell,imdir,indir,regiondir,outdir1,0);
end
matlabpool close;
end
