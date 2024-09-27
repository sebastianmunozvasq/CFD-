clear
clc
syms x %Variable independiente

%-----------------------Función 1----------------------------
y=sin(x);
figure
fplot(x,y,[0, 3*pi], 'LineWidth',2)
hold on
%Orden 2
data_x=linspace(0,3*pi,3); %Nodos
data_y=sin(data_x); %Función evaluada en los nodos
y2_f1=expand(lagrange(data_x,data_y,x));
fplot(x,y2_f1,[0,3*pi])
y2_f1=sym2poly(y2_f1)

%Orden 3
data_x=linspace(0,3*pi,4);
data_y=sin(data_x);
y3_f1=expand(lagrange(data_x,data_y,x));
fplot(x,y3_f1,[0,3*pi])
y3_f1=sym2poly(y3_f1)

%Orden 4
data_x=linspace(0,3*pi,5);
data_y=sin(data_x);
y4_f1=expand(lagrange(data_x,data_y,x));
fplot(x,y4_f1,[0,3*pi])
y4_f1=sym2poly(y4_f1)

%Orden 5
data_x=linspace(0,3*pi,6);
data_y=sin(data_x);
y5_f1=expand(lagrange(data_x,data_y,x));
fplot(x,y5_f1,[0,3*pi])
y5_f1=sym2poly(y5_f1)
 
%Orden 6
data_x=linspace(0,3*pi,7);
data_y=sin(data_x);
y6_f1=expand(lagrange(data_x,data_y,x));
fplot(x,y6_f1,[0,3*pi])
y6_f1=sym2poly(y6_f1)
% 
% %Orden 7
data_x=linspace(0,3*pi,8);
 data_y=sin(data_x);
y7_f1=expand(lagrange(data_x,data_y,x));
fplot(x,y7_f1,[0,3*pi])
y7_f1=sym2poly(y7_f1)
 
%Orden 8
data_x=linspace(0,3*pi,9);
data_y=sin(data_x);
y8_f1=expand(lagrange(data_x,data_y,x));
fplot(x,y8_f1,[0,3*pi])
y8_f1=sym2poly(y8_f1)
hold off

legend('sin(x)','Lagrange Grado 2', 'Lagrange Grado 3', 'Lagrange Grado 4', 'Lagrange Grado 5', 'Lagrange Grado 6', 'Lagrange Grado 7', 'Lagrange Grado 8')
title('Interpolación de Lagrange para sin(x)')
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
y2_f2=expand(lagrange(data_x,data_y,x));
fplot(x,y2_f2,[-5,5])
y2_f2=sym2poly(y2_f2)

%Orden 3
data_x=linspace(-5,5,4);
data_y=1./(1+(data_x).^2);
y3_f2=expand(lagrange(data_x,data_y,x));
fplot(x,y3_f2,[-5,5])
y3_f2=sym2poly(y3_f2)

%Orden 4
data_x=linspace(-5,5,5);
data_y=1./(1+(data_x).^2);
y4_f2=expand(lagrange(data_x,data_y,x));
fplot(x,y4_f2,[-5,5])
y4_f2=sym2poly(y4_f2)

%Orden 5
data_x=linspace(-5,5,6);
data_y=1./(1+(data_x).^2);
y5_f2=expand(lagrange(data_x,data_y,x));
fplot(x,y5_f2,[-5,5])
y5_f2=sym2poly(y5_f2)

%Orden 6
data_x=linspace(-5,5,7);
data_y=1./(1+(data_x).^2);
y6_f2=expand(lagrange(data_x,data_y,x));
fplot(x,y6_f2,[-5,5])
y6_f2=sym2poly(y6_f2)

%Orden 7
data_x=linspace(-5,5,8);
data_y=1./(1+(data_x).^2);
y7_f2=expand(lagrange(data_x,data_y,x));
fplot(x,y7_f2,[-5,5])
y7_f2=sym2poly(y7_f2)

%Orden 8
data_x=linspace(-5,5,9);
data_y=1./(1+(data_x).^2);
y8_f2=expand(lagrange(data_x,data_y,x));
fplot(y8_f2,[-5 5])
hold off
y8_f2=sym2poly(y8_f2)
legend('1/1+x^2','Lagrange Grado 2', 'Lagrange Grado 3', 'Lagrange Grado 4', 'Lagrange Grado 5', 'Lagrange Grado 6', 'Lagrange Grado 7', 'Lagrange Grado 8')
title('Interpolación de Lagrange para 1/(1+x^2)')
xlabel('x')
ylabel('y')

function y=lagrange(data_x, data_y,x)
sum = 0;
n=length(data_x); %Numero de nodos
for i = 1:n
    prod = data_y(i);
    for j = 1:n
        if i ~= j
            prod = prod*(x - data_x(j))/(data_x(i) - data_x(j)); %Funciones del Polinomio de Lagrange
        end
    end
sum = sum + prod; %Sumatoria de elementos del polinomio
end
y = sum; %Polinomio resultante
save lagrangeevariables
end


