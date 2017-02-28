function [plb,pub] = possible_bounds(model,form)
switch form
    case 'parametric'
        switch model
            case 'simplebaye'
                %         plb      = [0.001,0.01,1e-4];
                %         pub      = [0.1,10,0.3];
                plb      = [log(1),log(150),log(350),0.01];
                pub      = [log(20),log(250),log(450),0.1];
            case 'threshold'
                %         plb      = [0.001,0.01,0.01,1e-4];
                %         pub      = [0.1,10,10,0.3];
                plb      = [log(1),log(150),log(350),1,0.01];
                pub      = [log(20),log(250),log(450),400,0.1];
            case 'linear'
                %         plb      = [0.001,0.01,0.01,1,1e-4];
                %         pub      = [0.1,10,0.1,10,0.3];
                plb      = [log(1),log(150),log(350),0.01,1,0.01];
                pub      = [log(20),log(250),log(450),0.1,10,0.1];
            case 'baye'
                %         plb      = [0.001,0.01,0.2,1e-4];
                %         pub      = [0.1,10,0.8,0.3];
                plb      = [log(1),log(150),log(350),0.2,0.01];
                pub      = [log(20),log(250),log(450),0.8,0.1];
            case 'free'
                %         plb      = [0.001,0.01,5,10,10,10,1e-4];
                %         pub      = [0.1,10,15,15,15,20,0.05];
                plb      = [log(1),log(10),log(20),log(100),5,10,20,30,0.01];
                pub      = [log(25),log(50),log(100),log(400),15,20,30,40,0.1];
                
            case 'linear2'
                plb      = [log(1),log(150),log(350),0.1,1,0.01];
                pub      = [log(20),log(250),log(450),1,20,0.1];
            case 'baye2'
                %         plb      = [0.001,0.01,0.2,1e-4];
                %         pub      = [0.1,10,0.8,0.3];
                plb      = [log(1),log(150),log(350),0.2,0.01];
                pub      = [log(20),log(250),log(450),0.8,0.1];
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
            case 'baye2'
                plb      = [log(1),log(10),log(20),log(100),0.45,0.01];
                pub      = [log(25),log(50),log(100),log(400),0.55,0.1];
            case 'linbaye'
                plb      = [log(1),log(10),log(20),log(100),0.01,1,0.01];
                pub      = [log(25),log(50),log(100),log(400),0.1,10,0.1];
        end
    case 'cross'
        switch model
            case 'simplebaye'
                plb      = [1e-4];
                pub      = [0.1];
            case 'threshold'
                plb      = [1,1e-4];
                pub      = [50,0.1];
            case 'linear'
                plb      = [0.01,1,1e-4];
                pub      = [0.1,10,0.1];
            case 'baye'
                plb      = [0.45,1e-4];
                pub      = [0.55,0.1];
            case 'free'
                plb      = [5,10,20,30,1e-4];
                pub      = [15,20,30,40,0.1];
            case 'linear2'
                plb      = [0.1,1,1e-4];
                pub      = [1,20,0.1];
            case 'baye2'
                plb      = [0.45,1e-4];
                pub      = [0.55,0.1];
        end
end
