function sppedupsemantic(iter,namecell,imdir,indir,regiondir,outdir1,train)

    filename=[namecell{iter},'.unary.conf.txt'];
    semanconf=importdata([indir,'/',filename]);
    load([regiondir,namecell{iter},'.segimage.mat']);
    nseg=max(max(segimage));
    if 0 %train
        semanlabel=importdata([imdir,'/',filename]);
        seman_region_conf=zeros(nseg,size(semanconf,2)+1);
    else
        seman_region_conf=zeros(nseg,size(semanconf,2));
    end
    filename=[namecell{iter},'.unary.txt'];
    semanresult=importdata([indir,'/',filename]);
    seman_pixel_conf=zeros(size(semanconf));
    for classiter=1:11
        temp=(reshape(semanconf(:,classiter),320,240))';
        seman_pixel_conf(:,classiter)=exp(-temp(:));
    end
    
%     [val indx]=max(seman_pixel_conf,[],2);
%     ratio(iter)=sum((indx-1)~=semanresult(:))/sum(semanresult(:)>=0);
    filename=[namecell{iter},'.pixel.semantic.mat'];
    save([outdir1,'/',filename],'seman_pixel_conf');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Region %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    filename=[namecell{iter},'.txt'];
    if 0 % exist([imdir,'/',filename],'file')
        labelm=zeros(nseg,1);
        semanlabel=importdata([imdir,'/',filename]);
        for segiter=1:max(max(namecell(iter).segimage))
            findid=find(namecell(iter).segimage==segiter);
            if train
                seman_region_conf(segiter,2:end)=mean(seman_pixel_conf(findid,:));
                seman_region_conf(segiter,1)=majority(semanlabel(findid),1);
            else
                labellocation(iter)=1;
                labelm(segiter)=majority(semanlabel(findid),1);
            end
            seman_region_conf(segiter,:)=mean(seman_pixel_conf(findid,:));
        end
        filename=[namecell{iter},'.region.label.mat'];
        save([outdir1,'/',filename],'labelm');
    else
         for segiter=1:nseg
            findid=find(segimage(:)==segiter);
            seman_region_conf(segiter,:)=mean(seman_pixel_conf(findid,:));
         end
    end
    
    filename=[namecell{iter},'.region.semantic.mat'];
    save([outdir1,'/',filename],'seman_region_conf');

    fprintf('Finish image %s , number %u \n',namecell{iter},iter);
end