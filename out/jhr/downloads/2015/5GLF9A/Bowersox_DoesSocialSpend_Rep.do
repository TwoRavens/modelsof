***********************************************
***********************************************
****	Bowersox "Does Social Spending..." **** 
****	Replication .do	   				   ****
****	For use with 					   ****
****	Bowersox_DoesSocialspend_Data	   ****
***********************************************
***********************************************


  *
 ***
***** Models reported in main text. See "Bowersox_DoesSocialSpend_Appendix.do" for those models reported in Appendix.
 ***
  *
 
* .do need be run twice, once with OECD sample, and a second time with the non-OECD sample. 

*drop if oecd = 1
drop if oecd == 0

** Tables 1 & 2 **

xtgls part Spend Empower SpendEmpr lcapita poplog exconst logmilex Judiciary cim L.part, force corr(psar)

xtgls protest Spend Empower SpendEmpr lcapita poplog exconst logmilex Judiciary cim L.protest, force corr(psar)

xtgls strike Spend Empower SpendEmpr lcapita poplog exconst logmilex Judiciary cim L.strike, force corr(psar)

xtgls riot Spend Empower SpendEmpr lcapita poplog exconst logmilex Judiciary cim L.riot, force corr(psar)




** Table 3 **


xtgls F.part Spend Empower SpendEmpr lcapita poplog exconst logmilex Judiciary cim part, force corr(psar)

xtgls F.protest Spend Empower SpendEmpr lcapita poplog exconst logmilex Judiciary cim protest, force corr(psar)

xtgls F.strike Spend Empower SpendEmpr lcapita poplog exconst logmilex Judiciary cim strike, force corr(psar)

xtgls F.riot Spend Empower SpendEmpr lcapita poplog exconst logmilex Judiciary cim riot, force corr(psar)






  *
 ***
***** Figures 1a - 1d & 2.a - 2.d
 ***
  *
 
 
********************** Figures 1.a & 2.a ****************************

xtgls part Spend Empower SpendEmpr lcapita poplog exconst logmilex Judiciary cim L.part, force corr(psar)

matrix b=e(b)
matrix V=e(V)

matrix list b
matrix list V

local k = colsof(b)
foreach c of numlist 1(1)`k' {
	local b`c' = b[1,`c']
	local varb`c' = V[`c',`c']
	foreach r of numlist 1(1)`k' {
		local covb`r'b`c' = V[`r',`c']
	}
}

postfile int Z ME_X SE_X LO_X HI_X X ME_Z SE_Z LO_Z HI_Z using "Marginal Effects.dta", replace

foreach i of numlist 0(1)14 {
	local ME_X = `b1' + (`b3' * `i')
	local SE_X = sqrt(`varb1'+((`i'^2)*`varb3')+(2*`i'*`covb1b3'))
	local LO_X = `ME_X' - (1.96 * `SE_X')
	local HI_X = `ME_X' + (1.96 * `SE_X')
	
	post int (`i') (`ME_X') (`SE_X') (`LO_X') (`HI_X') (.) (.) (.) (.) (.) 

}

foreach i of numlist 8(1)40 {
	local ME_Z = `b2' + (`b3' * `i')
	local SE_Z = sqrt(`varb2'+((`i'^2)*`varb3')+(2*`i'*`covb2b3'))
	local LO_Z = `ME_Z' - (1.96 * `SE_Z')
	local HI_Z = `ME_Z' + (1.96 * `SE_Z')
	
	post int (.) (.) (.) (.) (.) (`i') (`ME_Z') (`SE_Z') (`LO_Z') (`HI_Z') 

}

postclose int

use "Marginal Effects.dta", clear

twoway (line ME_X Z) (line LO_X Z, lpattern(dash)) (line HI_X Z, lpattern(dash)), /*
*/	xtitle("Empowerment Rights") ytitle("Electoral Participation") note("Dashed lines represent 95% confidence intervals") yline(0) legend(off) scheme(s1mono)

*********************************************************END*****************************************


********************** Figures 1.b & 2.b ****************************

xtgls protest Spend Empower SpendEmpr lcapita poplog exconst logmilex Judiciary cim L.protest, force corr(psar)

matrix b=e(b)
matrix V=e(V)

matrix list b
matrix list V

local k = colsof(b)
foreach c of numlist 1(1)`k' {
	local b`c' = b[1,`c']
	local varb`c' = V[`c',`c']
	foreach r of numlist 1(1)`k' {
		local covb`r'b`c' = V[`r',`c']
	}
}

postfile int Z ME_X SE_X LO_X HI_X X ME_Z SE_Z LO_Z HI_Z using "Marginal Effects.dta", replace

foreach i of numlist 0(1)14 {
	local ME_X = `b1' + (`b3' * `i')
	local SE_X = sqrt(`varb1'+((`i'^2)*`varb3')+(2*`i'*`covb1b3'))
	local LO_X = `ME_X' - (1.96 * `SE_X')
	local HI_X = `ME_X' + (1.96 * `SE_X')
	
	post int (`i') (`ME_X') (`SE_X') (`LO_X') (`HI_X') (.) (.) (.) (.) (.) 

}

foreach i of numlist 8(1)40 {
	local ME_Z = `b2' + (`b3' * `i')
	local SE_Z = sqrt(`varb2'+((`i'^2)*`varb3')+(2*`i'*`covb2b3'))
	local LO_Z = `ME_Z' - (1.96 * `SE_Z')
	local HI_Z = `ME_Z' + (1.96 * `SE_Z')
	
	post int (.) (.) (.) (.) (.) (`i') (`ME_Z') (`SE_Z') (`LO_Z') (`HI_Z') 

}

postclose int

use "Marginal Effects.dta", clear

twoway (line ME_X Z) (line LO_X Z, lpattern(dash)) (line HI_X Z, lpattern(dash)), /*
*/	xtitle("Empowerment Rights") ytitle("Protest") note("Dashed lines represent 95% confidence intervals") yline(0) legend(off) scheme(s1mono)

*********************************************************END*****************************************


 

********************** Figures 1.c & 2.c ****************************

xtgls strike Spend Empower SpendEmpr lcapita poplog exconst logmilex Judiciary cim L.strike, force corr(psar)

matrix b=e(b)
matrix V=e(V)

matrix list b
matrix list V

local k = colsof(b)
foreach c of numlist 1(1)`k' {
	local b`c' = b[1,`c']
	local varb`c' = V[`c',`c']
	foreach r of numlist 1(1)`k' {
		local covb`r'b`c' = V[`r',`c']
	}
}

postfile int Z ME_X SE_X LO_X HI_X X ME_Z SE_Z LO_Z HI_Z using "Marginal Effects.dta", replace

foreach i of numlist 0(1)14 {
	local ME_X = `b1' + (`b3' * `i')
	local SE_X = sqrt(`varb1'+((`i'^2)*`varb3')+(2*`i'*`covb1b3'))
	local LO_X = `ME_X' - (1.96 * `SE_X')
	local HI_X = `ME_X' + (1.96 * `SE_X')
	
	post int (`i') (`ME_X') (`SE_X') (`LO_X') (`HI_X') (.) (.) (.) (.) (.) 

}

foreach i of numlist 8(1)40 {
	local ME_Z = `b2' + (`b3' * `i')
	local SE_Z = sqrt(`varb2'+((`i'^2)*`varb3')+(2*`i'*`covb2b3'))
	local LO_Z = `ME_Z' - (1.96 * `SE_Z')
	local HI_Z = `ME_Z' + (1.96 * `SE_Z')
	
	post int (.) (.) (.) (.) (.) (`i') (`ME_Z') (`SE_Z') (`LO_Z') (`HI_Z') 

}

postclose int

use "Marginal Effects.dta", clear

twoway (line ME_X Z) (line LO_X Z, lpattern(dash)) (line HI_X Z, lpattern(dash)), /*
*/	xtitle("Empowerment Rights") ytitle("Strikes") note("Dashed lines represent 95% confidence intervals") yline(0) legend(off) scheme(s1mono)

*********************************************************END*****************************************



********************** Figures 1.d & 2.d ****************************

xtgls riot Spend Empower SpendEmpr lcapita poplog exconst logmilex Judiciary cim L.riot, force corr(psar)

matrix b=e(b)
matrix V=e(V)

matrix list b
matrix list V

local k = colsof(b)
foreach c of numlist 1(1)`k' {
	local b`c' = b[1,`c']
	local varb`c' = V[`c',`c']
	foreach r of numlist 1(1)`k' {
		local covb`r'b`c' = V[`r',`c']
	}
}

postfile int Z ME_X SE_X LO_X HI_X X ME_Z SE_Z LO_Z HI_Z using "Marginal Effects.dta", replace

foreach i of numlist 0(1)14 {
	local ME_X = `b1' + (`b3' * `i')
	local SE_X = sqrt(`varb1'+((`i'^2)*`varb3')+(2*`i'*`covb1b3'))
	local LO_X = `ME_X' - (1.96 * `SE_X')
	local HI_X = `ME_X' + (1.96 * `SE_X')
	
	post int (`i') (`ME_X') (`SE_X') (`LO_X') (`HI_X') (.) (.) (.) (.) (.) 

}

foreach i of numlist 8(1)40 {
	local ME_Z = `b2' + (`b3' * `i')
	local SE_Z = sqrt(`varb2'+((`i'^2)*`varb3')+(2*`i'*`covb2b3'))
	local LO_Z = `ME_Z' - (1.96 * `SE_Z')
	local HI_Z = `ME_Z' + (1.96 * `SE_Z')
	
	post int (.) (.) (.) (.) (.) (`i') (`ME_Z') (`SE_Z') (`LO_Z') (`HI_Z') 

}

postclose int

use "Marginal Effects.dta", clear

twoway (line ME_X Z) (line LO_X Z, lpattern(dash)) (line HI_X Z, lpattern(dash)), /*
*/	xtitle("Empowerment Rights") ytitle("Riots") note("Dashed lines represent 95% confidence intervals") yline(0) legend(off) scheme(s1mono)

*********************************************************END*****************************************



