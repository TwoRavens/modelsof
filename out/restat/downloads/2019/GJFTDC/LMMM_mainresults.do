*This file runs the results for Tables 1-6 of "Labor Misallocation and Mass Mobilization: Russian Agriculture during the Great War 

set more off

local directory PUT_PATH_TO_USER'S_FOLDER_HERE
cd "`directory'"

use "`directory'/LMMM_district_farmtype.dta", clear

***********************************
**TABLE 1: Descriptive Statistics**
***********************************


sum agrains vnwfpaagrains awrye aoats commune rpopulation frontprovince rainfall_ytot temp_yavg swrrelpspring horsemobiliz2 

sum mobiliz2 shareapriv1913 communelandgini commune_size1905 shrepartition minorityexits exits_winlose if year==1916 & commune==1

sum allagrmash allagreq if year==1913

*USER SHOULD COPY OUTPUT AND PASTE INTO EXCEL TO PRODUCE TABLE 1.
 

****************************
**TABLES 2-6: Main Results** 
****************************

foreach var in agrains awrye awwheat asrye aswheat aoats abarley  {
gen com`var'=`var'
replace com`var'=0 if commune==0
gen missing_com`var'=(`var'==. & commune==1)
gen priv`var'=`var'
replace priv`var'=0 if commune==1
gen missing_priv`var'=(`var'==. & commune==0)
gen missing`var'=(missing_priv`var'==1 | missing_com`var'==1)
}

collapse (sum) agrains vnwfpaagrains aswheat awwheat awrye asrye aoats  abarley  asgrains awgrains allagreqpc allagrmashpc comagrains comawwheat comaswheat comawrye comasrye comaoats comabarley privawwheat privaswheat privawrye privasrye privaoats privabarley privagrains (mean) european mobiliz0 mobiliz1 horsemobiliz2 lintrend_horses linest_horsemobiliz2 quadest_horsemobiliz2 d_near d_front1916 d_moscow d_warsaw d_spb d_frontprov frontprovince rpopulation lag1rpopulation lag1delta1rpopulation y1913 y1914 y1916 mobiliz2 amissing1916 rainfall_ytot_anymissing temp_yavg_anymissing nomissingweather rainfall_ytot temp_yavg rpop1912 y14* missingagrains missingaswheat missingawwheat missingasrye missingawrye missingabarley missingaoats, by(year iddistrict)

foreach var in agrains awwheat aswheat awrye asrye aoats abarley {
  
replace `var'=. if missing`var'==1
}

replace vnwfpaagrains=. if agrains==.


foreach var in allagreqpc allagrmashpc {

egen m_`var'=mean(`var')
gen dm_`var'=`var'-m_`var'

gen mobiliz2`var'=mobiliz2*dm_`var'

}       

gen period=0 if year==1913
replace period=1 if year==1914
replace period=2 if year==1916

tsset iddistrict period
*********
*Table 2*
*********

*column 1
xtreg  d.agrains mobiliz2 d.lag1rpopulation y19*, robust cl(iddistrict) fe
outreg2 using "`directory'/LMMM_table2.xls", ct(1) bdec(2) bra label replace

*column 2
xtreg  d.vnwfpaagrains mobiliz2 d.lag1rpopulation y19*, robust cl(iddistrict) fe
outreg2 using "`directory'/LMMM_table2.xls", ct(1) bdec(2) bra label


****Continuing to run results using district aggregate data. Below at *Table 2 continued*, the remaining columns of Table 2 are run.

*********
*Table 5*
*********


*Pre-trend analysis

*Table 5, column 1 
reg  d.agrains mobiliz1 d.lag1rpopulation y19* if year<1916, robust cl(iddistrict) 
outreg2 using "`directory'/LMMM_table5.xls", ct(1) bdec(2) bra label replace

*Table 5, column 2 
reg  d.aoats mobiliz1 d.lag1rpopulation y19* if year<1916, robust cl(iddistrict) 
outreg2 using "`directory'/LMMM_table5.xls", ct(1) bdec(2) bra label 

*Table 5, column 3 
reg  d.agrains mobiliz1 d.lag1rpopulation lintrend_horses y19* if year<1916, robust cl(iddistrict) 
outreg2 using "`directory'/LMMM_table5.xls", ct(1) bdec(2) bra label 


*Instrumental variable analysis

*Table 5, column 4          
reg mobiliz1 d_near d_frontprov lag1rpopulation if year==1914 & amissing1916~=1, robust cl(iddistrict)
outreg2 using "`directory'/LMMM_table5.xls", ct(1) bdec(2) bra label

predict ivhat_mobiliz2
gen ivhat_mobiliz1=ivhat_mobiliz2
replace ivhat_mobiliz2=0 if year==1913
replace ivhat_mobiliz2=0 if year==1914
replace ivhat_mobiliz1=0 if year==1913


*Table 5, column 5 
xtreg  d.agrains ivhat_mobiliz2 d.lag1rpopulation y19*, robust cl(iddistrict) fe 
outreg2 using "`directory'/LMMM_table5.xls", ct(1) bdec(2) bra label 

*Table 5, column 6 
xtreg  d.agrains mobiliz2 d.lag1rpopulation d.rainfall_ytot d.temp_yavg y19*, robust cl(iddistrict) fe
outreg2 using "`directory'/LMMM_table5.xls", ct(1) bdec(2) bra label

*Table 5, column 7 
xtreg  d.agrains mobiliz2 frontprovince d.lag1rpopulation  y19*, robust cl(iddistrict) fe
outreg2 using "`directory'/LMMM_table5.xls", ct(1) bdec(2) bra label
    

*Attrition analysis

**First, test for attrition, random or selection on observables


merge m:1 iddistrict using "`directory'/LMMM_weights.dta"

drop _merge

sort period iddistrict

tsset iddistrict period

foreach var in mobiliz0 lag1rpopulation {

gen aAint_`var'=amissing1916*`var'


}


reg agrains mobiliz0 lag1rpopulation amissing1916 aAint* if year==1913, robust cluster(iddistrict)
 
testparm amissing1916 aAint*

**Second, rerun to account for selection on observables.

*Probit regressions to construct weights appearing in weights.dta
*Unrestricted
probit aselected1916 agrains mobiliz0 lag1rpopulation d_front1916 d_moscow d_warsaw d_spb if year==1913, robust 
*Restricted
probit aselected1916 agrains mobiliz0 lag1rpopulation if year==1913, robust 

*Table 5, column 8 
xtreg d.agrains mobiliz2 d.lag1rpopulation y19* [pweight=aAweight],  robust cluster(iddistrict) fe
outreg2 using "`directory'/LMMM_table5.xls", ct(1) bdec(2) bra label

    
**********
**Table 6*
**********

*Table 6, column 1 
xtreg d.agrains horsemobiliz2 d.lag1rpopulation y19* , robust cl(iddistrict) fe
outreg2 using "`directory'/LMMM_table6.xls", ct(1) bdec(2) bra label replace

*Table 6, column 2 
xtreg  d.agrains horsemobiliz2 mobiliz2 d.lag1rpopulation y19* , robust cl(iddistrict) fe
outreg2 using "`directory'/LMMM_table6.xls", ct(1) bdec(2) bra label

*Table 6, column 3 
xtreg  d.agrains linest_horsemobiliz2 d.lag1rpopulation y19* , robust cl(iddistrict) fe
outreg2 using "`directory'/LMMM_table6.xls", ct(1) bdec(2) bra label

*Table 6, column 4 
xtreg  d.agrains linest_horsemobiliz2 mobiliz2 d.lag1rpopulation y19* , robust cl(iddistrict) fe
outreg2 using "`directory'/LMMM_table6.xls", ct(1) bdec(2) bra label

*Table 6, column 5 
xtreg  d.agrains quadest_horsemobiliz2 d.lag1rpopulation y19* , robust cl(iddistrict) fe
outreg2 using "`directory'/LMMM_table6.xls", ct(1) bdec(2) bra label

*Table 6, column 6 
xtreg  d.agrains quadest_horsemobiliz2 mobiliz2 d.lag1rpopulation y19* , robust cl(iddistrict) fe 
outreg2 using "`directory'/LMMM_table6.xls", ct(1) bdec(2) bra label
 
*Table 6, column 7  
xtreg  d.agrains mobiliz2 mobiliz2allagrmashpc d.lag1rpopulation y19* , cl(iddistrict) robust fe
outreg2 using "`directory'/LMMM_table6.xls", ct(1) bdec(2) bra label 

*Table 6, column 8
xtreg  d.agrains mobiliz2  mobiliz2allagreqpc d.lag1rpopulation y19* , cl(iddistrict) robust fe
outreg2 using "`directory'/LMMM_table6.xls", ct(1) bdec(2) bra label 
 

************************************************
************************************************ 
  
use "`directory'/LMMM_district_farmtype.dta", clear
iis iddistrict
tis year

*******************
*Table 2 continued*
*******************


*Table 2, column 3
xtreg  delta1agrains mobiliz2 mobiliz2commun lag1delta1rpopulation y19*, robust cl(iddistrict) fe
outreg2 using "`directory'/LMMM_table2.xls", ct(1) bdec(2) bra label

*Table 2, column 4
xtreg  delta1vnwfpaagrains mobiliz2 mobiliz2commun lag1delta1rpopulation y19*, robust cl(iddistrict) fe
outreg2 using "`directory'/LMMM_table2.xls", ct(1) bdec(2) bra label

*Table 2, column 5
xtreg  delta1agrains mobiliz2 mobiliz2commun mobiliz2shareapriv1913 mobiliz2shareapriv1913commun lag1delta1rpopulation y19*, robust cl(iddistrict) fe
outreg2 using "`directory'/LMMM_table2.xls", ct(1) bdec(2) bra label 

*Table 2, column 6
xtreg  delta1vnwfpaagrains mobiliz2 mobiliz2commun mobiliz2shareapriv1913 mobiliz2shareapriv1913commun lag1delta1rpopulation y19*, robust cl(iddistrict) fe
outreg2 using "`directory'/LMMM_table2.xls", ct(1) bdec(2) bra label

*Table 2, column 7
xtreg  delta1agrains mobiliz2 mobiliz2commun mobiliz2communelandgini mobiliz2communcommunelandgini lag1delta1rpopulation y19*, robust cl(iddistrict) fe
outreg2 using "`directory'/LMMM_table2.xls", ct(1) bdec(2) bra label

*Table 2, column 8
xtreg  delta1vnwfpaagrains mobiliz2 mobiliz2commun mobiliz2communelandgini mobiliz2communcommunelandgini lag1delta1rpopulation y19*, robust cl(iddistrict) fe
outreg2 using "`directory'/LMMM_table2.xls", ct(1) bdec(2) bra label


**********
**Table 3* 
**********

*Table 3, column 1 
xtreg  delta1agrains mobiliz2 mobiliz2commun mobiliz2shrepartition mobiliz2communshrepartition lag1delta1rpopulation y19*, robust cl(iddistrict) fe
outreg2 using "`directory'/LMMM_table3.xls", ct(1) bdec(2) bra label replace

*Table 3, column 2 
xtreg  delta1vnwfpaagrains mobiliz2 mobiliz2commun mobiliz2shrepartition mobiliz2communshrepartition lag1delta1rpopulation y19*, robust cl(iddistrict) fe
outreg2 using "`directory'/LMMM_table3.xls", ct(1) bdec(2) bra label

*Table 3, column 3
xtreg  delta1agrains mobiliz2 mobiliz2commun mobiliz2minorityexits mobiliz2communminorityexits lag1delta1rpopulation y19*, robust cl(iddistrict) fe
outreg2 using "`directory'/LMMM_table3.xls", ct(1) bdec(2) bra label

*Table 3, column 4
xtreg  delta1vnwfpaagrains mobiliz2 mobiliz2commun mobiliz2minorityexits mobiliz2communminorityexits lag1delta1rpopulation y19*, robust cl(iddistrict) fe
outreg2 using "`directory'/LMMM_table3.xls", ct(1) bdec(2) bra label

*Table 3, column 5  
xtreg  delta1agrains mobiliz2 mobiliz2commun mobiliz2exits_winlose mobiliz2communexits_winlose lag1delta1rpopulation y19*, robust cl(iddistrict) fe
outreg2 using "`directory'/LMMM_table3.xls", ct(1) bdec(2) bra label

*Table 3, column 6 
xtreg  delta1vnwfpaagrains mobiliz2 mobiliz2commun mobiliz2exits_winlose mobiliz2communexits_winlose lag1delta1rpopulation y19*, robust cl(iddistrict) fe
outreg2 using "`directory'/LMMM_table3.xls", ct(1) bdec(2) bra label

*Table 3, column 7  
xtreg  delta1agrains mobiliz2 mobiliz2commun mobiliz2comsize1905 mobiliz2communcomsize1905 lag1delta1rpopulation y19* , cl(iddistrict) robust fe
outreg2 using "`directory'/LMMM_table3.xls", ct(1) bdec(2) bra label 

*Table 3, column 8
xtreg  delta1vnwfpaagrains mobiliz2 mobiliz2commun mobiliz2comsize1905 mobiliz2communcomsize1905 lag1delta1rpopulation y19* , cl(iddistrict) robust fe
outreg2 using "`directory'/LMMM_table3.xls", ct(1) bdec(2) bra label 

		
*********
*Table 4*
*********


*Table 4, column 1 
xtreg  delta1awrye mobiliz2 mobiliz2commun lag1delta1rpopulation y19*, robust cl(iddistrict) fe
outreg2 using "`directory'/LMMM_table4.xls", ct(1) bdec(2) bra label replace

*Table 4, column 2 
xtreg  delta1sh_awrye mobiliz2 mobiliz2commun swrrelpspring lag1delta1rpopulation y19*, robust cl(iddistrict) fe
outreg2 using "`directory'/LMMM_table4.xls", ct(1) bdec(2) bra label

*Table 4, column 3 
xtreg  delta1awrye mobiliz2 mobiliz2commun mobiliz2shareapriv1913 mobiliz2shareapriv1913commun lag1delta1rpopulation y19*, robust cl(iddistrict) fe
outreg2 using "`directory'/LMMM_table4.xls", ct(1) bdec(2) bra label

*Table 4, column 4 
xtreg  delta1awrye mobiliz2 mobiliz2commun mobiliz2communelandgini mobiliz2communcommunelandgini lag1delta1rpopulation y19*, robust cl(iddistrict) fe
outreg2 using "`directory'/LMMM_table4.xls", ct(1) bdec(2) bra label

*Table 4, column 5 
xtreg  delta1awrye mobiliz2 mobiliz2commun mobiliz2shrepartition mobiliz2communshrepartition lag1delta1rpopulation y19*, robust cl(iddistrict) fe
outreg2 using "`directory'/LMMM_table4.xls", ct(1) bdec(2) bra label

*Stolypin
*Table 4, column 6 
xtreg  delta1awrye mobiliz2 mobiliz2commun mobiliz2minorityexits mobiliz2communminorityexits lag1delta1rpopulation y19*, robust cl(iddistrict) fe
outreg2 using "`directory'/LMMM_table4.xls", ct(1) bdec(2) bra label

*Table 4, column 7 
xtreg  delta1awrye mobiliz2 mobiliz2commun mobiliz2exits_winlose mobiliz2communexits_winlose lag1delta1rpopulation y19*, robust cl(iddistrict) fe
outreg2 using "`directory'/LMMM_table4.xls", ct(1) bdec(2) bra label

*Table 4, column 8 
xtreg  delta1awrye mobiliz2 mobiliz2commun mobiliz2comsize1905 mobiliz2communcomsize1905 lag1delta1rpopulation y19* , cl(iddistrict) robust fe
outreg2 using "`directory'/LMMM_table4.xls", ct(1) bdec(2) bra label 
				

