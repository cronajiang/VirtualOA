%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% y_Fcn.m 
%   forward simulation 
%   return: F   forward result of ratio data
%   input:  x, fitting parameters
%           x_data, void 
%           paras, other parameters
%
%   author: jingjing Jiang  jjiang@student.ethz.com
%   created: 01.02.2016
%   modified: 07.03.2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function F = y_Fcn(x,x_data, paras)

ac_HHb_bulk = x(1)/100;
ac_OHb_bulk = x(2)/10;
ac_H2O_bulk = x(3);
ac_Lipid_bulk = x(4);
oxy = x(5);
b = x(6);
num_lasers = paras.numLaser;
wav = paras.wavList;
num_wav = length(wav);
mus_bulk_noa = (wav / 1000).^(-b);

for ii = 1:num_wav
    mua_vessel(ii) = get_mua_vessel(oxy, wav(ii));
    mua_bulk_witha(ii) = get_mua_bulk(ac_HHb_bulk, ac_OHb_bulk, ...
        ac_H2O_bulk, ac_Lipid_bulk, wav(ii));
    mu_eff_bulk(ii) = sqrt(3* mua_bulk_witha(ii)* mus_bulk_noa(ii));
end

%%%% Laser loop

% scale the signal to the mean value
for jj  = 1:num_lasers
    for ii = 1:num_wav
        G(jj, ii) = cal_fluence(mu_eff_bulk(ii), paras.z, paras.d(jj));    
        H(jj, ii) = G(jj, ii) * mua_vessel(ii);
    end
end

for jj = 1: num_lasers
    F(num_wav * (jj-1)+1: num_wav*jj) =  H(jj,:)./mean(H(jj,:)); % ratio data
end
% F = log(F);

if isfield(paras, 'NoiseLevel')
    %         % generate noisy result
        noise =paras.NoiseLevel .*F.*2.*(0.5-rand(1,num_lasers * num_wav));
        F = F + noise;
end
% if isfield(paras, 'fac_scl')
%     F = F ./ paras.fac_scl;  
% end

