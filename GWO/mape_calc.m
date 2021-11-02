function MAPE_train = mape_calc(weight,trainset)
        W1 = reshape(weight(1:50),10,5);
        B1 = reshape(weight(51:60),10,1);
        W2 = weight(61:70);
        B2 = weight(71);
        target = trainset(:,6);
        output = zeros(size(trainset,1),1);
        for j=1:size(trainset,1)
            x = trainset(j,1:5);
            z_in = x*W1'+B1';
            z = max(0,z_in);
            y = W2*z' + B2;
            output(j) = max(0,y);
        end
        MAPE_train = sum(abs((output-target))./target)/size(trainset,1);
    
end