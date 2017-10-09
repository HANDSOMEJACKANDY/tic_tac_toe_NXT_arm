%starting of project of tic_tac_toe!
alphaAngles = [1 2 3
4 5 6
7 8 9];
betaAngles  = [1 2 3
4 5 6
7 8 9];
game = Game;

% Close connection to the NXT brick if there was one before
COM_CloseNXT('all');

% Establish connection with the NXT brick
MyNXT = COM_OpenNXT();
COM_SetDefaultNXT(MyNXT);

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
        position =  scan(alphaAngles, betaAngles, game.curGrid);
        if position(1) == 0 && position(0) == 0
            disp('no piece sensed');
            break;
        end
    else
        disp('computer round')
        game.curRound = 1;
        position = game.rootDFS();
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
