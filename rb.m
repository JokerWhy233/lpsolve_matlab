%m by k

% all to cloud


clear
clc
format long
load('var.mat');
rng('default');
%rng(1);
%rng('shuffle');
% D = 0.4;% deadline (sec)
% tau = 0.35; % allocated cpu time (sec)
% x= 50; % Mcycles per task
% v=10;

Deadline = 0.5;% deadline (sec)
tau = 0.48; % allocated cpu time (sec)
x=35; % Mcycles per task
%v=10; 
E=70;
A=2.37;
p=3;
v=1;
m=6;
k=m;
m;
upper_N = 20;
upper_C = 20;


task_iter = 20;

arr_opt_no_miss_cnt = zeros(1, length(task_iter));
arr_opt_miss_cnt =  zeros(1, length(task_iter));
arr_static_no_miss_cnt =  zeros(1, length(task_iter));
arr_static_miss_cnt_t_limit =  zeros(1, length(task_iter));
arr_static_miss_cnt_c_limit =  zeros(1, length(task_iter));
arr_opt_enegery_used = zeros(1, length(task_iter));
arr_static_enegery_used = zeros(1, length(task_iter));
arr_task_iter_cnt = 1;


no_miss_cnt=0;
miss_cnt=0;
static_enegery_used = 0;
time_tot = 0;
for j = 1:length(N_mat)

    N = N_mat(j,:);
    N_leftover=zeros(1,size(N_mat,2));

    for i=1:m
        time_passed = 0;
        for n=1:N(i)
            time_passed = time_passed +  1/B(i,i) + x/f(i); 
            time_tot=time_tot+  1/B(i,i) + x/f(i);
            if  time_passed <= Deadline && n <= C(i)
                N_leftover(i)=N_leftover(i)+1;
                static_enegery_used=static_enegery_used+(A*(f(i)/1000)^p+E)*x/f(i);  
                
            end 
        end
        N_leftover(i)=N(i)-N_leftover(i);

    end
    time_passed = 0;

    for n=1:sum(N_leftover)
            time_passed = time_passed +  1/B(1,end) + x/f(end);   
            time_tot=time_tot+  1/B(1,end) + x/f(end);   
            
            if  time_passed >= Deadline
                miss_cnt = miss_cnt + 1;
            else
                no_miss_cnt=no_miss_cnt+1;
            end   
    end
    
    
      
     static_enegery_used=static_enegery_used+  (A*(f(end)/1000)^p+E)*sum(N_leftover)*x/f(end);  
         
        
end
miss_cnt
no_miss_cnt;

static_enegery_used

time_tot


%%
%m by k

% round robin

clear
clc
format long
load('var.mat');
rng('default');
%rng(1);
%rng('shuffle');
% D = 0.4;% deadline (sec)
% tau = 0.35; % allocated cpu time (sec)
% x= 50; % Mcycles per task
% v=10;

Deadline = 0.5;% deadline (sec)
tau = 0.5; % allocated cpu time (sec)
x= 35; % Mcycles per task
%v=10; 
E=70;
A=2.37;
p=3;
v=100;
m=6;
k=m;
m;
upper_N = 20;
upper_C = 20;


task_iter = 20;

arr_opt_no_miss_cnt = zeros(1, length(task_iter));
arr_opt_miss_cnt =  zeros(1, length(task_iter));
arr_static_no_miss_cnt =  zeros(1, length(task_iter));
arr_static_miss_cnt_t_limit =  zeros(1, length(task_iter));
arr_static_miss_cnt_c_limit =  zeros(1, length(task_iter));
arr_opt_enegery_used = zeros(1, length(task_iter));
arr_static_enegery_used = zeros(1, length(task_iter));
arr_task_iter_cnt = 1;


no_miss_cnt=0;
miss_cnt=0;
static_enegery_used = 0;
time_tot=0;
for j = 1:length(N_mat)

    N = N_mat(j,:);
    N_leftover=zeros(1,size(N_mat,2));
    C_left = C;

    time_passed_ar = zeros(1,size(N_mat,2));
    for i=1:m
        time_passed = time_passed_ar(i);
        for n=1:N(i)
            time_passed = time_passed +  1/B(i,i) + x/f(i);      
            if  time_passed <= Deadline && n <= C(i)
                N_leftover(i)=N_leftover(i)+1;
                static_enegery_used=static_enegery_used+(A*(f(i)/1000)^p+E)*x/f(i);  
                C_left(i)=C_left(i)-1;
            
                
            end
            
        end
        time_passed_ar(i)=(1/B(i,i) + x/f(i))*N_leftover(i);
        N_leftover(i)=N(i)-N_leftover(i);

    end
    inn=0;
    N_leftover
    time_passed_ar

    j
    for i=1:m
        
        while(N_leftover(i)>0)
            
            for ii=1:m
%                 time_passed = Deadline-time_passed_ar(ii);
%                
                if C_left(ii)>0 && N_leftover(i)>0
                    time_passed_ar(ii) = time_passed_ar(ii) +1/B(i,ii)+ x/f(ii);
                    if time_passed_ar(ii)>Deadline
                        miss_cnt = miss_cnt + 1;
                    end
                    static_enegery_used=static_enegery_used+(A*(f(ii)/1000)^p+E)*x/f(ii);  
                    N_leftover(i)=N_leftover(i)-1;
                    C_left(ii)=C_left(ii)-1;
       
                         inn=inn+ii;
                    
                end
            end
            
 
        end
        
        
        
    end
    
    
    time_tot = time_tot +sum(time_passed_ar);
end
miss_cnt
no_miss_cnt;

static_enegery_used
time_tot 

%%
%m by k

% Active Monitoring Load Balancer --> most available server - cloud last

clear
clc
format long
load('var.mat');
rng('default');
%rng(1);
%rng('shuffle');
% D = 0.4;% deadline (sec)
% tau = 0.35; % allocated cpu time (sec)
% x= 50; % Mcycles per task
% v=10;

Deadline = 0.5;% deadline (sec)
tau = 0.5; % allocated cpu time (sec)
x= 35; % Mcycles per task
%v=10; 
E=70;
A=2.37;
p=3;
v=100;
m=6;
k=m;
m;
upper_N = 20;
upper_C = 20;


task_iter = 20;

arr_opt_no_miss_cnt = zeros(1, length(task_iter));
arr_opt_miss_cnt =  zeros(1, length(task_iter));
arr_static_no_miss_cnt =  zeros(1, length(task_iter));
arr_static_miss_cnt_t_limit =  zeros(1, length(task_iter));
arr_static_miss_cnt_c_limit =  zeros(1, length(task_iter));
arr_opt_enegery_used = zeros(1, length(task_iter));
arr_static_enegery_used = zeros(1, length(task_iter));
arr_task_iter_cnt = 1;


no_miss_cnt=0;
miss_cnt=0;
static_enegery_used = 0;
time_tot=0;
for j = 1:length(N_mat)

    N = N_mat(j,:);
    N_leftover=zeros(1,size(N_mat,2));
    C_left = C;

    time_passed_ar = zeros(1,size(N_mat,2));
    for i=1:m
        time_passed = time_passed_ar(i);
        for n=1:N(i)
            time_passed = time_passed +  1/B(i,i) + x/f(i);      
            if  time_passed <= Deadline && n <= C(i)
                N_leftover(i)=N_leftover(i)+1;
                static_enegery_used=static_enegery_used+(A*(f(i)/1000)^p+E)*x/f(i);  
                C_left(i)=C_left(i)-1;
            
                
            end
            
        end
        time_passed_ar(i)=(1/B(i,i) + x/f(i))*N_leftover(i);
        N_leftover(i)=N(i)-N_leftover(i);

    end
    inn=0;
    N_leftover
    time_passed_ar
    for i=1:m
        
        while(N_leftover(i)>0)
            [val ,index]=max(C_left(1:end-1));
            if(val>0)
                ii=index;
            else
                ii=m;
            end
            time_passed_ar(ii) = time_passed_ar(ii) +1/B(i,ii)+ x/f(ii);
            if time_passed_ar(ii)>Deadline
                miss_cnt = miss_cnt + 1;
            end
            static_enegery_used=static_enegery_used+(A*(f(ii)/1000)^p+E)*x/f(ii);  
            N_leftover(i)=N_leftover(i)-1;
            C_left(ii)=C_left(ii)-1;
           
                
                
            
            
           
        end
        
        
        
    end
    
 time_tot = time_tot +sum(time_passed_ar);
end
miss_cnt
%no_miss_cnt

static_enegery_used
time_tot

%%
%m by k

% throttled Load Balancer --> most recommded 

clear
clc
format long
load('var.mat');
rng('default');
%rng(1);
%rng('shuffle');
% D = 0.4;% deadline (sec)
% tau = 0.35; % allocated cpu time (sec)
% x= 50; % Mcycles per task
% v=10;

Deadline = 0.5;% deadline (sec)
tau = 0.5; % allocated cpu time (sec)
x= 40; % Mcycles per task
%v=10; 
E=70;
A=2.37;
p=3;
v=100;
m=6;
k=m;
m;
upper_N = 20;
upper_C = 20;


task_iter = 20;

arr_opt_no_miss_cnt = zeros(1, length(task_iter));
arr_opt_miss_cnt =  zeros(1, length(task_iter));
arr_static_no_miss_cnt =  zeros(1, length(task_iter));
arr_static_miss_cnt_t_limit =  zeros(1, length(task_iter));
arr_static_miss_cnt_c_limit =  zeros(1, length(task_iter));
arr_opt_enegery_used = zeros(1, length(task_iter));
arr_static_enegery_used = zeros(1, length(task_iter));
arr_task_iter_cnt = 1;


no_miss_cnt=0;
miss_cnt=0;
static_enegery_used = 0;
time_tot=0;
for j = 1:length(N_mat)

    N = N_mat(j,:);
    N_leftover=zeros(1,size(N_mat,2));
    C_left = C;

    time_passed_ar = zeros(1,size(N_mat,2));
    for i=1:m
        time_passed = time_passed_ar(i);
        for n=1:N(i)
            time_passed = time_passed +  1/B(i,i) + x/f(i);      
            if  time_passed <= Deadline && n <= C(i)
                N_leftover(i)=N_leftover(i)+1;
                static_enegery_used=static_enegery_used+(A*(f(i)/1000)^p+E)*x/f(i);  
                C_left(i)=C_left(i)-1;
            
                
            end
            
        end
        time_passed_ar(i)=(1/B(i,i) + x/f(i))*N_leftover(i);
        N_leftover(i)=N(i)-N_leftover(i);

    end
    inn=0;
    N_leftover
    time_passed_ar
    for i=1:m
        
        while(N_leftover(i)>0)
           best = inf*ones(1,m);
           for ii=1:m            
                if C_left(ii)>0 
                    best(ii) = time_passed_ar(ii) +1/B(i,ii)+ x/f(ii);                
                end
           end
%            ii=m;
%            for index=1:m-1
%               if best(index)<=Deadline
%                   ii=index;
%               end
%            end
            [val ii]=min(best);
           
            time_passed_ar(ii) = time_passed_ar(ii) +1/B(i,ii)+ x/f(ii);
            if time_passed_ar(ii)>Deadline
                miss_cnt = miss_cnt + 1;
            end
            static_enegery_used=static_enegery_used+(A*(f(ii)/1000)^p+E)*x/f(ii);  
            N_leftover(i)=N_leftover(i)-1;
            C_left(ii)=C_left(ii)-1;
                
                
            
            
           
        end
        
        
        
    end
    
    
    
    time_tot = time_tot +sum(time_passed_ar);   
%         
end
miss_cnt
%no_miss_cnt

static_enegery_used
time_tot
