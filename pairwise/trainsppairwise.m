function trainsppairwise
addpath(genpath('/home/bliu/Desktop/project/'));
outdir='./videoset/';
fprintf('START TRAINING\n');
numclass=5;
minerror=1;
id=0;
choice=[-6,-4,-2,0,2,4,6];
% diary('spacepairwisetermn.txt')
% diary on;
for para1=choice
    parain1=exp(para1);
    for para2=choice
        parain2=exp(para2);
        id=id+1;
        fprintf('/////////////////////PARAMITER 1 IS %u and 2 is %u///////////////////////\n',parain1,parain2);
        error=geometricsmooth(outdir,numclass,parain1,parain2,0);
        
        if mean(error)<=minerror
            minpara=[parain1 parain2];
            minerror=mean(error);
        end
        fprintf('///////////////CURRENT PARAMITER ERROR is %e/////////////\n',mean(error));
    end
end
% originerror=geometricsmooth(outdir,numclass,0,0,1);
fprintf('Final weights are %e and %e for parain1 and parain2\n',minpara(1),minpara(2));
final=geometricsmooth(outdir,numclass,minpara(1),minpara(2),1);
% diary off;
% error=cell2mat(error);
% originerror=cell2mat(error);
save('./videoset/result/errorforsppairwise.mat','minerror');
save('./videoset/result/geometricsppairwise.mat','minpara');
end