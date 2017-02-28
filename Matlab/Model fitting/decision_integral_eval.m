function I = decision_integral_eval(yL,yR,ylevel,v,v_y,pc,yvals,npoints)

% yL = tempyL1;
% yR = tempyR1;
% ylevel = tempy1;
% v = exp(sigma2);
% v_y = v_dy;
% pc = 0.5;
% yvals = yD;

NumCnd = numel(v);
NumTrials = size(yL,1);
%npoints = 500;

yvals = reshape(yvals,[1,1,length(yvals)]);
v  = reshape(v,[1,1,length(v)]);
yL = reshape(yL,[1,1,1,length(yL)]);
yR = reshape(yR,[1,1,1,length(yR)]);

lb(1,1,:)  = yvals - 5.*sqrt(v_y+v);
ub(1,1,:)  = yvals + 5.*sqrt(v_y+v);

XL = zeros(npoints,1,NumCnd);
XR = zeros(1,npoints,NumCnd);
for ii = 1:NumCnd
    XL(:,1,ii) = linspace(lb(ii),ub(ii),npoints);
    XR(1,:,ii) = linspace(lb(ii),ub(ii),npoints);
end

RHS(1,1,:) = 0.5.*log(v.^2+2.*v.*v_y)-log(v+v_y)-log(pc/(1-pc));

C_hat_mat = bsxfun(@rdivide,bsxfun(@plus,(bsxfun(@minus,XL,yvals)).^2, (bsxfun(@minus,XR,yvals)).^2),2.*(v+v_y))...
    - bsxfun(@rdivide,bsxfun(@minus,XL,XR).^2,4.*v) - bsxfun(@rdivide,bsxfun(@minus,bsxfun(@plus,XL,XR)./2,yvals).^2,2.*((v./2)+v_y));



C_hat_mat = bsxfun(@ge,C_hat_mat,RHS);

I = NaN(NumTrials,1);
for ii = 1:NumCnd
    yindex = find(ylevel==yvals(ii));
    F = bsxfun(@times,bsxfun(@times,C_hat_mat(:,:,ii),bsxfun_normpdf(XL(:,1,ii),yL(1,1,1,yindex),sqrt(v(ii)))),...
        bsxfun_normpdf(XR(1,:,ii),yR(1,1,1,yindex),sqrt(v(ii))));
    I(yindex) = qtrapz(qtrapz(F,1),2)*(XL(2,1,ii)-XL(1,1,ii))*(XR(1,2,ii)-XR(1,1,ii));
end

