function [motionVectors, mcFrame] = blockMatchingSequential(targetFrame,referenceFrame,N,p)
    % Size of target
    [rows, cols, channels] = size(targetFrame);

    % Calculate number of macro block in image so that we know the size of our
    % motionVectors matrix, then create the motionVectors matrix
    numMacroBlocks = ceil(double(rows) / N) * ceil(double(cols) / N);
    motionVectors = zeros(2,numMacroBlocks);

    macroBlockNumber = 1; 
    
    % Convert target and reference frames to doubles because math
    targetFrame = im2double(targetFrame);
    referenceFrame = im2double(referenceFrame);
    
    % Initialize size of motion compensated frame
    % mcFrame = zeros(rows, cols);
    mcFrame = referenceFrame;

    % First pixel of each macro block.
    % (x,y) is the first pixel of the current macro block
    for x = 1:N:rows-N+1
        for y = 1:N:cols-N+1
            
            % Initialize minMAD so that first returned value from
            % MAD_CalculateBlock is always less than init value
            minMAD = 10000;
            % Loop through each pixel in search window
            % (i,j) is the current pixel of the search window
            for i = -p:p
               for j = -p:p
                    currMAD = calculateMAD(targetFrame,referenceFrame,N,i,j,x,y);
                    if(currMAD < minMAD)
                        minMAD = currMAD;
                        u = i;
                        v = j;
                    end
               end
            end
            motionVectors(1,macroBlockNumber) = u;
            motionVectors(2,macroBlockNumber) = v;
            macroBlockNumber = macroBlockNumber + 1;

            % Loop through each pixel in current macro block
            % (i,j) is current pixel in macro block
            for i = 1:N
                for j = 1:N
                    
                    x1 = x+i-1;
                    y1 = y+j-1;
                    
                    x2 = x1 + u;
                    y2 = y1 + v;
                    if(x2 < rows && y2 < cols && x2 > 0 && y2 > 0)
                        mcFrame(x2,y2) = referenceFrame(x1, y1);
                    end
                end
            end % end mcFrame generation

        end
    end % end macroblock loop
    
    mcFrame = im2uint8(mcFrame);
end