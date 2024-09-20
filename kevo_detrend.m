cd /Volumes/hades/brain_acq_analysis_demo_feb2020/data/
[data, hdr] = cbiReadNifti('p23.img');
nX = size(data,1);
nY = size(data,2);
nS = size(data,3);
nV = size(data,4);

im_data = data;

reshaped_data = reshape(im_data,nX*nY*nS,nV);
% The next thing to do is to make a GLM, with just a linear and quadratic regressor (see Hutton et al. Neuroimage
% 2011) i.e. solve
% 
% Y = X*betas + error
% 
% Where X has the model - otherwise known as the design matrix
% and betas is a column vector that has the co-efficients for the elements in the design matrix (to be estimated)



% X1 =[1:nV].';X2 = X1.^2;
% X = [ones(size(X1)),X1,X2]; %Design matrix
% P = (X'*X)\X'; % Proj. matrix (also pinv(X))  could also 
% betas = P*(reshaped_data.');
%betas_oneline = X \ reshaped_data';
% Now remove the linear and quadratic trend only..
%detrended_data = (reshaped_data.' - X(:,2:3)*betas(2:3,:)).';

detrended_data = detrend(reshaped_data);

im_data = reshape(detrended_data,nX,nY,nS,nV);

mymean = mean(im_data,4);

im_data_dm = im_data - mymean;
% Now this is standard...

t = 1:size(im_data,4);
figure
%%
figure
%bla = mean(im_data_dm,4);
mysignal = squeeze(im_data(100,65,19,:));
mysignal_sm = smoothdata(mysignal,1,'gaussian',5);
plot(t,mysignal)
hold on
figure
plot(t,mysignal_sm)
%hold on
% hold on
% for ii = 25:45
%     for jj= 50:70
%         subplot(20,20,
%         plot(t,squeeze(im_data_dm(ii,jj,12,:)))
%     end
%     
% end

%tsnrData=mean(im_data,4)./std(im_data,1,4);

