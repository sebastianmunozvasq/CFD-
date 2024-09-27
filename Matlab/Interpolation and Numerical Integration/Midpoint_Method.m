clear
clc
syms x
fun=exp(-(x^2)); %Función a integrar
a=0; %Límite inferior de integración
b=1; %Límite superior de integración
m=35; %Número de intervalos
integ=puntomedio(a,b,m,fun)


function integ =puntomedio(a,b,m,fun)
h=(b-a)/m; %Ancho de cada intervalo
x=[a+h/2:h:b]; %Nodos para evaluar función 
n=length(x); %Número de nodos
y=zeros(1,n);
for i=1:n
    y(i)=subs(fun,x(i)); %Función evaluada en nodo
end
if size(y)==1
    y=diag(ones(n))*y; 
end; 
integ=h*sum(y); %Resultado de integración numérica
save Puntomediovariables
end
