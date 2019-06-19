* this file replicates tables and graphs in 
* Aichele and Felbermayr: "Kyoto and Carbon Leakage: An Analysis of the Bilateral Carbon Content of Trade"
	
******************************************
*********** APPENDIX *********************
******************************************

cd "C:\Users\aichele\Documents\projects\bilateral\submission reconstat\data and code"


*************** Summary statistics **********************


use data_kyotoandleakage_restat, clear

***** Table A-I: Summary statistics covariates
format fta wto eu lcy lpy ldist contig comlang %9.2f
sum fta wto eu lcy lpy ldist contig comlang, format separator(7)

**** Table A-V: Summary statistics of the dependent variables
keep ccode pcode BEIM imp int_imp year category dk

* imp in Million US-dollar
replace imp=imp/1000000
* beim in Million tons of CO2
replace BEIM=BEIM/1000
* int-imp in kg per dollar
replace int_imp=BEIM/imp

la var imp "Imports"
la var int_imp "CO2 intensity imports"
la var BEIM "CO2 content imports"


quietly forvalues i=1(1)12{
local outcome ="imp int_imp BEIM"
foreach x of local outcome{
statsmat `x' if dk==1 & category==`i', stat(mean sd) matrix(sumstat_dk1)
statsmat `x' if dk==0 & category==`i', stat(mean sd) matrix(sumstat_dk0)
statsmat `x' if dk==-1 & category==`i', stat(mean sd)  matrix(sumstat_dkm1)

matrix sumstat_`x'_`i'=sumstat_dk1 , sumstat_dk0 , sumstat_dkm1
}
matrix sumstat_`i'=sumstat_imp_`i' \ sumstat_int_imp_`i' \sumstat_BEIM_`i'
}

matrix cat=(1\ 1\ 1)
matrix sumstat=(cat,sumstat_1)

quietly forvalues i=2(1)12{
matrix cat=(`i'\ `i'\ `i')
matrix sumstat=(sumstat \ cat, sumstat_`i')
}

matrix list sumstat

outtable using sumstat_new , mat(sumstat) replace nobox center format(%9.0f %9.1f)









*************** Regressions **********************

global mrterms "mrdis mrcon mrcom mrwto mrfta mreu"


use data_kyotoandleakage_restat, clear


eststo clear
* Table E-III: First stage to column (5) Table 2
eststo: xtivreg2 dk dkICC lcy lpy fta wto eu $mrterms ttt*, fe rob cluster(sid)
esttab, b(3) se  scalars("N No. of observations" "N_g No. of countrypair-sectors" "r2_a Adj. R$^2$" "F F-statistic") order(dkICC lcy lpy fta wto eu) keep(dkICC lcy lpy fta wto eu) replace starlevels(* 0.1 ** 0.05 *** 0.01) label tex nogaps
estout using TableE-III.csv, cells(b(star fmt(%9.3f)) se(par)) keep(dkICC lcy lpy fta wto eu) stats(N N_g r2_a F , fmt(0 0 3 3 )) style(tab) label legend replace mlabels(dk,  depvars) starlevels(* 0.1 ** 0.05 *** 0.01)



***** Table E-V: Placebo tests: comparison of Kyoto and USA
use data_kyotoandleakage_restat, clear

* comparison with USA
g marker1=1 if nonein==1 & ccode=="USA"
g marker2=1 if nonein==1 & pcode=="USA"
g marker=1 if marker1==1 | marker2==1
drop if nonein==1 & marker==.


drop if bothin==1

eststo clear
eststo: xtreg limp dk  fta wto eu nnn* , fe rob cluster(sid)
eststo: xtreg lint dk  fta wto eu nnn* , fe rob cluster(sid)
eststo: xtreg lCCT_sec dk nnn*, fe rob cluster(sid)
eststo: xtreg lbeim dk fta wto eu nnn* , fe rob cluster(sid)
esttab, b(3) se  scalars("N No. of observations" "N_g No. of countrypair-sectors" "r2_a Adj. R$^2$" "F F-stat" "rmse RMSE" ) order(dk* fta wto eu) keep(dk* fta wto eu) replace starlevels(* 0.1 ** 0.05 *** 0.01) label tex nogaps
estout using TableE-V.csv, cells(b(star fmt(%9.3f)) se(par)) keep(dk fta wto) stats(N N_g r2_a F rmse, fmt(0 0 3 3 3)) style(tab) label legend replace mlabels(limp lint lCCT_sec lbeim,  depvars)  starlevels(* 0.1 ** 0.05 *** 0.01)


***** Table E-VI: Placebo tests: comparison of Kyoto and developed non-Kyoto countries
use data_kyotoandleakage_restat, clear


* comparison with USA, KOR, ISR, AUS
replace ccomm=0 if ccode=="AUS"
replace pcomm=0 if pcode=="AUS"


g marker1=1 if nonein==1 & ccode=="USA"
replace marker1=1 if nonein==1 &( ccode=="KOR" | ccode=="ISR" | ccode=="AUS")
g marker2=1 if nonein==1 & pcode=="USA"
replace marker2=1 if nonein==1 &( pcode=="KOR" | pcode=="ISR" | pcode=="AUS")
g marker=1 if marker1==1 | marker2==1
drop if nonein==1 & marker==.
drop if bothin==1



eststo clear
eststo: xtreg limp dk fta wto eu nnn*, fe rob cluster(sid)
eststo: xtreg lint dk fta wto eu nnn*, fe rob cluster(sid)
eststo: xtreg lCCT_sec dk nnn*, fe rob cluster(sid)
eststo: xtreg lbeim dk fta wto eu nnn*, fe rob cluster(sid)
esttab, b(3) se  scalars("N No. of observations" "N_g No. of countrypair-sectors" "r2_a Adj. R$^2$" "F F-stat" "rmse RMSE" ) order(dk* fta wto eu) keep(dk* fta wto eu) replace starlevels(* 0.1 ** 0.05 *** 0.01) label tex nogaps
estout using TableE-VI.csv, cells(b(star fmt(%9.3f)) se(par)) keep(dk fta wto) stats(N N_g r2_a F rmse, fmt(0 0 3 3 3)) style(tab) label legend replace mlabels(limp lint lCCT_sec lbeim,  depvars) starlevels(* 0.1 ** 0.05 *** 0.01)



***** Table E-VII: Placebo tests: USA as additional Kyoto country

use data_kyotoandleakage_restat, clear

g pkyoto_USA=0
replace pkyoto_USA=1 if year>=2002
g ckyoto_USA=0
replace ckyoto_USA=1 if year>=2002

g dk_USA=dk
replace dk_USA=ckyoto-pkyoto_USA if pcode=="USA"
replace dk_USA=ckyoto_USA-pkyoto if pcode=="USA"

eststo clear
eststo: xtreg limp dk_USA fta wto eu nnn*, fe rob cluster(sid)
eststo: xtreg lint dk_USA fta wto eu nnn*, fe rob cluster(sid)
eststo: xtreg lCCT_sec dk_USA nnn*, fe rob cluster(sid)
eststo: xtreg lbeim dk_USA fta wto eu nnn*, fe rob cluster(sid)

esttab, b(3) se  scalars("N No. of observations" "N_g No. of countrypair-sectors" "r2_a Adj. R$^2$" "F F-stat" "rmse RMSE" ) order(dk* fta wto eu) keep(dk* fta wto eu) replace starlevels(* 0.1 ** 0.05 *** 0.01) label tex nogaps
estout using TableE-VII.csv, cells(b(star fmt(%9.3f)) se(par)) keep(dk_USA fta wto eu) stats(N N_g r2_a F rmse, fmt(0 0 3 3 3)) style(tab) label legend replace mlabels(limp lint lCCT_sec lbeim,  depvars) starlevels(* 0.1 ** 0.05 *** 0.01)



**** Table E-XV: first-difference regressions on pooled data
eststo clear
eststo: xtivreg2 limp dk fta wto eu nnn*, fd rob cluster(sid)
eststo: xtivreg2 lint dk fta wto eu nnn*, fd rob cluster(sid)
eststo: xtivreg2 lCCT_sec dk nnn*, fd rob cluster(sid)
eststo: xtivreg2 lbeim dk fta wto eu nnn*, fd rob cluster(sid)

esttab, b(3) se  scalars("N No. of observations" "N_g No. of countrypair-sectors" "r2_a Adj. R$^2$" "F F-stat" "rmse RMSE" ) order(D.dk* D.fta D.wto D.eu) keep(D.dk* D.fta D.wto D.eu) replace starlevels(* 0.1 ** 0.05 *** 0.01) label tex nogaps
estout using TableE-XV.csv, cells(b(star fmt(%9.3f)) se(par)) keep(dk fta wto eu) stats(N N_g r2_a F rmse, fmt(0 0 3 3 3)) style(tab) label legend replace mlabels(limp lint lCCT_sec lbeim,  depvars) starlevels(* 0.1 ** 0.05 *** 0.01)




