clear all
close all
clc

addpath('/mnt/musk2/home/jnichola/MDS_Scripts_and_ofMRI_data/MDS_Scripts/MDS_dependencies')

%%%%% Load/Prep Data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

currData = load('/mnt/mandarin2/Public_Data/OptofMRI/Stanford_Prefrontal_Reward/TimeseriesData_MotionCorrected/SSFO_ON_AllScans.mat');
%currData = load('/mnt/mandarin2/Public_Data/OptofMRI/Stanford_Prefrontal_Reward/TimeseriesData_MotionCorrected/SSFO_OFF_AllScans.mat');

stim = 'ON';
%stim = 'OFF';

stim_design = ones(1,600);

[timeseries{1}, timeseries{2}, timeseries{3}, timeseries{4}] = average_runs(currData, stim);

%selecting for mPFC and ventral striatum only
for ii = 1:4
    %timeseries{ii} = timeseries{ii}([25:32,51:68],:); %full node network for mPFC and vStriatium
    %timeseries{ii} = timeseries{ii}([25:32,51:52,57:60],:);
    timeseries{ii} = timeseries{ii}([27,51,55,57],:); %51, 55, 57
end
%%%% MDS Params %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

TR = 0.5; %500ms as described in supplementary methods
tol = 10^-4; %tolerance for MDS convergence
maxIter = 100; %max allowable iterations

Vm(:,1) = stim_design';
%Vm(:,2) = 1-stim_design';
L = round(32/TR);
method = 'L1_woi';
Nsubjects = 4;
Ntimepoints = size(timeseries{ii}, 2);

%%%% Run MDS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for subj = 1:Nsubjects
    %subj
    %Y = timeseries;
    Y = timeseries{subj};   
    J = size(Vm,2);        % Experimental conditions
    [M N] = size(Y); % M: region number N: time length
    v = zeros(N,1);  % External stimulus
    %v = 1-stim_design;
    cnt = 1;
    S = 1;
    for s = 1:S
        data(s).Y = Y;
        data(s).Vm = Vm;
    end
    %%%%%%%%%%% Initialization %%%%%%%%%%%%%%
    Vmc = [];
    vc = [];
    Xc = [];
    Yc = [];
%   [Phi, Bv] = get_model_hrf_rev(L,TR,M,1/1000);
 [Phi, Bv] =  get_model_hrf_3basis(L,TR,M,1/1000);
    for s = 1:S
        Vmc = [Vmc;data(s).Vm];
        vc = [vc;v];
        Y = data(s).Y(:,1:N);
        Yc = [Yc Y];
    end
    for m = 1:M
        y = Yc(m,:);
        R(m,m) = var(y);
    end
    R = eye(M);
    % Weiner Deconvolution
    h = Bv(:,1);
    Xest = weiner_deconv(Yc,h,R);
    [Bm,d,Q] = estAR_wo_intrinsic(Xest',vc,Vmc,1);
    A = zeros(M);
    [B,R1] = initialize_B_R_WD(Yc,Xest,Bv',L);
    %%%%%%%%%%%%%%%% Data for KF %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Y = zeros(M,N,S);
    Um = zeros(N,J,S);
    Ue = zeros(N,S);
    for s = 1:S
        Y(:,:,s) = data(s).Y(:,1:N);
        Vm = data(s).Vm;
        Um(:,:,s) = Vm;
        Ue(:,s) = v;
    end
    BDS.Phi = Phi;
    BDS.Phit = Bv';
    BDS.A = A;
    BDS.Bm = Bm;   %Weights due to Modulatory Inputs
    BDS.Q = Q;  %State Covariance
    BDS.d = d;
    BDS.B = B;  %Beta
    BDS.R = R;  %Ouput Covariance
    BDS.L = L; % Embedded Dimension
    BDS.M = M; %# of regionssubj_model_parameters
    BDS.mo = zeros(L*M,1); %Initial state vector mean
    BDS.Vo =  10^-3*eye(L*M);    % Initial Covariance
     BDS.ao = 10^-10; BDS.bo = 10^-10;
     BDS.co = 10^-10; BDS.do = 10^-10;
%      BDS.ao = 10^-0; BDS.bo = (10^-4);
%      BDS.co = 10^-0; BDS.do = (10^-4);
   % BDS.ao = 0; BDS.bo = 0;
   % BDS.co = 0; BDS.do = 0;
    BDS.method = method;
    switch BDS.method
        case 'L1'
            if sum(v(:)) ~= 0
                BDS.Alphab = 0*ones(M,(J+1)*M+1); %L1
            else
                BDS.Alphab = 0*ones(M,(J+1)*M); %L1
            end
            BDS.Alphab_op = 10^-0*ones(M,size(Bv,2)); %L1
        case 'L2'
            BDS.Alphab = 0*ones(M,1); %L2
            BDS.Alphab_op = 0*ones(M,1); %L2
        case 'L1_woi'
            BDS.Alphab = 0*ones(M,(J)*M+1); %L1
            BDS.Alphab_op = 0*ones(M,size(Bv,2)); %L1
        case 'L2_woi'
            BDS.Alphab = 0*ones(M,1); %L2
            BDS.Alphab_op = 0*ones(M,1); %L2
    end
    BDS.flag = 0;
    BDS.tol = tol;
    BDS.maxIter = maxIter;  %Max allowable Iterations%timeseries = timeseries(4:5,:); %determine timeseries of interest

    %[BDS,LL] = vb_em_iterations_all_subjs(BDS,Y,Um,Ue);
    [BDS,LL,KS] = vb_em_iterations_combined_par_convergence(BDS,Y,Um,Ue);
    length(LL)
    BDS.Var_A = ones(M);
    [Mapi_normal,Mapm_normal,Mapd_normal] = compute_normalized_stats_Multiple_inputs(BDS.A,BDS.Bm,BDS.Var_A,BDS.Var_Bm,BDS.d,BDS.Var_d);
    
    subj_model_parameters(subj).Theta_normal = Mapm_normal;
    subj_model_parameters(subj).Theta = BDS.Theta;
    subj_model_parameters(subj).Cov_mat = BDS.Cov_mat;
    subj_model_parameters(subj).Q = BDS.Q;
    
end

%save('SSFO_ON_26node_MDS.mat','subj_model_parameters')
%save('SSFO_OFF_26node_MDS.mat','subj_model_parameters')

save('/mnt/musk2/home/jnichola/mPFC_ofMRI/results/SSFO_ON_4node_MDS.mat','subj_model_parameters')
%save('/mnt/musk2/home/jnichola/mPFC_ofMRI/results/SSFO_OFF_4node_MDS.mat','subj_model_parameters')
