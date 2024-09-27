clear
clc
syms x
fun=exp(-(x^2)); %Función a integrar
a=0; %Límite inferior de integración
b=1; %Límite superior de integración
m=3; %Número de intervalos
integ=simpson(a,b,m,fun)


function integ = simpson(a,b,m,fun)
h=(b-a)/m; %Ancho de cada intervalo
x=[a:h/2:b]; %Nodos para evaluar función 
n = length(x); %Número de nodos
y=zeros(1,n);
for i=1:n
    y(i)=subs(fun,x(i)); %Función evaluada en nodo
end
if size(y)==1 
    y=diag(ones(n))*y; 
end;
integ=(h/6)*(y(1)+2*sum(y(3:2:2*m-1))+4*sum(y(2:2:2*m))+y(2*m+1)); %Resultado de integración numérica
save Simpsonvariables
end