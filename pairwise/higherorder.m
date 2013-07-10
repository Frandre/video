function error=higherorder(parasp1,parasp2,parahigher1,parahigher2,parahigher3,parahigher4,parahigher5,draw)

temdir='./videoset/tem/';
temlabel=zeros(240*320,1);
labeldir='../myCamVid/data/labels';
names=importdata('../CamVid/framenames.txt');
fullnames=importdata('./videoset/allframenames.txt');
load semanticmapping;
id=1; 
load color2id;
colormap=uint8(zeros(240*320,3));
gtmap=uint8(zeros(240*320,3));
for currentseq=1:length(names) 
    %%%%%%%%%%%%%%%%%%%% PICK THE SEQUENCE %%%%%%%%%%%%%%%%%%%%%
    if parahigher5==exp(-3);
       count=0;
       unary=cell(3,1);
       adjin=cell(3,1);
       imcolor=cell(3,1);
       connregion=cell(2,1);
       imnames=names{currentseq};
       for frameiter=-1:1
       %%%%%%%%%%%%%%%%% CURRENT FRAME %%%%%%%%%%%%%%%
           infullnamesiter=find(strcmp(fullnames,imnames)==1);
           filename=[fullnames{infullnamesiter+frameiter}, '.region.geometric.mat'];
           load(['./videoset/geooutput/',filename]);
           filename=[fullnames{infullnamesiter+frameiter}, '_SPadj.mat'];
           load(['./videoset/tem/',filename]);
           inregionval=nonzeros(adjinregion);
           inregionid=find(ismember(adjinregion,inregionval)==1);
           [inx iny]=ind2sub(size(adjinregion),inregionid);
           adjin{frameiter+2}=[[inx iny]+sum(count),inregionval*parasp1+parasp2]; 
           unary{frameiter+2}=geo_region_conf;
           filename=[fullnames{infullnamesiter+frameiter}, '.labcolor.mat'];
           load(['./videoset/tem/',filename]);
           imcolor{frameiter+2}=imagecolor;
           filename=[fullnames{infullnamesiter+frameiter}, '.next.mat'];
           load(['./videoset/tem/',filename]);
        
           if frameiter~=1
               connregion{frameiter+2}=[(1:size(adjinregion,1))'+sum(count), ...
                   selectregion++sum(count)+size(adjinregion,1)];
           end
           count(frameiter+2)=double(size(adjinregion,1));
       end
       adjinregion=cell2mat(adjin);
       fulladjmatrix=sparse(adjinregion(:,1),adjinregion(:,2),adjinregion(:,3),sum(count),sum(count));
       
       unaryconf=cell2mat(unary);
       imcolor=cell2mat(imcolor);
       connregion=cell2mat(connregion);
       [hop G]=findhigherorder(connregion,sum(count)-count(end),imcolor);
       filename=[imnames,'_higherorderall.mat'];
       save([temdir,filename],'fulladjmatrix','unaryconf','imcolor','connregion','count','hop','G');
    else
        filename=[imnames, '_higherorderall.mat'];
        load([temdir,filename]);
    end
%     hop=findhigherorder(connregion,5,sum(count)-count(end),imcolor,parahigher1,parahigher2,parahigher3,parahigher4,parahigher5);
    for hopiter=1:length(hop)
        hop(hopiter).Q=hop(hopiter).Q/parahigher1;
        gammares=length(hop(hopiter).ind)^parahigher2*(parahigher3+parahigher4*exp(-G(hopiter)*parahigher5));
        hop(hopiter).gamma=gammares*ones(6,1);
    end

    [junk_val first]=max(unaryconf,[],2);
    Dc=(-log(unaryconf))';
    [L E]=robustpn_mex(fulladjmatrix,Dc,hop,first-1);
    
    filename=[imnames, '.mat'];
    New_Id=importdata([labeldir,'/',filename])+1;
    
    Llabel=L(sum(count(1:4))+1:sum(count(1:5)));
    filename=[imnames, '.segimage.mat'];
    load(['./videoset/tmp/',filename]);
    reallabel=region2pixel(Llabel+1,segimage);
    for mmiter=1:11
        mapresult(New_Id==mmiter)=semanticmapping(mmiter,3);
    end
    
    if draw==1
        for cciter=1:5
            colormap(reallabel(:)==cciter,:)=repmat(mapping(cciter,:),sum(reallabel(:)==cciter),1);
            gtmap(mapresult(:)==cciter,:)=repmat(mapping(cciter,:),sum(mapresult(:)==cciter),1);
        end
        if parasp1==10^-4&&parasp2==10^-4
            filename=regexprep(imname,'.png','_withhigherorderonly.jpg');
        else
            filename=regexprep(imname,'.png','_withhigherorderandpairwise.jpg');
        end
        imwrite([reshape(colormap,240,320,3),reshape(gtmap,240,320,3)],[outdir,'output/',filename],'jpg');
    end        
    
    error(id)=sum(mapresult(:)~=reallabel(:))/sum(mapresult(:)>0);
    fprintf('----------Image %s finish----------- %u number\n',imname,currentseq);  
    mapresult=mapresult*0;
    id=id+1;
end  
end
