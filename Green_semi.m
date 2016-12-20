function G = Green_semi(mu_eff, rl,rb)
G =(1/4*pi)*(exp(-mu_eff.* rl)./rl - exp(-mu_eff.* rb )./ rb) ;
