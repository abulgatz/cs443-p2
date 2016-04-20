function frame = drawMotionVectors(frame, motionVectors, N)
    % Size of target
    [rows, cols, channels] = size(frame);

    macroBlockNumber = 1;
    
    % Convert target and reference frames to doubles because math
    frame = im2double(frame);

    % (x,y) is the upper left pixel of the current macro block
    for x = 1:N:rows-N+1
        for y = 1:N:cols-N+1
            
            % (i,j) is the middle pixel of the current macro block, or the
            % start of the line we are going to draw
            i = x + (N/2);
            j = y + (N/2);
            
            % Get motion vector for current macro block. u and v will tell
            % you the displacement, or what you need to add to (x,y) to get
            % the end point of the vector
            u = motionVectors(1,macroBlockNumber);
            v = motionVectors(2,macroBlockNumber);
            
            % (ii,jj) is the end of the line that we are going to dray
            ii = i+u;
            jj = j+v;
            
            if (i < rows &&...
                j < cols &&...
                ii > 0 &&...
                ii < rows &&...
                jj > 0 &&...
                jj < cols)
                % Now draw a line from (i,j) to (i+u), (j+v)
                frame = drawLine(frame, i, j, ii, jj, 1);
            end
            
            macroBlockNumber = macroBlockNumber + 1;

        end
    end % end macroblock loop
end