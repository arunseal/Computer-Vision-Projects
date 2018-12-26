function [model,trainloss_cross,testloss_cross,trainacc,testacc] = train(model,train_data,inlabels,test_data,outlabels,params,numIters)

% Initialize training parameters
% This code sets default values in case the parameters are not passed in.

% Learning rate
if isfield(params,'learning_rate') lr = params.learning_rate;
else lr = .01; end
% Weight decay
if isfield(params,'weight_decay') wd = params.weight_decay;
else wd = .0005; end
% Batch size
if isfield(params,'batch_size') batch_size = params.batch_size;
else batch_size = 128; end

% There is a good chance you will want to save your network model during/after
% training. It is up to you where you save and how often you choose to back up
% your model. By default the code saves the model in 'model.mat'
% To save the model use: save(save_file,'model');
if isfield(params,'save_file') save_file = params.save_file;
else save_file = 'model.mat'; end

% update_params will be passed to your update_weights function.
% This allows flexibility in case you want to implement extra features like momentum.
update_params = struct('learning_rate',lr,'weight_decay',wd);


trainloss_cross=zeros(numIters,1);
testloss_cross=zeros(floor(numIters/125),1);

for i = 1:numIters
    disp(i);
    vector=randperm(size(train_data,4));
    traininput_=train_data(:,:,:,vector);
    train_label_=inlabels(vector);
    
    traininput=traininput_(:,:,:,1:batch_size);
    train_label=train_label_(1:batch_size);   
    
    [trainoutput,activations] = inference_(model,traininput);   
    [trainloss_cross(i), dv_input] = loss_crossentropy_(trainoutput, train_label, update_params, true);
    dv_output=dv_input;
    [grad] = calc_gradient_(model, traininput, activations, dv_output);
    model= update_weights_(model,grad,update_params);	
    %[trainloss(i),~] = loss_euclidean(trainoutput,actual_in_labels,[],true);
    
    if mod(i,125)==0
        [testoutput,~] = inference_(model,test_data); 
        %[testloss(i/1),~] = loss_euclidean(testoutput,actual_out_labels,[],true);
        [testloss_cross(i/125), ~] = loss_crossentropy_(testoutput, outlabels, update_params, true);  
    end
end
%  if mod(i,100)==0%%
    [~,pred]=max(testoutput,[],1);
    total=length(outlabels); 
    matches=sum(pred==outlabels'); 
    testacc=matches/total;
%  else
%      testacc=0;
%  end
 

[~,pred1]=max(trainoutput,[],1);
total1=length(train_label);
matches1=sum(pred1==train_label');
trainacc=matches1/total1;


