%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function rData = forwardFcn(paras)
%   main function of forward process 
%   return: rData      ratio data 
%   author: jingjing Jiang  jjiang@student.ethz.com
%   created: 01.02.2016
%   modified: 27.12.2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function rData = forwardFcn(paras)
a=paras.a;
ac_HHb_bulk = a* paras.CHHb * 100; % * 100
ac_OHb_bulk = a* paras.COHb * 10;
ac_H2O_bulk = a* paras.CH2O;
ac_Lipid_bulk = a* paras.CLipid;
oxy=paras.StOv;
b=paras.b;
ref = [ac_HHb_bulk, ac_OHb_bulk, ac_H2O_bulk, ac_Lipid_bulk, oxy,b];

vessel.r = paras.vesselpos(1,1);
vessel.z = paras.vesselpos(1,2);
laser1.r = paras.laserpos(1,1);  
laser1.z = paras.laserpos(1,2);
num_lasers = paras.numLasers;
allLasers_r = laser1.r;
extraPara.numLaser = num_lasers;
if isfield(paras, 'NoiseLevel')
extraPara.NoiseLevel = paras.NoiseLevel;
end
if num_lasers > 1
    laser2.r = paras.laserpos(2,1);
    laser2.z = paras.laserpos(2,1);
    allLasers_r = linspace(laser1.r, laser2.r, num_lasers);
end  
extraPara.d = sqrt(allLasers_r.^2 + vessel.z .^2);
extraPara.z = vessel.z;
extraPara.wavList = paras.wavList;
rData=y_Fcn(ref','', extraPara); 