function traintppairwise
addpath(genpath('/home/bliu/Desktop/project/'));
load('./videoset/result/geometricsppairwise.mat');
minerror=1;
id=0;
choice=[-5 -3 -1 1 3 5];
% diary('tempairwisetermn1.txt')
% diary on;
for para1=choice
    paraout1=exp(para1);
    for para2=choice
        paraout2=exp(para2);
           id=id+1;
           fprintf('/////////////////////PARAMITER 1 IS %u and 2 is %u///////////////////////\n',paraout1,paraout2);
           error=tppairwise(minpara(1),minpara(2),paraout1,paraout2,0);
           if mean(error)<minerror
               minparabe=[paraout1 paraout2];
               minerror=mean(error);
           end
           fprintf('///////////////CURRENT PARAMITER ERROR is %e/////////////\n',mean(error));
    end
end
originerror=tppairwise(minpara(1),minpara(2),0,0,1);
final=tppairwise(minpara(1),minpara(2),minparabe(1),minparabe(2),1);
fprintf('Final weights are %e and %e for paraout1 and paraout2\n',minparabe(1),minparabe(2));
% error=cell2mat(error);
originalerror=mean(originerror);
% diary off;
save('./videoset/result/errorfortppairwise.mat','minerror','originerror');
save('./videoset/result/geometrictppairwise.mat','minparabe');
end