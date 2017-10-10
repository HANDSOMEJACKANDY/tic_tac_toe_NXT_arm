%read all angles for nine grids
alphaAngles = zeros(3);
betaAngles = zeros(3);
load('alphaAngles.mat');
load('betaAngles.mat');
%start both motors
% Close connection to the NXT brick if there was one before
COM_CloseNXT('all');
% Establish connection with the NXT brick
MyNXT = COM_OpenNXT();
COM_SetDefaultNXT(MyNXT);
% Set up two motors:
mA = NXTMotor('A');
mB = NXTMotor('B');
mC = NXTMotor('C');
mA.ResetPosition();
mB.ResetPosition();
mC.ResetPosition();
mA.SendToNXT();
mB.SendToNXT();
mC.SendToNXT();

%start reading
mA.Stop('off');
mB.Stop('off');
mC.Stop('off');

for r=1:3
    for c=1:3
        disp('manul adjustment ready for: ');
        disp([r, c]);
        a = input('press any button if position is ready for: ');
        
        if a == 1
            %get the postion for each motor
            moveTo(alphaAngles(r, c), betaAngles(r, c));
            dataA = mA.ReadFromNXT();
            alphaAngles(r, c) = dataA.Position;
            dataB = mB.ReadFromNXT();
            betaAngles(r, c) = dataB.Position;
            disp(dataA.Position);
            disp(dataB.Position);
        end
    end
end

%save angles:
disp(alphaAngles);
disp(betaAngles);
save('alphaAngles.mat', 'alphaAngles');
save('betaAngles.mat', 'betaAngles');

%testing for file loader
load('alphaAngles.mat');
load('betaAngles.mat');
%testing result:
b = input('testing the movine (1), or scanning (2)');
if b == 1
    for r=1:3
        for c=1:3
            disp('test for: ');
            disp([r, c]);
            a = input('press any button if position is ready for: ');

            %moveIt
            if a == 1
                moveTo(alphaAngles(r, c), betaAngles(r, c));
            end
        end
    end
else
    tempGame = Game;
    tempPos = scan(alphaAngles, betaAngles, tempGame);
    disp(tempPos);
    tempGame.putPiece(tempPos);
    disp(tempGame.curGrid);
    drop(mC);
end
mA.Stop('off');
mB.Stop('off');
COM_CloseNXT('all');

function wait(time)
    tic;
    while toc < time
    end
end

function drop(mC)
    mC.SmoothStart = 1;
    mC.SpeedRegulation = 1;
    mC.ActionAtTachoLimit = 'Brake';
    
    %motion para to be adjusted
    mC.Power = 5;
    mC.TachoLimit = 90;
    
    mC.SendToNXT();
    %wait till it stops
    waitStop(mC);
end

function newPos = scan(alphaAngles, betaAngles, game)
    %iterate through each row:
    OpenLight(SENSOR_1, 'ACTIVE');
    threshold = 500;
    flag = 0;
    newPos = [0, 0];
    for r=1:3
        for c=1:3
            disp(game.curGrid);
            if game.curGrid(r, c) == 0
                disp("previously empty");
                moveTo(alphaAngles(r, c), betaAngles(r, c));
                if GetLight(SENSOR_1)> threshold
                    disp('sensing:');
                    disp(GetLight(SENSOR_1));
                    newPos = [r, c];
                    flag = 1; %signal to jump out after locating the new human round action
                    break;
                end
            end
        end
        if flag == 1
            break;
        end
    end
    disp(newPos);
end

function waitStop(motor)
    data = motor.ReadFromNXT();
    pos = data.Position;
    wait(0.5);
    newData = motor.ReadFromNXT();
    newPos = newData.Position;
    while newPos ~= pos
        pos = newPos;
        wait(0.5);
        newData = motor.ReadFromNXT();
        newPos = newData.Position;
    end
end

function moveTo(alpha,beta)
    % move to a location
    mA = NXTMotor('A');
    mA.SmoothStart = 0;
    mA.SpeedRegulation = 1;

    mB = NXTMotor('B');
    mB.SmoothStart = 0;
    mB.SpeedRegulation = 1;

    speedA=20;
    speedB=100;
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
    %wait till they stop
    waitStop(mA);
    waitStop(mB);
end
