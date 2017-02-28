function model_recovery(iid)
[modelid,runid,subjid] = clusteriid(iid);
load theta_trues
models = {'threshold','baye','free','linear','baye2'};
scale  = 4;
v_dy   = (6*scale)^2;
% noise_min = [1,10,30,60];
% noise_max = [200,350,500,2500];
paranum = [6,6,9,7,6];
nruns = 3;
theta_true = theta_trues{modelid}((runid*nruns)-2:runid*nruns,:,subjid);
% noise_level = NaN(nruns,4);
% for ylevel = 1:4
%     noise_level(:,ylevel) = noise_min(ylevel) + (noise_max(ylevel)-...
%         noise_min(ylevel)).*rand(nruns,1);
% end
% noise_level = log(noise_level);
% 
% if modelid == 1
%     theta_true = NaN(nruns,5);
%     theta_true(:,1:4) = noise_level;
%     theta_ture(:,5) = 10 + (30 - 10).*rand(nruns,1);
% elseif modelid == 2
%     theta_true = NaN(nruns,5);
%     theta_true(:,1:4) = noise_level;
%     theta_ture(:,5) = 0.4 + (0.6 - 0.4).*rand(nruns,1);
% elseif modelid == 3
%     theta_true = NaN(nruns,8);
%     theta_true(:,1:4) = noise_level;
%     theta_ture(:,5) = 2 + (20 - 2).*rand(nruns,1);
%     theta_ture(:,6) = 10 + (30 - 10).*rand(nruns,1);
%     theta_ture(:,7) = 15 + (40 - 15).*rand(nruns,1);
%     theta_ture(:,8) = 20 + (50 - 20).*rand(nruns,1);
% elseif modelid == 4
%     theta_true = NaN(nruns,6);
%     theta_true(:,1:4) = noise_level;
%     theta_ture(:,5) = 0.001 + (0.07 - 0.001).*rand(nruns,1);
%     theta_ture(:,6) = 2 + (18 - 2).*rand(nruns,1);
%     
% elseif modelid == 5
%     theta_true = NaN(nruns,5);
%     theta_true(:,1:4) = noise_level;
%     theta_ture(:,5) = 0.4 + (0.6 - 0.4).*rand(nruns,1);
% end
% 
% temp = 0.02 + (0.3 - 0.02).*rand(nruns,1);
% theta_true = [theta_true,temp];

theta_est = cell(1,length(models));
loglike   = NaN(length(models),nruns);

for thismodel = 1:length(models)
    theta_est{thismodel} = NaN(nruns,paranum(thismodel));
end

for thisrun = 1:nruns
    clear loglikelihood
    fakedata = generatefakedata(feedtheta(theta_true(thisrun,:),models{modelid},'nonparametric'),...
        v_dy,models{modelid},'C','on','nonparametric',0,2400,[]);
    for thismodel= 1:length(models)
        [te,ll] =  fit_model(fakedata,v_dy,models{thismodel},'C','nonparametric',-1,30);
        theta_est{thismodel}(thisrun,:) = te;
        loglike(thismodel,thisrun) = ll;
        save(['modelrecovery_' num2str(iid) '.mat'],'theta_est','loglike');
    end
end


