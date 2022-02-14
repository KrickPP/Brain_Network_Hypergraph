data = load('D:\MATLAB_Projects\Adj_tensor\Data\\roc_curve_proposed.mat');
fpr_proposed = data.roc_fpr;
tpr_proposed = data.roc_tpr;

data = load('D:\MATLAB_Projects\Adj_tensor\Data\\roc_curve_elastic.mat');
fpr_elastic = data.roc_fpr;
tpr_elastic = data.roc_tpr;

data = load('D:\MATLAB_Projects\Adj_tensor\Data\\roc_curve_group_lasso.mat');
fpr_group_lasso = data.roc_fpr;
tpr_group_lasso = data.roc_tpr;

data = load('D:\MATLAB_Projects\Adj_tensor\Data\\roc_curve_FW_lasso.mat');
fpr_FW_lasso = data.roc_fpr;
tpr_FW_lasso = data.roc_tpr;

data = load('D:\MATLAB_Projects\Adj_tensor\Data\\roc_curve_learning.mat');
fpr_learning = data.roc_fpr;
tpr_learning = data.roc_tpr;


hold on
plot(fpr_elastic, tpr_elastic, '--*', 'LineWidth', 1.5)
plot(fpr_group_lasso, tpr_group_lasso, '--o', 'LineWidth', 1.5)
plot(fpr_FW_lasso, tpr_FW_lasso, '--+', 'LineWidth', 1.5)
plot(fpr_learning, tpr_learning, '--^', 'LineWidth', 1.5)
plot(fpr_proposed, tpr_proposed, '--s', 'LineWidth', 1.5)


xlabel('False Positive Rate')
ylabel('True Positive Rate')
legend('Group Lasso', 'Elastic Net', 'FW Lasso', 'Weight Learning', 'Proposed')
grid on