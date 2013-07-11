% function trainsppairwise
addpath(genpath('/home/bliu/Desktop/project/'));
outdir='./videoset/';
fprintf('START TRAINING\n');
numclass=5;
minerror=1;
id=0;
choice=[-6,-4,-2,0,2,4,6];
fullerror=zeros(49,468);
diary('spacepairwiseterm.txt')
diary on;
% for para1=choice
%     parain1=exp(para1);
%     for para2=choice
%         parain2=exp(para2);
%         id=id+1;
finalchoice=[];
for iter=1:length(choice)
    choice1=choice(iter)*ones(length(choice),1);
    choice2=choice';
    finalchoice=[finalchoice;choice1 choice2];
end
matlabpool(4);
parfor iter=1:49
        parain1=exp(finalchoice(iter,1));
        parain2=exp(finalchoice(iter,2));
        fprintf('/////////////////////PARAMITER 1 is %u and 2 is %u///////////////////////\n',parain1,parain2);
        [ind_bad ind_good error]=geometricsmooth(outdir,numclass,parain1,parain2,0,[],[]);
        [ind_b ind_g error0]=geometricsmooth(outdir,numclass,parain1,parain2,1,ind_bad,'bad');
        [ind_b ind_g error0]=geometricsmooth(outdir,numclass,parain1,parain2,1,ind_good,'good');
        
        fprintf('///////////////CURRENT PARAMITER ERROR is %e/////////////\n',mean(error));
        fullerror(iter,:)=error;
%     end
end
matlabpool close;
[minerror minindx]=min(mean(fullerror,2));
minpara=exp(finalchoice(minindx));
fprintf('Final weights are %e and %e for parain1 and parain2\n',minpara(1),minpara(2));
[ind_bad ind_good originerror]=geometricsmooth(outdir,numclass,10^-4,10^-4,0,[],[]);
[ind_b ind_g originerror0]=geometricsmooth(outdir,numclass,0.0001,10^-4,1,ind_bad,'bad');
[ind_b ind_g originerror0]=geometricsmooth(outdir,numclass,0.0001,0.0001,1,ind_good,'good');
fullerror=[fullerror;originerror];
% final=geometricsmooth(outdir,numclass,minpara(1),minpara(2),1,[],[]);
diary off;
save('./videoset/result/errorforsppairwise.mat','minerror');
save('./videoset/result/geometricsppairwise.mat','minpara');
save('fullerrorsp.mat','fullerror');
for iter=1:7:49
    if mod(iter,7)==1
        figure;
        subplot(1,8,1);bar(fullerror(iter,:));
        subplot(1,8,2);bar(fullerror(iter+1,:));
        subplot(1,8,3);bar(fullerror(iter+3,:));
        subplot(1,8,4);bar(fullerror(iter+4,:));
        subplot(1,8,5);bar(fullerror(iter+5,:));
        subplot(1,8,6);bar(fullerror(iter+6,:));
        subplot(1,8,7);bar(fullerror(iter+7,:));
        subplot(1,8,8);bar(fullerror(50,:));
    end      
end
% end