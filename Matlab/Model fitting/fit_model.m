function [theta_est,loglike] =  fit_model(data,v_dy,model,task,form,subj,niter)
%options = optimset('MaxFunEvals',1000,'Display','off');
NLL = NaN(niter,1);
% datastruct.data = data;
% datastruct.v_dy = v_dy;
% datastruct.model = model;
% datastruct.task = task;
% datastruct.form = form;
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
init_vec = NaN(niter,length(plb));
for ii = 1: length(plb)
    init_vec(:,ii)  = plb(ii) + (pub(ii)-plb(ii))*rand(niter,1);
end
est  = NaN(niter,length(plb));


for idx = 1:niter
    startpoint = init_vec(idx,:);
    % thisfunc = @(x_) -loglikelihood(x_,data,w,v_dy,model,task,form);
    thisfunc = @(x_) -loglikelihood(x_,data,v_dy,model,task,form,1,subj,500);
    [theta,NLL(idx)] = bps(thisfunc,startpoint(:),lb,ub,plb,pub);
    %         [theta,NLL(idx)] = cmaes('minusloglikelihood',startpoint(:),1,opts,datastruct);
    for ii = 1:length(theta)
        est(idx,ii) = theta(ii);
    end
end
% [theta,NLL(idx)] = fmincon(thisfunc,startpoint(:),[],[],[],[],lb,ub,[],options);

[negloglike, minloc] = min(NLL);
theta_est  = est(minloc,:);
loglike = -negloglike;
end

