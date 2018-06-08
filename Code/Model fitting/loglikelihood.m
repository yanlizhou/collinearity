function loglike = loglikelihood(theta,data,dataD,v_dy,model,task,form,summingflag,subjid,npoints)
if nargin < 8 || isempty(summingflag); summingflag  = 1; end
if nargin < 9 || isempty(subjid); subjid = -1; end
if nargin < 10 || isempty(npoints); npoints = 300; end
%%
% data = newsubjdataC{6};
% theta = temp_theta;
% model = 'linbaye_f2';
% task = 'C';
% form = 'nonparametric';
% summingflag = 1;
% subjid = 3;
% npoints = 300;

%% -----------------------------Reading Data-------------------------------
yvec  = data(:,1);                                % Eccentricity level
dyvec = data(:,2);                                % Physical offset
yLvec = data(:,6);                                % Left y coordinate
yRvec = data(:,7);                                % Right y coordinate
resp  = data(:,4);                                % Subject's response
resp(resp==-1) = 0;                               % -1: left higher
yvals  = unique(yvec);                            % Get 4 unique y values

% Categorize by response + Create persistent variable
persistent alldata;

if isempty(alldata)
    alldata = cell(1,3);
    newmat = 1;
else
    newmat = 0;
end

if newmat
    alldata{1}(:,1) = yvec(resp == 1);
    alldata{2}(:,1) = yvec(resp == 0);
    alldata{1}(:,2) = yLvec(resp == 1);
    alldata{2}(:,2) = yLvec(resp == 0);
    alldata{1}(:,3) = yRvec(resp == 1);
    alldata{2}(:,3) = yRvec(resp == 0);
    alldata{1}(:,4) = dyvec(resp == 1);
    alldata{2}(:,4) = dyvec(resp == 0);
    alldata{3}(:,1) = yvec;
    alldata{3}(:,2) = resp;
end
ally    = alldata{3}(:,1);
allresp = alldata{3}(:,2);
y1   = alldata{1}(:,1);
y2   = alldata{2}(:,1);
yL1  = alldata{1}(:,2);
yL2  = alldata{2}(:,2);
yR1  = alldata{1}(:,3);
yR2  = alldata{2}(:,3);
dy1  = alldata{1}(:,4);
dy2  = alldata{2}(:,4);

%% ----------------------------Categorization------------------------------

% 1. Define noise parameters (var not std)
sigma2 = NaN(4,1);

if strcmpi(task,'C') || strcmpi(task,'J')
    switch form
        case 'parametric'
            
            sigma2(1) = exp(theta(1));
            sigma2(3) = exp(theta(2));
            sigma2(4) = exp(theta(3));
            parabola = [yvals(3)^2,yvals(3);yvals(4)^2,yvals(4)]\...
                [sigma2(3)-sigma2(1);sigma2(4)-sigma2(1)];
            parabola = [parabola;sigma2(1)];
            sigma2(2) = parabola(1)*(yvals(2)^2)+parabola(2)*yvals(2)+...
                parabola(3);
            sigma2(2) = min(max(1,sigma2(2)),1500);
        case 'nonparametric'
            sigma2(1) = exp(theta(1));
            sigma2(2) = exp(theta(2));
            sigma2(3) = exp(theta(3));
            sigma2(4) = exp(theta(4));
        case 'cross'
            load('data_and_analysis.mat', 'theta_est_D');
            sigma2 = exp(theta_est_D(1:4,subjid));
    end
    
    v1 = NaN(size(y1));
    v2 = NaN(size(y2));
    for ii = 1:length(yvals)
        v1(y1==yvals(ii)) = sigma2(ii);
        v2(y2==yvals(ii)) = sigma2(ii);
    end
    
    % 2. Decision boundaries
    
    switch model
        % Simplified Bayesian model with pcommon fixed at 0.5
        case 'simplebaye'
            criterion1 = sqrt(2.*v1).*sqrt(log((v_dy./v1)+1).*...
                (1+(v1./v_dy)));
            criterion2 = sqrt(2.*v2).*sqrt(log((v_dy./v2)+1).*...
                (1+(v2./v_dy)));
            criterion1(criterion1 ~= real(criterion1)) = 0;
            criterion2(criterion2 ~= real(criterion2)) = 0;
            switch form
                case 'parametric'
                    lapserate = theta(4);
                case 'nonparametric'
                    lapserate = theta(5);
                case 'cross'
                    lapserate = theta(1);
            end
            
            % Fixed criterion model with constant decision boundary k
        case 'threshold'
            switch form
                case 'parametric'
                    k = theta(4);
                    lapserate = theta(5);
                case 'nonparametric'
                    k = theta(5);
                    lapserate = theta(6);
                case 'cross'
                    k = theta(1);
                    lapserate = theta(2);
            end
            criterion1 = k;
            criterion2 = k;
            
            % Heuristic model with decision boundary a linear function of y
        case 'linear'
            switch form
                case 'parametric'
                    k_1   = theta(4);
                    k_0   = theta(5);
                    lapserate = theta(6);
                case 'nonparametric'
                    k_1   = theta(5);
                    k_0   = theta(6);
                    lapserate = theta(7);
                case 'cross'
                    k_1   = theta(1);
                    k_0   = theta(2);
                    lapserate = theta(3);
            end
            criterion1 = k_1.*y1+k_0;
            criterion2 = k_1.*y2+k_0;
            
            % Simplified Bayesian model with pcommon a free parameter
        case 'baye'
            switch form
                case 'parametric'
                    p_common=theta(4);
                    lapserate = theta(5);
                case 'nonparametric'
                    p_common=theta(5);
                    lapserate = theta(6);
                case 'cross'
                    p_common=theta(1);
                    lapserate = theta(2);
            end
            criterion1 = 2*sqrt(v1./v_dy).*sqrt((v1+v_dy).*...
                (log(p_common/(1-p_common))+(log((v_dy./v1)+1)/2)));
            criterion2 = 2*sqrt(v2./v_dy).*sqrt((v2+v_dy).*...
                (log(p_common/(1-p_common))+(log((v_dy./v2)+1)/2)));
            criterion1(criterion1 ~= real(criterion1)) = 0;
            criterion2(criterion2 ~= real(criterion2)) = 0;
            
            % Nonparametric model
        case 'free'
            criterion1 = NaN(size(y1));
            criterion2 = NaN(size(y2));
            switch form
                case 'nonparametric'
                    for ii = 1:length(yvals)
                        criterion1(y1==yvals(ii)) = theta(ii+4);
                        criterion2(y2==yvals(ii)) = theta(ii+4);
                    end
                    lapserate = theta(9);
                case 'cross'
                    for ii = 1:length(yvals)
                        criterion1(y1==yvals(ii)) = theta(ii);
                        criterion2(y2==yvals(ii)) = theta(ii);
                    end
                    lapserate = theta(5);
            end
            
            % Heuristic model with decision boundary a linear function of noise
        case 'linear2'
            switch form
                case 'parametric'
                    k_1   = theta(4);
                    k_0   = theta(5);
                    lapserate = theta(6);
                    
                case 'nonparametric'
                    k_1   = theta(5);
                    k_0   = theta(6);
                    lapserate = theta(7);
                    
                case 'cross'
                    k_1   = theta(1);
                    k_0   = theta(2);
                    lapserate = theta(3);
            end
            criterion1 = k_1.*v1+k_0;
            criterion2 = k_1.*v2+k_0;
            
        case 'linear3'
            switch form
                case 'parametric'
                    k_1   = theta(4);
                    k_0   = theta(5);
                    lapserate = theta(6);
                    
                case 'nonparametric'
                    k_1   = theta(5);
                    k_0   = theta(6);
                    lapserate = theta(7);
                    
                case 'cross'
                    k_1   = theta(1);
                    k_0   = theta(2);
                    lapserate = theta(3);
            end
            criterion1 = k_1.*sqrt(v1)+k_0;
            criterion2 = k_1.*sqrt(v2)+k_0;
            
            % Fully Bayesian model
        case 'baye2'
            switch form
                case 'parametric'
                    p_common=theta(4);
                    lapserate = theta(5);
                case 'nonparametric'
                    p_common=theta(5);
                    lapserate = theta(6);
                case 'cross'
                    p_common=theta(1);
                    lapserate = theta(2);
            end
            
            % Simplified Bayesian model with linear subjective noise (free pcommon)
        case 'linbaye_pc'
            switch form
                case 'parametric'
                    a1 = theta(4);
                    a0 = theta(5);
                    p_common = theta(6);
                    lapserate = theta(7);
                case 'nonparametric'
                    a1 = theta(5);
                    a0 = theta(6);
                    p_common = theta(7);
                    lapserate = theta(8);
                case 'cross'
                    a1 = theta(1);
                    a0 = theta(2);
                    p_common = theta(3);
                    lapserate = theta(4);
            end
            subv1 = a1.*y1+a0;
            subv2 = a2.*y2+a0;
            criterion1 = 2*sqrt(subv1./v_dy).*sqrt((subv1+v_dy).*...
                (log(p_common/(1-p_common))+(log((v_dy./subv1)+1)/2)));
            criterion2 = 2*sqrt(subv2./v_dy).*sqrt((subv2+v_dy).*...
                (log(p_common/(1-p_common))+(log((v_dy./subv2)+1)/2)));
            criterion1(criterion1 ~= real(criterion1)) = 0;
            criterion2(criterion2 ~= real(criterion2)) = 0;
            
            % Simplified Bayesian model with linear subjective noise (pcommon = 0.5)
        case 'linbaye'
            switch form
                case 'parametric'
                    a1 = theta(4);
                    a0 = theta(5);
                    lapserate = theta(6);
                case 'nonparametric'
                    a1 = theta(5);
                    a0 = theta(6);
                    lapserate = theta(7);
                case 'cross'
                    a1 = theta(1);
                    a0 = theta(2);
                    lapserate = theta(3);
            end
            subv1 = a1.*y1+a0;
            subv2 = a1.*y2+a0;
            criterion1 = 2*sqrt(subv1./v_dy).*sqrt((subv1+v_dy).*...
                (log((v_dy./subv1)+1)/2));
            criterion2 = 2*sqrt(subv2./v_dy).*sqrt((subv2+v_dy).*...
                (log((v_dy./subv2)+1)/2));
            criterion1(criterion1 ~= real(criterion1)) = 0;
            criterion2(criterion2 ~= real(criterion2)) = 0;
            
            % Bayesian model with subjective noise parameters (free pcommon)
        case 'freebaye_pc'
            switch form
                case 'nonparametric'
                    subjnoise(1) = exp(theta(5));
                    subjnoise(2) = exp(theta(6));
                    subjnoise(3) = exp(theta(7));
                    subjnoise(4) = exp(theta(8));
                    p_common = theta(9);
                    lapserate = theta(10);
            end
            % Bayesian model with subjective noise parameters (pcommon = 0.5)
        case 'freebaye'
            switch form
                case 'nonparametric'
                    subjnoise(1) = exp(theta(5));
                    subjnoise(2) = exp(theta(6));
                    subjnoise(3) = exp(theta(7));
                    subjnoise(4) = exp(theta(8));
                    lapserate = theta(9);
            end
            
            % Linear model with trial dependence (up to 4)
        case 'lintrial'
            
            switch form
                case 'parametric'
                    k_1   = theta(4);
                    k_0   = theta(5);
                    k_2   = theta(6);
                    k_3   = theta(7);
                    k_4   = theta(8);
                    k_5   = theta(9);
                    lapserate = theta(10);
                case 'nonparametric'
                    k_1   = theta(5);
                    k_0   = theta(6);
                    k_2   = theta(7);
                    k_3   = theta(8);
                    k_4   = theta(9);
                    k_5   = theta(10);
                    lapserate = theta(11);
                case 'cross'
                    k_1   = theta(1);
                    k_0   = theta(2);
                    k_2   = theta(3);
                    k_3   = theta(4);
                    k_4   = theta(5);
                    k_5   = theta(6);
                    lapserate = theta(7);
            end
            ally = [0;0;0;0;ally];
            criterion = k_1.*ally(5:end)+k_2.*ally(4:end-1)+k_3.*ally(3:end-2)...
                +k_4.*ally(2:end-3)+k_5.*ally(1:end-4)+k_0;
            criterion1 = criterion(allresp == 1);
            criterion2 = criterion(allresp == 0);
            
        case 'lintrial2'
            
            switch form
                case 'parametric'
                    k_1   = theta(4);
                    k_0   = theta(5);
                    k_2   = theta(6);
                    k_3   = theta(7);
                    k_4   = theta(8);
                    k_5   = theta(9);
                    lapserate = theta(10);
                case 'nonparametric'
                    k_1   = theta(5);
                    k_0   = theta(6);
                    k_2   = theta(7);
                    k_3   = theta(8);
                    k_4   = theta(9);
                    k_5   = theta(10);
                    lapserate = theta(11);
                case 'cross'
                    k_1   = theta(1);
                    k_0   = theta(2);
                    k_2   = theta(3);
                    k_3   = theta(4);
                    k_4   = theta(5);
                    k_5   = theta(6);
                    lapserate = theta(7);
            end
            
            allsigma = NaN(size(ally));
            for ii = 1:length(yvals)
                allsigma(ally==yvals(ii)) = sqrt(sigma2(ii));
            end
            allsigma = [0;0;0;0;allsigma];
            criterion = k_1.*allsigma(5:end)+k_2.*allsigma(4:end-1)+k_3.*allsigma(3:end-2)...
                +k_4.*allsigma(2:end-3)+k_5.*allsigma(1:end-4)+k_0;
            criterion1 = criterion(allresp == 1);
            criterion2 = criterion(allresp == 0);
            
        case 'rbm_baye'
            lapserate   = theta(5);
        case 'linbaye_f'
            switch form
                case 'parametric'
                    subvmin = exp(theta(4));
                    subvmax = exp(theta(5));
                    lapserate = theta(6);
                case 'nonparametric'
                    subvmin = exp(theta(5));
                    subvmax = exp(theta(6));
                    lapserate = theta(7);
                case 'cross'
                    subvmin = exp(theta(1));
                    subvmax = exp(theta(2));
                    lapserate = theta(3);
            end
            a1 = (subvmax-subvmin)/(max(sigma2)-min(sigma2));
            a0 = subvmin-a1*min(sigma2);
            subjnoise = a1.*sigma2+a0;
        case 'linbaye_f2'
            switch form
                case 'parametric'
                    subsdmin = sqrt(exp(theta(4)));
                    subsdmax = sqrt(exp(theta(5)));
                    lapserate = theta(6);
                case 'nonparametric'
                    subsdmin = sqrt(exp(theta(5)));
                    subsdmax = sqrt(exp(theta(6)));
                    lapserate = theta(7);
                case 'cross'
                    subsdmin = sqrt(exp(theta(1)));
                    subsdmax = sqrt(exp(theta(2)));
                    lapserate = theta(3);
            end
            a1 = (subsdmax-subsdmin)/(max(sqrt(sigma2))-min(sqrt(sigma2)));
            a0 = subsdmin-a1*min(sqrt(sigma2));
            subjnoise = (a1.*sqrt(sigma2)+a0).^2;
    end
    
    
    if strcmpi(model,'baye2')
        temp1 = decision_integral_eval(yL1,yR1,y1,sigma2,v_dy,p_common,yvals,npoints);
        temp2 = 1 - decision_integral_eval(yL2,yR2,y2,sigma2,v_dy,p_common,yvals,npoints);
    elseif strcmpi(model,'rbm_baye')
        temp1 = decision_integral_eval(yL1,yR1,y1,sigma2,v_dy,0.5,yvals,npoints);
        temp2 = 1 - decision_integral_eval(yL2,yR2,y2,sigma2,v_dy,0.5,yvals,npoints);
    elseif strcmpi(model,'freebaye_pc')
        temp1 = decision_integral_eval(yL1,yR1,y1,sigma2,v_dy,p_common,yvals,npoints,subjnoise);
        temp2 = 1 - decision_integral_eval(yL2,yR2,y2,sigma2,v_dy,p_common,yvals,npoints,subjnoise);
    elseif strcmpi(model,'freebaye')
        temp1 = decision_integral_eval(yL1,yR1,y1,sigma2,v_dy,0.5,yvals,npoints,subjnoise);
        temp2 = 1 - decision_integral_eval(yL2,yR2,y2,sigma2,v_dy,0.5,yvals,npoints,subjnoise);
    elseif strcmpi(model,'linbaye_f')
        temp1 = decision_integral_eval(yL1,yR1,y1,sigma2,v_dy,0.5,yvals,npoints,subjnoise);
        temp2 = 1 - min(decision_integral_eval(yL2,yR2,y2,sigma2,v_dy,0.5,yvals,npoints,subjnoise),1);
    elseif strcmpi(model,'linbaye_f2')
        temp1 = decision_integral_eval(yL1,yR1,y1,sigma2,v_dy,0.5,yvals,npoints,subjnoise);
        temp2 = 1 - min(decision_integral_eval(yL2,yR2,y2,sigma2,v_dy,0.5,yvals,npoints,subjnoise),1);
    else
        criterion1 = max(criterion1,0);
        criterion2 = max(criterion2,0);
        temp1= 0.5.*(erf((criterion1-dy1)./(2.*sqrt(v1)))-erf((-criterion1-dy1)./(2*sqrt(v1))));
        temp2= 1-(0.5.*(erf((criterion2-dy2)./(2.*sqrt(v2)))-erf((-criterion2-dy2)./(2*sqrt(v2)))));
    end
    
    
    temp1 = log((1-lapserate)*temp1+lapserate/2);
    temp2 = log((1-lapserate)*temp2+lapserate/2);
    
    
    if summingflag == 0
        loglikeC = [temp1;temp2]';
    else
        loglikeC = sum(temp1)+ sum(temp2);
    end
    
    if strcmpi(task,'C')
        loglike = loglikeC;
    end
end
%% ----------------------------Discrimination------------------------------
if strcmpi(task,'D') || strcmpi(task,'J')
    yvecD  = dataD(:,1);                                % Eccentricity level
    dyvecD = dataD(:,2);                                % Physical offset
    yLvecD = dataD(:,6);                                % Left y coordinate
    yRvecD = dataD(:,7);                                % Right y coordinate
    respD  = dataD(:,4);                                % Subject's response
    respD(respD==-1) = 0;                               % -1: left higher
    yvalsD  = unique(yvecD);                            % Get 4 unique y values
    
    % Categorize by response + Create persistent variable
    persistent alldataD;
    
    if isempty(alldataD)
        alldataD = cell(1,3);
        newmat = 1;
    else
        newmat = 0;
    end
    
    if newmat
        alldataD{1}(:,1) = yvecD(respD == 1);
        alldataD{2}(:,1) = yvecD(respD == 0);
        alldataD{1}(:,2) = yLvecD(respD == 1);
        alldataD{2}(:,2) = yLvecD(respD == 0);
        alldataD{1}(:,3) = yRvecD(respD == 1);
        alldataD{2}(:,3) = yRvecD(respD == 0);
        alldataD{1}(:,4) = dyvecD(respD == 1);
        alldataD{2}(:,4) = dyvecD(respD == 0);
        alldataD{3}(:,1) = yvecD;
        alldataD{3}(:,2) = respD;
    end
    y1D   = alldataD{1}(:,1);
    y2D   = alldataD{2}(:,1);
    dy1D  = alldataD{1}(:,4);
    dy2D  = alldataD{2}(:,4);
    
    if strcmpi(task,'D') || strcmpi(task,'J')
        v1D = NaN(size(y1D));
        v2D = NaN(size(y2D));
        switch form
            case 'nonparametric'
                for ii = 1:length(yvals)
                    v1D(y1D==yvalsD(ii)) = exp(theta(ii));
                    v2D(y2D==yvalsD(ii)) = exp(theta(ii));
                    if strcmpi(task,'D')
                        lapserate = theta(5);
                    end
                end
            case 'parametric'
                sigma2D(1,1) = exp(theta(1));
                sigma2D(2,1) = NaN;
                sigma2D(3,1) = exp(theta(2));
                sigma2D(4,1) = exp(theta(3));
                parabola = [yvalsD(3)^2,yvalsD(3);yvalsD(4)^2,yvalsD(4)]\...
                    [sigma2D(3)-sigma2D(1);sigma2D(4)-sigma2D(1)];
                parabola = [parabola;sigma2D(1)];
                sigma2D(2,1) = parabola(1)*(yvalsD(2)^2)+parabola(2)*yvalsD(2)+parabola(3);
                sigma2D(2,1) = min(max(1,sigma2D(2,1)),1500);
                for ii = 1:length(yvalsD)
                    v1D(y1D==yvalsD(ii)) = sigma2D(ii);
                    v2D(y2D==yvalsD(ii)) = sigma2D(ii);
                end
                if strcmpi(task,'D')
                    lapserate = theta(4);
                end
        end
        temp1D= 0.5*(1+erf(-dy1D./(2.*sqrt(v1D))));
        temp2D= 1-(0.5*(1+erf(-dy2D./(2.*sqrt(v2D)))));
        temp1D=log((1-lapserate)*temp1D+lapserate/2);
        temp2D=log((1-lapserate)*temp2D+lapserate/2);
        loglikeD = sum(temp1D)+sum(temp2D);
        if strcmpi(task,'D')
            loglike = loglikeD;
        end
    end
end
if strcmpi(task,'J')
    loglike = loglikeC+loglikeD;
end

end