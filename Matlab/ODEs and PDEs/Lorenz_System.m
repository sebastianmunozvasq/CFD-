
%Condición inicial
x0=[0 1 0] ;
%Intervalo de tiempo y salto temporal
dt=0.01 ;
t0=0  ;
tf=30 ;
%se define la función f que representa al sistema de EDOs
f=@(t,x)Lorenz(t,x);%[Pr(x(2)-x(1)) Ra*x(1)-x(2)-x(1)*x(3) x(1)*x(2)-beta*x(3)];
%Resolución del sistema
[x,t]=RK4(f,x0,t0,tf,dt); 
%grafico de resultados 
figure;

plot3(x(1,:),x(2,:),x(3,:))
titulo='Estado del sistema de Lorenz para t=30(3000 iteraciones) con Ra=24.74' ;
title(titulo)
xlabel('x(t)')
ylabel('y(t)')
zlabel('z(t)')


function [AL]=Lorenz(t,x)
%Definición de parametros 
Pr=10;
Ra=28;
beta=8/3;
%Sistema de EDOs
AL=[Pr*(x(2)-x(1)),Ra*x(1)-x(2)-x(1)*x(3),x(1)*x(2)-beta*x(3)];
end

function [x,t]=RK4(f,x0,t0,tf,dt)

nx=length(x0);
t=t0:dt:tf ;
nt=length(t);
x=zeros(nx,nt);
x(:,1)=x0;
%Aplicación del esquema RK4
for i=1:nt-1
    k1=dt*f(t(i),x(:,i));
    k2=dt*f(t(i)+dt/2,x(:,i)+k1/2);
    k3=dt*f(t(i)+dt/2,x(:,i)+k2/2);
    k4=dt*f(t(i)+dt,x(:,i)+k3);
    x(:,i+1)=x(:,i)+1/6*(k1'+2*k2'+2*k3'+k4');
end
end