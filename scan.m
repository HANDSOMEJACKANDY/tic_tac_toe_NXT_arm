function newPos = scan(alphaAngles, betaAngles, game)
    %iterate through each row:
    OpenLight(SENSOR_1, 'ACTIVE');
    threshold = 500;
    flag = 0;
    for r=1:3
        for c=1:3
            if game.curGrid(r, c) == 0
                disp("previously empty")
                moveto(alphaAngles(r, c), betaAngles(r, c));
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

		