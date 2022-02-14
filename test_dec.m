
x(:,:,1) = [2,6,3,1;3,5,3,6;1,4,7,9;3,6,8,2];
x(:,:,2) = [2,6,3,1;4,6,8,2;1,4,7,9;3,6,8,2];
x(:,:,3) = [2,6,3,1;3,5,3,6;4,8,3,7;3,6,8,2];
x(:,:,4) = [8,9,4,2;3,5,3,6;1,4,7,9;3,6,8,2];

X = tensor(x);


sparse = nnz(X)/4^3;
[T, fit] = CP_ORTHO(X, 4);
T_full = full(T);



% for order= 10:2:22
%     [T, fit] = CP_ORTHO(x, order);
%     fit_his(i) = fit;
%     i= i+1;
%     fprintf('Order = %d, fit = %f\n', order, fit);
%     
% end

