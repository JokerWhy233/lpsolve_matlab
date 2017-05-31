
%m by k

clear
clc
close all


D = 0.5;% deadline (sec)
tau = .3; % allocated cpu time (sec)
x= 150; % Mcycles per task
v=10;


m=3;
k=3;
B = [10e5 8 24;16 10e5 8;24 16 10e5]; % link rate (task per second)
f = [2000 2400 2500];%(MHz)
N= [5 3 4]; % number of tasks(cars)
C = [4 4 4]; % server link capacity (# of tasks)



% m=2;
% k=2;
% B=[10e5 8;16 10e5];
% f=[3000 3600];
% C = [8 8];
% N=[3 8];


obj = [];
for i=1:m
    for j=1:m
        obj=[obj 1/B(i,j)+x/f(j)-D/k]; 
    end
end
for i=1:m
   obj=[obj v]; 
end
c1 = zeros(m,m*k+m);
for j=1:m
    for i=1:k
        c1(j,(i-1)*k+j)=x;
    end
end
c2 = zeros(m,m*k+m);
for j=1:m
    for i=1:k
        c2(j,(i-1)*k+j)=1;
    end
end
c3 = zeros(m,m*k+m);
for i=1:k
    for j=1:m
        c3(i,(i-1)*m+j)=1;
    end
end
y1 = zeros(m,m*k+m);
for j=1:m
   y1(j,m*k+j) = 1;
end
y2 = zeros(m,m*k+m);
for j=1:m
    for i=1:m
        y2(j,(i-1)*m+j)=-(1/B(i,j)+x/f(j));  
    end
end
for j=1:m
   y2(j,m*k+j) = 1;
end
a= [c1;c2;c3;y1;y2];
b = zeros(size(a,1),1);
cnt = 1;

for j=1:m
   b(cnt) = f(j)*tau;
   cnt = cnt +1;
end

for j=1:m
   b(cnt) = C(j);
   cnt = cnt +1;
end

for i=1:k
   b(cnt) = N(i);
   cnt = cnt +1;
end

for i=1:k
   b(cnt) = 0;
   cnt = cnt +1;
end

for i=1:k
   b(cnt) = -D;
   cnt = cnt +1;
end

e = -1*ones(size(a,1),1);
e(2*m+1:3*m)=0;
e(3*m+1:end)=1;
vlb=[];
vub=[];
xint=1:m*m;

lp = lp_maker(obj, a, b, e,vlb, vub, xint);
tic
solvestat = mxlpsolve('solve', lp)
final_obj = mxlpsolve('get_objective', lp)
res = mxlpsolve('get_variables', lp)
cons = mxlpsolve('get_constraints', lp)
final_dist=reshape(res,m,m+1)'
%mxlpsolve('delete_lp', lp);
toc