clear;
clc;

% Dimensions
Lc=1.5; % Height of surface 1 in [m]
Ds=1; % Diameter of surface 2, inner diameter of surface 4, smaller diameter in [m]
Dc=5; % Diameter of surface 3, outer diameter of surface 4, larger diameter in [m]
Lr=2; % Height of surface 5 in [m]

% Areas of the surfaces
A=zeros(1,5);
A(1)=pi*Dc*Lc; % Area of surface 1 in [m^2]
A(2)=0.25*pi*Ds^2; % Area of surface 2 in [m^2]
A(3)=0.25*pi*Dc^2; % Area of surface 3 in [m^2]
A(4)=0.25*pi*((Dc^2)-(Ds^2)); % Area of surface 4 in [m^2]
A(5)=pi*Dc*Lr; % Area of surface 5 in [m^2]
A

% Mean length of the radiant cavity
A_total=sum(A(1:5)); % Total area of the radiant cavity [m^2]
V_total=0.25*pi*(Dc^2)*(Lc+Lr); % Total volume of the radiant cavity [m^3]
Lm=3.6*V_total/A_total; % Mean length of the radiant cavity [m]

% Emissivities of the surfaces
e=zeros(1,5);
e(1)=0.45; % Emissivity of surface 1
e(2)=1; % Emissivity of surface 2, not a material surface
e(3)=0.55; % Emissivity of surface 3
e(4)=0.4; % Emissivity of surface 4
e(5)=0.38; % Emissivity of surface 5
e

% Temperatures of the surfaces
T=zeros(1,5);
T(1)=500+273.15; % Temperature of surface 1 in [K]
T(2)=300+273.15; % Temperature of surface 2 in [K]
T(3)=480+273.15; % Temperature of surface 3 in [K]
T(4)=380+273.15; % Temperature of surface 4 in [K]
T(5)=520+273.15; % Temperature of surface 5 in [K]
T

% Stefan-Boltzmann constant
sigma=5.669e-8; %[W/(m^2 K^4)]

% Form factors
F=zeros(5,5);
F(1,1)=0.255969;
F(1,2)=8.969838e-3;
F(1,3)=0.372017;
F(1,4)=0.147105;
F(1,5)=0.215939;
F(2,1)=0.269094;
F(2,2)=0;
F(2,3)=0.334828;
F(2,4)=0;
F(2,5)=0.396078;
F(3,1)=0.446418;
F(3,2)=0.0133931;
F(3,3)=0;
F(3,4)=0.257689;
F(3,5)=0.2822500;
F(4,1)=0.183880;
F(4,2)=0;
F(4,3)=0.268426;
F(4,4)=0;
F(4,5)=0.547689;
F(5,1)=0.161954;
F(5,2)=9.901982e-3;
F(5,3)=0.176563;
F(5,4)=0.328614;
F(5,5)=0.322967;
F

% Checking the sum of form factors
sum(F(1,:)) % Sum of elements of the first row, elements F(1,i)
sum(F(2,:)) % Sum of elements of the second row, elements F(2,i)
sum(F(3,:)) % Sum of elements of the third row, elements F(3,i)
sum(F(4,:)) % Sum of elements of the fourth row, elements F(4,i)
sum(F(5,:)) % Sum of elements of the fifth row, elements F(5,i)

% Reference properties
T_0=1000; % Reference temperature [K]
Tm=700+273.15; % Mean temperature of combustion gases [K]
t=Tm/T_0;
PaL_0=1; %[bar*cm]
P_0=1; % Atmospheric pressure in bar
P=1; % bar

% Calculation of Ts
num=0;
for j=1:5
    num=num+A(j)*T(j);
end
Ts=num/sum(A(1:5)); % Weighted temperature of the surface
FT=Ts/Tm; % Temperature factor

% Properties of H2O and correlation constants
y_H2O=0.16; % Molar fraction of H2O
P_H2O=y_H2O*P_0; % Partial pressure of H2O [bar]
PaL=P_H2O*Lm*100; %[bar*cm]
M=2;
N=2;
c_array=[-2.2118 -1.1987 0.035596; 0.85667 0.93048 -0.14391; -0.10838 -0.17156 0.045915];
Pe=(P+2.56*P_H2O/sqrt(t))/P_0;
PaL_m=(13.2*(t^2))*PaL_0;

if t<0.75
    a=2.144;
else
    a=1.888-2.053*log10(t);
end
b=1.10/(t^1.4);
c=0.5;


% The Leckner functions are located at the end of the code
% For emissivity
eps_div_eps_0 = leckner1(a, b, c, PaL, PaL_m, Pe, Tm, T_0); 
eps_0 = leckner2(c_array, PaL, PaL_0, Tm, T_0, M, N);
emi_H2O=eps_div_eps_0*eps_0; % Emissivity of H2O

% For absorptivity
eps_div_eps_0 = leckner1(a, b, c, PaL*FT, PaL_m, Pe, Ts, T_0);
eps_0 = leckner2(c_array, PaL*FT, PaL_0, Ts, T_0, M, N);
abs_H2O=((1/FT)^0.5)*eps_div_eps_0*eps_0; % Absorptivity of H2O

% Properties of CO2 and correlation constants
y_CO2=0.086; % Molar fraction of CO2
P_CO2=y_CO2*P_0; % Partial pressure of CO2 [bar]
PaL=P_CO2*Lm*100; %[bar*cm]
M=2;
N=3;
c_array=[-3.9893 2.7669 -2.1081 0.39163; 1.2710 -1.1090 1.0195 -0.21897; -0.23678 0.19731 -0.19544 0.044644];
Pe=(P+0.28*P_CO2)/P_0;

if t<0.7
    PaL_m=(0.054/(t^2))*PaL_0;
else
    PaL_m=(0.225*(t^2))*PaL_0;
end

a=1+0.1/(t^1.45);
b=0.23;
c=1.47;

% For emissivity
eps_div_eps_0 = leckner1(a, b, c, PaL, PaL_m, Pe, Tm, T_0);
eps_0 = leckner2(c_array, PaL, PaL_0, Tm, T_0, M, N);
emi_CO2=eps_0*eps_div_eps_0; % Emissivity of CO2

% For absorptivity
eps_div_eps_0 = leckner1(a, b, c, PaL*FT, PaL_m, Pe, Ts, T_0);
eps_0 = leckner2(c_array, PaL*FT, PaL_0, Ts, T_0, M, N);
abs_CO2=((1/FT)^0.5)*eps_div_eps_0*eps_0; % Absorptivity of CO2

% Calculation of mean emissivity of the gas
fp=P_H2O/(P_H2O+P_CO2); % Correction factor
L=Lm*100; % Mean length of the radiant cavity [cm]
delta_eps=((fp/(10.7+101*fp))-0.0089*(fp^10.4))*(log10((P_H2O+P_CO2)*L/PaL_0))^2.76;
emi_gas=emi_CO2+emi_H2O-delta_eps; % Emissivity of the gas

% Calculation of mean absorptivity of the gas
L=Lm*FT*100; % Length corrected by the temperature factor [cm]
delta_eps=((fp/(10.7+101*fp))-0.0089*(fp^10.4))*(log10((P_H2O+P_CO2)*L/PaL_0))^2.76;
abs_gas=((1/FT)^0.5)*(abs_CO2+abs_H2O-delta_eps); % Absorptivity of the gas

% Calculation of mean transmissivity of the gas
trans_gas=1-abs_gas; % Transmissivity of the gas

% Solution of the radiative exchange system
delta=eye(5); % 5x5 identity matrix, Kronecker delta
% Construction of the linear system [P]*{q}={f}
P=zeros(5);
for j=1:5 % Calculation of the elements P(j,k) of the coefficient matrix P
    for k=1:5
        P(j,k)=(1/e(k))*(delta(j,k)-(1-e(k))*trans_gas*F(j,k));
    end
end
P

f=zeros(5,1);
for j=1:5 % Calculation of the elements of the column vector {f} on the right side of the system
    suma=0;
    for k=1:5
        suma=suma+F(j,k)*sigma*T(k)^4;
    end
    f(j)=sigma*(T(j)^4)-trans_gas*suma-emi_gas*sigma*(Tm^4);
end
f

q=inv(P)*f; %[W/m^2]

% Net heat transferred by the gas under these conditions
Q=zeros(5,1);
for j=1:5
    Q(j)=q(j)*A(j)/1000; % Heat transferred by the gas to each surface   
end
sum(Q(1:5)); % Total net heat from the gas to the surfaces

for j=1:5
    X = ['Net heat from the gas to surface ', num2str(j), ' is ', num2str(Q(j)), ' kW'];
    disp(X)
end

% Negative values, under the reference used, confirm that the surfaces receive heat from the gas.
disp(['The total net heat transferred by the gas to the surfaces is ', num2str(sum(Q(1:5))), ' kW']);
% Heat loss by radiation through the opening
disp(['The heat loss by radiation through the opening is ', num2str(Q(2)), ' kW']);
% The negative value, under the reference used, confirms that surface 2 receives heat from the gas, and since this surface is non-material, the heat is lost through this opening.

% Leckner Functions
function eps_div_eps_0 = leckner1(a, b, c, PaL, PaL_m, Pe, Tg, T_0)
    eps_div_eps_0 = 1-((a-1)*(1-Pe)/(a+b-1+Pe))*exp(-c*(log10(PaL_m/PaL))^2); 
end

function eps_0 = leckner2(c_array, PaL, PaL_0, Tg, T_0, M, N)
    suma=0;
    for i=1:(M+1)
        for j=1:(N+1)
            suma=suma+c_array(i,j)*((Tg/T_0)^(j-1))*(log10((PaL)/PaL_0))^(i-1);   
        end
    end
    eps_0=exp(suma);    
end
