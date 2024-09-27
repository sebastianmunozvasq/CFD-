%Gauss Legendre hasta 6 puntos 
a=0; %limite inferior
b=1; %limite superior
n=6; %cantidad de nodos
syms x 
f=exp(-x^2); %funcion a integrar
[integral]=double(gausslegendre(a,b,n,f))
function [I]=gausslegendre(a,b,n,f)
%tabla de coeficientes c
ci=[1.0000 1.0000 NaN NaN NaN NaN;0.5556 0.8889 0.5556 NaN NaN NaN;0.3479 0.6521 0.6521 0.3479 NaN NaN;0.2369 0.4786 0.5689 0.4786 0.2369 NaN;0.1713 0.3608 0.4679 0.4679 0.3608 0.1713];
%tabla de coeficientes x
xi=[-0.5774 0.5774 NaN NaN NaN NaN;-0.7746 0 0.7746 NaN NaN NaN;-0.8611 -0.3400 0.3400 0.8611 NaN NaN;-0.9062 -0.5385 0 0.5385 0.9062 NaN;-0.9325 -0.6612 -0.2386 0.2386 0.6612 0.9325];
%coeficientes para cambiar limites de integración
ao=double((b+a)/2);
a1=double((b-a)/2);
I=0;
for i=1:n
    I=I+ci(n-1,i)*subs(f,ao+a1*xi(n-1,i))*(b-a)/2;
end    
double(I)    
save Gauss_Legendrevariables
end    
    