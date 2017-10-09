%class for gaming
classdef Game
    properties
        curGrid
        curRound
    end
    methods
        function obj = Game()
            obj.curGrid = zeros(3);
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
            %check for rows
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
            
            %check for cols
            if whichWin == 0
                for c = 1:3
                    prev = 0;
                    counter = 0;
                    for r = 1:3
                        if r == 1
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
                        counter = 1;
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
                        counter = 1;
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
                disp('no vacancy');
            else
                maxResult = -11;
                pos = [-1, -1];
                for r=1:3
                    for c=1:3
                        if obj.curGrid(r, c) == 0
                            newGame = Game;
                            newGame = obj.putPiece([r, c]);
                            newGame.curRound = -newGame.curRound;
                            newResult = DLS(newGame);
                            if newResult > maxResult
                                maxResult = newResult;
                                pos = [r, c];
                            end
                        end
                    end
                end
            end
        end
        
        function result = DLS(obj)
            nZero = obj.countSpace();
            whichWin = obj.checkWin();
            if whichWin ~= 0 || nZero == 0
                if whichWin == -1
                    result = -10;
                elseif whichWin == 0
                    result = 0
                else 
                    result = 10;
                end
            else
                if obj.curRound == 1
                    maxResult = -11;
                    for r=1:3
                        for c=1:3
                            if obj.curGrid(r, c) == 0
                                newGame = Game;
                                newGame = obj.putPiece([r, c]);
                                newGame.curRound = -obj.curRound;
                                newResult = DLS(newGame);
                                if newResult > maxResult
                                    maxResult = newResult;
                                end
                            end
                        end
                    end
                    result = maxResult;
                else
                    minResult = 11;
                    for r=1:3
                        for c=1:3
                            if obj.curGrid(r, c) == 0
                                newGame = Game;
                                newGame = obj.putPiece([r, c]);
                                newGame.curRound = -obj.curRound;
                                newResult = DLS(newGame);
                                if newResult < minResult
                                    minResult = newResult;
                                end
                            end
                        end
                    end
                    result = minResult;
                end
            end  
        end
    end
end