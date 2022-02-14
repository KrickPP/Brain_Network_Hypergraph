function adj_ts = inc_to_adj_4order(inc_mat)
    % 关联矩阵转为邻接张量
    % inc_mat: 关联矩阵
    % adj_ts: 邻接张量

    % 构建order阶张量，即每边最多order个节点
    order = 4;
    dataSize = size(inc_mat);
    node_num = dataSize(1); % 节点数
    edge_num = dataSize(2); % 边数(等于节点个数)
    involves = cell(edge_num, 1); % edge_num个元组，存储每条边涉及的节点
    edge = zeros(edge_num, 1); % 原始的第j条边
    edge_sort = zeros(edge_num, 1); % 排序后的第j条边

    %% 对每条边处理，获得张量的非零元素下标
    % 获取前order个大的系数
    for i = 1:edge_num
        edge_sort = sort(inc_mat(:, i), 'descend');
        min_coef = edge_sort(order); % 排序后第order个系数
        edge = inc_mat(:, i);
        edge(edge < min_coef) = 0; % 保留最大的前order个系数
        ind = find(edge); % 非零的索引，即脑区编号
        involves{i} = ind;
    end

    % 将脑区数量补充到order个
    involve_add = zeros(order, 1); % 添加到11个脑区
    edge_length = zeros(edge_num, 1); % 边包含脑区的个数

    for i = 1:edge_num
        edge_length(i) = length(involves{i});

        if edge_length(i) == order
            continue;
        end

        if edge_length(i) <= order / 2 % 数量不足一半的会重复
            pick = randperm(order - edge_length(i));
            ind = find(pick > edge_length(i));
            pick(ind) = mod(pick(ind), edge_length(i));
            ind = pick == 0;
            pick(ind) = edge_length(i);
        else
            pick = randperm(edge_length(i), order - edge_length(i)); % 随机选取M-c个
        end

        pick_add = involves{i}(pick); % 添加成11个
        involves{i}(edge_length(i) + 1:order) = pick_add;

    end

    %% 构建邻接张量（使用稀疏张量，因为普通张量存储需要极大的空间）
    inds_cell = cell(edge_num, 1); % 使用元组保存索引

%     % 方式一：仅使用涉及的边的排列
%     for i = 1:edge_num
%         inds = perms(involves{i}); % 涉及到的边的排列
%         inds = unique(inds, 'rows'); % 去重
%         inds_cell{i, 1} = inds; % 放入元组
% 
%         % fprintf('the %3dth edge.\n', i)
%     end

% 	% 方式二：索引全部用上
%     i_all = 1;
%     for i = 1:edge_num
%         ind_i = involves{i};
%         for i1 = 1:order
%             for i2 = 1:order
%                 for i3 = 1:order
%                     inds_cell{i_all, 1} = [ind_i(i1), ind_i(i2), ind_i(i3)];
%                     i_all = i_all + 1;
%                 end
%             end
%         end
%     end

    % 4阶张量
    i_all = 1;
    for i = 1:edge_num
        ind_i = involves{i};
        for i1 = 1:order
            for i2 = 1:order
                for i3 = 1:order
                    for i4 = 1:order
                        inds_cell{i_all, 1} = [ind_i(i1), ind_i(i2), ind_i(i3), ind(i4)];
                        i_all = i_all + 1;
                    end
                end
            end
        end
    end

	% 转成矩阵，去重
    inds = unique(cell2mat(inds_cell), 'rows');

    %% 设置邻接张量元素的值
    adj_ts = sptensor(repmat(node_num, 1, order));
    ele_num = 0; % 一个索引中不同脑区的个数
    factor = 6; % 元素值扩大

%     for i = 1:size(inds, 1)
%         ele_num = length(unique(inds(i, :)));
%         
%         switch ele_num
%             case 3
%                 adj_ts(inds(i, :)) = 1/2 * factor;
%             case 2
%                 adj_ts(inds(i, :)) = 1/3 * factor;
%             case 1
%                 adj_ts(inds(i, :)) = 1 * factor;
%         end
% 
%     end

    % 4阶张量
    for i = 1:size(inds, 1)
        ele_num = length(unique(inds(i, :)));
        
        switch ele_num
            case 4
                adj_ts(inds(i, :)) = 1/6 * factor;
            case 3
                adj_ts(inds(i, :)) = 1/12 * factor;
            case 2
                adj_ts(inds(i, :)) = 1/16 * factor;
            case 1
                adj_ts(inds(i, :)) = 1 * factor;
        end

    end

end
