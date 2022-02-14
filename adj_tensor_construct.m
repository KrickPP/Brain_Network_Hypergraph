%% 导入关联矩阵
clear;
load('Data\\COBRE_inc_mat_new.mat')

%% 设置参数COBRE
% COBRE前74control，后71patient
num_control = 74;
num_patient = 71;

%% 设置参数OPenNEURO
% OpenNERO前117control，后49patient，共166
num_control = 117;
num_patient = 49;

%% 设置参数ADHD
% ADHD_inattensive, 前44control，后55 patient_inattensive
num_control = 44;
num_patient = 55;

%% 设置参数AD_LMCI
% AD_LMCI, 前26control，后31 patient_LMCI
num_control = 26;
num_patient = 31;

%% 计算平均邻接张量

% 分开邻接矩阵
num_subjects = size(inc_mat, 3); % 总受试者个数

control_inc_all = inc_mat(:, :, 1:num_control);
patient_inc_all = inc_mat(:, :, (num_control + 1):num_subjects);

% 两组关联矩阵，分别平均
control_inc_aver = mean(control_inc_all, 3);
patient_inc_aver = mean(patient_inc_all, 3);

% % 加上中心节点
% control_inc_aver = control_inc_aver + eye(32);
% patient_inc_aver = patient_inc_aver + eye(32);

% 计算邻接张量
control_adj = inc_to_adj(control_inc_aver);
patient_adj = inc_to_adj(patient_inc_aver);

%6元素表示一条超边
% control_adj = inc_to_adj_6entry(control_inc_aver);
% patient_adj = inc_to_adj_6entry(patient_inc_aver);

% 4阶张量
% control_adj = inc_to_adj_4order(control_inc_aver);
% patient_adj = inc_to_adj_4order(patient_inc_aver);


%% 保存到文件
save('Data\\Open_adj_ts.mat', 'control_adj', 'patient_adj')

%% 保存到文件
save('Data\\COBRE_adj_ts.mat', 'control_adj', 'patient_adj')
