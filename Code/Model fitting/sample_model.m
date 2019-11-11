function [samples,LL,exitflag,output] =  sample_model(data,v_dy,modelid,task,form,subjid,chainid,dn_flag,rbmflag)
if nargin < 8 || isempty(dn_flag); dn_flag = 0; end
if nargin < 9 || isempty(rbmflag); rbmflag = 0; end

models = {'simplebaye','threshold','linear','baye','free',...
    'linear2','linbaye','lintrial','baye2','freebaye_pc','freebaye','linbaye_f',...
    'linear3','linbaye_f2','lintrial2','sub_vy'};
model = models{modelid};
[lb,ub] = parameter_bounds(model,form,rbmflag,dn_flag);
[plb, pub] = possible_bounds(model,form,rbmflag,dn_flag);

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
    elseif dn_flag        
        if modelid == 9
            load('theta_est_dn','theta_dn');
            startpoint = theta_dn(:,subjid);
        elseif modelid == 16
            load('theta_est_dn','theta_sub_dn');
            startpoint = theta_sub_dn(:,subjid);
        end
        
    else
        if modelid == 12 || modelid == 14 || modelid == 16            
            if modelid == 12
                load('theta_lb.mat');
                startpoint = theta_lb{1}(subjid,:)';
            elseif modelid == 14
                load('theta_lb.mat');
                startpoint = theta_lb{2}(subjid,:)';
            elseif modelid == 16
                load('theta_est_sub.mat');
                startpoint = theta_est_sub(:,subjid);
            end
        else
            if strcmpi(form,'nonparametric')
                load('data_and_analysis.mat', 'theta_est_all');
                startpoint = theta_est_all{modelid}(:,subjid);
            elseif strcmpi(form,'cross')
                load('theta_cross.mat', 'theta_cross');
                startpoint = theta_cross{modelid}(:,subjid);
            end
        end
    end
else
    load('data_and_analysis.mat', 'theta_est_D');
    startpoint = theta_est_D(:,subjid);
end

sampleopts.InversionSample = 0;
sampleopts.VarTransformMethod = 4;
if dn_flag
    sampleopts.SaveFile = strcat('sample_dn_',num2str(subjid),num2str(modelid),num2str(chainid),'.mat');
elseif strcmpi(form,'cross')
    sampleopts.SaveFile = strcat('sample_cross',num2str(subjid),num2str(modelid),num2str(chainid),'.mat');
else
    sampleopts.SaveFile = strcat('sample_',num2str(subjid),num2str(modelid),num2str(chainid),'.mat');
end

sampleopts.SaveTime = 1e4;
startpoint = startpoint';
[samples,LL,exitflag,output] = eissample(@(x) loglikelihood(x,data,[],v_dy,model,task,form,dn_flag,1,subjid,300),startpoint,10000,[],pub-plb,lb,ub,sampleopts);
% [samples,LL,exitflag,output,fvals] = eissample({@(x) bsxfun_normlogpdf(x(6),log(24),0.5),... 
%     @(x) loglikelihood(x,data,[],v_dy,model,task,form,dn_flag,1,subjid,300)},startpoint,10000,[],pub-plb,lb,ub,sampleopts);
output.fvals = fvals;

end