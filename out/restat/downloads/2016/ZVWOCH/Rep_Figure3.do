
****************************************************************************
* This file replicates Figure 3
**************************************************************************
cd //"directory where you put your files"
use statedat.dta, clear

xtset id year
xi: qui sureg (dm_relempgr l.dm_relempgr l2.dm_relempgr l.dm_le l2.dm_le l.dm_lp l2.dm_lp) (dm_le dm_lp=dm_relempgr  l.dm_relempgr l2.dm_relempgr l.dm_le l2.dm_le l.dm_lp l2.dm_lp) if year>=1990
mat X=e(b)
capture matrix drop A
capture matrix drop B
capture matrix drop C

matrix A=(0\1)
matrix B=(0\X[1,8])
matrix C=(0\X[1,16])
matrix A=(A\X[1,1]*A[2,1]+X[1,3]*B[2,1]+X[1,5]*C[2,1])
mat B=(B\X[1,8]*A[3,1]+X[1,9]*A[2,1]+X[1,11]*B[2,1]+X[1,13]*C[2,1])
mat C=(C\X[1,16]*A[3,1]+X[1,17]*A[2,1]+X[1,19]*B[2,1]+X[1,21]*C[2,1])



forvalues i=3/30 {
matrix A=(A\X[1,1]*A[`i',1]+X[1,2]*A[`i'-1,1]+X[1,3]*B[`i',1]+X[1,4]*B[`i'-1,1]+X[1,5]*C[`i',1]+X[1,6]*C[`i'-1,1])
matrix B=(B\X[1,8]*A[`i'+1,1]+X[1,9]*A[`i',1]+X[1,10]*A[`i'-1,1]+X[1,11]*B[`i',1]+X[1,12]*B[`i'-1,1]+X[1,13]*C[`i',1]+X[1,14]*C[`i'-1,1])
matrix C=(C\X[1,16]*A[`i'+1,1]+X[1,17]*A[`i',1]+X[1,18]*A[`i'-1,1]+X[1,19]*B[`i',1]+X[1,20]*B[`i'-1,1]+X[1,21]*C[`i',1]+X[1,22]*C[`i'-1,1])
}



matrix D=(0\1)
mat D=(D\D[2,1]+A[3,1])
mat D=(D\D[3,1]+A[4,1])



forvalues j=4/30 {
mat D=(D\D[`j',1]+A[`j'+1,1])
}


mat list D  //this is the vector of employment level response
matrix M=D-B-C //this is the vector of population response (net migration)


*matrix `b'=M' //put here the vector that you want to be displayed, remember to transpose
*ereturn post `b'

svmat D
svmat B
svmat C
svmat M


keep D1 B1 C1 M1
ren D1 emp
ren B1 er
ren C1 pr
ren M1 p
capture drop t
gen t=_n if _n<=31
replace t=t-1

export excel using fig3rep.xlsx, sheet("ols_system") sheetreplace firstrow(variables)

*Now do the direct regression using LAUS popdata, OLS identif:
use statedat.dta, clear
xi: qui xtreg dtdmigrate_new l.dtdmigrate_new l2.dtdmigrate_new relempgr l.relempgr l2.relempgr i.year, fe 

scalar s=1
matrix A=(0)
matrix A=(A\_b[relempgr]*s)
matrix A=(A\A[2,1]*_b[l.dtdmigrate_new]+_b[l.relempgr]*s)
matrix A=(A\A[3,1]*_b[l.dtdmigrate_new]+A[2,1]*_b[l2.dtdmigrate_new]+_b[l2.relempgr]*s)

forvalues i=5/20 {
matrix A=(A\A[`i'-1,1]*_b[l.dtdmigrate_new]+A[`i'-2,1]*_b[l2.dtdmigrate_new])
}

matrix A1=A
forvalues j=2/20 {
matrix A1[`j',1]=A1[`j'-1,1]+A[`j',1]
}
svmat A1 
keep A1
ren A11 p
gen t=_n if _n<=31
replace t=t-1

export excel using fig3rep.xlsx, sheet("ols_popreg") sheetreplace firstrow(variables)

****NOW do the same for rfiv:

use statedat.dta, clear
set matsize 1000
xtset id year


egen imix_avg=mean(imix2_i), by(year)
gen imix_rel=imix2_i-imix_avg

xi: qui sureg (relempgr le lp=imix_rel l.imix_rel l2.imix_rel l.relempgr l2.relempgr l.le l2.le  l.lp l2.lp i.id, r) if  year>=1990 & year<=2011 //limit sample to 2011 to match availability of migration data.


scalar s=1/[relempgr]imix_rel //normalize or not
matrix I=(s\0\0)
*t=1
matrix A=([relempgr]imix_rel*I[1,1])
matrix B=([le]imix_rel*I[1,1])
matrix C=([lp]imix_rel*I[1,1])
*t=2
matrix A=(A\[relempgr]imix_rel*I[2,1]+[relempgr]l.imix_rel*I[1,1]+[relempgr]l.relempgr*A[1,1]+[relempgr]l.le*B[1,1]+[relempgr]l.lp*C[1,1])
matrix B=(B\[le]imix_rel*I[2,1]+[le]l.imix_rel*I[1,1]+[le]l.relempgr*A[1,1]+[le]l.le*B[1,1]+[le]l.lp*C[1,1])
matrix C=(C\[lp]imix_rel*I[2,1]+[lp]l.imix_rel*I[1,1]+[lp]l.relempgr*A[1,1]+[lp]l.le*B[1,1]+[lp]l.lp*C[1,1])
*t=3
matrix A=(A\[relempgr]imix_rel*I[3,1]+[relempgr]l.imix_rel*I[2,1]+[relempgr]l2.imix_rel*I[1,1]+[relempgr]l.relempgr*A[2,1]+[relempgr]l2.relempgr*A[1,1]+[relempgr]l.le*B[2,1]+[relempgr]l2.le*B[1,1]+[relempgr]l.lp*C[2,1]+[relempgr]l2.lp*C[1,1])
matrix B=(B\[le]imix_rel*I[3,1]+[le]l.imix_rel*I[2,1]+[le]l2.imix_rel*I[1,1]+[le]l.relempgr*A[2,1]+[le]l.relempgr*A[1,1]+[le]l.le*B[2,1]+[le]l2.le*B[1,1]+[le]l.lp*C[2,1]+[le]l2.lp*C[1,1])
matrix C=(C\[lp]imix_rel*I[3,1]+[lp]l.imix_rel*I[2,1]+[lp]l2.imix_rel*I[1,1]+[lp]l.relempgr*A[2,1]+[lp]l2.relempgr*A[1,1]+[lp]l.le*B[2,1]+[lp]l2.le*B[1,1]+[lp]l.lp*C[2,1]+[lp]l2.lp*C[1,1])

*from t=4 onward
forvalues i=4/21 {
matrix A=(A\[relempgr]l.relempgr*A[`i'-1,1]+[relempgr]l2.relempgr*A[`i'-2,1]+[relempgr]l.le*B[`i'-1,1]+[relempgr]l2.le*B[`i'-2,1]+[relempgr]l.lp*C[`i'-1,1]+[relempgr]l2.lp*C[`i'-2,1])
matrix B=(B\[le]l.relempgr*A[`i'-1,1]+[le]l2.relempgr*A[`i'-2,1]+[le]l.le*B[`i'-1,1]+[le]l2.le*B[`i'-2,1]+[le]l.lp*C[`i'-1,1]+[le]l2.lp*C[`i'-2,1])
matrix C=(C\[lp]l.relempgr*A[`i'-1,1]+[lp]l2.relempgr*A[`i'-2,1]+[lp]l.le*B[`i'-1,1]+[lp]l2.le*B[`i'-2,1]+[lp]l.lp*C[`i'-1,1]+[lp]l2.lp*C[`i'-2,1])
}

matrix D=A

forvalues j=2/21 {
matrix D[`j',1]=D[`j'-1,1]+A[`j',1]
}

matrix M=D-B-C

mat list M


svmat D
svmat B
svmat C
svmat M


keep D1 B1 C1 M1
ren D1 emp
ren B1 er
ren C1 pr
ren M1 p
capture drop t
gen t=_n if _n<=21


export excel using fig3rep.xlsx, sheet("iv_system") sheetreplace firstrow(variables)


use statedat.dta, clear

egen imix_avg=mean(imix2_i), by(year)
gen imix_rel=imix2_i-imix_avg

xi: qui xtreg dtdmigrate_new l.dtdmigrate_new l2.dtdmigrate_new imix2_i l.imix2_i l2.imix2_i i.year trend, fe 

scalar s=1.214271
matrix A=(0)
matrix A=(A\_b[imix2_i]*s)
matrix A=(A\A[2,1]*_b[l.dtdmigrate_new]+_b[l.imix2_i]*s)
matrix A=(A\A[3,1]*_b[l.dtdmigrate_new]+A[2,1]*_b[l2.dtdmigrate_new]+_b[l2.imix2_i]*s)

forvalues i=5/20 {
matrix A=(A\A[`i'-1,1]*_b[l.dtdmigrate_new]+A[`i'-2,1]*_b[l2.dtdmigrate_new])
}

matrix A1=A
forvalues j=2/20 {
matrix A1[`j',1]=A1[`j'-1,1]+A[`j',1]
}
svmat A1 
keep A1
ren A11 p
gen t=_n if _n<=31
replace t=t-1

export excel using fig3rep.xlsx, sheet("iv_popreg") sheetreplace firstrow(variables)
