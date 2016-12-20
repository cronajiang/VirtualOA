%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function plot_ultra(paras)
%   plot ultrasound signal levels for different locations of probes  
%   input: paras
%         
%   author: jingjing Jiang  cronajiang@gmail.com
%   created: 01.02.2016
%   modified: 07.03.2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function plot_ultra(paras)

%-------------------- parameter assignment --------------------------%
a=paras.a;
ac_HHb_bulk = a* paras.CHHb; % * 100
ac_OHb_bulk = a* paras.COHb;
ac_H2O_bulk = a* paras.CH2O;
ac_Lipid_bulk = a* paras.CLipid;
oxy=paras.StOv;
b=paras.b;
vessel.r = paras.vesselpos(1,1);
vessel.z = paras.vesselpos(1,2);
probe1.r = paras.probepos(1,1);
probe1.z = paras.probepos(1,2);
num_probes = paras.numProbes;
allProbes_r = probe1.r;

if num_probes > 1
    probe2.r = paras.probepos(2,1);
    probe2.z = paras.probepos(2,1);
    allProbes_r = linspace(probe1.r, probe2.r, num_probes);
end  
%-------------------- parameter assignment END--------------------------%
%------------------ calculate ultrasound signal level ------------------%
num_wav = 27;
wav = linspace(650,910,num_wav);
 
mus_bulk_noa = (wav / 1000).^(-b);

for ii = 1:num_wav
    mua_vessel(ii) = get_mua_vessel(oxy, wav(ii));
    mua_bulk_witha(ii) = get_mua_bulk(ac_HHb_bulk, ac_OHb_bulk, ...
        ac_H2O_bulk, ac_Lipid_bulk, wav(ii));
    mu_eff_bulk(ii) = sqrt(3* mua_bulk_witha(ii)* mus_bulk_noa(ii));
end

for jj = 1: num_probes
    for ii = 1:num_wav     
    Probe.z = 0;
    Probe.r = allProbes_r(jj);  
    [rl, rb] =  dis_semiinfinite(vessel, Probe);
     G(jj, ii) = Green_semi(mu_eff_bulk(ii), rl, rb);
     H(jj, ii) = G(jj,ii) * mua_vessel(ii);
    end
end
%--------------- calculate ultrasound signal level END ----------------%
%------------------------------ plot START --------------------------- %
COLORs = ['r','c','b','k','m' ,'y','g'];
semilogy(wav, H(1,:)./H(1,1), COLORs(1))
hold on
str_legend(1) = {['dis = ' num2str(sqrt(vessel.z^2 + allProbes_r(1)^2))]};
if num_probes > 1
    for jj = 2:num_probes
        semilogy(wav, H(jj,:)./H(1,1), COLORs(jj))
        str_legend{jj} =  ['dis = ' num2str(sqrt(vessel.z^2 + allProbes_r(jj)^2))];
    end
end
legend(str_legend)
hold off
%------------------------------ plot END ----------------------------- %