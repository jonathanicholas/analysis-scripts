clear all
close all
clc

result_dir = '/mnt/musk2/home/jnichola/mPFC_ofMRI/results/';

onDataDir = ('/mnt/mandarin2/Public_Data/OptofMRI/Stanford_Prefrontal_Reward/CorrelationAndPartialCorrelationAnalysis/SSFO_ON/');
offDataDir = ('/mnt/mandarin2/Public_Data/OptofMRI/Stanford_Prefrontal_Reward/CorrelationAndPartialCorrelationAnalysis/SSFO_OFF/');

onRuns = {'SSFO_ON_RatA_run1','SSFO_ON_RatA_run2','SSFO_ON_RatB_run1','SSFO_ON_RatC_run1','SSFO_ON_RatC_run2','SSFO_ON_RatD_run1','SSFO_ON_RatD_run2'};
offRuns = {'SSFO_OFF_RatA_run1','SSFO_OFF_RatA_run2','SSFO_OFF_RatA_run3','SSFO_OFF_RatB_run1','SSFO_OFF_RatC_run1','SSFO_OFF_RatD_run1','SSFO_OFF_RatD_run2'};

threshold = 0.5; %Threshold for creating adjacency matrix from correlation matrix (corrs > threshold = 1; corrs < threshold = 0)
nSubs = 4;

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

% Compute hubs
disp('---------------------------------------')
disp('---------Computing Network Hubs--------')
disp('---------------------------------------')
disp(' ')
[betweenness_on meanBetween_on] = compute_hubs(A_on, nSubs, 'ON', result_dir, roi_names, '_thresh05');
[betweenness_off meanBetween_off] = compute_hubs(A_off, nSubs, 'OFF', result_dir, roi_names, '_thresh05');

% Compute degree
disp('---------------------------------------')
disp('--------Computing Network Degree-------')
disp('---------------------------------------')
disp(' ')
[degree_on meanDegree_on] = compute_degree(A_on, nSubs, 'ON', result_dir, roi_names, '_thresh05');
[degree_off meanDegree_off] = compute_degree(A_off, nSubs, 'OFF', result_dir, roi_names, '_thresh05');

% Compute Modularity

% Plot results

disp(strcat('Finished! Results saved in ', result_dir))