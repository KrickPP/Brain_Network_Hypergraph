
%% 所有人的平均关联矩阵
inc_aver = mean(inc_mat, 3);

% 所有人的平均邻接张量
adj_all = inc_to_adj(inc_aver);


%% 分解 所有人的邻接张量
order = 32;

[T, fit] = CP_ORTHO(adj_all, order);
T_full = full(T);
% save(sprintf('T_%.2f.mat', fit), 'T') % 将分解后的T保存到文件

% 如果adj_ts是超对称的，U{i} 32*order的所有列应该相等
% 分解结果每列确实几乎相等，这里给所有列取均值
U = T.U;
lambda_all = T.lambda;
U_aver_all = (U{1} + U{2} + U{3}) / 3;


%% 计算所有人的傅里叶变换
dataSize = size(ROI_time_series);
numSubjects = dataSize(3);
num_node = dataSize(2);
s_fourier = zeros(num_node, numSubjects);

for i = 1:numSubjects
    % 每个受试者的时间序列，长度*节点数
    timeseries = ROI_time_series(:, :, i);

    % 计算信号的功率，作为一个脑区的信号
    power = mean(timeseries.^2); % 每列是一个脑区的信号,power是1*N
    
    % 使用绝对值的均值
%     power = mean(abs(timeseries));

    % V 即[f1 f2 f3 ... fN]^T
    s = power';
    V = U_aver_all';
    s_fourier(:, i) = (V * s).^2;
end


%% 傅里叶变换结果绘图
figure
imagesc(s_fourier, [0,18]);
colorbar;
title('fourier transform')


%% 分类数据
label = [zeros(74, 1); ones(71,1)];
cobre_all = [s_fourier', label];






