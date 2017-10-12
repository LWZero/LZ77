function [signal] = lz77_decode(code, N, n1)
    % LZ77_DECODE
    %   Decodes a LZ77 code (presented as a vector of structures) using the LZ77 algorithm 
    %   with a sliding window of length N and a dictionary of length n1. 
    %
    % Arguments:
    %   code: The LZ77 code to decode using the LZ77 algorithm.
    %   N:    The length of the LZ77 sliding window (dictionary + view).
    %   n1:   The length of the dictionary.
    %
    % Returns:
    %   signal: 
    %     The decoded signal as an array of uint8. 
    %
    % Note:
    %   The structures used in the LZ77 code are of the following form:
    %       - 'idx' (uint8) the in-dictionary index offset for the first match
    %       - 'length' (uint8) the total consecutive match count
    %       - 'next' (uint8) the next unmatched symbol
    
    % Validate arguments
    assert(N > 0 && n1 > 0 && N > n1 && n1 < 255 && ismatrix(code) && numel(code) > 1 && isstruct(code(1)));
    
    % Determine dictionary length
    dictionaryMaxLength = n1;
    
    % Initialize dictionary
    dictionary = zeros(1, dictionaryMaxLength, 'uint8');
    
    % Initialize result (signal)
    signal = [];
    
    % Decode LZ77 triplets
    for codeTriplet = code(1:end)
        % Extract triplet values
        dictionaryIndex = codeTriplet.('idx');
        matchLenght = codeTriplet.('length');
        nextSymbol = codeTriplet.('next');
        
        % For each symbol of the prefix match, do the following
        for matchSubindex = 1:matchLenght
            % Find the symbol at the given dictionary index
            dictionarySymbol = dictionary(dictionaryMaxLength + 1 - dictionaryIndex);
            
            % Add the symbol found at the dictionary index to the decoded
            % signal and to the dictionary
            signal = [signal dictionarySymbol];
            dictionary(1:end - 1) = dictionary(2:end);
            dictionary(end) = dictionarySymbol;
        end
        
        % Once we have dealt with the prefix part, we simply add the
        % triplet's 'next' symbol to both the decoded signal and the
        % dictionary
        signal = [signal nextSymbol];
        dictionary(1:end - 1) = dictionary(2:end);
        dictionary(end) = nextSymbol;
    end
end
