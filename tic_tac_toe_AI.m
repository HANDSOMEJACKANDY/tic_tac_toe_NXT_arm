%starting of project of tic_tac_toe!
game = Game;

for i = 1:9
    disp(game.curGrid);
    if mod(i, 2) == 1
        disp('human round')
        game.curRound = -1;
        position = input('input your position: ');
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
    if whichWin ~= 0
        if whichWin == 1
            disp('comp win');
        else
            disp('human win');
        end
        break;
    end
end


