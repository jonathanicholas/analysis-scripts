function [A] = make_adjacency(currDataDir, runs, stim, threshold, nSubs)

    %load correlation matrices
    for run = 1:length(runs)
        load(strcat(currDataDir,runs{run},'/','results.mat'));
        corrs{run} = correlation;
    end

    %average runs together
    if strcmp(stim,'ON')
       ratA{1} = corrs{1};
       ratA{2} = corrs{2};
       ratB{1} = corrs{3};
       ratC{1} = corrs{4};
       ratC{2} = corrs{5};
       ratD{1} = corrs{6};
       ratD{2} = corrs{7};
    else
       ratA{1} = corrs{1};
       ratA{2} = corrs{2};
       ratA{3} = corrs{3};
       ratB{1} = corrs{4};
       ratC{1} = corrs{5};
       ratD{1} = corrs{6};
       ratD{2} = corrs{7};
    end

    ratA = cat(3, ratA{:});
    correlations{1} = mean(ratA, 3);
    ratB = cat(3, ratB{:});
    correlations{2} = mean(ratB, 3);
    ratC = cat(3, ratC{:});
    correlations{3} = mean(ratC, 3);
    ratD = cat(3, ratD{:});
    correlations{4} = mean(ratD, 3);

    for sub = 1:nSubs
        A{sub} = (correlations{sub} > threshold);
        A{sub}(logical(eye(size(A{sub})))) = 0;
    end
    
end

