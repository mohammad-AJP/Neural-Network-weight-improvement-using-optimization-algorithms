function out=leaky_relu(X)

for i=1:size(X,1)
    for j = 1:10
        if X(i,j) >= 0
            out(i,j) = X(i,1);
        else
            out(i,j) = 1/20*X(i,1);
        end
    end
end
end


