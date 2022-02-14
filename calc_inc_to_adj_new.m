%% 稀疏表示->邻接矩阵中权重->邻接张量


edge_num = 32;
order = 3;
ts_all = cell(145, 1);

for sub = 1:145
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
    
    ts_all{sub} = ts;
    
end