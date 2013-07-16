function flowdis(imname,nseg,segimage,Flow)

row=240;
col=320;
flowdist=reshape(Flow(:,:,2)./Flow(:,:,1),row*col,[]);
flowdist(isnan(flowdist))=0;
tmp=reshape(Flow(:,:,2),row*col,1);
flowdist(isinf(flowdist))=10*tmp(isinf(flowdist));
flowdist=atan(flowdist);
edges=-pi/2:pi/10:pi/2;
for iter=1:nseg
    flown(iter,:)=histc(flowdist(segimage(:)==iter),edges);
%     flown(nseg,:)=flown(nseg,:)./length(segimage(:)==iter);
end
filename=regexprep(imname,'.png', '.flowdis.mat');
save(['./videoset/tem/',filename],'flown');
fprintf('Finish image %s flow distribution finish...\n',imname);
end