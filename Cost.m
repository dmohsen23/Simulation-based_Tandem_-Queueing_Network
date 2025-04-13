function z = Cost(x, c, w, y, s)   %#ok

    global NFE;
    if isempty(NFE)
        NFE=0;
    end
    
    NFE=NFE+1;

    C = 40;        % Cost Constraints Right hand side
    W = 50;        % Weight Constraints Right hand side

    % System Cost (Constraint)
    x_1 = x(:,1:end-1);
    Violation1 = sum(sum(x_1.*c))/C-1;

    % System Weight (Constraint)
    % x_1 = x(:,1:end-1);
    Violation2 = sum(sum(x_1.*w))/W-1;

    alpha1 = 150;
    alpha2 = 150;
    alpha11 = 1000;
    alpha22 = 1000;

    % Queueing cost (Objective Function)
    ch = 11;
    cr = 10;

    Totalqueue = s(1);
    % Totalrepair = s(2);
    z2 =  ch*Totalqueue + cr*s (2)*x(1,end) + cr*s(3)*x(2,end) + cr*s(4)*x(3,end) + cr*s(5)*x(4,end);


    % z2 = 1 - sysavailcalc(x,y);

     z = z2  + alpha1*(Violation1<0)*abs(Violation1) + alpha11*(Violation1>0) +...
          alpha2*(Violation2<0)*abs(Violation2) + alpha22*(Violation2>0);
    % z= z2;

end