function [uValues,vValues] = PsuedoCodeVersion(targetFrame,referenceFrame,N,p)
[rows, cols,q] = size(targetFrame);
 macro_block_number = 1;    
 targetFrame = im2double(targetFrame);
 referenceFrame = im2double(referenceFrame);
 for x = 1 : N : rows-N+1
    for y = 1 : N : cols-N+1
        min_MAD = 10000;
        for i = -p:p
           for j = -p:p
                cur_MAD = MAD_CalculateBlock(targetFrame,referenceFrame,N,i,j,x,y);
                if(cur_MAD < min_MAD)
                   min_MAD = cur_MAD;
                   u = i;
                   v = j;
                end
            end
        end
        uValues(1,macro_block_number) = u;
        vValues(1,macro_block_number) = v;
        macro_block_number = macro_block_number + 1;
    end
 end
end