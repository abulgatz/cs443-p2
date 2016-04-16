%Assumes that Each Block is size N X N
function MAD_Value = MAD_CalculateBlock(TargetFrameBlock,referenceFrameBlock,N,x,y,i,j)
    for k = 0:1:N-1
        for l = 0:1:N-1
           difference = difference + abs(TargetFrame(x+k,y+l) - referenceFrame(x+i+k,y+j+l));
        end
    end
    MAD_Value = (1/N^2)*difference;
 end