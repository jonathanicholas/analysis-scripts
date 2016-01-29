function [ratA, ratB, ratC, ratD] = average_runs(currData, stim)
    
    if strcmp(stim, 'ON')
        ratA{1} = currData.SSFO_ON_RatA_run1;
        ratA{2} = currData.SSFO_ON_RatA_run2;
        ratB{1} = currData.SSFO_ON_RatB_run1;
        ratC{1} = currData.SSFO_ON_RatC_run1;
        ratC{2} = currData.SSFO_ON_RatC_run2;
        ratD{1} = currData.SSFO_ON_RatD_run1;
        ratD{2} = currData.SSFO_ON_RatD_run2;
    else 
        ratA{1} = currData.SSFO_OFF_RatA_run1;
        ratA{2} = currData.SSFO_OFF_RatA_run2;
        ratA{3} = currData.SSFO_OFF_RatA_run3;
        ratB{1} = currData.SSFO_OFF_RatB_run1;
        ratC{1} = currData.SSFO_OFF_RatC_run1;
        ratD{1} = currData.SSFO_OFF_RatD_run1;
        ratD{2} = currData.SSFO_OFF_RatD_run2;
    end

    ratA = cat(3, ratA{:});
    ratA = mean(ratA, 3);
    ratB = cat(3, ratB{:});
    ratB = mean(ratB, 3);
    ratC = cat(3, ratC{:});
    ratC = mean(ratC, 3);
    ratD = cat(3, ratD{:});
    ratD = mean(ratD, 3);
end