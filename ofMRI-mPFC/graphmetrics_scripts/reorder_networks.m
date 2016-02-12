function [mean_reordered_Ciu mean_reordered_A] = reorder_networks(Ciu, A, nSubs, stim, result_dir, roi_names)
    
    addpath('/mnt/musk2/home/jnichola/BCT')
    
    nRois = length(roi_names);
    
    
    for i = 1:length(Ciu)
        for s = 1:length(nSubs)
            [reordered_Ciu{s} reordered_A{s}] = reorder_mod(A{s}, Ciu{i});
        end
        mean_reordered_Ciu{i} = mean(cat(3, reordered_Ciu{:}), 3);
        mean_reordered_A{i} = mean(cat(3, reordered_A{:}), 3);
    end
    
    if strcmp(stim,'ON')
        save(strcat(result_dir,'SSFO_ON_reordered.mat'))
    else
        save(strcat(result_dir,'SSFO_OFF_reordered.mat'))
    end
end