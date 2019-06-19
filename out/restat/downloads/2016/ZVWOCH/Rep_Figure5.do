
************************************************************************************************************************************
* This files estimates the asymmetric model using rimix as IV, 
* performs Wald test for the first 3 years, and saves the response paths.
* Shock is +/- 1 % change in rimix.
* Response to positive and negative are saved to separate sheets after changing the variable for IRF calculation in lines 72-92.
* Update August 2016, mdao@imf.org
***********************************************************************************************************************************

cd //"directory where you put files"
use statedat.dta, clear
set matsize 1000
xtset id year
capture drop avgpop
egen avgpop=mean(civpop), by(id)

*to do relative to avg
egen imix_avg=mean(imix2_i), by(year)
gen civpopshr=civpop/civpopus
replace empgrus=(empus-empus)/l.empus
gen imix_rel=imix2_i-imix_avg
gen dpos=(imix_rel>0)
gen dneg=(imix_rel<0)
replace imix2_1=imix_rel*dpos
replace imix2_2=imix_rel*dneg
*/

xi: qui sureg (relempgr le lp=imix2_1 l.imix2_1 l2.imix2_1 imix2_2 l.imix2_2 l2.imix2_2  l.relempgr l2.relempgr l.le l2.le  l.lp l2.lp i.year i.id, r) [weight=avgpop]


***perform Wald tests for t=0 to t=3******************************************************** 
test [relempgr]imix2_1-[le]imix2_1-[lp]imix2_1=[relempgr]imix2_2-[le]imix2_2-[lp]imix2_2

testnl [relempgr]imix2_1 +[relempgr]l.imix2_1 + [relempgr]l.relempgr*[relempgr]imix2_1+[relempgr]l.le*[le]imix2_1 + [relempgr]l.lp*[lp]imix2_1 ///
       - ([le]l.imix2_1+[le]l.relempgr*[relempgr]imix2_1+[le]l.le*[le]imix2_1+[le]l.lp*[lp]imix2_1) ///
	   - ([lp]l.imix2_1+[lp]l.relempgr*[relempgr]imix2_1+[lp]l.le*[le]imix2_1+[lp]l.lp*[lp]imix2_1) ///
	   = [relempgr]imix2_2 +[relempgr]l.imix2_2 + [relempgr]l.relempgr*[relempgr]imix2_2+[relempgr]l.le*[le]imix2_2 + [relempgr]l.lp*[lp]imix2_2 ///
       - ([le]l.imix2_2+[le]l.relempgr*[relempgr]imix2_2+[le]l.le*[le]imix2_2+[le]l.lp*[lp]imix2_2) ///
	   - ([lp]l.imix2_2+[lp]l.relempgr*[relempgr]imix2_2+[lp]l.le*[le]imix2_2+[lp]l.lp*[lp]imix2_2)

	   *chi2(1) =        3.50
       *Prob > chi2 =        0.0613

	   
testnl [relempgr]imix2_1 +[relempgr]l.imix2_1 + [relempgr]l.relempgr*[relempgr]imix2_1+[relempgr]l.le*[le]imix2_1 + [relempgr]l.lp*[lp]imix2_1 ///
		+ [relempgr]l2.imix2_1+[relempgr]l.relempgr*([relempgr]l.imix2_1 + [relempgr]l.relempgr*[relempgr]imix2_1+[relempgr]l.le*[le]imix2_1 + [relempgr]l.lp*[lp]imix2_1)+[relempgr]l2.relempgr*[relempgr]imix2_1 ///
		+[relempgr]l.le*([le]l.imix2_1+[le]l.relempgr*[relempgr]imix2_1+[le]l.le*[le]imix2_1+[le]l.lp*[lp]imix2_1) +[relempgr]l2.le*[le]imix2_1 ///
		+[relempgr]l.lp*([lp]l.imix2_1+[lp]l.relempgr*[relempgr]imix2_1+[lp]l.le*[le]imix2_1+[lp]l.lp*[lp]imix2_1)+[relempgr]l2.lp*[lp]imix2_1 ///
		- ([le]l2.imix2_1+[le]l.relempgr*([relempgr]l.imix2_1 + [relempgr]l.relempgr*[relempgr]imix2_1+[relempgr]l.le*[le]imix2_1 + ///
		[relempgr]l.lp*[lp]imix2_1)+[le]l.relempgr*([relempgr]imix2_1)+[le]l.le*([le]l.imix2_1+[le]l.relempgr*[relempgr]imix2_1+[le]l.le*[le]imix2_1+[le]l.lp*[lp]imix2_1)+[le]l2.le*[le]imix2_1 ///
		+[le]l.lp*([lp]l.imix2_1+[lp]l.relempgr*[relempgr]imix2_1+[lp]l.le*[le]imix2_1+[lp]l.lp*[lp]imix2_1)+[le]l2.lp*[lp]imix2_1 ) ///
		- ( [lp]l2.imix2_1+[lp]l.relempgr*([relempgr]l.imix2_1+[relempgr]l.relempgr*[relempgr]imix2_1+[relempgr]l.le*[le]imix2_1+[relempgr]l.lp*[lp]imix2_1) ///
		+[lp]l2.relempgr*[relempgr]imix2_1+[lp]l.le*([le]l.imix2_1+[le]l.relempgr*[relempgr]imix2_1+[le]l.le*[le]imix2_1+[le]l.lp*[lp]imix2_1)+[lp]l2.le*[le]imix2_1 ///
		+[lp]l.lp*([lp]l.imix2_1+[lp]l.relempgr*[relempgr]imix2_1+[lp]l.le*[le]imix2_1+[lp]l.lp*[lp]imix2_1)+[lp]l2.lp*[lp]imix2_1) ///
		= [relempgr]imix2_2 +[relempgr]l.imix2_2 + [relempgr]l.relempgr*[relempgr]imix2_2+[relempgr]l.le*[le]imix2_2 + [relempgr]l.lp*[lp]imix2_2 ///
		+ [relempgr]l2.imix2_2+[relempgr]l.relempgr*([relempgr]l.imix2_2 + [relempgr]l.relempgr*[relempgr]imix2_2+[relempgr]l.le*[le]imix2_2 + [relempgr]l.lp*[lp]imix2_2)+[relempgr]l2.relempgr*[relempgr]imix2_2 ///
		+[relempgr]l.le*([le]l.imix2_2+[le]l.relempgr*[relempgr]imix2_2+[le]l.le*[le]imix2_2+[le]l.lp*[lp]imix2_2) +[relempgr]l2.le*[le]imix2_2 ///
		+[relempgr]l.lp*([lp]l.imix2_2+[lp]l.relempgr*[relempgr]imix2_2+[lp]l.le*[le]imix2_2+[lp]l.lp*[lp]imix2_2)+[relempgr]l2.lp*[lp]imix2_2 ///
		- ([le]l2.imix2_2+[le]l.relempgr*([relempgr]l.imix2_2 + [relempgr]l.relempgr*[relempgr]imix2_2+[relempgr]l.le*[le]imix2_2 + ///
		[relempgr]l.lp*[lp]imix2_2)+[le]l.relempgr*([relempgr]imix2_2)+[le]l.le*([le]l.imix2_2+[le]l.relempgr*[relempgr]imix2_2+[le]l.le*[le]imix2_2+[le]l.lp*[lp]imix2_2)+[le]l2.le*[le]imix2_2 ///
		+[le]l.lp*([lp]l.imix2_2+[lp]l.relempgr*[relempgr]imix2_2+[lp]l.le*[le]imix2_2+[lp]l.lp*[lp]imix2_2)+[le]l2.lp*[lp]imix2_2 ) ///
		- ( [lp]l2.imix2_2+[lp]l.relempgr*([relempgr]l.imix2_2+[relempgr]l.relempgr*[relempgr]imix2_2+[relempgr]l.le*[le]imix2_2+[relempgr]l.lp*[lp]imix2_2) ///
		+[lp]l2.relempgr*[relempgr]imix2_2+[lp]l.le*([le]l.imix2_2+[le]l.relempgr*[relempgr]imix2_2+[le]l.le*[le]imix2_2+[le]l.lp*[lp]imix2_2)+[lp]l2.le*[le]imix2_2 ///
		+[lp]l.lp*([lp]l.imix2_2+[lp]l.relempgr*[relempgr]imix2_2+[lp]l.le*[le]imix2_2+[lp]l.lp*[lp]imix2_2)+[lp]l2.lp*[lp]imix2_2) 
		
		*Chi(1)=6.89 p=0.0087

***************************************************************************************************		
	
*replace imix2_1 below with imix2_2 when deriving the response to negative shock
	
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

matrix M=D-B-C


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


export excel using rfiv_asym.xlsx, sheet("iv_wt_pos_reltoavg") sheetreplace firstrow(variables) //change sheetname when saving response to imix2_2



