%starting of project of tic_tac_toe!
game = Game;

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
mA.SendToNXT();
mB.SendToNXT();
mC.SendToNXT();

for i = 1:9
    disp(game.curGrid);
    if mod(i, 2) == 1
        disp('human round')
        game.curRound = -1;
        %wait for the human round
        tic;
        while toc < 5
        end
        %scan for human input
        position =  scan(alphaAngles, betaAngles, game);
        if position(1) == 0 && position(0) == 0
            disp('no piece scanned');
            break;
        end
    else
        disp('computer round')
        game.curRound = 1;
        position = game.rootDFS();
        moveTo(alphaAngles(position(1), position(2)), betaAngles(position(1), position(2)));
        drop();
    end
    
    disp(position);
    game = game.putPiece(position);
    disp('cool');
    disp(game.curGrid);
    %check for winner
    whichWin = game.checkWin();
    disp(whichWin);
    if whichWin ~= 0
        if whichWin == 1
            disp('comp win');
        else
            disp('human win');
        end
        break;
    end
end
disp('draw');

% Close connection to the NXT brick
COM_CloseNXT(MyNXT);

function waitStop(motor)
    data = motor.ReadFromNXT();
    pos = data.Position;
    wait(0.1);
    newData = motor.ReadFromNXT();
    newPos = newData.Position;
    while newPos ~= pos
        pos = newPos;
        wait(0.1);
        newData = motor.ReadFromNXT();
        newPos = newData.Position;
    end
end

function drop()
    mC = NXTMotor('C');
    mC.SmoothStart = 0;
    mC.SpeedRegulation = 1;
    mC.ActionAtTachoLimit = 'Brake';
    
    %motion para to be adjusted
    mC.Power = 10;
    mC.TachoLimit = 40;
    
    mC.SentToNXT();
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
            if game.curGrid(r, c) == 0
                disp("previously empty")
                moveTo(alphaAngles(r, c), betaAngles(r, c));
                if GetLight(SENSOR_1)> threshold
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
end

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
    %wait till they stop
    waitStop(mA);
    waitStop(mB);
end
