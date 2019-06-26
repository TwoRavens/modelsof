* This is the replication file for the article 						*
* "Leave None to Claim the Land: A Malthusian Catastrophe in Rwanda?" 		*
* Author: Marijke Verpoorten 									*
* Date: November 2011 										* 
*******************************************************************************


clear all
set memory 200000


use "C:\RwandaResearchProject\Repl_Verpoorten2011_JPR\Data_LNTCL_Verpoorten_JPR.dta", replace


* online appendix: calculation of death toll *
**********************************************

run "C:\RwandaResearchProject\Repl_Verpoorten2011_JPR\Appendix_LNTCL_Verpoorten_JPR.do"


* Sample *
**********

use "C:\RwandaResearchProject\Repl_Verpoorten2011_JPR\dataset.dta", clear
generate obs=0
replace obs=1 if popdens91~=.& popgr7891~=.& psinglemale2535com~=.& ptutsi91_com~=.& pop91~=.& disttotown~=.& disttoroad~=.&deathtoll_rem~=.
sort com91
by com91: egen max_obs=max(obs)
sort com91
by com91: generate order=_n
save "C:\RwandaResearchProject\Repl_Verpoorten2011_JPR\dataset.dta", replace

* Figures *
***********

* Figure 1 *

set scheme s1mono
generate deathtollrem_100=deathtoll_rem*100
graph twoway kdensity deathtollrem_100, lpattern(solid) lwidth(medthick) xtitle("Death toll (%)") ytitle(" ") legend(pos(3) ring(0) col(1) lab(1 "WEMI") region(fcolor(gs15)))

* Figure 2 *

keep idsector deathtoll_rem
xtile deathtoll_5=deathtoll_rem, nq(5)
sort idsector
* transfer to dbase, open geoda and plot on map *

* Figure 3 *

use "C:\RwandaResearchProject\Repl_Verpoorten2011_JPR\dataset.dta", clear
set scheme s1mono
label variable popdens91 "Population density"
graph twoway kdensity popdens91 if obs==1, lpattern(solid) lwidth(medthick) xtitle("1991 population density") ytitle(" ") legend(pos(3) ring(0) col(1) lab(1 "WEMI") region(fcolor(gs15)))
label variable popgr7891 "Population growth"
graph twoway kdensity popgr7891 if max_obs==1&order==1, lpattern(solid) lwidth(medthick) xtitle("1978-91 population growth") ytitle(" ") legend(pos(3) ring(0) col(1) lab(1 "WEMI") region(fcolor(gs15)))
graph twoway kdensity psinglemale2535com if max_obs==1&order==1, lpattern(solid) lwidth(medthick) xtitle("Young (25-35) single men") ytitle(" ") legend(pos(3) ring(0) col(1) lab(1 "WEMI") region(fcolor(gs15)))


* Tables *
**********

* Table 1 *

tabstat ptutsi91_com ptutsi91_com_c deathtoll_rem deathtollc_rem if deathtoll_rem~=., by(pref91) stats(mean)

* Table 2 *

summarize deathtoll_rem popdens91 popgr7891 psinglemale2535com ptutsi91_com pop91 disttotown disttoroad infantmortalitycom ploweducmale1525com pmixedhhtutcom days_RPF if obs==1


* REGRESSION ANALYSIS *

* variables for regression analysis *
generate ldisttotown=log(disttotown)
generate ldisttoroad=log(disttoroad)
generate km2=1/(popdens91/pop91)
sort com91
by com91: egen ldisttotowncom=mean(ldisttotown)
by com91: egen ldisttoroadcom=mean(ldisttoroad)
by com91: egen pop91com=sum(pop91)
by com91: egen km2com=sum(km2)
by com91: egen com_weight=max(order)
generate popdens91com=pop91com/km2com
generate lpop91com=log(pop91com)
replace popdens91com=popdens91com/100
replace popdens91=popdens91/100
generate lpopdens91=log(popdens91)
generate lpop91=log(pop91)
generate psingle=psinglemale2535com
replace infantmortalitycom=infantmortalitycom/1000
summarize infantmortalitycom

sort idsector
summarize obs if obs==1
save "C:\RwandaResearchProject\Repl_Verpoorten2011_JPR\dataset.dta", replace

* Table 3 *
* EQUATION 1: model 1-4 *
*-----------------------*

xi3: regress deathtoll_rem popdens91 i.com91, robust 
	outreg2 using "C:\RwandaResearchProject\Repl_Verpoorten2011_JPR\Table3.xls", dec(3) replace excel cttop(1)
xi3: regress deathtoll_rem popdens91 lpop91 i.com91, robust 
	outreg2 using "C:\RwandaResearchProject\Repl_Verpoorten2011_JPR\Table3.xls", dec(3) excel cttop(2)
xi3: regress deathtoll_rem popdens91 lpop91 ldisttotown i.com91, robust 
	outreg2 using "C:\RwandaResearchProject\Repl_Verpoorten2011_JPR\Table3.xls", dec(3) excel cttop(3)
xi3: regress deathtoll_rem popdens91 lpop91 ldisttotown ldisttoroad i.com91, robust 
	outreg2 using "C:\RwandaResearchProject\Repl_Verpoorten2011_JPR\Table3.xls", dec(3) excel cttop(4)

* Table 4 *
* EQUATION 2: model 5-11*
*-----------------------*
xi3: regress deathtoll_rem popdens91 ptutsi91_com lpop91 ldisttotown ldisttoroad i.pref91, robust 
	outreg2 using "C:\RwandaResearchProject\Repl_Verpoorten2011_JPR\Table4.xls", replace dec(3) excel cttop(5)
xi3: regress deathtoll_rem popgr7891 ptutsi91_com lpop91 ldisttotown ldisttoroad i.pref91, robust 
	outreg2 using "C:\RwandaResearchProject\Repl_Verpoorten2011_JPR\Table4.xls", dec(3) excel cttop(6)
xi3: regress deathtoll_rem psingle ptutsi91_com lpop91 ldisttotown ldisttoroad i.pref91, robust 
	outreg2 using "C:\RwandaResearchProject\Repl_Verpoorten2011_JPR\Table4.xls", dec(3) excel cttop(7)
xi3: regress deathtoll_rem popdens91 popgr7891 ptutsi91_com lpop91 ldisttotown ldisttoroad i.pref91, robust 
	outreg2 using "C:\RwandaResearchProject\Repl_Verpoorten2011_JPR\Table4.xls", dec(3) excel cttop(8)
xi3: regress deathtoll_rem popdens91 psingle ptutsi91_com lpop91 ldisttotown ldisttoroad i.pref91, robust 
	outreg2 using "C:\RwandaResearchProject\Repl_Verpoorten2011_JPR\Table4.xls", dec(3) excel cttop(9)
xi3: regress deathtoll_rem popdens91*popgr7891 ptutsi91_com lpop91 ldisttotown ldisttoroad i.pref91, robust 
	outreg2 using "C:\RwandaResearchProject\Repl_Verpoorten2011_JPR\Table4.xls", dec(3) excel cttop(10)
xi3: regress deathtoll_rem popdens91*psingle ptutsi91_com lpop91 ldisttotown ldisttoroad i.pref91, robust 
	outreg2 using "C:\RwandaResearchProject\Repl_Verpoorten2011_JPR\Table4.xls", dec(3) excel cttop(11)


* Table 5 *
* EQUATION 2: model 5'-11'*
*-------------------------*

xi3: regress deathtoll_rem popdens91 ptutsi91_com lpop91 ldisttotown ldisttoroad infantmortalitycom ploweducmale1525com pmixedhhtutcom i.pref91, robust 
	outreg2 using "C:\RwandaResearchProject\Repl_Verpoorten2011_JPR\Table5.xls", replace dec(3) excel cttop(12)
xi3: regress deathtoll_rem popgr7891 ptutsi91_com lpop91 ldisttotown ldisttoroad infantmortalitycom ploweducmale1525com pmixedhhtutcom i.pref91, robust 
	outreg2 using "C:\RwandaResearchProject\Repl_Verpoorten2011_JPR\Table5.xls", dec(3) excel cttop(13)
xi3: regress deathtoll_rem psingle ptutsi91_com lpop91 ldisttotown ldisttoroad infantmortalitycom ploweducmale1525com pmixedhhtutcom i.pref91, robust 
	outreg2 using "C:\RwandaResearchProject\Repl_Verpoorten2011_JPR\Table5.xls", dec(3) excel cttop(14)
xi3: regress deathtoll_rem popdens91 popgr7891 ptutsi91_com lpop91 ldisttotown ldisttoroad infantmortalitycom ploweducmale1525com pmixedhhtutcom i.pref91, robust 
	outreg2 using "C:\RwandaResearchProject\Repl_Verpoorten2011_JPR\Table5.xls", dec(3) excel cttop(15)
xi3: regress deathtoll_rem popdens91 psingle ptutsi91_com lpop91 ldisttotown ldisttoroad infantmortalitycom ploweducmale1525com pmixedhhtutcom i.pref91, robust 
	outreg2 using "C:\RwandaResearchProject\Repl_Verpoorten2011_JPR\Table5.xls", dec(3) excel cttop(16)
xi3: regress deathtoll_rem popdens91*popgr7891 ptutsi91_com lpop91 ldisttotown ldisttoroad infantmortalitycom ploweducmale1525com pmixedhhtutcom i.pref91, robust 
	outreg2 using "C:\RwandaResearchProject\Repl_Verpoorten2011_JPR\Table5.xls", dec(3) excel cttop(17)
xi3: regress deathtoll_rem popdens91*psingle ptutsi91_com lpop91 ldisttotown ldisttoroad infantmortalitycom ploweducmale1525com pmixedhhtutcom i.pref91, robust 
	outreg2 using "C:\RwandaResearchProject\Repl_Verpoorten2011_JPR\Table5.xls", dec(3) excel cttop(18)

* Table 6 *
* EQUATION 2: robustness checks model 5
*---------------------------------------*

xi3: regress deathtoll_rem lpopdens91 ptutsi91_com lpop91 ldisttotown ldisttoroad i.pref91, robust 
	outreg2 using "C:\RwandaResearchProject\Repl_Verpoorten2011_JPR\Table6.xls", replace dec(3) excel cttop(5)
xi3: regress deathtoll popdens91 ptutsi91_com lpop91 ldisttotown ldisttoroad i.pref91, robust 
	outreg2 using "C:\RwandaResearchProject\Repl_Verpoorten2011_JPR\Table6.xls", dec(3) excel cttop(5)
xi3: regress deathtoll_cen popdens91 ptutsi91_com lpop91 ldisttotown ldisttoroad i.pref91, robust 
	outreg2 using "C:\RwandaResearchProject\Repl_Verpoorten2011_JPR\Table6.xls", dec(3) excel cttop(5)
xi3: regress deathtoll_rem popdens91 ptutsi91_com lpop91 ldisttotown ldisttoroad pmixedhhtutcom i.pref91, robust 
	outreg2 using "C:\RwandaResearchProject\Repl_Verpoorten2011_JPR\Table6.xls", dec(3) excel cttop(5)
xi3: regress deathtoll_rem popdens91 ptutsi91_com lpop91 ldisttotown ldisttoroad days_RPF i.pref91, robust 
	outreg2 using "C:\RwandaResearchProject\Repl_Verpoorten2011_JPR\Table6.xls", dec(3) excel cttop(5)
xi3: regress deathtollcom_rem popdens91com ptutsi91_com lpop91com ldisttotowncom ldisttoroadcom i.pref91 if order==1 [fweight=com_weight], robust 
	outreg2 using "C:\RwandaResearchProject\Repl_Verpoorten2011_JPR\Table6.xls", dec(3)  excel cttop(5)

*end*

