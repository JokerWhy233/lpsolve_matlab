%m by k

clear
clc
close all
format long
%rng('shuffle');
% D = 0.4;% deadline (sec)
% tau = 0.35; % allocated cpu time (sec)
% x= 50; % Mcycles per task
% v=10;

D = 0.4;% deadline (sec)
tau = 0.38; % allocated cpu time (sec)
x= 50; % Mcycles per task
v=10e2;
E=50;
A=3.5;
p=2.5;

m=10;
k=m;
suc_solved = 0;
total_iter = 100;
not_fea = 1;
while not_fea 
  first = 0;

  B = [10e5 8 24 ;16 10e5 8;24 16 10e5]; % link rate (task per second)
  B = randi([8 64],m,m);
  B(eye(size(B))~=0)=10e5;
  f =  randi([18 24],1,m)*150;%(MHz)
  N=  randi([10 20],1,m); % number of tasks(cars)
  C =  randi([10 20],1,m); % server link capacity (# of tasks)
  
  num_tasks_allowed = sum(floor(tau*f/x));
  num_tasks = sum(N);
  if num_tasks < num_tasks_allowed & num_tasks < sum(C)
    not_fea = 0;
  else
    not_fea = 1;
  end

end


opt_no_miss_cnt = 0;
opt_miss_cnt = 0;

static_no_miss_cnt = 0;
static_miss_cnt_t_limit = 0;
static_miss_cnt_c_limit = 0;

opt_enegery_used = 0;
static_enegery_used = 0; 
for iter = 1:total_iter
     iter;
     not_fea = 1;
     while not_fea 
       N=  randi([10 20],1,m); % number of tasks(cars)
       num_tasks_allowed = sum(floor(tau*f/x));
       num_tasks = sum(N);
       if num_tasks < num_tasks_allowed & num_tasks < sum(C)
         not_fea = 0;
       else
         not_fea = 1;
       end

     end


    obj = [];
    for i=1:m
        for j=1:m
            obj=[obj 1/B(i,j)+x/f(j)-D/k]; 
        end
     end
%     for i=1:m
%         for j=1:m
%             obj=[obj x/f(j)*(A*f(j)^p+E)]; 
%         end
%     end
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
    toc
    
    if(solvestat==0)
        suc_solved = suc_solved +1;
        final_obj = mxlpsolve('get_objective', lp);
        res = mxlpsolve('get_variables', lp);
        cons = mxlpsolve('get_constraints', lp);
        %final_y1_cons=cons(end-2m+1:end-m)'
        final_y2_cons=cons(end-m+1:end)';
        dist=reshape(res,m,m+1)';
        final_dist=sparse(dist(1:m,:));
        final_dist2=sparse(dist(1:m,:)');
        lateness =zeros(m,m);
        opt_lateness = zeros(1,m);


        %for i=1:m
        %    for j=1:k
        %       lateness(i,j) = final_dist(i,j)*(1/B(i,j)+x/f(j));
        %    end 
        %    opt_lateness=sum(lateness,2)-D;
        %end
        for i=1:m
            for j=1:k
               lateness(i,j) = final_dist2(i,j)*(1/B(j,i)+x/f(i));
            end 
            opt_lateness=sum(lateness,2)-D;
        end


        %opt_lateness

        no_opt_lateness = zeros(m,1);

        for i=1:m    
            no_opt_lateness(i)=N(i)* ( 1/B(i,i) + x/f(i) )-D;
        end


        %no_opt_lateness


        %opt_stat=datastats(opt_lateness)
        %no_opt_stat=datastats(no_opt_lateness)


        no_opt_avail_cpu_minus_required_cpu=tau*f-N*x;

        num_tasks_allowed = sum(floor(tau*f/x));
        num_tasks = sum(N);
        num_tasks_c = sum(C);
        mxlpsolve('delete_lp', lp);




        %check deadline misses

        % my opt
        for i=1:m
            time_passed = 0;

            for j=1:k
                if final_dist2(i,j)>0
                    for jj=1:final_dist2(i,j)
                        time_passed=time_passed+(1/B(j,i)+x/f(i));
                        if  time_passed <= D
                            opt_no_miss_cnt = opt_no_miss_cnt + 1;
                        else
                            opt_miss_cnt = opt_miss_cnt + 1;
                        end   
                    end
                end
               lateness(i,j) = final_dist2(i,j)*(1/B(j,i)+x/f(i));
            end 
            opt_lateness=sum(lateness,2)-D;
        end






        % static
        for i=1:m    
            time_passed = 0;
            for kk= 1:N(i)
                if C(i)>=kk
                    time_passed = time_passed +  1/B(i,i) + x/f(i);
                    if  time_passed <= D
                        static_no_miss_cnt = static_no_miss_cnt + 1;
                    else
                        static_miss_cnt_t_limit  = static_miss_cnt_t_limit  + 1;
                    end
                else
                   static_miss_cnt_c_limit=static_miss_cnt_c_limit+1; 
                end

            end
            final_lateness2(i)=N(i)* ( 1/B(i,i) + x/f(i) )-D;
        end
        
        % random
%         time_passed=zeros(1,m);
%         for i=1:m    
%             time_passed = 0;
%             for kk= 1:N(i)
%                 if C(i)>=kk
%                     time_passed = time_passed +  1/B(i,i) + x/f(i);
%                     if  time_passed <= D
%                         no_miss_cnt = no_miss_cnt + 1;
%                     else
%                         miss_cnt_t_limit  = miss_cnt_t_limit  + 1;
%                     end
%                 else
%                    miss_cnt_c_limit=miss_cnt_c_limit+1; 
%                 end

%             end
%             final_lateness2(i)=N(i)* ( 1/B(i,i) + x/f(i) )-D;
%         end        
        
        
       %check enegery usage
 
        % my opt

        for i=1:m         
            for j=1:k
                opt_enegery_used=opt_enegery_used+  (A*f(i)^p+E)*final_dist2(i,j)*x/f(i);  
            end 
        end           
         
        % static
        for i=1:m         
                static_enegery_used=static_enegery_used+  (A*f(i)^p+E)*N(i)*x/f(i);  
        end           
        
        
        
    else
        iter
        mxlpsolve('delete_lp', lp);
    end



end


solved_percen = suc_solved/total_iter 
total_iter 
opt_miss_cnt
opt_no_miss_cnt


static_miss_cnt_c_limit
static_miss_cnt_t_limit
static_no_miss_cnt

opt_enegery_used
static_enegery_used 
