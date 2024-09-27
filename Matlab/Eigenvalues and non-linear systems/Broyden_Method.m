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
tol=1.e-5;
x=broyden(F,x0,tol)

function[x]=broyden(F,x0,tol) %x0 es un vector inicial arbitrario
J=jacobian(F);
F=inline(F); %Función en línea
J=inline(J);
F0=F(x0(1),x0(2),x0(3),x0(4),x0(5),x0(6),x0(7),x0(8),x0(9),x0(10));
v=F0;
J0=J(x0(1),x0(2),x0(3),x0(4),x0(5),x0(6),x0(7),x0(8),x0(9),x0(10));
A=inv(J0);
s=-A*v;
x=x0+s; 
error=norm(x)*2; %Asignación para entrar en el loop

while error>tol
    x0=x;  
    w=v;
    F_new=F(x(1),x(2),x(3),x(4),x(5),x(6),x(7),x(8),x(9),x(10));
    v=F_new;
    y=v-w;
    z=-A*y;
    p=-s'*z;
    q=s'*A;
    R=(s+z)*q/p;
    A=A+R;
    s=-A*v;
    x=x+s; %Solución del sistema
    error=norm(x-x0); %Error a comparar con tolerancia
end
save BroydenVariables
end


