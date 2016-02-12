clear all
close all
clc

addpath('/mnt/musk2/home/jnichola/Plotting')
addpath('/mnt/musk2/home/jnichola/BCT')

result_dir = '/mnt/musk2/home/jnichola/mPFC_ofMRI/results/';

onDataDir = ('/mnt/mandarin2/Public_Data/OptofMRI/Stanford_Prefrontal_Reward/CorrelationAndPartialCorrelationAnalysis/SSFO_ON/');
offDataDir = ('/mnt/mandarin2/Public_Data/OptofMRI/Stanford_Prefrontal_Reward/CorrelationAndPartialCorrelationAnalysis/SSFO_OFF/');

onRuns = {'SSFO_ON_RatA_run1','SSFO_ON_RatA_run2','SSFO_ON_RatB_run1','SSFO_ON_RatC_run1','SSFO_ON_RatC_run2','SSFO_ON_RatD_run1','SSFO_ON_RatD_run2'};
offRuns = {'SSFO_OFF_RatA_run1','SSFO_OFF_RatA_run2','SSFO_OFF_RatA_run3','SSFO_OFF_RatB_run1','SSFO_OFF_RatC_run1','SSFO_OFF_RatD_run1','SSFO_OFF_RatD_run2'};

threshold = 0.5; %Threshold for creating adjacency matrix from correlation matrix (corrs > threshold = 1; corrs < threshold = 0)
nSubs = 4;
nToPlot = 20; %10

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

% Make adjacency matrix
disp('---------------------------------------')
disp('-------Making Adjacency Matrices-------')
disp('---------------------------------------')
disp(' ')
A_on = make_adjacency(onDataDir, onRuns, 'ON', threshold, nSubs);
A_off = make_adjacency(offDataDir, offRuns, 'OFF', threshold, nSubs);

reps = 1000;
tau = {0, 0.25, 0.5, 0.75, 1};
for t = 1:5
    for s = 1:nSubs
        for i = 1:reps
            %mA = null_model_und_sign(A_on{s});
            %[mCi{i} mQ{i}] = community_louvain(mA,[],[],'negative_sym');
            for j = 1:10
                [Cireps{j} Qreps(j)] = community_louvain(A_on{s},[],[],'negative_sym');
            end
            Qr = find(Qreps == max(Qreps));
            Qr = Qr(1);
            Q(:,i) = Qreps(Qr);
            Ci(:,i) = Cireps{Qr}';
        end
        %mD = agreement(mCi); 
        D = agreement(Ci);
        D = D/reps;
        %mCiu = consensus_und(mD,tau,reps);
        Ciu{t} = consensus_und(D, tau{t}, reps);
    end
end
%[Ciu_on mCiu_on] = compute_consensus_cluster(A_on, nSubs, 'ON', result_dir, roi_names, 1) %1000