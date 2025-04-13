function R = randomtime(FR,NFR)

redunvect= [];


for ii =1:length(NFR)
    
    redunvect = [redunvect FR(ii).*ones(1,NFR(ii))];
    
end

R = sum(exprnd(1./redunvect));


end







