%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get_mua_bulk.m
%   according to oxygenation level, and loop up CoeffLookup table
%   output: mua
%   input: c_HHb, c_OHb, c_H2O,
%        wav: wavelength
%
%   author: jingjing Jiang  cronajiang@gmail.com
%   created: 01.02.2016
%   modified: 07.03.2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function mua = get_mua_bulk(c_HHb, c_OHb, c_H2O, c_Lipid,  wav)

TABLE_NIRFAST
T = 650:1:910;
tt = find(T== floor(wav));

Ex_Hb = table_coeff(tt,2); %[1/(mM*mm)]
Ex_HbO = table_coeff(tt,1);
Ex_H2O = table_coeff(tt,3);
Ex_Lipid = table_coeff(tt,4);
mua = Ex_Hb * c_HHb + Ex_HbO * c_OHb + c_H2O * Ex_H2O + c_Lipid * Ex_Lipid;
 
end