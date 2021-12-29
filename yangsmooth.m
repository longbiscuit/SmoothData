function [ Y ] = yangsmooth( kk,x,y,s,deta )
%yang �⻬����
%   kk: B���������ߵĴ���,ֻ��ȡ������һ��3 5 7 9 11
%   x: data x
%   y: data y
%   s:controls, s=1.0*std(yresult);%һ�����Ч���� sԽС������Խ����sԽ��Խ�⻬
%   deta:weight
%   deta=ones(size(y));
%   deta(1:3)=[0.00001,0.1,0.5];%��֤������߹���ʼ��
%   deta(end-2:end)=fliplr(deta(1:3));

if nargin<5%�����������ݵ��Ȩ�أ����û�и�ֵ����ȡĬ��ֵΪ1
    deta=ones(1,length(x));
end
detamax=max(deta);
w=detamax./deta;
rouz=-10;%-1 ��⻬����ȫ���ϣ�-10��⻬�����ϳ̶Ƚ�Զ
rou=1*10^(rouz);%
F=s+1;
Stepp1=0;
[B,E]=BE(kk,x,w);
y=y';
while F>s
    Stepp1=Stepp1+1;
    A=B+rou^(-1)*E;
    c=A\y;
    m=B*c-y;
    F=m'*m;
    if F>s
    invA=inv(A);
    dFdr=2*rou^(-2)*m'*B*invA*E*c;
    rou=rou-(F-s)/(dFdr);
    else
        break
    end
     if Stepp1>1000
         break
     end
end
%����ƽ������
BB=RB(kk,x,x);
Y=BB*c;
Y=Y';
end
% sub function
% 1-
function [ B,E ] = BE( kk,x,w )
%UNTITLED3 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
q=(kk+1)/2;
N=length(x);
for i=1:1:N
    for j=1:1:q
        xx=x(1,1:q+j);
        B(i,j)=bjxi(kk,xx,x(i));
        if i<=q+j && i>=1
            E(i,j)=w(i)^(-1)*betal(kk,xx,x(i));
        end
    end
    for j=q+1:1:N-q
        xx=x(1,j-q:1:j+q);
        B(i,j)=(x(j+q)-x(j-q))*bjxi(kk,xx,x(i));
        if i<=j+q && i>=j-q
            E(i,j)=w(i)^(-1)*(x(j+q)-x(j-q))*betal(kk,xx,x(i));
        end
    end
    for j=N-q+1:1:N
        xx=x(N)-x(1,N:-1:j-q);
        B(i,j)=bjxi(kk,xx,x(N)-x(i));
        if i<=N && i>=j-q
            E(i,j)=w(i)^(-1)*betal(kk,xx,x(N)-x(i));
        end
    end
end
E=(-1)^q*E;

end

% 2-
function [ B ] = RB( kk,x,X )
%UNTITLED4 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
q=(kk+1)/2;
N=length(x);
n=length(X);
for i=1:1:n
    for j=1:1:q
        xx=x(1,1:q+j);
        B(i,j)=bjxi(kk,xx,X(i));
    end
    for j=q+1:1:N-q
        xx=x(1,j-q:1:j+q);
        B(i,j)=(x(j+q)-x(j-q))*bjxi(kk,xx,X(i));
    end
    for j=N-q+1:1:N
        xx=x(N)-x(1,N:-1:j-q);
        B(i,j)=bjxi(kk,xx,x(N)-X(i));
    end
end

end

% 3-
function [ value ] = bjxi( kk,xx,X )
%UNTITLED5 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
n=length(xx);
value=zeros(1,length(X));
for i=1:1:length(X)
    XX=X(i);
    for k=1:1:n
        if(xx(k)-XX)>0
            m=(xx(k)-XX)^(kk);
        else
            m=0;
        end
        for l=1:1:n
            if l~=k
                m=m/(xx(k)-xx(l));
            end
        end
        value(i)=value(i)+m;
    end
end

end

% 4-
function [ beta ] = betal( kk,xx,X )
%UNTITLED6 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
n=length(xx);
m=factorial(kk);
for j=1:1:n
    if X~=xx(j)
        m=m/(X-xx(j));
    end
    beta=m;
end

end




