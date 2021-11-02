clc;
clear;
close all;

%% Problem Definition
%% loading dataset %%
load('Weight_mat.mat')
load('trainset.mat')
load('testset.mat')

var_num=71;            
VarSize=[1 var_num];  
VarMin=-5;        
VarMax= 5;       
%% PSO Parameters
max_epoch=100;      
ini_pop=50;        

% Constriction Coefficients
phi1=2.1;
phi2=2.1;
phi=phi1+phi2;
khi=2/(phi-2+sqrt(phi^2-4*phi));
w=khi;          % Inertia Weight
wdamp=0.99;        % Inertia Weight Damping Ratio
c1=khi*phi1;    % Personal Learning Coefficient
c2=khi*phi2;    % Global Learning Coefficient

% Velocity Limits
VelMax=0.1*(VarMax-VarMin);
VelMin=-VelMax;
%% Initialization

empty_particle.Position=[];
empty_particle.Cost=[];
empty_particle.Velocity=[];
empty_particle.Best.Position=[];
empty_particle.Best.Cost=[];

particle=repmat(empty_particle,ini_pop,1);  
GlobalBest.Cost=inf;
Cost_Test= zeros(50,1);
for i=1:ini_pop
    
    % Initialize Position
    particle(i).Position= WEIGHTS(i ,:);
    
    % Initialize Velocity
    particle(i).Velocity=zeros(VarSize);
    
    % Evaluation
    particle(i).Cost=mape_calc(particle(i).Position,trainset);
    Cost_Test(i)=mape_calc(particle(i).Position,testset);
    % Update Personal Best
    particle(i).Best.Position=particle(i).Position;
    particle(i).Best.Cost=particle(i).Cost;
    
    % Update Global Best
    if particle(i).Best.Cost<GlobalBest.Cost
        
        GlobalBest=particle(i).Best;
        
    end
    
end

BestCost_Train=zeros(max_epoch,1);
BestCost_Test=zeros(max_epoch,1);
[~, SortOrder]=sort(Cost_Test);
Cost_Test =Cost_Test(SortOrder);
%% PSO Main Loop
for it=1:max_epoch
    for i=1:ini_pop
        % Update Velocity
        particle(i).Velocity = w*particle(i).Velocity ...
            +c1*rand(VarSize).*(particle(i).Best.Position-particle(i).Position) ...
            +c2*rand(VarSize).*(GlobalBest.Position-particle(i).Position);
        
        % Apply Velocity Limits
        particle(i).Velocity = max(particle(i).Velocity,VelMin);
        particle(i).Velocity = min(particle(i).Velocity,VelMax);
        
        % Update Position
        particle(i).Position = particle(i).Position + particle(i).Velocity;
        IsOutside=(particle(i).Position<VarMin | particle(i).Position>VarMax);
        particle(i).Velocity(IsOutside)=-particle(i).Velocity(IsOutside);
        
        % Apply Position Limits
        particle(i).Position = max(particle(i).Position,VarMin);
        particle(i).Position = min(particle(i).Position,VarMax);
        
        % Evaluation
        particle(i).Cost = mape_calc(particle(i).Position,trainset);
        for l= 1:ini_pop
          Cost_Test(l)=mape_calc(particle(l).Position,testset);
        end
        [~, SortOrder]=sort(Cost_Test);
        Cost_Test =Cost_Test(SortOrder);
        BestCost_Test(it) = Cost_Test(1);
        % Update Personal Best
        if particle(i).Cost<particle(i).Best.Cost
            
            particle(i).Best.Position=particle(i).Position;
            particle(i).Best.Cost=particle(i).Cost;
            
            % Update Global Best
            if particle(i).Best.Cost<GlobalBest.Cost
                
                GlobalBest=particle(i).Best;
                
            end
            
        end
        
    end
    
    BestCost_Train(it)=GlobalBest.Cost;
    disp(['epochs ' num2str(it) ', cost on train data = ' num2str(BestCost_Train(it)) ', cost on test data = ' num2str(BestCost_Test(it))]);
    w=w*wdamp;
    
end

%% Results
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