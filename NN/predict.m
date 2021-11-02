function out = predict(X,W1,W2,B1,B2)

U = X*W1;
Z1 = bsxfun(@plus , U' , B1');
Z1 = Z1';
Z = leaky_relu(Z1);
UU = Z*W2;
Y1 = bsxfun(@plus, UU' , B2);
Y1 = Y1';
out = Y1;

end
