mata
mata clear
end
clear
set mem 500m
set more off
set matsize 5000
scalar N=1000
scalar T=10
scalar S=100
scalar NT=N*T
scalar uc=4

mata
S=100
alfams=J(S,1,0)
alfavarms=J(S,1,0)
Tobms=J(S,2,0)
N=1000
T=10
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

end

local i=1
while `i'<=1000{
gen ind`i'= individuals==`i'
local i=`i'+1
}
xtset individuals time

mata
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
stata("tobit y ind1-ind1000 age,ul nocons")
stata("mat coeff=e(b)")
Tob=st_matrix("coeff")
alfaTob1=J(cols(Tob)-2,T,0)
t=1
do{
i=1
do{
alfaTob1[i,t]=Tob[i]
i=i+1
} while (i<=cols(Tob)-2)
t=t+1
} while (t<=T)
alfaTob=colshape(alfaTob1,1)
gammaTob=Tob[cols(Tob)-1]
sigmaTob=Tob[cols(Tob)]


alfams[r]=mean(alfaTob)
alfavarms[r]=variance(alfaTob)
Tobms[r,1]=gammaTob
Tobms[r,2]=sigmaTob
r=r+1
stata("drop u ystar y")
}while (r<=S)

mean(alfams)
mean(alfavarms)
mean(Tobms)
sqrt(variance(alfams))
sqrt(variance(alfavarms))
sqrt(variance(Tobms))
end


