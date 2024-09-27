A=[-65 5*sqrt(3) 0;5*sqrt(3) -75 0;0 0 -52.7];
n=size(A,1);
tol=1e-5;
x0=ones(n,1);
p=0; %Se calculará el valor propio de A más cercano al valor de p, que es cero para así encontrar el valor propio de menor módulo
[lambda,x] = invpowerit (A,p,tol,x0)

function [lambda,x]= invpowerit(A,p,tol,x0)
n=size(A,1);
[L,U]=lu(A-p*eye(n)); %Se resolveran dos sistemas triangulares en cada iteración para no calcular directmante la inversa de A en cada una de ellas
y0=x0/norm (x0); %Normalización del vector inicial
z0=inv(L)*y0;
z=z0;
lambda=y0'*(inv(U)*z);
err=tol*abs(lambda )+1; %Error inicial mayor a tolerancia para entrar en loop
while err >tol*abs(lambda )
x = inv(U)*z; 
x = x/norm (x); %Vector propio
z=inv(L)*x; 
lambdanew = x'*(inv(U)*z);
err = abs(lambdanew - lambda ); %Error a comparar con tolerancia
lambda=lambdanew; 
end
lambda = 1/lambda + p; %Valor propio mínimo
save InversePowerIterationVariables
end