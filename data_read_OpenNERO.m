data_path = 'F:\OpenNERO';

num_subjects = 167;
ROI_num = 132;
time_length = 152;
ROI_time_series = zeros(time_length, ROI_num, num_subjects);

% 4:35是network，36:167是atlas
% 前118control，后49patient，共167
for i = 1:num_subjects
    if i==45  % 第45个长度128
        continue;
    end
    fprintf('The %3dth sunject.\t', i);
    load(fullfile(data_path, sprintf('ROI_Subject%03d_Session001.mat', i)));
    ROI_time_series(:, :, i) = cell2mat(data(1, 36:167));
    fprintf('Done.\n');
end

save('OpenNERO_132.mat', 'ROI_time_series')