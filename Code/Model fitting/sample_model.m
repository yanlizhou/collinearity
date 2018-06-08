function [samples,LL,exitflag,output] =  sample_model(data,v_dy,modelid,task,form,subjid,chainid,rbmflag)
if nargin < 8 || isempty(rbmflag); rbmflag = 0; end

models = {'simplebaye','threshold','linear','baye','free',...
    'linear2','linbaye','lintrial','baye2','freebaye_pc','freebaye','linbaye_f',...
    'linear3','linbaye_f2','lintrial2'};
model = models{modelid};

if rbmflag
    [lb,ub] = parameter_bounds(model,form,rbmflag);
    [plb, pub] = possible_bounds(model,form,rbmflag);
else
    [lb,ub] = parameter_bounds(model,form);
    [plb, pub] = possible_bounds(model,form);
end

if strcmpi(task,'C')
    if rbmflag
        load('theta_rbm_all.mat');
        if modelid == 2
            startpoint = theta_rbm_all{1}(:,subjid);
        elseif modelid == 9
            startpoint = theta_rbm_all{2}(:,subjid);
        elseif modelid == 13
            startpoint = theta_rbm_all{3}(:,subjid);
        elseif modelid == 5
            startpoint = theta_rbm_all{4}(:,subjid);
        end
    else
        if modelid == 12 || modelid == 14
            load('theta_lb.mat');
            if modelid == 12
                startpoint = theta_lb{1}(subjid,:)';
            elseif modelid == 14
                startpoint = theta_lb{2}(subjid,:)';
            end
        else
            load('data_and_analysis.mat', 'theta_est_all');
            if strcmpi(form,'nonparametric')
                startpoint = theta_est_all{modelid}(:,subjid);
            elseif strcmpi(form,'cross')
                startpoint = theta_est_all{modelid}(5:end,subjid);
            end
        end
    end
else
    load('data_and_analysis.mat', 'theta_est_D');
    startpoint = theta_est_D(:,subjid);
end

sampleopts.InversionSample = 0;
sampleopts.VarTransformMethod = 4;
sampleopts.SaveFile = strcat('sample',num2str(subjid),num2str(modelid),num2str(chainid),'.mat');
sampleopts.SaveTime = 1e4;
startpoint = startpoint';
[samples,LL,exitflag,output] = eissample(@(x) loglikelihood(x,data,v_dy,model,task,form,1,subjid,300),startpoint,10000,[],pub-plb,lb,ub,sampleopts);

end
