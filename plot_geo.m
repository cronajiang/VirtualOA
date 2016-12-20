%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot_geo.m
%   plot current model 
%   input: vessel_pos, probe_pos,num_probes
%         
%   author: jingjing Jiang  cronajiang@gmail.com
%   created: 01.02.2016
%   modified: 07.03.2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function plot_geo(vessel_pos, probe_pos,num_probes)

vessel.r = vessel_pos(1,1);
vessel.z = vessel_pos(1,2);
probe(1).r = probe_pos(1,1);
probe(1).z = probe_pos(1,2);
cla
hold on
set(gca,'Ydir','reverse')
bound.r = [-45, 45]; % r --> rho
bound.z = [-10,60];
xlim(bound.r);
ylim(bound.z);
xlabel('rho [mm]')
ylabel('z [mm]')
% draw tissue volume
rectangle('Position',[-45 0 90 60], 'FaceColor' ,[0.5 0.5 1])
text(-15,40,'Bulk','HorizontalAlignment','right','Color','k')

% draw distance
draw_dis(probe(1),vessel)

% boundaries
plot([bound.r(1):1:bound.r(2)],zeros(1,bound.r(2)-bound.r(1)+1), '-k');

% vessel
plot(vessel.r,vessel.z, 'Marker', 'o','MarkerSize',8, 'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'r')
text(vessel.r+15,vessel.z+5,'Blood vessel','HorizontalAlignment','right','Color','k')
str_coor = ['(' num2str(vessel.r) ',' num2str(vessel.z) ')'];
text(probe(1).r+6,vessel.z+10,str_coor,'HorizontalAlignment','right','Color','k')

%probe 1
plot(probe(1).r,probe(1).z, 'Marker', 'o','MarkerSize',6, 'MarkerFaceColor', 'k', 'MarkerEdgeColor', 'k')
text(probe(1).r+6,probe(1).z-7,'Probe 1','HorizontalAlignment','right','Color','k')
str_coor = ['(' num2str(probe(1).r) ',' num2str(probe(1).z) ')'];
text(probe(1).r+2,probe(1).z-3,str_coor,'HorizontalAlignment','right','Color','k')


if num_probes > 1
    probe(2).r = probe_pos(2,1);
    probe(2).z =probe_pos(2,2);  
    % draw distance
    draw_dis(probe(2),vessel)
    plot(probe(2).r,probe(2).z, 'Marker', 'o','MarkerSize',6, 'MarkerFaceColor', 'k', 'MarkerEdgeColor', 'k')
    text(probe(2).r+6,probe(2).z - 7,'Probe 2','HorizontalAlignment','right','Color','k')
    str_coor = ['(' num2str(probe(2).r) ',' num2str(probe(2).z) ')'];
    text(probe(2).r+6,probe(2).z-3,str_coor,'HorizontalAlignment','right','Color','k')
end   
if num_probes>2
allProbes_r = linspace(probe(1).r, probe(2).r, num_probes);
plot(allProbes_r(2:end-1),0,'Marker', 'o','MarkerSize',5, 'MarkerFaceColor', 'k', 'MarkerEdgeColor', 'k')
end
 
% draw distance
function draw_dis(p1,p2)
x1 = p1.r;
y1 = p1.z;
x2 = p2.r;
y2 = p2.z;
dis = sqrt((x1-x2)^2+(y1-y2)^2);
if x1==x2;
    plot([x1,x1],[min(y1,y2),max(y1,y2)], '-','LineWidth',1)
else
    x = [min(x1,x2):max(x1,x2)];
    y = (y1-y2)/(x1-x2)*(x-x1) + y1;
    plot(x, y, '-','LineWidth',1)
end

text((x1+x2)/2,(y1+y2)/2,num2str(dis),'HorizontalAlignment','left','Color','b')
axis on
 