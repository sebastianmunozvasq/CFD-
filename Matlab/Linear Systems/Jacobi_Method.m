%Jacobi
function[x]= jacobi(A,b)
nf=size(A,1);
x0=zeros(nf,1); %Solución supuesta
x=x0; 
e=0.0001; %Tolerancia
x_old=x+2; %Matriz para entrar en el loop (calculando error)
while abs(x-x_old)>e
    x_old=x;
    for i=1:nf
        x(i)=(b(i)/A(i,i))-(A(i,[1:i-1,i+1:nf])*x([1:i-1,i+1:nf]))/A(i,i);   
    end    
end
x;        
end    