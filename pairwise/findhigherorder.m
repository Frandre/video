function [higherorder G]=findhigherorder(adjarry,startnumber,imcolor)

% endid=find((isnan(adjarry(:,2)))|(adjarry(:,2)>=startnumber));
% for iter=1:length(endid)
%     iditer=endid(iter);
%     firstcol_endid=adjarry(iditer,1);
%     clique=[];
%     while sum(adjarry(:,2)==firstcol_endid)&&(firstcol_endid>endnumber)
%         secondcol_endid=find(adjarry(:,2)==firstcol_endid);
%         clique=[clique secondcol_endid];
%         firstcol_endid=adjarry(secondcol_endid,1);
%     end
% 
%     clique=[clique firstcol_endid];
%     if length(clique)==1
%         continue;
%     else
%         id=id+1;
%         higherorder(id).ind=clique;
%         higherorder(id).w=ones(length(clique),1);
%         higherorder(id).Q=length(clique)/para0;
%     
%         G=var(color(clique,:));
%         gamma=(length(clique).^para1*(para2+para3*exp(-G*para4)));
%     
%         higherorder(id).gamma=gamma*ones(classnum+1,1);
%     end
% end
id=0;
for iter=1:length(adjarry)
    clique=[iter];
    firstcol_endid=adjarry(iter,1);
    secondcol_endid=adjarry(iter,2);
    while ~isnan(secondcol_endid)&&secondcol_endid<=startnumber
        clique=[clique,secondcol_endid];        
        firstcol_endid=adjarry(secondcol_endid,1);
        secondcol_endid=adjarry(firstcol_endid,2);
    end
    
    if secondcol_endid>startnumber
        clique=[clique,secondcol_endid];
    end
    
    if length(clique)<=2
        continue;
    else
        id=id+1;
        clique=unique(clique);
        higherorder(id).ind=clique';
        higherorder(id).w=ones(length(clique),1);
        higherorder(id).Q=length(clique);
    
        G(id)=sum(sum((imcolor(clique(1:end-1),1:3)-imcolor(clique(2:end),1:3)).^2,2))/length(clique);
%         gamma=(length(clique).^para1*(para2+para3*exp(-G*para4)));
%     
%         higherorder(id).gamma=gamma*ones(classnum+1,1);
    end
    
end
end