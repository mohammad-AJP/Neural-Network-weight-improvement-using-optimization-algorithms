function out = rsme(yhat , train_tar)

a = 0;
for i = 1:size(train_tar,1)
    a = a + (yhat(i,1) - train_tar(i,1))^2;
end
b = a/size(train_tar,1);
out = sqrt(b); 
end
    