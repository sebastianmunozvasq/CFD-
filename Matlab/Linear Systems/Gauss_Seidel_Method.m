function[x]= gauss_seidel(A,b)
nf=size(A,1);
x=ones(nf,1);
e=0.0001; %Tolerancia
x0=zeros(nf,1); %Solución supuesta
x_old=x*1.1; %Matriz para entrar en el loop (calculando error)
while abs(x-x_old)>e 
    x_old=x;
    for i=1:nf
        x(i)=(b(i)/A(i,i))-(A(i,[1:i-1,i+1:nf])*x0([1:i-1,i+1:nf]))/A(i,i);
        x0(i)=x(i);
    end
    
end
x;        
end