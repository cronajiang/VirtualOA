function [rl, rb] = dis_semiinfinite(p, source)


ltr = 1;
 Z = p.z;
 rho = p.r;
 zl = source.z + ltr;
%  n = 1.4;
n = 1.34;
 R_eff = -1.44* n^(-2) + 0.71*n^(-1) +0.668 +0.00636 *n;
 zb = 2 *ltr *(1+R_eff) / (3 * (1-R_eff));
 rl=((Z-zl).^2+ (rho-source.r).^2).^.5;
 rb=((Z+2*zb+ltr - source.z ).^2+ (rho - source.r).^2).^.5;