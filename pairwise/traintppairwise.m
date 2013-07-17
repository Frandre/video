% function traintppairwise
% flowd;
 framenames=importdata('../data/framenames.txt');
%  matlabpool(4);
%  parfor iter=1:length(framenames)-1
%      computeflow3(framenames,iter);
%      computeflow4(framenames,iter);
%      computeflow2(framenames,iter);
%      computeflow1(framenames,iter);
%  end
%  matlabpool close;
addpath(genpath('/home/bliu/Desktop/project/'));
load('./videoset/result/geometricsppairwise.mat');
minerror=1;
id=0;
choice=[-5 -4 -3 -1 0 1 2 2.5 3 3.5 4 4.5 5];
choice0=[0.1,0.3,0.5,0.7,0.9];
choice0=log(choice0);
diary('tempairwisetermn.txt')
diary on;
fullerror=zeros(65,468);
% for para1=choice
%     paraout1=exp(para1);
%     for para2=choice
%         paraout2=exp(para2);
%            id=id+1;
finalchoice=[];
for miter=1:length(choice0)
    choice1=choice0(miter)*ones(length(choice),1);
    choice2=choice';
    finalchoice=[finalchoice;choice1 choice2];
end
% getadjmat(1);
matlabpool(4);
parfor iter=1:65
           paraout1=exp(finalchoice(iter,1));
           paraout2=exp(finalchoice(iter,2));
           fprintf('/////////////////////PARAMITER 1 is %u and 2 is %u///////////////////////\n',paraout1,paraout2);
           [ind_bad ind_good error]=tppairwise(0,0,paraout1,paraout2,0,[],[],1);
%            [ind_b ind_g error0]=tppairwise(minpara(1),minpara(2),paraout1,paraout2,1,ind_bad,'bad');
%            [ind_b ind_g error0]=tppairwise(minpara(1),minpara(2),paraout1,paraout2,1,ind_good,'good');

           fprintf('///////////////CURRENT PARAMITER ERROR is %e/////////////\n',mean(error));
           fullerror(iter,:)=error;
%     end
end
matlabpool close;
[minerror minindx]=min(mean(fullerror,2));
minparabe=exp(finalchoice(minindx,:));
% originerror=tppairwise(minpara(1),minpara(2),0,0,1);
fprintf('!!!!!!!!!!!!!!!!!!!!!Final weights are %e and %e for paraout1 and paraout2!!!!!!!!!!!!!!\n',minparabe(1),minparabe(2));
tppairwise(minpara(1),minpara(2),minparabe(1),minparabe(2),1,[],[],1);
diary off;
save('./videoset/result/errorfortppairwisetr3n.mat','minerror');
save('./videoset/result/geometrictppairwisetr3n.mat','minparabe');
save('fullerrortptr3n.mat','fullerror');
% for iter=1:6:36
%     if mod(iter,6)==1
%         figure;
%         subplot(6,1,1);bar(fullerror(iter,:));
%         subplot(6,1,2);bar(fullerror(iter+1,:));
%         subplot(6,1,3);bar(fullerror(iter+2,:));
%         subplot(6,1,4);bar(fullerror(iter+3,:));
%         subplot(6,1,5);bar(fullerror(iter+4,:));
%         subplot(6,1,6);bar(fullerror(iter+5,:));
%     end
% end
getadjmat(0);
matlabpool(4);
parfor iter=1:65
           paraout1=exp(finalchoice(iter,1));
           paraout2=exp(finalchoice(iter,2));
           fprintf('/////////////////////PARAMITER 1 is %u and 2 is %u///////////////////////\n',paraout1,paraout2);
           [ind_bad ind_good error]=tppairwise(0,0,paraout1,paraout2,0,[],[],0);
%            [ind_b ind_g error0]=tppairwise(minpara(1),minpara(2),paraout1,paraout2,1,ind_bad,'bad');
%            [ind_b ind_g error0]=tppairwise(minpara(1),minpara(2),paraout1,paraout2,1,ind_good,'good');

           fprintf('///////////////CURRENT PARAMITER ERROR is %e/////////////\n',mean(error));
           fullerror(iter,:)=error;
%     end
end
matlabpool close;
[minerror minindx]=min(mean(fullerror,2));
minparabe=exp(finalchoice(minindx,:));
save('./videoset/result/errorfortppairwisetr2n.mat','minerror');
save('./videoset/result/geometrictppairwisetr2n.mat','minparabe');
save('fullerrortptr2n.mat','fullerror');





