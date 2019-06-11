clear
mata
mata clear
end
scalar N=5000
mata
N=5000
alfa1=range(-10,-1,1)
alfa2=range(1,10,1)
alfas=J(20,1,0)
alfas[1..10]=alfa1
alfas[11..20]=alfa2
sigmas=range(0.1,5,0.1)
AA=J(20,50,0)
t=1
do{
AA[,t]=alfas
t=t+1
}while (t<=50)
alfa=colshape(AA,1)
Mat1=J(1000,2,0)
Mat1[.,1]=alfa 
BB=J(20,50,0)
t=1
do{
BB[t,]=sigmas'
t=t+1
}while (t<=20)
sigma=colshape(BB,1)
Mat1[.,2]=sigma 
mata drop alfa sigma alfa1 alfa2 alfas sigmas AA BB 
R=1000
Mat2=J(R,2,0)

r=1
do{
alfa=Mat1[r,1]
sigma=Mat1[r,2]
u=invnormal(uniform(N,1))*sigma
ystar=alfa:+u
c=mean(ystar)
y=(ystar:<=c):*ystar+(ystar:>c):*c
alfahat=mean(y)
sigmahat=sqrt(variance(y))

st_addobs(N)
(void) st_addvar("double", "ystar")
st_store(.,"ystar",ystar)
(void) st_addvar("double", "y")
st_store(.,"y",y)
stata("qui egen cvec=mean(ystar)")
stata("qui sum cvec")
stata("qui scalar cens=r(mean)")
stata("qui gen counter=1 if ystar>cens")
stata("qui replace counter=0 if counter==.")
stata("qui egen frequency=mean(counter)")
stata("qui egen var=sum(y) if y<cens")
stata("qui gen truncatedmean=var/N")
stata("qui sum truncatedmean")
stata("scalar valor=r(mean)")
stata("qui replace truncatedmean=valor if truncatedmean==.")
stata("qui gen y2=y^2")
stata("qui egen var2=sum(y2) if y<cens")
stata("qui gen truncatedmean2=var2/N")
stata("qui sum truncatedmean2")
stata("scalar valor2=r(mean)")
stata("qui replace truncatedmean2=valor2 if truncatedmean2==.")

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
alfa=alfavec[k-1] 
sigma=sigmavec[k-1]
A=(c-alfa)/sigma
lambda=normalden(A)/(1-normal(A))
st_view(frequency1=.,.,"frequency")
frequency=frequency1[1]
st_view(truncatedmean1=.,.,"truncatedmean")
truncatedmean=truncatedmean1[1]
st_view(truncatedmean2=.,.,"truncatedmean2")
truncatedmean2=truncatedmean2[1]

alfah=alfa+0.0001
sigmah=sigma+0.0001
Aalfah=(c-alfah)/sigma
Asigmah=(c-alfa)/sigmah
Lalfah=normalden(Aalfah)/(1-normal(Aalfah))
Lsigmah=normalden(Asigmah)/(1-normal(Asigmah))
NumJacobian1=(1/0.0001)*(frequency*(0.0001+(sigma*(Lalfah-lambda))))
NumJacobian2=(1/0.0001)*(frequency*((sigmah*Lsigmah)-(sigma*lambda)))
part1=frequency*(((alfah)^2)+((sigma^2)*(1+(Lalfah*Aalfah)))+(2*alfah*sigma*Lalfah))
part2=frequency*((alfa^2)+((sigma^2)*(1+(lambda*A)))+(2*alfa*sigma*lambda))
part3=(truncatedmean+(frequency*(alfa+(sigma*lambda))))^2
part4=(truncatedmean+(frequency*(alfah+(sigma*Lalfah))))^2
NumJacobian3=(1/0.0001)*(part1-part2+part3-part4)
part5=frequency*(((alfa)^2)+((sigmah^2)*(1+(Lsigmah*Asigmah)))+(2*alfa*sigmah*Lsigmah))
part6=(truncatedmean+(frequency*(alfa+(sigmah*Lsigmah))))^2
NumJacobian4=(1/0.0001)*(part5-part2+part3-part6)
G1=truncatedmean+(frequency*(alfa+(sigma*lambda)))
G2=truncatedmean2+(frequency*((alfa^2)+((sigma^2)*(1+(lambda*A)))+(2*alfa*sigma*lambda)))-(truncatedmean+(frequency*(alfa+(sigma*lambda))))
G2square=G2^2
value1=(1/sigma)*G2
value2=2*G2
value3=1/(2*sigma)
GJacobian1=NumJacobian1
GJacobian2=-NumJacobian2*(sigma^2)
GJacobian3=-NumJacobian3/G2square
GJacobian4=(NumJacobian4*(sigma^2))/G2square

NumJacobian=J(2,2,0)
NumJacobian[1,1]=NumJacobian1
NumJacobian[1,2]=NumJacobian2
NumJacobian[2,1]=NumJacobian3
NumJacobian[2,2]=NumJacobian4

GJacobian=J(2,2,0)
GJacobian[1,1]=GJacobian1
GJacobian[1,2]=GJacobian2
GJacobian[2,1]=GJacobian3
GJacobian[2,2]=GJacobian4

NewJacobian=J(2,2,0)
NewJacobian[1,1]=(1/G2square)*((NumJacobian1*sigma*G2)-(NumJacobian3*sigma*G1))
NewJacobian[1,2]=(1/G2square)*(((NumJacobian1*sigma)-(NumJacobian2*(sigma^2)))*G2-((NumJacobian3*sigma)-(NumJacobian4*(sigma^2)))*G1)
NewJacobian[2,1]=(1/G2square)*(-NumJacobian3*sigma)
NewJacobian[2,2]=(1/G2square)*(-NumJacobian3*sigma+NumJacobian4*(sigma^2))

E=eigenvalues(GJacobian)
E=Re(E)
Mat2[r,.]=E
r=r+1
stata("drop ystar y cvec counter frequency truncatedmean var y2 truncatedmean2 var2")
}while (r<=R)

biglambda=abs(Mat2[.,1])
shortlambda=abs(Mat2[.,2])
alfa=Mat1[.,1]
sigma=Mat1[.,2]
st_addobs(R)
(void) st_addvar("double", "biglambda")
st_store(.,"biglambda",biglambda)
(void) st_addvar("double", "shortlambda")
st_store(.,"shortlambda",shortlambda)
(void) st_addvar("double", "alfa")
st_store(.,"alfa",alfa)
(void) st_addvar("double", "sigma")
st_store(.,"sigma",sigma)
mean(Mat2)

end


drop if alfa==1
twoway (scatter biglambda shortlambda), ytitle(Lambda 1) xtitle(Lambda 2) title(Figure 1. Eigenvalues of the Jacobian)




