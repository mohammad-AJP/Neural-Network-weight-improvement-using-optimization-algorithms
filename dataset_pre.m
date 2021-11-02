clc
clear all
close all

load('thetable.mat');
x = table2cell(accesslogJul95);
u = cell2mat(x);
u(:,1) = [];
u(:,12) = ' ';
u(: , [3:12,15,18]) = [];
m1 = u(:,[1,2]);
m2 = u(:,[3,4]);
m3 = u(:,[5,6]);
for i = 1:size(u,1)
    n1(i,1) = str2num(m1(i,[1,2]));
    n2(i,1) = str2num(m2(i,[1,2]));
    n3(i,1) = str2num(m3(i,[1,2]));
end
data = [n1,n2,n3];

req = [];
day =1;
hour =0;
ii = 1;
rows = size(data,1);
t1=0;t2=0;t3=0;t4=0;t5=0;t6=0;t7=0;t8=0;t9=0;t10=0;t11=0;t12=0;
while ii <= rows
    while data(ii,1) == day
        while data(ii,2) == hour
            if (0<=data(ii,3))&&(data(ii,3)<=4)
                t1 = t1+1;
            elseif (5<=data(ii,3))&&(data(ii,3)<=9)
                t2 = t2+1;
            elseif (10<=data(ii,3))&&(data(ii,3)<=14)
                t3 = t3+1;
            elseif (15<=data(ii,3))&&(data(ii,3)<=19)
                t4 = t4+1;
            elseif (20<=data(ii,3))&&(data(ii,3)<=24)
                t5 = t5+1;
            elseif (25<=data(ii,3))&&(data(ii,3)<=29)
                t6 = t6+1;
            elseif (30<=data(ii,3))&&(data(ii,3)<=34)
                t7 = t7+1;
            elseif (35<=data(ii,3))&&(data(ii,3)<=39)
                t8 = t8+1;
            elseif (40<=data(ii,3))&&(data(ii,3)<=44)
                t9 = t9+1;
            elseif (45<=data(ii,3))&&(data(ii,3)<=49)
                t10 = t10+1;
            elseif (50<=data(ii,3))&&(data(ii,3)<=54)
                t11 = t11+1;
            else
                t12 = t12+1;
            end
            ii = ii+1;
        end
        hour = hour+1;
        req = [req;t1,t2,t3,t4,t5,t6,t7,t8,t9,t10,t11,t12];
        t1=0;t2=0;t3=0;t4=0;t5=0;t6=0;t7=0;t8=0;t9=0;t10=0;t11=0;t12=0;
    end
    hour = 0;
    day = day+1;
end

req1 = req';
req_list = reshape(req1,1,[]);
r=1;
while r+5 <= 7932
    pp_data(r,1:6) = req_list(1,r:r+5);
    r = r+1;
end
     

vec = randperm(size(pp_data, 1));
for i= 1:size(pp_data,1)
    dataset1(i,:) = pp_data(vec(i) , :);
end
