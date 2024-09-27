%Parametros 1er mat (Pared)
  rc1=2*10^6;
  lam1=2*3600;
  l1=0.45;
  T1=10;
  h=4*3600;
  dT1=5;

%Parametros 2do mat (Aislante)
   rc2=1*10^6;
   lam2=0.1*3600;
   l=0.5;
   T0=20;
%Parametros esquema 
nx=100;  %número de nodos espaciales
dx=l/nx;
dt=0.001;% %Paso de tiempo a utilizar
time=2; %Tiempo a simular 
nt=time/dt;
%Calculo de la condición CFL para estabilidad
CFL1=lam1*dt/(rc1*dx^2);
CFL2=lam2*dt/(rc2*dx^2);
if CFL1>0.5 || CFL2>0.5  %Evaluación de la condición CFL 
    disp('Alguno de los CFL es mayor a 0.5')
    CFL1
    CFL2
    return  %El programa termina si no se cumple la restricción para el CFL
end
%Perfil inicial
T=T1*ones(1,nx);
%Condiciones de borde
BC1=@(t)(T1+dT1*sin(2*pi*t/24)); %función temperatura de pared externa
%Condición de borde de temperatura constante a la derecha
T(nx)=T0; %Se debe comentar esta linea si la condición es convección

%ESQUEMA FTCS 

for n=2:nt
    t=n*dt;
    T(1)=BC1(t); %Condición de borde exterior
    for i=2:nx-1 
        %Se evalua en que punto de la pared nos encontramos
        if i*dx<l1
            rc=rc1;
            lam=lam1;
        elseif i*dx>l1
            rc=rc2;
            lam=lam2;
        else
            %Condición para la interfaz
            T(i)=(lam1*T(i-1)+lam2*T(i+1))/(lam1+lam2); 
            continue
        end
        T(i)=lam*dt/(rc*dx^2)*(T(i+1)-2*T(i)+T(i-1))+T(i);
        
        %Se debe descomentar la siguiente linea si  la condición es
        %convección
        %T(nx)=(lam2/dx*T(nx-1)+h*T0)/(h+lam2/dx); % Convección lado derecho
    end
end
x=linspace(0,l,nx);
titulo="Perfil de temperatura a las " + time + " [h], FTCS"
figure;
plot(x,T)
xlabel('Pared [m]')
ylabel('Temperatura en [°C]')
ylim([0 20])
title(titulo)
    
    