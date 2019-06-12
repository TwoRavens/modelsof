

use "$data/podes_pkhrollout.dta", clear	
		
		
	xtset kecid t
	global year year2000 year2003 year2005 year2011 year2014

/* Initialize empty table */
loc experiments " 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15"

	
preserve

clear all
eststo clear
estimates drop _all

set obs 10
qui gen x = 1
qui gen y = 1

loc columns = 0
 
foreach choice in `experiments' {

    loc ++columns
    qui eststo col`columns': reg x y

}

restore

/* Statistics */

loc colnum = 1
loc colnames ""

	
********************************************************************************
*****************************Column 1: Main specification **********************
********************************************************************************
	
	
	xtreg n_numberofsuicidespc post     $year if year>=2005 [aw=pop_sizebaseline], fe cluster(kabuid)

    estadd loc thisstat16 = `e(N)': col1
	

 sigstar post, prec(3)
    estadd loc thisstat3 = "`r(bstar)'": col1
    estadd loc thisstat4 = "`r(sestar)'": col1

	estadd loc thisstat8 = "Y": col1
    estadd loc thisstat9 = "Y": col1
    estadd loc thisstat13 = "Y": col1
    estadd loc thisstat10 = "N": col1
    estadd loc thisstat11 = "N": col1
    estadd loc thisstat12 = "N": col1
    estadd loc thisstat17 = "05 - 14": col1

	
sum n_numberofsuicidespc if never_treat==1 & year>=2011 [aw=pop_sizebaseline]
    estadd loc thisstat15 = string(r(mean), "%9.3f"): col1			
	
	
	
	
********************************************************************************
*****************************Column 2: No Population weight  *******************
********************************************************************************

	xtreg n_numberofsuicidespc treat_post   $year  if year>=2005, fe cluster(kecid)

  estadd loc thisstat16 = `e(N)': col2
	
 sigstar treat_post, prec(3)
    estadd loc thisstat3 = "`r(bstar)'": col2
    estadd loc thisstat4 = "`r(sestar)'": col2

		
 
	estadd loc thisstat8 = "Y": col2
    estadd loc thisstat9 = "Y": col2
    estadd loc thisstat13 = "N": col2
    estadd loc thisstat10 = "N": col2
    estadd loc thisstat11 = "N": col2
    estadd loc thisstat12 = "N": col2
    estadd loc thisstat17 = "05 - 14": col2
  
	
	sum n_numberofsuicidespc [aw=pop_sizebaseline] if never_treat==1 & year>=2011 
    estadd loc thisstat15 = string(r(mean), "%9.3f"): col2
	
	
	

********************************************************************************
*****************************Column 3: Drop RCT sample  ************************
********************************************************************************




	xtreg n_numberofsuicidespc treat_post     $year if year>=2005 & rctsample!=1 [aw=pop_sizebaseline], fe cluster(kabuid)

	 estadd loc thisstat16 = `e(N)': col3
	
 sigstar treat_post, prec(3)
    estadd loc thisstat3 = "`r(bstar)'": col3
    estadd loc thisstat4 = "`r(sestar)'": col3

		
 
	estadd loc thisstat8 = "Y": col3
    estadd loc thisstat9 = "Y": col3
    estadd loc thisstat13 = "Y": col3
    estadd loc thisstat10 = "Y": col3
    estadd loc thisstat11 = "N": col3
    estadd loc thisstat12 = "N": col3
    estadd loc thisstat17 = "05 - 14": col3
	

sum n_numberofsuicidespc if year>=2011 [aw=pop_sizebaseline]
estadd loc thisstat15 = string(r(mean), "%9.3f"): col3
	
	global year year2000 year2003 year2005 year2011 year2014
	
	
		
	
********************************************************************************
*****************************Column 4: All time periods ************************
********************************************************************************

	xtreg n_numberofsuicidespc treat_post  $year if year>=2000 [aw=pop_sizebaseline], fe cluster(kabuid)

  estadd loc thisstat16 = `e(N)': col4
	
 sigstar treat_post, prec(3)
    estadd loc thisstat3 = "`r(bstar)'": col4
    estadd loc thisstat4 = "`r(sestar)'": col4

		
 
	estadd loc thisstat8 = "Y": col4
    estadd loc thisstat9 = "Y": col4
    estadd loc thisstat13 = "Y": col4
    estadd loc thisstat10 = "N": col4
    estadd loc thisstat11 = "Y": col4
    estadd loc thisstat12 = "N": col4
    estadd loc thisstat17 = "00 - 14": col4
	
	
	sum n_numberofsuicidespc if never_treat==1 & year>=2011 [aw=pop_sizebaseline]
    estadd loc thisstat15 = string(r(mean), "%9.3f"): col4
	
	
********************************************************************************
*****************************Column 5: Sub-district trends *********************
********************************************************************************
 		preserve 	
	
	hdfe n_numberofsuicidespc  treat_post if year>=2000 [aw=pop_sizebaseline], absorb(i.kecid2000 i.kecid2000#c.year year $year ) clear  keepvars(kabuid never_treat) clustervars(kabuid)
	ivreg2 n_numberofsuicidespc treat_post    [aw=pop_sizebaseline] , cl(kabuid)
	
		 estadd loc thisstat16 = `e(N)': col5

		
 sigstar treat_post, prec(3)
    estadd loc thisstat3 = "`r(bstar)'": col5
    estadd loc thisstat4 = "`r(sestar)'": col5
	
		
	estadd loc thisstat8 = "Y": col5
    estadd loc thisstat9 = "Y": col5
    estadd loc thisstat13 = "Y": col5
    estadd loc thisstat10 = "N": col5
    estadd loc thisstat11 = "Y": col5
    estadd loc thisstat12 = "Y": col5
    estadd loc thisstat17 = "00 - 14": col5
	

	
	restore
		sum n_numberofsuicidespc if never_treat==1 & year>=2011 [aw=pop_sizebaseline]
    estadd loc thisstat15 = string(r(mean), "%9.3f"): col5


	
********************************************************************************
*****************************Column 6: Main specification **********************
********************************************************************************
	
	
	xtreg n_suicides_possion post     $year if year>=2005  , fe cluster(kabuid)

    estadd loc thisstat16 = `e(N)': col6
	

 sigstar post, prec(3)
    estadd loc thisstat3 = "`r(bstar)'": col6
    estadd loc thisstat4 = "`r(sestar)'": col6

	estadd loc thisstat8 = "Y": col6
    estadd loc thisstat9 = "Y": col6
    estadd loc thisstat13 = "N": col6
    estadd loc thisstat10 = "N": col6
    estadd loc thisstat11 = "N": col6
    estadd loc thisstat12 = "N": col6
    estadd loc thisstat17 = "05 - 14": col6
	

	
sum n_suicides_possion if never_treat==1 & year>=2011  
    estadd loc thisstat15 = string(r(mean), "%9.3f"): col6			
	
	
	
	
********************************************************************************
*****************************Column 7: No Population weight     *******************
********************************************************************************

	xtreg n_suicides_possion treat_post   $year  if year>=2005  [aw=pop_sizebaseline], fe cluster(kabuid)

  estadd loc thisstat16 = `e(N)': col7
	
 sigstar treat_post, prec(3)
    estadd loc thisstat3 = "`r(bstar)'": col7
    estadd loc thisstat4 = "`r(sestar)'": col7

		
 
	estadd loc thisstat8 = "Y": col7
    estadd loc thisstat9 = "Y": col7
    estadd loc thisstat13 = "Y": col7
    estadd loc thisstat10 = "N": col7
    estadd loc thisstat11 = "N": col7
    estadd loc thisstat12 = "N": col7
    estadd loc thisstat17 = "05 - 14": col7
	
  
	
	sum n_suicides_possion  if never_treat==1 & year>=2011  [aw=pop_sizebaseline]
    estadd loc thisstat15 = string(r(mean), "%9.3f"): col7
	
	
	

********************************************************************************
*****************************Column 8: Drop RCT sample  ************************
********************************************************************************




	xtreg n_suicides_possion treat_post     $year if year>=2005 & rctsample!=1  , fe cluster(kabuid)

	 estadd loc thisstat16 = `e(N)': col8
	
 sigstar treat_post, prec(3)
    estadd loc thisstat3 = "`r(bstar)'": col8
    estadd loc thisstat4 = "`r(sestar)'": col8

		
 
	estadd loc thisstat8 = "Y": col8
    estadd loc thisstat9 = "Y": col8
    estadd loc thisstat13 = "N": col8
    estadd loc thisstat10 = "Y": col8
    estadd loc thisstat11 = "N": col8
    estadd loc thisstat12 = "N": col8
    estadd loc thisstat17 = "05 - 14": col8
	

sum n_suicides_possion if never_treat==1 &rctsample!=1& year>=2011  
    estadd loc thisstat15 = string(r(mean), "%9.3f"): col8
	
	global year year2000 year2003 year2005 year2011 year2014
	
	
		
	
********************************************************************************
*****************************Column 9: All time periods ************************
********************************************************************************

	xtreg  n_suicides_possion treat_post  $year if year>=2000  , fe cluster(kabuid)

  estadd loc thisstat16 = `e(N)': col9
	
 sigstar treat_post, prec(3)
    estadd loc thisstat3 = "`r(bstar)'": col9
    estadd loc thisstat4 = "`r(sestar)'": col9

		 
 
	estadd loc thisstat8 = "Y": col9
    estadd loc thisstat9 = "Y": col9
    estadd loc thisstat13 = "N": col9
    estadd loc thisstat10 = "N": col9
    estadd loc thisstat11 = "Y": col9
    estadd loc thisstat12 = "N": col9
    estadd loc thisstat17 = "00 - 14": col9
	
	
	sum n_suicides_possion if never_treat==1  & year>=2011 
    estadd loc thisstat15 = string(r(mean), "%9.3f"): col9
	
	
********************************************************************************
*****************************Column 10: Sub-district trends *********************
********************************************************************************
 		preserve 	
	
	hdfe  n_suicides_possion treat_post if year>=2000  , absorb(i.kecid2000 i.kecid2000#c.year year $year) clear  keepvars(kabuid never_treat) clustervars(kabuid)
	ivreg2 n_suicides_possion treat_post   , cl(kabuid)
	
		 estadd loc thisstat16 = `e(N)': col10

		
 sigstar treat_post, prec(3)
    estadd loc thisstat3 = "`r(bstar)'": col10
    estadd loc thisstat4 = "`r(sestar)'": col10
	
		
	estadd loc thisstat8 = "Y": col10
    estadd loc thisstat9 = "Y": col10
    estadd loc thisstat13 = "N": col10
    estadd loc thisstat10 = "N": col10
    estadd loc thisstat11 = "Y": col10
    estadd loc thisstat12 = "Y": col10
    estadd loc thisstat17 = "00 - 14": col10

	 
	restore
		sum n_suicides_possion if never_treat==1  & year>=2011  
    estadd loc thisstat15 = string(r(mean), "%9.3f"): col10
	
	

********************************************************************************
*****************************Column 11: Main specification **********************
********************************************************************************
	
	
	xtreg n_numberofsuicides post     $year if year>=2005 , fe cluster(kabuid)

    estadd loc thisstat16 = `e(N)': col11
	

 sigstar post, prec(3)
    estadd loc thisstat3 = "`r(bstar)'": col11
    estadd loc thisstat4 = "`r(sestar)'": col11

	estadd loc thisstat8 = "Y": col11
    estadd loc thisstat9 = "Y": col11
    estadd loc thisstat13 = "N": col11
    estadd loc thisstat10 = "N": col11
    estadd loc thisstat11 = "N": col11
    estadd loc thisstat12 = "N": col11
    estadd loc thisstat17 = "05 - 14": col11
	

	
sum n_numberofsuicides if never_treat==1 & year>=2011  
    estadd loc thisstat15 = string(r(mean), "%9.3f"): col11		
	
	
	
	
********************************************************************************
*****************************Column 12: Population weight   *******************
********************************************************************************

	xtreg n_numberofsuicides treat_post   $year if year>=2005  [aw=pop_sizebaseline], fe cluster(kabuid)

  estadd loc thisstat16 = `e(N)': col12
	
 sigstar treat_post, prec(3)
    estadd loc thisstat3 = "`r(bstar)'": col12
    estadd loc thisstat4 = "`r(sestar)'": col12

		
 
	estadd loc thisstat8 = "Y": col12
    estadd loc thisstat9 = "Y": col12
    estadd loc thisstat13 = "Y": col12
    estadd loc thisstat10 = "N": col12
    estadd loc thisstat11 = "N": col12
    estadd loc thisstat12 = "N": col12
    estadd loc thisstat17 = "05 - 14": col12
  
	
	sum n_numberofsuicides  if never_treat==1 & year>=2011  [aw=pop_sizebaseline]
    estadd loc thisstat15 = string(r(mean), "%9.3f"): col12
	
	
	

********************************************************************************
*****************************Column 13: Drop RCT sample  ************************
********************************************************************************




	xtreg n_numberofsuicides treat_post     $year if year>=2005 & rctsample!=1  , fe cluster(kabuid)

	 estadd loc thisstat16 = `e(N)': col13
	
 sigstar treat_post, prec(3)
    estadd loc thisstat3 = "`r(bstar)'": col13
    estadd loc thisstat4 = "`r(sestar)'": col13

		
 
	estadd loc thisstat8 = "Y": col13
    estadd loc thisstat9 = "Y": col13
    estadd loc thisstat13 = "N": col13
    estadd loc thisstat10 = "Y": col13
    estadd loc thisstat11 = "N": col13
    estadd loc thisstat12 = "N": col13
    estadd loc thisstat17 = "05 - 14": col13
	

sum n_numberofsuicides if never_treat==1 &rctsample!=1& year>=2011  [aw=pop_sizebaseline]
    estadd loc thisstat15 = string(r(mean), "%9.3f"): col13
	
	global year year2000 year2003 year2005 year2011 year2014
	
	
		
	
********************************************************************************
*****************************Column 14: All time periods ************************
********************************************************************************

	xtreg n_numberofsuicides treat_post    $year if year>=2000 , fe cluster(kabuid)

  estadd loc thisstat16 = `e(N)': col14
	
 sigstar treat_post, prec(3)
    estadd loc thisstat3 = "`r(bstar)'": col14
    estadd loc thisstat4 = "`r(sestar)'": col14

		 
 
	estadd loc thisstat8 = "Y": col14
    estadd loc thisstat9 = "Y": col14
    estadd loc thisstat13 = "N": col14
    estadd loc thisstat10 = "N": col14
    estadd loc thisstat11 = "Y": col14
    estadd loc thisstat12 = "N": col14
    estadd loc thisstat17 = "00 - 14": col14
	
	
	sum n_numberofsuicides if never_treat==1  & year>=2011  
    estadd loc thisstat15 = string(r(mean), "%9.3f"): col14
	
	
********************************************************************************
*****************************Column 15: Sub-district trends *********************
********************************************************************************
 		preserve 	
	
	hdfe n_numberofsuicides  treat_post if year>=2000  [aw=pop_sizebaseline], absorb(i.kecid2000 i.kecid2000#c.year year $year) clear  keepvars(kabuid never_treat) clustervars(kabuid)
	ivreg2 n_numberofsuicides treat_post    [aw=pop_sizebaseline] , cl(kabuid)
	
		 estadd loc thisstat16 = `e(N)': col15

		
 sigstar treat_post, prec(3)
    estadd loc thisstat3 = "`r(bstar)'": col15
    estadd loc thisstat4 = "`r(sestar)'": col15
	
		
	estadd loc thisstat8 = "Y": col15
    estadd loc thisstat9 = "Y": col15
    estadd loc thisstat13 = "N": col15
    estadd loc thisstat10 = "N": col15
    estadd loc thisstat11 = "Y": col15
    estadd loc thisstat12 = "Y": col15
    estadd loc thisstat17 = "00 - 14": col15
	

	 
	restore
		sum n_numberofsuicides if never_treat==1  & year>=2011  
    estadd loc thisstat15 = string(r(mean), "%9.3f"): col15
		

 
loc rowlabels " " " " " "Treatment " " " " " " " " "   "\hline Subdistrict FE" "Time FE"  "Exclude RCT sample" "Include pre-treatment periods" "Subdistrict trends" "Population weight" " " "\hline Conrol mean (2011 \& 2014)" "N" "Census waves"  "
loc rowstats ""

forval i = 1/17 {
    loc rowstats "`rowstats' thisstat`i'"
}





esttab * using "$tables/TableA5_rollout_alternativeoutcomes2.tex", replace cells(none) nomtitles booktabs nonotes compress ///
 alignment(c) nogap noobs nobaselevels label stats(`rowstats', labels(`rowlabels')) ///
    mgroup("Suicide rate (2005 population)"   "Number of suicides (extrapolated - Poisson)" "Number of suicides", pattern(1 0 0 0 0 1 0 0 0 0 1 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) 


eststo clear
	
	
 
