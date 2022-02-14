%% 读取脑区数据 原始数据
data_path = 'D:\Data\code_Du\164_new_data';

num_subjects = 32;
ROI_num = 132;
time_length = 700;
ROI_time_series = zeros(time_length, ROI_num, num_subjects);

% 前16control， 后16patient
for i = 1:num_subjects
    load(fullfile(data_path, sprintf('ROI_Subject%03d_Session001.mat', i)));
    ROI_time_series(:, :, i) = cell2mat(data(1, 36:167));
    fprintf('ROI_Subject%03d_Session001.mat has been read.\n', i);
end

%% 读取去噪后的
data_path = 'D:\Data\code_Du\164_new_data\condition';

num_subjects = 32;
ROI_num = 32;
time_length = 700;
ROI_time_series = zeros(time_length, ROI_num, num_subjects);

% 前16control， 后16patient
for i = 1:num_subjects
    load(fullfile(data_path, sprintf('ROI_Subject%03d_Condition000.mat', i)));
    ROI_time_series(:, :, i) = cell2mat(data(1, 4:35));
    fprintf('ROI_Subject%03d_Condition000.mat has been read.\n', i);
end
save('Original_denoise_32','ROI_time_series')


