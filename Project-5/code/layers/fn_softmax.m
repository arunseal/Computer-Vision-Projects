% ----------------------------------------------------------------------
% input: num_nodes x batch_size
% output: num_nodes x batch_size
% ----------------------------------------------------------------------

function [output, dv_input, grad] = fn_softmax(input, params, hyper_params, backprop, dv_output)

[num_classes,batch_size] = size(input);
output = zeros(num_classes, batch_size);
% TODO: FORWARD CODE
for k=1:batch_size
    output(:,k) = exp(input(:,k))/sum(exp(input(:,k)));
end
dv_input = [];

% This is included to maintain consistency in the return values of layers,
% but there is no gradient to calculate in the softmax layer since there
% are no weights to update.
grad = struct('W',[],'b',[]); 
dv_input = zeros(size(input));
temp = zeros(num_classes);
if backprop
    % TODO: BACKPROP CODE
    for k=1:batch_size
        for i=1:num_classes
            for j=1:num_classes
                if(i==j)
                    temp(i,j)= (output(i,k)*(1-output(i,k)));
                else 
                    temp(i,j)= (-output(i,k)*output(j,k));
                end 
            end 
        end 
        dv_input(:,k) = temp * dv_output(:,k);
    end 
end             
end
