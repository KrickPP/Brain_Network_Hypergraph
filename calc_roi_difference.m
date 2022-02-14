% 寻找显著差异的脑区和连接

% 一对差异连接
threshold = 0.005;
p_thre = p_s < threshold;
figure
imagesc(p_thre, [0,1])
colorbar
[roi1, roi2] = find(p_thre);

% 查找出现次数最多的脑区
roi_all = [roi1; roi2];
count = tabulate(roi_all);
% count第1列是脑区编号，第2列是出现的次数。基于第二列，对每行降序排列
count_sort = sortrows(count, 2, 'descend');
roi_most = count_sort(1:8, :);

%%
figure
control_inc_aver(control_inc_aver <0) = 0;
imagesc(control_inc_aver, [0,0.5])
colorbar
title('Control Group Incidence Matrix')

figure
patient_inc_aver(patient_inc_aver <0) = 0;
imagesc(patient_inc_aver, [0,0.5])
colorbar
title('Patient Group Incidence Matrix')

