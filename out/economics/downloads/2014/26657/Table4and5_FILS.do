mata
mata clear
end
clear
set mem 500m
set more on
scalar N=5000
scalar T=10
scalar S=100
scalar nfirm=10
scalar NT=N*T
scalar uc=4
scalar tau=0.1
mata
S=100
alfams=J(S,1,0)
alfavarms=J(S,1,0)
betams=J(S,1,0)
correlationms=J(S,1,0)
gammams=J(S,1,0)
sigmams=J(S,1,0)
N=5000
T=10
nfirm=10
NT=N*T
sigma=2
tau=0.1
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
mata drop AA 

betas11=a:+(b-a)*uniform(nfirm,1)
betas1=sort(betas11,-1)
betas=J(N,T,0)

t=1
do{
assignoise=invnormal(uniform(N,1))*tau
assigvar=alfas+assignoise
minassigvar=min(assigvar)
maxassigvar=max(assigvar)
step=(maxassigvar-minassigvar)/nfirm
i=1
do{ 
j=1
do{
if ((assigvar[i]>=minassigvar) & (assigvar[i]<=minassigvar+step))  betas[i,t]=betas1[nfirm]
else if ((assigvar[i]>=minassigvar+(j*step)) & (assigvar[i]<=minassigvar+((j+1)*step)))  betas[i,t]=betas1[nfirm-j]
else if ((assigvar[i]>=minassigvar+((nfirm-1)*step)) & (assigvar[i]<=maxassigvar))  betas[i,t]=betas1[1]
j=j+1
}while (j<=nfirm-2)
i=i+1
}while (i<=N)
t=t+1
}while (t<=T)
beta=colshape(betas,1)

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

K=J(nfirm,1,0)
i=1
do{
K[i]=i
i=i+1
} while (i<=nfirm)

firms=J(NT,1,0)
i=1
do{ 
j=1
do{
if (beta[i]==betas1[j]) firms[i]=K[j]
j=j+1
}while (j<=nfirm)
i=i+1
}while (i<=NT)


st_addobs(NT)
(void) st_addvar("double","individuals")
(void) st_addvar("double", "time")
(void) st_addvar("double","firms")
(void) st_addvar("double", "alfa")
(void) st_addvar("double", "beta")
(void) st_addvar("double", "age")
st_store(.,"individuals",individuals)
st_store(.,"time",time)
st_store(.,"firms",firms)
st_store(.,"alfa",alfa)
st_store(.,"beta",beta)
st_store(.,"age",age)
end

bysort individuals: gen change=1 if firms[_n]~=firms[_n-1]
bysort individuals: replace change=0 if change==.
bysort individuals: egen totalchange=sum(change)
gen percentagechange=(totalchange-1)/T

local i=1
while `i'<=(nfirm-1){
gen firm`i'= firms==`i'
gen firmdum`i'=firm`i'+uniform()*0.0001
drop firm`i'
local i=`i'+1
}
xtset individuals time

mata
r=1
do{
u=invnormal(uniform(NT,1))*sigma
ystar=alfa+beta+age*gamma+u
y=(ystar:<=uc):*ystar+(ystar:>uc):*uc
(void) st_addvar("double", "u")
(void) st_addvar("double", "ystar")
(void) st_addvar("double", "y")
st_store(.,"u",u)
st_store(.,"ystar",ystar)
st_store(.,"y",y)
stata("xtreg y age firmdum*, fe vce(robust)")
stata("mat coeff2=e(b)")
stata("scalar gammahat1=coeff2[1,1]")
stata("mat betahat=coeff2[1,2..nfirm]")
stata("bysort individuals: gen gammahat=gammahat1")
stata("gen sigmahat=e(sigma_e)")
betahat1=st_matrix("betahat")
betahats=J(NT,1,0)
i=1
do{
if (firms[i]==nfirm) betahats[i]=0
else betahats[i]=betahat1[firms[i]]
i=i+1
}while (i<=NT) 
(void) st_addvar("double", "betahats")
st_store(.,"betahats",betahats)
stata("bysort individuals: egen meany=mean(y)")
stata("bysort individuals: egen meanage=mean(age)")
stata("bysort individuals: gen alfahat=meany-gammahat*meanage-betahats")
v=uniform(NT,1)
stata("gen z=(uc-alfahat-betahats-gammahat*age)/sigmahat")
st_view(z=.,.,"z")
st_view(alfahat=.,.,"alfahat")
st_view(sigmahat1=.,.,"sigmahat")
sigmahat=sigmahat1[1]
st_view(gammahat1=.,.,"gammahat")
gammahat=gammahat1[1]
st_view(y=.,.,"y")
st_view(age=.,.,"age")
ysim=J(NT,1,0)
aux= alfahat+betahats+gammahat*age+sigmahat*invnormal(normal(z)+(1:-normal(z)):*v)

j=1
do{
if (y[j]<uc) ysim[j]=y[j]
else ysim[j]=aux[j]
j=j+1
} while (j<=NT)

maxiter=100
alfavec=J(maxiter,1,0)
alfavar=J(maxiter,1,0)
betavec=J(maxiter,nfirm-1,0)
correlation=J(maxiter,1,0)
sigmavec=J(maxiter,1,0)
gammavec=J(maxiter,1,0)
alfavec[1]=mean(alfahat)
alfavar[1]=variance(alfahat)
betavec[1,.]=betahat1
stata("qui correlate alfahat betahats")
stata("scalar correlacion1=r(rho)")
stata("gen correlacion=correlacion1")
st_view(correlacion=.,.,"correlacion")
correlation[1]=correlacion[1]
sigmavec[1]=sigmahat
gammavec[1]=gammahat
stata("drop gammahat sigmahat alfahat betahats meany meanage correlacion z")

k=2
do{
(void) st_addvar("double", "ysim")
st_store(.,"ysim",ysim)
stata("xtreg ysim age firmdum*, fe vce(robust)")
stata("mat coeffs=e(b)")
stata("scalar gammahat1=coeffs[1,1]")
stata("bysort individuals: gen gammahat=gammahat1")
stata("gen sigmahat=e(sigma_e)")
stata("mat betahat=coeffs[1,2..nfirm]")
betahat1=st_matrix("betahat")
betahat=J(NT,1,0)
i=1
do{
if (firms[i]==nfirm) betahat[i]=0
else betahat[i]=betahat1[firms[i]]
i=i+1
}while (i<=NT) 
(void) st_addvar("double", "betahat")
st_store(.,"betahat",betahat)
stata("bysort individuals: egen meanysim=mean(ysim)")
stata("bysort individuals: egen meanage=mean(age)")
stata("bysort individuals: gen alfahat=meanysim-gammahat*meanage-betahat")
stata("gen z=(uc-alfahat-betahat-gammahat*age)/sigmahat")
st_view(z=.,.,"z")
st_view(alfahat=.,.,"alfahat")
alfavec[k]=mean(alfahat)
alfavar[k]=variance(alfahat)
betavec[k,.]=betahat1
stata("qui correlate alfahat betahat")
stata("scalar correlacion1=r(rho)")
stata("gen correlacion=correlacion1")
st_view(correlacion=.,.,"correlacion")
correlation[k]=correlacion[1]
st_view(sigmahat1=.,.,"sigmahat")
sigmavec[k]=sigmahat1[1]
st_view(gammahat1=.,.,"gammahat")
gammavec[k]=gammahat1[1]
aux= alfahat+betahat+gammavec[k]*age+sigmavec[k]*invnormal(normal(z)+(1:-normal(z)):*v)
    j=1
    do{ 
    if (y[j]<uc) ysim[j] = y[j]
    else ysim[j] = aux[j]
    j=j+1
    }while (j<=NT)
k=k+1
stata("drop ysim gammahat sigmahat betahat meanysim meanage alfahat correlacion z")
}while ((abs(sigmavec[k-1]-sigmavec[k-2])>=0.001) | (abs(gammavec[k-1]-gammavec[k-2])>=0.001) | (abs(alfavec[k-1]-alfavec[k-2])>=0.001) | (max(abs(betavec[k-1,.]-betavec[k-2,.]))>=0.001))

alfams[r]=alfavec[k-1]
alfavarms[r]=alfavar[k-1]
betams[r]=sum(betavec[k-1,.])/(nfirm-1)
correlationms[r]=correlation[k-1]
gammams[r]=gammavec[k-1] 
sigmams[r]=sigmavec[k-1]
r=r+1
stata("drop u ystar y")
}while (r<=S)

mean(alfams)
mean(alfavarms)
mean(betams)
mean(correlationms)
mean(gammams)
mean(sigmams)
sqrt(variance(alfams))
sqrt(variance(alfavarms))
sqrt(variance(betams))
sqrt(variance(correlationms))
sqrt(variance(gammams))
sqrt(variance(sigmams))
stata("mean(percentagechange)")

end


