% ----------------------------------------------------------------------
% input: in_height x in_width x num_channels x batch_size
% output: out_height x out_width x num_filters x batch_size
% hyper parameters: (stride, padding for further work)
% params.W: filter_height x filter_width x filter_depth x num_filters
% params.b: num_filters x 1
% dv_output: same as output
% dv_input: same as input
% grad.W: same as params.W
% grad.b: same as params.b
% ----------------------------------------------------------------------

function [output, dv_input, grad] = fn_conv(input, params, hyper_params, backprop, dv_output)

[~,~,num_channels,batch_size] = size(input);
[~,~,filter_depth,num_filters] = size(params.W);
assert(filter_depth == num_channels, 'Filter depth does not match number of input channels');

out_height = size(input,1) - size(params.W,1) + 1;
out_width = size(input,2) - size(params.W,2) + 1;
output = zeros(out_height,out_width,num_filters,batch_size);
filter=params.W;


%TODO: FORWARD CODE
for i=1:batch_size
    for j=1:num_filters
        comp1 = zeros(out_height,out_width,filter_depth);
        for k = 1:filter_depth
            C = conv2(input(:,:,k,i),filter(:,:,k,j),'valid');
            comp1(:,:,k) = C;
        end
       output(:,:,j,i) = sum(comp1,3)+params.b(j);
    end
end

dv_input = [];
grad = struct('W',[],'b',[]);

        

if backprop
	dv_input = zeros(size(input));
	grad.W = zeros(size(params.W));
	grad.b = zeros(size(params.b));
	% TODO: BACKPROP CODE
    for i=1:num_channels
      for j=1:num_filters
          mat = zeros(size(params.W,1),size(params.W,2),batch_size);
          for k=1:batch_size
              mat(:,:,k)=rot90(conv2(input(:,:,i,k),rot90(dv_output(:,:,j,k),2),'valid'),2);
          end
          grad.W(:,:,i,j)=sum(mat,3)./batch_size;
      end
    end
    
    for j=1:num_filters
        grad.b(j) = grad.b(j)+sum(sum(sum(dv_output(:,:,j,:))));
    end
    grad.b=grad.b./batch_size;
    
    for i=1:batch_size
        for j=1:filter_depth
            comp2 = zeros(size(input,1),size(input,2),num_filters);
            for k=1:num_filters
                f = rot90(filter(:,:,j,k),2);
                C = conv2(dv_output(:,:,k,i),f,'full');
                comp2(:,:,k) = C;
            end
            dv_input(:,:,j,i) = sum(comp2,3);
        end
    end

end