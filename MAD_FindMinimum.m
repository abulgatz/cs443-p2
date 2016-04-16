function minimumValue = MAD_FindMinimum(MAD,p)
first = 0;
 for i = 1:p
     for j = 1:p
         if first == 0
             minimumValue = MAD(i,j);
         else
             first = 1;
             if(minimumValue > MAD(i,j)
                 minimumValue = MAD(i,j);
             end
         end  
     end
 end
end