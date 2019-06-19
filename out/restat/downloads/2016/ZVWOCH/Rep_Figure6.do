
********************************************************************************
* This files estimates the asymmetric RFIV regression and calculates IRF to 
* positive and negative shock separately.
* Regressions and calculations are done on explanding window basis and responses
* at different horizons saved to excel. Replicates Figure 6 in main text.
* August 2016.
**created by M.Dao mdao@imf.org*************************************************

cd //"directory with files"
use statedat.dta, clear
set matsize 1000
xtset id year

*to do relative to avg
egen imix_avg=mean(imix2_i), by(year)
gen civpopshr=civpop/civpopus
replace empgrus=(empus-empus)/l.empus
gen imix_rel=imix2_i-imix_avg
gen dpos=(imix_rel>0)
gen dneg=(imix_rel<0)
replace imix2_1=imix_rel*dpos
replace imix2_2=imix_rel*dneg


mat Mres1=(0)
mat Pres1=(0)
mat Ures1=(0)
mat Mres2=(0)
mat Pres2=(0)
mat Ures2=(0)
mat Mres3=(0)
mat Pres3=(0)
mat Ures3=(0)
mat Mres4=(0)
mat Mres10=(0)

capture drop avgpop
egen avgpop=mean(civpop), by(id)
forvalues l=0/23 {
xi: qui sureg (relempgr le lp=imix2_1 l.imix2_1 l2.imix2_1 imix2_2 l.imix2_2 l2.imix2_2  l.relempgr l2.relempgr l.le l2.le  l.lp l2.lp i.year i.id, r) if  year <=1990+`l' & year>=1976 [weight=avgpop]

*change imix2_1 to imix2_i when deriving response to negative shock
scalar s=1 
matrix I=(s\0\0)
*t=1
matrix A=([relempgr]imix2_1*I[1,1])
matrix B=([le]imix2_1*I[1,1])
matrix C=([lp]imix2_1*I[1,1])
*t=2
matrix A=(A\[relempgr]imix2_1*I[2,1]+[relempgr]l.imix2_1*I[1,1]+[relempgr]l.relempgr*A[1,1]+[relempgr]l.le*B[1,1]+[relempgr]l.lp*C[1,1])
matrix B=(B\[le]imix2_1*I[2,1]+[le]l.imix2_1*I[1,1]+[le]l.relempgr*A[1,1]+[le]l.le*B[1,1]+[le]l.lp*C[1,1])
matrix C=(C\[lp]imix2_1*I[2,1]+[lp]l.imix2_1*I[1,1]+[lp]l.relempgr*A[1,1]+[lp]l.le*B[1,1]+[lp]l.lp*C[1,1])
*t=3
matrix A=(A\[relempgr]imix2_1*I[3,1]+[relempgr]l.imix2_1*I[2,1]+[relempgr]l2.imix2_1*I[1,1]+[relempgr]l.relempgr*A[2,1]+[relempgr]l2.relempgr*A[1,1]+[relempgr]l.le*B[2,1]+[relempgr]l2.le*B[1,1]+[relempgr]l.lp*C[2,1]+[relempgr]l2.lp*C[1,1])
matrix B=(B\[le]imix2_1*I[3,1]+[le]l.imix2_1*I[2,1]+[le]l2.imix2_1*I[1,1]+[le]l.relempgr*A[2,1]+[le]l.relempgr*A[1,1]+[le]l.le*B[2,1]+[le]l2.le*B[1,1]+[le]l.lp*C[2,1]+[le]l2.lp*C[1,1])
matrix C=(C\[lp]imix2_1*I[3,1]+[lp]l.imix2_1*I[2,1]+[lp]l2.imix2_1*I[1,1]+[lp]l.relempgr*A[2,1]+[lp]l2.relempgr*A[1,1]+[lp]l.le*B[2,1]+[lp]l2.le*B[1,1]+[lp]l.lp*C[2,1]+[lp]l2.lp*C[1,1])

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

matrix P=(D-B-C) 
matrix U=1/0.936*(D-B)-D //derive change in UR
matrix Par=(D-B)/0.936-P //derive change in Particip. Rate


mat Pshr=P
mat Ushr=U
mat Parshr=Par



mat Mres1=(Mres1\Pshr[1,1])
mat Ures1=(Ures1\-Ushr[1,1])
mat Pres1=(Pres1\Parshr[1,1])

mat Mres2=(Mres2\Pshr[2,1])
mat Ures2=(Ures2\-Ushr[2,1])
mat Pres2=(Pres2\Parshr[2,1])

mat Mres3=(Mres3\Pshr[3,1])
mat Ures3=(Ures3\-Ushr[3,1])
mat Pres3=(Pres3\Parshr[3,1])

mat Mres4=(Mres4\Pshr[4,1])
mat Mres10=(Mres10\Pshr[10,1])
}
svmat Mres1 
svmat Ures1 
svmat Pres1 
svmat Mres2
svmat Ures2
svmat Pres2
svmat Mres3
svmat Ures3 
svmat Pres3
svmat Mres4
svmat Mres10

*Mres1 and Mres10 is the respone of net population after 1 and 10 years as plotted in Figure 6.
export excel Mres11 Ures1 Pres1 Mres2 Ures2 Pres2 Mres3 Ures3 Pres3 Mres4 Mres101 using rollingregout_asym2.csv, sheet("pos") sheetreplace firstrow(variables) //change sheetlabel when saving response to imix2_2
