%starting of project of tic_tac_toe!
game = Game;

%load angle data
load('alphaAngles.mat');
load('betaAngles.mat');

% Close connection to the NXT brick if there was one before
COM_CloseNXT('all');

% Establish connection with the NXT brick
MyNXT = COM_OpenNXT();
COM_SetDefaultNXT(MyNXT);
%init all three motors
mA = NXTMotor('A');
mB = NXTMotor('B');
mC = NXTMotor('C');
mA.ResetPosition();
mB.ResetPosition();
mC.ResetPosition();
mA.SmoothStart = 1;
mB.SmoothStart = 1;
mC.SmoothStart = 1;
mA.SpeedRegulation = 1;
mB.SpeedRegulation = 1;
mC.SpeedRegulation = 1;
mA.SendToNXT();
mB.SendToNXT();
mC.SendToNXT();

%calibrate threshold
input('please place only one paper in 1,1, press enter to continue');
OpenLight(SENSOR_1, 'ACTIVE');
moveTo(alphaAngles(1, 1), betaAngles(1, 1));
paper = GetLight(SENSOR_1);
moveTo(alphaAngles(2, 1), betaAngles(2, 1));
noPaper = GetLight(SENSOR_1);
threshold = noPaper * 0.4 + paper * 0.6;
disp('threshold noPaper paper');
disp(threshold);
disp(noPaper);
disp(paper);

%record win
whichWin = 0;

for i = 1:9
    disp(game.curGrid);
    if mod(i, 2) == 1
        moveTo(400, -1600);
        disp('human round')
        game.curRound = -1;
        %wait for the human round
        OpenSwitch(SENSOR_2);
        while GetSwitch(SENSOR_2) == 0
        end
        CloseSensor(SENSOR_2);
        %scan for human input
        position =  scan(alphaAngles, betaAngles, game, threshold);
        if position(1) == 0 && position(0) == 0
            disp('no piece scanned');
            break;
        end
    else
        disp('computer round')
        game.curRound = 1;
        position = game.rootDFS();
        moveTo(alphaAngles(position(1), position(2)), betaAngles(position(1), position(2)));
        drop(mC);
    end
    
    disp(position);
    game = game.putPiece(position);
    disp('cool');
    disp(game.curGrid);
    %check for winner
    whichWin = game.checkWin();
    if whichWin ~= 0
        if whichWin == 1
            disp('comp win');
        else
            disp('human win');
        end
        break;
    end
end
if whichWin == 0
    disp('draw');
end

showResult(whichWin);
moveTo(0, 0);

% Close connection to the NXT brick
COM_CloseNXT(MyNXT);

function showResult(whichWin)
    if whichWin == 1
        %let B oscilate
        mA = NXTMotor('A');
        mA.SmoothStart = 0;
        mA.Power = 50;
        mA.SendToNXT();
        for i=1:10
            wait(0.3)
            if mod(i, 2) == 0
                mA.Power = 100;
            else
                mA.Power = -100;
            end
            mA.SendToNXT();
        end
        mA.Stop('brake');
    else
        %let C roll
        mC = NXTMotor('C');
        mC.TachoLimit = 5000;
        mC.Power = 100;
        mC.SendToNXT();
        waitStop(mC);
        mC.Stop('brake');
    end
end

function wait(time)
    tic;
    while toc < time
    end
end

function waitStop(motor)
    data = motor.ReadFromNXT();
    pos = data.Position;
    wait(0.8);
    newData = motor.ReadFromNXT();
    newPos = newData.Position;
    while newPos ~= pos
        pos = newPos;
        wait(0.8);
        newData = motor.ReadFromNXT();
        newPos = newData.Position;
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

function newPos = scan(alphaAngles, betaAngles, game, threshold)
    %iterate through each row:
    OpenLight(SENSOR_1, 'ACTIVE');
    flag = 0;
    newPos = [0, 0];
    for c=1:3
        for r=1:3
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
    CloseSensor(SENSOR_1);
end

function moveTo(alpha,beta)
    % move to a location
    mA = NXTMotor('A');
    mA.SmoothStart = 1;
    mA.SpeedRegulation = 1;

    mB = NXTMotor('B');
    mB.SmoothStart = 1;
    mB.SpeedRegulation = 1;

    speedA=15;
    speedB=100;
    %the gramma should be double checked when testing
    mA.ActionAtTachoLimit = 'HoldBrake';
    mB.ActionAtTachoLimit = 'HoldBrake';

    %need to check gramma
    data = mA.ReadFromNXT();
    position = data.Position;
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
