%%%%%%%%%%%%%%%Reliabiliy Paper%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%Costs of  the queueing system%%%%%%%%%%%%%%%%%%%%

%cr is the repair cost per unit time .
%ch is the customer's holding cost per unit time.

function totalcostwarm = queuecostcalc(Totalqueue,Totalrepair)

ch = 10;
cr = 100;


totalcostwarm =  ch*Totalqueue + cr*Totalrepair;

% clc;
% disp(['Repair cost is= ' num2str(cr*Totalrepair)]);
% disp(['Customer's holding cost is= ' num2str(ch*Totalqueue)]);


end
