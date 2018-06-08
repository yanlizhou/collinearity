function [theta_est,loglike,est,NLL] =  fit_model(data,dataD,v_dy,model,task,form,subj,niter,rbmflag)
if nargin < 9 || isempty(rbmflag); rbmflag = 0; end
% datastruct.data = data;
% datastruct.v_dy = v_dy;
% datastruct.model = model;
% datastruct.task = task;
% datastruct.form = form;
% opts.Restarts = 2;
% opts.SaveVariables = 'off';
% opts.LogModulo = Inf;
% opts.LBounds = lb(:);
% opts.UBounds = ub(:);

NLL = NaN(niter,1);
if rbmflag
    [lb,ub] = parameter_bounds(model,form,rbmflag);
    [plb, pub] = possible_bounds(model,form,rbmflag);
else
    [lb,ub] = parameter_bounds(model,form);
    [plb, pub] = possible_bounds(model,form);
end
init_vec = NaN(niter,length(plb));
for ii = 1: length(plb)
    init_vec(:,ii)  = plb(ii) + (pub(ii)-plb(ii))*rand(niter,1);
end
est  = NaN(niter,length(plb));


for idx = 1:niter
    startpoint = init_vec(idx,:);
    thisfunc = @(x_) -loglikelihood(x_,data,dataD,v_dy,model,task,form,1,subj,300);
    [theta,NLL(idx)] = bads(thisfunc,startpoint,lb,ub,plb,pub);
    %         [theta,NLL(idx)] = cmaes('minusloglikelihood',startpoint(:),1,opts,datastruct);
    for ii = 1:length(theta)
        est(idx,ii) = theta(ii);
    end
end
[negloglike, minloc] = min(NLL);
theta_est  = est(minloc,:);
loglike = -negloglike;
end

