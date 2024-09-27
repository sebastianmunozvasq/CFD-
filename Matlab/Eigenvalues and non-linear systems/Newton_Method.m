clear 
clc
syms x1 x2 x3 x4 x5 x6 x7 x8 x9 x10     
f1=-1017.31*(x5^1.852)-508.66*(x6^1.852)+1017.31*(x9^1.852)+2329.37*(x4^1.852);
f2=-1017.31*(x9^1.852)-508.66*(x7^1.852)+1017.31*(x10^1.852)-2329.37*(x3^1.852);
f3=-175.68*(x8^1.852)-2329.37*(x4^1.852)+2329.37*(x3^1.852)+175.68*(x2^1.852)+351.36*(x1^1.852);
f4=x8+x1-0.2;
f5=x1-x2-0.038;
f6=x2-x3-x10-0.008;
f7=x3-x9+x4-0.02;
f8=-x4+x8-x5-0.02;
f9=x6+x9-x7-0.008;
f10=x7+x10-0.1;
F=[f1;f2;f3;f4;f5;f6;f7;f8;f9;f10];
n=size(F,1);
x0=ones(n,1);
tol=1e-5;
x=newtonsys(F,x0,tol)

function [x] = newtonsys(F,x0,tol) %x0 es un vector inicial arbitrario
J=jacobian(F);
J=inline(J); %Función en línea
F=inline(F); 
x = x0;
x_old=2*x; %Asignación para entrar en el loop
error=norm(x-x_old);
while error>= tol
    x_old=x;    
    J_new=J(x_old(1),x_old(2),x_old(3),x_old(4),x_old(5),x_old(6),x_old(7),x_old(8),x_old(9),x_old(10));
    F_new=F(x_old(1),x_old(2),x_old(3),x_old(4),x_old(5),x_old(6),x_old(7),x_old(8),x_old(9),x_old(10)); 
    delta = - J_new^-1 *F_new;
    x = x + delta; %Solución del sistema
    error=norm(x-x_old); %Error a comparar con tolerancia
end
save NewtonVariables
end








