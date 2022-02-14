% load('Data\\COBRE_inc_mat.mat');
% 其他的构造方式
inc_mat = inc_mat_FW_lasso;

num_subjects = size(inc_mat, 3);
num_roi = size(inc_mat, 1);
cc_all = zeros(32, num_subjects);

% 每条边保留几个系数最大的
edge_num = size(inc_mat, 2);
left_num = 5;   % 保留的个数


for sub = 1:num_subjects
    inc_mat_i = inc_mat(:, :, sub);
    % 每个受试者保留left个节点
    for i = 1:edge_num
        edge_sort = sort(inc_mat_i(:, i), 'descend');
        min_coef = edge_sort(left_num); % 排序后第left_num个系数
        edge = inc_mat_i(:, i);
        edge(edge < min_coef) = 0; % 保留最大的前order个系数
        inc_mat_i(:, i) = edge;
        
    end
    inc_mat(:, :, sub) = inc_mat_i;
end


for sub = 1:num_subjects

    % 第i个受试者
%     H = double(inc_mat(:,:,sub) > 0);
    H = inc_mat(:, :, sub);
    H(H < 0) = 0;

    edges_v = zeros(5, 1); % 包含节点v的超边

    num_others = 0;
    cluster_coef = zeros(num_roi, 1);

    for i = 1:num_roi
        edges_v = find(H(i, :));
        Nv = nnz( sum(H(2:end, edges_v), 2) ); %节点v的邻居的个数
        if size(edges_v, 2) <= 1
            cluster_coef(i) = 0;
            continue
        end
        cluster_coef(i) = ( 2 * nnz(H(2:end, edges_v))  - Nv )  / ( Nv * (size(edges_v, 2) - 1) );

    end

    cc_all(:, sub) = cluster_coef;

end

% 分类数据
label = [zeros(74, 1); ones(71, 1)];
cc_train = [cc_all', label];

%%
label = [zeros(117, 1); ones(49, 1)];
cc_train_open = [cc_all', label];
