function traintphigherorder
addpath(genpath('/home/bliu/Desktop/project/'));
% load('./videoset/result/geometricsppairwiseval.mat');
% load('./videoset/result/geometrictppairwisetr3nvaln.mat');
% minerror=1;
% diary('tponlyhigherorderm.txt')
% diary on;
% choice1=1:0.7:4;
% choice2=-5:-2;
% finalchoice=[];
% fullchoice=[];
% for iter=1:length(choice2)
%     choice11=choice2(iter)*ones(length(choice2),1);
%     choice12=choice2';
%     finalchoice=[finalchoice;choice11 choice12];
% end
% for iter=1:length(choice1)
% %     choice21=iter*ones(length(choice1),1);
%     choice22=[choice1(iter)*ones(length(finalchoice),1) finalchoice];
%     fullchoice=[fullchoice;choice22];
% end
% fullerror=zeros(80,101);
% % gethigherorder;
% matlabpool(4);
% %  for para1=1:4
% %         parahigher1=exp(para1);
% %         for para2=-6:-2
% %             parahigher2=exp(para2);
% % %             for para3=-3:4
% % %                 parahigher3=exp(para3);
% % %                 for para4=-3:4
% % %                     parahigher4=exp(para4);
% %                     for para5=-6:-2
% %                         parahigher5=exp(para5);
% %                         id=id+1;
% parfor iter=1:80
% %     minpara=importdata('./videoset/result/geometricsppairwise.mat');
%     parahigher1=exp(fullchoice(iter,1));
%     parahigher2=exp(fullchoice(iter,2));
%     parahigher5=exp(fullchoice(iter,3));
%                         fprintf('/////////////////////PARAMITERS ARE %u, %u ,%u ///////////////////////\n',parahigher1,parahigher2,parahigher5);
% %                         error=higherorder(minpara(1),minpara(2),10^-4,10^-4,parahigher1,parahigher2,parahigher3,parahigher4,parahigher5,0);
%                         error=higherorder(0,1,parahigher1,parahigher2,parahigher5,0);
% %                         if mean(error)<=minerror
% % %                             minparahigher=[parahigher1 parahigher2 parahigher3 parahigher4 parahigher5 ];
% %                             minparahigher=[parahigher1 parahigher2 parahigher5 ];
% %                             minerror=mean(error);
% %                         end
%                         fprintf('///////////////CURRENT PARAMITER ERROR is %e/////////////\n',mean(error));
%                         fullerror(iter,:)=error;
% end
% matlabpool close;
% %                 end
% %             end
% %         end
% %  end
% % originerror{id}=higherorder(imsegs,0,0,parahigher1,parahigher2,parahigher3,parahigher4,parahigher5);
% [minerror minindx]=min(mean(fullerror,2));
% minparahigher=exp(fullchoice(minindx,:));
% % fprintf('Final weights are %e,%e,%e,%e,%e\n',minparahigher(1),parahigher2,parahigher3,parahigher4,parahigher5);
% fprintf('!!!!!!!!!!!!!!!!!!Final weights are %e,%e,%e!!!!!!!!!!!!!!!!!!!!!!\n',minparahigher(1),minparahigher(2),minparahigher(3));
% save('./videoset/result/errorfortphigherorderval.mat','minerror');
% save('./videoset/result/geometrictphigherval.mat','minparahigher');
% save('fullerrorhigherorderval.mat','fullerror');
% % final=higherorder(minpara(1),minpara(2),10^-4,10^-4,minparahigher(1),minparahigher(2),minparahigher(3),minparahigher(4),minparahigher(5),1);
% % final=higherorder(minpara(1),minpara(2),10^-4,10^-4,minparahigher(1),minparahigher(2),minparahigher(3),1);
% diary off;
load('./videoset/result/geometrictphigherval.mat');
diary('tphigherorderandparawise.txt')
diary on;
minerror1=1;
id=0;
fullerror=zeros(25,101);
for ra=-3:0.5:9
    ratio=exp(ra);
    fprintf('/////////////////////RATIO is %u ///////////////////////\n',ratio);
    id=id+1;
%     minparahigher=minparahigher*ratio;
%     error1=higherorder(minpara(1),minpara(2),minparabe(1),minparabe(2),minparahigher(1),minparahigher(2),minparahigher(3),minparahigher(4),minparahigher(5),0);
       error1=higherorder(1,ratio,minparahigher(1),minparahigher(2),minparahigher(3),0);
    if mean(error1)<minerror1
        minratio=ratio;
        minerror=mean(error1);
    end
    fullerror(id,:)=error1;
    fprintf('///////////////CURRENT PARAMITER ERROR is %e/////////////\n',mean(error1));
end
fprintf('!!!!!!!!!!!!!!!!!!!Final ratio between higherorder and pairwise term is %e !!!!!!!!!!!!!!!!!\n',ratio);
save('./videoset/result/geometrictphigherandpairwiseval.mat','minratio');
% error1=cell2mat(error1);
save('./videoset/result/errorfortphigherorderandpairwiseval.mat','minerror');
save('fullval.mat','fullerror');
% final=higherorder(minpara(1),minpara(2),minparabe(1),minparabe(2),minratio*minparahigher(1),minratio*minparahigher(2),minratio*minparahigher(3),minratio*minparahigher(4),minratio*minparahigher(5),1);
% final=higherorder(minpara(1),minpara(2),minratio*minparabe(1),minratio*minparabe(2),minparahigher(1),minparahigher(2),minparahigher(3),1);
diary off;
end
