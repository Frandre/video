function superpixel

addpath(genpath('/home/bliu/Desktop/multipleSegmentations'));
addpath(genpath('/home/bliu/Desktop/project'));

labeldir='/home/bliu/Desktop/tem/CamVid/data/labels/';
imdir='/home/bliu/Desktop/tem/CamVid/data/images/';
trainlist=importdata('/home/bliu/Desktop/tem/CamVid/camvidTrainList.txt');

imseg=cell(1,size(trainlist,1));
count=zeros(size(trainlist,1),2);
for iter=1:size(trainlist,1)
    imname=[trainlist{iter},'.jpg'];
    im=imread([imdir,imname]);
    
    filename=regexprep(imname,'jpg','txt');
    imagelabel=importdata([labeldir,filename]);
    
    imseg{iter}=msCreateSuperpixels(im, imname);
    labelimage=zeros(imseg{iter}.imsize(1),imseg{iter}.imsize(2));
    for segiter=1:imseg{iter}.nseg
        findid=find(imseg{iter}.segimage==segiter);
        majortylabel=majority(imagelabel(findid),1);
        labelimage(findid)=majortylabel;
    end
    
    count(iter,:)=[sum(imagelabel(:)~=labelimage(:)),imseg{iter}.imsize(1)*imseg{iter}.imsize(2)];
end
error=sum(count(:,1))/sum(count(:,2));
save Camvidtrainseg imseg
end
