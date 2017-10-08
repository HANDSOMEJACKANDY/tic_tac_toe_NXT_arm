% Close connection to the NXT brick if there was one before
COM_CloseNXT('all');

% Establish connection with the NXT brick
MyNXT = COM_OpenNXT();
COM_SetDefaultNXT(MyNXT);

%alpha
alphaAngles = [1 2 3
4 5 6
7 8 9];
%beta
betaAngles  = [1 2 3
4 5 6
7 8 9];
%store the grid: -1 for human, 1 for computer, 0 for vaccancy
grid  = zeros(3);
%current position
curPosition = [0; 0]

grid = scan(alphaAngles, betaAngles, grid)



% Close connection to the NXT brick
COM_CloseNXT(MyNXT);