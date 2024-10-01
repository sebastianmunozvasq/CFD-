% Fluid 1: gas transverse to the tubes - x-axis
% Fluid 2: oil inside the tubes - y-axis

% Case 1: Nf=40, Nc=100, Ly=4 [m], mf1=1 [kg/s], mf2t=0.5 [kg/s]
% Main Parameters
clc
clear
T1i=800+273.15; % Inlet temperature of fluid 1 [K]
T2i=20+273.15; % Inlet temperature of fluid 2 [K]

Nf=40; % Number of tube rows
Nc=100; % Number of tube columns
Ly=4; % Length of the tubes [m]
Z=72.39e-3; % Vertical distance between tube centers [m]
ri=20.445e-3; % Inner radius of the tubes [m]
ro=24.13e-3; % Outer radius of the tubes [m]
re=39.5e-3; % Outer radius of the fins [m]
t=1e-3; % Thickness of the fins [m]
sigma_f=275; % Number of fins per unit length on the tubes [1/m]
mf1=1; % Mass flow rate of fluid 1 [kg/s]
P1=120; % Gas pressure [kPa]
R=0.297; % Gas constant
mf2t=0.5; % Total mass flow rate of fluid 2 [kg/s]
mf2=(mf2t/Nc)*ones(1,Nc); % Mass flow distribution of fluid 2 across different tube columns [kg/s]
kt=40; % Thermal conductivity of the tubes [W/(m·K)]
kf=386; % Thermal conductivity of the fins [W/(m·K)]
nt=sigma_f*Ly; % Total number of fins on one tube
Ny=44; % Number of discretization elements in the tubes
% Constants
n=sigma_f*Ly/Ny; % Number of fins in each element
delta_y=Ly/Ny; % Length of each tube element [m]
delta_A1b=2*pi*ro*(delta_y-n*t); % Base area [m^2]
delta_A1f=2*pi*n*(re^2-ro^2+re*t); % Fin area [m^2]
delta_A1=delta_A1b+delta_A1f; % Net area on the hot side of one element of each tube [m^2]
delta_A2=2*pi*ri*delta_y; % Area on the cold side of one element of each tube [m^2]
Rw=log(ro/ri)/(2*pi*kt*delta_y); % Thermal resistance of the tube wall in each segment [W/m^2*K]
% Initialization of temperatures at inlet elements
T1=zeros(1,Nc+1); 
T1(1,1)=T1i; % Inlet temperature of fluid 1 [K]

T2=zeros(Nc, Ny+1);
% From i = 1 to i = Nc: T2[i;1] = T2i
for i=1:Nc
    T2(i,1)=T2i; % Inlet temperature of fluid 2 [K]
end
% Initial estimation
T1(Nc+1)=700+273.15; 
T1o=T1(Nc+1); % Initial estimate of the outlet temperature of fluid 1 [K]
% Main Calculation Loop
while 1 % Iterates until the defined tolerance condition is met
    
    % Calculations for circular fin efficiency
    r=re/ro;
    Le=re-ro+t/2;
    if r<=2
        b=0.9107+ 0.0893*r;
    else
        b=0.9706+0.17125*log(r);
    end
    C1=zeros(1,Nc); % Thermal capacity of fluid 1 [J/K]
    Cp2=zeros(1,Ny); % Specific heat capacity of fluid 2 [J/kg*K]
    Tm=(T1i+T1o)/2; % Mean temperature [K]
    Cp1m=1000*(1.0147+(3.3859e-4*Tm)-(1.6631e-6)*(Tm)^2+(3.5452e-9)*(Tm)^3-(2.8851e-12)*(Tm)^4+(8.1731e-16)*(Tm)^5); % Specific heat of fluid 1 at the mean temperature [J/kg*K]
    rho1=P1/(R*Tm); % Density of fluid 1 [kg/m^3]
    u_max=mf1/(rho1*Ly*(Nf*(Z-2*ro)-sigma_f*(2*re-2*ro)*t)); % Maximum average velocity of fluid 1 when passing through a tube column [m/s]
    miu1=1.751e-6+(6.4458e-8)*Tm-(4.1435e-11)*Tm^2+(1.8385e-14)*Tm^3-(3.2051e-18)*Tm^4; % Dynamic viscosity of fluid 1 [Pa*s]
    k1=1.995e-4+(9.9744e-5)*Tm-(4.8142e-8)*Tm^2+(1.614e-11)*Tm^3-(3.176e-15)*Tm^4; % Thermal conductivity of fluid 1 [W/(m·K)]
    Re1=rho1*u_max*2*ro/miu1; % Reynolds number of fluid 1
    Pr1=Cp1m*miu1/k1; % Prandtl number of fluid 1
    
    % Constant calculations for obtaining the Nusselt number
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

    
        Nu=C*(Re1^alpha)*(Pr1^beta); % Nusselt number for fluid 1
h1=Nu*k1/(2*ro); % Convective heat transfer coefficient for fluid 1 [W/m^2*K]

U=zeros(Nc, Ny); % Overall heat transfer coefficient [W/m^2*K]
h2=zeros(Nc,Ny); % Convective heat transfer coefficient for fluid 2 [W/m^2*K]
for i=1:Nc
    Cp1=1000*(1.0147+(3.3859e-4)*T1(i)-(1.6631e-6)*(T1(i))^2+(3.5452e-9)*(T1(i))^3-(2.8851e-12)*(T1(i))^4+(8.1731e-16)*(T1(i))^5); % Specific heat of fluid 1 [J/kg*K]  
    C1(i)=mf1*Cp1;  % Heat capacity of fluid 1 [J/K]     
    % Calculations for circular fin efficiency
    m=sqrt(2*h1/(kf*t));
    n=exp(0.13*m*Le-1.3863);
    phi=m*Le*(r)^n;
    if phi>0.6+2.257*(r)^-0.445
        etha0=(r)^-0.246*(m*Le)^-b;  % Individual efficiency of a circular fin       
    else
        etha0=tanh(phi)/phi; 
    end 
    ethaf=(delta_A1b+etha0*delta_A1f)/delta_A1; % Efficiency of the finned surface   
               
    for j=1:Ny
        Cp2(i,j)=1000*(0.81554 + 0.00364*T2(i,j)); % Specific heat of fluid 2 [J/kg*K]
        rho2=1040.3-0.60477*T2(i,j); % Density of fluid 2 [kg/m^3]
        u_max2=(mf2(i)/Nf)/(rho2*pi*ri^2); % Maximum average velocity of fluid 2 [m/s]
        k2=-7.5722e-2 +(2.5952e-3)*T2(i,j)-(1.2033e-5)*(T2(i,j))^2 + (2.653e-8)*(T2(i,j))^3 -(2.8663e-11)*(T2(i,j))^4 + (1.2174e-14)*(T2(i,j))^5; % Thermal conductivity of fluid 2 [W/(m·K)]
        miu2=1000*exp(81.541-0.61584*(T2(i,j))+(1.7943e-3)*(((T2(i,j))^2)-(2.3678e-6)*(((T2(i,j))^3)+(1.1763e-9)*((T2(i,j))^4)))); % Dynamic viscosity of fluid 2 [Pa*s]
        Pr2=Cp2*miu2/k2; % Prandtl number for fluid 2       
        Re2=rho2*u_max2*2*ro/miu2; % Reynolds number for fluid 2
        C2=mf2(1,j)*Cp2(i,j); % Heat capacity of fluid 2 [J/K]
        f=0.00512+0.4572*(Re2^(-0.311)); % Darcy-Weisbach friction factor
        % Calculation of Nusselt number for fluid 2
        if Re2<3000
            Nu=4.36;
        elseif Re2>3000
            num=(f/8)*((Re2)-1000)*Pr2;
            den=1+12.7*sqrt(f/8)*(((Pr2)^(2/3))-1);
            Nu=num/den;  
        end               
        h2(i,j)=Nu*k2/(2*ri); % Convective heat transfer coefficient for fluid 2 [W/m^2*K]      
        U(i,j)=inv((delta_A2/(h1*ethaf*delta_A1))+delta_A2*Rw+(1/h2(i,j))); % Overall heat transfer coefficient [W/m^2*K]       
        T2(i,j+1)=T2(i,j)+U(i,j)*delta_A2*(T1(i)-T2(i,j))/C2; % Outlet temperature of fluid 2 to the next element [K]
        if T2(i,j+1)>613.15 % Maximum temperature for fluid 2 [K]
            break
        end
        
    end 

    % Calculation of outlet temperature of fluid 1 for the next control volume
    suma=0;
    for j=1:Ny
        suma=suma+U(i,j)*(T1(i)-T2(i,j)); 
    end
    T1(i+1)=T1(i)-(delta_A2/C1(i))*suma;  %[K]
   
end  
% Graph T2 vs x for the outlet temperature distribution T2[i,Ny+1]
plot(T2(:,Ny+1)) 
title('Outlet Temperature Distribution')
ylabel('T2[i,Ny+1], [K]')
xlabel('X')   
% Decision whether to perform another iteration
AUX=T1o; % Auxiliary variable to store the last used value of T1o
T1o=T1(Nc+1); % New outlet temperature of fluid 1
E=1; % Defined tolerance for this difference

if abs(T1o-AUX)<E % Condition for acceptable estimation
    break % Exit the loop if tolerance is met
end

end
%T1
%T1o
%T2
% Calculation of outlet temperature T2o with eq 5.11
num=0;
den=0;
for i=1:Nc    
    num=num+mf2(i)*Cp2(i,Ny)*T2(i,Ny+1);
    den=den+mf2(i)*Cp2(i,Ny);      
end
T2o=num/den; % Outlet temperature of fluid 2 [K]
% Calculation of transferred heat Q with eq 5.13 
Q=0;
for i=1:Nc
    Q=Q+C1(1,i)*(T1(i)-T1(i+1));
end
Q % Total transferred heat [W]
