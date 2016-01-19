clc
clear all;

%Directory where data is located
%data_dir = '/mnt/apricot1_share6/oFMRI/DorsalHippocampusStim/';
data_dir = '/mnt/apricot1_share6/oFMRI/IntermediateHippocampusStim/';

%Names of folders for each subject
%subjects = {'cage138', 'cage152', 'cage154', 'cage55', 'cage60', 'cage68', 'cage69'};
%subjects = {'cage138', 'cage152', 'cage154', 'cage68', 'cage69'};
% cage55 and cage60 have NaN for all values in nodes we are looking at
subjects = {'cage132', 'cage133', 'cage142', 'cage143', 'cage144', 'cage147', 'cage148'};

%Prefix for each node
nodes = {'cg1_1_*', 'cg2_1_*', 'cg3_1_*', 'hypo_1_*', 'iDG_1_*', 'iHF_1_*', 'ins_1_*', 'rsp_1_*', 'spt_1_*'};

nodeLabels = {'cg1','cg2','cg3','hypo','iDG','iHF','ins','rsp','spt'};

%averages time series for each node
subject_data = average_timeseries(data_dir, subjects, nodes); 

%Group average
subject_data_mu = mean(cat(3, subject_data{:}), 3);

%calculate sample correlation coefficient matrix for group
for i = 1:length(nodes)
    for j = length(nodes):-1:1
        sample_R(i,j) = abs(sample_corr(subject_data_mu, [i, j]));
    end
end

figure;
imagesc(sample_R)
colorbar
set(gca,'XTickLabel',nodeLabels)
set(gca,'YTickLabel',nodeLabels)
%saveas(gcf,['/mnt/apricot1_share6/oFMRI/results/' 'DHstim_correlation_matrix.png'])
saveas(gcf,['/mnt/apricot1_share6/oFMRI/results/' 'IHstim_correlation_matrix.png'])