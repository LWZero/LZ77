function [signal] = format_signal(image)
    % FORMAT_SIGNAL
    %   Flattens a 2D or 3D image into a vector.
    %
    % Arguments:
    %   image: The image to flatten presented as a 2D or 3D tensor of uint8.
    %
    % Returns:
    %   signal:
    %     The flattened image (the signal) as an array of uint8.

    % Validate arguments
    assert(ndims(image) >= 2 && numel(image) > 1 && isa(image(1), 'uint8'));
    
    % Format signal
    sig = permute(image,[2 1 3]);
    signal = reshape(sig, 1, numel(sig));
end
