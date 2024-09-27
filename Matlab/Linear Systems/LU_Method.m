function [x]=LU_mp(A,b)
%Factorización
    n=size(A,1);
    for j=1:n-1 %j columnas
        for i=j+1:n %i filas 
            f=A(i,j)/A(j,j);
            A(i,j)=f;
            for k=j+1:n
                A(i,k)=A(i,k)-f*A(j,k);
            end
        end
    end
    L=eye(n);
    for j=1:n
        for k=j+1:n
            L(k,j)=A(k,j);
            A(k,j)=0;
        end
    end
U=A;

%Sustitución hacia delante
y=zeros(n,1);
y(1)=b(1)/L(1,1);
for i=2:n
    y(i)=(b(i)-L(i,1:i-1)*y(1:i-1))/L(i,i);
end
y;
%Sustitución hacia atrás
x=zeros(n,1);
x(n)=y(n)/U(n,n);
for i=n-1:-1:1
    x(i)=(y(i)-U(i,i+1:n)*x(i+1:n))/U(i,i);
end
x;
end