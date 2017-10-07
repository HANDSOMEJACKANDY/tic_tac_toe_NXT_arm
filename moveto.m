function newposition = moveto(alpha,beta,position)
% move to a location
mA = NXTMotor('A');
mA.SmoothStart = 0;
mA.SpeedRegulation = 0;

mB = NXTMotor('B');
mB.SmoothStart = 0;
mB.SpeedRegulation = 0;

speed=10
ActionAtTachoLimit = 'Brake';

if position(1)<aplha
	mA.Power = speed;
	mA.TachoLimit = alpha-position(1);
else
	mA.Power = -speed;
	mA.TachoLimit = position(1)-alpha;
end
if position(2)<beta
	mB.Power = speed;
	mB.TachoLimit = beta-position(2);
else
	mB.Power = -speed;
	mB.TachoLimit = position(2)-beta;
end
mA.SendToNXT();
mB.SendToNXT();
newposition=[alpha; beta];
