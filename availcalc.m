%%%%%%%%%%%%%%%Reliabiliy Paper%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%Availability of hot standby system is calculted%%%%%%%%%%%%%%%%%%%%

%Example:
% redunvect=[2 3 1 1 0.5];  % redunvect = [No. of  redundants,omega]
% omega=0.5; % Repair rate
% The first 4 elements of matrix redunvect are numbers of components is the
% subsystem and the last element is the repair rate considered for that
% subsystem.

function avail = availcalc(redunvect,subsysno,FR)

% FR is the failure rates matrix of components. Number of rows is the
% same as the number of subsystems.
% FR = [0.23 0.25 0.12 0.52;0.2 0.3 0.1 0.2;0.1 0.2 0.1 0.5;0.02 0.2 0.3 0.1];
 
omega = redunvect(end);

MTBF = sum((1./FR(subsysno,:)).*redunvect(1:end-1));
MTTR = omega^-1;

avail = MTBF/(MTBF+MTTR);
% clc;
% disp(['Availability = ' num2str(avail)]);
end
