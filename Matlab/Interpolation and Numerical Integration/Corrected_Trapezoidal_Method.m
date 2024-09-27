clear
clc
syms x
fun=exp(-x^2); %Función a integrar
a=0; %Límite inferior de integración
b=1; %Límite superior de integración
m=3; %Número de intervalos
dfun=diff(fun,x); %Derivada de la función
integ=trapcorregido(a,b,m,fun,dfun)


function integ = trapcorregido(a,b,m,fun,dfun)
h=(b-a)/m; %Ancho de cada intervalo
x=[a:h:b]; %Nodos para evaluar función 
n=length(x); %Número de nodos
y=zeros(1,n);
for i=1:n
    y(i)=subs(fun,x(i)); %Función evaluada en nodo
end
dfa=subs(dfun,a); %Derivada evaluada en límite inferior de integración 
dfb=subs(dfun,b); %Derivada evaluada en límite superior de integración
integ=h*(0.5*y(1)+sum(y(2:m))+0.5*y(m+1))+(h^2/12)*(dfa-dfb); %Resultado de integración numérica
integ=double(integ);
save trapeciocorregidovariables
end
