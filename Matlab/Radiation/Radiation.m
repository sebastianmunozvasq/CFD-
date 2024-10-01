
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

% Emissivities of the surfaces
e=zeros(1,5);
e(1)=0.45; % Emissivity of surface 1
e(2)=1; % Emissivity of surface 2, not a material surface
e(3)=0.55; % Emissivity of surface 3
e(4)=0.4; % Emissivity of surface 4
e(5)=0.7; % Emissivity of surface 5
e

% Temperatures of the surfaces
T=zeros(1,5);
T(1)=1110+273.15; % Temperature of surface 1 in [K]
T(2)=500+273.15; % Temperature of surface 2 in [K]
T(3)=1085+273.15; % Temperature of surface 3 in [K]
T(4)=1160+273.15; % Temperature of surface 4 in [K]
T(5)=1250+273.15; % Temperature of surface 5 in [K]
T

% Stefan-Boltzmann constant
sigma=5.669e-8; %[W/(m^2 K^4)]

% View factors
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

% Check sum of view factors
sum(F(1,:)) % Sum of elements in the first row, elements F(1,i)
sum(F(2,:)) % Sum of elements in the second row, elements F(2,i)
sum(F(3,:)) % Sum of elements in the third row, elements F(3,i)
sum(F(4,:)) % Sum of elements in the fourth row, elements F(4,i)
sum(F(5,:)) % Sum of elements in the fifth row, elements F(5,i)

% Solving the radiative exchange system
delta=eye(5); % 5x5 identity matrix, Kronecker delta
% Constructing the linear system [C]*{q}={b}
C=zeros(5);
for j=1:5 % Calculate elements C(j,k) of the coefficient matrix C
    for k=1:5
        C(j,k)=(1/e(k))*(delta(j,k)-(1-e(k))*F(j,k));
    end
end
C

b=zeros(5,1);
for j=1:5 % Calculate elements of the column vector {b} on the right side of the system
    suma=0;
    for k=1:5
        suma=suma+F(j,k)*T(k)^4;
    end
    b(j)=sigma*((T(j)^4)-suma);
end
b
q=inv(C)*b; %[W/m^2]


% Question 1: Calculation of heat flows from each surface in [kW]
Q=zeros(5,1);
for j=1:5
    Q(j)=q(j)*A(j)/1000;   
end

for j=1:5
    X = ['Net heat from surface ',num2str(j), ' is ',num2str(Q(j)),' kW'];
    disp(X)
end

disp(['The net heat absorbed by refractory wall 1 is ',num2str(Q(1)),' kW'])
disp(['The net heat absorbed by refractory wall 3 is ',num2str(Q(3)),' kW'])
disp(['The net heat absorbed by refractory wall 4 is ',num2str(Q(4)),' kW'])
disp(['The net heat loss through opening 2 is ',num2str(Q(2)),' kW']) 
% Negative values confirm that heat is moving in the direction of absorption, and since surface 2 is non-material, heat is lost through this opening.
% Energy conservation check:
sum(Q(1:5)) %[kW]
% Value deviates slightly from zero due to rounding errors.

% Question 2: Temperature in resistances
V=380; % Oven voltage [V]
I=2800; % Peak current [A]
P=sqrt(3)*V*I; % Electric power supplied to the resistances [W]
R=V/I; % Net resistance value [ohm]
A_em=A(5); % Emission area of the resistances [m^2]

Qi=[0 0 0 0 P]; % Known heat flows. In this case, 0 represents that the first 4 surfaces are unknowns.
% Constructing the linear system [B]*{x}={d}
B=zeros(4);
for j=1:5 % Calculate elements B(j,k) of the coefficient matrix B
    for k=1:5
        if k<5
            B(j,k)=(1/e(k))*(delta(j,k)-(1-e(k))*F(j,k));
        else
            B(j,k)=F(j,k)-delta(j,k);
        end
    end
end
B

d=zeros(5,1);
for j=1:5 % Calculate elements of the column vector {d} on the right side of the system
    suma1=0;
    suma2=0;
    for k=1:5
        if k<5
            suma1=suma1+(delta(j,k)-F(j,k))*sigma*T(k)^4;
        else
            suma2=suma2+(1/e(k))*(delta(j,k)-(1-e(k))*F(j,k))*Qi(k)/A_em;
        end
    end
    d(j)=suma1-suma2;
end
d

x=inv(B)*d;
q=zeros(4,1);
q(1:4)=x(1:4); % Assigning the first 4 solved unknowns to a heat vector [kW/A]

T5=(x(5)/sigma)^0.25; % New temperature at the fifth surface, where the resistances are located, in [K] 
disp(['The new temperature of the surface with resistances is ', num2str(T5),' K'])

% Net heat flows from the surfaces in [kW]
Q=zeros(5,1);
Q(5,1)=Qi(5)/1000; %[kW]
for j=1:4
    Q(j)=q(j)*A(j)/1000; %[kW]  
end

for j=1:5
    X = ['Net heat from surface ',num2str(j), ' is ',num2str(Q(j)),' kW'];
    disp(X)
end

% Energy conservation check:
sum(Q(1:5))
% Value deviates slightly from zero due to rounding errors.

