% function traintppairwise
addpath(genpath('/home/bliu/Desktop/project/'));
load('./videoset/result/geometricsppairwise.mat');
minerror=1;
id=0;
choice=[-5 -3 -1 1 3 5];
diary('tempairwisetermn.txt')
diary on;
fullerror=zeros(36,468);
% for para1=choice
%     paraout1=exp(para1);
%     for para2=choice
%         paraout2=exp(para2);
%            id=id+1;
finalchoice=[];
for iter=1:length(choice)
    choice1=choice(iter)*ones(length(choice),1);
    choice2=choice';
    finalchoice=[finalchoice;choice1 choice2];
end
matlabpool(4);
parfor iter=1:36
           paraout1=exp(finalchoice(iter,1));
           paraout2=exp(finalchoice(iter,2));    
           fprintf('/////////////////////PARAMITER 1 is %u and 2 is %u///////////////////////\n',paraout1,paraout2);
           [ind_bad ind_good error]=tppairwise(minpara(1),minpara(2),paraout1,paraout2,0,[],[]);
           [ind_b ind_g error0]=tppairwise(minpara(1),minpara(2),paraout1,paraout2,1,ind_bad,'bad');
           [ind_b ind_g error0]=tppairwise(minpara(1),minpara(2),paraout1,paraout2,1,ind_good,'good');

           fprintf('///////////////CURRENT PARAMITER ERROR is %e/////////////\n',mean(error));
           fullerror(iter,:)=error;
%     end
end
matlabpool close;
[minerror minindx]=min(mean(fullerror,2));
minparabe=exp(finalchoice(minindx));
% originerror=tppairwise(minpara(1),minpara(2),0,0,1);
fprintf('!!!!!!!!!!!!!!!!!!!!!Final weights are %e and %e for paraout1 and paraout2!!!!!!!!!!!!!!\n',minparabe(1),minparabe(2));
[ind_bad ind_good final]=tppairwise(minpara(1),minpara(2),minparabe(1),minparabe(2),1,[],[]);
diary off;
save('./videoset/result/errorfortppairwise.mat','minerror');
save('./videoset/result/geometrictppairwise.mat','minparabe');
save('fullerrortp.mat','fullerror');
for iter=1:6:36
    if mod(iter,6)==1
        figure;
        subplot(1,6,1);bar(fullerror(iter,:));
        subplot(1,6,2);bar(fullerror(iter+1,:));
        subplot(1,6,3);bar(fullerror(iter+3,:));
        subplot(1,6,4);bar(fullerror(iter+4,:));
        subplot(1,6,5);bar(fullerror(iter+5,:));
        subplot(1,6,6);bar(fullerror(iter+6,:));
    end      
end