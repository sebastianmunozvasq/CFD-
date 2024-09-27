%n es el número de nodos a utilizar
%a,b son los extremos del intervalo
%f es la función a interpolar 
n=2;
a=0;
b=3*pi;
syms x 
f=sin(x);

%---------Gráficos función 1-------
%Para cada orden se calculan los nodos de Chebyshev y luego se computan los
%polinomios de lagrange para estos nodos 
figure
fplot(x,f,[0 3*pi],'LineWidth',2)
hold on
%orden 2
[nodos]=nodosChebyshev(f,a,b,3);
y=sin(nodos);
p2=expand(lagrange(nodos,y,x));
fplot(x,p2,[0 3*pi])
%orden 3
[nodos]=nodosChebyshev(f,a,b,4);
y=sin(nodos);
p3=expand(lagrange(nodos,y,x));
fplot(x,p3,[0 3*pi])
%orden 4
[nodos]=nodosChebyshev(f,a,b,5);
y=sin(nodos);
p4=expand(lagrange(nodos,y,x));
fplot(x,p4,[0 3*pi])
%orden 5
[nodos]=nodosChebyshev(f,a,b,6);
y=sin(nodos);
p5=expand(lagrange(nodos,y,x));
fplot(x,p5,[0 3*pi])
%orden 6
[nodos]=nodosChebyshev(f,a,b,7);
y=sin(nodos);
p6=expand(lagrange(nodos,y,x));
fplot(x,p6,[0 3*pi])
%orden 7
[nodos]=nodosChebyshev(f,a,b,8);
y=sin(nodos);
p7=expand(lagrange(nodos,y,x));
fplot(x,p7,[0 3*pi])
%orden 8 
[nodos]=nodosChebyshev(f,a,b,9);
y=sin(nodos);
p8=expand(lagrange(nodos,y,x));
fplot(x,p8,[0 3*pi])
hold off
legend('sin(x)','Chebyshev Grado 2','Chebyshev Grado 3','Chebyshev Grado 4','Chebyshev Grado 5','Chebyshev Grado 6','Chebyshev Grado 7','Chebyshev Grado 8')
title('Interpolación de Chebyshev para sin(x)')
xlabel('x')
ylabel('y')
%---------Gráficos función 2-------
figure
fplot(x,f,[-5 5],'LineWidth',2)
hold on
%orden 2
[nodos]=nodosChebyshev(f,a,b,3);
y=zeros(1,3);
for i=1:3
   y(i)=subs(f,nodos(i)); 
end
p2=expand(lagrange(nodos,y,x));
fplot(x,p2,[-5 5])
%orden 3
[nodos]=nodosChebyshev(f,a,b,4);
y=zeros(1,4);
for i=1:4
   y(i)=subs(f,nodos(i)); 
end
p3=expand(lagrange(nodos,y,x));
fplot(x,p3,[-5 5])
%orden 4
[nodos]=nodosChebyshev(f,a,b,5);
y=zeros(1,5);
for i=1:5
   y(i)=subs(f,nodos(i)); 
end
p4=expand(lagrange(nodos,y,x));
fplot(x,p4,[-5 5])
%orden 5
[nodos]=nodosChebyshev(f,a,b,6);
y=zeros(1,6);
for i=1:6
   y(i)=subs(f,nodos(i)); 
end
p5=expand(lagrange(nodos,y,x));
fplot(x,p5,[-5 5])
%orden 6
[nodos]=nodosChebyshev(f,a,b,7);
y=zeros(1,7);
for i=1:7
   y(i)=subs(f,nodos(i)); 
end
p6=expand(lagrange(nodos,y,x));
fplot(x,p6,[-5 5])
%orden 7
[nodos]=nodosChebyshev(f,a,b,8);
y=zeros(1,8);
for i=1:8
   y(i)=subs(f,nodos(i)); 
end
p7=expand(lagrange(nodos,y,x));
fplot(x,p7,[-5 5])
%orden 8 
[nodos]=nodosChebyshev(f,a,b,9);
y=zeros(1,9);
for i=1:9
   y(i)=subs(f,nodos(i)); 
end
p8=expand(lagrange(nodos,y,x));
fplot(x,p8,[-5 5])
hold off
legend('1/(1+x^2)','Chebyshev Grado 2','Chebyshev Grado 3','Chebyshev Grado 4','Chebyshev Grado 5','Chebyshev Grado 6','Chebyshev Grado 7','Chebyshev Grado 8')
title('Interpolación de Chebyshev para 1/(1+x^2)ck')
xlabel('x')
ylabel('y')
%Función para calcular los nodos de Chebyshev
function [x]=nodosChebyshev(f,a,b,n)
%Se asigna espacio a vectores que contendran nodos de Chebyshev
r=zeros(1,n); %Nodos en el intervalo [-1,1]
x=zeros(1,n); %Nodos en el intervalo [a,b]
for i=1:n
    r(i)=-cos((2*i-1)/(2*n)*pi());
end
for i=1:n 
    x(i)=(r(i)+1)*(b-a)/2+a;
end
end

function y=lagrange(data_x, data_y,x)
sum = 0;
n=length(data_x);
for i = 1:n
    product = data_y(i);
    for j = 1:n
        if i ~= j
            product = product*(x - data_x(j))/(data_x(i) - data_x(j));
        end
    end
sum = sum + product;
end
y = sum;
save lagrangeevariables
end