function[x]=cholesky(A,b)
%Factorización    
    [nf,nc]=size(A);
    L=zeros(nf);
    L_trans=zeros(nf);
    L(1,1)=sqrt(A(1,1));
    L_trans(1,1)=L(1,1);
    for i=2:nf
        L(i,1)=A(i,1)/L(1,1);
        L_trans(1,i)=A(1,i)/L(1,1);
    end
    for i=2:nf
        for j=1:nf
            if i==j
                L(i,i)=sqrt(A(i,i)-L(i,1:i-1)*L_trans(1:i-1,i));
                L_trans(i,i)=L(i,i);
            else
                L(j,i)=(A(j,i)-L(j,1:i-1)*L_trans(1:i-1,i))/L(i,i);
            end
        end
        for k=i+1:nf
            L_trans(i,k)=(A(i,k)-L(i,1:i-1)*L_trans(1:i-1,k))/L(i,i);
        end
    end

%Sustitución hacia adelante
y=zeros(nf,1);
y(1)=b(1)/L(1,1);
for i=2:nf
    y(i)=(b(i)-L(i,1:i-1)*y(1:i-1))/L(i,i);
end
y;
%Sustitución hacia atrás
x=zeros(nf,1);
x(nf)=y(nf)/L_trans(nf,nf);
for i=nf-1:-1:1
    x(i)=(y(i)-L_trans(i,i+1:nf)*x(i+1:nf))/L_trans(i,i);
end
x;
end