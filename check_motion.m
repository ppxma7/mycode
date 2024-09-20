% check motion

mypath = '/Volumes/hermes/pain_03_11251_221129/processed_data/preCap/';
mypath2 = '/Volumes/hermes/pain_03_11251_221129/processed_data/postCap/';


aa = 'rp_parrec_thermode_block1_20221129091505_11_nordic_clv_toppedupabs.txt';
bb = 'rp_parrec_thermode_block2_20221129091505_12_nordic_clv_toppedupabs.txt';
cc = 'rp_parrec_thermode_armblock1_20221129091505_15_nordic_clv_toppedupabs.txt';
dd = 'rp_parrec_thermode_armblock2_20221129091505_16_nordic_clv_toppedupabs.txt';
ee = 'rp_parrec_PTSarm_20221129091505_14_nordic_clv_toppedupabs.txt';
ff = 'rp_parrec_PTShand_20221129091505_17_nordic_clv_toppedupabs.txt';

gg = 'rp_parrec_thermode_armblock1_20221129122548_8_nordic_clv_toppedupabs.txt';
hh = 'rp_parrec_thermode_armblock2_20221129122548_9_nordic_clv_toppedupabs.txt';
ii = 'rp_parrec_PTSarm_20221129122548_11_nordic_clv_toppedupabs.txt';


% mypath = '/Volumes/hermes/pain_02_15435_221117/processed_data/preCap/';
% mypath2 = '/Volumes/hermes/pain_02_15435_221117/processed_data/postCap/';
% 
% 
% aa = 'rp_parrec_thermode_block1_20221117143136_9_nordic_clv_toppedupabs.txt';
% bb = 'rp_parrec_thermode_block2_20221117143136_10_nordic_clv_toppedupabs.txt';
% cc = 'rp_parrec_thermode_armblock1_20221117143136_14_nordic_clv_toppedupabs.txt';
% dd = 'rp_parrec_thermode_armblock2_20221117143136_15_nordic_clv_toppedupabs.txt';
% ee = 'rp_parrec_PTSarm_20221117143136_12_nordic_clv_toppedupabs.txt';
% ff = 'rp_parrec_PTShand_20221117143136_16_nordic_clv_toppedupabs.txt';
% 
% gg = 'rp_postcap_thermode_armblock1_20221129112341_8_nordic_clv_toppedupabs.txt';
% hh = 'rp_postcap_thermode_armblock2_20221129112341_9_nordic_clv_toppedupabs.txt';
% ii = 'rp_postcap_PTSarm_20221129112341_11_nordic_clv_toppedupabs.txt';


aa_load = load([mypath aa]);
bb_load = load([mypath bb]);
cc_load = load([mypath cc]);
dd_load = load([mypath dd]);
ee_load = load([mypath ee]);
ff_load = load([mypath ff]);
gg_load = load([mypath2 gg]);
hh_load = load([mypath2 hh]);
ii_load = load([mypath2 ii]);

figure, plot(aa_load)
hold on
plot(bb_load)
plot(cc_load)
plot(dd_load)
plot(ee_load)
plot(ff_load)
plot(gg_load)
plot(hh_load)
plot(ii_load)










