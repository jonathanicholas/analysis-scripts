function [degree meanDegree] = compute_degree(A, nSubs, stim, result_dir, roi_names, threshold)

    nrois = length(roi_names);

    %%%%% Compute network degree %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    for sub = 1:nSubs

        degree{sub} = nansum(A{sub}, 1)/2;

    end

    meanDegree = cat(3, degree{:});
    meanDegree = mean(meanDegree, 3);

    if strcmp(stim,'ON')
        save(strcat(result_dir,'SSFO_ON_degree',threshold,'.mat'),'degree','meanDegree', 'roi_names')
    else
        save(strcat(result_dir,'SSFO_OFF_degree',threshold,'.mat'),'degree','meanDegree', 'roi_names')
    end
end




