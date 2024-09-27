clear
clc
syms x %Variable independiente
%-------------------Función 1 -----------------
y=sin(x);
figure
fplot(x,y,[0, 3*pi], 'LineWidth',2)
hold on

%Orden 2
data_x=linspace(0,3*pi,3); %Nodos
data_y=sin(data_x); %Función evaluada en los nodos
y2_f1=expand(newton(data_x,data_y,x));
fplot(x,y2_f1,[0,3*pi])
y2_f1=sym2poly(y2_f1)

%Orden 3
data_x=linspace(0,3*pi,4);
data_y=sin(data_x);
y3_f1=expand(newton(data_x,data_y,x));
fplot(x,y3_f1,[0,3*pi])
y3_f1=sym2poly(y3_f1)

%Orden 4
data_x=linspace(0,3*pi,5);
data_y=sin(data_x);
y4_f1=expand(newton(data_x,data_y,x));
fplot(x,y4_f1,[0,3*pi])
y4_f1=sym2poly(y4_f1)
  
%Orden 5
data_x=linspace(0,3*pi,6);
data_y=sin(data_x);
y5_f1=expand(newton(data_x,data_y,x));
fplot(x,y5_f1,[0,3*pi])
y5_f1=sym2poly(y5_f1)

%Orden 6
data_x=linspace(0,3*pi,7);
data_y=sin(data_x);
y6_f1=expand(newton(data_x,data_y,x));
fplot(x,y6_f1,[0,3*pi])
y6_f1=sym2poly(y6_f1)

%Orden 7
data_x=linspace(0,3*pi,8);
data_y=sin(data_x);
y7_f1=expand(newton(data_x,data_y,x));
fplot(x,y7_f1,[0,3*pi])
y7_f1=sym2poly(y7_f1)

%Orden 8
data_x=linspace(0,3*pi,9);
data_y=sin(data_x);
y8_f1=expand(newton(data_x,data_y,x));
fplot(y8_f1,[0 3*pi]);
y8_f1=sym2poly(y8_f1)
hold off
legend('sin(x)','Newton Grado 2', 'Newton Grado 3', 'Newton Grado 4', 'Newton Grado 5', 'Newton Grado 6', 'Newton Grado 7', 'Newton Grado 8')
title('Interpolación de Newton para sin(x)')
xlabel('x')
ylabel('y')

% %---------------------Función 2---------------------------

y=1/(1+x^2);
figure
fplot(x,y,[-5,5], 'LineWidth',2)
hold on

%Orden 2
data_x=linspace(-5,5,3);
data_y=1./(1+(data_x).^2);
y2_f2=expand(newton(data_x,data_y,x));
fplot(x,y2_f2,[-5,5])
y2_f2=sym2poly(y2_f2)

%Orden 3
data_x=linspace(-5,5,4);
data_y=1./(1+(data_x).^2);
y3_f2=expand(newton(data_x,data_y,x));
fplot(x,y3_f2,[-5,5])
y3_f2=sym2poly(y3_f2)

%Orden 4
data_x=linspace(-5,5,5);
data_y=1./(1+(data_x).^2);
y4_f2=expand(newton(data_x,data_y,x));
fplot(x,y4_f2,[-5,5])
y4_f2=sym2poly(y4_f2)
 
%Orden 5
data_x=linspace(-5,5,6);
data_y=1./(1+(data_x).^2);
y5_f2=expand(newton(data_x,data_y,x));
fplot(x,y5_f2,[-5,5])
y5_f2=sym2poly(y5_f2)

%Orden 6
data_x=linspace(-5,5,7);
data_y=1./(1+(data_x).^2);
y6_f2=expand(newton(data_x,data_y,x));
fplot(x,y6_f2,[-5,5])
y6_f2=sym2poly(y6_f2)
 
%Orden 7
data_x=linspace(-5,5,8);
data_y=1./(1+(data_x).^2);
y7_f2=expand(newton(data_x,data_y,x));
fplot(x,y7_f2,[-5,5])
y7_f2=sym2poly(y7_f2)

% %Orden 8
data_x=linspace(-5,5,9);
data_y=1./(1+(data_x).^2);
y8_f2=expand(newton(data_x,data_y,x));
fplot(y8_f2,[-5,5])
y8_f2=sym2poly(y8_f2)

hold off
legend('1/(1+x^2)','Newton Grado 2', 'Newton Grado 3', 'Newton Grado 4', 'Newton Grado 5', 'Newton Grado 6', 'Newton Grado 7', 'Newton Grado 8')
title('Interpolación de Newton para 1/(1+x^2)')
xlabel('x')
ylabel('y')

function [y] = newton(data_x,data_y,x)
[m n] = size(data_y);
for j = 1:m
    a (:,1) = data_y (j,:)';
    for i = 2:n
        a (i:n,i) = (a(i:n,i-1)-a(i-1,i-1))./(data_x(i:n)-data_x(i-1))'; %Primeras diferencias divididas
    end
    y(j,:) = a(n,n).*(x-data_x(n-1)) + a(n-1,n-1); %Polinomio interpolante
    for i = 2:n-1
        y(j,:) = y(j,:).*(x-data_x(n-i))+a(n-i,n-i); 
    end
end
y; %Polinomio resultante
save Newtonvariables
end