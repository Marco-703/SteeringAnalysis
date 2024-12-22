close all;
clear;
clc;


posXA = 1441;
posYA = 664;

posXB = 1427;
posYB = 1071;
reference = atan2(posXA - posXB, posYA - posYB) * (180/pi);
reference = 180 - reference;
disp(reference);



posXA = 1246;
posYA = 631;

posXB = 1549;
posYB = 905;
left = atan2(posXA - posXB, posYA - posYB) * (180/pi) - reference;

disp(180 + left);



posXA = 1541;
posYA = 801;

posXB = 1260;
posYB = 1100;
right = atan2(posXA - posXB, posYA - posYB) * (180/pi) - reference;

disp(180 - right);