* ---------------------------------------------------------------------- *
* ---------------------------------------------------------------------- *
* CREATE TABLES AND FIGURES FOR KREISMAN/RANGEL 2014
* ---------------------------------------------------------------------- *
* ---------------------------------------------------------------------- *

* BEGIN LOG
cap log close
*log using "${directory}/3_tables_and_figures", text

* ---------------------------------------------------------------------- *
* FIGURE 1 (HISTOGRAM OF SKIN COLOR FOR BLACK AND WHITE MALES, BY RACE)
* ---------------------------------------------------------------------- *

* OPEN DATA 
clear
use "${data}/skin_color_wide.dta"

* RESTRICT SAMPLE
count
keep if male==1 
keep if race<3
keep if color!=.
keep if coloryear==2008
count /* 2417 */

* LABEL VALUES FOR TITLES
lab def black 0"White" 1"Black", modify
lab val black black 

#delimit ;
histogram color,
	percent 
	by(black)
	discrete 
	ylab(, nogrid)
	ytitle(Percent of respondents within race) 
	xlab(0(1)10)
	ysca(r(0 50)) 
	ylab(0(10)50)
	xtitle(Interviewer skin color rating) 
	scheme(s1mono)
;
#delimit cr

* ---------------------------------------------------------------------- *
* TABLE 1 (INTERVIEWER CHARACTERISTICS, MEANS WEIGHTED BY INTERVIEWERS AND RESPONDENTS)
* ---------------------------------------------------------------------- *

* OPEN DATA 
clear
use "${data}/skin_color_wide.dta"


* COUNT OF RESPONDENTS PER INTERVIEWER 
cap drop n
bys intvid: gen n=_N


* COLUMN 1 (WEIGHTED BY INTERVIEWERS)
* ---------------------------------------------------------------------- *

* RESTRICT SAMPLE
count
keep if male==1 
keep if race<3
keep if color!=.
keep if coloryear==2008
count /* 2417 */


* MISSING INDICATORS
tab intvhgc, gen(intvhgc_)
foreach x in intvmale intvrace intv50 intvhgc {
	cap drop `x'_m
	gen `x'_m=`x'==.
}
recode intvmale (1=0) (0=1), gen(intvfemale)
recode intv50 (1=0) (0=1), gen(intvu50)

* PRESERVE (FOR COLLAPSE, RESTORED LATER)
preserve

* COLLAPSE BY INTERVIEWER
collapse intvmale intvfemale intvmale_m intvwhite intvblack intvother intvrace_m intv50 intvu50  intv50_m intvhgc_1 intvhgc_2 intvhgc_3 intvhgc_4 intvhgc_m n, by(intvid)
count 	/* 167 */ 
local n1=r(N)

* REPLACE MISSINGS TO 0 B/C MISSING DUMMIES ARE INCLUDED
foreach x in intvmale intvfemale intvmale_m intvwhite intvblack intvother intvrace_m intv50 intvu50  intv50_m intvhgc_1 intvhgc_2 intvhgc_3 intvhgc_4 intvhgc_m {
	replace `x'=0 if `x'==.
}
	
* TABSTAT (NOTE MAY REQUIRE PROGRAM `TABSTATMAT')
tabstat intvmale intvfemale intvmale_m intvwhite intvblack intvother intvrace_m intv50 intvu50  intv50_m intvhgc_1 intvhgc_2 intvhgc_3 intvhgc_4 intvhgc_m n, save stat(mean)
tabstatmat c1

* COLUMN 1 STATS
mat c1=(c1' \ `n1')
mat list c1

* RESTORE DATA
restore


* COLUMNS 2-4 (WEIGHTED BY RESPONDENTS)
* ---------------------------------------------------------------------- *

* PRESERVE FOR COLLAPSE
preserve

* COLLAPSE BY RESPONDENT
collapse white intvmale intvfemale intvmale_m intvwhite intvblack intvother intvrace_m intv50 intvu50  intv50_m intvhgc_1 intvhgc_2 intvhgc_3 intvhgc_4 intvhgc_m n, by(R0000100)
count 	/* 2417 */ 

* REPLACE MISSINGS TO 0 B/C MISSING DUMMIES ARE INCLUDED
foreach x in intvmale intvfemale intvmale_m intvwhite intvblack intvother intvrace_m intv50 intvu50  intv50_m intvhgc_1 intvhgc_2 intvhgc_3 intvhgc_4 intvhgc_m {
	replace `x'=0 if `x'==.
}
	
* TABSTAT 
tabstat intvmale intvfemale intvmale_m intvwhite intvblack intvother intvrace_m intv50 intvu50  intv50_m intvhgc_1 intvhgc_2 intvhgc_3 intvhgc_4 intvhgc_m n, by(white) save stat(mean)
tabstatmat c2

* COUNTS
qui count if white==0
local n2=r(N)
qui count if white==1
local n3=r(N)
qui count  
local n4=r(N)

* COLUMNS 2-4 STATS
mat c2=(c2' \ `n2' , `n3' , `n4')
mat list c2

* FINAL TABLE 1
* ---------------------------------------------------------------------- *
mat table1 = (c1, c2)
mat list table1

* RESTORE
restore


* ------------------------------------------------------------------------------------ *
** TABLE 2 (SKIN COLOR RATING FOR BLACK AND WHITE MALES BY INTERVIEWER CHARACTERISTICS)
* ------------------------------------------------------------------------------------ *

clear
use "${data}/skin_color_wide.dta"

* COUNT RESPONDENTS PER INTERVIEWER 
cap drop n
bys intvid: gen n=_N

count
keep if male==1 
keep if race<3
keep if color!=.
keep if coloryear==2008
count /* 2417 */


* RECODE INTV CHARS AND MISSINGS
recode intvmale (0=1) (1=0) (.=2), gen(intvfemale)
replace intvrace=4 if intvrace==.
replace intv50=2 if intv50==.
replace intvhgc=5 if intvhgc==.

* WHITE
tabstat color if black==0, by(intvfemale) save stat(mean sd) notot
tabstatmat c1
tabstat color if black==0, by(intvrace) save stat(mean sd) notot
tabstatmat c2
tabstat color if black==0, by(intv50) save stat(mean sd) notot
tabstatmat c3
tabstat color if black==0, by(intvhgc) save stat(mean sd) notot
tabstatmat c4
mat C1=(c1 \ c2 \ c3 \ c4)

* COUNT
qui count if white==1
local nW=r(N)
mat C1=(C1 \  `nW', `nW')

* BLACK
tabstat color if black==1, by(intvfemale) save stat(mean sd) notot
tabstatmat c1
tabstat color if black==1, by(intvrace) save stat(mean sd) notot
tabstatmat c2
tabstat color if black==1, by(intv50) save stat(mean sd) notot
tabstatmat c3
tabstat color if black==1, by(intvhgc) save stat(mean sd) notot
tabstatmat c4
mat C2=(c1 \ c2 \ c3 \ c4)

* COUNT
qui count if white==0
local nB=r(N)
mat C2=(C2 \  `nB', `nB')

* TABLE 
mat table2 = (C1, C2)
mat list table2



* ------------------------------------------------------------------------------------ *
** TABLE 3 (SAMPLE RESTRICTIONS)
* ------------------------------------------------------------------------------------ *
 
clear
use "${data}/skin_color.dta"

* TAG 1 OBS PER RESPONDENT
cap drop tag
egen tag=tag(R0000100)

* MAKE WAGE SAMPLE DUMMY
cap drop *wage_sample
gen N_wage_sample = (male==1 & race<3 & year>1998 & afqt!=. & hgc!=. & year>=new_entry & new_entry!=. & ifenr==0 & color!=. & coloryear==2008 & wage!=. & hrs>=30 & hrs<.)
bys R0000100: egen n_wage_sample=max(N_wage_sample)

* MAKE EMP SAMPLE DUMMY
cap drop N_emp_sample
gen N_emp_sample =  (male==1 & race<3 & year>1998 & afqt!=. & hgc!=. & year>=new_entry & new_entry!=. & ifenr==0 & color!=. & coloryear==2008 & shrwks30_v1!=.)
bys R0000100: egen n_emp_sample=max(N_emp_sample)

* GEN EVER ENTERED LABOR MARKET
cap drop tmp
cap drop tmp_entry
gen tmp=(year>=new_entry & new_entry!=.)
bys R0000100: egen tmp_entry=max(tmp)


* COLUMN 1 (INDIVIDUALS)
* ------------------------------------------------------------------------------------ *

* EACH RESTRICTION AS A DUMMY 
cap drop tmp_c*
gen tmp_r1=(year==2010)
gen tmp_r2=(year==2010 & male==1 & race<3)
gen tmp_r3=(year==2010 & male==1 & race<3 & color!=. & coloryear==2008)
gen tmp_r4=(year==2010 & male==1 & race<3 & color!=. & coloryear==2008 & afqt!=.)
gen tmp_r5=(year==2010 & male==1 & race<3 & color!=. & coloryear==2008 & afqt!=. & tmp_entry==1)
gen tmp_r6=(year==2010 & n_emp_sample==1)
gen tmp_r7=(year==2010 & n_wage_sample==1)
gen tmp_r8=(year==2010 & n_wage_sample==1 & white==1)
gen tmp_r9=(year==2010 & n_wage_sample==1 & black==1)

recode tmp_r* (0=.)
tabstat tmp_r* if year==2010, stat(N) save
tabstatmat c1

* COLUMN 2 (OBSERVATIONS)
* ------------------------------------------------------------------------------------ *

cap drop tmp_R*
gen tmp_R1=1
gen tmp_R2=(male==1 & race<3)
gen tmp_R3=(male==1 & race<3 & color!=. & coloryear==2008)
gen tmp_R4=(male==1 & race<3 & color!=. & coloryear==2008 & afqt!=.)
gen tmp_R5=(male==1 & race<3 & color!=. & coloryear==2008 & afqt!=. & tmp_entry==1)
gen tmp_R6=(N_emp_sample==1)
gen tmp_R7=(N_wage_sample==1)
gen tmp_R8=(N_wage_sample==1 & white==1)
gen tmp_R9=(N_wage_sample==1 & black==1)

recode tmp_R* (0=.)
tabstat tmp_R*, stat(N) save
tabstatmat c2

* FINAL TABLE 3
* ---------------------------------------------------------------------- *
mat table3=(c1', c2')
mat list table3
cap drop tmp*




* ------------------------------------------------------------------------------------ *
** TABLE 4 (SUMMARY STATS - MEANS AND SD BY RACE AND SKIN COLOR FOR WAGE REGRESSION SAMPLE)
* ------------------------------------------------------------------------------------ *
clear
use "${data}/skin_color.dta"

* SAMPLE RESTRICTIONS
* ---------------------------------------------------------------------- *
keep if male==1				/* MALES ONLY */
keep if race<3				/* BLACK AND WHITE RESPONDENTS ONLY */
keep if year>1998			/* OMIT 1997 SURVEY YEAR */
keep if afqt!=.				/* NON-MISSING AFQT */
keep if hgc!=.				/* NON-MISSING HGC */
keep if year>=new_entry		/* ENTERED LABOR MARKET */
keep if ifenr==0			/* NON-ENROLLED */


* MAKE WAGE SAMPLE DUMMY
cap drop *wage_sample
gen N_wage_sample = (male==1 & race<3 & year>1998 & afqt!=. & hgc!=. & year>=new_entry & new_entry!=. & ifenr==0 & color!=. & coloryear==2008 & wage!=. & hrs>=30 & hrs<.)
bys R0000100: egen n_wage_sample=max(N_wage_sample)

* MAKE EMP SAMPLE DUMMY
cap drop *_emp_sample
gen N_emp_sample =  (male==1 & race<3 & year>1998 & afqt!=. & hgc!=. & year>=new_entry & new_entry!=. & ifenr==0 & color!=. & coloryear==2008 & shrwks30_v1!=.)
bys R0000100: egen n_emp_sample=max(N_emp_sample)

* MAKE POTEXP IN LAST YEAR OBSERVED
cap drop tmp*
cap drop last_potexp
sort R0000100 year
by R0000100: gen  tmp=potexp if _n==_N
by R0000100: egen last_potexp=max(tmp)
cap drop tmp*

* MAKE TENURE IN LAST YEAR OBSERVED
cap drop tmp*
cap drop last_tenure
sort R0000100 year
by R0000100: gen  tmp=tenure if _n==_N
by R0000100: egen last_tenure=max(tmp)
cap drop tmp*



* SUM STATS BY RESPONDENTS IN THE WAGE SAMPLE
* ---------------------------------------------------------------------- *
gen hgcmom2_=hgcmom==2
foreach x in hgcmom1_ hgcmom2_ hgcmom3_ {
	replace `x'=. if hgcmom_m==1
}

foreach x in msa1_ msa2_ msa3_ { 
	replace `x'=. if msa_m==1
}	

foreach x in region1_ region2_ region3_ { 
	replace `x'=. if region_m==1
}	

replace povratio_=. if povratio_m==1

* COLLAPSE TO MEANS BY RESPONDENT
global vars "color bxcolor black bl bm bd afqtz hgcever entryage region3_ msa1_ povratio_ hgcmom1_ hgcmom3_ last_potexp last_tenure n_wage_sample (sum) N_wage_sample"
collapse $vars, by(R0000100)
keep if n_wage_sample==1

* COLOR GROUPS
cap drop tmp_color
gen tmp_color=.
replace tmp_color=0 if black==0
replace tmp_color=1 if bl==1
replace tmp_color=2 if bm==1
replace tmp_color=3 if bd==1

* TABSTATS FOR TABLE
global table4_vars "afqtz hgcever entryage region3_ msa1_ povratio_ hgcmom1_ hgcmom3_ last_potexp last_tenure N_wage_sample"
set more off
forval i=0(1)3 {
	qui tabstat $table4_vars if tmp_color==`i', stat(mean sd) save
	qui tabstatmat c`i'
	mat c`i'=vec(c`i')
	qui count if tmp_color==`i'
	mat n`i'=r(N)
	mat C`i'=(c`i'\n`i')
}

mat table4=(C0, C1, C2, C3)
mat list table4
 

* ---------------------------------------------------------------------- *
* ---------------------------------------------------------------------- *
* BEGIN REGRESSION TABLES
* ---------------------------------------------------------------------- *
* ---------------------------------------------------------------------- *
clear
use "${data}/skin_color.dta"
 
* SAMPLE RESTRICTIONS
* ---------------------------------------------------------------------- *
keep if male==1				/* MALES ONLY */
keep if race<3				/* BLACK AND WHITE RESPONDENTS ONLY */
keep if year>1998			/* OMIT 1997 & 1998 SURVEY YEARS B/C FEW OBS */
keep if afqt!=.				/* NON-MISSING AFQT */
keep if hgc!=.				/* NON-MISSING HGC */
keep if year>=new_entry		/* ENTERED LABOR MARKET */
keep if ifenr==0			/* NON-ENROLLED */


* DEFINE ADDITIONAL SAMPLE RESTRICTION GLOBALS USED W/IN REGS
* ---------------------------------------------------------------------- *
* IF COLOR IS NON-MISSING, COLOR MEASURED IN 2008
* HOURS IN JOB ARE >=30 AND NON-MISSING
global restrict_wage "color!=. & coloryear==2008 & hrs>=30 & hrs<."

* IF COLOR IS NON-MISSING, COLOR MEASURED IN 2008
global restrict_emp  "color!=. & coloryear==2008"


* CREATE INTVID DUMMIES FOR INTERVIEWER FE
* ---------------------------------------------------------------------- *
cap drop _intvid_*
qui tab intvid, gen(_intvid_)

* DEFINE REGRESSION GLOBALS
* ---------------------------------------------------------------------- *

* LEFT HAND SIDE VARIABLES
global ctls 		"region1_ region2_ region4_ region_m msa1_ msa3_ msa_m"
global parent		"povratio_ povratio_m aid_ aid_m parents6_ parents6_m hgcmom1_ hgcmom3_ hgcmom_m rural12_ rural12_m south12_" 
global intv 		"intvblack_ intvmale_ intv50_ intv_m"
global behavior		"height97_* weight97_* pca1_ pca_m"
global yr		 	"yr1999 yr2000 yr2001 yr2002 yr2003 yr2004 yr2005 yr2006 yr2007 yr2008 yr2009"

* STANDARD ERROR SPECIFICATIONS
global xtcluster	"i(R0000100) vce(cluster R0000100)"
global cluster		"cluster(R0000100)"
global glm 			"family(binomial) link(logit) cluster(R0000100)"

* REPORTING
global stars "starlevel(* 0.1 ** 0.05 *** 0.01)"

* ---------------------------------------------------------------------- *
* TABLE 5 (CONDITIONAL DIFF IN LOG HRLY WAGE BY RACE AND SKIN COLOR)
* ---------------------------------------------------------------------- *

* CONTROL GLOBALS FOR TABLES 5 & 6 
* ---------------------------------------------------------------------- *
set more off
local model1 "															$yr"
local model2 "hgc afqtz 	age entryage 						 		$yr"
local model3 "				age 	 	 $ctls $parent $behavior 		$yr"
local model4 "hgc afqtz 	age entryage $ctls $parent $behavior 		$yr"
local model5 "hgc afqtz 	age entryage $ctls $parent $behavior $intv 	$yr"
local model6 "hgc afqtz 	age entryage $ctls $parent $behavior 		$yr"

 
* SET DELIMITER
#delimit ;
eststo clear ;

* PANEL A: BLURRED COLOR LINE ;
local color "bl bm bd" ;
forvalues i=1(1)6 { ;
	if `i'<6 	{; eststo E_1_`i': qui reg  wage `color' `model`i'' if $restrict_wage, $cluster ; };
	if `i'==6 	{; eststo E_1_`i': qui areg wage `color' `model`i'' if $restrict_wage, $cluster absorb(intvid) ; };
} ;
 
* PANEL B: SHARP ;
#delimit ;
local color "black" ;
forvalues i=1(1)6 { ;
	if `i'<6 	{; eststo E_2_`i': qui reg  wage `color' `model`i'' if $restrict_wage, $cluster ; };
	if `i'==6 	{; eststo E_2_`i': qui areg wage `color' `model`i'' if $restrict_wage, $cluster absorb(intvid) ; };
} ;

* PANEL C: BLURRED (COMPARED WITH BLACK);
#delimit ;
local color "bl black bd" ;
 forvalues i=1(1)6 { ;
	if `i'<6 	{; eststo E_3_`i': qui reg  wage `color' `model`i'' if $restrict_wage, $cluster ; };
	if `i'==6 	{; eststo E_3_`i': qui areg wage `color' `model`i'' if $restrict_wage, $cluster absorb(intvid) ; };
	estadd scalar clust=e(N_clust);
} ;


* TABLE ;
esttab E_1* using "/Users/Kreisman/Desktop/table5.tex", 
			b(%9.3fc) se(%9.3fc)
 			keep(bl bm bd hgc afqtz) 	
 			$stars fragment nogap label nomtitles noobs
			replace ;
esttab E_2* using "/Users/Kreisman/Desktop/table5.tex", 
			b(%9.3fc) se(%9.3fc)
 			keep(black) 	
 			$stars fragment nogap label nomtitles noobs
			append ;
esttab E_3* using "/Users/Kreisman/Desktop/table5.tex", 
			b(%9.3fc) se(%9.3fc)
 			keep(bl bd) 	
 			$stars fragment nogap label nomtitles r2 scalar(clust)
			append ;
 

* CLEAR DELIMITER
#delimit cr

 
* ---------------------------------------------------------------------- *
* TABLE 6 (ROBUSTNESS CHECKS 1, VARIATION IN SAMPLE0 
* ---------------------------------------------------------------------- *

* RESTRICTIONS
cap drop tmp_restrict
gen tmp_restrict=0 if color!=.
replace tmp_restrict=1 if (black==1 & color==1)
replace tmp_restrict=1 if (black==0 & color==7 | color==8)

* INTERACTION WITH MIXED
cap drop black_mixed
gen black_mixed=(black==1 & mixed==1)
replace black_mixed=. if mixed==.

* CORESIDE INTERACTIONS
cap drop black_parents6_*
gen black_parents6_=black*parents6_
gen black_parents6_m=black*parents6_m

* MODEL 6 LOCAL, REPEATED FROM ABOVE 
local model6 "hgc afqtz age entryage $ctls $parent $behavior $yr"
eststo clear


* PANEL A: BLURRED COLOR LINE  
local color "bl bm bd"
set more off
eststo E_1_1: qui areg wage `color' `model6' if $restrict_wage, $cluster absorb(intvid)
eststo E_1_2: qui areg wage `color' `model6' if $restrict_wage & year>=2006, $cluster absorb(intvid)
eststo E_1_3: qui areg wage `color' `model6' if color!=. & hrs>=30 & hrs<., $cluster absorb(intvid)
eststo E_1_4: qui areg wage `color' `model6' if color!=. & coloryear==2008 & hrs>=20 & hrs<., $cluster absorb(intvid)
eststo E_1_5: qui areg wage `color' `model6' if $restrict_wage & tmp_restrict==0, $cluster absorb(intvid)
eststo E_1_6: qui areg wage `color' `model6' black_mixed if $restrict_wage, $cluster absorb(intvid)
eststo E_1_7: qui areg wage `color' `model6' if $restrict_wage & black_mixed==0, $cluster absorb(intvid)
eststo E_1_8: qui areg wage `color' `model6' if $restrict_wage & mixed!=1, $cluster absorb(intvid)

* PANEL B: SHARP 
local color "black"
set more off
eststo  E_2_1: qui areg wage `color' `model6' if $restrict_wage, $cluster absorb(intvid)
eststo  E_2_2: qui areg wage `color' `model6' if $restrict_wage & year>=2006, $cluster absorb(intvid)
eststo  E_2_3: qui areg wage `color' `model6' if color!=. & hrs>=30 & hrs<., $cluster absorb(intvid)
eststo  E_2_4: qui areg wage `color' `model6' if color!=. & coloryear==2008 & hrs>=20 & hrs<., $cluster absorb(intvid)
eststo  E_2_5: qui areg wage `color' `model6' if $restrict_wage & tmp_restrict==0, $cluster absorb(intvid)
eststo  E_2_6: qui areg wage `color' `model6' black_mixed if $restrict_wage, $cluster absorb(intvid)
eststo  E_2_7: qui areg wage `color' `model6' if $restrict_wage & black_mixed==0, $cluster absorb(intvid)
eststo  E_2_8: qui areg wage `color' `model6' if $restrict_wage & mixed!=1, $cluster absorb(intvid)
 
  
* PANEL C: BLURRED (COMPARED WITH BLACK)
local color "bl black bd"
set more off
eststo E_3_1: qui areg wage `color' `model6' if $restrict_wage, $cluster absorb(intvid)
estadd scalar clust=e(N_clust)
eststo E_3_2: qui areg wage `color' `model6' if $restrict_wage & year>=2006, $cluster absorb(intvid)
estadd scalar clust=e(N_clust)
eststo E_3_3: qui areg wage `color' `model6' if color!=. & hrs>=30 & hrs<., $cluster absorb(intvid)
estadd scalar clust=e(N_clust)
eststo E_3_4: qui areg wage `color' `model6' if color!=. & coloryear==2008 & hrs>=20 & hrs<., $cluster absorb(intvid)
estadd scalar clust=e(N_clust)
eststo E_3_5: qui areg wage `color' `model6' if $restrict_wage & tmp_restrict==0, $cluster absorb(intvid)
estadd scalar clust=e(N_clust)
eststo E_3_6: qui areg wage `color' `model6' black_mixed if $restrict_wage, $cluster absorb(intvid)
estadd scalar clust=e(N_clust)
eststo E_3_7: qui areg wage `color' `model6' if $restrict_wage & black_mixed==0, $cluster absorb(intvid)
estadd scalar clust=e(N_clust)
eststo E_3_8: qui areg wage `color' `model6' if $restrict_wage & mixed!=1, $cluster absorb(intvid)
estadd scalar clust=e(N_clust)
cap drop tmp_restrict

#delimit ;
* TABLE ;
esttab E_1* using "/Users/Kreisman/Desktop/table6.tex", 
			b(%9.3fc) se(%9.3fc)
 			keep(bl bm bd black_mixed) 	
 			$stars fragment nogap label nomtitles noobs
			replace ;
esttab E_2* using "/Users/Kreisman/Desktop/table6.tex", 
			b(%9.3fc) se(%9.3fc)
 			keep(black) 	
 			$stars fragment nogap label nomtitles noobs
			append ;
esttab E_3* using "/Users/Kreisman/Desktop/table6.tex", 
			b(%9.3fc) se(%9.3fc)
 			keep(bl bd) 	
 			$stars fragment nogap label nomtitles r2 scalar(clust)
			append ;
#delimit cr 



* ---------------------------------------------------------------------- *
* TABLE 7 (CONDITIONAL DIFFERENCE SIN SHARE OF WEEKS EMPLOYED 
* ---------------------------------------------------------------------- *

* CONTROL GLOBALS FOR TABLES 5 AND 6 (REPEATED FROM ABOVE)
* ---------------------------------------------------------------------- *
set more off
local model1 "															$yr"
local model2 "hgc afqtz 	age entryage 						 		$yr"
local model3 "				age 	 	 $ctls $parent $behavior 		$yr"
local model4 "hgc afqtz 	age entryage $ctls $parent $behavior 		$yr"
local model5 "hgc afqtz 	age entryage $ctls $parent $behavior $intv 	$yr"
* MODEL 6 IS MODIFIED B/C CANNOT DO 'areg' WITH GLM
local model6 "hgc afqtz 	age entryage $ctls $parent $behavior _intvid_* $yr"

set more off 
eststo clear 
 
* PANEL A: BLURRED COLOR LINE 
* ----------- * 
eststo clear
local color "bl bm bd" 
forvalues i=1(1)6 { 
	qui glm shrwks30_v1 `color' `model`i'' if $restrict_emp, $glm 
 	#delimit ;
 	if (`i'==1 | `i'==3) 	{; qui estpost margins, dydx(`color') ; };
 	if (`i'!=1 & `i'!=3)	{; qui estpost margins, dydx(`color' hgc afqtz) ; };
	#delimit cr
 	eststo margins`i' 
} 
#delimit ;
* TABLE ;
esttab using "/Users/Kreisman/Desktop/table7.tex", 
			b(%9.3fc) se(%9.3fc)
 			keep(bl bm bd hgc afqtz) 	
 			$stars fragment nogap label nomtitles noobs
			replace ;
#delimit cr

* PANEL B: SHARP 
* ----------- * 
eststo clear
local color "black" 
forvalues i=1(1)6 { 
	qui glm shrwks30_v1 `color' `model`i'' if $restrict_emp, $glm 
	#delimit ;
 	if (`i'==1 | `i'==3) 	{; qui estpost margins, dydx(`color') ; };
 	if (`i'!=1 & `i'!=3)	{; qui estpost margins, dydx(`color' hgc afqtz) ; };
	#delimit cr
 	eststo margins`i' 
} 
#delimit ;
* TABLE ;
esttab using "/Users/Kreisman/Desktop/table7.tex", 
			b(%9.3fc) se(%9.3fc)
 			keep(black) 	
 			$stars fragment nogap label nomtitles noobs
			append ;
#delimit cr
 
* PANEL C: BLURRED (COMPARED WITH BLACK)
* ----------- *
eststo clear
local color "bl black bd" 
forvalues i=1(1)6 { 
	qui glm shrwks30_v1 `color' `model`i'' if $restrict_emp, $glm 
	#delimit ;
 	if (`i'==1 | `i'==3) 	{; qui estpost margins, dydx(`color') ; };
 	if (`i'!=1 & `i'!=3)	{; qui estpost margins, dydx(`color' hgc afqtz) ; };
	#delimit cr
 	eststo margins`i'
 	estadd scalar clust=e(N_clust) 
} 
#delimit ;
* TABLE ;
esttab using "/Users/Kreisman/Desktop/table7.tex", 
			b(%9.3fc) se(%9.3fc)
 			keep(bl bd) 	
 			$stars fragment nogap label nomtitles
			append ;
#delimit cr

 

* ---------------------------------------------------------------------- *
* TABLE 8 (CONDITIONAL DIFFERENCES IN WAGES, INTERACTIONS WITH POTEXP AND TENURE 
* ---------------------------------------------------------------------- *

* ROUND TENURE TO NEAREST 1 
cap drop tenure_r
gen tenure_r=round(tenure)

* CENTER HGC
cap drop C*hgc
mcenter hgc
rename C_hgc Chgc
lab var Chgc "HGC"

cap drop tmp
cap drop C*potexp
cap drop tmp
gen tmp=(age-hgc-6)
replace tmp=0 if tmp<0
rename tmp Cpotexp 

* CENTER POTEXP
cap drop C*potexp
mcenter potexp
rename C_potexp Cpotexp

* CENTER TENURE
cap drop C*tenure
mcenter tenure_r,
rename C_tenure_r Ctenure


* CREATE INTERACTIONS WITH POTEXP/TENURE
foreach x in black bl bm bd Chgc afqtz {
	
	* POTEXP
	cap drop `x'_Cpotexp
	gen `x'_Cpotexp=`x'*Cpotexp	
	
	* TENURE
	cap drop `x'_Ctenure
	gen `x'_Ctenure=`x'*Ctenure	
}

* LABELS
lab var bl_Cpotexp "Light*Potexp"
lab var bm_Cpotexp "Medium*Potexp"
lab var bd_Cpotexp "Dark*Potexp"
lab var black_Cpotexp "Black*Potexp"
lab var Cpotexp "Potexp (centered)"
*
lab var bl_Ctenure "Light*Tenure"
lab var bm_Ctenure  "Medium*Tenure"
lab var bd_Ctenure  "Dark*Tenure"
lab var black_Ctenure "Black*Tenure"
lab var Ctenure "Tenure (centered)"
*
lab var Chgc_Cpotexp "HGC*potexp"
lab var Chgc_Ctenure "HGC*tenure"
lab var afqtz_Cpotexp "AFQT*potexp"
lab var afqtz_Ctenure "AFQT*tenure"



* RUN TABLE 8
* ---------------------------------------------------------------------- *

* GLOBALS FOR TABLE 8
* ---------------------------------------------------------------------- *
global vars_7  		 "Chgc afqtz $ctls $parent $behavior $yr" 
global skill_tenure  "Chgc_Ctenure afqtz_Ctenure"   
global skill_potexp  "Chgc_Cpotexp afqtz_Cpotexp"   


* PANEL A: BLURRED COLOR
* ---------------------------------------------------------------------- *
set more off

* LOCALS
local color "bl bm bd"
local color_potexp  "bl_Cpotexp bm_Cpotexp bd_Cpotexp"
local color_tenure  "bl_Ctenure bm_Ctenure bd_Ctenure"


* PANEL A: ALL
* ---------------------------------------------------------------------- *

eststo clear
eststo: qui areg wage `color' $vars_7 Cpotexp `color_potexp' 					  					if $restrict_wage, $cluster absorb(intvid)
eststo: qui areg wage `color' $vars_7 Cpotexp `color_potexp' $skill_potexp 	 						if $restrict_wage, $cluster absorb(intvid)
eststo: qui areg wage `color' $vars_7 Cpotexp `color_potexp' Ctenure `color_tenure'  				if $restrict_wage, $cluster absorb(intvid)
eststo: qui areg wage `color' $vars_7 Cpotexp `color_potexp' Ctenure `color_tenure' $skill_tenure 	if $restrict_wage, $cluster absorb(intvid)
* TABLE 
#delimit ;
esttab using "/Users/Kreisman/Desktop/table8.tex", 
			b(%9.3fc) se(%9.3fc)
 			keep(`color' `color_potexp' `color_tenure' Chgc afqtz Cpotexp Ctenure $skill_potexp $skill_tenure)  	
 			$stars fragment nogap label nomtitles noobs
			replace ;
#delimit cr


* PANEL B: SHARP COLOR
* ---------------------------------------------------------------------- *
set more off
local color "black"
local color_potexp  "black_Cpotexp"
local color_tenure  "black_Ctenure"

* REGRESSIONS
eststo clear
eststo: qui areg wage `color' $vars_7 Cpotexp `color_potexp' 					  					if $restrict_wage, $cluster absorb(intvid)
eststo: qui areg wage `color' $vars_7 Cpotexp `color_potexp' $skill_potexp 	 					if $restrict_wage, $cluster absorb(intvid)
eststo: qui areg wage `color' $vars_7 Cpotexp `color_potexp' Ctenure `color_tenure'  				if $restrict_wage, $cluster absorb(intvid)
eststo: qui areg wage `color' $vars_7 Cpotexp `color_potexp' Ctenure `color_tenure' $skill_tenure 	if $restrict_wage, $cluster absorb(intvid)
* TABLE 
#delimit ;
esttab using "/Users/Kreisman/Desktop/table8.tex", 
			b(%9.3fc) se(%9.3fc)
 			keep(`color_potexp' `color_tenure')
 			$stars fragment nogap label nomtitles noobs
			append ;
#delimit cr
 
 
* PANEL C: BLURRED VS. BLACK
* ---------------------------------------------------------------------- *
set more off
local color "bl black bd"
local color_potexp  "bl_Cpotexp black_Cpotexp bd_Cpotexp"
local color_tenure  "bl_Ctenure black_Ctenure bd_Ctenure"

* REGRESSIONS
eststo clear
eststo: qui areg wage `color' $vars_7 Cpotexp `color_potexp' 					  					if $restrict_wage, $cluster absorb(intvid)
estadd scalar clust=e(N_clust)
eststo: qui areg wage `color' $vars_7 Cpotexp `color_potexp' $skill_potexp 	 					if $restrict_wage, $cluster absorb(intvid)
estadd scalar clust=e(N_clust)
eststo: qui areg wage `color' $vars_7 Cpotexp `color_potexp' Ctenure `color_tenure'  				if $restrict_wage, $cluster absorb(intvid)
estadd scalar clust=e(N_clust)
eststo: qui areg wage `color' $vars_7 Cpotexp `color_potexp' Ctenure `color_tenure' $skill_tenure 	if $restrict_wage, $cluster absorb(intvid)
estadd scalar clust=e(N_clust)
* TABLE 
#delimit ;
esttab using "/Users/Kreisman/Desktop/table8.tex", 
			b(%9.3fc) se(%9.3fc) r2
			keep(bl bd bl_Ctenure bd_Ctenure bl_Cpotexp bd_Cpotexp) 
 			$stars fragment nogap label nomtitles scalar(clust) 
			append ;
#delimit cr
 


* ---------------------------------------------------------------------- *
*TABLE 9 - ROBUSTNESS CHECKS 2, SEMI-PARAMETRIC SKIN COLOR
* ---------------------------------------------------------------------- *

#delimit;
* CREATE INTERACTIONS;
local i=3 ;
foreach x in b1t3 b4 b5 b6 b7 b8 b9t10 {;
	local ++i ;

	* POTEXP;
	cap drop `x'_Cpotexp;
	gen `x'_Cpotexp=`x'*Cpotexp	;
	if "`x'"=="b1t3"  { ; lab var `x'_Cpotexp "Black, 1-3*potexp"; };
	if "`x'"=="b9t10" { ; lab var `x'_Cpotexp "Black, 9-10*potexp"; };
	else { ; lab var `x'_Cpotexp "Black, `i'*potexp"; };

	* TENURE ;
	cap drop `x'_Ctenure;
	gen `x'_Ctenure=`x'*Ctenure	;
	if "`x'"=="b1t3"  { ; lab var `x'_Ctenure "Black, 1-3*tenure"; };
	if "`x'"=="b9t10" { ; lab var `x'_Ctenure "Black, 9-10*tenure"; };
	else { ; lab var `x'_Ctenure "Black, `i'*tenure"; };
	 
};
#delimit cr


* REGRESSIONS
eststo clear
eststo: areg wage b1t3 b4 b5 b6 b7 b8 b9t10 Chgc afqtz Cpotexp  																			 									$ctls $parent $behavior $yr if $restrict_wage, $cluster absorb(intvid)
qui estadd scalar clust=e(N_clust)
eststo: areg wage b1t3 b4 b5 b6 b7 b8 b9t10 Chgc afqtz Cpotexp Chgc_Cpotexp afqtz_Cpotexp b1t3_Cpotexp b4_Cpotexp b5_Cpotexp b6_Cpotexp b7_Cpotexp b8_Cpotexp b9t10_Cpotexp 	$ctls $parent $behavior $yr if $restrict_wage, $cluster absorb(intvid)
qui estadd scalar clust=e(N_clust)
eststo: areg wage b1t3 b4 b5 b6 b7 b8 b9t10 Chgc afqtz Cpotexp Ctenure Chgc_Ctenure afqtz_Ctenure b1t3_Ctenure b4_Ctenure b5_Ctenure b6_Ctenure b7_Ctenure b8_Ctenure b9t10_Ctenure b1t3_Cpotexp b4_Cpotexp b5_Cpotexp b6_Cpotexp b7_Cpotexp b8_Cpotexp b9t10_Cpotexp	$ctls $parent $behavior $yr if $restrict_wage, $cluster absorb(intvid)
qui estadd scalar clust=e(N_clust)

* TABLE 
#delimit ;
esttab using "/Users/Kreisman/Desktop/table9.tex", 
			b(%9.3fc) se(%9.3fc) r2 wide
			drop($ctls $parent $behavior $yr) 
 			$stars fragment nogap label nomtitles scalar(clust) 
			replace ;
#delimit cr
 

 


* CLOSE LOG
cap log close

*-------------------------------------------------------------------
*-------------------------------------------------------------------
*-------------------------------------------------------------------

* END



