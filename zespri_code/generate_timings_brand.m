% generate timing file for brand kiwi zespri fMRI SPM

% myconds = 12;
% 
% names = cell(1,myconds);
% onsets = cell(1,myconds);
% durations = cell(1,myconds);

%% timings
subject1=[3	353	143	213	38	178	73	388	248	318	108	283	19	369	159	229	54	194	89	404	264	334	124	299];

subject2=[178	38	353	3	143	108	318	248	388	73	213	283	194	54	369	19	159	124	334	264	404	89	229	299];

subject3=[73	178	3	143	38	283	108	318	388	213	248	353	89	194	19	159	54	299	124	334	404	229	264	369];

subject4=[283	73	3	38	143	108	388	353	213	248	178	318	299	89	19	54	159	124	404	369	229	264	194	334];

subject5=[38	3	108	73	248	143	318	388	213	353	283	178	54	19	124	89	264	159	334	404	229	369	299	194];

subject6=subject5;

subject7=[108	73	213	248	38	3	143	178	353	283	318	388	124	89	229	264	54	19	159	194	369	299	334	404];

subject9=[143	3	73	38	108	213	283	388	248	178	318	353	159	19	89	54	124	229	299	404	264	194	334	369];

subject10=subject7;

subject11=[213	73	3	38	143	178	283	318	353	108	248	388	229	89	19	54	159	194	299	334	369	124	264	404];

subject12=[3	318	178	108	73	38	143	388	248	283	213	353	19	334	194	124	89	54	159	404	264	299	229	369];

subject13=[108	38	143	73	3	178	318	353	248	283	213	388	124	54	159	89	19	194	334	369	264	299	229	404];

subject14=subject11;


%% timings, but baseline as single regressor




% subject1=[3	353	143	213	38	178
% 7	357	147	217	42	182
% 11	361	151	221	46	186
% 15	365	155	225	50	190
% 19	369	159	229	54	194
% 23	373	163	233	58	198
% 27	377	167	237	62	202
% 31	381	171	241	66	206
% 73	388	248	318	108	283
% 77	392	252	322	112	287
% 81	396	256	326	116	291
% 85	400	260	330	120	295
% 89	404	264	334	124	299
% 93	408	268	338	128	303
% 97	412	272	342	132	307
% 101	416	276	346	136	311];
% 
% baseline_subject1 = subject1+2;
% baseline_subject1_t = transpose(baseline_subject1(:));
% baseline_subject1_t = sort(baseline_subject1_t);
% baseline_subject1_t = num2cell(baseline_subject1_t);
% 
% % Try this for one subject
% onsets_subject1 = transpose(subject1(:));
% onsets_subject1 = num2cell(onsets_subject1);
% 
% onsets = [onsets_subject1 baseline_subject1_t];
% %onsets = onsets_subject1;
% 
% numSamples = 16; %16
% kiwi_names = {'Green Brand Image','Red Brand Image','Gold Brand Image','Green Unbrand Image','Red Unbrand Image','Gold Unbrand Image'};
% kiwi_names = repmat(kiwi_names,numSamples,1);
% kiwi_names = transpose(kiwi_names(:));
% 
% baseline_names = {'Blur'};
% baseline_names = repmat(baseline_names,1,length(kiwi_names));
% 
% names = [kiwi_names baseline_names];
% %names = kiwi_names;
% 
% durations = {1.6};
% %durations = {16};
% durations = repmat(durations,1,length(names));
% 
% save subject1_timings.mat onsets durations names



%% names

%numSamples = 14; %16
names = {'Green Brand Image','Red Brand Image','Gold Brand Image','Green Unbrand Image','Red Unbrand Image','Gold Unbrand Image',...
    'Green Brand Image','Red Brand Image','Gold Brand Image','Green Unbrand Image','Red Unbrand Image','Gold Unbrand Image',...
    'Green Brand Blur','Red Brand Blur','Gold Brand Blur','Green Unbrand Blur','Red Unbrand Blur','Gold Unbrand Blur',...
    'Green Brand Blur','Red Brand Blur','Gold Brand Blur','Green Unbrand Blur','Red Unbrand Blur','Gold Unbrand Blur'};
names = names(:);
%names = repmat(names,numSamples,1);
% names = transpose(names(:));

%% durations
durations = {16};
%durations = {16};
durations = repmat(durations,length(names),1);
%% manipulate
onsets_subject1 = subject1(:);
onsets_subject1 = num2cell(onsets_subject1);
onsets = onsets_subject1;
save subject1_timings.mat onsets durations names

onsets_subject2 = subject2(:);
onsets_subject2 = num2cell(onsets_subject2);
onsets = onsets_subject2;
save subject2_timings.mat onsets durations names

onsets_subject3 = subject3(:);
onsets_subject3 = num2cell(onsets_subject3);
onsets = onsets_subject3;
save subject3_timings.mat onsets durations names

onsets_subject4 = subject4(:);
onsets_subject4 = num2cell(onsets_subject4);
onsets = onsets_subject4;
save subject4_timings.mat onsets durations names

onsets_subject5 = subject5(:);
onsets_subject5 = num2cell(onsets_subject5);
onsets = onsets_subject5;
save subject5_timings.mat onsets durations names

onsets_subject6 = subject6(:);
onsets_subject6 = num2cell(onsets_subject6);
onsets = onsets_subject6;
save subject6_timings.mat onsets durations names

onsets_subject7 = subject7(:);
onsets_subject7 = num2cell(onsets_subject7);
onsets = onsets_subject7;
save subject7_timings.mat onsets durations names

onsets_subject9 = subject9(:);
onsets_subject9 = num2cell(onsets_subject9);
onsets = onsets_subject9;
save subject9_timings.mat onsets durations names

onsets_subject10 = subject10(:);
onsets_subject10 = num2cell(onsets_subject10);
onsets = onsets_subject10;
save subject10_timings.mat onsets durations names

onsets_subject11 = subject11(:);
onsets_subject11 = num2cell(onsets_subject11);
onsets = onsets_subject11;
save subject11_timings.mat onsets durations names

onsets_subject12 = subject12(:);
onsets_subject12 = num2cell(onsets_subject12);
onsets = onsets_subject12;
save subject12_timings.mat onsets durations names

onsets_subject13 = subject13(:);
onsets_subject13 = num2cell(onsets_subject13);
onsets = onsets_subject13;
save subject13_timings.mat onsets durations names

onsets_subject14 = subject14(:);
onsets_subject14 = num2cell(onsets_subject14);
onsets = onsets_subject14;
save subject14_timings.mat onsets durations names

%%
%mylen = 192.*3;
mylen = 2.*12.*3;

% Find indices of 'Green Brand Image' and 'Green Brand Blur' conditions
image_indices = find(strcmp(names, 'Green Brand Image'));
blur_indices = find(strcmp(names, 'Green Brand Blur'));
% Create a contrast vector
contrast_vector = zeros(1, numel(names)); % Initialize with zeros
contrast_vector(image_indices) = 1; % Assign 1 to 'Green Brand Image' conditions
contrast_vector(blur_indices) = -1; % Assign -1 to 'Green Brand Blur' conditions
contrast_vector_green_brand = contrast_vector;

bloop = zeros(1,mylen);
index = 1:3:length(bloop);
bloop(index) = contrast_vector_green_brand;
contrast_vector_green_brand_HRF = bloop;



image_indices = find(strcmp(names, 'Red Brand Image'));
blur_indices = find(strcmp(names, 'Red Brand Blur'));
contrast_vector = zeros(1, numel(names)); % Initialize with zeros
contrast_vector(image_indices) = 1; % Assign 1 to 'Green Brand Image' conditions
contrast_vector(blur_indices) = -1; % Assign -1 to 'Green Brand Blur' conditions
contrast_vector_red_brand = contrast_vector;

bloop = zeros(1,mylen);
index = 1:3:length(bloop);
bloop(index) = contrast_vector_red_brand;
contrast_vector_red_brand_HRF = bloop;



image_indices = find(strcmp(names, 'Gold Brand Image'));
blur_indices = find(strcmp(names, 'Gold Brand Blur'));
contrast_vector = zeros(1, numel(names)); % Initialize with zeros
contrast_vector(image_indices) = 1; % Assign 1 to 'Green Brand Image' conditions
contrast_vector(blur_indices) = -1; % Assign -1 to 'Green Brand Blur' conditions
contrast_vector_gold_brand = contrast_vector;

bloop = zeros(1,mylen);
index = 1:3:length(bloop);
bloop(index) = contrast_vector_gold_brand;
contrast_vector_gold_brand_HRF = bloop;




image_indices = find(strcmp(names, 'Green Unbrand Image'));
blur_indices = find(strcmp(names, 'Green Unbrand Blur'));
contrast_vector = zeros(1, numel(names)); % Initialize with zeros
contrast_vector(image_indices) = 1; % Assign 1 to 'Green Brand Image' conditions
contrast_vector(blur_indices) = -1; % Assign -1 to 'Green Brand Blur' conditions
contrast_vector_green_unbrand = contrast_vector;

bloop = zeros(1,mylen);
index = 1:3:length(bloop);
bloop(index) = contrast_vector_green_unbrand;
contrast_vector_green_unbrand_HRF = bloop;




image_indices = find(strcmp(names, 'Red Unbrand Image'));
blur_indices = find(strcmp(names, 'Red Unbrand Blur'));
contrast_vector = zeros(1, numel(names)); % Initialize with zeros
contrast_vector(image_indices) = 1; % Assign 1 to 'Green Brand Image' conditions
contrast_vector(blur_indices) = -1; % Assign -1 to 'Green Brand Blur' conditions
contrast_vector_red_unbrand = contrast_vector;

bloop = zeros(1,mylen);
index = 1:3:length(bloop);
bloop(index) = contrast_vector_red_unbrand;
contrast_vector_red_unbrand_HRF = bloop;




image_indices = find(strcmp(names, 'Gold Unbrand Image'));
blur_indices = find(strcmp(names, 'Gold Unbrand Blur'));
contrast_vector = zeros(1, numel(names)); % Initialize with zeros
contrast_vector(image_indices) = 1; % Assign 1 to 'Green Brand Image' conditions
contrast_vector(blur_indices) = -1; % Assign -1 to 'Green Brand Blur' conditions
contrast_vector_gold_unbrand = contrast_vector;

bloop = zeros(1,mylen);
index = 1:3:length(bloop);
bloop(index) = contrast_vector_gold_unbrand;
contrast_vector_gold_unbrand_HRF = bloop;


%% Open or create a text file for writing
filename = '/Volumes/hermes/zespri_tasks/spm_analysis/brand_D/contrast_vectors.txt';
fileID = fopen(filename, 'w');

% Write contrast_vector_green_brand_HRF to the text file
fprintf(fileID, '%d ', contrast_vector_green_brand_HRF);
fprintf(fileID, '\n'); % Start a new line for the next variable
fprintf(fileID, '\n');
% Repeat for other variables if needed
fprintf(fileID, '%d ', contrast_vector_red_brand_HRF);
fprintf(fileID, '\n');
fprintf(fileID, '\n');

fprintf(fileID, '%d ', contrast_vector_gold_brand_HRF);
fprintf(fileID, '\n');
fprintf(fileID, '\n');

fprintf(fileID, '%d ', contrast_vector_green_unbrand_HRF);
fprintf(fileID, '\n');
fprintf(fileID, '\n');

fprintf(fileID, '%d ', contrast_vector_red_unbrand_HRF);
fprintf(fileID, '\n');
fprintf(fileID, '\n');

fprintf(fileID, '%d ', contrast_vector_gold_unbrand_HRF);
fprintf(fileID, '\n');
fprintf(fileID, '\n');
% fprintf(fileID, '%d ', next_variable);
% fprintf(fileID, '\n');

% Close the file
fclose(fileID);
%%
filename = '/Volumes/hermes/zespri_tasks/spm_analysis/brand_D/contrast_vectors_nohrf.txt';
fileID = fopen(filename, 'w');

% Write contrast_vector_green_brand_HRF to the text file
fprintf(fileID, '%d ', contrast_vector_green_brand);
fprintf(fileID, '\n'); % Start a new line for the next variable
fprintf(fileID, '\n');
% Repeat for other variables if needed
fprintf(fileID, '%d ', contrast_vector_red_brand);
fprintf(fileID, '\n');
fprintf(fileID, '\n');

fprintf(fileID, '%d ', contrast_vector_gold_brand);
fprintf(fileID, '\n');
fprintf(fileID, '\n');

fprintf(fileID, '%d ', contrast_vector_green_unbrand);
fprintf(fileID, '\n');
fprintf(fileID, '\n');

fprintf(fileID, '%d ', contrast_vector_red_unbrand);
fprintf(fileID, '\n');
fprintf(fileID, '\n');

fprintf(fileID, '%d ', contrast_vector_gold_unbrand);
fprintf(fileID, '\n');
fprintf(fileID, '\n');
% fprintf(fileID, '%d ', next_variable);
% fprintf(fileID, '\n');

% Close the file
fclose(fileID);




