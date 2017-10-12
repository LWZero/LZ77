function [compressionRatio] = compute_compression_ratio(originalSignalLength, compressedSignalLength)
    % COMPUTE_COMPRESSION_RATIO
    %   Computes a compression ratio using an original signal length and a compressed signal length.
    %
    % Arguments:
    %   originalSignalLength:   The length of the original signal in bytes.
    %   compressedSignalLength: The length of the compressed signal (code) in bytes.
    %
    % Returns:
    %   compressionRatio:
    %     The computed compression ratio as a floating point number.
    
    compressionRatio = 1 - (double(compressedSignalLength) / double(originalSignalLength));
end
