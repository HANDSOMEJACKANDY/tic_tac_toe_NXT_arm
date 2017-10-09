%read all angles for nine grids
alphaAngles = zeros(3);
betaAngles = zeros(3);

%start both motors
% Close connection to the NXT brick if there was one before
COM_CloseNXT('all');
% Establish connection with the NXT brick
MyNXT = COM_OpenNXT();
COM_SetDefaultNXT(MyNXT);
% Set up two motors:
mA = NXTMotor('A');
mB = NXTMotor('B');
mA.ResetPosition();
mB.ResetPosition();
mA.SendToNXT();
mB.SendToNXT();

%start reading
mA.Stop('off');
mB.Stop('off');

for r=1:1
    for c=1:1
        disp('manul adjustment ready for: ');
        disp([r, c]);
        input('press any button if position is ready for: ');
        
        %get the postion for each motor
        dataA = mA.ReadFromNXT();
        alphaAngles(r, c) = dataA.Position;
        dataB = mA.ReadFromNXT();
        betaAngles(r, c) = dataA.Position;
        disp(dataA.Position);
        disp(dataB.Position);
    end
end

%save angles:
disp(alphaAngles);
disp(betaAngles);
save('angles.mat', 'alphaAngles');
save('angles.mat', 'betaAngles');

%testing result:
for r=1:1
    for c=1:1
        disp('test for: ');
        disp([r, c]);
        input('press any button if position is ready for: ');
        
        %moveIt
        moveTo(alphaAngles(r, c), betaAngles(r, c));
    end
end

COM_CloseNXT('all');

function moveTo(alpha,beta)
    % move to a location
    mA = NXTMotor('A');
    mA.SmoothStart = 0;
    mA.SpeedRegulation = 1;

    mB = NXTMotor('B');
    mB.SmoothStart = 0;
    mB.SpeedRegulation = 1;

    speedA=10;
    speedB=40;
    %the gramma should be double checked when testing
    mA.ActionAtTachoLimit = 'Brake';
    mB.ActionAtTachoLimit = 'Brake';

    %need to check gramma
    data = mA.ReadFromNXT();
    position = data.Position;
    disp('cool');
    disp(position);
    disp(alpha);
    if position ~= alpha
        if position<alpha
            mA.Power = speedA;
            mA.TachoLimit = alpha-position;
        else
            mA.Power = -speedA;
            mA.TachoLimit = position-alpha;
        end
    end

    data = mB.ReadFromNXT();
    position = data.Position;
    disp('cool');
    disp(position);
    disp(beta);
    if position ~= beta
        if position<beta
            mB.Power = speedB;
            mB.TachoLimit = beta-position;
        else
            mB.Power = -speedB;
            mB.TachoLimit = position-beta;
        end
    end

    mA.SendToNXT();
    mB.SendToNXT();
end