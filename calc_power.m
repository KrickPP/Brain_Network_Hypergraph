dataSize = size(ROI_time_series);
num_subjects = dataSize(3);

power=zeros(num_subjects, 32);

for i = 1:num_subjects
    % 每个受试者的时间序列，长度*节点数
    timeseries = ROI_time_series(:, :, i);

    % 计算信号的功率，作为一个脑区的信号
%     power(i, :) = mean(timeseries.^2); % 每列是一个脑区的信号,power是1*N
    
    % 使用绝对值的均值
     power(i,:) = mean(abs(timeseries));

%     % V 即[f1 f2 f3 ... fN]^T
%     s = power';
%     V = U_aver_c';
%     s_fourier(:, i) = (V * s).^2;
end

%% 分类数据
label = [zeros(74, 1); ones(71,1)];
cobre_power = [power, label];
