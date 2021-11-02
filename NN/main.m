clc;
close all
clear all
%% preparing dataset %%
load('data.mat');
dataset = dataset1./100;
train_mat = dataset(1:floor(0.8*size(dataset,1)) , :);
test_mat = dataset(floor(0.8*size(dataset,1))+1 : size(dataset,1)  , :);

train_data = train_mat(: , 1:5);
X = train_data(1:5700,:);
validX = train_data(5701:6341 ,:);
train_tar = train_mat(: , 6);
T = train_tar(1:5700,:);
validtar = train_tar(5701:6341 ,:);
test_data = test_mat(: , 1:5);
test_tar = test_mat(: , 6);
%% parameters %%
max_epoch = 50;
alpha = 0.000001;
%% initial values %%
m = size(X , 1);
n = size(X , 2);
h = 10; %% # of hidden units

%% training section %%
for q = 1:50
    q
    W1 = 0.1*rand(n , h); %% 5*10
    W2 = 0.1*rand(h , 1); %% 10*1
    B1 = 0.1*rand(1 , h); %% 1*10
    B2 = 0.1*rand(1 , 1); %% 1*1
    for i = 1:max_epoch
        i
        %% feedforward %%
        U = train_data*W1;
        Z_in = bsxfun(@plus, U' , B1');
        Z_in = Z_in';
        Z = leaky_relu(Z_in);
        UU = Z*W2;
        Y_in = bsxfun(@plus, UU' , B2);
        Y_in = Y_in';
        Y = relu(Y_in);
        %% backpropagation %%
        delta_out = train_tar - Y;
        dif_Y = relu_grad(Y_in);
        delta_output = delta_out.*dif_Y;
        deltaW2 = alpha*delta_output'*Z;
        deltaB2 = alpha*1/m * sum(delta_out);
        W2 = W2 + deltaW2';
        B2 = B2 + deltaB2;
        
        A = delta_output*W2';
        dif_Z = leaky_grad(Z_in);
        B = bsxfun(@times, A ,dif_Z);
        deltaW1 = alpha*train_data'*B;
        deltaB1 = alpha*1/m * sum(B);
        W1 = W1 + deltaW1;
        B1 = B1 + deltaB1;
        %% evaluation
        yhat = predict(train_data,W1,W2,B1,B2);
        yhatt = predict(validX,W1,W2,B1,B2);
        RMSE(1,i) = rsme(yhat , train_tar);
        RMSE2(1,i) = rsme(yhatt , validtar);
        r1 = reshape(W1,1,50);
        r2 = reshape(W2,1,10);
    end
    Weights(q,:) = [r1,r2,B1,B2];
    epo = [1:max_epoch];
    figure
    plot(epo,RMSE,'-b')
    hold on
    plot(epo,RMSE2 , '--r')
end
