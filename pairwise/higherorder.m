% function error=higherorder(parasp1,parasp2,paratp1,paratp2,parahigher1,parahigher2,parahigher3,parahigher4,parahigher5,draw)
function error=higherorder(parasp1,parasp2,paratp1,paratp2,parahigher1,parahigher2,parahigher5,draw)

outdir='./videoset/';
temdir='./videoset/tem/';
mapresult=zeros(240*320,1);
labeldir='../myCamVid/data/labels';
names=importdata('../myCamVid/framenames.txt');
fullnames=importdata('../data/framenames.txt');
load semanticmapping;
id=1; 
load color2id;
colormap=uint8(zeros(240*320,3));
gtmap=uint8(zeros(240*320,3));
unarymap=colormap;
for currentseq=1:length(names) 
    imnames=names{currentseq};
    filename=[imnames, '_higherorderalln.mat'];
    %%%%%%%%%%%%%%%%%%%% PICK THE SEQUENCE %%%%%%%%%%%%%%%%%%%%%
    if (parahigher5==exp(-6)&&paratp1==10^-4)||~exist([temdir,filename],'file');
       count=0;
       unary=cell(9,1);
       adjin=cell(9,1);
       imcolor=cell(9,1);
       adjout=cell(8,1);
       connregion=cell(8,1);
       imnames=names{currentseq};
       for frameiter=-4:4
       %%%%%%%%%%%%%%%%% CURRENT FRAME %%%%%%%%%%%%%%%
           infullnamesiter=find(strcmp(fullnames,imnames)==1);
           filename=[fullnames{infullnamesiter+frameiter}, '.region.geometric.mat'];
           geo_region_confload(['./videoset/geooutput/',filename]);
           filename=[fullnames{infullnamesiter+frameiter}, '_SPadj.mat'];
           adjinregionload(['./videoset/tem/',filename]);
           filename=[fullnames{infullnamesiter+frameiter}, '_TPadj.mat'];
           adjoutregionload(['./videoset/tem/',filename]);  
           
           inregionval=nonzeros(adjinregion);
           inregionid=find(ismember(adjinregion,inregionval)==1);
           [inx iny]=ind2sub(size(adjinregion),inregionid);
           adjin{frameiter+5}=[[inx iny]+sum(count),inregionval*parasp1+parasp2];  
           
           unary{frameiter+5}=geo_region_conf;
           filename=[fullnames{infullnamesiter+frameiter}, '.labcolor.mat'];
           imagecolorload(['./videoset/tem/',filename]);
           imcolor{frameiter+5}=imagecolor;
           filename=[fullnames{infullnamesiter+frameiter}, '.next.mat'];
           selectregionload(['./videoset/tem/',filename]);
        
           if frameiter~=4
               connregion{frameiter+5}=[(1:size(adjinregion,1))'+sum(count), ...
                   selectregion++sum(count)+size(adjinregion,1)];
               outregionval=nonzeros(adjoutregion);
               outregionid=find(ismember(adjoutregion,outregionval)==1);
               [outx outy]=ind2sub(size(adjoutregion),outregionid);
               adjout{frameiter+5}=[[outx outy]+sum(count),outregionval];
           end
           count(frameiter+5)=double(size(adjinregion,1));
       end
       adjinregion=cell2mat(adjin);
       adjoutregion=cell2mat(adjout);
%        fulladjmatrix=sparse(adjinregion(:,1),adjinregion(:,2),adjinregion(:,3),sum(count),sum(count));
       
       unaryconf=cell2mat(unary);
       imcolor=cell2mat(imcolor);
       connregion=cell2mat(connregion);
       [hop G]=findhigherorder(connregion,sum(count)-count(end),imcolor);
       filename=[imnames,'_higherorderalln.mat'];
       save([temdir,filename],'adjinregion','adjoutregion','unaryconf','imcolor','connregion','count','hop','G');
    else
        filename=[imnames, '_higherorderalln.mat'];
        load([temdir,filename]);
    end
%     hop=findhigherorder(connregion,5,sum(count)-count(end),imcolor,parahigher1,parahigher2,parahigher3,parahigher4,parahigher5);
    for hopiter=1:length(hop)
        hop(hopiter).Q=single(hop(hopiter).Q/parahigher1);
%         gammares=length(hop(hopiter).ind)^parahigher2*(parahigher3+parahigher4*exp(-G(hopiter)*parahigher5));
        gammares=exp(-G(hopiter)*parahigher5);
        if gammares<=10^-6||gammares-parahigher2*hop(hopiter).Q<0
            hop(hopiter).gamma=single([zeros(1,5) gammares]);
        else
            hop(hopiter).gamma=single([(gammares-parahigher2*hop(hopiter).Q)*ones(1,5) gammares]);
        end
    end
    newx=[adjinregion(:,1);adjoutregion(:,1)];
    newy=[adjinregion(:,2);adjoutregion(:,2)];
    newval=[adjinregion(:,3);adjoutregion(:,3)*paratp1+paratp2];
    fulladjmatrix=sparse(newx,newy,newval,sum(count),sum(count));
    [junk_val first]=max(unaryconf,[],2);
    Dc=single((-log(unaryconf))');
    [L E]=robustpn_mex(fulladjmatrix,Dc,hop,first);
    fprintf('Mininum Energy is %u after expansion, higherorder term is % u\n',E(4),E(3));
    
    filename=[imnames, '.mat'];
    New_Id=importdata([labeldir,'/',filename])+1;
    
    Llabel=L(sum(count(1:4))+1:sum(count(1:5)));
    firstlabel=first(sum(count(1:4))+1:sum(count(1:5)));
    
    filename=[imnames, '.segimage.mat'];
    segimageload(['./videoset/tem/',filename]);
    reallabel=region2pixel(Llabel+1,segimage);
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
        if paratp1==10^-4&&paratp2==10^-4
            filename=[imnames,'_withhigherorderonly.jpg'];
        else
            filename=[imnames,'_withhigherorderandpairwise.jpg'];
        end
        imwrite([reshape(colormap,240,320,3),reshape(unarymap,240,320,3),reshape(gtmap,240,320,3)],[outdir,'output/',filename],'jpg');
    end        
    gtmap=gtmap*0;
    error(id)=sum(mapresult(mapresult>0)~=reallabel(mapresult>0))/sum(mapresult(:)>0);
    fprintf('----------Image %s finish----------- %u number\n',imnames,currentseq);  
    mapresult=mapresult*0;
    id=id+1;
end

end
