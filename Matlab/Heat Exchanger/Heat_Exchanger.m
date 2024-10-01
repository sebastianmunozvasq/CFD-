%fluido 1: gas transversal a los tubos - eje x
%fluido 2: aceite dentro de los tubos - eje y

%Caso 1: Nf=40, Nc=100, Ly=4 [m}, mf1=1 [kg/s], mf2t=0.5 [kg/s]
%Parámetros principales
clc
clear
T1i=800+273.15; %Temperatura de entrada de fluido 1 [K]
T2i=20+273.15; %Temperatura de entrada de fluido 2 [K]

Nf=40; %Numero de filas de tubos
Nc=100; %%Numero de  columnas de tubos
Ly=4; %Longitud de los tubos [m]
Z=72.39e-3; %Separacion vertical entre centros de tubos [m]
ri=20.445e-3; %Radio interior de los tubos [m]
ro=24.13e-3; %Radios  exterior de los tubos [m]
re=39.5e-3; %Radio exterior de las aletas [m]
t=1e-3; %espesor de las aletas [m]
sigma_f=275; %Numero de aletas por unidad de longitud, sobre los tubos [1/m]
mf1=1; %flujo masico del fluido 1 [kg/s]
P1=120; %Presión del gas [kpa]
R=0.297; %Constante del gas
mf2t=0.5; %Flujo másico total del fluidos 2 [kg/s]
mf2=(mf2t/Nc)*ones(1,Nc); %Distribucion del flujo másico del fluido 2 entre las diferentes columnas de tubos [kg/s]
kt=40; %Conductividad termica de los tubos [W/(m·K)]
kf=386; %Conductividad termica de las aletas [W/(m·K)]
nt=sigma_f*Ly; %Cantidad total de aletas en un tubo
Ny=44; %Número de elementos de discretizacion en los tubos
%Constantes
n=sigma_f*Ly/Ny; %número de aletas en cada elemento
delta_y=Ly/Ny; % Longitud de cada elemento de los tubos [m]
delta_A1b=2*pi*ro*(delta_y-n*t); %Área de la base [m^2]
delta_A1f=2*pi*n*(re^2-ro^2+re*t); %Área de las aletas [m^2]
delta_A1=delta_A1b+delta_A1f; %Área neta del lado caliente de un elemento de cada tubo [m^2]
delta_A2=2*pi*ri*delta_y; %Área del lado frío de un elemento de cada tubo [m^2]
Rw=log(ro/ri)/(2*pi*kt*delta_y); %Resistencia térmica de la pared de cada tramo de los tubos [W/m^2*K]
%Inicialización de temperaturas en los elementos de entrada
T1=zeros(1,Nc+1); 
T1(1,1)=T1i; %Temperatura de entrada del fluido 1 [K]

T2=zeros(Nc, Ny+1);
%Desde i = 1 hasta i = Nc hacer: T2[i;1] = T2i
for i=1:Nc
    T2(i,1)=T2i; %Temperatura de entrada del fluido 2 [K]
end
%Estimación inicial
T1(Nc+1)=700+273.15; 
T1o=T1(Nc+1); %Estimación inicial de temperatura de salida del fluido 1 [K]
%Ciclo principal de Cálculo
while 1 %Se iterará hasta que se cumpla la condición de tolerancia definida después
    
    %Cálculos para eficiencia de aleta circular 
    r=re/ro;
    Le=re-ro+t/2;
    if r<=2
        b=0.9107+ 0.0893*r;
    else
        b=0.9706+0.17125*log(r);
    end
    C1=zeros(1,Nc); %Capacidad térmica del fluido 1 [J/K]
    Cp2=zeros(1,Ny); %Calor específico del fluido 2 [J/kg*K]
    Tm=(T1i+T1o)/2; %Temperatura media [K]
    Cp1m=1000*(1.0147+(3.3859e-4*Tm)-(1.6631e-6)*(Tm)^2+(3.5452e-9)*(Tm)^3-(2.8851e-12)*(Tm)^4+(8.1731e-16)*(Tm)^5); %Calor específico del fluido 1 a temperatura media [J/kg*K]
    rho1=P1/(R*Tm); %Densidad del fluido 1 [kg/m^3]
    u_max=mf1/(rho1*Ly*(Nf*(Z-2*ro)-sigma_f*(2*re-2*ro)*t)); %Velocidad promedio maxima del fluido 1 al pasar a traves de una columna de tubos [m/s]
    miu1=1.751e-6+(6.4458e-8)*Tm-(4.1435e-11)*Tm^2+(1.8385e-14)*Tm^3-(3.2051e-18)*Tm^4; %Viscosidad dinámica del fluido 1 [Pa*s]
    k1=1.995e-4+(9.9744e-5)*Tm-(4.8142e-8)*Tm^2+(1.614e-11)*Tm^3-(3.176e-15)*Tm^4; %Conductividad térmica del fluido 1 [W/(m·K)]
    Re1=rho1*u_max*2*ro/miu1; %Número de Reynolds del fluido 1
    Pr1=Cp1m*miu1/k1; %Número de Prandt del fluido 1
    
    %Cálculo de constantes para obtener número de Nusselt
    if Re1>0 && Re1<1e2
            C=0.9;
            alpha=0.4;
            beta=0.36;
        elseif Re1>1e2 && Re1<1e3
            C=0.52;
            alpha=0.5;
            beta=0.36;
        elseif Re1>1e3 && Re1<2e5
            C=0.27;
            alpha=0.63;
            beta=0.36;
        else
            C=0.033;
            alpha=0.8;
            beta=0.4;       
        end
    
        Nu=C*(Re1^alpha)*(Pr1^beta); %Número de Nusselt del fluido 1
        h1=Nu*k1/(2*ro); %Coeficiente de convección del fluido 1 [W/m^2*K]
    
    U=zeros(Nc, Ny); %Coeficiente global de transferencia de calor 1 [W/m^2*K]
    h2=zeros(Nc,Ny); %Coeficiente de convección del fluido 2 1 [W/m^2*K]
    for i=1:Nc
        Cp1=1000*(1.0147+(3.3859e-4)*T1(i)-(1.6631e-6)*(T1(i))^2+(3.5452e-9)*(T1(i))^3-(2.8851e-12)*(T1(i))^4+(8.1731e-16)*(T1(i))^5); %Calor específico del fluido 1 [J/kg*K]  
        C1(i)=mf1*Cp1;  %Capacidad térmica del fluido 1 [J/K]     
        %Cálculo de constantes para eficiente de aleta circular
        m=sqrt(2*h1/(kf*t));
        n=exp(0.13*m*Le-1.3863);
        phi=m*Le*(r)^n;
        if phi>0.6+2.257(r)^-0.445
            etha0=(r)^-0.246*(m*Le)^-b;  %Eficiencia individual de una aleta circular       
        else
            etha0=tanh(phi)/phi; 
        end 
        ethaf=(delta_A1b+etha0*delta_A1f)/delta_A1; %Eficiencia de la superficie con aletas   
                   
        for j=1:Ny
            Cp2(i,j)=1000*(0.81554 + 0.00364*T2(i,j)); %Calor específico del fluido 2 [J/kg*K]
            rho2=1040.3-0.60477*T2(i,j); %Densidad del fluido 2 [kg/m^3]
            u_max2=(mf2(i)/Nf)/(rho2*pi*ri^2); %Velocidad promedio máxima del fluido 2 [m/s]
            k2=-7.5722e-2 +(2.5952e-3)*T2(i,j)-(1.2033e-5)*(T2(i,j))^2 + (2.653e-8)*(T2(i,j))^3 -(2.8663e-11)*(T2(i,j))^4 + (1.2174e-14)*(T2(i,j))^5; %Conductividad térmica del fluido 2 [W/(m·K)]
            miu2=1000*exp(81.541-0.61584*(T2(i,j))+(1.7943e-3)*(((T2(i,j))^2)-(2.3678e-6)*(((T2(i,j))^3)+(1.1763e-9)*((T2(i,j))^4)))); %Viscosidad dinámica del fluido 2 [Pa*s]
            Pr2=Cp2*miu2/k2; %Número de Prandt del fluido 2       
            Re2=rho2*u_max2*2*ro/miu2; %Número de Reynolds del fluido 2
            C2=mf2(1,j)*Cp2(i,j); %Capacidad térmica del fluido 2 [J/K]
            f=0.00512+0.4572*(Re2^(-0.311)); %Factor de fricción de Darcy-Weisbach
            %Cálculo del número de Nusselt del fluido 2
            if Re2<3000
                Nu=4.36;
            elseif Re2>3000
                num=(f/8)*((Re2)-1000)*Pr2;
                den=1+12.7*sqrt(f/8)*(((Pr2)^(2/3))-1);
                Nu=num/den  
            end               
            h2(i,j)=Nu*k2/(2*ri); %Coeficiente de convección del fluido 2 [W/m^2*K]      
            U(i,j)=inv((delta_A2/(h1*ethaf*delta_A1))+delta_A2*Rw+(1/h2(i,j))); %Coeficiente global de transferencia de calor [W/m^2*K]       
            T2(i,j+1)=T2(i,j)+U(i,j)*delta_A2*(T1(i)-T2(i,j))/C2; %Temperatura de salida del fluido 2 hacia el siguiente elemento [K]
            if T2(i,j+1)>613.15 %Temperatura máxima del fluido 2 [K]
                break
            end
            
        end 
    
        %Cálculo de temperatura de salida del fluido 1 hacia el siguiente volumen de control 
        suma=0;
        for j=1:Ny;
            suma=suma+U(i,j)*(T1(i)-T2(i,j)); 
        
        end
        T1(i+1)=T1(i)-(delta_A2/C1(i))*suma;  %[K]
       
    end  
%Gráfico T2 vs x para la distribución de las temperaturas de salida T2[i,Ny+1]
    plot(T2(:,Ny+1)) 
    title('Distribución de temperaturas de salida')
    ylabel('T2[i,Ny+1], [K]')
    xlabel('X')   
%Decisión de si se debe realizar otra iteracion
    AUX=T1o; %Variable auxiliar para guardar valor recién usado de T1o
    T1o=T1(Nc+1); %Nueva temperatura de salida del fluido 1
    E=1; %Toleracion definida para esta diferencia

    if abs(T1o-AUX)<E %Condición de estimación aceptable
        break %Se sale del ciclo si se cumple tolerancia
    end

end
T1
T1o
T2
%Cálculo de temperatura de salida T2o con ec 5.11
 num=0;
 den=0;
 for i=1:Nc    
     num=num+mf2(i)*Cp2(i,Ny)*T2(i,Ny+1);
     den=den+mf2(i)*Cp2(i,Ny);      
 end
 T2o=num/den %Temperatura de salida del fluido 2 [K]
%Cálculo de calor transferido Q con ec 5.13 
 Q=0;
 for i=1:Nc
     Q=Q+C1(1,i)*(T1(i)-T1(i+1));
 end
 Q %Calor total transferido [W]
