 
%% Syatem Availability%%

% NFR is a 2-dimensional matrix and for a system composed of 3 subsystem is defined as the following:
%  NFR(1,:) = redunvect1      %The No. of conmponents and repair rate of subsystem 1
%  NFR(2,:)=redunvect2        %The No. of conmponents and repair rate of subsystem 2
%  NFR(3,:)=redunvect3        %The No. of conmponents and repair rate of subsystem 3
% and so on
%Example: redunvect1=[2 3 1 1  0.3];
%                                 ---------  -----
%                                 No. of    Repair
%                                 comp.     rate

% For example if there are 4 subsystems in the main system, the first
% dimension of this matrix would be of size 4.



function SA = sysavailcalc(NFR,FR)

SA = 1;

for  ii = 1:size(NFR,1)
    
    SA = SA*availcalc(NFR(ii,:),ii,FR);
    
end

end