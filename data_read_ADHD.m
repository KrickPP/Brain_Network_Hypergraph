%% 读取脑区数据 原始数据
% 32脑区
data_path = 'D:\QQ_files\ADHD';

num_subjects = 147;
ROI_num = 32;
ROI_time_series = cell(1, ROI_num, num_subjects);

for i = 1:num_subjects
    load(fullfile(data_path, sprintf('ROI_Subject%03d_Session001.mat', i)));
    ROI_time_series(:, :, i) = data(4:35);
    fprintf('ROI_Subject%03d_Session001.mat has been read.\n', i);
end

save('ADHD\\ADHD_32.mat', 'ROI_time_series');


%% 132脑区
data_path = 'D:\QQ_files\ADHD';

num_subjects = 147;
ROI_num = 132;
ROI_time_series = cell(1, ROI_num, num_subjects);

for i = 1:num_subjects
    load(fullfile(data_path, sprintf('ROI_Subject%03d_Session001.mat', i)));
    ROI_time_series(:, :, i) = data(36:167);
    fprintf('ROI_Subject%03d_Session001.mat has been read.\n', i);
end

%% 统计长度
% load('AD_132.mat')
% num_subjects = 54;
time_series = cell(1,32);
length = zeros(num_subjects, 1);

for i = 1:num_subjects
    time_series = ROI_time_series(:,:,i);
    length(i) = size(time_series{1,1}, 1);
end