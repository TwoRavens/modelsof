
********************************************************************************
* This files estimates the baseline IV regression using rimix as independnet 
* variable in SURE form and calculates IRF. Choose different sub-samples and save to excel
* August 2016, mdao@imf.org
********************************************************************************

cd //"directory where you put yoru files"
use statedat.dta, clear
set matsize 1000
xtset id year


egen imix_avg=mean(imix2_i), by(year)
gen imix_rel=imix2_i-imix_avg

*change sample below from 1976-1990 to 1991-2007 to 1991-2013 
xi: qui sureg (relempgr le lp=imix_rel l.imix_rel l2.imix_rel l.relempgr l2.relempgr l.le l2.le  l.lp l2.lp i.id, r) //if  /*put sample here*/

scalar s=1/[relempgr]imix_rel //normalize for OLS comparison, equal 1 for change over time
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


export excel using baseline.xlsx, sheet("iv") sheetreplace firstrow(variables)


