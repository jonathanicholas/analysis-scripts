addpath('/mnt/musk2/home/sryali/MDS_scripts')

roi_names = {'CingCx1_R','CingCx1_L','CingCx2_R','CingCx2_L','IL_R','IL_L','DP_R','DP_L','septal_R','septal_L','CauPut_R','CauPut_L','GloPall_R','GloPall_L','NAsh_R','NAsh_L','NAco_R','NAco_L','VenPall_R','VenPall_L','mlfb_R','mlfb_L','thal_R','thal_L','BNST_R','BNST_L'};

load('/mnt/musk2/home/jnichola/mPFC_ofMRI/results/SSFO_ON_MDS.mat')

[causal_maps_on causal_maps_fdr_on] = mds_ofmri_stats(subj_model_parameters);

subplot(2,2,1)
cca_plotcausality(causal_maps_on{1},roi_names,5)
title('ON stim causality')

subplot(2,2,2)
cca_plotcausality(causal_maps_fdr_on{1},roi_names,5)
title('ON stim causality (FDR corr)')

%load('SSFO_OFF_MDS.mat')
%[causal_maps_off causal_maps_fdr_off] = mds_ofmri_stats(subj_model_parameters);

%subplot(2,2,3)
%cca_plotcausality(causal_maps_off{1},roi_names,5)
%title('OFF stim causality')

%subplot(2,2,4)
%cca_plotcausality(causal_maps_fdr_off{1},roi_names,5)
%title('OFF stim causality (FDR corr)')

saveas(gcf,['/mnt/musk2/home/jnichola/mPFC_ofMRI/results/' 'causality_26node_ON.png'])

%figure
%cca_plotcausality(Mapm_fdr(:,1:M),roi_names,5);

%title('IH stimulation causality')
%saveas(gcf,['/mnt/apricot1_share6/oFMRI/results/' 'IHstim_causality_5node_indiv.png'])

%title('DH stimulation causality')

%saveas(gcf,['/mnt/apricot1_share6/oFMRI/results/' 'DHstim_causality_5node_allconditions.png'])
