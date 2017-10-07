% Close connection to the NXT brick if there was one before
COM_CloseNXT('all');

% Establish connection with the NXT brick
MyNXT = COM_OpenNXT();
COM_SetDefaultNXT(MyNXT);

%alpha
data(:,:,1) = [1 2 3
4 5 6
7 8 9];
%beta
data(:,:,2) = [1 2 3
4 5 6
7 8 9];
%enable - disable when known to be filled
data(:,:,3) = [1 1 1
1 1 1
1 1 1];
%human pieces
data(:,:,4) = [0 0 0
0 0 0
0 0 0];
%computer pieces
data(:,:,5) = [0 0 0
0 0 0
0 0 0];
data(:,:,6) = [0; 0]

data=scan(data)



% Close connection to the NXT brick
COM_CloseNXT(MyNXT);