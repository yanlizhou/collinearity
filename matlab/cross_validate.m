function cross_validate(iid)
scale  = 4;
v_dy   = (6*scale)^2;
w      = 70*scale;
% load samples_all3_lin
load samples_all_baye
load newsubjdata
[~,subjid] = clusteriid(iid);

% form   = {'nonparametric','nonparametric','nonparametric','parametric',...
%     'parametric','parametric','parametric','nonparametric'};
% 
% models = {'threshold','baye','free','linear','linear2','threshold','baye','linear'};
loglikemat = NaN(30000,length(newsubjdataC{subjid}));

for sampleid = 1:30000
    %          loglikemat(sampleid,:) = loglikelihood(...
    %              samples_all3_lin{modelid}(sampleid,:,subjid),newsubjdataC{subjid},w,...
    %              v_dy,models{modelid},'C',form{modelid},0);
    
    %     loglikemat(sampleid,:) = loglikelihood(...
    %         samples_all3_lin(sampleid,:,subjid),newsubjdataC{subjid},w,...
    %         v_dy,models{modelid},'C',form{modelid},0);
    
    loglikemat(sampleid,:) = loglikelihood_baye(samples_all_baye(sampleid,:,subjid),...
        newsubjdataC{subjid},v_dy,'nonparametric',0,-1,300);
end

[loo,loos,pk] = psisloo(loglikemat);

save(['cross_validate' num2str(iid) '.mat'],'loo','loos','pk');

% Added stuff
