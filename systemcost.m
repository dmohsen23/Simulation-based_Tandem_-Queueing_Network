    % NFR is a 2-dimensional matrix and for a system composed of 3 subsystem is defined as the following:
    %  NFR(1,:) = redunvect1      %The No. of conmponents and repair rate of subsystem 1
    %  NFR(2,:)=redunvect2        %The No. of conmponents and repair rate of subsystem 2
    %  NFR(3,:)=redunvect3        %The No. of conmponents and repair rate of subsystem 3
    % and so on
    %Example: redunvect1=[2 3 1 1 0.3];

    % For example if there are 4 subsystems in the main system, the first
    % dimension of this matrix would be of size 4.

    % CM is the matrix of components costs.
    % CM is a 2-dimensional matrix in which the first dimension is representative of the subsystems number.
    % Example: 
    % CM=[10 12 13;20 21 23];
    % CM is the cost matrix of a system with 2 subsystems in which 10 is the
    % cost of first component in subsystem 1 and 21 is the cost of second
    % component in subsystem 2.

    % Note: The first dimnesion of matrix CM should be the same as the first
    % dimension of matrix NFR.


function SC = systemcost(NFR,CM)

    % CM = [100 120 150 130;200 150 110 123;140 150 126 135;201 231 210 220];

    NFR_1 = NFR(:,1:end-1);

    SC = sum(sum(NFR_1.*CM));

end