u1=[2,3,4]';
u2=[3,4,5]';
u3=[1,1,2]';

x1=ktensor({u1, u2,u3});
x2=full(x1);

s=[1,2,3,4]';
s_h = ktensor({s,s,s,s});
s_h_full = full(s_h);
disp(s(3)*s(2)*s(3)*s(4))
s_h_full(3,2,3,4)
