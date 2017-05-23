%%%%%%%%%%%%%%%%%%%
% cal_fluence
%%%%%%%%%%%%%%%%%%
function G = cal_fluence(mu_eff, z, d)
% z: depth,
% d: distance
G = z./(d.^3).*[1+mu_eff.*d].*exp(-mu_eff.*d);
end
 