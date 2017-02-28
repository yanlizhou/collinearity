function theta = feedtheta(thetaorg,model,form)

%     case 'simplebaye'
%         theta = [thetaorg(1:2),NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,thetaorg(3)];
%     case 'threshold'
%         theta = [thetaorg(1:2),NaN,thetaorg(3),NaN,NaN,NaN,NaN,NaN,NaN,thetaorg(4)];
%     case 'linear'
%         theta = [thetaorg(1:2),NaN,NaN,thetaorg(3),thetaorg(4),NaN,NaN,NaN,NaN,thetaorg(5)];
%     case 'baye'
%         theta = [thetaorg(1:3),NaN,NaN,NaN,NaN,NaN,NaN,NaN,thetaorg(4)];

switch form
    case 'parametric'
        switch model
            case 'simplebaye'
                theta = [thetaorg(1:3),NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,thetaorg(4)];
            case 'threshold'
                theta = [thetaorg(1:3),NaN,NaN,thetaorg(4),NaN,NaN,NaN,NaN,NaN,NaN,thetaorg(5)];
            case 'linear'
                theta = [thetaorg(1:3),NaN,NaN,NaN,thetaorg(4),thetaorg(5),NaN,NaN,NaN,NaN,thetaorg(6)];
            case 'baye'
                theta = [thetaorg(1:3),NaN,thetaorg(4),NaN,NaN,NaN,NaN,NaN,NaN,NaN,thetaorg(5)];
            case 'free'
                theta = [thetaorg(1:4),NaN,NaN,NaN,NaN,thetaorg(5),thetaorg(6),thetaorg(7),thetaorg(8),thetaorg(9)];
            case 'linear2'
                theta = [thetaorg(1:3),NaN,NaN,NaN,thetaorg(4),thetaorg(5),NaN,NaN,NaN,NaN,thetaorg(6)];
                
        end
    case 'nonparametric'
        switch model
            case 'simplebaye'
                theta = [thetaorg(1:4),NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,thetaorg(5)];
            case 'threshold'
                theta = [thetaorg(1:4),NaN,thetaorg(5),NaN,NaN,NaN,NaN,NaN,NaN,thetaorg(6)];
            case 'linear'
                theta = [thetaorg(1:4),NaN,NaN,thetaorg(5),thetaorg(6),NaN,NaN,NaN,NaN,thetaorg(7)];
            case 'baye'
                theta = [thetaorg(1:4),thetaorg(5),NaN,NaN,NaN,NaN,NaN,NaN,NaN,thetaorg(6)];
            case 'free'
                theta = [thetaorg(1:4),NaN,NaN,NaN,NaN,thetaorg(5),thetaorg(6),thetaorg(7),thetaorg(8),thetaorg(9)];
            case 'linear2'
                theta = [thetaorg(1:4),NaN,NaN,thetaorg(5),thetaorg(6),NaN,NaN,NaN,NaN,thetaorg(7)];
            case 'baye2'
                theta = [thetaorg(1:4),thetaorg(5),NaN,NaN,NaN,NaN,NaN,NaN,NaN,thetaorg(6)];
        end
        
end

