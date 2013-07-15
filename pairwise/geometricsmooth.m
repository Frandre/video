function [ind_bad ind_good error]=geometricsmooth(outdir,numclass,parain1,parain2,draw,ind_gb,ind)

outdir='./videoset/';
labeldir='../myCamVid/data/labels';
% trainimage=dir([outdir,'tem/*_SPadjn*.mat']);
load semanticmapping;
mapresult=zeros(240*320,1);
namecell=importdata('../myCamVid/framenames.txt');
load color2id;
colormap=uint8(zeros(240*320,3));
gtmap=uint8(zeros(240*320,3));
unarymap=colormap;
if isempty(ind_gb)
    choice=1:size(namecell,1);
else
    choice=ind_gb;
end
for iter=choice
    imname=[namecell{iter},'.png'];
    filename=regexprep(imname,'.png','_SPadj.mat');
    load([outdir,'tem/',filename]);
    
    filename=regexprep(filename, '_SPadjn', '.region.geometric');
    load([outdir,'geooutput/',filename]);
    
    filename=regexprep(filename, '.region.geometric.mat', '.txt');
    New_Id=importdata([labeldir,'/',filename])+1; 
    
    filename=regexprep(filename, '.txt', '.segimage.mat');
    load([outdir,'tem/',filename]);
        
    nodePot=single(-log(geo_region_conf));
    SmoothnessCost=single(ones(numclass)-eye(numclass));
    [junk first]=max(geo_region_conf,[],2);
    
    regionval=nonzeros(adjinregion);
    regionid=find(ismember(adjinregion,regionval)==1);
    [findx findy]=ind2sub(size(adjinregion),regionid);
    
    AdjancentMatrix=sparse(findx,findy,regionval*parain1+parain2,size(adjinregion,1),size(adjinregion,2));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [reslabels energy afterenergy]=GCMex(first-1,nodePot',AdjancentMatrix,SmoothnessCost,1);
    fprintf('Energy is %e before and %e after expansion\n',energy,afterenergy);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     gch=GraphCut('open',nodePot',SmoothnessCost,AdjancentMatrix);
%     gch=GraphCut('set',gch,first-1);
%     [gch e]=GraphCut('energy', gch);
%     fprintf('Current Energy is %e \n',e);
%     [gch reslabels]=GraphCut('expand',gch);
%     [gch e]=GraphCut('energy', gch);
%     fprintf('Output Energy is %e \n',e);
%     gch=GraphCut('close', gch);
%     clear gch e;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    reallabel=region2pixel(reslabels+1,segimage);
    firstlabel=region2pixel(first,segimage);
    for mmiter=1:11
        mapresult(New_Id==mmiter)=semanticmapping(mmiter,3);
    end
    if draw==1
        for cciter=1:5
            unarymap(firstlabel(:)==cciter,:)=repmat(mapping(cciter,:),sum(firstlabel(:)==cciter),1);
            colormap(reallabel(:)==cciter,:)=repmat(mapping(cciter,:),sum(reallabel(:)==cciter),1);
            gtmap(mapresult(:)==cciter,:)=repmat(mapping(cciter,:),sum(mapresult(:)==cciter),1);
        end
        if parain1==10^-4&&parain2==10^-4
            if isempty(ind_gb)
                filename=regexprep(imname,'.png','_withoutsp.jpg');
            else
                filename=regexprep(imname,'.png','_withoutsp');
                filename=[filename,'_',ind,'.jpg'];
            end
        else
            if isempty(ind_gb)
                filename=regexprep(imname,'.png','_withsp.jpg');
            else
                filename=regexprep(imname,'.png','_withsp');
                filename=[filename,num2str(log(parain1)),num2str(log(parain2)),'_',ind,'.jpg'];
            end
        end
        imwrite([reshape(colormap,240,320,3),reshape(unarymap,240,320,3),reshape(gtmap,240,320,3)],[outdir,'compareresult/',filename],'jpg');
        gtmap=gtmap*0;
    end
    error(iter)=single(sum(mapresult(mapresult>0)~=reallabel(mapresult>0))/sum(mapresult(:)>0));
    fprintf('----------Image %s finish----------- %u number\n',imname,iter);  
    mapresult=mapresult*0;
end 
[res ind_gb]=sort(error,'descend');
ind_bad=ind_gb(1:2:20);
ind_good=ind_gb(end-19:2:end);
end