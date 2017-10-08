%class for gaming
classdef Game
    properties
        curGrid
        alpha
        beta
        curRound
    end
    methods
        function obj = Game()
            obj.curGrid = zeros(3);
            obj.alpha = -10000;
            obj.beta = 10000;
            obj.curRound = 0;
        end
        
        function obj = putPiece(obj, pos)
            if obj.curGrid(pos(1), pos(2)) ~= 0
                disp('wrong!!!!!!!!');
            else
                obj.curGrid(pos(1), pos(2)) = obj.curRound;
            end
        end
        
        function whichWin = checkWin(obj)
            %check for cols
            whichWin = 0;
            for r = 1:3
                prev = 0;
                counter = 0;
                for c = 1:3
                    if c == 1
                        prev = obj.curGrid(r, c);
                        if prev == 0
                            break;
                        end
                        counter = 1;
                    else
                        if prev ~= obj.curGrid(r, c)
                            counter = 0;
                            break;
                        else
                            counter = counter + 1;
                        end
                    end
                end
                if counter == 3
                    whichWin = prev;
                    break;
                end
            end

            %check for rows
            if whichWin == 0
                for c = 1:3
                    prev = 0;
                    counter = 0;
                    for r = 1:3
                        if c == 1
                            prev = obj.curGrid(r, c);
                            if prev == 0
                                break;
                            end
                            counter = 1;
                        else
                            if prev ~= obj.curGrid(r, c)
                                counter = 0;
                                break;
                            else
                                counter = counter + 1;
                            end
                        end
                    end
                    if counter == 3
                        whichWin = prev;
                        break;
                    end
                end
            end

            %check for diagnals
            if whichWin == 0
                prev = 0;
                counter = 0;
                for r = 1:3
                    if r == 1
                        prev = obj.curGrid(r, r);
                        if prev == 0
                            break;
                        end
                        counter = counter + 1;
                    else
                        if prev ~= obj.curGrid(r, r)
                            counter = 0;
                            break;
                        else
                            counter = counter + 1;
                        end
                    end
                end
                if counter == 3
                    whichWin = prev;
                end
            end

            %check for diagnals
            if whichWin == 0
                prev = 0;
                counter = 0;
                for r = 1:3
                    if r == 1
                        prev = obj.curGrid(4 - r, r);
                        if prev == 0
                            break;
                        end
                        counter = counter + 1;
                    else
                        if prev ~= obj.curGrid(4 - r, r)
                            counter = 0;
                            break;
                        else
                            counter = counter + 1;
                        end
                    end
                end
                if counter == 3
                    whichWin = prev;
                end
            end 
           
        end 
        
        function nZero = countSpace(obj)
            nZero = 0;
            for r = 1:3
                for c = 1:3
                    if obj.curGrid(r, c) == 0
                        nZero = nZero + 1;
                    end
                end
            end
        end
        
        function pos = rootDFS(obj)
            nZero = obj.countSpace();
            if nZero == 0
                pos = [-1, -1];
            else
                maxAlpha = -10000;
                pos = [-1, -1];
                for r=1:3
                    for c=1:3
                        if obj.curGrid([r, c]) == 0
                            newGame = Game;
                            newGame = obj.putPiece([r, c]);
                            newGame.curRound = -newGame.curRound;
                            newGame.alpha = maxAlpha;
                            [newAlpha, newBeta] = DLS(newGame);
                            if newAlpha > maxAlpha
                                maxAlpha = newAlpha;
                                pos = [r, c];
                            end
                        end
                    end
                end
            end
        end
        
        function [alpha, beta] = DLS(obj)
            nZero = obj.countSpace();
            whichWin = obj.checkWin();
            if whichWin ~= 0 || nZero == 0
                if obj.curRound == -1
                    if whichWin == obj.curRound
                        beta = -10;
                    elseif whichWin == 0
                        beta = 0;
                    else
                        beta = 10;
                    end
                    alpha = obj.alpha;
                else
                    if whichWin == obj.curRound
                        alpha = 10;
                    elseif whichWin == 0
                        alpha = 0;
                    else
                        alpha = -10;
                    end
                    beta = obj.beta;
                end
            else
                if obj.curRound == 1
                    maxBeta = -10000;
                    for r=1:3
                        for c=1:3
                            if obj.curGrid(r, c) == 0
                                newGame = Game;
                                newGame = obj.putPiece([r, c]);
                                newGame.curRound = -obj.curRound;
                                newGame.alpha = maxBeta;
                                [newAlpha, newBeta] = DLS(newGame);
                                if newBeta >= obj.beta
                                    maxBeta = -10000;
                                    break; %pruning
                                else
                                    if newBeta > maxBeta %updating new alpha
                                        maxBeta = newBeta;
                                    end
                                end
                            end
                        end
                    end
                    alpha = maxBeta;
                    beta = obj.beta;
                else
                    minAlpha = 10000;
                    for r=1:3
                        for c=1:3
                            if obj.curGrid(r, c) == 0
                                newGame = Game;
                                newGame = obj.putPiece([r, c]);
                                newGame.beta = minAlpha;
                                newGame.curRound = -obj.curRound;
                                [newAlpha, newBeta] = DLS(newGame);
                                if newAlpha < obj.alpha
                                    minAlpha = 10000;
                                    break; %pruning
                                else
                                    if newAlpha < minAlpha
                                        minAlpha = newAlpha;
                                    end
                                end
                            end
                        end
                    end
                    beta = minAlpha;
                    alpha = obj.alpha;
                end
            end  
        end
    end
end