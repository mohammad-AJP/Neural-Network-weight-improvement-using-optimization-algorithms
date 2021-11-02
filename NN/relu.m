function out = relu(X)

for i=1:size(X,1) 
    a(i,1) = max(0,X(i,1));
    out = a(:,1);
end
end