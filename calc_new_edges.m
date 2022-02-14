%% 添加新的超边-公共邻居
% 方法1 从邻接矩阵中找出同时包含两个脑区的公共脑区
edges_ind = cell(200, 3); % 存储新的超边，共有C(32,2)= 496条
ind = 1; % 新的边的索引

% 将邻接矩阵二值化
% 两组平均
thre = 0.55;
adj_mat_c = mean(adj_mat_all(:, :, 1:74), 3);
adj_mat_p = mean(adj_mat_all(:, :, 75:end), 3);
adj_mat_c(adj_mat_c < thre) = 0;
adj_mat_p(adj_mat_p < thre) = 0;
adj_mat_c(logical(eye(32))) = 0;    % 对角线元素置零
adj_mat_p(logical(eye(32))) = 0;

for i = 1:31
    rois_i = adj_mat_c(i, :);
    for j = (i + 1):32
        % adj_mat需要转成二值矩阵(0-1)
        rois_j = adj_mat_c(j, :);
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
        edges_ind{i, 3} = sum(adj_mat_c(edges_ind{i, 1}(1), edges_ind{i, 2}) ...
            + adj_mat_c(edges_ind{i, 1}(2), edges_ind{i, 2}));
        edges_ind{i, 2} = [edges_ind{i, 1}(1), edges_ind{i, 2}];
        
    else
        % 取权重加起来最大的三个（没有i或j节点）
        % i_com1 + i_com2权重最大的三个
        weight = adj_mat_c(edges_ind{i, 1}(1), edges_ind{i, 2}) ...
            + adj_mat_c(edges_ind{i, 1}(2), edges_ind{i, 2});
        weight_with_ind = [edges_ind{i, 2}', weight'];
        weight_with_ind_sort = sortrows(weight_with_ind, 2, 'descend');
        
        % 保留最大的三个, 第三列加一列：三节点对i,j权重和(对应adj_mat中6条边)
        edges_ind{i, 2} = weight_with_ind_sort(1:3, 1)';
        edges_ind{i, 3} = sum(weight_with_ind_sort(1:3, 2));
    end
end

%% 将新超边转为张量
% 定义32*32*32的张量
adj_ts_c = sptensor(repmat(32, 1, 3));
% 不去重，重复的覆盖
% involves = edges_ind(:, 2);
% involves = unique(cell2mat(involves), 'rows');
for i = 1:length(edges_ind)
    % 3个节点，有6个排列，写成3*6，按列循环
    inds = perms(edges_ind{i, 2})';
    for ind = inds
        % 六个元素都取为权重
        adj_ts_c(ind') = edges_ind{i, 3};
    end
end


%% 对P组同样的操作
edges_ind = cell(200, 3); % 存储新的超边，共有C(32,2)= 496条
ind = 1; % 新的边的索引

for i = 1:31
    rois_i = adj_mat_p(i, :);
    for j = (i + 1):32
        % adj_mat需要转成二值矩阵(0-1)
        rois_j = adj_mat_p(j, :);
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
        edges_ind{i, 3} = sum(adj_mat_p(edges_ind{i, 1}(1), edges_ind{i, 2}) ...
            + adj_mat_p(edges_ind{i, 1}(2), edges_ind{i, 2}));
        edges_ind{i, 2} = [edges_ind{i, 1}(1), edges_ind{i, 2}];
        
    else
        % 取权重加起来最大的三个（没有i或j节点）
        % i_com1 + i_com2权重最大的三个
        weight = adj_mat_p(edges_ind{i, 1}(1), edges_ind{i, 2}) ...
            + adj_mat_p(edges_ind{i, 1}(2), edges_ind{i, 2});
        weight_with_ind = [edges_ind{i, 2}', weight'];
        weight_with_ind_sort = sortrows(weight_with_ind, 2, 'descend');
        
        % 保留最大的三个, 第三列加一列：三节点对i,j权重和(对应adj_mat中6条边)
        edges_ind{i, 2} = weight_with_ind_sort(1:3, 1)';
        edges_ind{i, 3} = sum(weight_with_ind_sort(1:3, 2));
    end
end

%% 将新超边转为张量
% 定义32*32*32的张量
adj_ts_p = sptensor(repmat(32, 1, 3));
% 不去重，重复的覆盖
% involves = edges_ind(:, 2);
% involves = unique(cell2mat(involves), 'rows');
for i = 1:length(edges_ind)
    % 3个节点，有6个排列，写成3*6，按列循环
    inds = perms(edges_ind{i, 2})';
    for ind = inds
        % 六个元素都取为权重
        adj_ts_p(ind') = edges_ind{i, 3};
    end
end

% 变量已在基础工作区中创建。
% Structure  'Tree_74' exported from Classification Learner. 
% To make predictions on a new predictor column matrix, X: 
%   yfit = Tree_74.predictFcn(X) 
% For more information, see How to predict using an exported model.



