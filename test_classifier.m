y = zeros(145,1);
for i =1:145
    y(i)=COBRE_99.predictFcn(table2array(X(i,:)));
end