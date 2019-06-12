mata
mata clear
end
clear
set mem 500m
set more off
scalar N=1000
scalar T=10
scalar S=100
scalar NT=N*T
scalar uc=4

mata

S=100
alfams=J(S,1,0)
alfavarms=J(S,1,0)
gammams=J(S,1,0)
sigmams=J(S,1,0)
N=1000
T=20
NT=N*T
sigma=2
gamma=0.02
a=0
b=2
alfas=a:+(b-a)*uniform(N,1)
AA=J(N,T,0)
t=1
do{
AA[,t]=alfas
t=t+1
}while (t<=T)
alfa=colshape(AA,1)
mata drop AA alfas a b

c=18
d=61
edad=c:+trunc((d-c+1)*uniform(N,1))
ones=J(N,1,1)
x=J(N,T,0)
t=1
do{
x[,t]=edad+t*ones
t=t+1
}while (t<=T)
age=colshape(x,1)
mata drop x edad c d

uc=4

t=1
F=J(N,T,0)
do{
F[.,t]=ones+(t-1)*ones
t=t+1
}while (t<=T)
time=colshape(F,1)
mata drop F

F=J(N,T,0)
t=1
do{
i=1
do{
F[i,t]=i
i=i+1
} while (i<=N)
t=t+1
} while (t<=T)
individuals=colshape(F,1)
mata drop i F

st_addobs(NT)
(void) st_addvar("double","individuals")
(void) st_addvar("double", "time")
(void) st_addvar("double", "alfa")
(void) st_addvar("double", "age")
st_store(.,"individuals",individuals)
st_store(.,"time",time)
st_store(.,"alfa",alfa)
st_store(.,"age",age)
stata("xtset individuals time")

r=1
do{
u=invnormal(uniform(NT,1))*sigma
ystar=alfa+age*gamma+u
y=(ystar:<=uc):*ystar+(ystar:>uc):*uc
(void) st_addvar("double", "u")
(void) st_addvar("double", "ystar")
(void) st_addvar("double", "y")
st_store(.,"u",u)
st_store(.,"ystar",ystar)
st_store(.,"y",y)
stata("xtreg y age, fe vce(robust)")
stata("mat coeff2=e(b)")
stata("scalar gammahat1=coeff2[1,1]")
stata("bysort individuals: gen gammahat=gammahat1")
stata("gen sigmahat=e(sigma_e)")
stata("bysort individuals: egen meany=mean(y)")
stata("bysort individuals: egen meanage=mean(age)")
stata("bysort individuals: gen alfahat=meany-gammahat*meanage")
v=uniform(NT,1)
stata("gen z=(uc-alfahat-gammahat*age)/sigmahat")
st_view(z=.,.,"z")
st_view(alfahat=.,.,"alfahat")
st_view(sigmahat1=.,.,"sigmahat")
sigmahat=sigmahat1[1]
st_view(gammahat1=.,.,"gammahat")
gammahat=gammahat1[1]
st_view(y=.,.,"y")
st_view(age=.,.,"age")
ysim=J(NT,1,0)
aux= alfahat+gammahat*age+sigmahat*invnormal(normal(z)+(1:-normal(z)):*v)

j=1
do{
if (y[j]<uc) ysim[j]=y[j]
else ysim[j]=aux[j]
j=j+1
} while (j<=NT)

maxiter=100
alfavec=J(maxiter,1,0)
alfavar=J(maxiter,1,0)
sigmavec=J(maxiter,1,0)
gammavec=J(maxiter,1,0)
alfavec[1]=mean(alfahat)
alfavar[1]=variance(alfahat)
sigmavec[1]=sigmahat
gammavec[1]=gammahat
stata("drop gammahat sigmahat meany meanage alfahat z")

k=2
do{
(void) st_addvar("double", "ysim")
st_store(.,"ysim",ysim)
stata("qui xtreg ysim age, fe vce(robust)")
stata("mat coeffs=e(b)")
stata("scalar gammahat1=coeffs[1,1]")
stata("bysort individuals: gen gammahat=gammahat1")
stata("gen sigmahat=e(sigma_e)")
stata("bysort individuals: egen meanysim=mean(ysim)")
stata("bysort individuals: egen meanage=mean(age)")
stata("bysort individuals: gen alfahat=meanysim-gammahat*meanage")
stata("gen z=(uc-alfahat-gammahat*age)/sigmahat")
st_view(z=.,.,"z")
st_view(alfahat=.,.,"alfahat")
alfavec[k]=mean(alfahat)
alfavar[k]=variance(alfahat)
st_view(sigmahat1=.,.,"sigmahat")
sigmavec[k]=sigmahat1[1]
st_view(gammahat1=.,.,"gammahat")
gammavec[k]=gammahat1[1]
aux= alfahat+gammavec[k]*age+sigmavec[k]*invnormal(normal(z)+(1:-normal(z)):*v)
    j=1
    do{ 
    if (y[j]<uc) ysim[j] = y[j]
    else ysim[j] = aux[j]
    j=j+1
    }while (j<=NT)
k=k+1
stata("drop ysim gammahat sigmahat alfahat meanysim meanage z")
}while ((abs(sigmavec[k-1]-sigmavec[k-2])>=0.001)& (abs(gammavec[k-1]-gammavec[k-2])>=0.001))
alfams[r]=alfavec[k-1]
alfavarms[r]=alfavar[k-1]
gammams[r]=gammavec[k-1] 
sigmams[r]=sigmavec[k-1]
r=r+1
stata("drop u ystar y")
}while (r<=S)

mean(alfams)
mean(alfavarms)
mean(gammams)
mean(sigmams)
sqrt(variance(alfams))
sqrt(variance(alfavarms))
sqrt(variance(gammams))
sqrt(variance(sigmams))

end


