function theta=jointlabel(iternumber)

% datadir='/home/bliu/Desktop/tem/videoproject/output';
% outdir='/home/bliu/Desktop/tem/videoproject/output';
% load ./oldCamVid/trainimage
trainnames=importdata('../myCamVid/camvidTrainList.txt');
% addpath(genpath('/home/bliu/Desktop/project/'));
% valimsegs=importdata('./oldCamVid/valimage.mat');
valnames=importdata('../myCamVid/camvidValList.txt');
traindata=cell(length(trainnames),1);
num_labels=11;
iternumber=5;
datadir0 = '/home/bliu/Desktop/tem/videoproject/geo_output';  % where existing data is stored
datadir1 = '/home/bliu/Desktop/tem/videoproject/semanoutput';  % where existing data is stored
outdir =  '/home/bliu/Desktop/tem/videoproject/videoset/newclassifier';  % where to save data, results, etc.
for iter=1:length(trainnames)
    filename=[trainnames{iter},'.region.semantic.mat'];
    load([datadir1,'/',filename]);
    filename=[trainnames{iter},'.region.geometric.mat'];
    load([datadir0,'/',filename]);
    filename=[trainnames{iter},'.region.label.mat'];
    load([datadir1,'/',filename]);
    traindata{iter}=[labelm seman_region_conf,geo_region_conf];
end
featuredata=cell2mat(traindata);
save([outdir,'/','traindata'],'featuredata');

feature=featuredata(:,2:end);
label=featuredata(:,1)+1;

valdata=cell(length(valnames),1);
for iter=1:length(valnames)
    filename=[valnames{iter},'.region.semantic.mat'];
    load([datadir1,'/',filename]);
    filename=[valnames{iter},'.region.geometric.mat'];
    load([datadir0,'/',filename]);
    filename=[valnames{iter},'.region.label.mat'];
    load([datadir1,'/',filename]);
    valdata{iter}=[labelm seman_region_conf,geo_region_conf]; 
    fprintf('finish %u\n',iter);
end
featuredata=cell2mat(valdata);
save([outdir,'/','valdata'],'featuredata');

Vafeature=featuredata(:,2:end);
Valabel=featuredata(:,1)+1;

for iter=1:num_labels
    labelcount(iter)=length(find(label==iter));
end
save('LabelNum','labelcount');
[countnum indx]=sort(labelcount);
indxnum=indx(ceil(num_labels/2));
num_labels=11;
lambda=0.01;
fprintf('\nTraining Logistic Regression...\n');
errortrain=single(zeros(iternumber,1));
errorva=errortrain;
J=single(zeros(iternumber,1));
Jva=J;
%tr_size=size(trainfet,1);
%fulltrain=1:PIxelSum(iter);
% load Theta_addhog;
for iter=1:iternumber
    if iter==1
        theta=NaN;
        theta=oneVsother(feature,label,num_labels,lambda,indxnum,theta);
    else
        theta=oneVsother(feature,label,num_labels,lambda,indxnum,theta);
    end
    
    J(iter)=multilikelihood(feature,label,theta,num_labels);
    Jva(iter)=multilikelihood(Vafeature,Valabel,theta,num_labels);
%     
    predlabel=predictmulticlass_log_regression(theta,feature,0);
    predValabel=predictmulticlass_log_regression(theta,Vafeature,0);
    
    errortrain(iter)=length(find(predlabel~=label))/length(label>0);
    errorva(iter)=length(find(predValabel~=Valabel))/length(Valabel>0);
end
figure;
plot(errortrain);
hold on; plot(errorva,'-r');
% hold on; plot(errortest,'-y');
hold on; plot(J,'-b');
    
save([datadir0,'/errortrain.mat'],'errortrain');
save([datadir0,'/errorva.mat'],'errorva');
save([datadir0,'/loglikelihood.mat'],'J'); 
save([datadir0,'/valoglikelihood.mat'],'Jva'); 
save([outdir,'/JointTheta.mat'],'theta');   
end
