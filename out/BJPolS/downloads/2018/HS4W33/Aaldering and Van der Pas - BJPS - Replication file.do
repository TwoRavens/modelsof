
*********************************************
** Analyses BJPS Aaldering and Van der Pas **
*********************************************

**************************
** Figure 1: Party size **
**************************
use ".../Replication File 1 - Aaldering and Van der Pas - BJPS (party size).dta", clear

net install scheme_tufte.pkg
drop if function==1
collapse (mean) partysize (first) gender, by(leader)	
gen sortvar = 1/partysize
sort sortvar
drop sortvar

gen count = _n
gen partysize_m = partysize if gender=="m"
gen partysize_f = partysize if gender=="f"

twoway || bar partysize_m count, barw(.84) col(gs13) lw(none) fi(100) ///
		|| bar  partysize_f count, barw(.84) col(gs5)  lw(none) fi(100) || ///
		, scheme(tufte) legend(order(1 "Male" 2 "Female") cols(2))  ///
		xtitle("") ytitle("Average Party Size" "in Parliamentary Seats") ///
		xlabel(1 "Balkenende (CDA)" 2 "Bos (PvdA)" 3 "Cohen (PvdA)" 4 "Samsom (PvdA)" 5 "Rutte (VVD)" ///
		6 "Kant (SP)" 7 "Zalm (VVD)" 8 "Marijnissen (SP)" 9 "Buma (CDA)" 10 "Verhagen (CDA)" ///
		11 "Roemer (SP)" 12 "Wilders (PVV)" 13 "Sap (GrL)" 14 "Verdonk (ToN)" 15 "Halsema (GrL)" ///
		16 "Pechtold (D66)" 17 "Rouvoet (CU)" 18 "Slob (CU)" 19 "Van der Vlies (SGP)" ///
		20 "Van der Staaij (SGP)" 21 "Thieme (PvdD)" , angle(55)) 

********************
** Main Analayses **
********************
use ".../Replication File 2 - Aaldering and Van der Pas - BJPS (main analyses).dta", clear

net install scheme_tufte.pkg
ssc inst egenmore	

gen l1_visibility = l.visibility
gen l2_visibility = l2.visibility
gen l3_visibility = l3.visibility
gen l4_visibility = l4.visibility
gen l_crapos = l.crapos
gen l_craneg = l.craneg
gen l_vigpos = l.vigpos
gen l_compos = l.compos
gen l_intneg = l.intneg
gen l_totpos = l.totneg
gen l_totneg = l.totneg
gen count = _n

** rename trait variables
rename polcraftotaal cratot
rename vigtotaal vigtot
rename inttotaal inttot
rename commtotaal comtot
rename contotaal contot
rename totaltotal1 tottot

* lagged dependent variables
foreach var of varlist *tot {
	gen l_`var' = l.`var'
}

*******************************
*** Table 1: Leaders traits ***
*******************************

jackknife, cluster(leadernr): xtpcse cratot l_cratot partysize doublefunc i.sex if function!=1, pairwise // p0.004
estimates store LeiderMain1
margins sex

jackknife, cluster(leadernr): xtpcse vigtot l_vigtot  partysize doublefunc i.sex if function!=1, pairwise // p0.030
estimates store LeiderMain2
margins sex

jackknife, cluster(leadernr): xtpcse inttot l_inttot 		  partysize doublefunc i.sex if function!=1, pairwise
estimates store LeiderMain3
margins sex

jackknife, cluster(leadernr): xtpcse comtot 		  partysize doublefunc i.sex if function!=1, pairwise // p0.049
estimates store LeiderMain4
margins sex

jackknife, cluster(leadernr): xtpcse contot  		partysize doublefunc i.sex if function!=1, pairwise
estimates store LeiderMain5
margins sex
	
****************************************************
*** Table 2: Leader traits positive and negative ***
****************************************************

jackknife, cluster(leadernr): xtpcse crapos partysize doublefunc i.sex if function!=1, pairwise 
estimates store LeiderPosNeg1
margins sex

jackknife, cluster(leadernr): xtpcse vigpos l_vigpos  partysize doublefunc i.sex if function!=1, pairwise // * sign (neg eff)
estimates store LeiderPosNeg2
margins sex

jackknife, cluster(leadernr): xtpcse intpos 		  partysize doublefunc i.sex if function!=1, pairwise
estimates store LeiderPosNeg3
margins sex

jackknife, cluster(leadernr): xtpcse compos 		  partysize doublefunc i.sex if function!=1, pairwise // † eenzijdig sign (neg eff)
estimates store LeiderPosNeg4
margins sex

jackknife, cluster(leadernr): xtpcse conpos 		  partysize doublefunc i.sex if function!=1, pairwise
estimates store LeiderPosNeg5
margins sex

jackknife, cluster(leadernr): xtpcse craneg l_craneg partysize doublefunc i.sex if function!=1, pairwise 
estimates store LeiderPosNeg7
margins sex

jackknife, cluster(leadernr): xtpcse vigneg 		partysize doublefunc i.sex if function!=1, pairwise // * sign (neg eff)
estimates store LeiderPosNeg8
margins sex

jackknife, cluster(leadernr): xtpcse intneg 		  partysize doublefunc i.sex if function!=1, pairwise
estimates store LeiderPosNeg9
margins sex

jackknife, cluster(leadernr): xtpcse comneg 		  partysize doublefunc i.sex if function!=1, pairwise // † eenzijdig sign (neg eff)
estimates store LeiderPosNeg10
margins sex

jackknife, cluster(leadernr): xtpcse conneg 		  partysize doublefunc i.sex if function!=1, pairwise
estimates store LeiderPosNeg11
margins sex
		
*****************************************************************
*** Table 3 and Figure 2: Leaders traits, routine vs campaign ***
*****************************************************************

jackknife, cluster(leadernr): xtpcse cratot l_cratot	  c.partysize##i.campaign doublefunc i.sex##i.campaign if function!=1, pairwise
estimates store LeiderCamp1
margins, dydx(sex) at(campaign=(0 1))
mat table =  r(table)
gen	mean_cratot_r = table[1,3]  
gen mean_cratot_c = table[1,4]  
gen	lb_cratot_r   = table[5,3] 
gen lb_cratot_c   = table[5,4] 
gen	ub_cratot_r   = table[6,3] 
gen ub_cratot_c   = table[6,4] 

jackknife, cluster(leadernr): xtpcse vigtot l_vigtot  c.partysize##i.campaign doublefunc i.sex##i.campaign if function!=1, pairwise
estimates store LeiderCamp2
margins, dydx(sex) at(campaign=(0 1))
mat table =  r(table)
gen	mean_vigtot_r = table[1,3]  
gen mean_vigtot_c = table[1,4]  
gen	lb_vigtot_r   = table[5,3]  
gen lb_vigtot_c   = table[5,4] 
gen	ub_vigtot_r   = table[6,3] 
gen ub_vigtot_c   = table[6,4]

jackknife, cluster(leadernr): xtpcse inttot l_inttot	  c.partysize##i.campaign doublefunc i.sex##i.campaign if function!=1, pairwise
estimates store LeiderCamp3
margins, dydx(sex) at(campaign=(0 1))
mat table =  r(table)
gen	mean_inttot_r = table[1,3]  
gen mean_inttot_c = table[1,4]  
gen	lb_inttot_r   = table[5,3]  
gen lb_inttot_c   = table[5,4] 
gen	ub_inttot_r   = table[6,3] 
gen ub_inttot_c   = table[6,4] 

jackknife, cluster(leadernr): xtpcse comtot 		  c.partysize##i.campaign doublefunc i.sex##i.campaign if function!=1, pairwise
estimates store LeiderCamp4
margins, dydx(sex) at(campaign=(0 1))
mat table =  r(table)
gen	mean_comtot_r = table[1,3]  
gen mean_comtot_c = table[1,4]  
gen	lb_comtot_r   = table[5,3]  
gen lb_comtot_c   = table[5,4] 
gen	ub_comtot_r   = table[6,3] 
gen ub_comtot_c   = table[6,4] 

jackknife, cluster(leadernr): xtpcse contot 		  c.partysize##i.campaign doublefunc i.sex##i.campaign if function!=1, pairwise
estimates store LeiderCamp5
margins, dydx(sex) at(campaign=(0 1))
mat table =  r(table)
gen	mean_contot_r = table[1,3]  
gen mean_contot_c = table[1,4]  
gen	lb_contot_r   = table[5,3]  
gen lb_contot_c   = table[5,4] 
gen	ub_contot_r   = table[6,3] 
gen ub_contot_c   = table[6,4] 
	
twoway	||scatteri  12  0  0 0, lcolor(gs10) recast(line) lpattern(dash) lw(thin) || ///
		|| scatter count mean_cratot_r if count==11, m(o) msiz(medsmall) || ///
		|| rcap lb_cratot_r ub_cratot_r count if count==11, col(gs2) msize(small) lw(thin) hor  || ///
		|| scatter count mean_vigtot_r if count==10, m(o) msiz(medsmall) || ///
		|| rcap lb_vigtot_r ub_vigtot_r count if count==10, col(gs2) msize(small) lw(thin) hor  || ///
		|| scatter count mean_inttot_r if count==9, m(o) msiz(medsmall) || ///
		|| rcap lb_inttot_r ub_inttot_r count if count==9, col(gs2) msize(small) lw(thin) hor  || ///
		|| scatter count mean_comtot_r if count==8, m(o) msiz(medsmall) || ///
		|| rcap lb_comtot_r ub_comtot_r count if count==8, col(gs2) msize(small) lw(thin) hor  || ///
		|| scatter count mean_contot_r if count==7, m(o) msiz(medsmall) || ///
		|| rcap lb_contot_r ub_contot_r count if count==7, col(gs2) msize(small) lw(thin) hor  || ///
		|| scatter count mean_cratot_c if count==5, m(o) msiz(medsmall) || ///
		|| rcap lb_cratot_c ub_cratot_c count if count==5, col(gs2) msize(small) lw(thin) hor  || ///
		|| scatter count mean_vigtot_c if count==4, m(o) msiz(medsmall) || ///
		|| rcap lb_vigtot_c ub_vigtot_c count if count==4, col(gs2) msize(small) lw(thin) hor  || ///
		|| scatter count mean_inttot_c if count==3, m(o) msiz(medsmall) || ///
		|| rcap lb_inttot_c ub_inttot_c count if count==3, col(gs2) msize(small) lw(thin) hor  || ///
		|| scatter count mean_comtot_c if count==2, m(o) msiz(medsmall) || ///
		|| rcap lb_comtot_c ub_comtot_c count if count==2, col(gs2) msize(small) lw(thin) hor  || ///
		|| scatter count mean_contot_c if count==1, m(o) msiz(medsmall) || ///
		|| rcap lb_contot_c ub_contot_c count if count==1, col(gs2) msize(small) lw(thin) hor  || ///
		, ytitle("") xscale(range(-5 5)) xscale(alt) ///
	yscale(range(0 12)) xlabel(-4(2)4, tl(.5) axis(1) labsize(small)) ///
	scheme(Tufte)  ///
	ylabel( 11 "ROUTINE                 Political craftsmanship" 10 ///
	"Vigorousness" 9 "Integrity" 8 "Communicative skills" ///
	7 "Consistency" 5 "CAMPAIGN              Political craftsmanship" 4 ///
	"Vigorousness" 3 "Integrity" 2 "Communicative skills" ///
	1 "Consistency" , noticks nogrid labsize(small)) /// 
	xtitle("Effect of gender of leader", height(2) margin(small) size(small)) ///
	legend(off)   aspect(1.55) 
		
***********************************
*** Appendix 3: Minister traits ***
***********************************

jackknife, cluster(leadernr): xtpcse cratot 		i.sex ministry_none total_recode experience* if function==1, pairwise // 0.020
estimates store MinisterMain1
margins sex

jackknife, cluster(leadernr): xtpcse vigtot  			i.sex ministry_none total_recode experience* if function==1, pairwise //0.000
estimates store MinisterMain2
margins sex

jackknife, cluster(leadernr): xtpcse inttot  				i.sex ministry_none total_recode experience* if function==1, l(99.9) pairwise //0.001
estimates store MinisterMain3
margins sex

jackknife, cluster(leadernr): xtpcse comtot l_comtot i.sex ministry_none total_recode experience* if function==1, pairwise //
estimates store MinisterMain4
margins sex

jackknife, cluster(leadernr): xtpcse contot 				 i.sex ministry_none total_recode experience* if function==1, pairwise // 
estimates store MinisterMain5
margins sex
	

*******************************************************
*** Appendix 2: Descriptive information on Minister ***
*******************************************************
use "...\Replication File - Minister Experience and Budget.dta", clear

ssc inst egenmore	

gen priorcabinetexperience = 0
replace priorcabinetexperience = 1 if experience_juniormin==1
replace priorcabinetexperience = 2 if experience_seniormin==1
replace priorcabinetexperience = 3 if experience_juniormin==1 & experience_seniormin==1
label define experiencelabels 0 "None" 1 "Junior minister" 2 "Full minister" 3 "Both"
label values priorcabinetexperience experiencelabels

gen highestexperience = priorcabinetexperience 
label values highestexperience experiencelabels
recode highestexperience(3=2)

gen ministry_yes = 1 - ministry_none
bys cabinetname name: gen count = _n, 

replace gender = " Male" if gender=="m"
replace gender = "Female" if gender=="v" | gender=="f"
gen Female = 0
replace Female = 1 if gender=="Female" 
gen Male = 1 - Female

gen female_totalbudget = total_recode * Female
gen male_totalbudget = total_recode * Male

recode priorcabinetexperience (0=1) (1/3=.), gen(prior_none)
recode priorcabinetexperience (2/3=.) (0=.), gen(prior_jun)
recode priorcabinetexperience (2=1) (0/1=.) (3=.), gen(prior_sen)
recode priorcabinetexperience (0/2=.) (3=1), gen(prior_both)

sort count cabinet name

graph pie Male Female if cabinet=="BalkenendeIII", scheme(tufte) pie(1, c(gs13)) pie(2, c(gs7)) nocl plabel(_all percent, format(%2.0f) size(large)) name(number_1, replace) title("Balkenende III" "2006-2007")
graph pie Male Female if cabinet=="BalkenendeIV", scheme(tufte) pie(1, c(gs13)) pie(2, c(gs7)) nocl plabel(_all percent, format(%2.0f) size(large)) name(number_2, replace) title("Balkenende IV" "2007-2010")
graph pie Male Female if cabinet=="RutteI", scheme(tufte) pie(1, c(gs13)) pie(2, c(gs7)) nocl plabel(_all percent, format(%2.0f) size(large)) name(number_3, replace) title("Rutte I" "2010-2012")
graph pie male_totalbudget female_totalbudget if cabinet=="BalkenendeIII", scheme(tufte) pie(1, c(gs13)) pie(2, c(gs7)) nocl plabel(_all percent, format(%2.0f) size(large)) name(number_4, replace) title("Balkenende III" "2006-2007")
graph pie male_totalbudget female_totalbudget if cabinet=="BalkenendeIV", scheme(tufte) pie(1, c(gs13)) pie(2, c(gs7)) nocl plabel(_all percent, format(%2.0f) size(large)) name(number_5, replace) title("Balkenende IV" "2007-2010")
graph pie male_totalbudget female_totalbudget if cabinet=="RutteI", scheme(tufte) pie(1, c(gs13)) pie(2, c(gs7)) nocl plabel(_all percent, format(%2.0f) size(large)) name(number_6, replace) title("Rutte I" "2010-2012")

graph hbar (count) prior_none prior_jun prior_sen prior_both if count==1, ///
	stack by(gender, cols(1) note("Prior Cabinet Experience", position(9) ///
	orientation(vertical) size(medium) margin(l=0 r=5) )) blabel(bar, format(%2.0f) size(medium) position(center)) ///
	percent scheme(tufte) bar(1, c(gs15)) bar(2, c(gs10)) bar(3, c(gs7)) bar(4, c(gs5)) ///
	legend(order(1 "None" 2 "Junior minister" 3 "Senior minister" 4 "Both" ) cols(4) ) ///
	name(number_10, replace) aspect(.04) outergap(-10)
	
	
***************************************
*** Descriptive info: article level ***
***************************************

use "...\Replication File 3 - Aaldering and Van der Pas - BJPS (article level).dta", clear

* recode double function
recode function (2=0)

* campaign only for party leaders
replace campaign=0 if function==1

* counting the number of weeks per politician
sort campaign leader week
bys campaign leader week: gen weekcount = 1 if _n==1

drop if leader==""
gen sex = 0 if gender=="m"
replace sex = 1 if gender!="m"
label define sexes 1 "Female" 0 "Male"
label values sex sexes
encode leader, gen(leadernr)

rename polcraftotaal cratot
rename vigtotaal vigtot
rename inttotaal inttot
rename commtotaal comtot
rename contotaal contot
rename totaltotal1 tottot

**************************************
*** Appendix 4: Traits in articles ***
**************************************
	
* Leaders, campaign interaction & interaction campaign and partysize
foreach trait of varlist cratot vigtot inttot comtot contot tottot {
	logit `trait' sex##campaign i.doublefun c.partysize##campaign if function==0, cluster(leader)
	est store logit2`trait'
}
	

	
