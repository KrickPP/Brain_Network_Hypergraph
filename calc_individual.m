%% 导入每个人的关联矩阵
clear;
load('Data\\COBRE_inc_mat.mat');
%% 参数设置
dataSize = size(inc_mat);
num_subjects = dataSize(3);
num_node = dataSize(1);

%% 计算每个人的邻接张量
adj_all = cell(num_subjects, 1);

for i = 1:num_subjects
    adj_all{i} = inc_to_adj(inc_mat(:, :, i));
end
save('Data\\adj_all.mat', 'adj_all');
%% 对每个人都进行正交CP分解
order = num_node; % 32阶
T_all = cell(num_subjects, 1);
lambda_all = zeros(num_node, num_subjects);
U_aver_all = zeros(num_node, num_node, num_subjects);

% 每个人分解多次，选最佳结果
% 控制组选lambda尽量短的，患者组选长的（进行测试）
dec_times = 1;
for i = 1:74
    [T_all{i}, fit] = CP_ORTHO(adj_all{i}, order);
    curr_dec = T_all{i};
    lambda_all(:, i) = T_all{i}.lambda;
    curr_length = sum(lambda_all(:, i) ~= 0);
    while dec_times <= 3
        [T_all{i}, fit] = CP_ORTHO(adj_all{i}, order);
        next_dec = T_all{i};
        lambda_all(:, i) = T_all{i}.lambda;
        next_length = sum(lambda_all(:, i) ~= 0);
        if next_length < curr_length
            % 新分解更短，保留新分解，否则保留旧分解
            curr_dec = next_dec;
        end
        
        dec_times = dec_times +1;
    end
    dec_times = 1;
    % 将三个分量取平均
    U = curr_dec.U;
    lambda_all(:, i) = curr_dec.lambda;
    U_aver_all(:, :, i) = (U{1} + U{2} + U{3}) / 3;
    
    fprintf('The %3dth subject CP_ORTHO Done.\n', i);
    
end
% 患者组
for i = 75:145
    [T_all{i}, fit] = CP_ORTHO(adj_all{i}, order);
    curr_dec = T_all{i};
    lambda_all(:, i) = T_all{i}.lambda;
    curr_length = sum(lambda_all(:, i) ~= 0);
    while dec_times <= 3
        [T_all{i}, fit] = CP_ORTHO(adj_all{i}, order);
        next_dec = T_all{i};
        lambda_all(:, i) = T_all{i}.lambda;
        next_length = sum(lambda_all(:, i) ~= 0);
        if next_length < curr_length
            % 新分解更短，保留新分解，否则保留旧分解
            curr_dec = next_dec;
        end
        
        dec_times = dec_times +1;
    end
    dec_times = 1;
    % 将三个分量取平均
    U = curr_dec.U;
    lambda_all(:, i) = curr_dec.lambda;
    U_aver_all(:, :, i) = (U{1} + U{2} + U{3}) / 3;
    
    fprintf('The %3dth subject CP_ORTHO Done.\n', i);
    
end

save('T_all', 'T_all');
save('lambda_all', 'lambda_all');
save('U_aver_all', 'U_aver_all');
fprintf('All Subjects CP_ORTHO Done and Saved.\n');
datestr(now)
%% 每个人都计算傅里叶变换
s_fourier = zeros(num_node, num_subjects);

for i = 1:num_subjects
    % 每个受试者的时间序列，长度*节点数
    timeseries = ROI_time_series(:, :, i);

    % 计算信号的功率，作为一个脑区的信号
    power = mean(timeseries.^2); % 每列是一个脑区的信号,power是1*N

    % 使用绝对值的均值
%     power = mean(abs(timeseries));

    % V 即[f1 f2 f3 ... fN]^T
    s = power';
    V = U_aver_all(:,:,i)';
    s_fourier(:, i) = (V * s).^2;
    fprintf('The %3dth subject Fourier Done.\n', i);
end

%% 傅里叶变换结果绘图
figure
imagesc(s_fourier, [0, 15]);
colorbar;
title('fourier transform')

%% 分类数据
label = [zeros(74, 1); ones(71, 1)];
cobre_train = [lambda_all', label];
