function[x]=grad_conjugado(A,b)
x=rand(size(b))  ;       %cualquier vector en Rn para empezar a iterar
tol=10^-4;          %tolerancia
i=0; %contador de iteraciones 
r=b-A*x;
p=r; %primera dirección de bajada
while abs(r)>tol      
    alpha=r'*p/(p'*A*p);
    x=x+alpha*p;
    r=b-A*x;
    beta=-p'*A*r/(p'*A*p);
    p=r+beta*p;
    alpha=r'*p/(p'*A*p);
    x=x+alpha*p;
    r=b-A*x;
    beta=-(p'*A*r)/(p'*A*p);
    i=i+1;
end
end