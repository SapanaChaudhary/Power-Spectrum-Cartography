% to generate voronoi tesellation
load fin
load latlong2

[x,y] = deg2utm(latlong2(:,1),latlong2(:,2));

%fin = unique(fin,'rows');
xy = [x y];
[sam_x, sam_y] = deg2utm(10.5996400000000,77.0146900000000);

TT=find(sqrt((fin(1:1000,1)-sam_x).^2 +(fin(1:1000,2)-sam_y).^2 ) < 3550);


xgv = fin(TT,1);
ygv= fin(TT,2);
zgv = 10*log10(fin(TT,3)*1000);

[X,Y] = meshgrid(xgv,ygv);
F = scatteredInterpolant(xgv,ygv,zgv);

Z = F(X,Y);
  
hold on
contourf(X,Y,Z,30,'LineStyle','none')
scatter(sam_x,sam_y,'r','filled');
hold on
% scatter(xy(:,1),xy(:,2))
% hold on
axis equal
voronoi(x,y)
scatter(xgv,ygv,'.')
hold on
xlim([7.1650e+05,   7.2356e+05 ])
ylim([1.1690e+06,   1.1759e+06 ])

colorbar

 %scatter(fin(TT,1),fin(TT,2),'k')
