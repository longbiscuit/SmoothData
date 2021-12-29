clc;
clear all;
close all;
filename='csuhReadInListZong.txt';
fileID = fopen(filename);
C=textscan(fileID,'%s %f','delimiter', ',');%第一种方法读取文档：textscan
LengthC=length(C{1,1});
fclose(fileID);

for k=1:LengthC
    
    strTem='';
    strTem=string((C{1,1}(k,1)));
    TextList(k)=strTem;%输入文档列表
    myType(k)=(C{1,2}(k,1));
    
    charTem=char(strTem);
    filenameLength=length(charTem);
    lianjiefu='-';
    charTem=charTem(1:filenameLength-4);
    filename='';
%     filename=[charTem(1:filenameLength-4),lianjiefu,num2str(myType(k)),'-cs.txt'];
    filename=[charTem(1:filenameLength-4),lianjiefu,'cs.txt'];
    TextListOut(k)=string(filename);%输出文档列表
end
textNums=length(C{1,1});%有几个文本文档

%读入实验数据
for i=1:textNums
    filename='';
    filename=char(TextList(i));
    data=load(filename,'-ascii');%第二种方法读取文档：load
    [m,n]=size(data);
    DataLines(i)=m;%每个数据文档行数
    for j=1:m%行
        for k=1:n%列
            ArrayLabData(i,j,k)=data(j,k);
        end
    end  
end


for i=1:textNums
    exp_epsa=ArrayLabData(i,1:DataLines(i),1);%第一列
    exp_q=ArrayLabData(i,1:DataLines(i),2);
    exp_p=ArrayLabData(i,1:DataLines(i),3);
    exp_e=ArrayLabData(i,1:DataLines(i),4);
    exp_u=ArrayLabData(i,1:DataLines(i),5);
    %     插值
    temp_ref=max(exp_epsa);
%     eps_temp=0:1/1000:temp_ref;
    eps_temp=linspace(0,temp_ref,300);
%     exp_q_cs=csaps(exp_epsa,exp_q,1,eps_temp);
%     exp_p_cs=csaps(exp_epsa,exp_p,1,eps_temp);
%     exp_e_cs=csaps(exp_epsa,exp_e,1,eps_temp);
%     exp_u_cs=csaps(exp_epsa,exp_u,1,eps_temp);
    exp_q_cs=spline(exp_epsa,exp_q,eps_temp);
    exp_p_cs=spline(exp_epsa,exp_p,eps_temp);
    exp_e_cs=spline(exp_epsa,exp_e,eps_temp);
    exp_u_cs=spline(exp_epsa,exp_u,eps_temp);
    
    exp_epsa_cs=eps_temp;
    
    outDataLines(i)=numel(exp_epsa_cs);
    
    ArrayLabDataCS(i,1:outDataLines(i),1)=exp_epsa_cs;
    ArrayLabDataCS(i,1:outDataLines(i),2)=exp_q_cs;
    ArrayLabDataCS(i,1:outDataLines(i),3)=exp_p_cs;
    ArrayLabDataCS(i,1:outDataLines(i),4)=exp_e_cs;
    ArrayLabDataCS(i,1:outDataLines(i),5)=exp_u_cs;
end
%将数据写入文档

for i=1:textNums
    filename=TextListOut(i);
    twoDimArrTem(1:outDataLines(i),:)=ArrayLabDataCS(i,1:outDataLines(i),:);
    %     save(char(filename),'twoDimArrTem','-ascii');%虽然可以写入，但没有逗号
    fid=fopen(filename,'wt'); %写的方式打开文件（若不存在，建立文件）；
     for j=1:outDataLines(i)
        fprintf(fid,'%f,%f,%f,%f,%f\n ',twoDimArrTem(j,:));  % %d 表示以整数形式写入数据，这正是我想要的；        
     end
    fclose(fid);  %关闭文件；
end
%输出文档路径
filename='csuhReadInListZong-cs.txt';
fileID = fopen(filename,'wt');
for k=1:LengthC
   fN=string([char(TextListOut(k)),',', num2str(myType(k))]);
   fprintf(fileID,'%s\n',fN);%fN是字符串还是字符数组都行
end
fclose(fileID);  %关闭文件；
% 
fclose('all');
disp('spline completed!');








