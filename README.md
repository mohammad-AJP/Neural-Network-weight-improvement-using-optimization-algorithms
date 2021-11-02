# Neural-Network-weight-improvement-using-optimization-algorithms
Gray Wolf Optimization (GWO), Imperialist Competitive Algorithm (ICA) and Particle Swarm Optimization (PSO) are used to improve the weights achieved by a Neural Network trained with Gradient Descent method. 
the data used in this repo is NASA trace network gathered in july. the data is processed using "data_pre.m" which from adds the number of requests and responses of every 5 minutes so that we have a number for every five minutes from the day 1 to the day 28 of july. then 6 of these numbers creates a row of the data in which the first 5 are inputs and the last number is treated as the target data.  
a Neural network is used to predict the achieved time series which has 7927 rows of data which exploits gradient descent method.  
then the weights are optimized through GWO, ICA and PSO algorithms to improve the total performance of the system. the data and codes are categorized into 4 separate directories. 
