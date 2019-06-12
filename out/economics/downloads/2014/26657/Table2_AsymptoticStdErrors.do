clear
mata
mata clear
end
set mem 500m
scalar N=100000
scalar c=0
scalar S=1000
scalar h=0.0001
range alfavec 0.02 2 100
range sigmavec 1.02 3 100
range vectorc c c 100
gen Avec=(vectorc-alfavec)/sigmavec
gen lambdavec=normalden(Avec)/(1-normal(Avec))
dydx lambdavec Avec, gen(lambda1vec)
keep if alfavec==1 & sigmavec==2
sum Avec
scalar A=r(mean)
sum lambdavec
scalar L=r(mean)
sum lambda1vec
scalar Lprime=r(mean)
drop alfavec sigmavec vectorc Avec lambdavec lambda1vec


mata
S=1000
N=100000
sigma=2
alfa=1
c=0
sigmavec=range(1.02,3,0.02)
alfavec=range(0.02,2,0.02)
vectorc=J(S,1,c)
alfams=J(S,1,0)
sigmams=J(S,1,0)
iterationsms=J(S,1,0)
st_addobs(N)
u=invnormal(uniform(N,1))*sigma
ystar=alfa:+u
y=(ystar:<=c):*ystar+(ystar:>c):*c
(void) st_addvar("double", "y")
st_store(.,"y",y)
A=(0-alfa)/sigma
lambda=normalden(A)/(1-normal(A))
value1=alfa+(sigma*lambda)
value2=(alfa^2)+((sigma^2)*(1+(lambda*A)))+(2*alfa*sigma*lambda)
Psi=J(N,2,0)
i=1
do{
if (y[i]<c) Psi[i,1]=y[i]-alfa
else Psi[i,1]=value1-alfa
i=i+1
} while (i<=N)
i=1
do{
if (y[i]<c) Psi[i,2]=(y[i])^2-(alfa^2)-(sigma^2)
else Psi[i,2]=value2-(alfa^2)-(sigma^2)
i=i+1
} while (i<=N)
Psi1=Psi'
NumHam=(Psi1*Psi)/(N^2)
end

scalar alfa=1
scalar sigma=2
qui gen counter=1 if y==c
qui replace counter=0 if counter==.
qui egen frequency=mean(counter)
qui egen var=sum(y) if y<0
qui gen truncatedmean=var/N
qui gen y2=y^2
qui egen var2=sum(y2) if y<0
qui gen truncatedmean2=var2/N
qui gen y3=y^3
qui egen var3=sum(y3) if y<0
qui gen truncatedmean3=var3/N
qui gen y4=y^4
qui egen var4=sum(y4) if y<0
qui gen truncatedmean4=var4/N
qui gen check1=(truncatedmean)+(frequency*(alfa+(sigma*L)))
qui gen check2=sqrt((truncatedmean2)+(frequency*((alfa^2)+(sigma^2)*(1+(L*A))+(2*alfa*sigma*L)))-(alfa^2))
qui gen firstham=truncatedmean2+(frequency*(alfa+(sigma*L))^2)-(alfa^2)
qui gen secondham=truncatedmean3+(frequency*(alfa+(sigma*L))*((alfa^2)+((sigma^2)*(1+(L*A)))+(2*alfa*sigma*L)))-(alfa*((alfa^2)+(sigma^2)))
qui gen thirdham=truncatedmean4+frequency*(alfa^2+(sigma^2)*(1+(L*A))+(2*alfa*sigma*L))^2-((alfa^2)+(sigma^2))^2
qui gen firstbread=frequency*(1-Lprime)-1
qui gen secondbread=frequency*(L-Lprime*A)
qui gen thirdbread=frequency*((2*alfa)-(sigma*L)-(Lprime*sigma*A)+(2*sigma*L)-(2*alfa*Lprime))-(2*alfa)
qui gen forthbread=frequency*((2*sigma*(1+L*A))-(Lprime*A*A*sigma)-(L*A*sigma)+(2*alfa*L)-(2*alfa*Lprime*A))-(2*sigma)
scalar alfa=1
scalar sigma=2
scalar alfah=1.0001
scalar sigmah=2.0001
scalar A=(0-alfa)/sigma
scalar L=normalden(A)/(1-normal(A))
scalar Aalfah=(0-alfah)/sigma
scalar Asigmah=(0-alfa)/sigmah
scalar Lalfah=normalden(Aalfah)/(1-normal(Aalfah))
scalar Lsigmah=normalden(Asigmah)/(1-normal(Asigmah))
qui gen firstnumbread=(1/0.0001)*((frequency)*(0.0001+(sigma*(Lalfah-L)))-0.0001)
qui gen secondnumbread=(1/0.0001)*((frequency)*((0.0001*Lsigmah)+(sigma*(Lsigmah-L))))
qui gen part1=frequency*((alfah^2)+((sigma^2)*(1+Lalfah*Aalfah))+(2*alfah*sigma*Lalfah))
qui gen part2=frequency*((alfa^2)+((sigma^2)*(1+L*A))+(2*alfa*sigma*L))
qui gen thirdnumbread=(1/0.0001)*(part1-(alfah)^2-part2+(alfa^2))
qui gen part3=frequency*((alfa^2)+((sigmah^2)*(1+Lsigmah*Asigmah))+(2*alfa*sigmah*Lsigmah))
qui gen forthnumbread=(1/0.0001)*(part3-(sigmah)^2-part2+(sigma^2))
qui drop if y==0

mata
st_view(firstham=.,.,"firstham")
firstham=firstham[1]
st_view(secondham=.,.,"secondham")
secondham=secondham[1]
st_view(thirdham=.,.,"thirdham")
thirdham=thirdham[1]
st_view(firstbread=.,.,"firstbread")
firstbread=firstbread[1]
st_view(secondbread=.,.,"secondbread")
secondbread=secondbread[1]
st_view(thirdbread=.,.,"thirdbread")
thirdbread=thirdbread[1]
st_view(forthbread=.,.,"forthbread")
forthbread=forthbread[1]
st_view(firstnumbread=.,.,"firstnumbread")
firstnumbread=firstnumbread[1]
st_view(secondnumbread=.,.,"secondnumbread")
secondnumbread=secondnumbread[1]
st_view(thirdnumbread=.,.,"thirdnumbread")
thirdnumbread=thirdnumbread[1]
st_view(forthnumbread=.,.,"forthnumbread")
forthnumbread=forthnumbread[1]
Bread=J(2,2,0)
Bread[1,1]=firstbread
Bread[1,2]=secondbread
Bread[2,1]=thirdbread
Bread[2,2]=forthbread
Breadinv=luinv(Bread)
Breadtrans=J(2,2,0)
Breadtrans[1,1]=firstbread
Breadtrans[1,2]=thirdbread
Breadtrans[2,1]=secondbread
Breadtrans[2,2]=forthbread
Breadtransinv=luinv(Breadtrans)
Ham=J(2,2,0)
Ham[1,1]=firstham
Ham[1,2]=Ham[2,1]=secondham
Ham[2,2]=thirdham
VarandCovar=Breadinv*Ham*Breadtransinv

NumBread=J(2,2,0)
NumBread[1,1]=firstnumbread
NumBread[1,2]=secondnumbread
NumBread[2,1]=thirdnumbread
NumBread[2,2]=forthnumbread
NumVarandCovar=Breadinv*NumHam*Breadtransinv


r=1
do{
u=invnormal(uniform(N,1))*sigma
ystar=alfa:+u
y=(ystar:<=c):*ystar+(ystar:>c):*c
alfahat=mean(y)
sigmahat=sqrt(variance(y))
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
do{
alfavec[k]=mean(ysim)
sigmavec[k]=sqrt(variance(ysim))
z=(c-alfavec[k])/sigmavec[k]
aux= alfavec[k]:+sigmavec[k]*invnormal(normal(z):+(1-normal(z)):*v)
    j=1
    do{ 
    if (y[j]<c) ysim[j] = y[j]
    else ysim[j] = aux[j]
    j=j+1
    }while (j<=N)
k=k+1
}while ((abs(alfavec[k-1]-alfavec[k-2])>=0.001) | (abs(sigmavec[k-1]-sigmavec[k-2])>=0.001)) 
alfams[r]=alfavec[k-1] 
sigmams[r]=sigmavec[k-1]
iterationsms[r]=k-1
r=r+1
}while (r<=S)

mean(alfams)
mean(sigmams)
sqrt(variance(alfams))
sqrt(variance(sigmams))
mean(iterationsms)
Bread
NumBread
Ham/N
NumHam
NumVarandCovar
sqrt(NumVarandCovar[1,1])
sqrt(NumVarandCovar[2,2])
end

sum check1 check2


