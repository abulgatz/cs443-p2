function motionVectors = PsuedoCodeVersion(targetFrame,referenceFrame,N,p)
 [rows, cols,q] = size(targetFrame);
 macro_block_number = 1;    
 for x = 1 : N : rows-N+1
    for y = 1 : N : cols-N+1
        min_MAD = 100000000000000;
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
        motionVectors(1,macro_block_number) = u;
        motionVectors(2,macro_block_number) = v;
        macro_block_number = macro_block_number + 1;
    end
 end
end