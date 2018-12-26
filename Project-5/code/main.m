load_MNIST_data
addpath pcode
addpath layers


%% check the input and label
% testdata=test_data(:,:,:,1);
% testlabels=test_label(1);

%% model initialisation

mylayers = [init_layer('conv',struct('filter_size',5,'filter_depth',1,'num_filters',20))   
    init_layer('relu',[])	
	init_layer('pool',struct('filter_size',2,'stride',2))
    init_layer('conv',struct('filter_size',5,'filter_depth',20,'num_filters',50))   
    init_layer('relu',[])
	init_layer('pool',struct('filter_size',2,'stride',2))
	init_layer('flatten',struct('num_dims',4))     
	init_layer('linear',struct('num_in',800,'num_out',10))
	init_layer('softmax',[])];

%% Select train and test data

%% Training and Testing

model=init_model(mylayers,size(train_data(:,:,:,1:128)),10,true);

learning_rate=[0.01];
weight_decay= 0.0005;
trainaccuracy=zeros(length(weight_decay),1);
testaccuracy=zeros(length(weight_decay),1);

for i=1:length(learning_rate)   
    tic
    params=struct('learning_rate',learning_rate,'weight_decay',0.0005,'batch_size',128);
    
    [model,trainloss_cross,testloss_cross,trainaccuracy(i),testaccuracy(i)]=train(model,train_data,train_label,test_data,test_label,params,500);

    figure(2*i-1);
    plot(trainloss_cross);
    legend("Cross-entropy Training Loss");
    title(['Training Loss for learning rate:' num2str(learning_rate(i))]);

    figure(2*i);
    plot(testloss_cross);
    legend("Cross-entropy Test Loss");
    title(['Test Loss for learning rate:' num2str(learning_rate(i))]);
    toc
end