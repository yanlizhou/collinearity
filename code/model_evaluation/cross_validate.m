function cross_validate(iid)
load('data_and_analysis.mat', 'newsubjdataC','samples_all');
scale  = 4;
v_dy   = (6*scale)^2;
[subjid,modelid,~] = clusteriid(iid);
form = 'nonparametric';
clear loglikelihood
models = {'simplebaye','threshold','linear','baye','free',...
    'linear2','linbaye','lintrial','baye2','freebaye_pc','freebaye','linbaye_f','linear3'};
model = models{modelid};
loglikemat = NaN(30000,length(newsubjdataC{subjid}));
for sampleid = 1:30000
    loglikemat(sampleid,:) = loglikelihood(...
        samples_all{modelid}(sampleid,:,subjid),newsubjdataC{subjid},...
        v_dy,model,'C',form,0,subjid);
end

[loo,loos,pk] = psisloo(loglikemat);

save(['cross_validate' num2str(iid) '.mat'],'loo','loos','pk');
