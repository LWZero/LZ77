function [image] = reformat_image(signal, img_size)
    % REFORMAT_IMAGE
    %   Reshapes a signal vector into an image tensor with the dimensions given in img_size.
    %
    % Arguments:
    %   signal:   The signal to reshape presented as a vector of uint8.
    %   img_size: The dimensions of the tensor into which the image signal will be reshaped.
    %
    % Returns:
    %   image:
    %     The reconstructed image as a 2D or 3D tensor of uint8.
    
    % Validate arguments
    assert(numel(img_size) >= 2 && ismatrix(signal) && numel(signal) > 1 && isa(signal(1), 'uint8'));
    
    % Reformat image
    if numel(img_size) == 3
        image = permute(reshape(signal, [img_size(2) img_size(1) img_size(3)]), [2 1 3]);
    else
        image = reshape(signal, [img_size(2) img_size(1)])';
    end
end
