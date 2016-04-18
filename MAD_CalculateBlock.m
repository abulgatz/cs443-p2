%Assumes that Each Block is size N X N
function MAD_Value = MAD_CalculateBlock(TargetFrame,referenceFrame,N,i,j,x,y)
difference = 0;
[row,col,l] = size(referenceFrame);
    for k = 0:1:N-1
        for l = 0:1:N-1
           if((x+i+k) <= 0 || (x+i+k) > row || (y+j+l) <= 0 || (y+j+l) > col)
               continue;
           end
           difference = difference + abs(TargetFrame(x+k,y+l) - referenceFrame(x+i+k,y+j+l));
        end
    end
    MAD_Value = difference;
 end