function model_recovery(iid)
rng(iid)
scale  = 4;
v_dy   = (6*scale)^2;
this_str   = num2str(iid);
modelid    = str2double(this_str(1));
% runid      = str2double(this_str(2:3));
models = {'threshold','baye2','linear3'};
nrun = 50;

if modelid == 1
    mid = 2;
elseif modelid == 2
    mid = 9;
elseif modelid == 3
    mid = 13;
end

samples = load('data_and_analysis.mat','samples_all');
samples_all = samples.samples_all{mid};
subjid = randi(8);
samples_all = samples_all(:,:,subjid);
theta = samples_all(randi(30000),:);
data = generatefakedata(feedtheta(theta,models{modelid},'nonparametric'),v_dy,models{modelid},'C','on','nonparametric');


loglikes = NaN(3,1);
for ii = 1:length(models)
    clear loglikelihood
    [theta_est,loglike] = fit_model(data,[],v_dy,models{ii},'C','nonparametric',subjid,nrun);
    loglikes(ii) = loglike;
end
save(['modelrecovery_' num2str(iid) '.mat'],'loglikes');
end