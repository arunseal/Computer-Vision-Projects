function [output,activations] = inference(model,input)
% Do forward propagation through the network to get the activation
% at each layer, and the final output

num_layers = numel(model.layers);
activations = cell(num_layers,1);
activations{1}=input;
% TODO: FORWARD PROPAGATION CODE
for i=1:num_layers
    temp_layer = model.layers{i};
    temp_func = temp_layer.fwd_fn;
    [output,~,~]=temp_func(input,temp_layer.params,temp_layer.hyper_params,false,0); 
    activations{i+1} = output;
    input = output;
end 
output = activations{end};
