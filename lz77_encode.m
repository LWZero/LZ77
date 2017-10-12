function [code] = lz77_encode(signal, N, n1)
    % LZ77_ENCODE
    %   Encodes a signal (presented as a uint8 vector) using the LZ77 algorithm 
    %   with a sliding window of length N and a dictionary of length n1. 
    %
    % Arguments:
    %   signal: The signal to encode using the LZ77 algorithm.
    %   N:      The length of the LZ77 sliding window (dictionary + view).
    %   n1:     The length of the dictionary.
    %
    % Returns:
    %   code: 
    %     An array of structures, each with three fields:
    %       - 'idx' (uint8) the in-dictionary index offset for the first match
    %       - 'length' (uint8) the total consecutive match count
    %       - 'next' (uint8) the next unmatched symbol
    %     Initialize LZ77 code triplets as follows: 
    %       triplet = struct('idx', uint8(..), 'length', uint8(..), 'next', uint8(..));
    
    % Validate arguments
    assert(N > 0 && n1 > 0 && N > n1 && n1 < 255 && ismatrix(signal) && numel(signal) > 1 && isa(signal(1), 'uint8'));
    
    % Determine signal, dictionary and view length
    signalLength = numel(signal);
    slidingWindowMaxLength = N;
    dictionaryMaxLength = n1;
    
    % Initialize signal index, sliding window, and result (code)
    signalIndex = 1;
    slidingWindow = zeros(1, dictionaryMaxLength, 'uint8');
    code = [];
    
    while true
        % Fill the sliding window as much as possible (as long a there are remaining signal elements)
        nElementsToAdd = min(signalLength - signalIndex + 1, slidingWindowMaxLength - numel(slidingWindow));
        slidingWindow = [slidingWindow signal(signalIndex:signalIndex + nElementsToAdd - 1)];
        signalIndex = signalIndex + nElementsToAdd;

        viewLength = numel(slidingWindow) - dictionaryMaxLength;
        
        if viewLength == 0
            break;
        end

        % Find the longest view prefix that starts in the dictionary
        view = slidingWindow(dictionaryMaxLength + 1:end);
        matchStartIndex = 0;
        matchLength = 0;
        nextSymbol = 0;
        
        if viewLength == 1
            nextSymbol = view(viewLength);
        else
            for viewIndex = 1:viewLength;
                % Determine the view prefix to match
                viewPrefix = view(1:viewIndex);
                viewPrefixLength = viewIndex;

                % Try matching the view prefix from the dictionary
                isViewPrefixMatched = false;
                for dictionaryIndex = 1:dictionaryMaxLength
                    dictionarySequence = slidingWindow(dictionaryMaxLength + 1 - dictionaryIndex:dictionaryMaxLength - dictionaryIndex + viewPrefixLength);
                    if isequal(dictionarySequence, viewPrefix)
                        isViewPrefixMatched = true;
                        matchStartIndex = dictionaryIndex;
                        break;
                    end
                end

                % If view prefix is matched, we try to match a longer view prefix
                if isViewPrefixMatched
                    % Here, we check if we can match a longer prefix, otherwise we break
                    if viewIndex == 256
                        matchLength = viewIndex - 1;
                        nextSymbol = view(viewIndex);
                        break;
                    elseif viewIndex == viewLength - 1
                        matchLength = viewIndex;
                        nextSymbol = view(viewLength);
                        break;
                    end
                % If the view prefix does not match, we cannot encode it further, so we break
                else
                    matchLength = viewIndex - 1;
                    nextSymbol = view(viewIndex);
                    break
                end
            end
        end

        % Once the longest view prefix that starts in the dictionary is determined, we simply encode it in a structure
        code = [code struct('idx', uint8(matchStartIndex), 'length', uint8(matchLength), 'next', uint8(nextSymbol))];

        % Shift out the oldest elements of the sliding window
        shiftLength = matchLength + 1;
        slidingWindow = slidingWindow(shiftLength + 1:end);
    end
end
