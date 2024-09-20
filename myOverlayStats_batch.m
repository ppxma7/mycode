function[]=myOverlayStats_batch(pattern)
clear matches*
v = viewGet([], 'view', 1);

saveD = 0;
% by not saving dd struct from mrTools we can save dozens of megabytes

allROIs = v.ROIs;

o = viewGet(v, 'overlays');
dd = viewGet(v, 'd');
ex = extractfield(o, 'name');
ex = ex';
% check if we are looking at prf or tw scan
prfpos = strcmpi(ex, 'prefDigit');
twpos = strcmpi(ex, 'co');
glmpos = any(contains(ex,'Z'));

isprf = prfpos(prfpos==1);
istw = twpos(twpos==1);

curScan = viewGet(v,'curscan');

if nargin < 1
    error('Please specify the regexp pattern, either l, m or r')
end

if strcmpi(pattern,'l')
    pattern = 'D[1-5]lBA(?:3[ab12]|2|1)l';
elseif strcmpi(pattern,'m')
    %pattern = 'D[1-5]mBA(?:3[ab12]|2|1)';
    pattern = 'D[1-5]mBA(?:3[ab12]|2|1|4[ap]|6)'; % for extra brodmann areas
elseif strcmpi(pattern,'r')
    pattern = 'D[1-5]BA(?:3[ab12]|2|1)';
else
    error('woops, the pattern is either l, r, or m, no other letters')
end

for jj = 1:length(allROIs)
    str = allROIs(jj).name;
    %pattern = 'D[1-5]lBA(?:3[ab12]|2|1)l';
    %pattern = 'D[1-5]mBA(?:3[ab12]|2|1)';
    %pattern =
    matches{jj} = regexp(str, pattern, 'match');
    matches_clean = matches(~cellfun('isempty',matches));
    matches_clean = matches_clean(:); %vectorise
end

for kk = 1:length(allROIs)
    for kkx = 1:length(matches_clean)
        test(kk,kkx) = contains(allROIs(kk).name,matches_clean{kkx}{1});

    end
end

testDex = sum(test,2);
testDex = logical(testDex);
theseROIs = allROIs(testDex);


for rr = 1:length(theseROIs)
    v = viewGet([], 'view', 1);
    thisname = theseROIs(rr).name;
    fprintf('using roi: %s\n', thisname);
    xform = viewGet(v, 'scan2roi');
    theseROIs(rr).scanCoords = getROICoordinates(v,theseROIs(rr),curScan);
    datasz = size(o(1).data{curScan});
    idx = sub2ind(datasz, theseROIs(rr).scanCoords(1,:)',  theseROIs(rr).scanCoords(2,:)',  theseROIs(rr).scanCoords(3,:)' );
    rawcoords = getfield(theseROIs(rr), 'coords');
    rawcoords = rawcoords(1:3,:);

    if isprf

        prf_overlays = zeros(length(idx), length(o));

        for ii = 1:length(o)
            prf_overlays(:,ii) = o(ii).data{curScan}(idx);
        end

        thisA = viewGet(v,'analysis');
        if saveD == 0
            filename = [thisname '_' thisA.name];
            save(filename,'prf_overlays', 'ex', 'rawcoords', 'idx'); %
            %COMMENT ^THIS^ FOR DEBUGGING
        else
            filename = input('Save name?', 's');
            save(filename,'prf_overlays', 'ex', 'dd', 'rawcoords', 'idx');
        end


    elseif istw
        coamph = 3;
        tw_overlays = zeros(length(idx), coamph);

        for ii = 1:coamph
            tw_overlays(:,ii) = o(ii).data{curScan}(idx);
        end


        coherenceMap = o(1).data{1};
        phaseMap = o(3).data{1};

        filename = input('Save name?', 's');
        save(filename,'tw_overlays', 'ex', 'dd', 'idx', 'datasz');
    end

end


end

