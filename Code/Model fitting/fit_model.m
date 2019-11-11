function [theta_est,loglike,est,NLL] =  fit_model(data,dataD,v_dy,model,task,form,dn_flag,subj,niter,rbmflag)
if nargin < 10 || isempty(rbmflag); rbmflag = 0; end

NLL = NaN(niter,1);
if rbmflag
    [lb,ub] = parameter_bounds(model,form,rbmflag);
    [plb, pub] = possible_bounds(model,form,rbmflag);
else
    [lb,ub] = parameter_bounds(model,form,[],dn_flag);
    [plb,pub] = possible_bounds(model,form,[],dn_flag);
end
init_vec = NaN(niter,length(plb));
for ii = 1: length(plb)
    init_vec(:,ii)  = plb(ii) + (pub(ii)-plb(ii))*rand(niter,1);
end
est  = NaN(niter,length(plb));


for idx = 1:niter
    startpoint = init_vec(idx,:);
    thisfunc = @(x_) -loglikelihood(x_,data,dataD,v_dy,model,task,form,dn_flag,1,subj,300);
    [theta,NLL(idx)] = bads(thisfunc,startpoint,lb,ub,plb,pub);
    for ii = 1:length(theta)
        est(idx,ii) = theta(ii);
    end
end
[negloglike, minloc] = min(NLL);
theta_est  = est(minloc,:);
loglike = -negloglike;
end

