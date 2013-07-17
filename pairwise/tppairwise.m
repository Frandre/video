function [ind_bad ind_good error]=tppairwise(minpara1,minpara2,paraout1,paraout2,draw,ind_gb,gb,adj)

outdir='./videoset/';
mapresult=zeros(240*320,1);
labeldir='../myCamVid/data/labels';
names=importdata('../myCamVid/framenames.txt');
load semanticmapping;
id=1;
load color2id;
colormap=uint8(zeros(240*320,3));
gtmap=uint8(zeros(240*320,3));
unarymap=colormap;
error=0;
draw=0;
if isempty(ind_gb)
    choice=1:length(names);
else
    choice=ind_gb;
end
if adj==0
    tem='tem/';
else
    tem='tem1/';
end
for currentseq=choice
    imnames=names{currentseq};
    filename=[imnames,'_tem_pairwise_sptpunaryn.mat'];
    load(['./videoset/',tem,filename]);

    filename=[imnames, '.mat'];
    New_Id=importdata([labeldir,'/',filename])+1;

%     newx=[adjmatin(:,1);adjmatbe(:,1)];
%     newy=[adjmatin(:,2);adjmatbe(:,2)];
%     newval=[adjmatin(:,3)*minpara1+minpara2;exp(-adjmatbe(:,3)*paraout1-(1-paraout1)*adjmatbe(:,4))*paraout2];
    tmpadj=adjbesp*paraout1+adjbecsp*(1-paraout1);
    adjval=nonzeros(tmpadj);
    adjid=find(ismember(tmpadj,adjval)==1);
    [adjx adjy]=ind2sub(size(tmpadj),adjid);
    AdjancentMatrix=sparse(adjx,adjy,exp(-adjval),size(tmpadj,1),size(tmpadj,2));
               
    AdjancentMatrix=AdjancentMatrix*paraout2+adjinsp*minpara1+minpara2;
    if ~issparse(AdjancentMatrix)
        AdjancentMatrix=sparse(AdjancentMatrix);
    end
%     AdjancentMatrix=sparse(newx,newy,newval,sum(count),sum(count));
    [junk first]=max(unaryconf,[],2);
    nodePot=single(-log(unaryconf));
    SmoothnessCost=single(ones(5)-eye(5));
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
%     if 1
%         displayresultimages(imnames,fullnames,reslabels,first,count);
%         continue;
%     end

    reslabels=reslabels(sum(count(1:4))+1:sum(count(1:5)));
    firstlabel=first(sum(count(1:4))+1:sum(count(1:5)));

    filename=[imnames, '.segimage.mat'];
    load(['./videoset/tem/',filename]);
    reallabel=region2pixel(reslabels+1,segimage);
    firstlabel=region2pixel(firstlabel,segimage);
    for mmiter=1:11
        mapresult(New_Id==mmiter)=semanticmapping(mmiter,3);
    end

    if draw==1
        for cciter=1:5
            unarymap(firstlabel(:)==cciter,:)=repmat(mapping(cciter,:),sum(firstlabel(:)==cciter),1);
            colormap(reallabel(:)==cciter,:)=repmat(mapping(cciter,:),sum(reallabel(:)==cciter),1);
            gtmap(mapresult(:)==cciter,:)=repmat(mapping(cciter,:),sum(mapresult(:)==cciter),1);
        end
        if minpara1==0&&minpara2==0
            if isempty(ind_gb)
                filename=[imnames,'_withouttp.jpg'];
            else
                filename=[imnames,'_withouttp','_',gb,'.jpg'];
            end
        else
            if isempty(ind_gb)
                filename=[imnames,'_withtp.jpg'];
            else
                filename=[imnames,'_withtp',num2str(log(paraout1)),num2str(log(paraout2)),'_',gb,'.jpg'];
            end
        end
        imwrite([reshape(colormap,240,320,3),reshape(unarymap,240,320,3),reshape(gtmap,240,320,3)],[outdir,'comparetp/',filename],'jpg');
        gtmap=gtmap*0;
    end
    error(id)=sum(mapresult(mapresult>0)~=reallabel(mapresult>0))/sum(mapresult(:)>0);
    fprintf('----------Image %s finish----------- %u number\n',imnames,currentseq);
    mapresult=mapresult*0;
    id=id+1;
end
[res ind_gb]=sort(error,'descend');
if length(ind_gb)<=20
    ind_bad=ind_gb;
    ind_good=ind_gb;
else
    ind_bad=ind_gb(1:2:20);
    ind_good=ind_gb(end-19:2:end);
end
end
