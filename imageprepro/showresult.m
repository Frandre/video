function showresult(choose,full)
names=importdata('../myCamVid/valnames.txt');
fullnames=importdata('../data/framenames.txt');
% labeldir='../myCamVid/data/labels';
if full
    load('./videoset/result/geometricsppairwiseval.mat');
    minpara1=minpara(1);
    minpara2=minpara(2);
else
    minpara1=0;
    minpara2=0;
end
if choose
    load('./videoset/result/geometrictppairwisetr3nvaln.mat');
    paraout1=minparabe(1);
    paraout2=minparabe(2);
    tem='tem1';
else
    load('./videoset/result/geometrictppairwisetr2nvaln.mat');
    paraout1=minparabe(1);
    paraout2=minparabe(2);
    tem='tem';
end
for currentseq=1:length(names)
    imnames=names{currentseq};
    filename=[imnames,'_tem_pairwise_sptpunaryn.mat'];
    load(['./videoset/',tem,'/',filename]);

%     filename=[imnames, '.mat'];
%     New_Id=importdata([labeldir,'/',filename])+1;

    tmpadj=adjbesp*paraout1+adjbecsp*(1-paraout1);
    adjval=nonzeros(tmpadj);
    adjid=find(ismember(tmpadj,adjval)==1);
    [adjx adjy]=ind2sub(size(tmpadj),adjid);
    AdjancentMatrixtp=sparse(adjx,adjy,exp(-adjval)*paraout2,size(tmpadj,1),size(tmpadj,2));

    adjval=nonzeros(adjinsp);
    adjid=find(ismember(adjinsp,adjval)==1);
    [adjx adjy]=ind2sub(size(adjinsp),adjid);
    AdjancentMatrixsp=sparse(adjx,adjy,adjval*minpara1+minpara2,size(adjinsp,1),size(adjinsp,2));
    
%     AdjancentMatrix=AdjancentMatrixtp+AdjancentMatrixsp;
%     if ~issparse(AdjancentMatrix)
%         AdjancentMatrix=sparse(AdjancentMatrix);
%     end

    if full
        save(['./videoset/',tem,'/',imnames,'_fulltpspmap.mat'],'AdjancentMatrixsp','AdjancentMatrixtp','unaryconf','count');
    end
    
%     AdjancentMatrix=sparse(newx,newy,newval,sum(count),sum(count));
%     [junk first]=max(unaryconf,[],2);
%     nodePot=single(-log(unaryconf));
%     SmoothnessCost=single(ones(5)-eye(5));
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     [reslabels energy afterenergy]=GCMex(first-1,nodePot',AdjancentMatrix,SmoothnessCost,1);
%     displayresultimages(imnames,fullnames,reslabels,first,count,tem,full);
end

end
