
clc;
clear;
close all;
load('weight_mat.mat')
load('trainset.mat')
load('testset.mat')
global trainset;
%% Problem Definition  
CostFunction=@(voroodi,trainset) mape_calc(voroodi,trainset);       
var_num=71;             
VarSize=[1 var_num];   
VarMin=-5;        
VarMax= 5;         
%% ICA Parameters
max_epoch=2000;        
ini_pop=50;           
em_num=4;            
nCol=ini_pop-em_num;
alpha=1;            % Selection Pressure
beta=1.5;           % Assimilation Coefficient
pRevolution=0.05;   % Revolution Probability
mu=0.1;             % Revolution Rate
zeta=0.2;           % Colonies Mean Cost Coefficient
%% Globalization of Parameters and Settings
global ProblemSettings;
ProblemSettings.CostFunction=CostFunction;
ProblemSettings.nVar=var_num;
ProblemSettings.VarSize=VarSize;
ProblemSettings.VarMin=VarMin;
ProblemSettings.VarMax=VarMax;
global ICASettings;
ICASettings.MaxIt=max_epoch;
ICASettings.nPop=ini_pop;
ICASettings.nEmp=em_num;
ICASettings.alpha=alpha;
ICASettings.beta=beta;
ICASettings.pRevolution=pRevolution;
ICASettings.mu=mu;
ICASettings.zeta=zeta;
%% Initialization
% Initialize Empires
empty_country.Position=[];
empty_country.Cost=[];
Cost_Test= zeros(50,1);
country=repmat(empty_country,ini_pop,1);
for i=1:ini_pop
        country(i).Position=WEIGHTS(i ,:);
        country(i).Cost=CostFunction(country(i).Position,trainset);
        Cost_Test(i)=CostFunction(country(i).Position,testset);
end
    
    costs=[country.Cost];
    [~, SortOrder]=sort(costs);  
    country=country(SortOrder);
    [~, SortOrder]=sort(Cost_Test);
    Cost_Test =Cost_Test(SortOrder);
    
    imp=country(1:em_num);
    col=country(em_num+1:end); 
    empty_empire.Imp=[];
    empty_empire.Col=repmat(empty_country,0,1);
    empty_empire.nCol=0;
    empty_empire.TotalCost=[];
    emp=repmat(empty_empire,em_num,1);
    
    % Assign Imperialists
    for k=1:em_num
        emp(k).Imp=imp(k);
    end
    
    % Assign Colonies
    P=exp(-alpha*[imp.Cost]/max([imp.Cost]));
    P=P/sum(P);
    for j=1:nCol
        
        k=RouletteWheelSelection(P);
        emp(k).Col=[emp(k).Col
                    col(j)];
        emp(k).nCol=emp(k).nCol+1;
    end
    
    emp=UpdateTotalCost(emp);

% Array to Hold Best Cost Values
BestCost_Train=zeros(max_epoch,1);
BestCost_Test=zeros(max_epoch,1);
nfe=zeros(max_epoch,1);
%% ICA Main Loop
for it=1:max_epoch

    % Assimilation
    emp=AssimilateColonies(emp);
    
    % Revolution
    emp=DoRevolution(emp);
    
    % Intra-Empire Competition
    emp=IntraEmpireCompetition(emp);
    
    % Update Total Cost of Empires
    emp=UpdateTotalCost(emp);
    
    % Inter-Empire Competition
    emp=InterEmpireCompetition(emp);
    
    % Update Best Solution Ever Found
    imp=[emp.Imp];
    [~, BestImpIndex]=min([imp.Cost]);
    BestSol=imp(BestImpIndex);
    % Update Best Cost
    BestCost_Train(it)=BestSol.Cost;
    switch numel(emp)
        case 4
            M = [1,emp(1).nCol+1,1+emp(1).nCol+emp(2).nCol,1+emp(1).nCol+emp(2).nCol+emp(3).nCol];
            N=[emp(1).nCol,emp(1).nCol+emp(2).nCol,emp(1).nCol+emp(2).nCol+emp(3).nCol,emp(1).nCol+emp(2).nCol+emp(3).nCol+emp(4).nCol];
        case 3
            M = [1,emp(1).nCol+1,1+emp(1).nCol+emp(2).nCol];
            N=[emp(1).nCol,emp(1).nCol+emp(2).nCol,emp(1).nCol+emp(2).nCol+emp(3).nCol];
        case 2
            M = [1,emp(1).nCol+1];
            N=[emp(1).nCol,emp(1).nCol+emp(2).nCol];
        case 1
            M = 1;
            N=[emp(1).nCol];
    end
    o=1;
    for m=1 : numel(emp)
        for n = M(m) : N(m)
           Cost_Test(n)=CostFunction(emp(m).Col(o).Position,testset); 
           o=o+1;
        end
        o=1;
    end
    for l=1 :numel(emp)
        Cost_Test(l + N(end))=CostFunction(imp(l).Position,testset);
    end
    [~, SortOrder]=sort(Cost_Test);
    Cost_Test =Cost_Test(SortOrder);
    BestCost_Test(it) = Cost_Test(1);
    % Show Iteration Information
    disp(['epoch ' num2str(it) ', cost on train data = ' num2str(BestCost_Train(it)) ', cost on test data = ' num2str(BestCost_Test(it))]);
    
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
