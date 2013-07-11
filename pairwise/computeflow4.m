function computeflow4(namecell,iter)

row=240;
col=320;

    imname=[namecell{iter},'.png'];
    resultname=regexprep(imname, '.png', '_Flow.mat');
    load(['./videoset/newflow/',resultname]);
    [prevx prevy]=ind2sub([row, col],1:row*col);
    
    currx=round(prevx+(reshape(Flow(:,:,1),row*col,[]))');
    curry=round(prevy+(reshape(Flow(:,:,2),row*col,[]))');
    
    id=find(currx<=0|curry<=0|currx>row|curry>col);
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
        [selectregion(segiter) freq]=mode(single(segimage1(curr(selectid))));
        currregion=unique(segimage1(segimage==segiter));       
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
    

        filename=[namecell{iter+1},'.flowdis.mat'];
        flown1=importdata(['./videoset/tem/',filename]);
        filename=[namecell{iter},'.flowdis.mat'];
        load(['./videoset/tem/',filename]);
        
        valout=(flown(adjregion(:,2),:)-flown1(adjregion(:,1)-nseg,:))./flown(adjregion(:,2),:);
        valout(isnan(valout))=0;
        valout(isinf(valout))=max(abs(valout(~isinf(valout))));
        valout=sum((valout).^2,2);
        meanval=1/(sum(valout)/length(valout));
        valout=exp(-meanval*valout);
    
        valout0=valout;%*para1+para2;
        adjoutregion=sparse(findoutx,findouty,[valout0 valout0],...
             double(nseg+nseg1),double(nseg+nseg1));
        
         filename=[namecell{iter},'_TPadj.mat'];
         save(['./videoset/tem/',filename],'adjoutregion');

    adjregion=[];
    fprintf('Finish image %s temporal adjacent matrix finish...\n',imname);
end