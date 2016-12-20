%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get_mua_vessel.m
%   according to oxygenation level, and loop up CoeffLookup table
%   output: mua
%   input: oxy: 0<= oxy <= 1
%        wav: wavelength
%
%   author: jingjing Jiang  cronajiang@gmail.com
%   created: 01.02.2016
%   modified: 07.03.2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function mua = get_mua_vessel(oxy,  wav )
TABLE_NIRFAST
T = 650:1:910;
tt = find(T== floor(wav));
Ex_Hb = table_coeff(tt,2); %[1/(mM*mm)]
Ex_HbO = table_coeff(tt,1);
c_HbO = oxy; % assume the Tc_Hb for vessel = 1mM
c_HHb = 1-oxy;
mua = Ex_HbO*c_HbO+Ex_Hb*c_HHb;%mua = c_HHb*(Ex_HbO*oxy/(1-oxy)-Ex_Hb);
end