clc;
clear;
close all;
%% Problem Definition
load('trainset.mat')
load('testset.mat')
load('weight_mat.mat')

var_num=71;            
VarSize=[1 var_num];   
VarMin=-5;         
VarMax= 5;         
%% GWO Parameters
max_epoch=1500;      
ini_pop=50;      
empty_wolf.Position=[];
empty_wolf.Cost=[];
wolf=repmat(empty_wolf,ini_pop,1);
Cost_Test= zeros(50,1);
for i=1:ini_pop
    % Initialize Position
    wolf(i).Position= WEIGHTS(i ,:); 
    % Evaluation
    wolf(i).Cost=mape_calc(wolf(i).Position,trainset);
    Cost_Test(i)=mape_calc(wolf(i).Position,testset);
end

BestCost_Train=zeros(max_epoch,1);
BestCost_Test=zeros(max_epoch,1);
costs=[wolf.Cost];
[~, SortOrder]=sort(costs);
wolf=wolf(SortOrder);

[~, SortOrder]=sort(Cost_Test);
Cost_Test =Cost_Test(SortOrder);

% nfe=zeros(max_epoch,1);

%% GWO Main Loop
for epoch=1:max_epoch
    alfa = wolf(1);
    beta = wolf(2);
    delta = wolf(3);
    omegas = wolf(4:end);

    a = 2-(epoch/max_epoch);
    for j=1 :47
    A1 = 2*a*rand(1,71)-a;
    A2 = 2*a*rand(1,71)-a;
    A3 = 2*a*rand(1,71)-a;
    
    c1 = 2*rand(1,71);
    c2 = 2*rand(1,71);
    c3 = 2*rand(1,71);
    d_alfa = abs(c1.*(alfa.Position) - omegas(j).Position);
    d_beta = abs(c2.*(beta.Position) - omegas(j).Position);
    d_delta = abs(c3.*(delta.Position) - omegas(j).Position);
    
    new_omegas_1 = alfa.Position - A1.*d_alfa;
    new_omegas_2 = beta.Position - A2.*d_beta;
    new_omegas_3 = delta.Position - A3.*d_delta;
    omegas(j).Position = (new_omegas_1+new_omegas_2+new_omegas_3)/3;
    omegas(j).Cost = mape_calc(omegas(j).Position,trainset);
    end
    
      wolf(1)=alfa;
      wolf(2) = beta;
      wolf(3)= delta;
      wolf(4:end) = omegas;
      for l= 1:ini_pop
          Cost_Test(l)=mape_calc(wolf(l).Position,testset);
      end
      [~, SortOrder]=sort(Cost_Test);
      Cost_Test =Cost_Test(SortOrder);
      BestCost_Test(epoch) = Cost_Test(1);
      
      costs=[wolf.Cost];
      [~, SortOrder]=sort(costs);
      wolf=wolf(SortOrder); 
      BestCost_Train(epoch) = wolf(1).Cost;
      
%       nfe(epoch)=NFE;
      disp(['Iteration ' num2str(epoch)  ', cost on train data = ' num2str(BestCost_Train(epoch)) ', cost on test data = ' num2str(BestCost_Test(epoch))]);

end

%%  diagrams %%
figure;
semilogx(BestCost_Train,'LineWidth',2);
xlabel('epochs');
ylabel('train costs');
grid on;

figure;
semilogx(BestCost_Test,'LineWidth',2);
xlabel('epochs');
ylabel('test costs');
grid on;





