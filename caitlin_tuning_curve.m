x = [20 50 80 130 200];
x2 = [x,x]';
y_arm = [2 1.8 1.8 1.5 1.4];
y_hand = [1.5 1.4 1.4 1.3 1.3];
y = [y_arm,y_hand]';
arm = repmat({'arm'},length(y_arm),1);
hand = repmat({'hand'},length(y_arm),1);
armhand = [arm;hand];
clear g
figure
g = gramm('x',x2,'y',y,'color',armhand);
g.geom_point()
g.set_names('x','Frequency (Hz)','y','Levels (amplitude AU)')
g.set_text_options('Font','Helvetica', 'base_size', 16)
g.set_point_options('base_size',12)
%g.axe_property('XGrid','on','YGrid','on','YLim',[0 aa], 'XLim',[0 aa],'DataAspectRatio',[1 1 1])
%g.axe_property('XGrid','on','YGrid','on','DataAspectRatio',[1 1 1])
%g.set_order_options('x',0)
%g.set_color_options('map',mycmap)
g.draw
% 
% x = 0:10;
% y = 0:10;
g.update('x',x2,'y',y)
g.stat_fit('fun',@(a,b,c,x)a./(x+b)+c,'intopt','functional');
g.set_title('stat_fit()');
%g.set_color_options('map',[0.5 0.5 0.5])
g.no_legend()
g.draw

filename = sprintf(['caitlin_tuning_curve.pdf'],'%s%s');
    g.export('file_name',filename, ...
        'export_path',...
        '/Users/ppzma/The University of Nottingham/Michael_Sue - General/caitlin/',...
        'file_type','pdf')