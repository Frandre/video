function displayresultimages(imnames,namecells,resultlabel,firstlabel,count)

imgdir='../data/images/';
vir='./videoset/tem/';
id=1; 
load color2id;
colormap=uint8(zeros(240*320,3));
unarymap=colormap;
row=240;
col=320;
    infullnamesiter=find(strcmp(namecells,imnames)==1);
    cc=0;
    for mmiter=-7:7
        currim=namecells{infullnamesiter+mmiter};
        load([vir,currim,'.segimage.mat']);
        
        im=imread([imgdir,currim,'.png']);
        reslabel=resultlabel(cc+1:cc+count(id));
        first=firstlabel(cc+1:cc+count(id));
        
        finallabel=region2pixel(reslabel+1,segimage);
        unlabel=region2pixel(first,segimage);
        
        for iter=1:5
            colormap(finallabel(:)==iter,:)=repmat(mapping(iter,:),sum(finallabel(:)==iter),1);
            unarymap(unlabel(:)==iter,:)=repmat(mapping(iter,:),sum(unlabel(:)==iter),1);
        end
        
        filename=[currim,'.temporalonlytr4-3-5.jpg'];
%         if mmiter==-4
            imwrite([im,reshape(colormap,row,col,3),reshape(unarymap,row,col,3)],['./videoset/tmpimage/-3-5long/'...
                ,filename],'jpg');
%         else
%             precuur=namecells{infullnamesiter+mmiter-1};
%             img=imread('./videoset/tmpimage/',precuur,'.temporalonly-3-5.jpg');
%             img=img(1:240,1:960,:);
%             fullim=[im,reshape(colormap,row,col,3),reshape(unarymap,row,col,3)];
%             imwrite([fullim;uint8(abs(fullim-img))],['./videoset/tmpimage/'...
%                 ,filename],'jpg');
%         end
        cc=cc+count(id);
        id=id+1;
    end

end