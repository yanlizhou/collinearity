function model_fitting_example(subjid,modelid,noise,nrun,fullfit)
%MODEL_FITTING_EXAMPLE Example full model fit for one subject and model.
%
% subjid: Subject ID (choose from: 1-8)
%
% modelid: Model ID (choose from: 1-16)
% Main model IDs:
% 9: Bayes optimal model
% 13: Linear heuristic model
% 2: Fixed model
% Supplemetary model IDs:
% 5: Nonparametric model
% 10: Mismatch model
% 15: Trial dependency model
% 16: Subjective parameter distribution model 
%
% noise: Type of fitting of noise parameters
% choose from:
% 1. 'parametric' (or 'p') for a linear fit
% 2. 'nonparametric' (or 'n') for a nonparametric fit
% 3. 'cross' (or 'c') for importing noise parameters from discrimination task
%
% nrun: Number of times to run the fitting procedure
%
% fullfit: flag; run full fits as opposed to quick test runs (default false)

if nargin < 1 || isempty(subjid); subjid = 1; end
if nargin < 2 || isempty(modelid); modelid = 2; end
if nargin < 3 || isempty(noise); noise = 'p'; end
if nargin < 4 || isempty(nrun); nrun = 1; end
if nargin < 5 || isempty(fullfit); fullfit = false; end

% Add all necessary subfolders to MATLAB path
folders = {'code','data','utils'};
for f = 1:numel(folders); addpath(genpath(folders{f})); end

% Loading subject dataset
load('newsubjdata.mat', 'newsubjdataC');

% Some experimental parameters
scale  = 4;
v_dy   = (6*scale)^2;

% All model names
models = {'simplebaye','threshold','linear','baye','free',...
    'linear2','linbaye','lintrial','baye2','freebaye_pc',...
    'freebaye','linbaye_f','linear3','linbaye_f2','lintrial2','sub_vy'};

switch lower(noise(1))
    case 'p'; noise = 'parametric';
    case 'n'; noise = 'nonparametric';
    case 'c'; noise = 'cross';
    otherwise
        error('Unknown NOISE form.');
end

clear loglikelihood;

data = newsubjdataC{subjid};
task = 'C';         % Fit the categorization task
dn_flag = false;    % Decision noise flag

% First, maximum-likelihood fit
if fullfit
    maxfunevals = Inf;
else
    maxfunevals = 1e3;
end
[theta_est,loglike,~,~] = fit_model(data,[],v_dy,models{modelid},task,noise,dn_flag,subjid,nrun,[],maxfunevals);
save(['mle_s' num2str(subjid) '_m' num2str(modelid) '.mat'],'theta_est','loglike');

% Second, run Markov Chain Monte Carlo from MLE
chainid = 1;        % Id of current MCMC chain (should run multiple chains)
if fullfit
    Nsamples = 1e4;
else
    Nsamples = 1e3;    
end
[samples,LL,exitflag,output,savefilename] = ...
    sample_model(data,v_dy,modelid,task,noise,subjid,chainid,dn_flag,[],Nsamples,theta_est);
save(savefilename,'samples','LL','exitflag','output');


end