%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function rData = reconstructionFcn(paras)
%   main function of inverse process 
%   return: x    reconstructed parameters
%   input:  paras: parameters 
%           rDataNoise: noisy reference data
%
%   author: jingjing Jiang  cronajiang@gmail.com
%   created: 01.02.2016
%   modified: 07.03.2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function x = reconstructionFcn(paras, rDataNoise)
   
    opts = optimoptions(@lsqcurvefit,'MaxFunEvals',150,'Display','iter-detailed','TolX',1e-12,'TolFun',1e-12,'Algorithm','trust-region-reflective','PlotFcns',{@optimplotx,@optimplotfunccount ,@optimplotfval,@optimplotresnorm,@optimplotstepsize,@optimplotfirstorderopt})
    lower=[paras.a_range(1) * paras.CHHb_range(1) * 100,...
        paras.a_range(1) * paras.COHb_range(1) * 10,...
        paras.a_range(1) * paras.CH2O_range(1),...
        paras.a_range(1) * paras.CLipid_range(1),...
        paras.StOv_range(1),...
        paras.b_range(1)];
    upper=[paras.a_range(2) * paras.CHHb_range(2) * 100,...
        paras.a_range(2) * paras.COHb_range(2) * 10,...
        paras.a_range(2) * paras.CH2O_range(2),...
        paras.a_range(2) * paras.CLipid_range(2),...
        paras.StOv_range(2),...
        paras.b_range(2)];
    
    a=paras.a;
    ac_HHb_bulk = a* paras.CHHb * 100;
    ac_OHb_bulk = a* paras.COHb * 10;
    ac_H2O_bulk = a* paras.CH2O;
    ac_Lipid_bulk = a* paras.CLipid;
    oxy=paras.StOv;
    b=paras.b;
    init = [ac_HHb_bulk, ac_OHb_bulk, ac_H2O_bulk, ac_Lipid_bulk,oxy,b];

    vessel.r = paras.vesselpos(1,1);
    vessel.z = paras.vesselpos(1,2);
    laser1.r = paras.laserpos(1,1);
    laser1.z = paras.laserpos(1,2);
    num_lasers = paras.numLasers;
    allLasers_r = laser1.r;
    extraPara.numLaser = num_lasers;
    if num_lasers > 1
        laser2.r = paras.laserpos(2,1);
        laser2.z = paras.laserpos(2,1);
        allLasers_r = linspace(laser1.r, laser2.r, num_lasers);
    end  
    extraPara.d = sqrt(allLasers_r.^2 + vessel.z .^2);
    extraPara.z = vessel.z;
%     for ii = 1: num_lasers
%         Laser.z = 0;
%         Laser.r = allLasers_r(ii);
%         [extraPara.P(ii).rl, extraPara.P(ii).rb] =  dis_semiinfinite(vessel, Laser);
%     end
    
%     % factor of scaling
%     if isfield(paras, 'fac_scl')
%         extraPara.fac_scl = paras.fac_scl;
%         rDataNoise = rDataNoise ./ extraPara.fac_scl;
%     end
     
    ydata = @(x,xdata)y_Fcn(x,xdata, extraPara);
    [x,resnorm] = lsqcurvefit(ydata,init,0,rDataNoise,lower,upper,opts);
    