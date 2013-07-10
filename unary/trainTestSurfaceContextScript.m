% trainTestSurfaceContextScript
% 
% Assumes you have created:
%   imsegs  :  data structure that contains information on all training
%              and testing images
%   trainind:  the indices of the training images
%   testind:   the indices of the testing images

basedir = '/home/bliu/Desktop/tem/myCamVid/data'; % set this appropriately
imdir = [basedir '/images'];
datadir = '/home/bliu/Desktop/tem/videoproject/newclassifier';
resultsdir = [basedir '/results'];
% imsegs=importdata('/home/bliu/Desktop/tem/videoproject/trainimage.mat');
% imsegs1=importdata('/home/bliu/Desktop/tem/videoproject/valimage.mat');
% imsegs0=importdata('/home/bliu/Desktop/tem/videoproject/testimage.mat');
% for iter=1:size(imsegs1,2)
%     imsegs(iter+367)=imsegs1(iter);
% end
% for iter=1:size(imsegs0,2)
%     imsegs(iter+468)=imsegs0(iter);
% end
load CamVidimsegs
trainind=1:468;
testind=469:701;

DO_TRAIN = 1;
DO_TEST = 1;

if DO_TRAIN

    nsegments = [10 20 30 40 50 60 80 100];

    % Computes the superpixel features
    load([datadir '/superpixelData.mat']);
%     if ~exist('spfeatures')
%         spfeatures = mcmcGetAllSuperpixelData(imdir, imsegs);
%         save([datadir '/superpixelData.mat'], 'spfeatures');
%     end

    % Trains the superpixel classifiers
    load([datadir '/superpixelClassifier.mat']);
%     if ~exist('vclassifierSP')
%         [vclassifierSP, hclassifierSP] = ...
%             mcmcTrainSuperpixelClassifier(spfeatures(trainind), imsegs(trainind));
%         vclassifierSP=converttree2struture(vclassifierSP);
%         hclassifierSP=converttree2struture(hclassifierSP);
%         save([datadir '/superpixelClassifier.mat'], 'vclassifierSP', 'hclassifierSP');
%     end

    % Computes the same-label features
    load([datadir '/edgeData.mat']);
%     if ~exist('efeatures')
%         [efeatures, adjlist] = mcmcGetAllEdgeData(spfeatures, imsegs);
%         save([datadir '/edgeData.mat'], 'efeatures', 'adjlist');
%     end

    % Trains the same-label classifier
    load([datadir '/edgeClassifier.mat']);
%     if ~exist('eclassifier')        
%         eclassifier = mcmcTrainEdgeClassifier(efeatures(trainind), ...
%             adjlist(trainind), imsegs(trainind));
%         ecal = calibrateEdgeClassifier(efeatures(trainind), adjlist(trainind), ...
%             imsegs(trainind), eclassifier, 4);
%         ecal = ecal{1};
%         eclassifier=converttree2struture(eclassifier);
%         save([datadir '/edgeClassifier.mat'], 'eclassifier', 'ecal');
%     end
    
    % Computes the multiple segmentations, the segment features, and the
    % ground truth labels for each segment
    
%     load([datadir '/allData.mat']);
    if ~exist('labdata')
        % gather data
        for f = 1:numel(imsegs)

            disp([num2str(f) ': ' imsegs(f).imname])

            [pvSP{f}, phSP{f}, pE{f}] = mcmcInitialize(spfeatures{f}, efeatures{f}, ...
                adjlist{f}, imsegs(f), vclassifierSP, hclassifierSP, eclassifier, ecal, 'none');
            smaps{f} = generateMultipleSegmentations2(pE{f}, adjlist{f}, imsegs(f).nseg, nsegments);

            im = im2double(imread([imdir '/' imsegs(f).imname]));
            imdata = mcmcComputeImageData(im, imsegs(f));

            for k = 1:numel(nsegments)
                labdata{f, k} = mcmcGetSegmentFeatures(imsegs(f), spfeatures{f}, imdata, smaps{f}(:, k), (1:max(smaps{f}(:, k))));
                [mclab{f, k}, mcprc{f, k}, allprc{f, k}, trainw{f, k}] = segmentation2labels(imsegs(f), smaps{f}(:, k));
                unilabel{f, k} = mclab{f, k}.*(mcprc{f, k}>0.95);
                seglabel{f,k} =  1*(mcprc{f, k}>0.95) + (-1)*(mcprc{f, k}<0.95);                                 
            end
        end
        save([datadir '/allData.mat'], 'smaps', 'labdata', 'mclab', 'mcprc', 'allprc', 'seglabel', 'unilabel', 'trainw', 'pvSP', 'phSP', 'pE');
    end
        
    % Trains the segment classifiers
    load([datadir '/allnewClassifiers.mat']);
%     if ~exist('vclassifier')     
%         sclassifier = mcmcTrainSegmentationClassifier2(labdata(trainind, :), seglabel(trainind, :), trainw(trainind, :)); 
%         [vclassifier, hclassifier] = ...
%             mcmcTrainSegmentClassifier2(labdata(trainind, :), unilabel(trainind, :), trainw(trainind, :));             
%     end
%     sclassifier=converttree2struture(sclassifier);
%     hclassifier=converttree2struture(hclassifier);
%     vclassifier=converttree2struture(vclassifier);
%     save([datadir '/allnewClassifiers.mat'], 'vclassifier', 'hclassifier', 'sclassifier', 'eclassifier', 'vclassifierSP', 'hclassifierSP','ecal');
% 
end

if DO_TEST
    
    % Computes the label confidences for each superpixel in the test images
    % and gives the final accuracy.
    % pg{image number}(superpixel number, [000 left center right porous solid sky])
    % gives the superpixel label confidences                                  
    [vacc, hacc, vcm, hcm, pg] = ...
        testMultipleSegmentationsCV2(imsegs, labdata, ...
        labdata, smaps, ...
        vclassifier, hclassifier, sclassifier, pvSP, phSP, 1);
    save([datadir '/newresults.mat'], 'vacc', 'hacc', 'vcm', 'hcm', 'pg');
%     testgeometricmethod;
    % Computes and writes the labeled images
%     for f = 1:testind
%         im = im2double(imread([imdir '/' imsegs(f).imname]));
%         [pv, ph] = splitpg(pg{f});
%         lim = APPgetLabeledImage2(im, imsegs(f), pv, ph);
%         imwrite(im, [resultsdir '/' imsegs(f).imname]);
%         imwrite(lim, [resultsdir '/' strtok(imsegs(f).imname, '.') '.l.jpg']);
%     end
end