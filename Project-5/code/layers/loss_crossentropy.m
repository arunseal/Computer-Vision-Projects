% ----------------------------------------------------------------------
% input: num_nodes x batch_size
% labels: batch_size x 1
% ----------------------------------------------------------------------

function [loss, dv_input] = loss_crossentropy(input, labels, hyper_params, backprop)

assert(max(labels) <= size(input,1));
if isfield(hyper_params, 'num_dims') 
    num_dims = hyper_params.num_dims;
else
    num_dims = 2;
end
batch_size = size(input, num_dims);

% TODO: CALCULATE LOSS
I = sub2ind(size(input),labels',1:size(input,2));
p = input(I);
lp = log(p);
loss = -sum(lp) / batch_size;
dv_input = zeros(size(input));
if backprop
	% TODO: BACKPROP CODE
    label_vec = zeros(size(input));
    for i=1:batch_size
       ind = labels(i);
       label_vec(ind,i)=1;  
    dv_input(:,i) = -bsxfun(@ldivide,input(:,i),label_vec(:,i)); 
    end 
end
