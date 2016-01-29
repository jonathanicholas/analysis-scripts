clear all
close all
clc

addpath('/mnt/musk2/home/jnichola/BCT/')

result_dir = '/mnt/musk2/home/jnichola/mPFC_ofMRI/results/';

%%%%% Load/Prep Data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

currDataDir = ('/mnt/mandarin2/Public_Data/OptofMRI/Stanford_Prefrontal_Reward/CorrelationAndPartialCorrelationAnalysis/SSFO_ON/');
%currDataDir = ('/mnt/mandarin2/Public_Data/OptofMRI/Stanford_Prefrontal_Reward/CorrelationAndPartialCorrelationAnalysis/SSFO_OFF/');

runs = {'SSFO_ON_RatA_run1','SSFO_ON_RatA_run2','SSFO_ON_RatB_run1','SSFO_ON_RatC_run1','SSFO_ON_RatC_run2','SSFO_ON_RatD_run1','SSFO_ON_RatD_run2'};
%runs = {'SSFO_OFF_RatA_run1','SSFO_OFF_RatA_run2','SSFO_OFF_RatA_run3','SSFO_OFF_RatB_run1','SSFO_OFF_RatC_run1','SSFO_OFF_RatD_run1','SSFO_OFF_RatD_run2'};

stim = 'ON';
%stim = 'OFF';

threshold = 0.5;
nSubs = 4;

A = make_adjacency(currDataDir, runs, stim, threshold, nSubs);

%loading and removing number from roi name file
old_names = importdata('/mnt/mandarin2/Public_Data/OptofMRI/Stanford_Prefrontal_Reward/TimeseriesData_MotionCorrected/ROILabels_shortForm.txt',',');
for ii = 1:length(old_names)
    for jj = 1:length(old_names{ii})
        if old_names{ii}(jj) == ' ' && jj < length(old_names{ii})
            roi_names{ii} = old_names{ii}(jj+1:length(old_names{ii})-1);
        end    
    end
end

nrois = length(roi_names);
gamma = 1;
numIters = 2; %1000
numReps = 1; %100

Qs = cell(1,nSubs);
matchedQs = cell(1, nSubs);

for sub = 1:nSubs
    for ii = 1:numIters
        
        matchedA = null_model_und_sign(A{sub});
        [matched_Ci matched_Q] = community_louvain(abs(matchedA),gamma);
        
        for jj = 1:numReps
            
            [CiforMax{jj} QforMax(jj)] = community_louvain(A{sub},gamma);
        
        end
        
        Q = find(QforMax == max(QforMax));
        Q = Q(1);
        Ci = CiforMax{Q};
        Q = QforMax(Q);
        
        Qs{sub} = [Qs{sub} Q];
        matchedQs{sub} = [matchedQs{sub} matched_Q];
        
        currentModularity = Ci;
        coClassification = zeros(nrois, nrois);
        
        for row = 1:nrois
            currVal = currentModularity(row);
            for col = 1:nrois
                if currentModularity(row) == currentModularity(col)
                    coClassification(row,col) = 1;
                end
            end
            coClassification(row,row) = 0;
        end
        coClassification_sub{ii} = coClassification;
    end
    
    coClassificationMat{sub} = coClassification_sub;
    Qs{sub} = median(Qs{sub});
    matchedQs{sub} = median(matchedQs{sub});
    
end

Qs = cell2mat(Qs);
matchedQs = cell2mat(matchedQs);

[Q_pVal Q_hVal] = ranksum(Qs, matchedQs);

for sub = 1:nSubs
    for ii = 1:numIters
        if ii == 1
            currMat = bsxfun(@plus, coClassificationMat{sub}{ii}, coClassificationMat{sub}{ii+1});
        elseif ii ~= numIters
            currMat = bsxfun(@plus, currMat, coClassificationMat{a}{ii+1});
        else
            currMat = bsxfun(@plus, currMat, coClassificationMat{a}{ii});
        end
    end
    individualcoClass{sub} = currMat;
end

for sub = 1:nSubs
    
    for ii = 1:numIters
        matched_groupA = null_model_und_sign(individualcoClass{sub});
        [matched_groupCi matched_group_Q] = community_louvain(abs(matched_groupA), gamma); 
    
        matched_groupQ(ii) = matched_group_Q; 
    end
    
    matched_groupQ = median(matched_groupQ);
    
    for jj = 1:numReps
        [CiforMax_coClass{jj} QforMax_coClass{jj}] = community_louvain(abs(individualcoClass{sub}), gamma);
    end
    
    groupQmax = find(QforMax_coClass == max(QforMax_coClass));
    groupQmax = Qmax(1);
    groupCI = CiforMax_coClass{groupQmax};
    groupQ = QforMax_coClass(groupQmax);
    
    groupCurrMod = groupCI;
    groupCIs(:,sub) = groupCurrMod;
    
    group_coClass = zeros(nrois, nrois)
    for row = 1:nrois
       currVal = groupCurrMod(row);
       for col = 1:nrois
            if groupCurrMod(row) == groupCurrMod(col)
                group_coClass(row,col) = 1;
            end
        end
        group_coClass(row,row) = 0;
    end
    coClassification_group{sub} = group_coClass;
end

[groupQ_pVal groupQ_hVal] = ranksum(groupQ, matched_groupQ);

for sub = 1:nSubs
    if sub == 1
        currMat = bsxfun(@plus, coClassification_group{sub}, coClassification_group{sub+1})
    elseif sub ~= numIters
        currMat = bsxfun(@plus, currMat, coClassification_group{a}(i+1));
    else
        currMat = bsxfun(@plus, currMat, coClassification_group{a}{i});
    end
    groupcoClass = currMat;
end

for sub = 1:nSubs
    for ii = 1:numIters
        matched_finalA = null_model_und_sign(groupcoClass{a});
        [matched_finalCi matched_finQ] = community_louvain(abs(matched_finalA), gamma);
    
        matched_finalQ(ii) = matched_finQ;
    end
    
    matched_finalQ = median(matched_finalQ);
    matched_final_Q(sub) = matched_finalQ;
end

[finalCi finalQ] = community_louvain(abs(groupcoClass),gamma);

[final_pVal final_hVal] = ranksum(finalQ, matched_final_Q);

finalCi'
































