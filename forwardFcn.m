%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function rData = forwardFcn(paras)
%   main function of forward process 
%   return: rData      ratio data 
%   author: jingjing Jiang  cronajiang@gmail.com
%   created: 01.02.2016
%   modified: 07.03.2016
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
probe1.r = paras.probepos(1,1);
probe1.z = paras.probepos(1,2);
num_probes = paras.numProbes;
allProbes_r = probe1.r;
extraPara.numProbe = num_probes;
if isfield(paras, 'NoiseLevel')
extraPara.NoiseLevel = paras.NoiseLevel;
end
if num_probes > 1
    probe2.r = paras.probepos(2,1);
    probe2.z = paras.probepos(2,1);
    allProbes_r = linspace(probe1.r, probe2.r, num_probes);
end  
for ii = 1: num_probes
    Probe.z = 0;
    Probe.r = allProbes_r(ii);
    [extraPara.P(ii).rl, extraPara.P(ii).rb] =  dis_semiinfinite(vessel, Probe);
end
rData=y_Fcn(ref','', extraPara); 