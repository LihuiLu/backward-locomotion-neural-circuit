function drawErrorLine(x,y,error,facecolor,facealpha)
x = x(:)';
y = y(:)';
error = error(:)';

x1 = x;
x2 = fliplr(x);

y1 = y - error;
y2 = fliplr(y + error);


modified_color = 0.3*facecolor + 0.7;
patch([x1 x2],[y1 y2],modified_color,'EdgeColor','none','FaceAlpha',facealpha);
hold on;
plot(x,y,'color',facecolor,'LineWidth',2);