function NNFR = position_modify(NFR,FR)


[ii,jj]=find(~(sum(NFR,2)>0));


for jj = ii'

[a , b] = min(FR(jj,:));
NFR(jj,b) = 1;

end

NNFR = NFR;

end