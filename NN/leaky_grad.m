function out = leaky_grad(X)

for i=1:size(X,1)
    for j = 1:10
        if X(i,j) >= 0
            out(i,j) = 1;
        else
            out(i,j) = 1/20;
        end
    end
end
end