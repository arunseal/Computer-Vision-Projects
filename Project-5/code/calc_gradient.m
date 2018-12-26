function [grad] = calc_gradient(model, input, activations, dv_output)
% Calculate the gradient at each layer, to do this you need dv_output
% determined by your loss function and the activations of each layer.
% The loop of this function will look very similar to the code from
% inference, just looping in reverse.

num_layers = numel(model.layers);
grad = cell(num_layers,1);

% TODO: Determine the gradient at each layer with weights to be updated
for i=1:num_layers
    input=activations(num_layers-i+1);
    temp_layer=model.layers(num_layers-i+1);
    temp_func=temp_layer.fwd_fn;
    [~,dv_input,grad(num_layers-i+1)]=temp_func(input, temp_layer,params, temp_layer.hyer_params, true, dv_output);
    dv_output=dv_input;
end