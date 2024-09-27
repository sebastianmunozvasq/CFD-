syms x
fun=exp(-(x^2)); %Función a integrar
a=0; %Límite inferior de integración
b=1; %Límite superior de integración
m=29; %Número de intervalos
[integ]=trapecio(a,b,m,fun)

function integ = trapecio(a,b,m,fun)
h=(b-a)/m; %Ancho de cada intervalo
x=[a:h:b]; %Nodos para evaluar función 
n=length(x); %Número de nodos
y=zeros(n,1);
for i=1:n
    y(i)=subs(fun,x(i)); %Función evaluada en nodo
end
if size(y)==1
    y=diag(ones(n))*y; 
end;
integ=h*(0.5*y(1)+sum(y(2:m))+0.5*y(m+1)); %Resultado de integración numérica
save Trapeciovariables
end
