function [Ciu Q] = compute_consensus_cluster(A, nSubs, stim, result_dir, roi_names, reps)

tau = {0, 0.25, 0.5, 0.75, 1};
for t = 1:5
    for s = 1:nSubs
        for i = 1:reps
            %mA = null_model_und_sign(A_on{s});
            %[mCi{i} mQ{i}] = community_louvain(mA,[],[],'negative_sym');
            for j = 1:10
                [Cireps{j} Qreps(j)] = community_louvain(A{s},[],[],'negative_sym');
            end
            Qr = find(Qreps == max(Qreps));
            Qr = Qr(1);
            Q(:,i) = Qreps(Qr);
            Ci(:,i) = Cireps{Qr}';
        end
        %mD = agreement(mCi); 
        D = agreement(Ci);
        D = D/reps;
        %mCiu = consensus_und(mD,tau{t},reps);
        Ciu{t} = consensus_und(D, tau{t}, reps);
    end
end
    
    if strcmp(stim,'ON')
        save(strcat(result_dir,'SSFO_ON_modularity.mat'))
    else
        save(strcat(result_dir,'SSFO_OFF_modularity.mat'))
    end

end