%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function plot_fluence(paras)
%   plot fluence and mua of the blood vessel
%   output: void
%   input: paras
%
%   author: jingjing Jiang  jjiang@student.ethz.com
%   created: 01.02.2016
%   modified: 07.03.2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function plot_fluence(paras)
axes(paras.axesFluence)
cla
% calculate mu_eff
 oxy = paras.StOv; % vessel oxy
 a = paras.a;
 b = paras.b;
 wav = paras.wav;
 c_HHb_bulk = paras.CHHb;
 c_OHb_bulk = paras.COHb;
 c_H2O_bulk = paras.CH2O;
 c_Lipid_bulk = paras.CLipid;
 laser.r = paras.laserpos(1,1);
 laser.z = paras.laserpos(1,2);
 vessel.r = paras.vesselpos(1,1);
 vessel.z = paras.vesselpos(1,2);
    mua_vessel = get_mua_vessel(oxy, wav);
    mus_bulk = a.*(wav / 1000).^(-b);
    mua_bulk  = get_mua_bulk(c_HHb_bulk, c_OHb_bulk, c_H2O_bulk,...
        c_Lipid_bulk, wav);
    mu_eff_bulk  = sqrt(3* mua_bulk * mus_bulk );
 

% calculate .. using Green function
A = 100;
A_green = 1;
for zi = 0:60
    for ri = -45:45
        pBulk.z = zi;
        pBulk.r = ri;
%         [rl, rb] =  dis_semiinfinite(pBulk, laser); 
        % debug
        if zi == 10&& ri ==0
            t=0;
        end
%         G( zi+1,ri+45+1) = Green_semi(mu_eff_bulk, rl, rb) ; 
        G( zi+1,ri+45+1) = cal_fluence(mu_eff_bulk, zi, ...
            sqrt(ri*ri+zi*zi));
        F(zi+1, ri+45+1) = log(G( zi+1,ri+45+1))+A ;
        
    end
end

G_src = mean( [G(3, 46)  G(1, 44) G(1,47)]);
F_src = mean( [F(3, 46) F(1,44) F(1,47)]);
for zi = 0:2
    for ri = -1:1
        G( zi+1,ri+45+1) = G_src;
        F(zi+1, ri+45+1) = F_src;
% plot bulk
    end
end
[X, Y] = meshgrid(-45:45,0:60);

% calculate the highest and lowest fluence for this configurations
% highest are always around wav 650 770 910   pos close to (0,0)
wav_high = [740 770 800];
% pHigh.z = 1;
% pHigh.r = 1;

for ii = 1: length(wav_high)

    mus_bulk = a.*(wav_high(ii)* 1e-3).^(-b);
    mua_bulk  = get_mua_bulk(c_HHb_bulk, c_OHb_bulk, c_H2O_bulk, ...
        c_Lipid_bulk, wav_high(ii));
    mu_eff_bulk  = sqrt(3* mua_bulk * mus_bulk );
%     [rl, rb] =  dis_semiinfinite(pHigh, laser); 
%     G_h(ii) = Green_semi(mu_eff_bulk, rl, rb); 
    G_h(ii) = cal_fluence(mu_eff_bulk, 1, 1);
    F_h(ii) = log(G_h(ii))+A ;
end
high_F = max(F_h);

% lowest are always around wav 700 730, pos close to (45,60)
wav_low = [650 910];
% pLow.r = 45;
% pLow.z = 60;
for ii = 1:length(wav_low)
    mus_bulk = a.*(wav_low(ii)* 1e-3).^(-b);
    mua_bulk  = get_mua_bulk(c_HHb_bulk, c_OHb_bulk, c_H2O_bulk,...
        c_Lipid_bulk, wav_low(ii));
    mu_eff_bulk  = sqrt(3* mua_bulk * mus_bulk );
%     [rl, rb] =  dis_semiinfinite(pLow, laser); 
%     G_l(ii) = Green_semi(mu_eff_bulk, rl, rb); 
    G_l(ii) =  cal_fluence(mu_eff_bulk, 60, sqrt(45*45+60*60));
    F_l(ii) = log(G_l(ii))+A ; 
end
low_F = min(F_l);

highV_wav = [650:2:910];
for ii = 1: length(highV_wav)
    mua_vessel_h(ii) =   get_mua_vessel(oxy, highV_wav(ii));
end
high_muaV = max(mua_vessel_h);
low_muaV = min(mua_vessel_h);
%%%%%%%%%%%%%%%%%%%% end %%%%%%%%%%%%%%%%%%
cla
hold on
%title('fluence field for laser 1')
set(gca,'Ydir','reverse')
xlabel('rho [mm]')
ylabel('z [mm]')

low =low_F ;
high =high_F + 2;
 
surf(X,Y,F);
shading interp;

axis([-45, 45, 0, 60, low, high]);
 
az = 0;
el = 90;
 view(az, el);
 colormap(hot);
 
caxis([low high])
hCB = findobj(paras.uiPanel, 'tag', 'Colorbar');% avoid overlap of colorbars
delete(hCB);
h = colorbar('Parent',paras.uiPanel,'Position', [0.85 0.16 0.0401 0.72]);
set(h, 'ylim', [low high])
 
% calculate the product  
H = A_green* G(vessel.z + 1, vessel.r + 46) * mua_vessel;
% text(vessel.r+30,vessel.z+6,200,['H = \mu_a_v x Fluence_b' ],...
%     'HorizontalAlignment','right','Color','k')
% text(vessel.r+32,vessel.z+11,200,['=' num2str(mua_vessel,5) ' x '...
%     num2str(A_green*G(vessel.z + 1, vessel.r + 46),5)],...
%     'HorizontalAlignment','right','Color','k')
% text(vessel.r+14,vessel.z+16,200,['=' num2str(H,5)],...
%     'HorizontalAlignment','right','Color','k')

% plot mua_vessel for the vessel
vesselColor =( 1- (mua_vessel-(low_muaV-0.01))./(0.01+high_muaV-low_muaV ))...
    * ones(1,3);
plot3(vessel.r,vessel.z,high, 'Marker', 'o','MarkerSize',10,...
    'MarkerFaceColor', vesselColor, 'MarkerEdgeColor', 'r')
drawnow;
hold off
%------------------ calculate ultrasound signal level ------------------%
num_wav = 27;
wav = linspace(650,910,num_wav);
 
mus_bulk_noa = (wav / 1000).^(-b);

for ii = 1:num_wav
    mua_vessel(ii) = get_mua_vessel(oxy, wav(ii));
    mua_bulk_witha(ii) = get_mua_bulk(a*c_HHb_bulk, a*c_OHb_bulk, ...
        a*c_H2O_bulk, a*c_Lipid_bulk, wav(ii));
    mu_eff_bulk(ii) = sqrt(3* mua_bulk_witha(ii)* mus_bulk_noa(ii));
    
end

 
for ii = 1:num_wav     
 
    %     [rl, rb] =  dis_semiinfinite(vessel, laser);
    %      G(jj, ii) = Green_semi(mu_eff_bulk(ii), rl, rb);
         G(ii) = cal_fluence(mu_eff_bulk(ii),vessel.z, ...
             sqrt(laser.r.^2 + vessel.z .^2));
         H_us(ii) = G(ii) * mua_vessel(ii);
    
    
end
minH_us = min(H_us);
maxH_us = max(H_us);
A = (H - minH_us) / (maxH_us - minH_us);
% -------------------  


%% generate sound
if isfield(paras, 'isSliderWav')
    if paras.IsSound 
        Vol =  exp(A/2);
        for ii = 1:3
%         
%         
%         
% %        set(paras.axesFluence,'visible','off')
%        %%%%%%%%%%%  remove plot %%%%%%%%%%%%
%            cla
% hold on
% %title('fluence field for laser 1')
% % set(gca,'Ydir','reverse')
% % xlabel('rho [mm]')
% % ylabel('z [mm]')
% 
% surf(X,Y,low_F*ones(size(X)));
% shading interp;
% 
% axis([-45, 45, 0, 60, low, high]);
%  view(0, 90);
%  colormap(hot);
%  
% caxis([low high])

generate_sound(Vol);
% plot3(vessel.r,vessel.z,high, 'Marker', 'o','MarkerSize',10,...
%     'MarkerFaceColor', vesselColor, 'MarkerEdgeColor', 'r')
% drawnow;

       %%%%%%%%%% remove plot end %%%%%%%%%%
       
    %%%%%%%%%%%%% plot again %%%%%%%%%%%
%     cla
% hold on
%  
% surf(X,Y,F);
% shading interp;
% 
% axis([-45, 45, 0, 60, low, high]);
%  
%  view(0, 90);
%  colormap(hot);
%  
% caxis([low high])
% 
% 
% plot3(vessel.r,vessel.z,high, 'Marker', 'o','MarkerSize',10,...
%     'MarkerFaceColor', vesselColor, 'MarkerEdgeColor', 'r')
% drawnow;
%%%%%%%%%%%%%%%%%%% plot again end %%%%%%%%%%%%
%        pause(0.01)
       
       
        end
    end
end
end

function generate_sound(A)
    amp = [1 0.5 0.25 0.125 0.125/2] .*0.8;
    freq = [110 220 330 440 550]/4;
    x = -1:0.002:1;
    Y = 0;
    for ii = 1: 5

        Y = Y + amp(ii)*sin(x.*freq(ii)*2*pi) .* gaussmf(x,[0.8 0]);
    end
%     space = zeros(1,501);
%     Y = [Y space  Y space   Y  ];
    %%

    Y = Y.*A;
 
    player = audioplayer(Y ,8192);
    play(player);
 pause(0.01)
end
