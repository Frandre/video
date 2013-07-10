function alltrainimage

labeldir='/home/bliu/Desktop/tem/myCamVid/data/labels/';
imagedir='/home/bliu/Desktop/tem/myCamVid/data/images/';
trainlist=importdata('/home/bliu/Desktop/tem/myCamVid/images.txt');
% load Camvidvaltseg;
load semanticmapping;
% load semantic5mapping;
% load semanticsubmapping;
% addpath('/home/bliu/Desktop/project/ultility');
% addpath(genpath('/home/bliu/Desktop/multipleSegmentations'));
% imsegs=cell(length(imseg),1);
label_name=importdata('label_names.txt');
vert_name=importdata('vert_names.txt');
horz_name=importdata('horz_names.txt');
label=importdata('labels.txt');
label_names={label_name{1},label_name{2},label_name{3},label_name{4},label_name{5}};
vert_names={vert_name{1},vert_name{2},vert_name{3}};
horz_names={horz_name{1},horz_name{2},horz_name{3}};
for iter=1:length(trainlist)
    filename=trainlist{iter};
    im=imread([imagedir,filename,'.png']);  
    imseg=msCreateSuperpixels(im,[filename,'.png']);
    imsegs(iter).imname=imseg.imname;
    imsegs(iter).imsize=imseg.imsize;
    imsegs(iter).segimage=imseg.segimage;
    imsegs(iter).nseg=imseg.nseg;
    imsegs(iter).npixels=imseg.npixels;
    imsegs(iter).adjmat=imseg.adjmat;
    
    filename=regexprep(imsegs(iter).imname,'png','mat');
    imagelabel=importdata([labeldir,filename]);
    
    labels=zeros(imsegs(iter).nseg,1);
    vert_labels=labels;
    horz_labels=labels;
    vlabels=cell(imsegs(iter).nseg,1);
    hlabels=cell(imsegs(iter).nseg,1);
    
    for segiter=1:imsegs(iter).nseg
        findid=find(imsegs(iter).segimage==segiter);
        regionlabel=majority(imagelabel(findid),1);
        if regionlabel~=-1 
            labels(segiter)=semanticmapping(regionlabel+1,3);
            vert_labels(segiter)=semanticmapping(regionlabel+1,1);
            horz_labels(segiter)=semanticmapping(regionlabel+1,2);
            vlabels{segiter}=label{labels(segiter)};
            if horz_labels(segiter)
                hlabels{segiter}=horz_names{horz_labels(segiter)};
            else
                hlabels{segiter}='---';
            end
        else
            hlabels{segiter}='---';
            vlabels{segiter}='---';
            continue;
        end
    end
    
    imsegs(iter).vlabels=vlabels;
    imsegs(iter).hlabels=hlabels;
    imsegs(iter).labels=labels;
    imsegs(iter).vert_labels=vert_labels;
    imsegs(iter).horz_labels=horz_labels;
    
    imsegs(iter).label_names=label_names;
    imsegs(iter).vert_names=vert_names;
    imsegs(iter).horz_names=horz_names;
    fprintf('Processing %u image,named %s finish\n',iter,imsegs(iter).imname);
end

save CamVidimsegs imsegs
end
    
    