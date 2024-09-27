%---------EULER-IMPLICITO-------------
%Parametros del problema
l=0.5;
l1=0.45;
lam1=2*3600;
rc1=2*10^6;
rc2=1*10^6;
lam2=0.1*3600;

T1=10;
h=4*3600;
dT1=5;
T0=20;
%Parametros del método
nx=100;  %número de nodos espaciales
dx=l/(nx-1);
dt=0.1;% %Paso de tiempo a utilizar
time=2; %Tiempo a simular 
nt=time/dt; 
%Sigma para cada material
sigma1=lam1*dt/(rc1*dx^2); 
sigma2=lam2*dt/(rc2*dx^2);


%Perfil inicial
T=T1*ones(1,nx);
%Condiciones de borde izquierda
BC1=@(t)(T1+dT1*sin(2*pi*t/24));

%Resolución del sistema
for n=1:nt
   t=n*dt;
   b=matriz_b(T,sigma1,sigma2,nx,dx,l1,h,T0,lam2);
   A=matriz_A(nx,dx,sigma1,sigma2,l1,h,lam2);
   %T_int=LU_mp(A,b); %Resolucíon del sistema lineal
   T_int=A\b';
   T(2:nx-1)=T_int;
   %Condiciones de borde
   T(1)=BC1(t);
   T(nx)=T0;  %Temperatura fija lado derecho  
   (lam2/dx*T(nx-1)+h*T0)/(h+lam2/dx);
   %T(nx)=(lam2*T(nx-1)+h*dx*T0)/(h*dx+lam2);%(lam2/dx*T(nx-1)+h*T0)/(h+lam2/dx); % Convección lado derecho%
end
x=linspace(0,l,nx);
titulo="Perfil de temperatura a las " + time + " [h], Euler implícito"
figure;

plot(x,T)
xlabel('Pared [m]')

ylim([0 35])
ylabel('Temperatura en [°C]')
title(titulo)
%Función para generar la matriz A
function [A]=matriz_A(nx,dx,sigma1,sigma2,l1,h,lam2)
%Aqui tengo que modificar por el cambio de material
A=zeros(nx-2,nx-2);
%Comentar alguna de las siguientes lineas dependiendo de la CB
%A(nx-2,nx-2)=2+1/sigma2-lam2/(h*dx+lam2); %Convección
A(nx-2,nx-2)=2+1/sigma2;%Temperatura fija
A(nx-2,nx-3)=-1;
for i=1:nx-3
    %Evaluamos en qué punto del material nos encontramos
    if dx*i<l1
        sigma=sigma1;
    else
        sigma=sigma2;
    end
   
   A(i,i)=2+1/sigma; 
   A(i,i+1)=-1;
   A(i+1,i)=-1;
end
 
end
%Función para generar la matriz b
function [b]=matriz_b(T,sigma1,sigma2,nx,dx,l1,h,T0,lam2)

 b= zeros(1,nx-2);
 Taux=T(2:nx-1);
 for i=1:nx-2
    if dx*i<l1
        sigma=sigma1;
    else
        sigma=sigma2;
    end
    b(i)=Taux(i)*1/sigma;
 end
 %Se aplican las condiciónes de borde 
 %Si la CB es convección: Comentar 2da linea y descomentar la 3ra
 b(1)=b(1)+T(1);
 b(nx-2)=b(nx-2)+T(nx);
 %b(nx-2)=b(nx-2)+T(nx-1)+h*T0/(h+lam2/dx); %Convección a la derecha
 
end
%Método LU para resolver sistemas lineales realizado en la Tarea 1
function [x]=LU_mp(A,b)
%Factorización
    n=size(A,1);
    for j=1:n-1 %j columnas
        for i=j+1:n %i filas 
            f=A(i,j)/A(j,j);
            A(i,j)=f;
            for k=j+1:n
                A(i,k)=A(i,k)-f*A(j,k);
            end
        end
    end
    L=eye(n);
    for j=1:n
        for k=j+1:n
            L(k,j)=A(k,j);
            A(k,j)=0;
        end
    end
U=A;

%Sustitución hacia delante
y=zeros(n,1);
y(1)=b(1)/L(1,1);
for i=2:n
    y(i)=(b(i)-L(i,1:i-1)*y(1:i-1))/L(i,i);
end
%Sustitución hacia atrás
x=zeros(n,1);
x(n)=y(n)/U(n,n);
for i=n-1:-1:1
    x(i)=(y(i)-U(i,i+1:n)*x(i+1:n))/U(i,i);
end
end