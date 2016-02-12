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

nSubs = 4;
nToPlot = 20; %10
runComm = false;
computeHubs = false;
computeDegree = false;
whichTau = 3; %1 or 2 seems best
tauVal = '05';
whichNodes = 'all'; %'DMN'
dmn_rois = {'PL_R','PL_L','MO_R','MO_L','VO_R','VO_L','LO_R','LO_L','DLO_R','DLO_L','insularCx_R','insularCx_L','Cg2_R','Cg1_L','Cg2_R','Cg2_L','IL_R','IL_L','retrosplenialCx_R','retrosplenialCx_L','hippocampus_R','hippocampus_L'};

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

% Make weighted/undirected adjacency matrix from partial correlation
% matrices of each run
disp('---------------------------------------')
disp('-------Making Adjacency Matrices-------')
disp('---------------------------------------')
disp(' ')
A_on = make_adjacency(onDataDir, onRuns, 'ON', nSubs, whichNodes);
A_off = make_adjacency(offDataDir, offRuns, 'OFF', nSubs, whichNodes);

if (computeHubs)
    % Compute hubs
    disp('---------------------------------------')
    disp('---------Computing Network Hubs--------')
    disp('---------------------------------------')
    disp(' ')
    [betweenness_on meanBetween_on] = compute_hubs(A_on, nSubs, 'ON', result_dir, roi_names, '_thresh05', whichNodes);
    [betweenness_off meanBetween_off] = compute_hubs(A_off, nSubs, 'OFF', result_dir, roi_names, '_thresh05', whichNodes);

    [sorted_between_on sorted_between_on_index] = sort(meanBetween_on, 1, 'descend');
    sorted_between_rois_on = roi_names(sorted_between_on_index)';

    [sorted_between_off sorted_between_off_index] = sort(meanBetween_off, 1, 'descend');
    sorted_between_rois_off = roi_names(sorted_between_off_index)';

    between_diff = meanBetween_on - meanBetween_off;
    [sorted_between_diff sorted_between_diff_index] = sort(between_diff, 1, 'descend');
    sorted_between_rois_diff = roi_names(sorted_between_diff_index)';

    %subplot(1,2,1)
    fHand = figure(1);
    aHand = axes('parent',fHand);
    hold(aHand,'on')
    colors = hsv(2);
    for i = 1:numel(sorted_between_rois_on)
        if any(strcmp(sorted_between_rois_on(i),dmn_rois))
            bar(i,sorted_between_on(i),'parent',aHand, 'facecolor', colors(2,:));
        else
            bar(i,sorted_between_on(i),'parent',aHand, 'facecolor', colors(1,:));
        end
    end
    title('top hubs ON stim');
    %xticklabel_rotate(1:nToPlot,90,sorted_between_rois_on(1:nToPlot));
    xticklabel_rotate(1:numel(sorted_between_rois_on),90,sorted_between_rois_on);


    saveas(gcf,[result_dir 'Allhubs_ON_thresh05.png'])
    %saveas(gcf,[result_dir 'DMNhubs_ON_thresh05.png'])

    %subplot(1,2,2)
    fHand = figure(2);
    aHand = axes('parent',fHand);
    hold(aHand,'on')
    colors = hsv(2);
    for i = 1:numel(sorted_between_rois_off)
        if any(strcmp(sorted_between_rois_off(i),dmn_rois))
            bar(i,sorted_between_off(i),'parent',aHand, 'facecolor', colors(2,:));
        else
            bar(i,sorted_between_off(i),'parent',aHand, 'facecolor', colors(1,:));
        end
    end
    title('top hubs OFF stim');
    %xticklabel_rotate(1:nToPlot,90,sorted_between_rois_off(1:nToPlot));
    xticklabel_rotate(1:numel(sorted_between_rois_off),90,sorted_between_rois_off);

    %saveas(gcf,[result_dir 'Allhubs_OFF_thresh05.png'])
    saveas(gcf,[result_dir 'DMNhubs_OFF_thresh05.png'])

    fHand = figure(3);
    aHand = axes('parent',fHand);
    hold(aHand,'on')
    colors = hsv(2);
    for i = 1:numel(sorted_between_rois_off)
        if any(strcmp(sorted_between_rois_diff(i),dmn_rois))
            bar(i,sorted_between_diff(i),'parent',aHand, 'facecolor', colors(2,:));
        else
            bar(i,sorted_between_diff(i),'parent',aHand, 'facecolor', colors(1,:));
        end
    end
    title('top hubs ON - OFF');
    %xticklabel_rotate(1:nToPlot,90,sorted_between_rois_off(1:nToPlot));
    xticklabel_rotate(1:numel(sorted_between_rois_diff),90,sorted_between_rois_diff);

    %saveas(gcf,[result_dir 'Allhubs_diff_thresh05.png'])
    saveas(gcf,[result_dir 'DMNhubs_OFF_thresh05.png'])

end

if (computeDegree)
    % Compute degree
    disp('---------------------------------------')
    disp('--------Computing Network Degree-------')
    disp('---------------------------------------')
    disp(' ')
    [degree_on meanDegree_on] = compute_degree(A_on, nSubs, 'ON', result_dir, roi_names, '_thresh05', 'DMN');
    [degree_off meanDegree_off] = compute_degree(A_off, nSubs, 'OFF', result_dir, roi_names, '_thresh05', 'DMN');

    [sorted_degree_on sorted_degree_on_index] = sort(meanDegree_on', 1, 'descend');
    sorted_degree_rois_on = roi_names(sorted_degree_on_index)';

    [sorted_degree_off sorted_degree_off_index] = sort(meanDegree_off', 1, 'descend');
    sorted_degree_rois_off = roi_names(sorted_degree_off_index)';

    degree_diff = meanDegree_on' - meanDegree_off';
    [sorted_degree_diff sorted_degree_diff_index] = sort(degree_diff, 1, 'descend');
    sorted_degree_rois_diff = roi_names(sorted_degree_diff_index)';

    %subplot(1,2,1)
    % figure(3)
    % bar(sorted_degree_on(1:nToPlot));
    % title('most connected rois ON stim');
    % xticklabel_rotate([1:nToPlot],90,sorted_degree_rois_on(1:nToPlot)');

    fHand = figure(4);
    aHand = axes('parent',fHand);
    hold(aHand,'on')
    colors = hsv(2);
    for i = 1:numel(sorted_degree_rois_off)
        if any(strcmp(sorted_degree_rois_off(i),dmn_rois))
            bar(i,sorted_degree_off(i),'parent',aHand, 'facecolor', colors(2,:));
        else
            bar(i,sorted_degree_off(i),'parent',aHand, 'facecolor', colors(1,:));
        end
    end
    title('most connected rois OFF stim');
    %xticklabel_rotate(1:nToPlot,90,sorted_degree_rois_off(1:nToPlot));
    xticklabel_rotate(1:numel(sorted_degree_rois_off),90,sorted_degree_rois_off);


    saveas(gcf,[result_dir 'Alldegree_OFF_thresh05.png'])
    %saveas(gcf,[result_dir 'DMNdegree_OFF_thresh05.png'])

    %subplot(1,2,2)
    % figure(4)
    % bar(sorted_degree_off(1:nToPlot))
    % title('most connected rois OFF stim')
    % xticklabel_rotate([1:nToPlot],90,sorted_degree_rois_off(1:nToPlot)');

    fHand = figure(5);
    aHand = axes('parent',fHand);
    hold(aHand,'on')
    colors = hsv(2);
    for i = 1:numel(sorted_degree_rois_on)
        if any(strcmp(sorted_degree_rois_on(i),dmn_rois))
            bar(i,sorted_degree_on(i),'parent',aHand, 'facecolor', colors(2,:));
        else
            bar(i,sorted_degree_on(i),'parent',aHand, 'facecolor', colors(1,:));
        end
    end
    title('most connected rois ON stim');
    %xticklabel_rotate(1:nToPlot,90,sorted_degree_rois_on(1:nToPlot));
    xticklabel_rotate(1:numel(sorted_degree_rois_on),90,sorted_degree_rois_on);

    saveas(gcf,[result_dir 'Alldegree_ON_thresh05.png'])
    %saveas(gcf,[result_dir 'DMNdegree_ON_thresh05.png'])

    fHand = figure(6);
    aHand = axes('parent',fHand);
    hold(aHand,'on')
    colors = hsv(2);
    for i = 1:numel(sorted_degree_rois_off)
        if any(strcmp(sorted_degree_rois_diff(i),dmn_rois))
            bar(i,sorted_degree_diff(i),'parent',aHand, 'facecolor', colors(2,:));
        else
            bar(i,sorted_degree_diff(i),'parent',aHand, 'facecolor', colors(1,:));
        end
    end
    title('top hubs ON - OFF');
    %xticklabel_rotate(1:nToPlot,90,sorted_degree_rois_off(1:nToPlot));
    xticklabel_rotate(1:numel(sorted_degree_rois_diff),90,sorted_degree_rois_diff);

    saveas(gcf, [result_dir 'Alldegree_diff_thresh05.png'])

end

% Compute Modularity
disp('---------------------------------------')
disp('-----Computing Community Structure-----')
disp('---------------------------------------')
disp(' ')
% calculated with:
% tau = {0, 0.25, 0.5, 0.75, 1};

if (runComm)
    [Ciu_on Q_on] = compute_consensus_cluster(A_on, nSubs, 'ON', result_dir, roi_names, 2); %1000
    [Ciu_off Q_off] = compute_consensus_cluster(A_off, nSubs, 'OFF', result_dir, roi_names, 2); %1000
else %consensus clustering takes a long time so if it has already been run, just load data
    load(strcat(result_dir,'SSFO_ON_modularity.mat'));
    Ciu_on = Ciu;
    load(strcat(result_dir,'SSFO_OFF_modularity.mat'));
    Ciu_off = Ciu;
end

[sorted_Ciu_on sorted_Ciu_on_index] = sort(Ciu_on{whichTau}, 1, 'descend');
sorted_Ciu_on_rois = roi_names(sorted_Ciu_on_index)';

[sorted_Ciu_off sorted_Ciu_off_index] = sort(Ciu_off{whichTau}, 1, 'descend');
sorted_Ciu_off_rois = roi_names(sorted_Ciu_off_index)';


fHand = figure(7);
aHand = axes('parent',fHand);
hold(aHand,'on')
colors = hsv(2);
for i = 1:numel(Ciu_on{2})
    if any(strcmp(sorted_Ciu_on_rois(i),dmn_rois))
        bar(i,sorted_Ciu_on(i),'parent',aHand, 'facecolor', colors(2,:));
    else
        bar(i,sorted_Ciu_on(i),'parent',aHand, 'facecolor', colors(1,:));
    end
end
title('Community Structure ON stim');
%xticklabel_rotate(1:nToPlot,90,sorted_degree_rois_on(1:nToPlot));
xticklabel_rotate(1:numel(sorted_Ciu_on_rois),90,sorted_Ciu_on_rois);

saveas(gcf, strcat(result_dir, 'modularity_ON_tau', tauVal, '.png'))

fHand = figure(8);
aHand = axes('parent',fHand);
hold(aHand,'on')
colors = hsv(2);
for i = 1:numel(Ciu_off{2})
    if any(strcmp(sorted_Ciu_off_rois(i),dmn_rois))
        bar(i,sorted_Ciu_off(i),'parent',aHand, 'facecolor', colors(2,:));
    else
        bar(i,sorted_Ciu_off(i),'parent',aHand, 'facecolor', colors(1,:));
    end
end
title('Community Structure OFF stim');
%xticklabel_rotate(1:nToPlot,90,sorted_degree_rois_off(1:nToPlot));
xticklabel_rotate(1:numel(sorted_Ciu_off_rois),90,sorted_Ciu_off_rois);

saveas(gcf, strcat(result_dir, 'modularity_OFF_tau', tauVal, '.png'))

%[reordered_Ciu_on reordered_A_on] = reorder_networks(Ciu_on, A_on, nSubs, 'ON', result_dir, roi_names);
%[reordered_Ciu_off reordered_A_off] = reorder_networks(Ciu_off, A_off, nSubs, 'OFF', result_dir, roi_names);

% Compute intermodular measures
disp('---------------------------------------')
disp('----Computing Intermodular Measures----')
disp('---------------------------------------')
disp(' ')

%module degree z score and participation coefficient
Amu_on = cat(3, A_on{:});
Amu_on = mean(Amu_on, 3);

Amu_off = cat(3, A_off{:});
Amu_off = mean(Amu_off, 3);

for i = 1:length(Ciu_on)

    P_on{i} = participation_coef(Amu_on, Ciu_on{i});
    Z_on{i} = module_degree_zscore(Amu_on, Ciu_on{i});
    
    P_off{i} = participation_coef(Amu_off, Ciu_off{i});
    Z_off{i} = module_degree_zscore(Amu_off, Ciu_off{i});

end

[sorted_P_on sorted_P_on_index] = sort(P_on{whichTau}, 1, 'descend');
sorted_P_on_rois = roi_names(sorted_P_on_index)';

[sorted_P_off sorted_P_off_index] = sort(P_off{whichTau}, 1, 'descend');
sorted_P_off_rois = roi_names(sorted_P_off_index)';

[sorted_Z_on sorted_Z_on_index] = sort(Z_on{whichTau}, 1, 'descend');
sorted_Z_on_rois = roi_names(sorted_Z_on_index)';

[sorted_Z_off sorted_Z_off_index] = sort(Z_off{whichTau}, 1, 'descend');
sorted_Z_off_rois = roi_names(sorted_Z_off_index)';

fHand = figure(9);
aHand = axes('parent',fHand);
hold(aHand,'on')
colors = hsv(2);
for i = 1:numel(P_on{2})
    if any(strcmp(sorted_P_on_rois(i),dmn_rois))
        bar(i,sorted_P_on(i),'parent',aHand, 'facecolor', colors(2,:));
    else
        bar(i,sorted_P_on(i),'parent',aHand, 'facecolor', colors(1,:));
    end
end
title('Participation Coefficient ON stim');
%xticklabel_rotate(1:nToPlot,90,sorted_degree_rois_on(1:nToPlot));
xticklabel_rotate(1:numel(sorted_P_on_rois),90,sorted_P_on_rois);

saveas(gcf, strcat(result_dir, 'pCoeff_ON_tau', tauVal, '.png'))

fHand = figure(10);
aHand = axes('parent',fHand);
hold(aHand,'on')
colors = hsv(2);
for i = 1:numel(P_off{2})
    if any(strcmp(sorted_P_off_rois(i),dmn_rois))
        bar(i,sorted_P_off(i),'parent',aHand, 'facecolor', colors(2,:));
    else
        bar(i,sorted_P_off(i),'parent',aHand, 'facecolor', colors(1,:));
    end
end
title('Participation Coefficient OFF stim');
%xticklabel_rotate(1:nToPlot,90,sorted_degree_rois_off(1:nToPlot));
xticklabel_rotate(1:numel(sorted_P_off_rois),90,sorted_P_off_rois);

saveas(gcf, strcat(result_dir, 'pCoeff_OFF_tau', tauVal, '.png'))

fHand = figure(11);
aHand = axes('parent',fHand);
hold(aHand,'on')
colors = hsv(2);
for i = 1:numel(Z_on{2})
    if any(strcmp(sorted_Z_on_rois(i),dmn_rois))
        bar(i,sorted_Z_on(i),'parent',aHand, 'facecolor', colors(2,:));
    else
        bar(i,sorted_Z_on(i),'parent',aHand, 'facecolor', colors(1,:));
    end
end
title('Within-Module Degree Z-score ON stim');
%xticklabel_rotate(1:nToPlot,90,sorted_degree_rois_on(1:nToPlot));
xticklabel_rotate(1:numel(sorted_Z_on_rois),90,sorted_Z_on_rois);

saveas(gcf, strcat(result_dir, 'zScore_ON_tau', tauVal, '.png'))

fHand = figure(12);
aHand = axes('parent',fHand);
hold(aHand,'on')
colors = hsv(2);
for i = 1:numel(Z_off{2})
    if any(strcmp(sorted_Z_off_rois(i),dmn_rois))
        bar(i,sorted_Z_off(i),'parent',aHand, 'facecolor', colors(2,:));
    else
        bar(i,sorted_Z_off(i),'parent',aHand, 'facecolor', colors(1,:));
    end
end
title('Within-Module Degree Z-score OFF stim');
%xticklabel_rotate(1:nToPlot,90,sorted_degree_rois_off(1:nToPlot));
xticklabel_rotate(1:numel(sorted_Z_off_rois),90,sorted_Z_off_rois);

saveas(gcf, strcat(result_dir, 'zScore_OFF_tau', tauVal, '.png'))

disp(strcat('Finished! Results saved in ', result_dir))









