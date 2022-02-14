%% 计算信号的傅里叶变换
load('Data\\U_aver.mat');
load('COBRE_Data\\COBRE_32.mat');

%% 设置参数，计算傅里叶变换
% num_control 和 num_patient 在构建邻接张量时设置

num_subjects = size(ROI_time_series, 3);
num_node = size(ROI_time_series, 2);
s_fourier = zeros(num_node, num_subjects);

% 计算正常组的傅里叶变换
for i = 1:num_control
    % 每个受试者的时间序列，长度*节点数
%     timeseries = cell2mat(ROI_time_series(:, :, i));
    timeseries = ROI_time_series(:, :, i);
    % 计算信号的功率，作为一个脑区的信号
    power = mean(timeseries.^2); % 每列是一个脑区的信号,power是1*N
    
    % 使用绝对值的均值
%     power = mean(abs(timeseries));

    % V 即[f1 f2 f3 ... fN]^T
    s = power';
    V = U_aver_c';
    s_fourier(:, i) = (V * s).^2;
end

% 计算患者组的傅里叶变换
for i = num_control + 1:num_subjects
    % 每个受试者的时间序列，长度*节点数
%     timeseries = cell2mat(ROI_time_series(:, :, i));
    timeseries = ROI_time_series(:, :, i);
    % 计算信号的功率，作为一个脑区的信号
    power = mean(timeseries.^2); % 每列是一个脑区的信号,power是1*N
    
    % 使用绝对值的均值
%     power = mean(abs(timeseries));

    % V 即[f1 f2 f3 ... fN]^T
    s = power';
    V = U_aver_p';
    s_fourier(:, i) = (V * s).^2;
end

%% 保存到文件
save('COBRE_fourier', 's_fourier');

%% 保存到文件
save('OpenNEURO_fourier', 's_fourier');

%% 傅里叶变换结果绘图
figure

imagesc(s_fourier, [0, 20]);
colorbar;
% title('fourier transform')

%% 保存图片
fig_name = 'fourier transform';
print(gcf, '-dpng', '-r300', fig_name);




