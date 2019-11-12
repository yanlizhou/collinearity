function [theta_est,loglike,est,NLL] =  fit_model(data,dataD,v_dy,model,task,noise,dn_flag,subj,niter,rbmflag,maxfeval)
if nargin < 10 || isempty(rbmflag); rbmflag = 0; end
if nargin < 11 || isempty(maxfeval); maxfeval = []; end


NLL = NaN(niter,1);
if rbmflag
    [lb,ub] = parameter_bounds(model,noise,rbmflag);
    [plb, pub] = plausible_bounds(model,noise,rbmflag);
else
    [lb,ub] = parameter_bounds(model,noise,[],dn_flag);
    [plb,pub] = plausible_bounds(model,noise,[],dn_flag);
end
init_vec = NaN(niter,length(plb));
for ii = 1:length(plb)
    init_vec(:,ii)  = plb(ii) + (pub(ii)-plb(ii))*rand(niter,1);
end
est  = NaN(niter,length(plb));

if isempty(maxfeval) || ~isfinite(maxfeval); maxfeval = 500*numel(plb); end

for idx = 1:niter
    startpoint = init_vec(idx,:);
    thisfunc = @(x_) -loglikelihood(x_,data,dataD,v_dy,model,task,noise,dn_flag,1,subj,300);
    bads_opts.MaxFunEvals = maxfeval;
    [theta,NLL(idx)] = bads(thisfunc,startpoint,lb,ub,plb,pub,[],bads_opts);
    for ii = 1:length(theta)
        est(idx,ii) = theta(ii);
    end
end
[negloglike, minloc] = min(NLL);
theta_est  = est(minloc,:);
loglike = -negloglike;
end

