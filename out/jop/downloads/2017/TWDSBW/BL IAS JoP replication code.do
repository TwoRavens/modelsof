*********************************************************************
*Replication code for 
*
*Local Embeddedness and Bureaucratic Performance: Evidence from India
*Rikhil R. Bhavnani
*Alexander Lee
*Forthcoming in the Journal of Politics
*
*********************************************************************

use "BL IAS JoP replication data 1.dta", clear

global prefcontrols lnnewpop lnnvill p_rural p_work p_aglab p_sc p_st lnmurderpc stategov natgov

*tab 1
reg Phigh ALLlocal, robust
reg Phigh ALLlocal ALLbachdivi $prefcontrols, robust 
reg Phigh ALLlocal ALLbachdivi $prefcontrols i.distcode71 i.year, robust cl(distcode71) 
xi: ivreg2 Phigh (ALLlocal=EXALLlocal) ALLbachdivi $prefcontrols i.distcode71 i.year, robust cl(distcode71) ffirst partial(_Idistcode7*) savefprefix(r)

*tab 2
xi: ivreg2 Phigh (ALLlocal ALLexamrank=EXALLlocal EXALLexamrank) ALLbachdivi $prefcontrols i.distcode71 i.year, robust cl(distcode71) ffirst partial(_Idistcode7*) savefprefix(r)
xi: ivreg2 Phigh EXALLlocal ALLbachdivi $prefcontrols i.distcode71 i.year, robust cl(distcode71) partial(_Idistcode7*) 
xi: ivreg2 Phigh (ALLlocal=EX4ALLlocal) ALLbachdivi $prefcontrols i.distcode71 i.year, robust cl(distcode71) ffirst partial(_Idistcode7*) 
xi: ivreg2 Phigh (ALLlocal=EXALLlocal) LPhigh ALLbachdivi $prefcontrols i.year i.stcode, robust ffirst cl(stcode)
xi: ivreg2 Panymed (ALLlocal=EXALLlocal) ALLbachdivi $prefcontrols i.distcode71 i.year, robust cl(distcode71) ffirst partial(_Idistcode7*) savefprefix(r)
xi: ivreg2 Pphone (ALLlocal=EXALLlocal) ALLbachdivi $prefcontrols i.distcode71 i.year, robust cl(distcode71) ffirst partial(_Idistcode7*)

*tab 3
xi: ivreg2 Phigh (ALLlocal plit71ALLlocal=EXALLlocal plit71EXALLlocal) ALLbachdivi $prefcontrols i.distcode71 i.year, robust cl(distcode71) ffirst partial(_Idistcode7*) 
xi: ivreg2 Phigh (ALLlocal lnpcnewslocal71ALLlocal=EXALLlocal lnpcnewslocal71EXALLlocal) ALLbachdivi $prefcontrols i.distcode71 i.year, robust cl(distcode71) ffirst partial(_Idistcode7*) 
xi: ivreg2 Phigh (ALLlocal ALLsamelang=EXALLlocal EXALLsamelang) ALLbachdivi $prefcontrols i.distcode71 i.year, robust cl(distcode71) ffirst partial(_Idistcode7*) savefprefix(r)
xi: ivreg2 Phigh (ALLlocal ALLpol=EXALLlocal EXALLpol) ALLbachdivi $prefcontrols i.distcode71 i.year, robust cl(distcode71) ffirst partial(_Idistcode7*) savefprefix(r)

*fig 1
preserve
	use "BL IAS JoP replication data 2.dta", clear
	twoway (tsline Phigh), ytitle(Prop. of vill. with high schools) xtitle(Year) title("") ylabel(0(.05).20)
restore

*fig 2
lpoly ALLlocal EXALLlocal, nosc ci legend(off) note("") title("") ylabel(0(.2) 1) name(a, replace)

*fig 3
lpoly Phigh ALLlocal, nosc ci legend(off) note("") title("") name(a, replace) ylabel(0(.05).20)


*fig 4
xi: ivreg2 Phigh (ALLlocal plit71ALLlocal=EXALLlocal plit71EXALLlocal) ALLbachdivi $prefcontrols i.distcode71 i.year, robust cl(distcode71) ffirst partial(_Idistcode7*) 
capture drop where
capture drop pipe
gen where=0
gen pipe="|"
summ plit71 if e(sample)
global max = r(max)
global min = r(min)
mat V=e(V)
local var1=V[1,1]
local var2=V[2,2]
local covar=V[2,1]
twoway (function y = _b[ALLlocal] + _b[plit71ALLlocal]*x, range($min $max)) ///
(function y = _b[ALLlocal] + _b[plit71ALLlocal]*x + 1.64*(`var1'+x^2*`var2'+2*x*`covar')^0.5, range($min $max) lpattern("-")) ///
(function y = _b[ALLlocal] + _b[plit71ALLlocal]*x - 1.64*(`var1'+x^2*`var2'+2*x*`covar')^0.5, range($min $max) lpattern("-")) ///
(scatter where plit71 if e(sample), ms(none) mlabel(pipe) mlabpos(0) legend(off)), ///
ytitle("Change in the prop. of villages with high sch. per" "unit change in the prop. of local bureaucrats") xtitle("Prop. of literates, 1971") name(z1, replace) ///
legend(off) ylabel(,valuelabel labs(medlarge) nogrid) xlabel(,labsize(medlarge))

xi: ivreg2 Phigh (ALLlocal lnpcnewslocal71ALLlocal=EXALLlocal lnpcnewslocal71EXALLlocal) ALLbachdivi $prefcontrols i.distcode71 i.year, robust cl(distcode71) ffirst partial(_Idistcode7*) 
capture drop where
capture drop pipe
gen where=0
gen pipe="|"
summ lnpcnewslocal71 if e(sample)
global max = r(max)
global min = r(min)
mat V=e(V)
local var1=V[1,1]
local var2=V[2,2]
local covar=V[2,1]
twoway (function y = _b[ALLlocal] + _b[lnpcnewslocal71ALLlocal]*x, range($min $max)) ///
(function y = _b[ALLlocal] + _b[lnpcnewslocal71ALLlocal]*x + 1.64*(`var1'+x^2*`var2'+2*x*`covar')^0.5, range($min $max) lpattern("-")) ///
(function y = _b[ALLlocal] + _b[lnpcnewslocal71ALLlocal]*x - 1.64*(`var1'+x^2*`var2'+2*x*`covar')^0.5, range($min $max) lpattern("-")) ///
(scatter where lnpcnewslocal71 if e(sample), ms(none) mlabel(pipe) mlabpos(0) legend(off)), ///
ytitle("Change in the prop. of villages with high sch. per" "unit change in the prop. of local bureaucrats") xtitle("Log per capita newspaper circulation, 1971") name(z1, replace) ///
legend(off) ylabel(,valuelabel labs(medlarge) nogrid) xlabel(,labsize(medlarge))

