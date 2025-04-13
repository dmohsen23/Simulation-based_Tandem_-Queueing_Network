%%%% Main code of PSO %%%

clear;
close all;
clc;

tic
%% Parameters

% Customers arrival rate.
lambda = 2;

% Service rates of servers.
Mu = [4 3 5 6];

% FR is the failure rates matrix of components. Number of rows is the
% same as the number of subsystems.

% Redundancy allocation in series-parallel systems under warm standby and
% active components in repairable subsystems (2018)

FR = [0.0112, 0.0123, 0.0119, 0.0123;
      0.0123, 0.0123, 0.0106, 0.0119;
      0.0108, 0.0125, 0.014, 0.0122;
      0.011, 0.0115, 0.0119, 0.0118];

% CM is the matrix of components costs.
% CM is a 2-dimensional matrix in which the first dimension is representative of the subsystems number.
% Example:
% CM=[10 12 13;20 21 23];
% CM is the cost matrix of a system with 2 subsystems in which 10 is the
% cost of first component in subsystem 1 and 21 is the cost of second
% component in subsystem 2.

% Note: The first dimnesion of matrix CM should be the same as the first
% dimension of matrix NFR.

% A preference ordered classification for a multi-objective max–min
% redundancy allocation problem (2011)

CM = [3, 1, 5, 2;
      2, 3, 5, 6;
      3, 3, 4, 2;
      2, 3, 4, 3];

% CW is the matrix of components weight

% A preference ordered classification for a multi-objective max–min
% redundancy allocation problem (2011)

CW = [3, 4, 2, 5;
      7, 5, 6, 4;
      5, 4, 5, 4;
      5, 3, 4, 5];

%cr is the repair cost per unit time .
%ch is the customer's holding cost per unit time.

ch = 1;
cr = 10;

%% Decision variable

%  NFR is a 2-dimensional matrix and for a system composed of 3 subsystem is defined as the following:
%  NFR(1,:) = redunvect1      %The No. of conmponents and repair rate of subsystem 1
%  NFR(2,:)=redunvect2        %The No. of conmponents and repair rate of subsystem 2
%  NFR(3,:)=redunvect3        %The No. of conmponents and repair rate of subsystem 3
%  and so on
%  Example: redunvect1=[2 3 1 1 0.3];

% For example if there are 4 subsystems in the main system, the first
% dimension of this matrix would be of size 4.

NFR = [1 1 1 1 0.45;
       1  2  3 5 0.1;
       1  1  2 3 0.2;
       2  3  4 6 0.2];

%% PSO Algorithm

% parpool(2);
% PSO Parameters

global NFE;
NFE = 0;

[row, column] = size(NFR);

nVar = column;              % Number of Decision Variables

VarSize = [row nVar];       % Size of Decision Variables Matrix

VarMin = [zeros(row, column-1) 0.0001*ones(row,1)];  % Upper Bound of Variables

VarMax = [8, 9, 7, 8, 15;
          5, 6, 2, 1, 15;
          3, 2, 1, 7, 15;
          2, 2, 3, 1, 15];      % Upper Bound of Variables


MaxIt = 50;        % Maximum Number of Iterations

nPop = 250;         % Population Size (Swarm Size)

% Constriction Coefficients
phi1 = 2.05;
phi2 = 2.05;
phi = phi1+phi2;
chi = 2/(phi-2+sqrt(phi^2-4*phi));
w = chi;          % Inertia Weight
wdamp = 1;        % Inertia Weight Damping Ratio
c1 = chi* phi1;    % Personal Learning Coefficient
c2 = chi*phi2;    % Global Learning Coefficient

% Velocity Limits
VelMax = 0.1*(VarMax-VarMin);
VelMin = -VelMax;

% Initialization
empty_particle.Position = [];
empty_particle.Cost = [];
empty_particle.Velocity = [];
empty_particle.Best.Position = [];
empty_particle.Best.Cost = [];

particle = repmat(empty_particle,nPop,1);

GlobalBest.Cost = inf;

for i = 1:nPop
    
    % Initialize Position
    particle(i).Position = [(unidrnd(VarMax(:,1:end-1), row, row)-1), unifrnd(VarMin(1,1), VarMax(1,end), [row,1])];
    
    if sum((sum(particle(i).Position(:,1:end-1),2)>0)) ~= row       
        particle(i).Position(:,1:end-1) = position_modify(particle(i).Position(:,1:end-1),FR);       
    end
    
    % Initialize Velocity
    particle(i).Velocity = zeros(VarSize);
    
    % NFR & Simulink Run
    NFR = particle(i).Position;
    
    particle(i).availability = sysavailcalc(particle(i).Position, FR);
    
    if particle(i).availability > 0.9987
        
        SR = SimRun();
        
        % Evaluation
        particle(i).Cost=Cost(particle(i).Position, CM, CW, FR, SR);
        
    else
        particle(i).Cost = 20000;
    end
    
    % Update Personal Best
    particle(i).Best.Position = particle(i).Position;
    particle(i).Best.Cost = particle(i).Cost;
    particle(i).Best.Availability = particle(i).availability;
    
    % Update Global Best
    if particle(i).Best.Cost < GlobalBest.Cost        
        GlobalBest = particle(i).Best;        
    end
    
end

BestCost=zeros(MaxIt,1);

nfe=zeros(MaxIt,1);

% PSO Main Loop

for it=1:MaxIt
    
    for i=1:nPop
        
    % Update Velocity
    particle(i).Velocity = w*particle(i).Velocity ...
        + c1*rand(VarSize).*(particle(i).Best.Position-particle(i).Position) ...
        + c2*rand(VarSize).*(GlobalBest.Position-particle(i).Position);
        
    % Apply Velocity Limits
    particle(i).Velocity = max(particle(i).Velocity,VelMin);
    particle(i).Velocity = min(particle(i).Velocity,VelMax);
        
    % Update Position
    particle(i).Position = particle(i).Position + particle(i).Velocity;
    NFR = particle(i).Position.*([zeros(row,row) ones(row,1)])+floor(particle(i).Position).*([ones(row,row) zeros(row,1)]);
    NFR = (NFR<0).*0+(NFR>0).*NFR;
                        
    if sum((sum(NFR(:,1:end-1),2)>0)) ~= row            
        NFR(:,1:end-1) = position_modify(NFR(:,1:end-1),FR);    
    end
        
    particle(i).Position = NFR;
        
    particle(i).availability = sysavailcalc(particle(i).Position, FR);

    if particle(i).availability > 0.9981
        
        SR = SimRun();
        
        % Evaluation
        particle(i).Cost = Cost(particle(i).Position, CM, CW, FR, SR);
            
    else
        particle(i).Cost = 20000;
    end
            
    % Velocity Mirror Effect
    IsOutside = (particle(i).Position < VarMin | particle(i).Position > VarMax);
    particle(i).Velocity(IsOutside) = -particle(i).Velocity(IsOutside);
        
    % Apply Position Limits
    particle(i).Position = max(particle(i).Position,VarMin);
    particle(i).Position = min(particle(i).Position,VarMax);
        
    % Update Personal Best
    if particle(i).Cost < particle(i).Best.Cost
            
        particle(i).Best.Position = particle(i).Position;
        particle(i).Best.Cost = particle(i).Cost;
        particle(i).Best.Availability = particle(i).availability;
           
        % Update Global Best
        if particle(i).Best.Cost < GlobalBest.Cost                
            GlobalBest = particle(i).Best;                
        end
            
    end
                                      
    end
    
    BestCost(it) = GlobalBest.Cost;
    
    nfe(it) = NFE;
    
    disp(['Iteration ' num2str(it) ': NFE = ' num2str(nfe(it)) ', Best Cost = ' num2str(BestCost(it))]);
    
    w = w*wdamp;
    
end

% Results

figure;
%plot(nfe,BestCost,'LineWidth',2);
semilogy(1:MaxIt,BestCost,'LineWidth',2);
xlabel('NFE');
ylabel('Best Cost');

toc