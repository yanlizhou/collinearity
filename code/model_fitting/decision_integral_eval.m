function I = decision_integral_eval(yL,yR,ylevel,v,v_y,pc,yvals,npoints,subv,dn_flag,dn)
if nargin < 9 || isempty(subv); subv = v; end
if nargin < 10 || isempty(dn_flag); dn_flag = 0; end
NumCnd = numel(v);
NumTrials = size(yL,1);
%npoints = 500;

yvals = reshape(yvals,[1,1,length(yvals)]);
subv  = reshape(subv,[1,1,length(subv)]);
yL = reshape(yL,[1,1,1,length(yL)]);
yR = reshape(yR,[1,1,1,length(yR)]);

scale  = 4;
v_dy   = (6*scale)^2;
lb(1,1,:)  = yvals - 5.*sqrt(v_dy+subv); %change it to real v_dy
ub(1,1,:)  = yvals + 5.*sqrt(v_dy+subv);

XL = zeros(npoints,1,NumCnd);
XR = zeros(1,npoints,NumCnd);
for ii = 1:NumCnd
    XL(:,1,ii) = linspace(lb(ii),ub(ii),npoints);
    XR(1,:,ii) = linspace(lb(ii),ub(ii),npoints);
end

RHS(1,1,:) = 0.5.*log(subv.^2+2.*subv.*v_y)-log(subv+v_y)-log(pc/(1-pc));

d = bsxfun(@rdivide,bsxfun(@plus,(bsxfun(@minus,XL,yvals)).^2, ...
    (bsxfun(@minus,XR,yvals)).^2),2.*(subv+v_y))...
    - bsxfun(@rdivide,bsxfun(@minus,XL,XR).^2,4.*subv) - bsxfun(@rdivide,...
    bsxfun(@minus,bsxfun(@plus,XL,XR)./2,yvals).^2,2.*((subv./2)+v_y));

d = bsxfun(@minus,d,RHS);

if dn_flag
    C_hat_mat = normcdf(d./(sqrt(dn)));  
%     normcdf(d,0,sqrt((dn));

else
    C_hat_mat = d >= 0 ;
end



I = NaN(NumTrials,1);
for ii = 1:NumCnd
    yindex = find(ylevel==yvals(ii));    
    F = bsxfun(@times,bsxfun(@times,C_hat_mat(:,:,ii),bsxfun_normpdf(...
        XL(:,1,ii),yL(1,1,1,yindex),sqrt(v(ii)))),...
        bsxfun_normpdf(XR(1,:,ii),yR(1,1,1,yindex),sqrt(v(ii))));
    I(yindex) = qtrapz(qtrapz(F,1),2)*(XL(2,1,ii)-XL(1,1,ii))*...
        (XR(1,2,ii)-XR(1,1,ii));
end

