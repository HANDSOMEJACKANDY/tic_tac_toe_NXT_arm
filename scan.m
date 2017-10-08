function newGrid = scan(alphaAngles, betaAngles, grid)
newGrid = grid;
%iterate through each row:
OpenLight(SENSOR_1, 'ACTIVE');
threshold = 500;
flag = 0;
for r=1:3
	for c=1:3 %#ok<ALIGN>
        if grid(r, c) == 0 && GetLight(SENSOR_1)> threshold
            disp("previously empty")
            moveto(alphaAngles(r, c), betaAngles(r, c));
            newGrid(r, c) = -1;
            flag = 1; %signal to jump out after locating the new human round action
            break;
        end
    end
    if flag == 1
        break;
    end
end
end

		