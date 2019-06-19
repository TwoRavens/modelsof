***********************************************************************
********* Performs regressions for ************************************
********* A & F,  Review of Economics and Statistics ******************
***********************************************************************



cd "C:\Users\aichele\Documents\projects\bilateral\submission reconstat\data and code"
clear all
set more off
set maxvar 20000
set matsize 10000





****************************************************************
********************* Regressions ******************************
****************************************************************

use data_kyotoandleakage_restat, clear


global mrterms "mrdis mrcon mrcom mrwto mrfta mreu"

global candt ""
local names "ARG AUS AUT BEL BRA CAN CHE CHN CZE DEU DNK ESP EST FIN FRA GBR GRC HUN IDN IND IRL ISR ITA JPN KOR MEX NLD NOR NZL POL PRT RUS SVK SVN SWE TUR USA ZAF ROU CHL" 
foreach x of local names{
 forvalues i=1995(1)2007{
 global candt "$candt nnn`x'_`i'"
 }
 }
 
 macro list candt

 
***********************************************************
****** Table 1: Benchmark: Regressions on pooled data *****
***********************************************************

eststo clear
eststo: xtreg limp dk fta wto eu nnn*, fe rob cluster(sid)
test $candt
eststo: xtreg lint dk fta wto eu nnn*, fe rob cluster(sid)
eststo: xtreg lCCT_sec dk nnn*, fe rob cluster(sid)
eststo: xtreg lbeim dk fta wto eu nnn*, fe rob cluster(sid)

esttab, b(3) se  scalars("N No. of observations" "N_g No. of countrypair-sectors" "r2_a Adj. R$^2$" "F F-stat" "rmse RMSE" ) order(dk* fta wto eu) keep(dk* fta wto eu) replace starlevels(* 0.1 ** 0.05 *** 0.01) label tex nogaps

estout using Table1.csv, cells(b(star fmt(%9.3f)) se(par)) keep(dk fta wto eu) stats(N N_g r2_a F rmse, fmt(0 0 3 3 3)) style(tab) label legend replace mlabels(limp lint lCCT_sec lbeim,  depvars)  starlevels(* 0.1 ** 0.05 *** 0.01)







*************************************************
****** Table 2: Sources of endogeneity bias *****
*************************************************

* Panel a) imports
eststo: reg limp dk lcy lpy fta wto eu $mrterms ldist contig comlang_ethno if year==2006, rob 
eststo: reg limp dk lcy lpy ldist contig comlang_ethno fta wto eu $mrterms ttt*, rob
eststo: xtreg limp dk lcy lpy fta wto eu $mrterms ttt*, fe rob cluster(sid)
eststo: xtivreg2 limp (dk = dkICC) lcy lpy fta wto eu $mrterms ttt*, fe rob cluster(sid) first


esttab  est1 est5 est6 est7 est8, b(3) se  scalars("N No. of observations" "N_g No. of countrypair-sectors" "r2_a Adj. R$^2$" "idp Underid test" "widstat Weak id test") keep(dk ) replace starlevels(* 0.1 ** 0.05 *** 0.01) label tex nogaps
estout est1 est5 est6 est7 est8 using Table2a.csv, cells(b(star fmt(%9.3f)) se(par)) keep(dk) stats(r2_a idp widstat, fmt(3)) style(tab) label legend replace  starlevels(* 0.1 ** 0.05 *** 0.01)

* for Appendix Table E-I
esttab  est1 est5 est6 est7 est8, b(3) se  scalars("N No. of observations" "N_g No. of countrypair-sectors" "r2_a Adj. R$^2$" "idp Underid test" "widstat Weak id test") order(dk lcy lpy ldist  contig comlang_ethno fta wto eu) keep(dk lcy lpy ldist fta wto eu contig comlang_ethno) replace starlevels(* 0.1 ** 0.05 *** 0.01) label tex nogaps
estout est1 est5 est6 est7 est8 using TableE-I.csv, cells(b(star fmt(%9.3f)) se(par)) order(dk lcy lpy ldist  contig comlang_ethno fta wto eu) keep(dk lcy lpy ldist fta wto eu contig comlang_ethno) stats(N N_g r2_a idp widstat, fmt(0 0 3)) style(tab) label legend replace  starlevels(* 0.1 ** 0.05 *** 0.01)


* Panel b) carbon content of imports
eststo: reg lbeim dk lcy lpy fta wto eu $mrterms ldist contig comlang_ethno if year==2006, rob 
eststo: reg lbeim dk lcy lpy ldist contig comlang_ethno fta wto eu $mrterms ttt*, rob
eststo: xtreg lbeim dk lcy lpy fta wto eu $mrterms ttt*, fe rob cluster(sid)
eststo: xtivreg2 lbeim (dk = dkICC) lcy lpy fta wto eu $mrterms ttt*, fe rob cluster(sid) first

esttab est4 est9 est10 est11 est12, b(3) se  scalars("N No. of observations" "N_g No. of countrypair-sectors" "r2_a Adj. R$^2$" "idp Underid test" "widstat Weak id test")  keep(dk ) replace starlevels(* 0.1 ** 0.05 *** 0.01) label tex nogaps
estout est4 est9 est10 est11 est12 using Table2b.csv, cells(b(star fmt(%9.3f)) se(par)) keep(dk) stats(r2_a idp widstat, fmt(3)) style(tab) label legend replace  starlevels(* 0.1 ** 0.05 *** 0.01)

* for Appendix Table E-II
esttab est4 est9 est10 est11 est12, b(3) se  scalars("N No. of observations" "N_g No. of countrypair-sectors" "r2_a Adj. R$^2$" "idp Underid test" "widstat Weak id test") order(dk lcy lpy ldist contig comlang_ethno fta wto eu) keep(dk lcy lpy ldist fta wto eu contig comlang_ethno) replace starlevels(* 0.1 ** 0.05 *** 0.01) label tex nogaps
estout est4 est9 est10 est11 est12 using TableE-II.csv, cells(b(star fmt(%9.3f)) se(par)) order(dk lcy lpy ldist  contig comlang_ethno fta wto eu) keep(dk lcy lpy ldist fta wto eu contig comlang_ethno) stats(N N_g r2_a idp widstat, fmt(0 0 3)) style(tab) label legend replace starlevels(* 0.1 ** 0.05 *** 0.01)





************************************
****** Table 3: Placebo tests ******
************************************


**** Panel A: Ln imports
* Columns (1)-(3): fictitious Kyoto ratification dates
eststo clear
use data_kyotoandleakage_restat, clear
forvalues i=1997(1)1998{
g dk_alt_`i'=0
replace dk_alt_`i'=1 if impin==1 & year>=`i'
replace dk_alt_`i'=-1 if expin==1 & year>=`i'
label var dk_alt_`i' "Kyoto_m-Kyoto_x"
}
forvalues i=1997(1)1998{
eststo: xtreg limp dk_alt_`i' fta wto eu nnn* if year<2001, fe rob cluster(sid)
}

use work_beim2_long_placebo1997, clear
eststo: quietly xtreg limp dk fta wto eu ttt* nnn*   ,fe rob cluster(sid)

* Table E-IV Panel A in Appendix
esttab, b(3) se  scalars("N No. of observations" "N_g No. of countrypair-sectors" "r2_a Adj. R$^2$" "F F-stat" "rmse RMSE" ) order(dk* fta wto eu) keep(dk* fta wto eu) replace starlevels(* 0.1 ** 0.05 *** 0.01) label tex nogaps
estout using TableE-IVa.csv, cells(b(star fmt(%9.3f)) se(par)) keep(dk* fta wto) order(dk_alt* dk) stats(r2_a, fmt(3)) style(tab) label legend replace starlevels(* 0.1 ** 0.05 *** 0.01)



* Columns (4): Comparison with USA
use data_kyotoandleakage_restat, clear

g marker1=1 if nonein==1 & ccode=="USA"
g marker2=1 if nonein==1 & pcode=="USA"
g marker=1 if marker1==1 | marker2==1
drop if nonein==1 & marker==.
drop if bothin==1

eststo: xtreg limp dk fta wto eu nnn*, fe rob cluster(sid)

* Columns (5): Comparison with USA, KOR, ISR, AUS
use data_kyotoandleakage_restat, clear

replace ccomm=0 if ccode=="AUS"
replace pcomm=0 if pcode=="AUS"

g marker1=1 if nonein==1 & ccode=="USA"
replace marker1=1 if nonein==1 &( ccode=="KOR" | ccode=="ISR" | ccode=="AUS")
g marker2=1 if nonein==1 & pcode=="USA"
replace marker2=1 if nonein==1 &( pcode=="KOR" | pcode=="ISR" | pcode=="AUS")
g marker=1 if marker1==1 | marker2==1
drop if nonein==1 & marker==.
drop if bothin==1


eststo: xtreg limp dk fta wto eu nnn*, fe rob cluster(sid)

* Columns (6): USA as additional Kyoto country
use data_kyotoandleakage_restat, clear

g pkyoto_USA=0
replace pkyoto_USA=1 if year>=2002
g ckyoto_USA=0
replace ckyoto_USA=1 if year>=2002

g dk_USA=dk
replace dk_USA=ckyoto-pkyoto_USA if pcode=="USA"
replace dk_USA=ckyoto_USA-pkyoto if pcode=="USA"

eststo: xtreg limp dk_USA fta wto eu nnn*, fe rob cluster(sid)


esttab, b(3) se  scalars("N No. of observations" "N_g No. of countrypair-sectors" "r2_a Adj. R$^2$" "F F-stat" "rmse RMSE" ) keep(dk*) replace starlevels(* 0.1 ** 0.05 *** 0.01) label tex nogaps
estout using Table3a.csv, cells(b(star fmt(%9.3f)) se(par)) keep(dk*) stats(r2_a, fmt(3)) style(tab) label legend replace starlevels(* 0.1 ** 0.05 *** 0.01)



**** Panel B: Ln CO2 intensity

eststo clear
use data_kyotoandleakage_restat, clear
forvalues i=1997(1)1998{
g dk_alt_`i'=0
replace dk_alt_`i'=1 if impin==1 & year>=`i'
replace dk_alt_`i'=-1 if expin==1 & year>=`i'
label var dk_alt_`i' "Kyoto_m-Kyoto_x"
}
forvalues i=1997(1)1998{
eststo: xtreg lint dk_alt_`i' fta wto eu nnn* if year<2001, fe rob cluster(sid)
}

use work_beim2_long_placebo1997, clear
eststo: quietly xtreg lint dk fta wto eu ttt* nnn*   ,fe rob cluster(sid)

* Table E-IV Panel B in Appendix
esttab , b(3) se  scalars("N No. of observations" "N_g No. of countrypair-sectors" "r2_a Adj. R$^2$" "F F-stat" "rmse RMSE" ) order(dk* fta wto) keep(dk* fta wto) replace starlevels(* 0.1 ** 0.05 *** 0.01) label tex nogaps
estout using TableE-IVb.csv, cells(b(star fmt(%9.3f)) se(par)) keep(dk* fta wto) order(dk_alt* dk) stats(r2_a, fmt(3)) style(tab) label legend replace starlevels(* 0.1 ** 0.05 *** 0.01)


* comparison with USA
use data_kyotoandleakage_restat, clear

g marker1=1 if nonein==1 & ccode=="USA"
g marker2=1 if nonein==1 & pcode=="USA"
g marker=1 if marker1==1 | marker2==1
drop if nonein==1 & marker==.
drop if bothin==1

eststo: xtreg lint dk fta wto eu nnn*, fe rob cluster(sid)

* comparison with USA, KOR, ISR, AUS
use data_kyotoandleakage_restat, clear

replace ccomm=0 if ccode=="AUS"
replace pcomm=0 if pcode=="AUS"

g marker1=1 if nonein==1 & ccode=="USA"
replace marker1=1 if nonein==1 &( ccode=="KOR" | ccode=="ISR" | ccode=="AUS")
g marker2=1 if nonein==1 & pcode=="USA"
replace marker2=1 if nonein==1 &( pcode=="KOR" | pcode=="ISR" | pcode=="AUS")
g marker=1 if marker1==1 | marker2==1
drop if nonein==1 & marker==.
drop if bothin==1


eststo: xtreg lint dk fta wto eu nnn*, fe rob cluster(sid)

* USA as additional Kyoto country
use data_kyotoandleakage_restat, clear

g pkyoto_USA=0
replace pkyoto_USA=1 if year>=2002
g ckyoto_USA=0
replace ckyoto_USA=1 if year>=2002

g dk_USA=dk
replace dk_USA=ckyoto-pkyoto_USA if pcode=="USA"
replace dk_USA=ckyoto_USA-pkyoto if pcode=="USA"

eststo: xtreg lint dk_USA fta wto eu nnn*, fe rob cluster(sid)

esttab, b(3) se  scalars("N No. of observations" "N_g No. of countrypair-sectors" "r2_a Adj. R$^2$" "F F-stat" "rmse RMSE" ) keep(dk*) replace starlevels(* 0.1 ** 0.05 *** 0.01) label tex nogaps
estout using Table3b.csv, cells(b(star fmt(%9.3f)) se(par)) keep(dk*) order(dk_alt* dk) stats(r2_a, fmt(3)) style(tab) label legend replace starlevels(* 0.1 ** 0.05 *** 0.01)


****** Panel C: Ln bilateral CO2 imports

use data_kyotoandleakage_restat, clear
eststo clear
forvalues i=1997(1)1998{
g dk_alt_`i'=0
replace dk_alt_`i'=1 if impin==1 & year>=`i'
replace dk_alt_`i'=-1 if expin==1 & year>=`i'
label var dk_alt_`i' "Kyoto_m-Kyoto_x"
}
forvalues i=1997(1)1998{
eststo: xtreg lbeim dk_alt_`i' fta wto eu nnn* if year<2001, fe rob cluster(sid)
}

use work_beim2_long_placebo1997, clear
eststo: quietly xtreg lbeim dk fta wto eu ttt* nnn*   ,fe rob cluster(sid)


* Table E-IV Panel C in Appendix
esttab, b(3) se  scalars("N No. of observations" "N_g No. of countrypair-sectors" "r2_a Adj. R$^2$" "F F-stat" "rmse RMSE" ) order(dk* fta wto eu) keep(dk* fta wto eu) replace starlevels(* 0.1 ** 0.05 *** 0.01) label tex nogaps
estout using TableE-IVc.csv, cells(b(star fmt(%9.3f)) se(par)) keep(dk dk_alt* fta wto) order(dk_alt* dk  fta wto) stats(r2_a, fmt(3)) style(tab) label legend replace starlevels(* 0.1 ** 0.05 *** 0.01)

* comparison with USA
use data_kyotoandleakage_restat, clear

g marker1=1 if nonein==1 & ccode=="USA"
g marker2=1 if nonein==1 & pcode=="USA"
g marker=1 if marker1==1 | marker2==1
drop if nonein==1 & marker==.
drop if bothin==1

eststo: xtreg lbeim dk fta wto eu nnn*, fe rob cluster(sid)

* comparison with USA, KOR, ISR, AUS
use data_kyotoandleakage_restat, clear

replace ccomm=0 if ccode=="AUS"
replace pcomm=0 if pcode=="AUS"

g marker1=1 if nonein==1 & ccode=="USA"
replace marker1=1 if nonein==1 &( ccode=="KOR" | ccode=="ISR" | ccode=="AUS")
g marker2=1 if nonein==1 & pcode=="USA"
replace marker2=1 if nonein==1 &( pcode=="KOR" | pcode=="ISR" | pcode=="AUS")
g marker=1 if marker1==1 | marker2==1
drop if nonein==1 & marker==.
drop if bothin==1


eststo: xtreg lbeim dk fta wto eu nnn*, fe rob cluster(sid)

* USA as additional Kyoto country
use data_kyotoandleakage_restat, clear

g pkyoto_USA=0
replace pkyoto_USA=1 if year>=2002
g ckyoto_USA=0
replace ckyoto_USA=1 if year>=2002

g dk_USA=dk
replace dk_USA=ckyoto-pkyoto_USA if pcode=="USA"
replace dk_USA=ckyoto_USA-pkyoto if pcode=="USA"

eststo: xtreg lbeim dk_USA fta wto eu nnn*, fe rob cluster(sid)

esttab, b(3) se  scalars("N No. of observations" "N_g No. of countrypair-sectors" "r2_a Adj. R$^2$" "F F-stat" "rmse RMSE" ) keep(dk*) replace starlevels(* 0.1 ** 0.05 *** 0.01) label tex nogaps
estout using Table3c.csv, cells(b(star fmt(%9.3f)) se(par)) keep(dk*) order(dk_alt* dk) stats(r2_a, fmt(3)) style(tab) label legend replace starlevels(* 0.1 ** 0.05 *** 0.01)







******************************************************************
***** Table 4: Regressions on Pooled Data, Robustness Checks *****
******************************************************************

use data_kyotoandleakage_restat, clear
set more off
eststo clear

g CCT_sec_mrio= (BEEX_mrio/exp) / (BEIM_mrio/imp)
g lCTT_sec_mrio=ln(CCT_sec_mrio)

*Panel A: Alternative measures of CO2 imports

* MRIO
eststo: quietly xtreg lint2 dk fta wto eu nnn* ,fe rob cluster(sid)
eststo: quietly xtreg lCTT_sec_mrio dk nnn* ,fe rob cluster(sid)
eststo: quietly xtreg lmrio dk fta wto eu nnn* ,fe rob cluster(sid)

* IO-fixed 2000

eststo: quietly xtreg ltech dk fta wto eu ttt* nnn* ,fe rob cluster(sid)

g ltechmrio=ln(BEIM_m_iofix)

eststo: quietly xtreg ltechmrio dk fta wto eu ttt* nnn* ,fe rob cluster(sid)

label var dk "Kyoto_m-Kyoto_x"
label var eu "Joint EU (0,1)"
label var wto "Joint WTO (0,1)"
label var fta "FTA (0,1)"

esttab, b(3) se  scalars("N Observations" "r2_a Adj. R$^2$") keep(dk) replace starlevels(* 0.1 ** 0.05 *** 0.01) label tex nogaps
estout using Table4a.csv, cells(b(star fmt(%9.3f)) se(par)) keep(dk) stats(N r2_a, fmt(0 3)) style(tab) label legend replace starlevels(* 0.1 ** 0.05 *** 0.01)

* Table E-VIII in Appendix
esttab, b(3) se  scalars("N Observations" "r2_a Adj. R$^2$") keep(dk) replace starlevels(* 0.1 ** 0.05 *** 0.01) label tex nogaps
estout using TableE-VIII.csv, cells(b(star fmt(%9.3f)) se(par)) order(dk fta wto eu) keep(dk fta wto eu) stats(N r2_a, fmt(0 3)) style(tab) label legend replace starlevels(* 0.1 ** 0.05 *** 0.01)



*Panel B: Alternative sample and aggregate data
** w/o China & transition countries
eststo clear

use data_kyotoandleakage_restat, clear

eststo: quietly xtreg limp dk fta wto eu nnn*   if pcode!="CHN" & ccode!="CHN" & trans==0,fe rob cluster(sid)
eststo: quietly xtreg lCCT_sec dk nnn*   if pcode!="CHN" & ccode!="CHN" & trans==0,fe rob cluster(sid)
eststo: quietly xtreg lbeim dk fta wto eu nnn*   if pcode!="CHN" & ccode!="CHN" & trans==0,fe rob cluster(sid)


** aggregate bilateral data
use data_aggregate.dta, clear


eststo: quietly xtreg laggimp dk fta wto eu nnn* , fe rob cluster(iddi)
eststo: quietly xtreg laggCTT dk nnn*                 , fe rob cluster(iddi)
eststo: quietly xtreg laggbeim dk fta wto eu nnn* , fe rob cluster(iddi)


esttab, b(3) se  scalars("N Observations" "r2_a Adj. R$^2$") order(dk fta wto eu) keep(dk fta wto eu) replace starlevels(* 0.1 ** 0.05 *** 0.01) label tex nogaps
estout using Table4b.csv, cells(b(star fmt(%9.3f)) se(par)) keep(dk) stats(N r2_a, fmt(0 3)) style(tab) label legend replace starlevels(* 0.1 ** 0.05 *** 0.01) mlabels(limp lCCT_sec lbeim laggimp laggCTT laggbeim, depvars)
* Table E-IX in Appendix
esttab, b(3) se  scalars("N Observations" "r2_a Adj. R$^2$") keep(dk) replace starlevels(* 0.1 ** 0.05 *** 0.01) label tex nogaps
estout using TableE-IX.csv, cells(b(star fmt(%9.3f)) se(par)) order(dk fta wto eu) keep(dk fta wto eu) stats(N r2_a, fmt(0 3)) style(tab) label legend replace starlevels(* 0.1 ** 0.05 *** 0.01) mlabels(limp lCCT_sec lbeim laggimp laggCTT laggbeim, depvars)


* Panel C: Alternative estimators
** Long diff-in-diff

eststo clear
u work_beim2_long, clear
eststo: quietly xtreg limp dk fta wto eu ttt* nnn*   ,fe rob cluster(sid)
eststo: quietly xtreg lCTT_sec dk fta wto eu ttt* nnn*   ,fe rob cluster(sid)
eststo: quietly xtreg lbeim dk fta wto eu ttt* nnn*  ,fe rob cluster(sid)


** PPML

use work_beim_poisson2, clear

sum imp BEIM int_imp

g sc_imp=imp/1000000000
g sc_BEIM=BEIM/10000000
replace int_imp=. if int_imp<0

quietly forvalues y=1995(1)2007 {
	forvalues i=1(1)12 {
		g sss`i'_`y'=0
		replace sss`i'_`y'=1 if category==`i' & year==`y'
	}
}

sum sc_*

* the following sector-and-year dummies are collinear (from xtreg of the same specification as below) and are therefore dropped, otherwise not concave
local collinea "sss1_2007 sss2_2007 sss3_2007 sss4_2007 sss5_2007 sss6_2007 sss7_2007 sss8_2007 sss9_2007 sss10_2007 sss11_2007 sss12_2007"
foreach x of local collinea{
drop `x'
}


drop if BEIM==.

* estimation with sector-and-year dummies
set seed 10101
eststo: xtpqml sc_imp dk lcy lpy fta wto eu $mrterms sss* if lbeim~=., fe i(sid) cluster(sid)
set seed 10101
eststo: xtpqml sc_imp dk lcy lpy fta wto eu $mrterms sss*, fe i(sid) cluster(sid)
set seed 10101
eststo: xtpqml sc_BEIM dk lcy lpy fta wto eu $mrterms sss*, fe i(sid) cluster(sid)


label var dk "Kyoto_m-Kyoto_x"
label var eu "Joint EU (0,1)"
label var wto "Joint WTO (0,1)"
label var fta "FTA (0,1)"
label var lcy "ln GDP_m"
label var lpy "ln GDP_x"

esttab , b(3) se  scalars("N No. of observations" "N_g No. of countrypair-sectors" "ll Log likelihood" "r2_p Pseudo R$^2$" "r2_a Adj. R$^2$") order(dk* lcy lpy fta wto eu) keep(dk* lcy lpy fta wto eu) replace starlevels(* 0.1 ** 0.05 *** 0.01) label tex nogaps
estout using Table4c.csv, cells(b(star fmt(%9.3f)) se(par)) keep(dk) stats(N r2_a ll, fmt(0 3 0)) style(tab) label legend replace mlabels(limp lCCT_sec lbeim sc_imp sc_imp sc_BEIM, depvars) starlevels(* 0.1 ** 0.05 *** 0.01)
* Table E-X in Appendix
esttab , b(3) se  scalars("N No. of observations" "N_g No. of countrypair-sectors" "r2_a Adj. R$^2$" "ll Log likelihood") order(dk lcy lpy fta wto eu) keep(dk lcy lpy fta wto eu) replace starlevels(* 0.1 ** 0.05 *** 0.01) label tex nogaps
estout using TableE-X.csv, cells(b(star fmt(%9.3f)) se(par)) order(dk lcy lpy fta wto eu) keep(dk lcy lpy fta wto eu) stats(N N_g r2_a ll, fmt(0 0 3 0)) style(tab) label legend replace mlabels(limp lCCT_sec lbeim sc_imp sc_imp sc_BEIM, depvars) starlevels(* 0.1 ** 0.05 *** 0.01)






**************************************************************************
***** Table 5: Sector-by-sector regressions: differential commitment *****
**************************************************************************


clear all



* Sector-by-sector: differential commitment


eststo clear
set more off
forvalues x = 1/12 {
		use data_kyotoandleakage_restat, clear
		keep  if cate==`x'
		tsset sid year
		eststo: quietly xtreg limp dk  fta wto eu nnn* , fe robust cluster(sid)
		use work_beim2_long, clear
		keep if cate==`x'
		tsset sid per
		eststo: quietly xtreg limp dk  fta wto eu nnn* , fe robust cluster(sid)
		use data_kyotoandleakage_restat, clear
		keep if cate==`x'
		tsset sid year
		eststo: quietly xtreg lint dk  fta wto eu nnn* , fe robust cluster(sid)
		use work_beim2_long, clear
		keep if cate==`x'
		tsset sid per
		eststo: quietly xtreg lint dk  fta wto eu nnn* , fe robust cluster(sid)
		use data_kyotoandleakage_restat, clear
		keep if cate==`x'
		tsset sid year
		eststo: quietly xtreg lCCT_sec dk  fta wto eu nnn*, fe robust cluster(sid)
		use work_beim2_long, clear
		keep if cate==`x'
		tsset sid per
		g lCCT_sec=ln(CCT_sec)
		eststo: quietly xtreg lCCT_sec dk  fta wto eu nnn* , fe robust cluster(sid)
		use data_kyotoandleakage_restat, clear
		keep if cate==`x'
		tsset sid year
		eststo: quietly xtreg lbeim dk  fta wto eu nnn* , fe robust cluster(sid)
		use work_beim2_long, clear
		keep if cate==`x'
		tsset sid per
		eststo: quietly xtreg lbeim dk  fta wto eu nnn* , fe robust cluster(sid)
		display "Sector: " `x'
		label var fta "Joint FTA (0,1)"
        label var wto "Joint WTO (0,1)"
        label var eu "Joint EU (0,1)"
        label var dk "Kyoto_m-Kyoto_x"
		* Table E-XI to E-XIV in Appendix
		esttab, b(2) se  scalars("N Observations" "r2_a Adj. R$^2$")  keep(dk fta wto eu) starlevels(* 0.1 ** 0.05 *** 0.01) tex label
		estout using TableE-XI_`x'.csv, cells(b(star fmt(%9.3f)) se(par)) keep(dk fta wto eu) stats(N r2_a, fmt(0 3 0)) style(tab) label legend replace mlabels(limp lint lCCT_sec lbeim, depvars)  starlevels(* 0.1 ** 0.05 *** 0.01)
		eststo drop est5 est6
		esttab, b(2) se  scalars("N Observations" "r2_a Adj. R$^2$")  keep(dk) starlevels(* 0.1 ** 0.05 *** 0.01) tex label
		estout using Table5_`x'.csv, cells(b(star fmt(%9.3f)) se(par)) keep(dk) style(tab) label legend replace mlabels(limp lint lbeim, depvars)  starlevels(* 0.1 ** 0.05 *** 0.01)
		eststo clear
        }

		
	
	


********************************************************************************
*************** Figure 1: Differential Kyoto commitment ************************
*************** and imports, carbon intensity and carbon content of trade ******
********************************************************************************

use data_kyotoandleakage_restat, clear

replace ckyoto=0 if ccode=="AUS"
replace pkyoto=0 if pcode=="AUS"


g per=0 if year>=1997 & year<=2000
replace per =1 if year >=2004  & year<=2007
g pair=ccode+"-"+pcode


collapse (mean) lbeim limp lint, by(pair ccode pcode per ckyoto pkyoto)
g dk=ckyoto-pkyoto

egen pairid=group(ccode pcode)
drop if per==.

tsset pairid per


gen Dlbeim=D.lbeim
g Dlimp=D.limp
g Dlint=D.lint

bysort dk: sum Dlbeim Dlimp Dlint

reg Dlimp dk, rob
reg Dlint dk, rob
reg Dlbeim dk, rob

drop lbeim lint limp


reshape long D, i(ccode pcode per pair ckyoto pkyoto dk pairid) j(outcome) string
replace outcome="lzbeim" if outcome=="lbeim"

reg D dk if outcome=="limp", rob
reg D dk if outcome=="lint", rob
reg D dk if outcome=="lzbeim", rob


egen meanD=mean(D), by(dk outcome)

twoway (lfitci D dk if outcome=="limp", clcolor(black) clwidth(medthick)) (dropline meanD dk if outcome=="limp", msymbol(i) lwidth(vvvthick) lcolor(black) lpattern(solid)) ,  xtitle("")   legend(off) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) saving(fig1_limp,replace) title("Ln imports", color(black) size(medsize)) xlabel(#2, labels ticks tlcolor(black)) ytitle("Average difference between pre- and post-treatment average") note("Kyoto coeff. (std.err.): 0.11*** (0.03)")
twoway (lfitci D dk if outcome=="lint", clcolor(black) clwidth(medthick)) (dropline meanD dk if outcome=="lint", msymbol(i) lwidth(vvvthick) lcolor(black) lpattern(solid)) ,  xtitle("")   legend(off) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) saving(fig1_lint,replace) title("Ln carbon intensity", color(black) size(medsize)) xlabel(#2, labels ticks tlcolor(black)) note("0.06*** (0.01)")
twoway (lfitci D dk if outcome=="lzbeim", clcolor(black) clwidth(medthick)) (dropline meanD dk if outcome=="lzbeim", msymbol(i) lwidth(vvvthick) lcolor(black) lpattern(solid)) ,  xtitle("")   legend(off) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) saving(fig1_lbeim,replace) title("Ln carbon imports", color(black) size(medsize)) xlabel(#2, labels ticks tlcolor(black)) note("0.16*** (0.03)") 

graph combine "fig1_limp.gph" "fig1_lint.gph" "fig1_lbeim.gph", saving(fig1, replace) rows(1) ycommon graphregion(color(white)) 
graph export fig1.eps, as(eps) replace

