framenames=importdata('../data/framenames.txt');
matlabpool(4);
parfor iter=1:length(framenames)
    imname=framenames{iter};
    segimage=importdata(['./videoset/tem/',imname,'.segimage.mat']);
    nseg=max(max(segimage));
    Flow=importdata(['./videoset/newflow/',imname,'_Flow.mat']);
    imname=[imname,'.png'];
    flowdis(imname,nseg,segimage,Flow);
end
matlabpool close;