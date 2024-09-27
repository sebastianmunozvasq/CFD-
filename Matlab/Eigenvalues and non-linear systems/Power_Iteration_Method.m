clc
clear
A=[-65 5*sqrt(3) 0;5*sqrt(3) -75 0;0 0 -52.7];
n=size(A,1);
tol=1e-6;
x0=ones(n,1);

[lambda,x]= powerit (A,tol ,x0)

%Algoritmo Power Iteration 
function [lambda,x]= powerit (A,tol,x0) %Vector inicial x0 es arbitrario
y0 = x0/norm (x0); %Normalización del vector inicial
lambda = y0'* A*y0; 
err = tol*abs(lambda) + 1; %Error inicial mayor a tolerancia para entrar en loop
y=y0;
while err >tol*abs(lambda)  
x = A*y; %Vector propio
y = x/norm (x);
lambdanew = y'* A*y;
err = abs(lambdanew - lambda ); %Error a comparar con tolerancia
lambda = lambdanew; %Valor propio máximo
end
save PowerIterationVariables.mat
end

