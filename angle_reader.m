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
mb = NXTMotor('B');
mA.ResetPosition();
mB.ResetPosition();
mA.TachoLimit = 0;
mB.TachoLimit = 0;
mA.ActionAtTachoLimit = 'off';
mB.ActionAtTachoLimit = 'off';
mA.SendToNXT();
mB.SendToNXT();

%start reading
for r=1:3
    for c=1:3
        disp('manul adjustment ready for: ');
        disp([r, c]);
        input('press any button if position is ready for: ');
        
        %get the postion for each motor
        dataA = mA.ReadFromNXT();
        alphaAngles(r, c) = dataA.position;
        dataB = mA.ReadFromNXT();
        betaAngles(r, c) = dataA.position;
        disp(dataA.position);
        disp(dataB.position);
    end
end

%save angles:
disp(alphaAngles);
disp(betaAngles);
save('angles.mat', alphaAngles);
save('angles.mat', betaAngles);

%testing result:
for r=1:3
    for c=1:3
        disp('test for: ');
        disp([r, c]);
        input('press any button if position is ready for: ');
        
        %moveIt
        moveTo(alphaAngles(r, c));
        moveTo(betaAngles(r, c));
    end
end

function moveTo(alpha,beta)
% move to a location
mA = NXTMotor('A');
mA.SmoothStart = 0;
mA.SpeedRegulation = 0;

mB = NXTMotor('B');
mB.SmoothStart = 0;
mB.SpeedRegulation = 0;

speedA=40;
speedB=100;
%the gramma should be double checked when testing
mA.ActionAtTachoLimit = 'Brake';
mB.ActionAtTachoLimit = 'Brake';

%need to check gramma
data = mA.readFromNXT();
position = data.position;
if position(1)<aplha
	mA.Power = speedA;
	mA.TachoLimit = alpha-position(1);
else
	mA.Power = -speed;
	mA.TachoLimit = position(1)-alpha;
end
data = mB.readFromNXT();
position = data.position;
if position(2)<beta
	mB.Power = speedB;
	mB.TachoLimit = beta-position(2);
else
	mB.Power = -speed;
	mB.TachoLimit = position(2)-beta;
end
mA.SendToNXT();
mB.SendToNXT();
end


% Close connection to the NXT brick
COM_CloseNXT(MyNXT);