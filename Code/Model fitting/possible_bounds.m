function [plb,pub] = possible_bounds(model,form,rbmflag)
if nargin < 3 || isempty(rbmflag); rbmflag = 0; end

if rbmflag
    switch model
        case 'simplebaye'
            plb      = [log(4),log(1.5),log(0.5),log(0.1),0.01];
            pub      = [log(8),log(3.5),log(2),log(1),0.1];
        case 'threshold'
            plb      = [log(4),log(1.5),log(0.5),log(0.1),0.05,0.01];
            pub      = [log(8),log(3.5),log(2),log(1),8,0.1];
        case 'linear'
            plb      = [log(4),log(1.5),log(0.5),log(0.1),0.01,0.5,0.01];
            pub      = [log(8),log(3.5),log(2),log(1),0.1,1.2,0.1];
        case 'baye'
            plb      = [log(4),log(1.5),log(0.5),log(0.1),0.45,0.01];
            pub      = [log(8),log(3.5),log(2),log(1),0.55,0.1];
        case 'free'
            plb      = [log(4),log(1.5),log(0.5),log(0.1),3.75,2.5,1.25,0.6,0.01];
            pub      = [log(8),log(3.5),log(2),log(1),5,3.75,2.5,1.875,0.1];
        case 'linear2'
            plb      = [log(4),log(1.5),log(0.5),log(0.1),0.01,0.5,0.01];
            pub      = [log(8),log(3.5),log(2),log(1),0.1,1.2,0.1];
        case 'linear3'
            plb      = [log(4),log(1.5),log(0.5),log(0.1),0.01,0.5,0.01];
            pub      = [log(8),log(3.5),log(2),log(1),0.1,1.2,0.1];
        case 'baye2'
            plb      = [log(4),log(1.5),log(0.5),log(0.1),0.45,0.01];
            pub      = [log(8),log(3.5),log(2),log(1),0.55,0.1];
        case 'linbaye_pc'
            plb      = [log(4),log(1.5),log(0.5),log(0.1),0.01,1,0.45,0.01];
            pub      = [log(8),log(3.5),log(2),log(1),0.1,10,0.55,0.1];
        case 'linbaye'
            plb      = [log(4),log(1.5),log(0.5),log(0.1),0.01,1,0.01];
            pub      = [log(8),log(3.5),log(2),log(1),0.1,10,0.1];
        case 'lintrial'
            plb      = [log(4),log(1.5),log(0.5),log(0.1),0.01,1,0.01,0.01,0.01,0.01,0.01];
            pub      = [log(8),log(3.5),log(2),log(1),0.1,10,0.1,0.1,0.1,0.1,0.1];
        case 'lintrial2'
            plb      = [log(4),log(1.5),log(0.5),log(0.1),0.01,1,0.01,0.01,0.01,0.01,0.01];
            pub      = [log(8),log(3.5),log(2),log(1),0.1,10,0.1,0.1,0.1,0.1,0.1];
        case 'rbm_baye'
            plb      = [log(4),log(1.5),log(0.5),log(0.1),0.01];
            pub      = [log(8),log(3.5),log(2),log(1),0.1];
        case 'linbaye_f'
            plb      = [log(4),log(1.5),log(0.5),log(0.1),0.01,0.05,0.01];
            pub      = [log(8),log(3.5),log(2),log(1),0.1,2,0.1];
    end
else
    switch form
        case 'parametric'
            switch model
                case 'simplebaye'
                    plb      = [log(1),log(20),log(100),0.01];
                    pub      = [log(25),log(100),log(400),0.1];
                case 'threshold'
                    plb      = [log(1),log(20),log(100),1,0.01];
                    pub      = [log(25),log(100),log(400),400,0.1];
                case 'linear'
                    plb      = [log(1),log(20),log(100),0.01,1,0.01];
                    pub      = [log(25),log(100),log(400),0.1,10,0.1];
                case 'baye'
                    plb      = [log(1),log(20),log(100),0.2,0.01];
                    pub      = [log(25),log(100),log(400),0.8,0.1];
                case 'free'
                    plb      = [log(1),log(20),log(100),5,10,20,30,0.01];
                    pub      = [log(25),log(100),log(400),15,20,30,40,0.1];
                case 'linear2'
                    plb      = [log(1),log(20),log(100),0.1,1,0.01];
                    pub      = [log(25),log(100),log(400),1,20,0.1];
                case 'baye2'
                    plb      = [log(1),log(20),log(100),0.2,0.01];
                    pub      = [log(25),log(100),log(400),0.8,0.1];
                case 'linbaye_pc'
                    plb      = [log(1),log(20),log(100),0.01,1,0.2,0.01];
                    pub      = [log(25),log(100),log(400),0.1,10,0.8,0.1];
                case 'linbaye'
                    plb      = [log(1),log(20),log(100),0.01,1,0.01];
                    pub      = [log(25),log(100),log(400),0.1,10,0.1];
                case 'freebaye_pc'
                    plb      = [log(1),log(20),log(100),log(1),log(10),log(20),log(100),0.45,0.01];
                    pub      = [log(25),log(100),log(400),log(25),log(50),log(100),log(400),0.55,0.1];
                case 'freebaye'
                    plb      = [log(1),log(20),log(100),log(1),log(10),log(20),log(100),0.01];
                    pub      = [log(25),log(100),log(400),log(25),log(50),log(100),log(400),0.1];
                case 'lintrial'
                    plb      = [log(1),log(20),log(100),0.01,1,0.01,0.01,0.01,0.01,0.01];
                    pub      = [log(25),log(100),log(400),0.1,10,0.1,0.1,0.1,0.1,0.1];
                case 'linbaye_f'
                    plb      = [log(1),log(20),log(100),0.01,1,0.01];
                    pub      = [log(25),log(100),log(400),0.1,10,0.1];
            end
        case 'nonparametric'
            switch model
                case 'simplebaye'
                    plb      = [log(1),log(10),log(20),log(100),0.01];
                    pub      = [log(25),log(50),log(100),log(400),0.1];
                case 'threshold'
                    plb      = [log(1),log(10),log(20),log(100),1,0.01];
                    pub      = [log(25),log(50),log(100),log(400),50,0.1];
                case 'linear'
                    plb      = [log(1),log(10),log(20),log(100),0.01,1,0.01];
                    pub      = [log(25),log(50),log(100),log(400),0.1,10,0.1];
                case 'baye'
                    plb      = [log(1),log(10),log(20),log(100),0.45,0.01];
                    pub      = [log(25),log(50),log(100),log(400),0.55,0.1];
                case 'free'
                    plb      = [log(1),log(10),log(20),log(100),5,10,20,30,0.01];
                    pub      = [log(25),log(50),log(100),log(400),15,20,30,40,0.1];
                case 'linear2'
                    plb      = [log(1),log(10),log(20),log(100),0.1,1,0.01];
                    pub      = [log(25),log(50),log(100),log(400),1,20,0.1];
                case 'linear3'
                    plb      = [log(1),log(10),log(20),log(100),1,1,0.01];
                    pub      = [log(25),log(50),log(100),log(400),2,10,0.1];
                case 'baye2'
                    plb      = [log(1),log(10),log(20),log(100),0.45,0.01];
                    pub      = [log(25),log(50),log(100),log(400),0.55,0.1];
                case 'linbaye_pc'
                    plb      = [log(1),log(10),log(20),log(100),0.01,1,0.45,0.01];
                    pub      = [log(25),log(50),log(100),log(400),0.1,10,0.55,0.1];
                case 'linbaye'
                    plb      = [log(1),log(10),log(20),log(100),0.01,1,0.01];
                    pub      = [log(25),log(50),log(100),log(400),0.1,10,0.1];
                case 'freebaye_pc'
                    plb      = [log(1),log(10),log(20),log(100),log(1),log(10),log(20),log(100),0.45,0.01];
                    pub      = [log(25),log(50),log(100),log(400),log(25),log(50),log(100),log(400),0.55,0.1];
                case 'freebaye'
                    plb      = [log(1),log(10),log(20),log(100),log(1),log(10),log(20),log(100),0.01];
                    pub      = [log(25),log(50),log(100),log(400),log(25),log(50),log(100),log(400),0.1];
                case 'lintrial'
                    plb      = [log(1),log(10),log(20),log(100),0.01,1,0.01,0.01,0.01,0.01,0.01];
                    pub      = [log(25),log(50),log(100),log(400),0.1,10,0.1,0.1,0.1,0.1,0.1];
                case 'lintrial2'
                    plb      = [log(1),log(10),log(20),log(100),0.01,1,0.01,0.01,0.01,0.01,0.01];
                    pub      = [log(25),log(50),log(100),log(400),0.1,10,0.1,0.1,0.1,0.1,0.1];
                case 'rbm_baye'
                    plb      = [log(1),log(10),log(20),log(100),0.001];
                    pub      = [log(25),log(50),log(100),log(400),0.01];
                case 'linbaye_f'
                    plb      = [log(1),log(10),log(20),log(100),log(1),log(100),0.01];
                    pub      = [log(25),log(50),log(100),log(400),log(25),log(400),0.1];
                case 'linbaye_f2'
                    plb      = [log(1),log(10),log(20),log(100),log(1),log(100),0.01];
                    pub      = [log(25),log(50),log(100),log(400),log(25),log(400),0.1];
            end
        case 'cross'
            switch model
                case 'simplebaye'
                    plb      = 1e-4;
                    pub      = 0.1;
                case 'threshold'
                    plb      = [1,0.01];
                    pub      = [50,0.1];
                case 'linear'
                    plb      = [0.01,1,0.01];
                    pub      = [0.1,10,0.1];
                case 'baye'
                    plb      = [0.45,0.01];
                    pub      = [0.55,0.1];
                case 'free'
                    plb      = [5,10,20,30,0.01];
                    pub      = [15,20,30,40,0.1];
                case 'linear2'
                    plb      = [0.1,1,1e-4];
                    pub      = [1,20,0.1];
                case 'linear3'
                    plb      = [1,1,0.01];
                    pub      = [2,10,0.1];
                case 'baye2'
                    plb      = [0.45,1e-4];
                    pub      = [0.55,0.1];
                case 'linbaye_pc'
                    plb      = [0.01,1,0.45,0.01];
                    pub      = [0.1,10,0.55,0.1];
                case 'linbaye'
                    plb      = [0.01,1,0.01];
                    pub      = [0.1,10,0.1];
                case 'freebaye_pc'
                    plb      = [log(1),log(10),log(20),log(100),0.45,0.01];
                    pub      = [log(25),log(50),log(100),log(400),0.55,0.1];
                case 'freebaye'
                    plb      = [log(1),log(10),log(20),log(100),0.01];
                    pub      = [log(25),log(50),log(100),log(400),0.1];
                case 'lintrial'
                    plb      = [0.01,1,0.01,0.01,0.01,0.01,0.01];
                    pub      = [0.1,10,0.1,0.1,0.1,0.1,0.1];
            end
    end
end