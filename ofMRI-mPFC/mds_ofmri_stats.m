function [causal_maps causal_maps_fdr] = mds_ofmri_stats(subj_model_parameters)

pval_uc = 0.05;
M = size(subj_model_parameters(1).Theta,1);
pval_bon = pval_uc/(M*(M-1));
no_subjs = length(subj_model_parameters);

on_mapm_normal = {};
for sub = 1:no_subjs
    
    mapm_normal{sub} = subj_model_parameters(sub).Theta_normal(:,:,1);

    
end

mapm_normal = cat(3, mapm_normal{:}); %average on
mapm_normal = mean(mapm_normal, 3);

pVals(:,:,1) = 1-normcdf(abs(mapm_normal));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Condition #1 ON %%%%%%%%%%%%%%%%%%%%
%FDR not corrected
Mapm_1 = pVals(:,:,1)<= pval_uc;

%FDR corrected
pth = FDR(pVals(:,:,1),pval_uc);
if ~isempty(pth)
    Mapm_fdr1 = pVals(:,:,1)<= pth;
else
    Mapm_fdr1 = zeros(M);
end


causal_maps{1} = Mapm_1;

causal_maps_fdr{1} = Mapm_fdr1;

end