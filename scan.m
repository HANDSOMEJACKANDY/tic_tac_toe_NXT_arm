function newdata = scan(data)
%iterate through each row:
OpenLight(SENSOR_1, 'ACTIVE');
threshold = 500
for r=1:3
	for c=1:3
		if data(r,c,3)==1
			disp("previously empty")
			disp(data(r,c,1));%aplha to reach
			disp(data(r,c,2));%beta to reach
			newdata(1:2,1,6)=moveto(data(r,c,1),data(r,c,2));
			if GetLight(SENSOR_1)> threshold
				newdata(r,c,4)=1
				newdata(r,c,3)=0
				return
			end
		else
			disp("known to be filled")
		