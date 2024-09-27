function[x]=metod_qr(A,b)
[m,n]=size(A);
R=A;        %Se asigna matriz A a R
Q=eye(m);   %Se asigna la identidad a Q para la primera iteración
for i=1:n
    H=eye(m);
    if i==1
       x=R(:,1);
    else
       x=R(i:m,i);%bien
    end
    Hb= Householder(x);
    size(Hb);
    if i==1
        H=Hb;
    elseif i==n
        H(n,n)=Hb;
    else
        H(i:m,i:n)=Hb;
    end
    R=H*R;
    Q=Q*H;
end
%Resolución del sistema usando Q y R mediante sust hacia atras
b2=Q'*b;
x=zeros(n,1);
x(n)=b2(n)/R(n,n);
for i=n-1:-1:1
    x(i)=(b2(i)-R(i,i+1:n)*x(i+1:n))/R(i,i);
end

function [H]=Householder(x)  %Funcion para generar matriz de Housholder
    ei=zeros(size(x));
    ei(1)=1;
    u=x+sign(x(1))*(x'*x)*ei;
    k=length(u);
    H=eye(k,k)-2*(u*u')/(u'*u);  
end
end