function data = generatefakedata(theta,v_dy,model,task,lapse,form,displayflag,nTrialsC,nTrialsD,subjid)
if nargin < 7 || isempty(displayflag); displayflag = 0; end
if nargin < 8 || isempty(nTrialsC); nTrialsC  = 2400; end
if nargin < 9 || isempty(nTrialsD); nTrialsD  = 960; end
if nargin < 10 || isempty(subjid); subjid  = 1; end

p_common  = theta(5);
k         = theta(6);
k_1       = theta(7);
k_0       = theta(8);
lapserate = theta(13);

scale     = 4;
yD        = [0; 60; 120; 210].*scale;

% Vertical positions
if strcmpi(task,'C')
    nTrials = nTrialsC;
else
    nTrials = nTrialsD;
end
temp = ones(nTrials/length(yD),1);
yVec = kron(yD,temp);
% Vertical offset
yleft      = NaN(nTrials,1);
yright     = NaN(nTrials,1);
dyVec      = NaN(nTrials,1);
for ii = 1:nTrials
    yval = yVec(ii);
    if strcmpi(task,'C')
        if mod(ii,2) == 0
            yleft(ii)  = sqrt(v_dy).*randn(1)+yval;
            yright(ii) = yleft(ii);
        elseif mod(ii+1,4)==0
            yleft(ii)  = sqrt(v_dy).*randn(1)+yval;
            yright(ii) = sqrt(v_dy).*randn(1)+yval;
            if yright(ii) < yleft(ii)
                temp = yright(ii);
                yright(ii) = yleft(ii);
                yleft(ii) = temp;
            end
        else
            yleft(ii)  = sqrt(v_dy).*randn(1)+yval;
            yright(ii) = sqrt(v_dy).*randn(1)+yval;
            if yright(ii) > yleft(ii)
                temp = yright(ii);
                yright(ii) = yleft(ii);
                yleft(ii) = temp;
            end
        end
    else
        if mod(ii,2) == 0
            yleft(ii)  = sqrt(v_dy).*randn(1)+yval;
            yright(ii) = sqrt(v_dy).*randn(1)+yval;
            if yright(ii) < yleft(ii)
                temp = yright(ii);
                yright(ii) = yleft(ii);
                yleft(ii) = temp;
            end
        else
            yleft(ii)  = sqrt(v_dy).*randn(1)+yval;
            yright(ii) = sqrt(v_dy).*randn(1)+yval;
            if yright(ii) > yleft(ii)
                temp = yright(ii);
                yright(ii) = yleft(ii);
                yleft(ii) = temp;
            end
        end
    end
    yright(ii) = round(yright(ii));
    yleft(ii)  = round(yleft(ii));
    dyVec(ii)  = yleft(ii)-yright(ii);
end

% Measurements

v_y = NaN(size(yVec));
switch form
    case 'parametric'
        if strcmpi(model,'free')
            for ii = 1:4
                v_y(yVec == yD(ii)) = exp(theta(ii));
            end
        else
            sigma = NaN(4,1);
            sigma(1) = exp(theta(1));
            sigma(3) = exp(theta(2));
            sigma(4) = exp(theta(3));
            tempo = [yD(3)^2,yD(3);yD(4)^2,yD(4)]\[sigma(3)-sigma(1);sigma(4)-sigma(1)];
            sigma(2) = tempo(1)*yD(2)^2+tempo(2)*yD(2)+sigma(1);
            for ii = 1:4
                v_y(yVec == yD(ii)) = sigma(ii);
            end
        end
    case 'nonparametric'
        for ii = 1:4
            v_y(yVec == yD(ii)) = exp(theta(ii));
        end
    case 'cross'
        load('data_and_analysis.mat', 'theta_est_D');
        for ii = 1:4
            v_y(yVec == yD(ii)) = exp(theta_est_D(ii,subjid));
        end
end
dx = sqrt(2*v_y).*randn(nTrials,1) + dyVec;
xl = sqrt(v_y).*randn(nTrials,1) + yleft;
xr = sqrt(v_y).*randn(nTrials,1) + yright;

switch model
    case 'simplebaye'
        switch task
            case 'C'
                criterion = 2*sqrt(v_y./v_dy).*sqrt((v_y+v_dy).*log((v_dy./v_y)+1)/2);
                C_hat = abs(dx)<criterion;
            case 'D'
                
                switch lapse
                    case 'off'
                        C_hat = dx<0; % 1 = dx<0 0 = dx>0
                    case 'on'
                        lap = rand(nTrialsD,1)<lapserate;
                        C_hat = (lap==1).*round(rand(nTrialsD,1)) + (lap==0).*(dx<0);
                end
        end
        
    case 'baye'
        
        %case 'C' %catagorization task%
        criterion = 2*sqrt(v_y./v_dy).*sqrt((v_y+v_dy).*(log(p_common/(1-p_common))+log((v_dy./v_y)+1)/2));
        C_hat = abs(dx)<criterion;
        
    case'threshold'
        C_hat = abs(dx)<k;
        
    case 'linear'
        C_hat = abs(dx)<(k_1.*yVec+k_0);
    case 'free'
        dbound = NaN(size(yVec));
        
        for ii = 1:length(yD)
            dbound(yVec == yD(ii)) = theta(ii+8);
        end
        C_hat = abs(dx)<dbound;
    case 'linear2'
        C_hat = abs(dx)<(k_1.*v_y+k_0);
    
    case 'linear3'
        C_hat = abs(dx)<(k_1.*sqrt(v_y)+k_0);
        
    case 'baye2'
        RHS = 0.5.*log(v_y.^2+2.*v_y.*v_dy)-log(v_y+v_dy)-log(p_common/(1-p_common));
        C_hat = ((-(xl+xr-2.*yVec).^2)./(4.*(2*v_dy+v_y)))-(((xl-xr).^2)./(4.*v_y))...
            + ((xl-yVec).^2+(xr-yVec).^2)./(2.*(v_y+v_dy)) >= RHS;
end

% Adding lapse trials
if strcmpi(task,'C')
    if strcmpi(lapse,'on')
        lap = rand(nTrials,1) < lapserate;
        nLapses = sum(lap == 1);
        C_hat(lap == 1) = round(rand(nLapses,1));
    end
    C = dyVec == 0;
else
    C = dyVec < 0;
end

placeholder = NaN(size(yVec));
data = [yVec dyVec C C_hat placeholder yleft yright];

% C Graph prep

if task~='D' && displayflag
    
    nbins = 9;
    [label,prop_report_aligned,~] = bindata(yVec,dyVec,C_hat,v_dy,nbins);
    figure;
    hold on
    newDefaultColors = winter(4);
    set(gca, 'ColorOrder', newDefaultColors, 'NextPlot', 'replacechildren');
    
    %for ii = 1:4
    %errorbar(label, prop_report_aligned(ii,:), se_aligned(ii,:));
    plot(label, prop_report_aligned,'LineWidth',2);
    %end
    ylim([0 1]);
    legend(strcat('y=',num2str(yD)),'Location','Best')
    xlabel('Disparity (pixels)')
    ylabel('Percetage of reporting aligned')
    ylim([0 1]);
    %xlim([label(1)-10 label(end)+10]);
end
