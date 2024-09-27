function [Q,R]=QR_hessenberg(A)
A=[-65 5*3^0.5 0; 5*3^0.5 -75 0; 0 0 -52.7];
n=size(A,1);
[H]=hessehouse(A); %La función hessehouse entrega matriz de Hessenberg
Q=eye(n); %Se asigna la identidad a Q para comenzar a iterar
R=H;
niter=100;%Cantidad de iteraciones arbitrarias
cont=0;
eigvect=eye(n);%Se asigna espacio para los eigenvectors
while cont<=niter
    eigvect=eigvect*Q';%Productoria de Qi traspuesta
    Q=eye(n);
for j=1:n-1
    alpha=(R(j,j)^2+R(j+1,j)^2)^0.5;
    c=-R(j,j)/alpha;     %coseno para la matriz de Givens
    s=-R(j+1,j)/alpha;   %seno para la matriz de Givens
    G=givens(j,c,s,n);   %esta función nos entrega la matriz de Givens
    R=G*R; %Se calcula R
    Q=Q*G';%Se calcula Q     
end
R=R*Q; %Para volver a iterar se hace R=R*Q la cual converge a una
%matriz diagonal que contiene los valores propios
cont=cont+1;
end
eigval=diag(R)%Se crea vector de valores propios
eigvect %Se imprime matriz de vectores propios
%------Matriz de Givens-------
function [Y]=givens(j,c,s,n) 
k=j+1; 
Y=eye(n);
Y(j,j)=c;
Y(k,k)=c;
Y(j,k)=s;
Y(k,j)=-s;
Y;
end
function [H]=hessehouse(A)  %Esta función aplica reflexiones de Householder para llegar a matriz de Hessenberg

[~,n] = size(A);

Q=eye(n);

for k = 1:n-2

  x=A(k+1:n,k);
  ek = zeros(size(x,1),1);
  ek(1)=1;

  u = (x+sign(x(1))*norm(x)*ek)/(norm(x+sign(x(1))*norm(x)*ek));

  I=eye(size(x,1));   
  P=I-2*(u)*(u');
  Q_1=blkdiag(eye(k),P);
  Q=Q_1*Q;
  A=(Q_1')*A*(Q_1);

end
  H=A;

end 
save QRhessenbergvariables
end
