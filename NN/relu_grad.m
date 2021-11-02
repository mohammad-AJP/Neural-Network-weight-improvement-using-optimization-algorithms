function out = relu_grad(X)

for i=1:size(X,1) 
    if X(i,1) >= 0
        out(i,1) = 1;
    else
        out(i,1) = 0;
    end
end
end