function loglike = loglikelihood(theta,data,v_dy,model,task,form,summingflag,subjid,npoints)
if nargin < 7 || isempty(summingflag); summingflag  = 1; end
if nargin < 8 || isempty(subjid); subjid = -1; end
if nargin < 9 || isempty(npoints); npoints = 500; end

yvec  = data(:,1);
dyvec = data(:,2);
yLvec = data(:,6);
yRvec = data(:,7);
resp  = data(:,4);
resp(resp==-1) = 0; % -1: left higher
yvals  = unique(yvec);

sigma2 = NaN(4,1);

persistent bigmat;
if isempty(bigmat)
    bigmat = cell(1,2);
    newbigmat = 1;
else
    newbigmat = 0;
end
if newbigmat
    bigmat{1}(:,1) = yvec(resp == 1);
    bigmat{2}(:,1) = yvec(resp == 0);
    bigmat{1}(:,2) = yLvec(resp == 1);
    bigmat{2}(:,2) = yLvec(resp == 0);
    bigmat{1}(:,3) = yRvec(resp == 1);
    bigmat{2}(:,3) = yRvec(resp == 0);
    bigmat{1}(:,4) = dyvec(resp == 1);
    bigmat{2}(:,4) = dyvec(resp == 0);
end

tempy1   = bigmat{1}(:,1);
tempy2   = bigmat{2}(:,1);
tempyL1  = bigmat{1}(:,2);
tempyL2  = bigmat{2}(:,2);
tempyR1  = bigmat{1}(:,3);
tempyR2  = bigmat{2}(:,3);
tempdy1  = bigmat{1}(:,4);
tempdy2  = bigmat{2}(:,4);

if strcmpi(task,'C') || strcmpi(task,'J')
    switch form
        case 'parametric'
            if strcmpi(model,'free')
                sigma2(1) = exp(theta(1));
                sigma2(2) = exp(theta(2));
                sigma2(3) = exp(theta(3));
                sigma2(4) = exp(theta(4));
            else
                sigma2(1) = exp(theta(1));
                sigma2(3) = exp(theta(2));
                sigma2(4) = exp(theta(3));
                parabola = [yvals(3)^2,yvals(3);yvals(4)^2,yvals(4)]\...
                    [sigma2(3)-sigma2(1);sigma2(4)-sigma2(1)];
                parabola = [parabola;sigma2(1)];
                sigma2(2) = parabola(1)*(yvals(2)^2)+parabola(2)*yvals(2)+parabola(3);
                sigma2(2) = min(max(1,sigma2(2)),1500);
            end
        case 'nonparametric'
            sigma2(1) = exp(theta(1));
            sigma2(2) = exp(theta(2));
            sigma2(3) = exp(theta(3));
            sigma2(4) = exp(theta(4));
        case 'cross'
            load theta_est_D;
            sigma2 = exp(theta_est_D(1:4,subjid));
    end
    tempvy1 = NaN(size(tempy1));
    tempvy2 = NaN(size(tempy2));
    for ii = 1:length(yvals)
        tempvy1(tempy1==yvals(ii)) = sigma2(ii);
        tempvy2(tempy2==yvals(ii)) = sigma2(ii);
    end
    switch model
        case 'simplebaye'
            criterion1 = sqrt(2.*tempvy1).*sqrt(log((v_dy./tempvy1)+1).*(1+(tempvy1./v_dy)));
            criterion2 = sqrt(2.*tempvy2).*sqrt(log((v_dy./tempvy2)+1).*(1+(tempvy2./v_dy)));
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
            
            criterion1 = k_1.*tempy1+k_0;
            criterion2 = k_1.*tempy2+k_0;
            
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
            criterion1 = 2*sqrt(tempvy1./v_dy).*sqrt((tempvy1+v_dy).*(log(p_common/(1-p_common))+(log((v_dy./tempvy1)+1)/2)));
            criterion2 = 2*sqrt(tempvy2./v_dy).*sqrt((tempvy2+v_dy).*(log(p_common/(1-p_common))+(log((v_dy./tempvy2)+1)/2)));
            criterion1(criterion1 ~= real(criterion1)) = 0;
            criterion2(criterion2 ~= real(criterion2)) = 0;
            
        case 'free'
            criterion1 = NaN(size(tempy1));
            criterion2 = NaN(size(tempy2));
            switch form
                case 'nonparametric'
                    for ii = 1:length(yvals)
                        criterion1(tempy1==yvals(ii)) = theta(ii+4);
                        criterion2(tempy2==yvals(ii)) = theta(ii+4);
                    end
                    lapserate = theta(9);
                case 'cross'
                    for ii = 1:length(yvals)
                        criterion1(tempy1==yvals(ii)) = theta(ii);
                        criterion2(tempy2==yvals(ii)) = theta(ii);
                    end
                    lapserate = theta(5);
            end
            
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
            criterion1 = k_1.*tempvy1+k_0;
            criterion2 = k_1.*tempvy2+k_0;
            
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
            sub_vy1 = a1.*tempy1+a0;
            sub_vy2 = a1.*tempy2+a0;    
            criterion1 = sqrt(2.*sub_vy1).*sqrt(log((v_dy./sub_vy1)+1).*(1+(sub_vy1./v_dy)));
            criterion2 = sqrt(2.*sub_vy2).*sqrt(log((v_dy./sub_vy2)+1).*(1+(sub_vy2./v_dy)));
            criterion1(criterion1 ~= real(criterion1)) = 0;
            criterion2(criterion2 ~= real(criterion2)) = 0;
            
    end
    if strcmpi(model,'baye2')
        temp1 = decision_integral_eval(tempyL1,tempyR1,tempy1,sigma2,v_dy,p_common,yvals,npoints);
        temp2 = 1 - decision_integral_eval(tempyL2,tempyR2,tempy2,sigma2,v_dy,p_common,yvals,npoints);
    else
        criterion1 = max(criterion1,0);
        criterion2 = max(criterion2,0);
        temp1= 0.5.*(erf((criterion1-tempdy1)./(2.*sqrt(tempvy1)))-erf((-criterion1-tempdy1)./(2*sqrt(tempvy1))));
        temp2= 1-(0.5.*(erf((criterion2-tempdy2)./(2.*sqrt(tempvy2)))-erf((-criterion2-tempdy2)./(2*sqrt(tempvy2)))));
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

if strcmpi(task,'D') || strcmpi(task,'J')
    tempvy1 = NaN(size(tempy1));
    tempvy2 = NaN(size(tempy2));
    switch form
        case 'nonparametric'
            for ii = 1:length(yvals)
                tempvy1(tempy1==yvals(ii)) = exp(theta(ii));
                tempvy2(tempy2==yvals(ii)) = exp(theta(ii));
                if strcmpi(task,'D')
                    lapserate = theta(5);
                end
            end
        case 'parametric'
            sigma2(1,1) = exp(theta(1));
            sigma2(2,1) = NaN;
            sigma2(3,1) = exp(theta(2));
            sigma2(4,1) = exp(theta(3));
            parabola = [yvals(3)^2,yvals(3);yvals(4)^2,yvals(4)]\...
                [sigma2(3)-sigma2(1);sigma2(4)-sigma2(1)];
            parabola = [parabola;sigma2(1)];
            sigma2(2,1) = parabola(1)*(yvals(2)^2)+parabola(2)*yvals(2)+parabola(3);
            sigma2(2,1) = min(max(1,sigma2(2,1)),1500);
            for ii = 1:length(yvals)
                tempvy1(tempy1==yvals(ii)) = sigma2(ii);
                tempvy2(tempy2==yvals(ii)) = sigma2(ii);
            end
            if strcmpi(task,'D')
                lapserate = theta(4);
            end
    end
    temp1= 0.5*(1+erf(-tempdy1./(2.*sqrt(tempvy1))));
    temp2= 1-(0.5*(1+erf(-tempdy2./(2.*sqrt(tempvy2)))));
    temp1=log((1-lapserate)*temp1+lapserate/2);
    temp2=log((1-lapserate)*temp2+lapserate/2);
    loglikeD = sum(temp1)+sum(temp2);
    if strcmpi(task,'D')
        loglike = loglikeD;
    end
end

if strcmpi(task,'J')
    loglike = loglikeC+loglikeD;
end

end





