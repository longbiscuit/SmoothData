clc;
clear all;
close all;
% xy的x一般较大，chaxy的x一般较小，这样内插较为精确，但内插会浪费一小段x
% 若xy的x比chaxy的x小，那么就会外插，外插不精确，但不会浪费一小段x

xy=[

30.70422535	14.78873239
31.83098592	13.38028169
32.3943662	14.78873239
32.95774648	19.01408451
34.08450704	16.1971831
34.64788732	14.78873239
34.64788732	20.42253521
35.77464789	17.6056338
36.33802817	20.42253521
37.46478873	20.42253521
38.5915493	21.83098592


];

x=xy(:,1);
y=xy(:,2);
chax=[
% 500
% 1200
% 2400
34.8
    ];

chay=spline(x,y,chax);

plot(x,y,'b*');
hold on;
plot(chax,chay,'r-o');
result=[chax chay];