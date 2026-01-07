savedgroup = 'compare_dti_values_between_scan_sequences';
mypath = ['/Users/' userName '/Library/CloudStorage/OneDrive-SharedLibraries-TheUniversityofNottingham/Michael_Sue - General/AFIRM_SASHB_NEXPO/dti_data/' savedgroup '/'];

vm_nexpo = load(fullfile(mypath,'vm_nexpo_fa.mat'));
vm_chain = load(fullfile(mypath,'vm_chainafirmsash_fa.mat'));
vm_nexpo_md = load(fullfile(mypath,'vm_nexpo_md.mat'));
vm_chain_md = load(fullfile(mypath,'vm_chainafirmsash_md.mat'));


vm_nexpo_fa  = vm_nexpo.vm;
vm_chain_fa = vm_chain.vm;
vm_nexpo_md  = vm_nexpo_md.vm;
vm_chain_md = vm_chain_md.vm;

vmall = [vm_nexpo_fa; vm_chain_fa];
vmallmd = [vm_nexpo_md; vm_chain_md];

grp_nexpo = repmat({'NEXPO'},length(vm_nexpo_data),1);
grp_chain = repmat({'CHAINAFIRMSASHB'},length(vm_chain_data),1);

grpall = [grp_nexpo; grp_chain];

% Process the loaded data (e.g., compute the mean of each dataset)
mean_nexpo = mean(vm_nexpo_fa);
mean_chain = mean(vm_chain_fa);

% Display the computed means
disp(['Mean of vm_nexpo FA: ', num2str(mean_nexpo)]);
disp(['Mean of vm_chain FA: ', num2str(mean_chain)]);

% Process the loaded data (e.g., compute the mean of each dataset)
mean_nexpo = mean(vm_nexpo_md);
mean_chain = mean(vm_chain_md);

% Display the computed means
disp(['Mean of vm_nexpo MD: ', num2str(mean_nexpo)]);
disp(['Mean of vm_chain MD: ', num2str(mean_chain)]);

%%
close all
clear g
figure ('Position',[100 100 400 600])
g = gramm('x',grpall,'y',vmall);
g.stat_boxplot2('drawoutlier',1);
g.set_names('x','Group','y','Mean FA');
%g.set_names('x','ROI','y','Mean T1','color','Group');
%g.set_point_options('base_size',1)
%g.axe_property('XTickLabelRotation',45,'YLim',[0 1],'YGrid','on','XGrid','on');
g.axe_property('XTickLabelRotation',45,'YGrid','on','XGrid','on','YLim',[0.2 0.4]);
g.set_order_options('x',0)

g.draw();
g.export('file_name', ...
    fullfile(mypath,'facomp'), ...
    'file_type','pdf');

close all
clear g
figure ('Position',[100 100 400 600])
g = gramm('x',grpall,'y',vmallmd);
g.stat_boxplot2('drawoutlier',1);
g.set_names('x','Group','y','Mean MD');
%g.set_names('x','ROI','y','Mean T1','color','Group');
%g.set_point_options('base_size',1)
%g.axe_property('XTickLabelRotation',45,'YLim',[0 1],'YGrid','on','XGrid','on');
g.axe_property('XTickLabelRotation',45,'YGrid','on','XGrid','on');
g.set_order_options('x',0)

g.draw();
g.export('file_name', ...
    fullfile(mypath,'mdcomp'), ...
    'file_type','pdf');


