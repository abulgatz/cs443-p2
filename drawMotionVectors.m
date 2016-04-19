function outputFrame = drawMotionVectors(frame,motionVectors)
    % Size of target
    [rows, cols, channels] = size(frame);

    macroBlockNumber = 1;
    
    % Convert target and reference frames to doubles because math
    frame = im2double(frame);

    % First pixel of each macro block.
    % (x,y) is the first pixel of the current macro block
    for x = 1:N:rows-N+1
        for y = 1:N:cols-N+1
            
            % Bounds checking to make sure don't go out of image matrix
            middleCurrMacroBlockX = x + N/2;
            middleCurrMacroBlockY = y + N/2;
            
            % Get motion vector for current macro block. U and V will tell
            % you the displacement, or what you need to add to (x,y) to get
            % the end point of the vector
            u = motionVectors(1,macroBlockNumber);
            v = motionVectors(2,macroBlockNumber);
            
            % Now draw a line from (x,y) to (x+u), (y+v)
            
            macroBlockNumber = macroBlockNumber + 1;

        end
    end % end macroblock loop
end