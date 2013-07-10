function traintphigherorder

load('./videoset/result/geometricsppairwise.mat');
minerror=1;
id=0;
 for para1=1:4
        parahigher1=exp(para1);
        for para2=-3:4
            parahigher2=exp(para2);
            for para3=-3:4
                parahigher3=exp(para3);
                for para4=-3:4
                    parahigher4=exp(para4);
                    for para5=-3:4
                        parahigher5=exp(para5);
                        id=id+1;
                        error{id}=higherorder(10^-4,10^-4,parahigher1,parahigher2,parahigher3,parahigher4,parahigher5,0);
                        if mean(error{id})<minerror
                            minparahigher=[parahigher1 parahigher2 parahigher3 parahigher4 parahigher5 ];
                            minerror=mean(error{id});
                        end
                    end
                end
            end
        end
 end
% originerror{id}=higherorder(imsegs,0,0,parahigher1,parahigher2,parahigher3,parahigher4,parahigher5); 
fprintf('Final weights are %e,%e,%e,%e,%e\n',parahigher1,parahigher2,parahigher3,parahigher4,parahigher5);
error=cell2mat(error);
save('./videoset/result/errorfortphigherorder.mat','error');
save('./videoset/result/geometrictphigher.mat','minparahigher');
final=higherorder(10^-4,10^-4,minparahigher(1),minparahigher(2),minparahigher(3),minparahigher(4),minparahigher(5),1);
minerror1=1;
for ra=-3:4
    ratio=exp(ra);
    id=id+1;
    minparahigher=minparahigher*ratio;
    error1{id}=higherorder(minpara(1),minpara(2),minparahigher(1),minparahigher(2),minparahigher(3),minparahigher(4),minparahigher(5),0);
    if mean(error1{id})<minerror1
        minratio=ratio;
        minerror=mean(error1{id});
    end
end
fprintf('Final ratio between higherorder and pairwise term is %e \n',ratio);
save('./videoset/result/geometrictphigherandpairwise.mat','minratio');
error1=cell2mat(error1);
save('./videoset/result/errorfortphigherorderandpairwise.mat','error1');
final=higherorder(minpara(1),minpara(2),minratio*minparahigher(1),minratio*minparahigher(2),minratio*minparahigher(3),minratio*minparahigher(4),minratio*minparahigher(5),1);
end