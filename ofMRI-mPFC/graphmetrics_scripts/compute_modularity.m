function [finalCi finalQ final_pVal final_hVal] = compute_modularity(A, nSubs, stim, result_dir, roi_names, threshold, numIters)


    nrois = length(roi_names);
    gamma = 1;
    numReps = 100;

    Qs = cell(1,nSubs);
    matchedQs = cell(1, nSubs);

    for sub = 1:nSubs
        for ii = 1:numIters

            matchedA = null_model_und_sign(A{sub});
            [matched_Ci matched_Q] = community_louvain(matchedA,[],[],'negative_sym');

            for jj = 1:numReps

                [CiforMax{jj} QforMax(jj)] = community_louvain(A{sub},[],[],'negative_sym');

            end

            Q = find(QforMax == max(QforMax));
            Q = Q(1);
            Ci = CiforMax{Q};
            Q = QforMax(Q);

            Qs{sub} = [Qs{sub} Q];
            matchedQs{sub} = [matchedQs{sub} matched_Q];

            currentModularity = Ci;
            coClassification = zeros(nrois, nrois);

            for row = 1:nrois
                currVal = currentModularity(row);
                for col = 1:nrois
                    if currentModularity(row) == currentModularity(col)
                        coClassification(row,col) = 1;
                    end
                end
                coClassification(row,row) = 0;
            end
            coClassification_sub{ii} = coClassification;
        end

        coClassificationMat{sub} = coClassification_sub;
        Qs{sub} = median(Qs{sub});
        matchedQs{sub} = median(matchedQs{sub});

    end

    Qs = cell2mat(Qs);
    matchedQs = cell2mat(matchedQs);

    [Q_pVal Q_hVal] = ranksum(Qs, matchedQs);

    for sub = 1:nSubs
        for ii = 1:numIters
            if ii == 1
                currMat = bsxfun(@plus, coClassificationMat{sub}{ii}, coClassificationMat{sub}{ii+1});
            elseif ii ~= numIters
                currMat = bsxfun(@plus, currMat, coClassificationMat{sub}{ii+1});
            else
                currMat = bsxfun(@plus, currMat, coClassificationMat{sub}{ii});
            end
        end
        individualcoClass{sub} = currMat;
    end

    for sub = 1:nSubs

        for ii = 1:numIters
            matched_groupA = null_model_und_sign(individualcoClass{sub});
            [matched_groupCi matched_group_Q] = community_louvain(matched_groupA,[],[],'negative_sym');

            matched_groupQ(ii) = matched_group_Q; 
        end

        matched_groupQ = median(matched_groupQ);

        for jj = 1:numReps
            [CiforMax_coClass{jj} QforMax_coClass(jj)] = community_louvain(individualcoClass{sub},[],[],'negative_sym');
        end

        groupQmax = find(QforMax_coClass == max(QforMax_coClass));
        groupQmax = groupQmax(1);
        groupCI = CiforMax_coClass{groupQmax};
        groupQ = QforMax_coClass(groupQmax);

        groupCurrMod = groupCI;
        groupCIs(:,sub) = groupCurrMod;

        group_coClass = zeros(nrois, nrois);
        for row = 1:nrois
           currVal = groupCurrMod(row);
           for col = 1:nrois
                if groupCurrMod(row) == groupCurrMod(col)
                    group_coClass(row,col) = 1;
                end
            end
            group_coClass(row,row) = 0;
        end
        coClassification_group{sub} = group_coClass;
    end

    [groupQ_pVal groupQ_hVal] = ranksum(groupQ, matched_groupQ);

    for sub = 1:nSubs
        if sub == 1
            currMat = bsxfun(@plus, coClassification_group{sub}, coClassification_group{sub+1});
        elseif sub ~= numIters
            currMat = bsxfun(@plus, currMat, coClassification_group{sub+1});
        else
            currMat = bsxfun(@plus, currMat, coClassification_group{sub});
        end
        groupcoClass = currMat;
    end

    for sub = 1:nSubs
        for ii = 1:numIters
            matched_finalA = null_model_und_sign(coClassification_group{sub});
            [matched_finalCi matched_finQ] = community_louvain(matched_finalA,[],[],'negative_sym');

            matched_finalQ(ii) = matched_finQ;
        end

        matched_finalQ = median(matched_finalQ);
        matched_final_Q(sub) = matched_finalQ;
    end

    [finalCi finalQ] = community_louvain(groupcoClass,[],[],'negative_sym');

    [final_pVal final_hVal] = ranksum(finalQ, matched_final_Q);


    if strcmp(stim, 'ON')
        save(strcat(result_dir,'SSFO_ON_modularity',threshold,'.mat'))
    else
        save(strcat(result_dir,'SSFO_OFF_modularity',threshold,'.mat'))
    end

end



























