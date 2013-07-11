function [ind_bad ind_good error]=tppairwise(minpara1,minpara2,paraout1,paraout2,draw,ind_gb,gb)

outdir='./videoset/';
mapresult=zeros(240*320,1);
labeldir='../myCamVid/data/labels';
names=importdata('../myCamVid/framenames.txt');
load semanticmapping;
id=1;
fullnames=importdata('../data/framenames.txt');
load color2id;
colormap=uint8(zeros(240*320,3));
gtmap=uint8(zeros(240*320,3));
unarymap=colormap;
if isempty(ind_gb)
    choice=1:length(names);
else
    choice=ind_gb;
end
for currentseq=choice
    imnames=names{currentseq};
    filename=[imnames,'_tem_pairwise_sptpunaryn.mat'];
    %%%%%%%%%%%%%%%%%%%% PICK THE SEQUENCE %%%%%%%%%%%%%%%%%%%%%
    if paraout2==exp(-5)||~exist(['./videoset/tem/',filename],'file');
       count=0;
       unary=cell(9,1);
       adjin=cell(9,1);
       adjbe=cell(8,1);
       for frameiter=-4:4
       %%%%%%%%%%%%%%%%% CURRENT FRAME %%%%%%%%%%%%%%%
           infullnamesiter=find(strcmp(fullnames,imnames)==1);
           filename=[fullnames{infullnamesiter+frameiter}, '.region.geometric.mat'];
           load(['./videoset/geooutput/',filename]);
           filename=[fullnames{infullnamesiter+frameiter}, '_SPadj.mat'];
           load(['./videoset/tem/',filename]);
           inregionval=nonzeros(adjinregion);
           inregionid=find(ismember(adjinregion,inregionval)==1);
           [inx iny]=ind2sub(size(adjinregion),inregionid);
           adjin{frameiter+5}=[[inx iny]+sum(count),inregionval*minpara1+minpara2]; 
           unary{frameiter+5}=geo_region_conf;
                     
           if frameiter~=4
               filename=[fullnames{infullnamesiter+frameiter}, '_TPadj.mat'];
               load(['./videoset/tem/',filename]);
               beregionval=nonzeros(adjoutregion);
               beregionid=find(ismember(adjoutregion,beregionval)==1);
               [bex bey]=ind2sub(size(adjoutregion),beregionid);
               adjbe{frameiter+5}=[[bex bey]+sum(count),beregionval];
           end
           
           count(frameiter+5)=double(size(adjinregion,1));
        end
           adjmatin=cell2mat(adjin);
           adjmatbe=cell2mat(adjbe);
           unaryconf=cell2mat(unary);
           filename=[imnames,'_tem_pairwise_sptpunaryn.mat'];
           save(['./videoset/tem/',filename],'adjmatin','adjmatbe','unaryconf','count');
           clear unary adjin adjbe inregionval inregionid inx iny
    else
        filename=[imnames,'_tem_pairwise_sptpunaryn.mat'];
        load(['./videoset/tem/',filename]);
    end
    filename=[imnames, '.mat'];
    New_Id=importdata([labeldir,'/',filename])+1;  
    
    newx=[adjmatin(:,1);adjmatbe(:,1)];
    newy=[adjmatin(:,2);adjmatbe(:,2)];
    newval=[adjmatin(:,3);adjmatbe(:,3)*paraout1+paraout2];
    AdjancentMatrix=sparse(newx,newy,newval,sum(count),sum(count));
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
ind_bad=ind_gb(1:2:20);
ind_good=ind_gb(end-19:2:end);
end