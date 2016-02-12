function [A] = make_adjacency(currDataDir, runs, stim, nSubs, nodeType)

    %load partial correlation matrices
    for run = 1:length(runs)
        load(strcat(currDataDir,runs{run},'/','results.mat'));
        corrs{run} = partial_correlation;
    end 
    
    %average runs together
    if strcmp(stim,'ON')
       if strcmp(nodeType,'DMN')
           ratA{1} = corrs{1}([7:16,21:22,25:30,41:42,78:79],[7:16,21:22,25:30,41:42,78:79]);
           ratA{2} = corrs{2}([7:16,21:22,25:30,41:42,78:79],[7:16,21:22,25:30,41:42,78:79]);
           ratB{1} = corrs{3}([7:16,21:22,25:30,41:42,78:79],[7:16,21:22,25:30,41:42,78:79]);
           ratC{1} = corrs{4}([7:16,21:22,25:30,41:42,78:79],[7:16,21:22,25:30,41:42,78:79]);
           ratC{2} = corrs{5}([7:16,21:22,25:30,41:42,78:79],[7:16,21:22,25:30,41:42,78:79]);
           ratD{1} = corrs{6}([7:16,21:22,25:30,41:42,78:79],[7:16,21:22,25:30,41:42,78:79]);
           ratD{2} = corrs{7}([7:16,21:22,25:30,41:42,78:79],[7:16,21:22,25:30,41:42,78:79]);
       else
           ratA{1} = corrs{1};
           ratA{2} = corrs{2};
           ratB{1} = corrs{3};
           ratC{1} = corrs{4};
           ratC{2} = corrs{5};
           ratD{1} = corrs{6};
           ratD{2} = corrs{7};
       end
    else
       if strcmp(nodeType,'DMN')
           ratA{1} = corrs{1}([7:16,21:22,25:30,41:42,78:79],[7:16,21:22,25:30,41:42,78:79]);
           ratA{2} = corrs{2}([7:16,21:22,25:30,41:42,78:79],[7:16,21:22,25:30,41:42,78:79]);
           ratA{3} = corrs{3}([7:16,21:22,25:30,41:42,78:79],[7:16,21:22,25:30,41:42,78:79]);
           ratB{1} = corrs{4}([7:16,21:22,25:30,41:42,78:79],[7:16,21:22,25:30,41:42,78:79]);
           ratC{1} = corrs{5}([7:16,21:22,25:30,41:42,78:79],[7:16,21:22,25:30,41:42,78:79]);
           ratD{1} = corrs{6}([7:16,21:22,25:30,41:42,78:79],[7:16,21:22,25:30,41:42,78:79]);
           ratD{2} = corrs{7}([7:16,21:22,25:30,41:42,78:79],[7:16,21:22,25:30,41:42,78:79]);
       else 
           ratA{1} = corrs{1};
           ratA{2} = corrs{2};
           ratA{3} = corrs{3};
           ratB{1} = corrs{4};
           ratC{1} = corrs{5};
           ratD{1} = corrs{6};
           ratD{2} = corrs{7};
       end
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
        %A{sub} = (correlations{sub} > threshold);
        A{sub} = correlations{sub};
        A{sub}(logical(eye(size(A{sub})))) = 0;
    end
    
end

