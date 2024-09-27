clear 
clc
syms x1 x2 x3 x4 x5 x6 x7 x8 x9 x10     
f1=-1017.31*(x5^1.852)-508.66*(x6^1.852)+1017.31*(x9^1.852)-2329.37*(x4^1.852);
f2=-1017.31*(x9^1.852)-508.66*(x7^1.852)+1017.31*(x10^1.852)-2329.37*(x3^1.852);
f3=-175.68*(x8^1.852)+2329.37*(x4^1.852)+2329.37*(x3^1.852)+175.68*(x2^1.852)+351.36*(x1^1.852);
f4=x8+x1-0.2;
f5=x1-x2-0.038;
f6=x2-x3-x10-0.008;
f7=x3-x9-x4-0.02;
f8=x4+x8-x5-0.02;
f9=x6+x9-x7-0.008;
f10=x7+x10-0.1;
F=[f1;f2;f3;f4;f5;f6;f7;f8;f9;f10];

e=10^-1;
x0=[0 0 0 0 0 0 0 0 0 0];
[x_final]=GC_NL(F,x0,e);


function [x]=GC_NL(F,x0,e)
x=x0;
t=1;
sigma=0.01;
rho=0.5;
beta=1;
k=0;
[F_num]=evaluar(F,x);

while double(norm(F_num))>e   
    if k==0
        d=-F_num;
    else
        d=-(1+beta*F_num'*d/(norm(F_num)^2))*F_num+beta*d ;
    end
    beta=norm(F_num)/d;
    m=1;
    A=0;
    %Se debe encontrar el mínimo valor entero m>0 que satisfaga la
    %desigualdad A
    while A~=1 
    dotfd=dot(evaluar(F,x+beta*rho^m*d),d); 
    A=-eval(dotfd)>=eval(sigma*beta*rho^m*norm(d)^2);   
    m=m+1;
    end
    alpha=beta*rho^m;
    y=x+alpha*d; %Vector intermedio y
    [F_numy]=evaluar(F,y);
    hk=dot(F_numy,x-y);
    chik=hk/norm(F_numy)^2;  %Evaluar F en el vector numérico y 
    if hk>0
       Phk=x-chik*F_numy;
    else
       Phk=x;
    end
    x=Phk*(x-chik*F_numy); %Se calcula el nuevo x
    k=k+1;
end
end

function [G]=evaluar(F,x)   %Función para evaluar el vector F simbólico
syms x1 x2 x3 x4 x5 x6 x7 x8 x9 x10
% x1=x(1);
% x2=x(2);
% x3=x(3);
% x4=x(4);
% x5=x(5);
% x6=x(6);
% x7=x(7);
% x8=x(8);
% x9=x(9);
% x10=x(10);
G=subs(F,[x1 x2 x3 x4 x5 x6 x7 x8 x9 x10],x)
end
