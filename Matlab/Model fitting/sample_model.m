function [samples,LL,exitflag,output] =  sample_model(data,w,v_dy,model,task,form,subjid,chainid)
load theta_est_all;
load theta_new;
load theta_est_D;
datastruct.data = data;
datastruct.w = w;
datastruct.v_dy = v_dy;
datastruct.model = model;
datastruct.task = task;
datastruct.form = form;
opts.Restarts = 2;
opts.SaveVariables = 'off';
opts.LogModulo = Inf;
[lb,ub] = parameter_bounds(model,form);
opts.LBounds = lb(:);
opts.UBounds = ub(:);

if strcmpi(task,'C') || strcmpi(task,'J')
    [plb, pub] = possible_bounds(model,form);
elseif strcmpi(task,'D')
    [plb, pub] = possible_bounds('simplebaye',form);
end

if strcmpi(task,'C')
    if strcmpi(form,'nonparametric') && strcmpi(model,'threshold')
        startpoint = theta_est_all{1}(:,subjid);
        % elseif strcmpi(form,'nonparametric') && strcmpi(model,'baye')
        %     startpoint = theta_est_all{2}(:,subjid);
    elseif strcmpi(form,'nonparametric') && strcmpi(model,'baye')
        startpoint = theta_new(:,subjid);
    elseif strcmpi(form,'nonparametric') && strcmpi(model,'free')
        startpoint = theta_est_all{3}(:,subjid);
    elseif strcmpi(form,'parametric') && strcmpi(model,'linear')
        startpoint = theta_est_all{4}(:,subjid);
    elseif strcmpi(form,'parametric') && strcmpi(model,'linear2')
        startpoint = theta_est_all{5}(:,subjid);
    elseif strcmpi(form,'parametric') && strcmpi(model,'threshold')
        startpoint = theta_est_all{6}(:,subjid);
    elseif strcmpi(form,'parametric') && strcmpi(model,'baye')
        startpoint = theta_est_all{7}(:,subjid);
    elseif strcmpi(form,'nonparametric') && strcmpi(model,'linear')
        startpoint = theta_est_all{8}(:,subjid);
    end
else
    startpoint = theta_est_D(:,subjid);
end
sampleopts.InversionSample = 0;
sampleopts.VarTransformMethod = 4;
sampleopts.SaveFile = strcat('sample',num2str(subjid),num2str(chainid),'.mat');
sampleopts.SaveTime = 1e4;
startpoint = startpoint';
%[samples,LL,exitflag,output] = eissample(@(x) -minusloglikelihood(x,datastruct),startpoint,10000,[],pub-plb,lb,ub,sampleopts);
[samples,LL,exitflag,output] = eissample(@(x) loglikelihood_baye(x,data,v_dy,form,1,-1,300),startpoint,10000,[],pub-plb,lb,ub,sampleopts);

end
