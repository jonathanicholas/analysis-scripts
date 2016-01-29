function [betweenness meanBetween] = compute_hubs(A, nSubs, stim, result_dir, roi_names)

    nrois = length(roi_names);

    %%%%% Compute network hubs %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    for sub = 1:nSubs

        betweenness{sub} = betweenness_wei(A{sub});
        betweenness{sub} = betweenness{sub}/((nrois-1)*(nrois-2));%normalizing to the range [0, 1]

    end

    meanBetween = cat(3, betweenness{:});
    meanBetween = mean(meanBetween, 3);

    if strcmp(stim,'ON')
        save(strcat(result_dir,'SSFO_ON_hubs.mat'),'betweenness','meanBetween', 'roi_names')
    else
        save(strcat(result_dir,'SSFO_OFF_hubs.mat'),'betweenness','meanBetween', 'roi_names')
    end
    
end