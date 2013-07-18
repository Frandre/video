function result_ma=test_accuracy(num,la_real,la_re);
%TEST_ACCURACY generates final accuray matrtix for our prediction.

%num=8;%input('Number of Classes:');
%trainlist=improtdata('/home/paprika/Desktop/tem/CamVid/camvidTrainList.txt');
%resultlab_dir='/home/paprika/Desktop/result/';
% lab_files=dir(lab_dir);

%relab_dir='/home/paprika/Desktop/tem/CamVid/data/labels/';
% re_files=dir(re_dir);

%label_real=cell(size(lab_files,1),1);
%label_re=label_real;
%iter=1;
%num=7;
% for sample_num=1:length(trainlist)
%        filenamereal=[trainlist{1},'.txt');
%        templabel=importdata([resultlab_dir,filenamela]);
%        [row col]=size(templabel);
%        label_real{sample_num}=templabel(:);
        
%        filenameres=regexprep(filenamereal,'txt','mat');
%        load([relab_dir,filenameres]);
%        [row1 col1]=size(templabel);
%        label_re{sample_num}=templabel(:);
        
%        if row~=row1||col~=col1
%            fprintf('Processing %u image mistake\n',sample_num);
%        end
%    fprintf('Processing %u image finish\n',sample_num);
% end

% la_real=cell2mat(label_real);
% la_re=cell2mat(label_re);

%==============================In All Accracy=============================%

result_ma=cell(2,1);
%result_ma=cell(3,1);
%precision=zeros(1,2);

precision=length(find(la_real(la_real>0)==la_re(la_real>0)))/sum(la_real>0);
% precision(1)=length(find(la_real(:,1)==la_re(:,1)))/length(find(la_real(:,1)>=0));
% precision(2)=length(find(la_real(:,2)==la_re(:,2)))/length(find(la_real(:,2)>=0));        
result_ma{1}=precision;

%===========================Confusion Matrix==============================%
% 
% seman=zeros(8);
% geo=zeros(3);
% tran_re=zeros(length(la_re),1);
% tran_pre=2*ones(length(la_re),1);
% 
% for re_label=0:7
%     re_lab=find(la_real(:,1)==re_label);
%     tran_re(re_lab)=1;
%     for pre_label=0:7
%        pre_lab=find(la_re(:,1)==pre_label);
% %        pre_lab=find(la_re==pre_label+1);
%        tran_pre(pre_lab)=1;
%        same=length(find(tran_re==tran_pre));
%        seman(re_label+1,pre_label+1)=same/length(re_lab);
%        tran_pre=2*ones(length(la_re),1);
%     end
%     tran_re=zeros(length(la_re),1);
% end
% 
tran_re=zeros(length(la_re),1);
tran_pre=2*ones(length(la_re),1);
% 
% for re_label=0:2
%     re_lab=find(la_real(:,2)==re_label);
%     tran_re(re_lab)=1;
%     for pre_label=0:2
%        pre_lab=find(la_re(:,2)==pre_label);
%        tran_pre(pre_lab)=1;
%        geo(re_label+1,pre_label+1)=length(find(tran_re==tran_pre))/length(re_lab);
%        tran_pre=2*ones(length(la_re),1);
%     end
%     tran_re=zeros(length(la_re),1);
% end
% result_ma{2}=seman;
% result_ma{3}=geo;
confusion=zeros(num);
for re_label=1:num
    re_lab=find(la_real==re_label);
    tran_re(re_lab)=1;
    for pre_label=1:num
       pre_lab=find(la_re==pre_label);
       tran_pre(pre_lab)=1;
       confusion(re_label,pre_label)=length(find(tran_re==tran_pre))/length(re_lab);
       tran_pre=2*ones(length(la_re),1);
    end
    tran_re=zeros(length(la_re),1);
end
result_ma{2}=confusion;
% save('geo_5mapping.mat','result_ma');
end
