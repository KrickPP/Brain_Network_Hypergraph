%% 分解张量，得到频率分量
% load('Data\\adj_ts.mat')

%% 分解控制组
% 秩最大为N=32
rank = 32;
% control_adj = ts_group{1};

[T, fit] = CP_ORTHO(control_adj, rank);
% T_full = full(T);
% save(sprintf('T_%.2f.mat', fit), 'T') % 将分解后的T保存到文件

% 如果adj_ts是超对称的，U{i} 32*order的所有列应该相等
% 分解结果每列确实几乎相等，这里给所有列取均值
U = T.U;
lambda_c = T.lambda;
U_aver_c = (U{1} + U{2} + U{3}) / 3;

%% 分解患者组
% patient_adj = ts_group{2};
[T, fit] = CP_ORTHO(patient_adj, rank);
% T_full = full(T);

U = T.U;
lambda_p = T.lambda;
U_aver_p = (U{1} + U{2} + U{3}) / 3;

%% 绘图
figure;
imagesc(U_aver_c);
colorbar;
% title('control frequency')

figure
imagesc(U_aver_p);
colorbar;
% title('patient frequency')


%% 保存数据
save('Data\\COBRE_U_aver_c.mat', 'U_aver_c', 'lambda_c')
save('Data\\COBRE_U_aver_p.mat', 'U_aver_p', 'lambda_p')


%% 保存数据
save('Data\\Open_U_aver_c.mat', 'U_aver_c', 'lambda_c')
save('Data\\Open_U_aver_p.mat', 'U_aver_p', 'lambda_p')

%% 保存数据
save('Data\\ADHD_U_aver_c.mat', 'U_aver_c', 'lambda_c')
save('Data\\ADHD_U_aver_p.mat', 'U_aver_p', 'lambda_p')






