% 分组找不同，稀疏表示->inc平均->邻接矩阵中权重->两个张量
% 结论：傅里叶变换结果和基于A(i1,i2,i3)公式，即结构权重结果类似。

%% 导入关联矩阵
clear;
load('Data\\COBRE_inc_mat_new.mat')

%% 设置参数COBRE
% COBRE前74control，后71patient
num_control = 74;
num_patient = 71;

%% 平均稀疏表示矩阵
% 分开邻接矩阵
num_subjects = size(inc_mat, 3); % 总受试者个数

control_inc_all = inc_mat(:, :, 1:num_control);
patient_inc_all = inc_mat(:, :, (num_control + 1):num_subjects);

% 两组关联矩阵，分别平均
control_inc_aver = mean(control_inc_all, 3);
patient_inc_aver = mean(patient_inc_all, 3);

%% 构造邻接张量，使用邻接矩阵中的权重
edge_num = 32;
left_num = 3;   % 保留的个数
involves = cell(32, 2); % 构建两个矩阵

% 对控制组inc矩阵
% 每个受试者保留3个节点
inc_mat_i = control_inc_aver;
sub = 1;
for i = 1:edge_num
    edge_sort = sort(inc_mat_i(:, i), 'descend');
    min_coef = edge_sort(left_num); % 排序后第left_num个系数
    edge = inc_mat_i(:, i);
    edge(edge < min_coef) = 0; % 保留最大的前order个系数
    inc_mat_i(:, i) = edge;
    ind = find(edge); % 非零的索引，即脑区编号
    involves{i, sub} = ind;
end

% 对患者组inc矩阵
% 每个受试者保留3个节点
inc_mat_i = patient_inc_aver;
sub = 2;
for i = 1:edge_num
    edge_sort = sort(inc_mat_i(:, i), 'descend');
    min_coef = edge_sort(left_num); % 排序后第left_num个系数
    edge = inc_mat_i(:, i);
    edge(edge < min_coef) = 0; % 保留最大的前order个系数
    inc_mat_i(:, i) = edge;
    ind = find(edge); % 非零的索引，即脑区编号
    involves{i, sub} = ind;
end

%% 从邻接矩阵取出权重
% 两个权重
edges_weight = zeros(edge_num, 2);

adj_aver_c = mean(adj_mat_all(:, :, 1:num_control), 3);
adj_aver_p = mean(adj_mat_all(:, :, (num_control + 1):num_subjects), 3);

adj_i = adj_aver_c;
involve = involves(:,1);
for i = 1:edge_num
    edge_ind = involve{i};
    edges_weight(i, 1) = sum(adj_i(i, edge_ind));
end

adj_i = adj_aver_p;
involve = involves(:,2);
for i = 1:edge_num
    edge_ind = involve{i};
    edges_weight(i, 2) = sum(adj_i(i, edge_ind));
end
    

%% 构建邻接张量

order = 3;
ts_group = cell(2, 1);

for sub = 1:2
    ts = sptensor([32,32,32]);
    inds_cell = cell(27*32, 1);
    i_all = 1;
    inv_i = involves(:, sub);
    for i = 1:edge_num
        edge_i = inv_i{i};
        % 所有索引都用上，3*3*3=27个元素表示一条超边
        if length(edge_i) < 3
            continue;
        end
        for i1 = 1:order
            for i2 = 1:order
                for i3 = 1:order
                    inds_cell{i_all} = [edge_i(i1), edge_i(i2), edge_i(i3)];
                    ts(inds_cell{i_all}) = edges_weight(i, sub);
                    i_all = i_all + 1;
                end
            end
        end
    end
    
    ts_group{sub} = ts;
    
end


