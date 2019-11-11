function model_fitting_example(subjid, modelid, form, nrun)

%------------------------------------------------------------%

% subjid: Subject ID
% choose from: 1-8

% modelid: Model ID 
% choose from: 1-16

% Main model IDs:
% 9: Bayes optimal model
% 13: Linear heuristic model
% 2: Fixed model

% Supplemetary model IDs:
% 5: Nonparametric model
% 10: Mismatch model
% 15: Trial dependency model
% 16: Subjective parameter distribution model 

% form: Type of fitting of noise parameters we would like to perform

% choose from:
% 1. 'nonparametric' for a nonparametric fit
% 2. 'parametric' for a linear fit
% 3. 'cross' for importing noise parameters from discrimination task

% nrun: Number of times we want to run the fitting procedure

%------------------------------------------------------------%

% Loading subject dataset
load('newsubjdata.mat', 'newsubjdataC');

% Some experimental parameters
scale  = 4;
v_dy   = (6*scale)^2;

% All model names
models = {'simplebaye','threshold','linear','baye','free',...
    'linear2','linbaye','lintrial','baye2','freebaye_pc',...
    'freebaye','linbaye_f','linear3','linbaye_f2','lintrial2','sub_vy'};

clear loglikelihood
[theta_est,loglike,~,~] = fit_model(newsubjdataC{subjid},[],v_dy,models{modelid},'C',form,0,subjid,nrun);
save(['modelfitting_' num2str(subjid) '_' num2str(modelid) '.mat'],'theta_est','loglike');

end