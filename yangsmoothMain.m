clc;
clear all;
close all;
data=[
33.47119778	0.926193833
50.8546894	0.919920017
78.38976677	0.921883315
88.84808107	0.915675046
96.59601141	0.91359626
109.5029721	0.910478079
117.4304066	0.912522532
131.2842903	0.910437502
159.6195761	0.911423834
180.8826036	0.902125476
191.335244	0.908293168
196.7741526	0.910346985
205.0272051	0.896947237
242.4755051	0.902059929
256.318485	0.896897296
259.9671584	0.899984263
298.7016628	0.888622726
368.2964821	0.890635965
368.1641574	0.884455788
435.096667	0.877208126
453.5354858	0.871018585
460.1568569	0.880285729
493.2629318	0.875119975
616.4031363	0.867859828
624.6910137	0.857556411
698.5982752	0.860621529
738.5256348	0.856488926
873.1038246	0.855421441
909.7233278	0.842021693
935.5831845	0.844075509
1045.207395	0.829630126
1060.720938	0.843017388
1121.009139	0.833734637
1185.291722	0.832692123
1270.567766	0.827526368
1381.118499	0.822357493
1400.023755	0.816174195
1565.004459	0.812029106
1608.720398	0.805842686
1926.749426	0.788291608
2212.637628	0.767659804
2306.406272	0.761470263
2372.252474	0.765584139
2404.436703	0.757340781
2649.103329	0.743928548
2724.570095	0.747012394
2760.707351	0.733618889
3000.554084	0.726389955
3172.616345	0.72534744
3171.666412	0.720197292

];

smoothData=zeros(size(data));
smoothData(:,1)=data(:,1);

yangData=zeros(size(data));
yangData(:,1)=data(:,1);

smoothyangData=zeros(size(data));
smoothyangData(:,1)=data(:,1);

ct=size(data,2);
for c=2:ct%遍历每列
    x=data(:,1)';
    y=data(:,c)';
    yresult=y;
    figure(c)
    plot(x,yresult,'k-*');%原始数据
    hold on;
    ysmooth=smooth(x,yresult)';
    ysmooth(1)=yresult(1);%将光滑数据的第一个点用原始数据代替
    smoothData(:,c)=ysmooth';%matlab自带的smooth函数光滑后的数据
    plot(x,ysmooth','b-d')
    hold on;
    %用yang的方法进行光滑
    switch c
        case 1
            s=0.05*std(yresult)^2;%%s小了贴合，s大了远离
        case 2
            s=0.05*std(yresult)^2;%%s小了贴合，s大了远离
             title('{\ite_1}-{\itq}');
        case 3
%             s=0.09*std(yresult)^2;%%s小了贴合，s大了远离 CU
            s=0.05*std(yresult)^2;%%s小了贴合，s大了远离 CD
            title('{\ite_1}-{\itp}');
        case 4
            s=0.01*std(yresult)^2;%%s小了贴合，s大了远离 
            
            title('{\ite_1}-{\ite}');
        case 5
            s=0.9*std(yresult)^2;%%s小了贴合，s大了远离 %CU
            title('{\ite_1}-{\itu}');
    end
    %     s=0.05*std(yresult)^2;%%s小了贴合，s大了远离
    deta=ones(size(yresult));
%     deta(1:3)=[0.001,0.5,0.9];%保证拟合曲线过初始点
%     deta(1:3)=[0.0001,0.1,0.1];%保证拟合曲线过初始点
    %  deta(end-2:end)=fliplr(deta(1:3));
    yyang=yangsmooth( 5,x,yresult,s,deta); %smoothdata( kk,x,y,s,deta )，kk样条曲线次数
    % yyang=smooth(x,yresult);
    yangData(:,c)=yyang';
    yangData(1,:)=data(1,:);
    plot(x,yangData(:,c),'r-o');
    hold on;
    
    % 先smooth 再yangsmooth----------------------------------------
    s=0.04*std(yresult)^2;%%s小了贴合，s大了远离
    yyang=yangsmooth( 5,x,ysmooth,s,deta); %smoothdata( kk,x,y,s,deta )，kk样条曲线次数
    % yyang=smooth(x,yresult);
    smoothyangData(:,c)=yyang';
    smoothyangData(1,:)=data(1,:);
    plot(x,smoothyangData(:,c),'r-d');
    hold on;

    xlabel('{\itx}');
    ylabel('{\ity}');
    legend('theoryData','smoothData','yangData','smoothyangData');
    fontModify;
%     saveas(gcf,[ num2str(c) '-noisedataAndsmoothdata'],'png');
   
end
figure(6)
plot(yangData(:,3),yangData(:,2),'r-o');
hold on;
plot(smoothyangData(:,3),smoothyangData(:,2),'r-d');
legend('yangData','smoothyangData');
title('{\itp}-{\itq}');
figure(7)
plot(yangData(:,1),yangData(:,3),'k-*');
title('{\ite_1}-{\itp}');
hold on;
plot(yangData(:,1),smooth(yangData(:,1),yangData(:,3)),'r-o');
legend('yangData','smooth(yangData)');
disp('succeed !')


