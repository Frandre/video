function error=geometricsmooth(outdir,numclass,parain1,parain2,draw)

outdir='./videoset/';
labeldir='../myCamVid/data/labels';
trainimage=dir([outdir,'tem/*_SPadjn*.mat']);
load semanticmapping;
mapresult=zeros(240*320,1);
namecell=importdata('../myCamVid/framenames.txt');
load color2id;
colormap=uint8(zeros(240*320,3));
gtmap=uint8(zeros(240*320,3));
for iter=1:size(namecell,1)
    imname=[namecell{iter},'.png'];
    filename=regexprep(imname,'.png','_SPadjn.mat');
    load([outdir,'tem/',filename]);
    
    filename=regexprep(filename, '_SPadjn', '.region.geometric');
    load([outdir,'geooutput/',filename]);
    
    filename=regexprep(filename, '.region.geometric.mat', '.txt');
    New_Id=importdata([labeldir,'/',filename])+1; 
    
    filename=regexprep(filename, '.txt', '.segimage.mat');
    load([outdir,'tem/',filename]);
        
    nodePot=-log(geo_region_conf);
    SmoothnessCost=ones(numclass)-eye(numclass);
    [junk first]=max(geo_region_conf,[],2);
    
    regionval=nonzeros(adjinregion);
    regionid=find(ismember(adjinregion,regionval)==1);
    [findx findy]=ind2sub(size(adjinregion),regionid);
    
    AdjancentMatrix=sparse(findx,findy,regionval*parain1+parain2,size(adjinregion,1),size(adjinregion,2));
    
    gch=GraphCut('open',nodePot',SmoothnessCost,AdjancentMatrix);
%     gch=GraphCut('set',gch,reshape(first-1,row,col));
    gch=GraphCut('set',gch,first-1);
    [gch e]=GraphCut('energy', gch);
    fprintf('Current Energy is %e \n',e);
    [gch reslabels]=GraphCut('expand',gch);
    [gch e]=GraphCut('energy', gch);
    fprintf('Output Energy is %e \n',e);
    gch=GraphCut('close', gch);
%     reslabels=reslabels;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    reallabel=region2pixel(reslabels+1,segimage);
    for mmiter=1:11
        mapresult(New_Id==mmiter)=semanticmapping(mmiter,3);
    end
    if draw==1
        for cciter=1:5
            colormap(reallabel(:)==cciter,:)=repmat(mapping(cciter,:),sum(reallabel(:)==cciter),1);
            gtmap(mapresult(:)==cciter,:)=repmat(mapping(cciter,:),sum(mapresult(:)==cciter),1);
        end
        if parain1==0&&parain2==0
            filename=regexprep(imname,'.png','_withoutsp.jpg');
        else
            filename=regexprep(imname,'.png','_withsp.jpg');
        end
        imwrite([reshape(colormap,240,320,3),reshape(gtmap,240,320,3)],[outdir,'output/',filename],'jpg');
    end
    error(iter)=single(sum(mapresult(:)~=reallabel(:))/sum(mapresult(:)>0));
    fprintf('----------Image %s finish----------- %u number\n',imname,iter);  
    mapresult=mapresult*0;
end 
end