function gethigherorder
names=importdata('../myCamVid/framenames.txt');
fullnames=importdata('../data/framenames.txt');

choice=1:length(names);
for currentseq=choice
    imnames=names{currentseq};
    id=0;
    filename=[imnames,'_tem_pairwise_sptpunaryn.mat'];
    load(['./videoset/tem/',filename],'count');
    infullnamesiter=find(strcmp(fullnames,imnames)==1);
    imcolor=cell(9,1);
    connregion=cell(8,1);
    for frameiter=-4:4
        filename=[fullnames{infullnamesiter+frameiter}, '.labcolor.mat'];
        load(['./videoset/tem/',filename]);
        imcolor{frameiter+5}=imagecolor;
        filename=[fullnames{infullnamesiter+frameiter}, '.next.mat'];
        load(['./videoset/tem/',filename]);
        id=id+1;
        if frameiter~=4
             connregion{frameiter+5}=[(1:count(id))'+sum(count(1:id))-count(id), ...
                   selectregion++sum(count(1:id))];
        end
    end
    
    connregion=cell2mat(connregion);
    imcolor=cell2mat(imcolor);
    [hop G]=findhigherorder(connregion,sum(count)-count(end),imcolor);
    filename=[imnames,'_higherorderalln.mat'];
    save(['./videoset/tem/',filename],'hop','G');
    fprintf('--------------Image %s finish the higherorder graph--------------%u number\n',imnames,currentseq);
end
end