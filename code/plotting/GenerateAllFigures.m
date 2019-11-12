%function GenerateAllFigures(save_figures,generate_flag,show_individual)
save_figures = 0;
generate_flag = 1;
show_individual = 0;
% if nargin < 1 || isempty(save_figures); save_figures = 0; end
% if nargin < 2 || isempty(generate_flag); generate_flag = 0; end
% if nargin < 3 || isempty(show_individual); show_individual = 0; end
%%
% Load data
load 'data_and_analysis.mat'
load mycolormap
% Init
% colors_m = [255 153 153; 253 196 7; 102 178 255]./255;
colors_y = [map(4,:);map(1,:);map(3,:);map(2,:)];
nbins    = 9;
nsubj    = length(newsubjdataC);
scale    = 4;
% yD       = [0; 60; 120; 210].*scale;
yD       = [0;4.8;9.6;16.8];
v_dy     = (6*scale)^2;
w        = 70*scale;
form     = 'nonparametric';
models   = {'threshold','baye','free','linear'};
nmodels  = length(models);
titles   = {'Fixed','Optimal','Nonparametric','Heuristic'};

%% AIC
figure(1);

AIC     = [2*6-ML(:,1).*2,2*6-ML(:,2).*2,2*9-ML(:,3).*2,2*7-ML(:,4).*2];
%AIC     = [AIC; mean(AIC)];
AIC_f   = bsxfun(@minus,AIC(:,1),AIC);
thisbar = bar(AIC_f(:,2:end));
hold on
AIC_mean = mean(AIC);
AIC_mean = AIC_mean(1) - AIC_mean;
mean_lines = plot(linspace(0,9,100),bsxfun(@times,AIC_mean(2:end)',ones(1,100)),'LineWidth',2);

for ii = 1:3
    thisbar(ii).FaceColor = Colors_m(ii,:);
    thisbar(ii).EdgeColor = thisbar(ii).FaceColor;
    mean_lines(ii).Color = Colors_m(ii,:);
end
Title = 'AIC relative to the Fixed model';
title(Title)
legend('Bayesian','Non-parametric','Linear')
legend BOXOFF
set(gca,'TickDir','out')
set(gca,'box','off')
xlabel('Subject ID')
ylabel('AIC_F_i_x_e_d - AIC')
%set(gca,'xticklabel',{1,2,3,4,5,6,7,8,'Mean'})

% if save_figures
%     print_pdf(Title)
% end
%% BIC
figure(2);
for ii = 1:nsubj
    logN(ii,1) = log(length(newsubjdataC{ii}(:,1)));
end
BIC    = [-2.*ML(:,1)+6*logN,-2.*ML(:,2)+6*logN,-2.*ML(:,3)+9*logN,-2.*ML(:,4)+7*logN];
%BIC    = [BIC; mean(BIC)];
BIC_f  = bsxfun(@minus,BIC(:,1),BIC);

thisbar = bar(BIC_f(:,2:end));
hold on
BIC_mean = mean(BIC);
BIC_mean = BIC_mean(1) - BIC_mean;
mean_lines = plot(linspace(0,9,100),bsxfun(@times,BIC_mean(2:end)',ones(1,100)),'LineWidth',2);


for ii = 1:3
    thisbar(ii).FaceColor = Colors_m(ii,:);
    thisbar(ii).EdgeColor = thisbar(ii).FaceColor;
    mean_lines(ii).Color = Colors_m(ii,:);
end
Title = 'BIC relative to the Fixed model';
title(Title)
xlabel('Subject NO.')
ylabel('BIC_F_i_x_e_d - BIC')
legend('Bayesian','Non-parametric','Linear')
legend BOXOFF
set(gca,'TickDir','out')
set(gca,'box','off')
%set(gca,'xticklabel',{1,2,3,4,5,6,7,8,'Mean'})
if save_figures
    print_pdf(Title)
end

%% Sum of leave-one-out log densities
loo_f = bsxfun(@minus,LOO,LOO(:,2));
loo_f = [loo_f(:,2),loo_f(:,9),loo_f(:,14),loo_f(:,13),loo_f(:,15),loo_f(:,5)];
titles  =  {'BO','MM','LH','TD','NP'};
figure;
thisbar = bar(loo_f(:,2:end));
hold on
% mean_lines = plot(linspace(0,9,100),bsxfun(@times,loo_mean(2:end)',ones(1,100)),'LineWidth',2);

for ii = 1:size(loo_f,2)-1
    thisbar(ii).FaceColor = colors_m(ii,:);
    thisbar(ii).EdgeColor = thisbar(ii).FaceColor;
end
% Title = 'LOO relative to the Fixed model';
makepretty(24,'Subject No.','LOO-LOO_F_C',titles,[],...
    [0,9],[-50,150],[],[],[],flip([150,100,50,0,-50]))
% if save_figures
%     print_pdf(Title)
% end
width = 10.5;
height = 8;
set(gcf,'InvertHardcopy','on');
set(gcf,'PaperUnits', 'inches');
papersize = get(gcf, 'PaperSize');
left = (papersize(1)- width)/2;
bottom = (papersize(2)- height)/2;
myfiguresize = [left, bottom, width, height];
set(gcf,'PaperPosition', myfiguresize);
%% LOO models
loo_f = bsxfun(@minus,LOO(:,2:end),LOO(:,2));
loo_f = [loo_f(:,1),loo_f(:,8),loo_f(:,12)];
%for ii = 1:size(loo_f,2)
ii=3;
figure;
thisbar = bar(loo_f(:,ii));
thisbar.FaceColor = [0.1    0.1    0.1];
thisbar.EdgeColor = thisbar.FaceColor;
hold on
thismean = mean(loo_f(:,ii)).*ones(1,100);
thisse = std(loo_f(:,ii))./sqrt(8).*ones(1,100);
plot(linspace(0,9,100),thismean,'LineWidth',2,'Color',[0.5  0.5  0.5]);
ylabel('LOO_{Lin} - LOO_{Fixed}')
ylim([-50,150])
xlim([0,9])
thisgraph = fill([linspace(0,9,100), fliplr(linspace(0,9,100))],[thismean+thisse,fliplr(thismean-thisse)],[0.4 0.4 0.4],'EdgeColor','none');
thisgraph.FaceAlpha = 0.4;
set(gca,'TickDir','out')
set(gca,'box','off')
xlabel('Subject No.')
%     title([titles{ii},' vs. Fixed'])
set(gca,'FontSize',32)
%     print_pdf(titles{ii})
width = 10.5;
height = 8;
set(gcf,'InvertHardcopy','on');
set(gcf,'PaperUnits', 'inches');
papersize = get(gcf, 'PaperSize');
left = (papersize(1)- width)/2;
bottom = (papersize(2)- height)/2;
myfiguresize = [left, bottom, width, height];
set(gcf,'PaperPosition', myfiguresize);

%end
%% RBM AICs
figure;
thisbar = bar(AIC_f');
hold on
% mean_lines = plot(linspace(0,9,100),bsxfun(@times,loo_mean(2:end)',ones(1,100)),'LineWidth',2);

for ii = 1:size(AIC_f,1)
    thisbar(ii).FaceColor = colors_m(ii+1,:);
    thisbar(ii).EdgeColor = thisbar(ii).FaceColor;
end
Title = 'AIC relative to the Fixed model';
makepretty(22,'Classifier No.','AIC_F_i_x_e_d - AIC',{'Bayesian','Linear','Nonparametric'},Title,...
    [0,9],[500,850],[],[],[],[]);

%% Generate fake data
generate_flag = 1;
form     = 'cross';
models = {'threshold','baye2','linear3'};
nmodels = length(models);
idx = [2,9,10];
spacing  = 1:500:30000;
if generate_flag
    fakedata = NaN(2400,4,nmodels,nsubj,length(spacing));
    for modelidx = 1:nmodels
        thissamples = cross_samples_all{idx(modelidx)};
        for subjidx = 1:nsubj
            for sampleidx = 1:length(spacing)
                thistheta = thissamples(spacing(sampleidx),:,subjidx);
                thisdata = generatefakedata(feedtheta(thistheta,models{modelidx},form),...
                    v_dy,models{modelidx},'C','on',form,0,2400);
                fakedata(:,:,modelidx,subjidx,sampleidx) = thisdata(:,1:4);
            end
        end
    end
else
    load fakedata
end
%% generate fakedata for discrimination transfer fit (or joint fit)
generate_flag = 1;
form     = 'nonparametric';
models = {'threshold','baye2','linear3'};
nmodels = length(models);
idx = [1,2,3];
spacing  = 1:500:30000;
if generate_flag
    fakedata = NaN(2400,4,nmodels,nsubj,length(spacing));
    for modelidx = 1:nmodels
        thissamples = samples_j_all{idx(modelidx)};
        for subjidx = 1:nsubj
            for sampleidx = 1:length(spacing)
                thistheta = thissamples(spacing(sampleidx),:,subjidx);
                thisdata = generatefakedata(feedtheta(thistheta,models{modelidx},form),...
                    v_dy,models{modelidx},'C','on',form,0,2400);
                fakedata(:,:,modelidx,subjidx,sampleidx) = thisdata(:,1:4);
            end
        end
    end
else
    load fakedata
end
%% Individual fits
% Bin data
[edges,label] = getbounds(9,v_dy);
labelmat = repmat(label',1,4);

prop_model_all  = NaN(length(yD),nbins,nmodels,nsubj,length(spacing));
for modelidx = 1:nmodels
    for subjidx = 1:nsubj
        for sampleidx = 1:length(spacing)
            yvec = fakedata(:,1,modelidx,subjidx,sampleidx);
            dyvec = fakedata(:,2,modelidx,subjidx,sampleidx);
            response = fakedata(:,4,modelidx,subjidx,sampleidx);
            prop_model_all(:,:,modelidx,subjidx,sampleidx) = bindata(edges,yvec,dyvec,response);
        end
    end
end
%%
prop_data_ind  = NaN(length(yD),nbins,nsubj);
prop_model_ind = NaN(length(yD),nbins,nmodels,nsubj);
se_model_ind   = NaN(length(yD),nbins,nmodels,nsubj);

show_individual = 0;
titles = {'threshold','baye2','linear3'};
for subjidx = 1:nsubj
    if show_individual
        figure;
    end
    yvec_data = newsubjdataC{subjidx}(:,1);
    dyvec_data = newsubjdataC{subjidx}(:,2);
    response_data = newsubjdataC{subjidx}(:,4);
    prop_data_ind(:,:,subjidx) = bindata(edges,yvec_data,dyvec_data,response_data);
    for modelidx = 1:nmodels
        thisprop= squeeze(prop_model_all(:,:,modelidx,subjidx,:));
        prop_model_ind(:,:,modelidx,subjidx) = squeeze(mean(thisprop,3));
        se_model_ind(:,:,modelidx,subjidx) = squeeze(std(thisprop,[],3))./sqrt(length(spacing));
        if show_individual
            if mod(modelidx,2) == 0; col = 2; isylabel = 0; else col = 1; isylabel = 1; end
            if modelidx < 3; row = 1; isxlabel = 0; else row = 2; isxlabel = 1; end
            tight_subplot(2,2,row,col,0.12,[.1 .15 .04 .06]);
            if modelidx == 4; islegend = 1; else islegend = 0; end
            plotfits(prop_data_ind(:,:,subjidx),[],prop_model_ind(:,:,modelidx,subjidx),...
                se_model_ind(:,:,modelidx,subjidx),label,colors_y,1,islegend,titles{modelidx},'Prop. reporting same',isylabel,isxlabel,yD,1);
        end
    end
    
end
%% Model fit across subjects (Sameness)
isylabel = 1;
isxlabel = 1;
islegend = 0;
prop_data  = squeeze(mean(prop_data_ind,3))';
se_data    = squeeze(std(prop_data_ind,[],3))'./sqrt(8);
figure;
plotfits(prop_data,se_data,[],...
    [],label,colors_y,[],[],[],'Proportion reporting collinear',[],[],yD,0);

%%
prop_model = NaN(length(yD),nbins,nmodels);
se_model   = NaN(length(yD),nbins,nmodels);
%figure;
for modelidx = 1:nmodels
    figure;
    prop_model(:,:,modelidx) = mean(squeeze(prop_model_ind(:,:,modelidx,:)),3);
    se_model(:,:,modelidx) = std(squeeze(prop_model_ind(:,:,modelidx,:)),[],3)./sqrt(nsubj);
    %if mod(modelidx,2) == 0; col = 2; isylabel = 0; else col = 1; isylabel = 1; end
    %if modelidx < 3; row = 1; isxlabel = 0; else row = 2; isxlabel = 1; end
    %tight_subplot(2,2,row,col,[0.05,0.1],[.1 .15 .1 .1]);
    %     if modelidx == 1; islegend = 1; else islegend = 0; end
    plotfits(prop_data,se_data,prop_model(:,:,modelidx),...
        se_model(:,:,modelidx),label,colors_y,0,islegend,[],'Proportion reporting collinear',isylabel,isxlabel,[0;4.8;9.6;16.8],1);
    %ylabel('Proportion reporting collinear')
    
end
%% Height Judgement data
for subjidx = 1:nsubj
    yvec_data = newsubjdataD{subjidx}(:,1);
    dyvec_data = newsubjdataD{subjidx}(:,2);
    response_data = newsubjdataD{subjidx}(:,4);
    prop_data_ind_D(:,:,subjidx) = bindata(edges,yvec_data,dyvec_data,response_data,1);
end
prop_data_D = squeeze(mean(prop_data_ind_D,3))';
se_data_D   = squeeze(std(prop_data_ind_D,[],3))'./sqrt(8);
figure;
plotfits(prop_data_D,se_data_D,[],...
    [],label,colors_y,0,0,'','Proportion reporting right higher',[],[],yD,0);
% axis square
%% Comparing to height judgement task results:
width = 8;
height = 8;
figure;
plot([0:0.1:8],[0:0.1:8],'--','Color',[0.5 0.5 0.5],'Linewidth',3)
hold on
sigma_C = theta_est_all{13}(1:4,:);
mean_C  = mean(sigma_C,2);
eb_1 = std(sigma_C,[],2)/sqrt(8);
sigma_D = theta_est_D(1:4,:);
eb_2 = std(sigma_D,[],2)/sqrt(8);
mean_D  = mean(sigma_D,2);
for ii = 1:4
    scatters(ii) = scatter(sigma_C(ii,:),sigma_D(ii,:),70,colors_y(ii,:),'Filled','Linewidth',3);
end
for ii = 1:4
    line([mean_C(ii),mean_C(ii)],[mean_D(ii)-eb_2(ii),mean_D(ii)+eb_2(ii)],'Color',colors_y(ii,:),'Linewidth',3)
    herro = herrorbar(mean_C(ii),mean_D(ii),eb_1(ii));
    herro(1).Color = colors_y(ii,:);
    herro(2).Color = colors_y(ii,:);
    herro(1).LineWidth = 3;
    herro(2).LineWidth = 3;
end

% legend(scatters,strcat('\ity \rm=',num2str(yD)),'Location','Best');
% legend BOXOFF
xlim([0,8])
ylim([0,8])

set(gca,'TickDir','out')
set(gca,'box','off')
% set(gca,'YTick',[0 2 4 6 8]);
% set(gca,'XTick',[0 2 4 6 8]);
set(gca,'YTick',[0 2 4 6 8]);
set(gca,'XTick',[0 2 4 6 8]);
% 0.0200    0.1478    1.0920    8.0686   59.6192
set(gca,'XTickLabel',[0.02 0.15 1.1 8.1 59.6]);
set(gca,'YTickLabel',[0.02 0.15 1.1 8.1 59.6]);
% set(gca,'XTickLabel',[0.02 1.1 59.6]);
% set(gca,'YTickLabel',[0.02 1.1 59.6]);
% xlabel('Sameness Judgement noise estimates (log)')
% ylabel('Height Judgement noise estimates (log)')
% xlabel('Noise estimates from main task (dva)')
% ylabel('Noise estimates from height judgement task (dva)')
xlabel('Estimated collinearity judgment noise')
ylabel('Estimated height judgment noise')
axis square
set(gca,'FontSize',24)
set(gcf,'InvertHardcopy','on');
set(gcf,'PaperUnits', 'inches');
papersize = get(gcf, 'PaperSize');
left = (papersize(1)- width)/2;
bottom = (papersize(2)- height)/2;
myfiguresize = [left, bottom, width, height];
set(gcf,'PaperPosition', myfiguresize);
print('dis vs cat','-dpng','-r300');
%% Accuracy by offset
for subjidx = 1:8
    for ii = 1:length(edges)-1
        currentdata = newsubjdataC{subjidx}((newsubjdataC{subjidx}(:,2)<= edges(ii+1) & ...
            newsubjdataC{subjidx}(:,2) > edges(ii) & newsubjdataC{subjidx}(:,2) ~= 0),:);
        accuracy(subjidx,ii) = sum(currentdata(:,3) ~= currentdata(:,4))/length(currentdata(:,1));
    end
end

width = 10;
height = 8;
figure;
mean_accuracy = mean(accuracy);
se_accuracy = std(accuracy)/sqrt(8);
errorbar(label, mean_accuracy,se_accuracy,'Color','k','LineWidth',5);
xlim([-60,60])
ylim([0,1])
% ylim([0.5,1])
ylabel('Proportion reporting collinear')
xlabel('Offset (dva)')
set(gca,'TickDir','out')
% axis square

set(gca,'YTick',[0,0.2,0.4,0.6,0.8,1]);
% set(gca,'XTick',label);
set(gca,'XTick',[label(1),label(3),label(5),label(7),label(9)]);
% set(gca,'XTickLabel',{'-1','-0.8','-0.5','-0.2','0','0.2','0.5','0.8','1'});
set(gca,'XTickLabel',{'-1','-0.5','0','0.5','1'});
set(gca,'box','off')
set(gca,'FontSize',32)
set(gcf,'InvertHardcopy','on');
set(gcf,'PaperUnits', 'inches');
papersize = get(gcf, 'PaperSize');
left = (papersize(1)- width)/2;
bottom = (papersize(2)- height)/2;
myfiguresize = [left, bottom, width, height];
set(gcf,'PaperPosition', myfiguresize);
print('accuracy_offset','-dpng','-r300');
%% Accuracy
hitrate = NaN(8,4);
farate = NaN(8,4);
yD       = [0; 60; 120; 210].*scale;
for subjidx = 1:length(newsubjdataC)
    for ii = 1:4
        yval = yD(ii);
        currentdata = newsubjdataC{subjidx}((newsubjdataC{subjidx}(:,1)==yval),:);
        hitrate(subjidx,ii) = sum(currentdata(:,3) == 1 & currentdata(:,4)==1)/sum(currentdata(:,3) == 1);
        farate(subjidx,ii)  = sum(currentdata(:,3) == 0 & currentdata(:,4)==1)/sum(currentdata(:,3) == 0);
    end
end

accuracy = (hitrate + 1-farate)./2;
%%
width = 10;
height = 8;
figure;
mean_accuracy = mean(accuracy);
se_accuracy = std(accuracy)/sqrt(8);
errorbar(yD, mean_accuracy,se_accuracy,'Color','k','LineWidth',5);
xlim([-20,850])
ylim([0.5,1])
ylabel('Accuracy')
xlabel('Retinal eccentricity (dva)')
set(gca,'TickDir','out')
% axis square

set(gca,'YTick',[0.5,0.6,0.7,0.8,0.9,1]);
% set(gca,'YTickLabel',{'0','...','0.6','0.7','0.8','0.9','1'});
set(gca,'XTick',yD);
set(gca,'XTickLabel',{'0','4.8','9.6','16.8'});
set(gca,'box','off')
set(gca,'FontSize',32)
set(gcf,'InvertHardcopy','on');
set(gcf,'PaperUnits', 'inches');
papersize = get(gcf, 'PaperSize');
left = (papersize(1)- width)/2;
bottom = (papersize(2)- height)/2;
myfiguresize = [left, bottom, width, height];
set(gcf,'PaperPosition', myfiguresize);
% print('accuracy','-dpng','-r300');
%%
for subjidx = 1:length(newsubjdataC)
    thetavec = sigma_D(:,subjidx);
    thetavec = [thetavec;0.5;0];
    dataopt(:,:,subjidx) = generatefakedata(feedtheta(thetavec','baye','nonparametric'),v_dy,'baye','C','on','nonparametric',0,24000);
end
for subjidx = 1:length(newsubjdataC)
    thetavec = sigma_C(:,subjidx);
    thetavec = [thetavec;0.5;0];
    dataopt_C(:,:,subjidx) = generatefakedata(feedtheta(thetavec','baye','nonparametric'),v_dy,'baye','C','on','nonparametric',0,24000);
end

for subjidx = 1:length(newsubjdataC)
    for ii = 1:4
        yval = yD(ii);
        currentdata = dataopt((dataopt(:,1,subjidx)==yval),:,subjidx);
        hitrate_opt(subjidx,ii) = sum(currentdata(:,3) == 1 & currentdata(:,4)==1)/sum(currentdata(:,3) == 1);
        farate_opt(subjidx,ii)  = sum(currentdata(:,3) == 0 & currentdata(:,4)==1)/sum(currentdata(:,3) == 0);
    end
end
for subjidx = 1:length(newsubjdataC)
    for ii = 1:4
        yval = yD(ii);
        currentdata = dataopt_C((dataopt_C(:,1,subjidx)==yval),:,subjidx);
        hitrate_opt_C(subjidx,ii) = sum(currentdata(:,3) == 1 & currentdata(:,4)==1)/sum(currentdata(:,3) == 1);
        farate_opt_C(subjidx,ii)  = sum(currentdata(:,3) == 0 & currentdata(:,4)==1)/sum(currentdata(:,3) == 0);
    end
end
hold on
ylim([0.5,1])
accuracy_opt = (hitrate_opt + 1-farate_opt)./2;
accuracy_opt_C = (hitrate_opt_C + 1-farate_opt_C)./2;
mean_accuracyopt = mean(accuracy_opt);
se_accuracyopt = std(accuracy_opt)/sqrt(8);
mean_accuracyopt_C = mean(accuracy_opt_C);
se_accuracyopt_C = std(accuracy_opt_C)/sqrt(8);
errorbar(yD, mean_accuracyopt_C,se_accuracyopt_C,'LineWidth',5,'Color',[ 153, 204, 0]/255);
errorbar(yD, mean_accuracyopt,se_accuracyopt,'LineWidth',5,'Color',[77, 166, 255]/255);
% set(gca,'YTick',[0.5 0.75 1]);
% legend('Actual accuracy across subjects','Location','Best')
% legend('Actual accuracy across subjects','Accuracy if optimal (Collinearity judgement noise)','Accuracy if optimal (Height judgement noise)','Location','Best')
% legend('Actual accuracy across subjects','Accuracy if optimal (Height judgement noise)','Location','Best')
legend('','','','Location','Best')
legend BOXOFF
% set(gca,'TickDir','out')
% set(gca,'XTick',yD);
% set(gca,'XTickLabel',{'0','4.8','9.6','16.8'});
% set(gca,'FontSize',18);
%%
figure;
plot([0.5:0.001:1],[0.5:0.001:1],'--','Color',[0.5 0.5 0.5],'Linewidth',2)
hold on

accuracy = accuracy';
accuracy_opt_C = accuracy_opt_C';
mean_1  = mean(accuracy,2);
mean_2  = mean(accuracy_opt_C,2);
for ii = 1:4
    scatters(ii) = scatter(accuracy(ii,:),accuracy_opt_C(ii,:),30,colors_y(ii,:),'Linewidth',2);
    scatter(mean_1(ii),mean_2(ii),200,colors_y(ii,:),'Filled')
end

legend(scatters,strcat('y=',num2str(yD),'\circ'),'Location','Best');
legend BOXOFF
xlim([0.5,1])
ylim([0.5,1])
set(gca,'FontSize',16);
set(gca,'TickDir','out')
set(gca,'box','off')
set(gca,'YTick',[0.5 0.75 1]);
set(gca,'XTick',[0.5 0.75 1]);
% 0.0200    0.1478    1.0920    8.0686   59.6192

xlabel('Accuracy from data (%)')
ylabel('Accuracy if optimal (%)')

%%
figure;
plot([0.5:0.001:1],[0.5:0.001:1],'--','Color',[0.5 0.5 0.5],'Linewidth',2)
hold on


%accuracy_opt = accuracy_opt';
mean_1  = mean(accuracy,2);
eb_1 = std(accuracy,[],2)/sqrt(8);
mean_2  = mean(accuracy_opt,2);
eb_2 = std(accuracy_opt,[],2)/sqrt(8);
for ii = 1:4
    scatters(ii) = scatter(accuracy(ii,:),accuracy_opt(ii,:),30,colors_y(ii,:),'Filled','o','Linewidth',2);
end
% for ii = 1:4
%     scatter(mean_1(ii),mean_2(ii),100,Colors_y(ii,:),'Filled')
% en

for ii = 1:4
    line([mean_1(ii),mean_1(ii)],[mean_2(ii)-eb_2(ii),mean_2(ii)+eb_2(ii)],'Color',colors_y(ii,:),'Linewidth',3)
    herro = herrorbar(mean_1(ii),mean_2(ii),eb_1(ii));
    herro(1).Color = colors_y(ii,:);
    herro(2).Color = colors_y(ii,:);
    herro(1).LineWidth = 3;
    herro(2).LineWidth = 3;
end
legend(scatters,strcat('y=',num2str(yD),'\circ'),'Location','Best');
legend BOXOFF
xlim([0.5,1])
ylim([0.5,1])
set(gca,'FontSize',16);
set(gca,'TickDir','out')
set(gca,'box','off')
set(gca,'YTick',[0.5 0.6 0.7 0.8 0.9 1]);
set(gca,'XTick',[0.5 0.6 0.7 0.8 0.9 1]);
axis square
% 0.0200    0.1478    1.0920    8.0686   59.6192

xlabel('Accuracy from data')
ylabel('Accuracy if optimal')

%% LOO models - cross
loo_cross_f = bsxfun(@minus,loo_cross(:,1),loo_cross);
for ii = 2:3
    figure;
    thisbar = bar(loo_cross_f(:,ii));
    thisbar.FaceColor = [0.5882    0.5882    0.5882];
    thisbar.EdgeColor = thisbar.FaceColor;
    hold on
    thismean = mean(loo_cross_f(:,ii)).*ones(1,100);
    thisse = std(loo_cross_f(:,ii))./sqrt(8).*ones(1,100);
    plot(linspace(0,9,100),thismean,'LineWidth',2,'Color',Colors_m(1,:));
    ylabel('LOO_F_i_x_e_d - LOO')
    %ylim([-150,50])
    xlim([0,9])
    thisgraph = fill([linspace(0,9,100), fliplr(linspace(0,9,100))],[thismean+thisse,fliplr(thismean-thisse)],Colors_m(1,:),'EdgeColor','none');
    thisgraph.FaceAlpha = 0.4;
    set(gca,'TickDir','out')
    set(gca,'box','off')
    xlabel('Subject No.')
    title(titles{ii})
end
%% LOO models - cross
BIC_f =  -BIC_f;
titles   = {'Fixed','Optimal','Heuristic'};
for ii = 2:3
    figure;
    thisbar = bar(BIC_f(:,ii));
    thisbar.FaceColor = [0.5882    0.5882    0.5882];
    thisbar.EdgeColor = thisbar.FaceColor;
    hold on
    thismean = mean(BIC_f(:,ii)).*ones(1,100);
    thisse = std(BIC_f(:,ii))./sqrt(8).*ones(1,100);
    plot(linspace(0,9,100),thismean,'LineWidth',2,'Color',Colors_m(1,:));
    ylabel('LOO_F_i_x_e_d - LOO')
    ylim([-300,100])
    xlim([0,9])
    thisgraph = fill([linspace(0,9,100), fliplr(linspace(0,9,100))],[thismean+thisse,fliplr(thismean-thisse)],Colors_m(1,:),'EdgeColor','none');
    thisgraph.FaceAlpha = 0.4;
    set(gca,'TickDir','out')
    set(gca,'box','off')
    xlabel('Subject No.')
    title(titles{ii})
end
%% linear descision boundaries
boundaries = theta_est_all{5}(5:8,:);
figure;
hold on
for ii  = 1:8
    plot(yD,boundaries(:,ii),'Color',[0.7 0.7 0.7])
end
plot(yD,mean(boundaries,2),'-o','LineWidth',3)
xlim([0,16.8])
axis square
set(gca,'TickDir','out')
set(gca,'box','off')
set(gca,'FontSize',20)
set(gca,'XTick',yD);
set(gca,'YTick',[0,25,50]);
xlabel('Eccentricity(\circ)')
set(gcf,'InvertHardcopy','on');
set(gcf,'PaperUnits', 'inches');
papersize = get(gcf, 'PaperSize');
left = (papersize(1)- width)/2;
bottom = (papersize(2)- height)/2;
myfiguresize = [left, bottom, width, height];
set(gcf,'PaperPosition', myfiguresize);

% Save the file as PNG
print('boundaries','-dpng','-r300');

%%
width = 8;     % Width in inches
height = 5;    % Height in inches
figure;
hold on
variances = exp(theta_est_all{5}(1:4,6));
xx = linspace(-150,150,1000);
for ii = 1:4
    %     plot(xx,1/sqrt(4*pi*variances(ii)).*exp((-(xx.^2)./(4*variances(ii)))),'Color',colors_y(ii,:),'LineWidth',4);
    plot(xx,1/sqrt(2*pi*variances(ii)).*exp((-(xx.^2)./(2*variances(ii)))),'Color',colors_y(ii,:),'LineWidth',6);
end
set(gca,'TickDir','out')
set(gca,'box','off')
set(gca,'FontSize',24)
set(gca,'XTick',[-120,0,120]);
% set(gca,'XTickLabel',{'\Delta\ity \rm-2.4','\Delta\ity ','\Delta\ity \rm+2.4'});
% set(gca,'XTickLabel',{'','\ity\rm_R or \ity\rm_L',''});
set(gca,'XTickLabel',{'','',''});
set(gca,'YTick',[0,0.125]);
ylim([0,0.125])
xlim([-120,120])
set(gca,'YTickLabel','');
% xlabel('Measurement (dva)')
ylabel('Probability')
set(gcf,'InvertHardcopy','on');
set(gcf,'PaperUnits', 'inches');
papersize = get(gcf, 'PaperSize');
left = (papersize(1)- width)/2;
bottom = (papersize(2)- height)/2;
myfiguresize = [left, bottom, width, height];
set(gcf,'PaperPosition', myfiguresize);
% legend([strcat('  \ity \rm =  ',num2str([0,4.8,9.6,16.8]'))],'Location','Best');
% legend BOXOFF
% set(gca, 'visible', 'off')
% print('measurement2','-dpng','-r300');
%%
figure;
xx = linspace(-120,120,1000);
% plot(zeros(1,50),linspace(0,0.125,50),'.','Color',[0.6, 0.6, 0.6],'MarkerSize',20)
hold on
% plot(xx,1/sqrt(4*pi*v_dy).*exp((-(xx.^2)./(4*v_dy))),'Color',[0.6, 0.6, 0.6],'LineWidth',4);
% plot(xx,1/sqrt(2*pi*v_dy).*exp((-(xx.^2)./(2*v_dy))),'Color',[0.6, 0.6, 0.6],'LineWidth',6);
set(gca,'TickDir','out')
set(gca,'box','off')
set(gca,'FontSize',24)
set(gca,'XTick',[-120,-16,120]);
% set(gca,'XTickLabel',{-2.4,0,2.4});
set(gca,'XTickLabel',{[],[],[]})
% set(gca,'YTick',[0,0.085]);
set(gca,'YTick',[0,1]);
ylim([0,0.125])
xlim([-120,120])
set(gca,'YTickLabel','');
% xlabel('Stimulus (dva)')
ylabel('Probability')
set(gcf,'InvertHardcopy','on');
set(gcf,'PaperUnits', 'inches');
papersize = get(gcf, 'PaperSize');
left = (papersize(1)- width)/2;
bottom = (papersize(2)- height)/2;
myfiguresize = [left, bottom, width, height];
set(gcf,'PaperPosition', myfiguresize);
% legend('  \itC \rm = 1','  \itC \rm = 0')
% legend BOXOFF
% set(gca, 'visible', 'off')
% print('stimulus2','-dpng','-r300');
%%
[edges,label] = getbounds(9,v_dy);
labelmat = repmat(label',1,4);
subjs = [1,2,3,7,8];
for ii = 1:length(subjs)
    subjidx = subjs(ii);
    %     figure;
    yvec_data = newsubjdataC{subjidx}(:,1);
    dyvec_data = newsubjdataC{subjidx}(:,2);
    response_data = newsubjdataC{subjidx}(:,4);
    prop_data_ind(:,:,ii) = bindata(edges,yvec_data,dyvec_data,response_data);
end
figure;
newDefaultColors = colors_y;
set(gca, 'ColorOrder', newDefaultColors, 'NextPlot', 'replacechildren');
mean_prop = mean(prop_data_ind,3);
se_prop = std(prop_data_ind,[],3)./sqrt(5);
errorbar(labelmat,mean_prop',se_prop','LineWidth',2)
hold on
for subjidx = 1:8
    yvec_data2 = newsubjdataC{subjidx}(:,1);
    dyvec_data2 = newsubjdataC{subjidx}(:,2);
    response_data2 = newsubjdataC{subjidx}(:,4);
    prop_data_ind2(:,:,subjidx) = bindata(edges,yvec_data2,dyvec_data2,response_data2);
end
mean_prop2 = mean(prop_data_ind2,3);
se_prop2 = std(prop_data_ind2,[],3)./sqrt(8);
errorbar(labelmat,mean_prop2',se_prop2','--','LineWidth',2)
ylim([0,1])


%% LOO cross
loo_f = bsxfun(@minus,LOO_cross,LOO_cross(:,1));
loo_f = [loo_f(:,1),loo_f(:,8),loo_f(:,9)];
% for ii = 1:size(loo_f,2)
ii=3;
figure;
thisbar = bar(loo_f(:,ii));
thisbar.FaceColor = [0.1 0.1 0.1];
thisbar.EdgeColor = thisbar.FaceColor;
hold on
thismean = mean(loo_f(:,ii)).*ones(1,100);
thisse = std(loo_f(:,ii))./sqrt(8).*ones(1,100);
plot(linspace(0,9,100),thismean,'LineWidth',2,'Color',[0.5 0.5 0.5]);
ylabel('LOO_{Lin} - LOO_{Fixed}')
ylim([-50,300])
xlim([0,9])
set(gca,'YTick',[0,100,200,300]);
thisgraph = fill([linspace(0,9,100), fliplr(linspace(0,9,100))],[thismean+thisse,fliplr(thismean-thisse)],[0.4 0.4 0.4],'EdgeColor','none');
thisgraph.FaceAlpha = 0.4;
set(gca,'TickDir','out')
set(gca,'box','off')
xlabel('Subject No.')
%     title([titles{ii},' vs. Fixed'])
set(gca,'FontSize',32)
%     print_pdf(titles{ii})
width = 10.5;
height = 8;
set(gcf,'InvertHardcopy','on');
set(gcf,'PaperUnits', 'inches');
papersize = get(gcf, 'PaperSize');
left = (papersize(1)- width)/2;
bottom = (papersize(2)- height)/2;
myfiguresize = [left, bottom, width, height];
set(gcf,'PaperPosition', myfiguresize);

% end
%%
width = 8;
height = 8;
figure;
plot(0:0.5:50,0:0.5:50,'--','Color',[0.7 0.7 0.7],'Linewidth',3);
hold on
temp = theta_est_all{13}(1:4,:);
temp_lin = bsxfun(@plus,bsxfun(@times,sqrt(exp(temp)),theta_est_all{13}(5,:)),theta_est_all{13}(6,:));
for ii = 1:4
    scatters(ii) = scatter(temp_lin(ii,:),theta_est_all{5}(ii+4,:),100,colors_y(ii,:),'Filled');
    hold on
end
axis square
ylim([0,50])
xlim([0,50])
set(gca,'YTick',[0,10,20,30,40,50]);
set(gca,'XTick',[0,10,20,30,40,50]);
set(gca,'box','off')
set(gca,'FontSize',24)
xlabel('Decision boundary from Lin (dva)')
ylabel('Decision boundary from Nonparametric (dva)')
set(gcf,'InvertHardcopy','on');
set(gcf,'PaperUnits', 'inches');
papersize = get(gcf, 'PaperSize');
legend(scatters,strcat('y = ',num2str(yD)),'Location','Best');
legend BOXOFF
left = (papersize(1)- width)/2;
bottom = (papersize(2)- height)/2;
myfiguresize = [left, bottom, width, height];
set(gcf,'PaperPosition', myfiguresize);
% print('lin_vs_free','-dpng','-r300');
%%
width = 8;
height = 8;
temp = bsxfun(@times,sqrt(exp(theta_est_all{13}(1:4,:))),theta_est_all{13}(5,:));
temp = bsxfun(@plus,temp,theta_est_all{13}(6,:));
figure;errorbar(yD,mean(temp,2),std(temp,[],2)/sqrt(8),'LineWidth',6,'Color',colors_m(3,:))
hold on
scatter(yD,mean(theta_est_all{5}(5:8,:),2),200,colors_m(5,:),'Filled')
errorbar(yD,mean(theta_est_all{5}(5:8,:),2),std(theta_est_all{5}(5:8,:),[],2)/sqrt(8),'o','Color',colors_m(5,:),'LineWidth',4)
set(gca,'TickDir','out')
ylim([0,40])
xlim([0,17])
axis square
set(gca,'YTick',[0,10,20,30,40])
set(gca,'XTick',yD);
set(gca,'XTickLabel',{'0','4.8','9.6','16.8'});
set(gca,'box','off')
set(gca,'FontSize',24)
xlabel('Eccentricity (dva)')
ylabel('Decision boundary (dva)')
set(gcf,'InvertHardcopy','on');
set(gcf,'PaperUnits', 'inches');
papersize = get(gcf, 'PaperSize');
left = (papersize(1)- width)/2;
bottom = (papersize(2)- height)/2;
myfiguresize = [left, bottom, width, height];
set(gcf,'PaperPosition', myfiguresize);
print('decision_bounds','-dpng','-r300');

%% model accuracy

accuracy_model_all  = NaN(length(yD),nbins,nmodels,nsubj,length(spacing));
for modelidx = 1:nmodels
    for subjidx = 1:nsubj
        for sampleidx = 1:length(spacing)
            yvec = fakedata(:,1,modelidx,subjidx,sampleidx);
            dyvec = fakedata(:,2,modelidx,subjidx,sampleidx);
            truth = fakedata(:,3,modelidx,subjidx,sampleidx);
            response = fakedata(:,4,modelidx,subjidx,sampleidx);
            yval = unique(yvec);
            prop = NaN(length(yval), length(edges)-1);
            for ii=1:length(yval)
                yind=yval(ii);
                tempdy=dyvec(yvec==yind);
                [~, bins] = histc(tempdy,edges);
                tempC=response(yvec==yind);
                tempT=truth(yvec==yind);
                for dyind=1:length(edges)-1
                    temp0 = tempC(bins==dyind);
                    temp1 = tempT(bins==dyind);
                    prop(ii,dyind) = mean(temp0==temp1);
                    %se(ii,dyind) = std(temp0)/sqrt(length(temp0));
                end
            end
            accuracy_model_all(:,:,modelidx,subjidx,sampleidx) = prop;
        end
    end
end

accuracy_model_ind = NaN(4,nbins,modelidx,subjidx);

for subjidx = 1:nsubj
    for modelidx = 1:nmodels
        thisprop= squeeze(accuracy_model_all(:,:,modelidx,subjidx,:));
        accuracy_model_ind(:,:,modelidx,subjidx) = squeeze(mean(thisprop,3));
    end
end
for modelidx = 1:nmodels
    prop_model(:,:,modelidx) = mean(squeeze(accuracy_model_ind(:,:,modelidx,:)),3);
    se_model(:,:,modelidx) = std(squeeze(accuracy_model_ind(:,:,modelidx,:)),[],3)./sqrt(nsubj);
end

%%
figure;
width =  10;
height = 8;
means = mean(BIC_b,2);
ses = std(BIC_b,[],2)/sqrt(10);
plot([20:0.2:125],zeros(1,length([20:0.2:125])),'Color',[0.8784    0.2392    0.5608],'LineWidth',3)
hold on
plot(ones(1,length([-600:1:400]))*50,[-600:1:400],'--','Color',[0.7 0.7 0.7],'LineWidth',3)
plot([20:0.2:125],ones(1,length([20:0.2:125]))*-126.0734,'--','Color',[0.7 0.7 0.7],'LineWidth',3)
errorbar(savepoints,means,ses,'k','LineWidth',3);
xlim([20,125])
set(gca,'YTick',[-800,-600,-400,-200,0,200,400,600])
set(gca,'XTick',[25,50,75,100,125])
xlabel('# of epochs')
ylabel('BIC_{lin}-BIC_{Bayes}')
set(gca,'FontSize',24);
set(gca,'TickDir','out')
set(gca,'box','off')
set(gcf,'InvertHardcopy','on');
set(gcf,'PaperUnits', 'inches');
papersize = get(gcf, 'PaperSize');
left = (papersize(1)- width)/2;
bottom = (papersize(2)- height)/2;
myfiguresize = [left, bottom, width, height];
set(gcf,'PaperPosition', myfiguresize);

%%
[~,locs] = min(BIC,[],2);
loc=squeeze(locs);
cts = NaN(20,3);
for ii = 1:3
    for jj = 1:20
        cts(jj,ii) = sum(locs(jj,:)==ii);
    end
end
% temp = cts(7,2);
% cts(7,2)=cts(7,3);
% cts(7,3)=temp;
figure;
fill([savepoints,flip(savepoints)],[cts(:,3)'+cts(:,2)',flip(cts(:,3)')],[0.6510    0.8588    0.3490],'EdgeColor','none')
hold on
fill([savepoints,flip(savepoints)],[cts(:,3)',zeros(1,20)],[0 0.6000 1.0000],'EdgeColor','none')
fill([savepoints,flip(savepoints)],[ones(1,20)*20,flip(cts(:,3)'+cts(:,2)')],[1.0000    0.7608    0.2392],'EdgeColor','none')
plot(ones(1,length([0:0.5:20]))*50,[0:0.5:20],'--','Color',[0.7 0.7 0.7],'LineWidth',3)
plot([25:1:120],ones(1,length([25:1:120]))*5,'--','Color',[0.7 0.7 0.7],'LineWidth',3)
xlim([savepoints(1),savepoints(20)])
set(gca,'YTick',[0 10 20])
set(gca,'YTickLabel',[0 0.5 1])
set(gca,'XTick',[25,50,75,100,120])
xlabel('# of epochs')
ylabel('Prop. of model wins')
set(gca,'FontSize',24);
set(gca,'TickDir','out')
set(gca,'box','off')
set(gcf,'InvertHardcopy','on');
set(gcf,'PaperUnits', 'inches');
axis square
papersize = get(gcf, 'PaperSize');
width =  8;
height = 8;
left = (papersize(1)- width)/2;
bottom = (papersize(2)- height)/2;
myfiguresize = [left, bottom, width, height];
set(gcf,'PaperPosition', myfiguresize);

%%
R_min = 1;
R_max = 0;
models = [2,5,9,13,14,15];

for ii = 1:6
    modelid = models(ii);
    for jj = 1:8
        [R,~,~,~,~,~,~] = psrf(cat(3,samples_all{modelid}(1:10000,:,jj),samples_all{modelid}(10001:20000,:,jj),samples_all{modelid}(20001:30000,:,jj)));
        this_min = min(R);
        this_max = max(R);
        if this_min < R_min
            R_min = this_min;
        end
        if this_max > R_max
            R_max = this_max;
        end
        
    end
    
end

%%

hitrate = NaN(8,4,4);
farate = NaN(8,4,4);
subjectname = {'AM','CY','DR','MR','SG','SJ','YL','ZK'};
for subjidx = 1:length(subjectname)
    for jj = 1:4 % session
        datafilename = strcat(subjectname{subjidx},num2str(jj), '.mat');
        load(datafilename);
        datafilename
        thismat = fullDataMat;
        thismat((thismat(:,6)==-100),:)=[]; % remove trials with multiple key presses
        trial_type = thismat(:,5);
        idxC = find(trial_type == 0 | trial_type == 1);
        rawC = thismat(idxC,[1 2 5 6 13 9 10]);
        rawC(rawC(:,4)==114,4) = 1;
        rawC(rawC(:,4)==101,4) = 1;
        rawC(rawC(:,4)==119,4) = 1;
        rawC(rawC(:,4)==113,4) = 1;
        rawC(rawC(:,4)==117,4) = 0;
        rawC(rawC(:,4)==105,4) = 0;
        rawC(rawC(:,4)==111,4) = 0;
        rawC(rawC(:,4)==112,4) = 0;
        for ii = 1:4 % y level
            yval = yD(ii);
            currentdata = rawC((rawC(:,1)==yval),:);
            hitrate(subjidx,jj,ii) = sum(currentdata(:,3) == 1 & currentdata(:,4)==1)/sum(currentdata(:,3) == 1);
            farate(subjidx,jj,ii)  = sum(currentdata(:,3) == 0 & currentdata(:,4)==1)/sum(currentdata(:,3) == 0);
        end
    end   
end
accuracy = (hitrate + 1-farate)./2;

width =  10;
height = 8;
greys = [0,0,0; 0.3,0.3,0.3; 0.5,0.5,0.5; 0.65,0.65,0.65];
width = 10;
height = 8;
figure;
hold on
for eccid = 1:4
    mean_accuracy = mean(squeeze(accuracy(:,:,eccid)));
    se_accuracy = std(squeeze(accuracy(:,:,eccid)))/sqrt(8);
    errorbar([1,2,3,4], mean_accuracy,se_accuracy,'Color',greys(eccid,:),'LineWidth',5);
end
% legend('','','','','Location','Best');
legend(strcat('\ity \rm=',num2str(yD)),'Location','Best');
legend BOXOFF
xlim([0.9,4.1])
ylim([0.5,1])
ylabel('Accuracy')
xlabel('Session #')
set(gca,'TickDir','out')
set(gca,'XTick',[1,2,3,4]);
set(gca,'box','off')
set(gca,'FontSize',32)
set(gcf,'InvertHardcopy','on');
set(gcf,'PaperUnits', 'inches');
papersize = get(gcf, 'PaperSize');
left = (papersize(1)- width)/2;
bottom = (papersize(2)- height)/2;
myfiguresize = [left, bottom, width, height];
set(gcf,'PaperPosition', myfiguresize);
% print('accuracy_offset','-dpng','-r300');

%%
width =  8;
height = 8;
figure;
heatmap(histmat,{'Fixed','Bayes','Lin'},{'Fixed','Bayes','Lin'},[],'Colormap', 'gray');
set(gca,'FontSize',28)
ylabel('Generating models','FontSize',32)
xlabel('Fitted models','FontSize',32)
axis square
hold on
for i = 1:3
    for j = 1:3
        if i==j
            text(i-0.16,j,num2str(histmat(i,j),'%0.2f'),'Color','black','FontSize',22);
        elseif histmat(i,j) ~= 0
            text(i-0.16,j,num2str(histmat(i,j),'%0.2f'),'Color','white','FontSize',22);
        end
    end
end
set(gcf,'InvertHardcopy','on');
set(gcf,'PaperUnits', 'inches');
papersize = get(gcf, 'PaperSize');
left = (papersize(1)- width)/2;
bottom = (papersize(2)- height)/2;
myfiguresize = [left, bottom, width, height];
set(gcf,'PaperPosition', myfiguresize);