mata
mata clear
end
clear
set mem 500m
set more off
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
r=1
do{ 

N=1000
sigma=2
alfa=1
c=1
u=invnormal(uniform(N,1))*sigma
ystar=alfa:+u

y=(ystar:<=c):*ystar+(ystar:>c):*c
alfahat=mean(y)
sigmahat=sqrt(variance(y))

YT=J(N,1,0)
st_view(YT,.,"yt")
YT[.]=y

stata("tobit yt,ul",1)
stata("mat coeff=e(b)")

v=uniform(N,1)
z=(c-alfahat)/sigmahat
ysim=J(N,1,0)
aux= alfahat:+sigmahat*invnormal(normal(z):+(1-normal(z)):*v)

j=1
do{
if (y[j]<c) ysim[j]=y[j]
else ysim[j]=aux[j]
j=j+1
} while (j<=N)

maxiter=100
alfavec=J(maxiter,1,0)
sigmavec=J(maxiter,1,0)
alfavec[1]=alfahat
sigmavec[1]=sigmahat


k=2
endloop=0

do{

alfavec[k]=mean(ysim)
sigmavec[k]=sqrt(variance(ysim))

z=(c-alfavec[k])/sigmavec[k]

    j=1
    do{ 
    aux= alfavec[k]:+sigmavec[k]*invnormal(normal(z):+(1-normal(z)):*v)
    if (y[j]<c) ysim[j] = y[j]
    else ysim[j] = aux[j]
    j=j+1
    }while (j<=N)

k=k+1
}while ((abs(alfavec[k-1]-alfavec[k-2])>=0.001) & (abs(sigmavec[k-1]-sigmavec[k-2])>=0.001))

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
drop yt1

mata
st_addobs(T)
(void) st_addvar("double","alfams")
(void) st_addvar("double","sigmams")
st_store(.,"alfams",alfams)
st_store(.,"sigmams",sigmams)

kdensity alfams, addplot(kdensity sigmams)

end
