function spatialsmooth(imname,nseg,segimage,imagecolor)

% outdir='./videoset';
outdir1='./videoset/tem';
% row=240;
% col=320;
se=strel('diamond',1);
biimage=zeros(240,320);
% cellname=importdata('../CamVid/camvidTrainList.txt');
% cellname1=importdata('../CamVid/camvidTestList.txt');

% for iter=1:size(imsegs,2)
    adjin=cell(nseg,1);
    for segiter=1:nseg
        biimage(segimage==segiter)=1;
        idmember=unique(segimage(setdiff(find(imdilate(biimage,se)==1),find(segimage==segiter))));
%         if length(idmember)>4
%             countnumber=histc(segimage(segimage(imdilate(biimage,se)==1)~=segiter),idmember);
%             [ordercount countnumber]=sort(countnumber,'descend');
%             idmember=idmember(countnumber(1:4));
%         end
        if size(idmember,1)<size(idmember,2)
            idmember=idmember';
        end
        idi=ones(length(idmember),1)*double(segiter);
        idj=idmember;
        adjin{segiter}=[idi,idj];
        biimage=biimage*0;
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    adjin=cell2mat(adjin);
    %%%%%%%%%%%% Make sure symmetric %%%%%%%%%%%%%%
%     orilength=length(adjin);
%     for imlength=1:orilength
%         rowfind=adjin(imlength,:);
%         if ~sum(ismember(adjin,[rowfind(2) rowfind(1)],'rows'))
%             countnum_row1=sum(adjin(:,1)==rowfind(1));
%             countnum_row2=sum(adjin(:,1)==rowfind(2));
%             if countnum_row1>=8||countnum_row2>=8
%                adjin(imlength,:)=[0 0];
%             else
%                 adjin=[adjin;[rowfind(2) rowfind(1)]];
%             end
%         end
%     end
%     countnumber=histc(adjin(:,1),1:imsegs(iter).nseg);
%     [ordercount countnumber]=sort(countnumber,'descend');
%     for imlength=1:length(adjin)
%         selectidcount=ordercount(imlength);
%         if selectidcount>=4
%             selectidnum=adjin(find(adjin(:,1)==countnumber(imlength)),:);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     adjin=adjin(adjin(:,1)~=0,:);
    findiny=adjin(:,1);
    findinx=adjin(:,2);
    result=sum((imagecolor(findinx,1:3)-imagecolor(findiny,1:3)).^2,2);
    meanresult=1/(2*((sum(result)/length(result))));
    valin=exp(-meanresult*result);
    
    valin0=valin;%*para1+para2;
    
    adjinregion=sparse(double(findinx),double(findiny),valin0,double(nseg),double(nseg));
%     adjinregion=adjinregion;
    fprintf('Finish image %s spatial adjacent matrix finish...\n',imname);
    filename=regexprep(imname, '.png', '_SPadjn.mat');
%     if sum(strcmp(imsegs.imname,cellname))||sum(strcmp(imsegs.imname,cellname1))
    save([outdir1,'/',filename],'adjinregion');
%     end
end
% end
