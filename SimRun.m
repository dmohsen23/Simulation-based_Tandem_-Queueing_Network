function SR = SimRun()
    % clear;
    % close all;
    % clc;

    %  NFR is a 2-dimensional matrix and for a system composed of 3 subsystem is defined as the following:
    %  NFR(1,:) = redunvect1      %The No. of conmponents and repair rate of subsystem 1
    %  NFR(2,:)=redunvect2        %The No. of conmponents and repair rate of subsystem 2
    %  NFR(3,:)=redunvect3        %The No. of conmponents and repair rate of subsystem 3
    %  and so on
    %  Example: redunvect1=[2 3 1 1  0.3];
    %                                 ---------  -----
    %                                 No. of    Repair
    %                                 comp.     rate

    % For example if there are 4 subsystems in the main system, the first
    % dimension of this matrix would be of size 4.

    % NFR = [1 1 1 1 0.45;1 2 3 5 0.1;1 1 2 3 0.2;2 3 4 6 0.2];



    %% Simulink

    % StartTime = input('Please insert StartTime of simulation: ');
    % StopTime = input('Please insert StopTime of simulation: ');

    StartTime = 0;
    StopTime = 10000;


    Solution = sim('Faiureprocess_2018.slx','StartTime',num2str(StartTime), ...
            'StopTime',num2str(StopTime));

    %% Reults    

    % System Average Wait

    QueueAvrWait = Solution.AvrWaitQueue1(end)+Solution.AvrWaitQueue2(end)+Solution.AvrWaitQueue3(end)+ ...
        Solution.AvrWaitQueue4(end);

    ServerAvrWait = Solution.AvrWaitServer1(end)+Solution.AvrWaitServer2(end)+ ...
        Solution.AvrWaitServer3(end)+Solution.AvrWaitServer4(end);

    Result.SystemAvrWait = QueueAvrWait + ServerAvrWait;

    % System Average Customers in the system

    AvrServerUtilization = Solution.ServerUtilization1(end)+ Solution.ServerUtilization2(end)+ ...
        Solution.ServerUtilization3(end)+Solution.ServerUtilization4(end);

    AvrQueueLength = Solution.AvrQueueLenght1(end)+ Solution.AvrQueueLenght2(end)+ ...
        Solution.AvrQueueLenght3(end)+ Solution.AvrQueueLenght4(end);

    Result.SystemAvrCustomer = AvrServerUtilization + AvrQueueLength;

    % System Average Repairs

    Result.SystemAvrReparis = numel(Solution.FailureDeparted1)+numel(Solution.FailureDeparted2)+ ...
        numel(Solution.FailureDeparted3)+ numel(Solution.FailureDeparted4);


    % Totalwait = Result.SystemAvrWait;
    Totalqueue = Result.SystemAvrCustomer;
    Totalrepair = Result.SystemAvrReparis/StopTime; %#ok

    SR = [Totalqueue numel(Solution.FailureDeparted1)/StopTime numel(Solution.FailureDeparted2)/StopTime numel(Solution.FailureDeparted3)/StopTime numel(Solution.FailureDeparted4)/StopTime];
end