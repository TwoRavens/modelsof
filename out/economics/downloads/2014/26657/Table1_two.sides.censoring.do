mata
mata clear
end
clear
set mem 500m
set more off
set r on
set matsize 5000

scalar N=1000
mat A=J(N,1,0)
svmat A, names(yt)

mata
S=T
T=100
alfams=J(T,1,0)
sigmams=J(T,1,0)
iterationsms=J(T,1,0)
Tob=J(T,2,0)
N=1000
sigma=2
alfa=1
uc=1
lc=-1

r=1
do{ 
u=invnormal(uniform(N,1))*sigma
ystar=alfa:+u
y=((ystar:<=uc)-(lc:<ystar:<uc)):*ystar+(ystar:>uc):*uc+(ystar:<lc):*lc
alfahat=mean(y)
sigmahat=sqrt(variance(y))

YT=J(N,1,0)
st_view(YT,.,"yt")
YT[.]=y

stata("tobit yt,ul ll",1)
stata("mat coeff=e(b)")

v=uniform(N,1)
z=(uc-alfahat)/sigmahat
z1=(lc-alfahat)/sigmahat
ysim=J(N,1,0)
aux= alfahat:+sigmahat*invnormal(normal(z):+(1-normal(z)):*v)
aux1=alfahat:+sigmahat*invnormal(normal(z1):*v)
j=1
do{
if (y[j]<=lc) ysim[j]=aux1[j]
else if (y[j]>=uc) ysim[j]=aux[j]
else ysim[j]=y[j]
j=j+1
} while (j<=N)

maxiter=100
alfavec=J(maxiter,1,0)
sigmavec=J(maxiter,1,0)
alfavec[1]=alfahat
sigmavec[1]=sigmahat

k=2
do{
alfavec[k]=mean(ysim)
sigmavec[k]=sqrt(variance(ysim))
z=(uc-alfavec[k])/sigmavec[k]
z1=(lc-alfavec[k])/sigmavec[k]
aux= alfavec[k]:+sigmavec[k]*invnormal(normal(z):+(1-normal(z)):*v)
aux1= alfavec[k]:+sigmavec[k]*invnormal(normal(z1):*v)
    j=1
    do{ 
    if (y[j]<=lc) ysim[j] = aux1[j]
    else if (y[j]>=uc) ysim[j]=aux[j]  
    else ysim[j]=y[j]
    j=j+1
    }while (j<=N)
k=k+1
}while ((abs(alfavec[k-1]-alfavec[k-2])>=0.001) | (abs(sigmavec[k-1]-sigmavec[k-2])>=0.001)) 

alfams[r]=alfavec[k-1] 
sigmams[r]=sigmavec[k-1]
iterationsms[r]=k-1
Tob[r,.]=st_matrix("coeff")
r=r+1
}while (r<=T)

mean(alfams)
mean(sigmams)
sqrt(variance(alfams))
sqrt(variance(sigmams))
mean(Tob)
sqrt(variance(Tob))
mean(iterationsms)
end
set r off
