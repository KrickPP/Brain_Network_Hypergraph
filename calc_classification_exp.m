% 分类实验
% 稀疏表示 -- A中权重 -- AC矩阵分类

% 保留几个系数最大的
num_subjects = size(inc_mat, 3);
edge_num = 32;
left_num = 3;   % 保留的个数
involves = cell(32, 145);

for sub = 1:num_subjects
    inc_mat_i = inc_mat(:, :, sub);
    % 每个受试者保留3个节点
    for i = 1:edge_num
        edge_sort = sort(inc_mat_i(:, i), 'descend');
        min_coef = edge_sort(left_num); % 排序后第left_num个系数
        edge = inc_mat_i(:, i);
        edge(edge < min_coef) = 0; % 保留最大的前order个系数
        inc_mat_i(:, i) = edge;
        ind = find(edge); % 非零的索引，即脑区编号
        involves{i, sub} = ind;
    end
    inc_mat(:, :, sub) = inc_mat_i;
end

%% 取邻接矩阵中的系数作为权重
edges_weight = zeros(edge_num, num_subjects);
for sub = 1:num_subjects
    adj_i = adj_mat_all(:,:,sub);
    involve = involves(:,sub);
    for i = 1:edge_num
        edge_ind = involve{i};
        
        edges_weight(i, sub) = sum(adj_i(i, edge_ind));
        
    end
    
end

%% 分类实验2-公共邻居分类
num_subjects = size(adj_mat_all, 3);
edges_all = cell(num_subjects, 1);
for sub = 1:num_subjects
    adj_mat_i = adj_mat_all(:,:,sub);
    adj_mat_i(adj_mat_i < 0.6) = 0;
    edges_ind = cell(200, 3); % 存储新的超边，共有C(32,2)= 496条
    ind = 1; % 新的边的索引
    for i = 1:31
        rois_i = adj_mat_i(i, :);
        for j = (i + 1):32
            % adj_mat需要转成二值矩阵(0-1)
            rois_j = adj_mat_i(j, :);
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

    % 将超边变成三个节点的超边
    for i = 1:length(edges_ind)
        if length(edges_ind{i, 2}) == 2
            % 加一个i节点（先算权重，两节点对i,j权重和，对应adj_mat中4条边）
            edges_ind{i, 3} = sum(adj_mat_i(edges_ind{i, 1}(1), edges_ind{i, 2}) ...
                + adj_mat_i(edges_ind{i, 1}(2), edges_ind{i, 2}));
            edges_ind{i, 2} = [edges_ind{i, 1}(1), edges_ind{i, 2}];

        elseif length(edges_ind{i, 2}) == 3
            % 取权重加起来最大的三个（没有i或j节点）
            % i_com1 + i_com2权重最大的三个
            weight = adj_mat_i(edges_ind{i, 1}(1), edges_ind{i, 2}) ...
                + adj_mat_i(edges_ind{i, 1}(2), edges_ind{i, 2});
            weight_with_ind = [edges_ind{i, 2}', weight'];
            weight_with_ind_sort = sortrows(weight_with_ind, 2, 'descend');

            % 保留最大的三个, 第三列加一列：三节点对i,j权重和(对应adj_mat中6条边)
            edges_ind{i, 2} = weight_with_ind_sort(1:3, 1)';
            edges_ind{i, 3} = sum(weight_with_ind_sort(1:3, 2));
            
        elseif length(edges_ind{i, 2}) == 4
            % 取权重加起来最大的4个（没有i或j节点）
            % i_com1 + i_com2权重最大的4个
            weight = adj_mat_i(edges_ind{i, 1}(1), edges_ind{i, 2}) ...
                + adj_mat_i(edges_ind{i, 1}(2), edges_ind{i, 2});
            weight_with_ind = [edges_ind{i, 2}', weight'];
            weight_with_ind_sort = sortrows(weight_with_ind, 2, 'descend');

            % 保留最大的三个, 第三列加一列：三节点对i,j权重和(对应adj_mat中6条边)
            edges_ind{i, 2} = weight_with_ind_sort(1:4, 1)';
            edges_ind{i, 3} = sum(weight_with_ind_sort(1:4, 2));
        elseif length(edges_ind{i, 2}) >= 5
            % 取权重加起来最大的4个（没有i或j节点）
            % i_com1 + i_com2权重最大的4个
            weight = adj_mat_i(edges_ind{i, 1}(1), edges_ind{i, 2}) ...
                + adj_mat_i(edges_ind{i, 1}(2), edges_ind{i, 2});
            weight_with_ind = [edges_ind{i, 2}', weight'];
            weight_with_ind_sort = sortrows(weight_with_ind, 2, 'descend');

            % 保留最大的三个, 第三列加一列：三节点对i,j权重和(对应adj_mat中6条边)
            edges_ind{i, 2} = weight_with_ind_sort(1:5, 1)';
            edges_ind{i, 3} = sum(weight_with_ind_sort(1:5, 2));
        end
    end
    edges_all{sub, 1} = edges_ind;

end

%% 转成H矩阵
H_all = cell(145, 1);
w_all = cell(145, 1);

for sub = 1:145
    edges_i = edges_all{sub};
    edges_num = size(edges_i, 1);
    H = zeros(32, edges_num);
    w = zeros(edges_num, 1);
    % 未去重
    for i = 1:edges_num
        H(edges_i{i, 2}, i) = 1;
        w(i) = edges_i{i, 3};
    end

    H_all{sub} = H;
    w_all{sub} = w;
end


%% S矩阵t检验
num_subjects = 145;
S_all = zeros(32, 32, num_subjects);
S_vec = zeros(num_subjects, 32*32);
for i = 1:num_subjects
    H = H_all{i};
    
    W = diag(w_all{i});
    de = sum(H, 1);
    De = diag(de);
    S_all(:,:,i) = H * W * De^-1 * H';
    S_vec(i, :) = vec(S_all(:,:,i));
end
[h_s, p_s] =ttest2(S_all(:,:,1:74), S_all(:,:,75:end), 'Dim', 3);
figure
imagesc(h_s, [0,1])
colormap parula
colorbar

