function classifier=converttree2struture(classifier)

% sclassifier=classifier.sclassifier;
% eclassifier=classifier.eclassifier;
% vclassifier=classifier.vclassifier;
% hclassifier=classifier.hclassifier;
% vclassifierSP=classifier.vclassifierSP;
% hclassifierSP=classifier.hclassifierSP;

[row col]=size(classifier.wcs);
for iterrow=1:row
    for itercol=1:col
        dttree=classifier.wcs(iterrow,itercol).dt;        
        dt.method=dttree.method;
        dt.node=dttree.node;
        dt.parent=dttree.parent;
        dt.class=dttree.class;
        dt.var=dttree.var;
        dt.cut=dttree.cut;
        dt.children=dttree.children;
        dt.nodeprob=dttree.nodeprob;
        dt.nodeerr=dttree.nodeerr;
        dt.risk=dttree.risk;
        dt.nodesize=dttree.nodesize;
        dt.npred=dttree.npred;
        dt.catcols=dttree.catcols;
        dt.prior=dttree.prior;
        dt.nclasses=dttree.nclasses;
        dt.cost=dttree.cost;
        dt.classprob=dttree.classprob;
        dt.classcount=dttree.classcount;
        dt.classname=dttree.classname;
        dt.catsplit=dttree.catsplit;
        dt.alpha=dttree.alpha;
        dt.ntermnodes=dttree.ntermnodes;
        dt.prunelist=dttree.prunelist;
        
        classifier.wcs(iterrow,itercol).dt=dt;
    end
end
% classifier.sclassifier=sclassifier;
end