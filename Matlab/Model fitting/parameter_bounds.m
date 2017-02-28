function [lb,ub] = parameter_bounds(model,form)
switch form
    case 'parametric'
        switch model
            case 'simplebaye'
                %         lb = [1e-6,1e-6,1e-6];
                %         ub = [1,20,0.3];
                lb = [log(1/6),log(1/6),log(1/6),1e-4];
                ub = [log(500),log(1500),log(3000),0.3];
            case 'threshold'
                %         lb = [1e-6,1e-6,1e-6,1e-6];
                %         ub = [1,20,50,0.3];
                lb = [log(1/6),log(1/6),log(1/6),1/6,1e-4];
                ub = [log(500),log(1500),log(3000),50,0.3];
            case 'linear'
                %         lb = [1e-6,1e-6,-10,1e-6,1e-6];
                %         ub = [1,20,10,50,0.3];
                lb = [log(1/6),log(1/6),log(1/6),-1,1/6,1e-4];
                ub = [log(500),log(1500),log(3000),5,50,0.3];
            case 'baye'
                %         lb = [1e-6,1e-6,0.01,1e-6];
                %         ub = [1,20,0.99,0.3];
                lb = [log(1/6),log(1/6),log(1/6),0.01,1e-4];
                ub = [log(500),log(1500),log(3000),0.99,0.6];
            case 'free'
                %         lb = [1e-6,1e-6,-20,-20,-20,-20,1e-6];
                %         ub = [1,20,30,30,30,30,0.3];
                lb = [log(1/6),log(1/6),log(1/6),log(1/6),1/6,1/6,1/6,1/6,1e-4];
                ub = [log(500),log(1000),log(1500),log(3000),100,100,100,100,0.3];
                
            case 'linear2'
                lb = [log(1/6),log(1/6),log(1/6),-1,1/6,1e-4];
                ub = [log(500),log(1500),log(3000),5,50,0.3];
            case 'baye2'
                lb = [log(1/6),log(1/6),log(1/6),0.01,1e-4];
                ub = [log(500),log(1500),log(3000),0.99,0.6];
        end
    case 'nonparametric'
        switch model
            case 'simplebaye'
                lb = [log(1/6),log(1/6),log(1/6),log(1/6),1e-4];
                ub = [log(500),log(1000),log(1500),log(3000),0.3];
            case 'threshold'
                lb = [log(1/6),log(1/6),log(1/6),log(1/6),1/6,1e-4];
                ub = [log(500),log(1000),log(1500),log(3000),50,0.3];
            case 'linear'
                lb = [log(1/6),log(1/6),log(1/6),log(1/6),-1,1/6,1e-4];
                ub = [log(500),log(1000),log(1500),log(3000),5,50,0.3];
            case 'baye'
                lb = [log(1/6),log(1/6),log(1/6),log(1/6),0.01,1e-4];
                ub = [log(500),log(1000),log(1500),log(3000),0.99,0.5];
            case 'free'
                lb = [log(1/6),log(1/6),log(1/6),log(1/6),1/6,1/6,1/6,1/6,1e-4];
                ub = [log(500),log(1000),log(1500),log(3000),100,100,100,100,0.3];
            case 'linear2'
                lb = [log(1/6),log(1/6),log(1/6),log(1/6),-1,1/6,1e-4];
                ub = [log(500),log(1000),log(1500),log(3000),5,50,0.3];
            case 'baye2'
                lb = [log(1/6),log(1/6),log(1/6),log(1/6),0.01,1e-4];
                ub = [log(500),log(1000),log(1500),log(3000),0.99,0.5];
            case 'linbaye'
                lb = [log(1/6),log(1/6),log(1/6),log(1/6),-1,1/6,1e-4];
                ub = [log(500),log(1000),log(1500),log(3000),5,50,0.5];
        end
    case 'cross'
        switch model
            case 'simplebaye'
                lb = [1e-4];
                ub = [0.3];
            case 'threshold'
                lb = [1/6,1e-4];
                ub = [50,0.3];
            case 'linear'
                lb = [-1,1/6,1e-4];
                ub = [5,50,0.3];
            case 'baye'
                lb = [0.01,1e-4];
                ub = [0.99,0.5];
            case 'free'
                lb = [1/6,1/6,1/6,1/6,1e-4];
                ub = [100,100,100,100,0.3];
            case 'linear2'
                lb = [-1,1/6,1e-4];
                ub = [5,50,0.3];
            case 'baye2'
                lb = [0.01,1e-4];
                ub = [0.99,0.5];
        end
end