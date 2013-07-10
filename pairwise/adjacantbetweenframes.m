function adjacantbetweenframes(namecell)
row=240;
col=320;
edges=-pi/2:pi/10:pi/2;
% namecell=importdata('../data/framenames.txt');
for iter=1:4:length(namecell)
    imname=[namecell{iter},'.png'];
    resultname=regexprep(imname, '.png', '_Flow.mat');
    load(['./videoset/newflow/',resultname]);
    [prevx prevy]=ind2sub([row, col],1:row*col);
    
    currx=round(prevx+(reshape(Flow(:,:,1),row*col,[]))');
    curry=round(prevy+(reshape(Flow(:,:,2),row*col,[]))');
    
    id=find(currx<=0|curry<=0|currx>row|curry>col);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     xid0=(currx<=0);
%     yid0=(curry<=0);
%     currx(xid)=1;
%     curry(yid)=1;
%     
%     xidm=(currx>row);
%     yidm=(curry>col);
%     currx(xidm)=row;
%     curry(yidm)=col;
%     currx(id)=1;
%     curry(id)=1;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    flowdist=reshape(Flow(:,:,2)./Flow(:,:,1),row*col,[]);
    flowdist(isnan(flowdist))=0;
    flowdist(isinf(flowdist))=0;
    flowdist=atan(flowdist);
    curr=(curry-1)*row+currx;
    
    filename=regexprep(imname, '.png', '.segimage.mat');
    load(['./videoset/tem/',filename]);
    
    nseg=max(max(segimage));
    filename=[namecell{iter+1},'.segimage.mat'];
    segimage1=importdata(['./videoset/tem/',filename]);        
    nseg1=max(max(segimage1));
    selectregion=zeros(nseg,1);
    idnum=1;
    adjregion=cell(nseg,1);
    for segiter=1:nseg
        %%%%%%%%%%%%%%%%%%%%%% Between Frames %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        selectid=setdiff(find(segimage==segiter),intersect(find(segimage==segiter),id));
%         currregion=unique(segimage1(curr(selectid)));
        [selectregion(segiter) freq]=mode(single(segimage1(curr(selectid))));
%         prevregion=ones(length(currregion),1)*segiter;
        
        currregion=unique(segimage1(segimage==segiter));
%         if length(currregion)>4
%             countnumber=histc(segimage1(curr(selectid)),currregion);
%             [ordercount countnumber]=sort(countnumber,'descend');
%             currregion=currregion(countnumber(1:4));
%         end
        
        if size(currregion,2)>size(currregion,1)
            currregion=currregion';
        end
        
        findoutx=currregion+nseg;
        if ~isempty(findoutx)           
            findouty=ones(size(findoutx,1),1)*double(segiter);
            adjregion{idnum}=[findoutx,findouty]; % [currregion,prevregion];
            idnum=idnum+1;
        end
        
        
        if (freq<0.5*length(selectid))||isnan(selectregion(segiter))
            selectregion(segiter)=NaN;
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    adjregion=cell2mat(adjregion);            
    findoutx=double([adjregion(:,1);adjregion(:,2)]);
    findouty=double([adjregion(:,2);adjregion(:,1)]);
    
%      if iter~=1
        filename=[namecell{iter+1},'.flowdis.mat'];
        flown1=importdata(['./videoset/tem/',filename]);
        filename=[namecell{iter},'.flowdis.mat'];
        load(['./videoset/tem/',filename]);              
        
        valout=(flown(adjregion(:,2),:)-flown1(adjregion(:,1)-nseg,:))./flown(adjregion(:,2),:);
        valout(isnan(valout)|isinf(valout))=0;
        valout=sum((valout).^2,2);
        meanval=1/(2*((sum(valout)/length(valout))));
        valout=exp(-meanval*valout);
    
        valout0=valout;%*para1+para2;
        adjoutregion=sparse(findoutx,findouty,[valout0 valout0],...
             double(nseg+nseg1),double(nseg+nseg1));
        
         filename=[namecell{iter},'_TPadjn.mat'];
         save(['./videoset/tem/',filename],'adjoutregion');
%      end
%     imsegs(iter).selectregion=selectregion;
%     imsegs(iter).flown=flown;
%     imsegs(iter).adjoutregion=adjoutregion;
    adjregion=[];
    filename=regexprep(imname, '.png', '.next.mat');
    save(['./videoset/tem/',filename],'selectregion');
%     filename=regexprep(imname,'.png', '.flowdis.mat');
%     save(['./videoset/tem/',filename],'flown');
    fprintf('Finish image %s temporal adjacent matrix finish...\n',imname);
end

end