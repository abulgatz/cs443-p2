%Assumes that Each Block is size N X N
function MAD = calculateMAD(targetFrame,referenceFrame,N,i,j,x,y)
    difference = 0;
    [rows, cols ,channels] = size(referenceFrame);
    for k = 0:1:N-1
        for l = 0:1:N-1
            if((x+i+k) <= 0 || (x+i+k) > rows || (y+j+l) <= 0 || (y+j+l) > cols)
                continue;
            end
            difference = difference + abs(targetFrame(x+k,y+l) - referenceFrame(x+i+k,y+j+l));
        end
    end
    MAD = difference;
end