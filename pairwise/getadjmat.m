function getadjmat(adj)
names=importdata('../myCamVid/framenames.txt');
fullnames=importdata('../data/framenames.txt');
if adj==0
    tem='tem/';
else
    tem='tem1/';
end
choice=1:length(names);
for currentseq=choice
    imnames=names{currentseq};
    %%%%%%%%%%%%%%%%%% PICK THE SEQUENCE %%%%%%%%%%%%%%%%%%%%%
       count=0;
       unary=cell(9,1);
       adjin=cell(9,1);
       adjbe=cell(8,1);
       adjbec=cell(8,1);
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
           adjin{frameiter+5}=[[inx iny]+sum(count),inregionval];
           unary{frameiter+5}=geo_region_conf;

           if frameiter~=4
               filename=[fullnames{infullnamesiter+frameiter}, '_TPadj.mat'];
               load(['./videoset/',tem,filename]);
               beregionval=nonzeros(adjoutregion);
               beregionid=find(ismember(adjoutregion,beregionval)==1);
               [bex bey]=ind2sub(size(adjoutregion),beregionid);
               adjbe{frameiter+5}=[[bex bey]+sum(count),beregionval];
               
               filename=[fullnames{infullnamesiter+frameiter}, '_TPadjn.mat'];
               adjoutregionc=importdata(['./videoset/',tem,filename]);
               beregionvalc=nonzeros(adjoutregionc);
               if isnan(sum(beregionvalc))
                   beregionvalc=0;
                   bexc=1; 
                   beyc=1;
               else
                   beregionidc=find(ismember(adjoutregionc,beregionvalc)==1);
                   [bexc beyc]=ind2sub(size(adjoutregionc),beregionidc);
               end
               adjbec{frameiter+5}=[[bexc beyc]+sum(count),beregionvalc];
           end
           count(frameiter+5)=double(size(adjinregion,1));
        end
           adjmatin=cell2mat(adjin);
           adjmatbe=cell2mat(adjbe);
           unaryconf=cell2mat(unary);
           adjmatbec=cell2mat(adjbec);

           adjbesp=sparse(adjmatbe(:,1),adjmatbe(:,2),adjmatbe(:,3),sum(count),sum(count));
           adjbecsp=sparse(adjmatbec(:,1),adjmatbec(:,2),adjmatbec(:,3),sum(count),sum(count));
           adjinsp=sparse(adjmatin(:,1),adjmatin(:,2),adjmatin(:,3),sum(count),sum(count));
           filename=[imnames,'_tem_pairwise_sptpunaryn.mat'];
           save(['./videoset/',tem,filename],'adjinsp','adjbesp','adjbecsp','unaryconf','count');
           clear unary adjin adjbe inregionval inregionid inx iny
           fprintf('--------------Image %s finish the full tp graph--------------%u number\n',imnames,currentseq);
end
% fprintf('----------Image %s finish the full tp graph ----------- %u number\n',imnames,currentseq);
