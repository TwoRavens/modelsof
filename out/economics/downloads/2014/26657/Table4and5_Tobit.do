mata
mata clear
end
clear
set mem 500m
set more off
set matsize 5000
scalar N=1000
scalar T=20
scalar S=100
scalar nfirm=20
scalar NT=N*T
scalar uc=4
scalar tau=0.1

mata
S=100
alfams=J(S,1,0)
alfavarms=J(S,1,0)
betams=J(S,1,0)
betavarms=J(S,1,0)
correlationms=J(S,1,0)
Tobms=J(S,2,0)
N=1000
T=20
nfirm=20
NT=N*T
sigma=2
gamma=0.02
tau=0.1
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
if ((assigvar[i]>=minassigvar) & (assigvar[i]<=minassigvar+step))  betas[i,t]=betas1[20]
else if ((assigvar[i]>=minassigvar+step) & (assigvar[i]<=minassigvar+2*step))  betas[i,t]=betas1[19]
else if ((assigvar[i]>=minassigvar+2*step) & (assigvar[i]<=minassigvar+3*step))  betas[i,t]=betas1[18]
else if ((assigvar[i]>=minassigvar+3*step) & (assigvar[i]<=minassigvar+4*step))  betas[i,t]=betas1[17]
else if ((assigvar[i]>=minassigvar+4*step) & (assigvar[i]<=minassigvar+5*step))  betas[i,t]=betas1[16]
else if ((assigvar[i]>=minassigvar+5*step) & (assigvar[i]<=minassigvar+6*step))  betas[i,t]=betas1[15]
else if ((assigvar[i]>=minassigvar+6*step) & (assigvar[i]<=minassigvar+7*step))  betas[i,t]=betas1[14]
else if ((assigvar[i]>=minassigvar+7*step) & (assigvar[i]<=minassigvar+8*step))  betas[i,t]=betas1[13]
else if ((assigvar[i]>=minassigvar+8*step) & (assigvar[i]<=minassigvar+9*step))  betas[i,t]=betas1[12]
else if ((assigvar[i]>=minassigvar+9*step) & (assigvar[i]<=minassigvar+10*step))  betas[i,t]=betas1[11]
else if ((assigvar[i]>=minassigvar+10*step) & (assigvar[i]<=minassigvar+11*step))  betas[i,t]=betas1[10]
else if ((assigvar[i]>=minassigvar+11*step) & (assigvar[i]<=minassigvar+12*step))  betas[i,t]=betas1[9]
else if ((assigvar[i]>=minassigvar+12*step) & (assigvar[i]<=minassigvar+13*step))  betas[i,t]=betas1[8]
else if ((assigvar[i]>=minassigvar+13*step) & (assigvar[i]<=minassigvar+14*step))  betas[i,t]=betas1[7]
else if ((assigvar[i]>=minassigvar+14*step) & (assigvar[i]<=minassigvar+15*step))  betas[i,t]=betas1[6]
else if ((assigvar[i]>=minassigvar+15*step) & (assigvar[i]<=minassigvar+16*step))  betas[i,t]=betas1[5]
else if ((assigvar[i]>=minassigvar+16*step) & (assigvar[i]<=minassigvar+17*step))  betas[i,t]=betas1[4]
else if ((assigvar[i]>=minassigvar+17*step) & (assigvar[i]<=minassigvar+18*step))  betas[i,t]=betas1[3]
else if ((assigvar[i]>=minassigvar+18*step) & (assigvar[i]<=minassigvar+19*step))  betas[i,t]=betas1[2]
else if ((assigvar[i]>=minassigvar+19*step) & (assigvar[i]<=maxassigvar))  betas[i,t]=betas1[1]
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
if (beta[i]==betas1[1]) firms[i]=K[1]
else if (beta[i]==betas1[2]) firms[i]=K[2]
else if (beta[i]==betas1[3]) firms[i]=K[3]
else if (beta[i]==betas1[4]) firms[i]=K[4]
else if (beta[i]==betas1[5]) firms[i]=K[5]
else if (beta[i]==betas1[6]) firms[i]=K[6]
else if (beta[i]==betas1[7]) firms[i]=K[7]
else if (beta[i]==betas1[8]) firms[i]=K[8]
else if (beta[i]==betas1[9]) firms[i]=K[9]
else if (beta[i]==betas1[10]) firms[i]=K[10]
else if (beta[i]==betas1[11]) firms[i]=K[11]
else if (beta[i]==betas1[12]) firms[i]=K[12]
else if (beta[i]==betas1[13]) firms[i]=K[13]
else if (beta[i]==betas1[14]) firms[i]=K[14]
else if (beta[i]==betas1[15]) firms[i]=K[15]
else if (beta[i]==betas1[16]) firms[i]=K[16]
else if (beta[i]==betas1[17]) firms[i]=K[17]
else if (beta[i]==betas1[18]) firms[i]=K[18]
else if (beta[i]==betas1[19]) firms[i]=K[19]
else if (beta[i]==betas1[20]) firms[i]=K[20]
i=i+1
}while (i<=NT)

st_addobs(NT)
(void) st_addvar("double","individuals")
(void) st_addvar("double", "time")
(void) st_addvar("double","firms")
(void) st_addvar("double", "alfa")
(void) st_addvar("double", "age")
st_store(.,"individuals",individuals)
st_store(.,"time",time)
st_store(.,"firms",firms)
st_store(.,"alfa",alfa)
st_store(.,"age",age)

end

local i=1
while `i'<=1000{
gen ind`i'= individuals==`i'
local i=`i'+1
}
local i=1
while `i'<=nfirm{
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
stata("qui tobit y ind1-ind1000 firmdum1-firmdum19 age,ul nocons")
stata("mat coeff=e(b)")
Tob=st_matrix("coeff")
alfaTob1=J(cols(Tob)-nfirm-1,T,0)
t=1
do{
i=1
do{
alfaTob1[i,t]=Tob[i]
i=i+1
} while (i<=N)
t=t+1
} while (t<=T)
alfaTob=colshape(alfaTob1,1)
stata("mat betaT=coeff[1,1001..1019]")
betaTob1=st_matrix("betaT")
betaTob=J(NT,1,0)
i=1
do{
if (firms[i]==20) betaTob[i]=0
else betaTob[i]=betaTob1[firms[i]]
i=i+1
}while (i<=NT) 
gammaTob=Tob[cols(Tob)-1]
sigmaTob=Tob[cols(Tob)]


alfams[r]=mean(alfaTob)
alfavarms[r]=variance(alfaTob)
betams[r]=mean(betaTob)
betavarms[r]=variance(betaTob)
(void) st_addvar("double", "alfaTob")
(void) st_addvar("double", "betaTob")
st_store(.,"alfaTob",alfaTob)
st_store(.,"betaTob",betaTob)
stata("qui correlate alfaTob betaTob")
stata("scalar correlacion1=r(rho)")
stata("gen correlacion=correlacion1")
st_view(correlacion=.,.,"correlacion")
correlationms[r]=correlacion[1]
Tobms[r,1]=gammaTob
Tobms[r,2]=sigmaTob
r=r+1
stata("drop u ystar y alfaTob betaTob correlacion")
}while (r<=S)

mean(alfams)
mean(alfavarms)
mean(betams)
mean(betavarms)
mean(correlationms)
mean(Tobms)
sqrt(variance(alfams))
sqrt(variance(alfavarms))
sqrt(variance(betams))
sqrt(variance(betavarms))
sqrt(variance(correlationms))
sqrt(variance(Tobms))
end


