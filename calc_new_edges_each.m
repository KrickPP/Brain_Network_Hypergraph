%% 添加新的超边
% 方法1 从邻接矩阵中找出同时包含两个脑区的公共脑区
edges_ind = cell(200, 3); % 存储新的超边，共有C(32,2)= 496条
adj_all = cell(145, 1); % 存储所有人的新超边
ind = 1; % 新的边的索引

% 将邻接矩阵二值化
thre = 0.5;

for sub = 1:145
    adj_mat = adj_mat_all(:, :, sub);
    adj_mat(adj_mat < thre) = 0;
    adj_mat(logical(eye(32))) = 0; % 对角线元素置零

    for i = 1:31
        rois_i = adj_mat(i, :);

        for j = (i + 1):32
            % adj_mat需要转成二值矩阵(0-1)
            rois_j = adj_mat(j, :);
            roi_common = rois_i .* rois_j; % 同时包含节点i, j的脑区，但不含i,j
            ind_common = find(roi_common);

            if length(ind_common) >= 2
                % 超过两个节点的才算一条边
                edges_ind{ind, 1} = [i, j];
                edges_ind{ind, 2} = ind_common;
                ind = ind + 1;
            end

        end

    end

    % edges_ind空白的删除
    edges_ind(ind:end, :) = [];

    %% 将超边变成三个节点的超边
    for i = 1:length(edges_ind)

        if length(edges_ind{i, 2}) == 2
            % 加一个i节点（先算权重，两节点对i,j权重和，对应adj_mat中4条边）
            edges_ind{i, 3} = sum(adj_mat(edges_ind{i, 1}(1), edges_ind{i, 2}) ...
            + adj_mat(edges_ind{i, 1}(2), edges_ind{i, 2}));
            edges_ind{i, 2} = [edges_ind{i, 1}(1), edges_ind{i, 2}];

        else
            % 取权重加起来最大的三个（没有i或j节点）
            % i_com1 + i_com2权重最大的三个
            weight = adj_mat(edges_ind{i, 1}(1), edges_ind{i, 2}) ...
            + adj_mat(edges_ind{i, 1}(2), edges_ind{i, 2});
            weight_with_ind = [edges_ind{i, 2}', weight'];
            weight_with_ind_sort = sortrows(weight_with_ind, 2, 'descend');

            % 保留最大的三个, 第三列加一列：三节点对i,j权重和(对应adj_mat中6条边)
            edges_ind{i, 2} = weight_with_ind_sort(1:3, 1)';
            edges_ind{i, 3} = sum(weight_with_ind_sort(1:3, 2));
        end

    end

    %% 将新超边转为张量
    % 定义32*32*32的张量
    adj_ts = sptensor(repmat(32, 1, 3));
    % 不去重，重复的覆盖
    % involves = edges_ind(:, 2);
    % involves = unique(cell2mat(involves), 'rows');
    for i = 1:length(edges_ind)
        % 3个节点，有6个排列，写成3*6，按列循环
        inds = perms(edges_ind{i, 2})';

        for ind = inds
            % 六个元素都取为权重
            adj_ts(ind') = edges_ind{i, 3};
        end

    end

    adj_all{sub} = adj_ts;

end


%% 每个人新边 傅里叶变换
rank = 32; % 32阶
num_subjects = 145;
num_node = 32;
T_all = cell(num_subjects, 1);
lambda_all = zeros(num_node, num_subjects);
U_aver_all = zeros(num_node, num_node, num_subjects);

parfor i = 1:num_subjects
    [T_all{i}, fit] = CP_ORTHO(adj_all{i}, rank);

    % 将三个分量取平均
    U = T_all{i}.U;
    lambda_all(:, i) = T_all{i}.lambda;
    U_aver_all(:, :, i) = (U{1} + U{2} + U{3}) / 3;
    
    fprintf('The %3dth subject CP_ORTHO Done.\n', i);
    
end

save('New_edges\T_all', 'T_all');
save('New_edges\lambda_all', 'lambda_all');
save('New_edges\U_aver_all', 'U_aver_all');
fprintf('All Subjects CP_ORTHO Done and Saved.\n');

%% 每个人都计算傅里叶变换
s_fourier = zeros(num_node, num_subjects);

parfor i = 1:num_subjects
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
imagesc(lambda_all, [0, 20]);
colorbar;
title('fourier transform')

%% 分类数据
label = [zeros(74, 1); ones(71, 1)];
cobre_train = [s_fourier', label];