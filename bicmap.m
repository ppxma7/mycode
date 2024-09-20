

tmp = inferno(64 + 16);  tmp = tmp([1:64] + 16,:);
colormap([gray(64); tmp])
%%
tmp = viridis(64 + 16);  tmp = tmp([1:64] + 16,:);
colormap([gray(64); tmp])


