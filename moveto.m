function newposition = moveto(alpha,beta)
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
newposition=[alpha; beta];
end