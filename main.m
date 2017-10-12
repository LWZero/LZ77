close all;
clear;
clc;

test_image_paths = { ...
    'data/test1.png', ...
    'data/test2.png', ...
    'data/test3.png', ...
    'data/test4.png', ...
    'data/test5.png', ...
    'data/test6.png', ...
    'data/test7.png', ...
};

slidingWindowLength = 300;
dictionaryLength = 30;
            
for t = 1:numel(test_image_paths)
    originalImageFilePath = test_image_paths{t};
    
    disp('============================================================');
    disp(['Testing codec with: ', originalImageFilePath]);
    disp('------------------------------------------------------------');
    
    originalImage = imread(originalImageFilePath);

    disp('Preparing image file for encoding...');
    originalSignal = format_signal(originalImage);
    disp('Image file ready for encoding.');

    disp('Encoding...');
    code = lz77_encode(originalSignal, slidingWindowLength, dictionaryLength);
    disp('Encoding complete.');

    disp('Decoding...');
    finalSignal = lz77_decode(code, slidingWindowLength, dictionaryLength);
    disp('Decoding complete.');
    
    disp('Reconstructing image file...');
    finalImage = reformat_image(finalSignal, size(originalImage));
    disp('Image file reconstructed.');

    disp('Veryfying that decoded image matches original image exactly...');
    if isequal(finalImage, originalImage)
        disp('Decoded image does match original image exactly.');
    else
        error('Decoded image does not match original image exactly.');
    end

    uncompressedSignalLength = numel(originalSignal);
    compressedSignalLength = numel(code) * 3;
    disp(['Uncompressed signal length (in bytes): ', num2str(uncompressedSignalLength)]);
    disp(['Compressed signal length (in bytes): ', num2str(compressedSignalLength)]);
    disp(['Compression ratio: ', num2str(compute_compression_ratio(uncompressedSignalLength, compressedSignalLength))]);

    disp('Generating visual comparison figure...');
    fig = figure;
    set(gcf,'Visible','off');
    axis off;
    axis equal;
    set(gcf, 'color', [0.8 0.8 0.8]);
    subplot(1, 2, 1);
    subimage(originalImage);
    title('Original image');
    subplot(1, 2, 2);
    subimage(finalImage);
    title('Image after encoding and decoding');
    figureFilePath = strcat('fig/', originalImageFilePath(6:end));
    print(fig, '-dpng', figureFilePath);
    disp(['Visual comparison figure generated and saved to "', figureFilePath, '".']);
    
    disp('============================================================');
end
