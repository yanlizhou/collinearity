function [lb,ub] = parameter_bounds(model,noise,rbmflag,dn_flag)
if nargin < 3 || isempty(rbmflag); rbmflag = 0; end
if nargin < 4 || isempty(dn_flag); dn_flag = 0; end

if rbmflag
    switch model
        case 'simplebaye'
            lb      = [log(0.04),log(0.02),log(0.01),log(1e-8),1e-6];
            ub      = [log(40),log(20),log(10),log(5),0.3];
        case 'threshold'
            lb      = [log(0.04),log(0.02),log(0.01),log(1e-8),0.005,1e-6];
            ub      = [log(40),log(20),log(10),log(5),80,0.3];
        case 'linear'
            lb      = [log(0.04),log(0.02),log(0.01),log(1e-8),-1,0.0001,1e-6];
            ub      = [log(40),log(20),log(10),log(5),5,6.25,0.3];
        case 'baye'
            lb      = [log(0.04),log(0.02),log(0.01),log(1e-8),0.01,1e-6];
            ub      = [log(40),log(20),log(10),log(5),0.99,0.3];
        case 'free'
            lb      = [log(0.04),log(0.02),log(0.01),log(1e-8),0.375,0.25,0.125,0.06,1e-6];
            ub      = [log(40),log(20),log(10),log(5),50,37.5,25,18.75,0.3];
        case 'linear2'
            lb      = [log(0.04),log(0.02),log(0.01),log(1e-8),-1,0.0001,1e-6];
            ub      = [log(40),log(20),log(10),log(5),5,6.25,0.3];
        case 'linear3'
            lb      = [log(0.04),log(0.02),log(0.01),log(1e-8),-1,0.0001,1e-6];
            ub      = [log(40),log(20),log(10),log(5),5,6.25,0.3];
        case 'baye2'
            lb      = [log(0.04),log(0.02),log(0.01),log(1e-8),0.01,1e-6];
            ub      = [log(40),log(20),log(10),log(5),0.99,0.3];
        case 'linbaye_pc'
            lb      = [log(0.04),log(0.02),log(0.01),log(1e-8),-1,0.01,0.01,1e-6];
            ub      = [log(40),log(20),log(10),log(5),5,6.25,0.99,0.3];
        case 'linbaye'
            lb      = [log(0.04),log(0.02),log(0.01),log(1e-8),-1,0.01,1e-6];
            ub      = [log(40),log(20),log(10),log(5),5,6.25,0.3];
        case 'lintrial'
            lb      = [log(0.04),log(0.02),log(0.01),log(1e-8),0.01,1,0.01,0.01,0.01,0.01,1e-6];
            ub      = [log(40),log(20),log(10),log(5),0.1,10,0.1,0.1,0.1,0.1,0.3];
        case 'rbm_baye'
            lb      = [log(0.04),log(0.02),log(0.01),log(1e-8),1e-6];
            ub      = [log(40),log(20),log(10),log(5),0.3];
        case 'linbaye_f'
            lb      = [log(0.04),log(0.02),log(0.01),log(1e-8),-1,0.01,1e-6];
            ub      = [log(40),log(20),log(10),log(5),5,6.25,0.3];
    end
else
    switch noise
        case 'parametric'
            switch model
                case 'simplebaye'
                    lb = [log(1/6),log(1/6),log(1/6),1e-4];
                    ub = [log(500),log(1500),log(3000),0.3];
                case 'threshold'
                    lb = [log(1/6),log(1/6),log(1/6),1/6,1e-4];
                    ub = [log(500),log(1500),log(3000),50,0.3];
                case 'linear'
                    lb = [log(1/6),log(1/6),log(1/6),-1,1/6,1e-4];
                    ub = [log(500),log(1500),log(3000),5,50,0.3];
                case 'baye'
                    lb = [log(1/6),log(1/6),log(1/6),0.01,1e-4];
                    ub = [log(500),log(1500),log(3000),0.99,0.6];
                case 'free'
                    lb = [log(1/6),log(1/6),log(1/6),log(1/6),1/6,1/6,1/6,1/6,1e-4];
                    ub = [log(500),log(1000),log(1500),log(3000),100,100,100,100,0.3];
                case 'linear2'
                    lb = [log(1/6),log(1/6),log(1/6),-1,1/6,1e-4];
                    ub = [log(500),log(1500),log(3000),5,50,0.3];
                case 'baye2'
                    lb = [log(1/6),log(1/6),log(1/6),0.01,1e-4];
                    ub = [log(500),log(1500),log(3000),0.99,0.6];
                case 'linbaye_pc'
                    lb = [log(1/6),log(1/6),log(1/6),-1,1/6,0.01,1e-4];
                    ub = [log(500),log(1500),log(3000),5,50,0.99,0.5];
                case 'linbaye'
                    lb = [log(1/6),log(1/6),log(1/6),-1,1/6,1e-4];
                    ub = [log(500),log(1500),log(3000),5,100,0.5];
                case 'freebaye_pc'
                    lb = [log(1/6),log(1/6),log(1/6),log(1/6),log(1/6),log(1/6),log(1/6),0.01,1e-4];
                    ub = [log(500),log(1500),log(3000),log(500),log(1000),log(1500),log(3000),0.99,0.5];
                case 'freebaye'
                    lb = [log(1/6),log(1/6),log(1/6),log(1/6),log(1/6),log(1/6),log(1/6),1e-4];
                    ub = [log(500),log(1500),log(3000),log(500),log(1000),log(1500),log(3000),0.5];
                case 'lintrial'
                    lb = [log(1/6),log(1/6),log(1/6),-1,1/6,-10,-10,-10,-10,1e-4];
                    ub = [log(500),log(1500),log(3000),5,50,10,10,10,10,0.3];
            end
        case 'nonparametric'
            switch model
                case 'simplebaye'
                    lb = [log(1/6),log(1/6),log(1/6),log(1/6),1e-4];
                    ub = [log(500),log(1000),log(1500),log(3000),0.5];
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
                case 'linear3'
                    lb = [log(1/6),log(1/6),log(1/6),log(1/6),-1,-20,1e-4];
                    ub = [log(500),log(1000),log(1500),log(3000),5,50,0.3];
                case 'baye2'
%                     lb = [log(1/6),log(1/6),log(1/6),log(1/6),0.01,1e-4];
%                     ub = [log(500),log(1000),log(1500),log(3000),0.99,0.5];
                    lb = [log(1/6),log(1/6),log(1/6),log(1/6),0.01,1e-4];
                    ub = [log(500),log(1000),log(1500),log(3000),0.99,0.5];
                case 'linbaye_pc'
                    lb = [log(1/6),log(1/6),log(1/6),log(1/6),-1,1/6,0.01,1e-4];
                    ub = [log(500),log(1000),log(1500),log(3000),5,50,0.99,0.5];
                case 'linbaye'
                    lb = [log(1/6),log(1/6),log(1/6),log(1/6),-1,1/6,1e-4];
                    ub = [log(500),log(1000),log(1500),log(3000),5,100,0.5];
                case 'freebaye_pc'
                    lb = [log(1/6),log(1/6),log(1/6),log(1/6),log(1/6),log(1/6),log(1/6),log(1/6),0.01,1e-4];
                    ub = [log(500),log(1000),log(1500),log(3000),log(500),log(1000),log(1500),log(3000),0.99,0.5];
                case 'freebaye'
                    lb = [log(1/6),log(1/6),log(1/6),log(1/6),log(1/6),log(1/6),log(1/6),log(1/6),1e-4];
                    ub = [log(500),log(1000),log(1500),log(3000),log(500),log(1000),log(1500),log(3000),0.5];
                case 'lintrial'
                    lb = [log(1/6),log(1/6),log(1/6),log(1/6),-1,1/6,-10,-10,-10,-10,1e-4];
                    ub = [log(500),log(1000),log(1500),log(3000),5,50,10,10,10,10,0.3];
                case 'lintrial2'
                    lb = [log(1/6),log(1/6),log(1/6),log(1/6),-1,1/6,-10,-10,-10,-10,1e-4];
                    ub = [log(500),log(1000),log(1500),log(3000),5,50,10,10,10,10,0.3];
                case 'rbm_baye'
                    lb = [log(1/6),log(1/6),log(1/6),log(1/6),1e-6];
                    ub = [log(500),log(1000),log(1500),log(3000),0.1];
                case 'linbaye_f'
                    lb = [log(1/6),log(1/6),log(1/6),log(1/6),log(1/6),log(1/6),1e-4];
                    ub = [log(500),log(1000),log(1500),log(3000),log(500),log(3000),0.5];
                case 'linbaye_f2'
                    lb = [log(1/6),log(1/6),log(1/6),log(1/6),log(1/6),log(1/6),1e-4];
                    ub = [log(500),log(1000),log(1500),log(3000),log(500),log(3000),0.5];
                case 'sub_vy'
                    lb = [0.4855, 3.2774, 4.0490, 4.8847, 0.01, 2.5,1e-4];
                    ub = [4.3865, 5.2943, 6.5815, 8.0697, 0.99, 4.8, 0.3];
                case 'sub_vy_no_pc'
                    lb = [log(1/6),log(1/6),log(1/6),log(1/6),0.01,1e-4];
                    ub = [log(500),log(1000),log(1500),log(3000),200,0.5];
            end
        case 'cross'
            switch model
                case 'simplebaye'
                    lb = 1e-4;
                    ub = 0.5;
                case 'threshold'
                    lb = [1/6,1e-4];
                    ub = [50,0.5];
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
                case 'linear3'
                    lb = [-1,-20,1e-4];
                    ub = [5,50,0.3];
                case 'baye2'
                    lb = [0.01,1e-4];
                    ub = [0.99,0.5];
                case 'linbaye_pc'
                    lb = [-1,1/6,0.01,1e-4];
                    ub = [5,50,0.99,0.5];
                case 'linbaye'
                    lb = [-1,1/6,1e-4];
                    ub = [5,150,0.5];
                case 'freebaye_pc'
                    lb = [log(1/6),log(1/6),log(1/6),log(1/6),0.01,1e-4];
                    ub = [log(500),log(1000),log(1500),log(3000),0.99,0.5];
                case 'freebaye'
                    lb = [log(1/6),log(1/6),log(1/6),log(1/6),1e-4];
                    ub = [log(500),log(1000),log(1500),log(3000),0.5];
                case 'lintrial'
                    lb = [-1,1/6,-10,-10,-10,-10,1e-4];
                    ub = [5,50,10,10,10,10,0.3];
            end
    end
    
    if dn_flag
        lb(length(lb)+1) = 1e-6;
        ub(length(ub)+1) = 10;
    end
    
 
end