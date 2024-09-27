clear
clc
syms x
% 
% %---------------Función 1--------------
y=sin(x);
figure
fplot(x,y,[0, 3*pi],'LineWidth',2)
hold on
 
data_x=linspace(0,3*pi,40); %Nodos
data_y=sin(data_x); %Función evaluada en los nodos
y1=splinelineal(data_x,data_y,x); %Spline lineal
n=length(data_x); %Número de nodos
for i=1:n-1
     fplot(x,y1(i), [data_x(i), data_x(i+1)])
     hold on
end
hold off
legend('sin(x)', 'Spline lineal, 40 nodos')
title('Aproximación de sin(x) con Spline lineal')
xlabel('x') 
ylabel('y(x)')

% % %-------------Función 2-----------
y=1/(1+x^2);
figure
fplot(x,y,[-5, 5],'LineWidth',2)
hold on
 
data_x=linspace(-5,5,70);
data_y=1./(1+(data_x).^2);
y2=splinelineal(data_x,data_y,x);
n=length(data_x);
for i=1:n-1
     fplot(x,y2(i), [data_x(i), data_x(i+1)])
     hold on
end
hold off
legend('1/(1+x^2)', 'Spline lineal, 70 nodos')
title('Aproximación de 1/(1+x^2) con Spline lineal')
xlabel('x') 
ylabel('y(x)')


function y=splinelineal(data_x,data_y,x)
n=length(data_x); %Número de nodos
y=zeros(n-1,1);
y=sym(y);
for i=1:n-1
    m=(data_y(i+1)-data_y(i))/(data_x(i+1)-data_x(i)); %Pendiente de la recta
    b=data_y(i)-m*data_x(i); %Intercepto de la recta
    y(i)=m*x+b; %Recta en el intervalo
end
y; %Conjunto de rectas
save Splinelinealvariables
end