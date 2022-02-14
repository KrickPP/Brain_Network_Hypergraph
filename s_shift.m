function s1 = s_shift(F, s)
    % hypergraph shifting
    % 1 step shift

    node_num = length(s);
    s1 = zeros(node_num, 1); % 一步移位信号
    [inds, ~] = find(F);
    
    for i = 1:node_num
        slice_i = inds(:, 1) == i; % 第一个索引为i
        inds_i = inds(slice_i, :); % 第一个索引为i的F项
        s1(i) = sum(F(inds_i) .* s(inds_i(:, 2)) .* s(inds_i(:, 3)));
    end

end
