close all
h=figure(22);

cd_outer = 120; %aussendurchmesser
cd_inner = 37; %nutzbarer innendurchmesser
cd_hole = 15; %loch in der mitte

w=0:0.001:2*pi;

x=cd_outer/2 * cos(w);
y=cd_outer/2 * sin(w);
plot(x,y,'r');
hold on

x=cd_inner/2 * cos(w);
y=cd_inner/2 * sin(w);
plot(x,y,'r')

x=cd_hole/2 * cos(w);
y=cd_hole/2 * sin(w);
plot(x,y,'r')

squareA = 51; %rechteck seite a
squareB = 35; %rechteck seite b

squareX = [squareA -squareA -squareA squareA squareA]/2;
squareY = [squareB squareB -squareB -squareB squareB]/2;

%square 1
squareX_1 = squareX;
squareY_1 = squareY+36;
plot(squareX_1, squareY_1, 'k');

%square 2
angle = 120 /360*2*pi;
squareX_2 = cos(angle)*squareX_1 - sin(angle)*squareY_1;
squareY_2 = sin(angle)*squareX_1 + cos(angle)*squareY_1;
plot(squareX_2, squareY_2, 'k');

%square 3
angle = 240 /360*2*pi;
squareX_3 = cos(angle)*squareX_1 - sin(angle)*squareY_1;
squareY_3 = sin(angle)*squareX_1 + cos(angle)*squareY_1;
plot(squareX_3, squareY_3, 'k');

%axis("noLabel")
%set(h, "paperunits", "centimeters");
%set(h, "paperposition", [5 5 12 12]);
%print(h, "cd.pdf");
%print(h, "cd.jpg");
%print