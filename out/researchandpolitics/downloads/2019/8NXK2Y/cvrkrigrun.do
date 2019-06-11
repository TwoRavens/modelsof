* This program estimates total population analytically and performs the kriging geographical interppolation
scalar diestim=0
scalar nestim=0
scalar nestime=0
scalar nestimv=0
******************************
matrix mao=J(nstrata,3,0)
matrix modelmat=J(7, 1, 0)
forval ii = 1/58{   /* begin loop strata */
scalar jhat=`ii'
scalar jj1=(jhat-1)*8*3+(perpeh-1)*8+1
scalar jj2=jj1+6

matrix a=yy[jj1..jj2,1]              /*original data*/
run "$code\analya"
matrix mao[jhat,1]=ntotalm
if modeli>0 & (perpeh~=2 | jhat~=57) & (perpeh~=3 | jhat~=52) {           /* Original*/
matrix modelmat[modeli,1]=modelmat[modeli,1]+1
matrix mao[jhat,2]=nmv[modeli, 1]
matrix mao[jhat,3]=nmv[modeli, 2]
scalar diestim=diestim+1
scalar nestim=nestim+mao[jhat,1]
scalar nestime=nestime+mao[jhat,2]
scalar nestimv=nestimv+mao[jhat,3]

matrix reportmo=nmv,prm,chi2ml,dfml

forval ii= 1/7{
matrix reportmo[`ii',2]=sqrt(reportmo[`ii',2])
matrix reportmo[`ii',4]=reportmo[`ii',4]/reportmo[`ii',5]
}

di perpeh,jhat
matrix reportmo=reportmo[1..7,1..4]
matrix list reportmo
}


} /* end loop strata*/

matrix list mao



clear
svmat mao, names(v)

*1.       Create vector of values.
g dep=v2/v1
g dep2=v3/(v1*v1)



g i=_n
sort i

merge 1:1 i using "${geocoord}\distxy"  /* Coordinates */
drop _merge
mkmat x_di
mkmat y_di

ren x_di x
ren y_di y

drop if dep==0 | dep==.

*2.       Calculate variogram
variog2 dep x y , width(190000) lags(10)   list g(sem)

sum dep
scalar depmean=r(mean) 
scalar depvar1=r(Var) 
replace dep=dep-depmean

sum dep2
scalar depvar2=r(mean) 
scalar depvar=depvar1+ depvar2


mkmat dep
mkmat sem
mkmat x
mkmat y
drop if sem==.
scalar nlags=_N
clear

scalar nv=rowsof(dep)
*matrix ones=J(1,nv,1)
*matrix depmean=ones*dep/nv

scalar variance=0.
scalar i=1
while i<=nlags{
scalar variance=max(variance,sem[i,1])
scalar i=i+1
}
scalar variance=depvar
di variance

scalar rangex=nlags*190000

matrix sem=sem*depvar/variance
matrix sem=sem[1..nlags,.]
*scalar variance=depvar

*4. Variogram matrix
matrix varmar==J(nv,nv,0)
scalar i=1
while i<=nv{
*matrix dep[i,1]=dep[i,1]-depmean[1,1]

matrix varmar[i,i]=variance
scalar j=1
while j<i{
scalar distance= sqrt((x[i,1] - x[j,1])* (x[i,1] - x[j,1]) + (y[i,1] - y[j,1])* (y[i,1] - y[j,1]))

scalar disran=distance/rangex
scalar semico=variance*(1.5*disran-0.5*disran*disran*disran)                               /*3.       Estimate variogram */
if disran>1{
scalar semico=variance
}

matrix varmar[i,j]=variance-semico
matrix varmar[j,i]= varmar[i,j]
scalar j=j+1
}
scalar i=i+1
}

* Calculate variogram matrix
matrix list varmar
matrix varinv=inv(varmar)

*5.       Calculate variogram vector to estimation point
forval i = 1/58{

if  mao[`i',2]==0{

matrix varvec=J(nv,1,0)

scalar j=1
while j<=nv{
scalar distance= sqrt((x_di[`i',1] - x[j,1])* (x_di[`i',1] - x[j,1]) + (y_di[`i',1] - y[j,1])* (y_di[`i',1] - y[j,1]))
scalar disran=distance/rangex
scalar semico=variance*(1.5*disran-0.5*disran*disran*disran)          /*3.       Estimate variogram */
if disran>1{
scalar semico=variance
}
di j "   " distance  " " variance-semico " " sem[j,1] " " dep[j,1] " " depmean
matrix varvec[j,1]=variance-semico
scalar j=j+1
}
matrix beta=varinv*varvec
matrix list beta
matrix dephat=dep'*beta+depmean
matrix va=variance- varvec'*beta
di `i' " " dephat[1,1] "  " va[1,1]
di "   "
*matrix list beta
matrix mao[`i',2]=mao[`i',1]*dephat[1,1]
matrix mao[`i',3]=mao[`i',1]*mao[`i',1]*(variance- varvec'*beta)
}
matrix mao[`i',2]=int(mao[`i',2]+0.5)
matrix mao[`i',3]=int(mao[`i',3]+0.5)

}

matrix ones58==J(1,58,1)
matrix sum_mao=ones58*mao
matrix list sum_mao

di sqrt(sum_mao[1,3])
matrix list mao

scalar nestim2=nestim/sum_mao[1,1]
di nlags,nestim,nestim2
