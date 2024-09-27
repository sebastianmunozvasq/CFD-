clear
clc
syms x
fun=exp(-(x^2)); %Función a integrar
a=0; %Límite inferior de integración
b=1; %Límite superior de integración
m=4280; %Número de intervalos
integ=rectangulo(a,b,m,fun)


function integ =rectangulo(a,b,m,fun)
h=(b-a)/m; %Ancho de cada intervalo
x=[a+h:h:b]; %%Nodos para evaluar función por la derecha 
n=length(x); %Número de nodos
y=zeros(1,n);
for i=1:n
    y(i)=subs(fun,x(i)); %Función evaluada en nodo
end
if size(y)==1
    y=diag(ones(n))*y; 
end; 
integ=h*sum(y); %Resultado de integración numérica
save Rectangulovariables
end
