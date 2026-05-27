%$ (c) Jan Modersitzki 2009/03/24, see FAIR.2 and FAIRcopyright.m.
%$ note: '%$' is used so hide comments in the book                              

FAIRfigure(1,'color','w','position',300); clf
tt = linspace(-3,11,1001);
p1 = plot(tt,spline1D(0,tt)); hold on; axis([-3,12,0,1])
set(p1,'linewidth',3,'color','k')
p2 = plot(tt,spline1D(2,tt),'--');
p3 = plot(tt,spline1D(7,tt),'--');
set([p2;p3],'linestyle','--','linewidth',1.5,'color','k'); axis off;
