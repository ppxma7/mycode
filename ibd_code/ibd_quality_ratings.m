temp = spm_select(Inf,'any', 'Select cat12 quality indicator files');
all = cell(size(temp,1),3);
for ii = 1:size(temp,1)
    
    curr     = load(deblank(temp(ii,:)));
    all{ii,1} = deblank(temp(ii,:));
    all{ii,2} = min(100,max(0,105 - curr.S.qualityratings.IQR*10));
    
    all{ii,3} = 5;
    
end

%%
rtings = cell2mat(all(:,2));
disp(mean(rtings))
disp(std(rtings))