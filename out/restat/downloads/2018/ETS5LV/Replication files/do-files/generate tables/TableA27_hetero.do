
use "$data/podes_pkhrollout.dta", clear
		
		
	xtset kecid t
	global year year2000 year2003 year2005 year2011 year2014
	
*Generate percentage poor *

gen zperc_poor=.

sum poor	if year==2005
gen temp=(poor-r(mean))/r(sd) if year==2005
bys kecid2000: egen temp1=max(temp)
replace zperc_poor=temp1
drop temp*


gen post_zperc_poor= zperc_poor*post
	
loc experiments " 1 2 3 4 5 6 7"

	
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
	
	
	xtreg nsuicidespc post post_zperc_poor post_pcexp  post_perc_farmers2005baseline post_pcn_crimebaseline post_pcn_socorgbaseline post_pcHealthbaseline c.pcexp#c.year c.perc_farmers2005baseline#c.year c.pcn_crimebaseline#c.year c.pcn_socorgbaseline#c.year c.pcHealthbaseline#c.year c.zperc_poor#c.year  i.year	if year>=2005 [aw=pop_sizebaseline], fe cl(kabuid)

	

	sigstar post, prec(3)
    estadd loc thisstat3 = "`r(bstar)'": col1
    estadd loc thisstat4 = "`r(sestar)'": col1


	sigstar post_zperc_poor, prec(3)
    estadd loc thisstat6 = "`r(bstar)'": col1
    estadd loc thisstat7 = "`r(sestar)'": col1
	

	sigstar post_perc_farmers2005baseline, prec(3)
    estadd loc thisstat9 = "`r(bstar)'": col1
    estadd loc thisstat10 = "`r(sestar)'": col1

	sigstar post_pcexp , prec(3)
    estadd loc thisstat12 = "`r(bstar)'": col1
    estadd loc thisstat13 = "`r(sestar)'": col1

	sigstar post_pcn_crimebaseline, prec(3)
    estadd loc thisstat15 = "`r(bstar)'": col1
    estadd loc thisstat16 = "`r(sestar)'": col1

	sigstar post_pcn_socorgbaseline, prec(3)
    estadd loc thisstat18 = "`r(bstar)'": col1
    estadd loc thisstat19 = "`r(sestar)'": col1
	
	
	sigstar post_pcHealthbaseline, prec(3)
    estadd loc thisstat21 = "`r(bstar)'": col1
    estadd loc thisstat22 = "`r(sestar)'": col1
			
			
			
	
    estadd loc thisstat25 = `e(N)': col1
    estadd loc thisstat26 = "05-14": col1

	
	
********************************************************************************
*****************************Column 2: Percent poor          *******************
********************************************************************************

		xtreg nsuicidespc post_zperc_poor post zperc_poor c.zperc_poor#c.year i.year	if year>=2005 [aw=pop_sizebaseline], fe cl(kabuid)
    estadd loc thisstat25 = `e(N)': col2
    estadd loc thisstat26 = "05-14": col2


	sigstar post, prec(3)
    estadd loc thisstat3 = "`r(bstar)'": col2
    estadd loc thisstat4 = "`r(sestar)'": col2


	sigstar post_zperc_poor, prec(3)
    estadd loc thisstat6 = "`r(bstar)'": col2
    estadd loc thisstat7 = "`r(sestar)'": col2
		
	loc sem = `r(sestar)'*2.8
    estadd loc thisstat24= string(`sem', "%9.3f"): col2	
		

********************************************************************************
*****************************Column 3: Percentage of farmers********************
********************************************************************************

	xtreg nsuicidespc post_perc_farmers2005baseline post c.perc_farmers2005baseline#c.year i.year	if year>=2005 [aw=pop_sizebaseline], fe cl(kabuid)
    estadd loc thisstat25 = `e(N)': col3
    estadd loc thisstat26 = "05-14": col3


	sigstar post, prec(3)
    estadd loc thisstat3 = "`r(bstar)'": col3
    estadd loc thisstat4 = "`r(sestar)'": col3

	sigstar post_perc_farmers2005baseline, prec(3)
    estadd loc thisstat9 = "`r(bstar)'": col3
    estadd loc thisstat10 = "`r(sestar)'": col3

	loc sem = `r(sestar)'*2.8
    estadd loc thisstat24= string(`sem', "%9.3f"): col3

********************************************************************************	
*****************************Column 4: Per capita expenditure*******************	
********************************************************************************

	xtreg nsuicidespc post_pcexp post c.pcexp#c.year i.year	if year>=2005 [aw=pop_sizebaseline], fe cl(kabuid)
    estadd loc thisstat25 = `e(N)': col4
    estadd loc thisstat26 = "05-14": col4


	sigstar post, prec(3)
    estadd loc thisstat3 = "`r(bstar)'": col4
    estadd loc thisstat4 = "`r(sestar)'": col4

	sigstar post_pcexp , prec(3)
    estadd loc thisstat12 = "`r(bstar)'": col4
    estadd loc thisstat13 = "`r(sestar)'": col4

	loc sem = `r(sestar)'*2.8
    estadd loc thisstat24= string(`sem', "%9.3f"): col4
	

********************************************************************************
*****************************Column 5: Crime************************************
********************************************************************************

		xtreg nsuicidespc post_pcn_crimebaseline post c.year#c.pcn_crimebaseline i.year	if year>=2005 [aw=pop_sizebaseline], fe cl(kabuid)
    estadd loc thisstat25 = `e(N)': col5
    estadd loc thisstat26 = "05-14": col5

	
	sigstar post, prec(3)
    estadd loc thisstat3 = "`r(bstar)'": col5
    estadd loc thisstat4 = "`r(sestar)'": col5	
	

	sigstar post_pcn_crimebaseline, prec(3)
    estadd loc thisstat15 = "`r(bstar)'": col5
    estadd loc thisstat16 = "`r(sestar)'": col5	
	
	loc sem = `r(sestar)'*2.8
    estadd loc thisstat24= string(`sem', "%9.3f"): col5
		
********************************************************************************
*****************************Column 6: Social capital*************************** 
********************************************************************************

		xtreg nsuicidespc post_pcn_socorgbaseline post c.year#c.pcn_socorgbaseline i.year	if year>=2005 [aw=pop_sizebaseline], fe cl(kabuid)

    estadd loc thisstat25 = `e(N)': col6
    estadd loc thisstat26 = "05-14": col6
	
	sigstar post, prec(3)
    estadd loc thisstat3 = "`r(bstar)'": col6
    estadd loc thisstat4 = "`r(sestar)'": col6
	

	sigstar post_pcn_socorgbaseline, prec(3)
    estadd loc thisstat18 = "`r(bstar)'": col6
    estadd loc thisstat19 = "`r(sestar)'": col6
	loc sem = `r(sestar)'*2.8
    estadd loc thisstat24= string(`sem', "%9.3f"): col6
		
********************************************************************************
*****************************Column 7: Health*************************** 
********************************************************************************
		
		xtreg nsuicidespc post_pcHealthbaseline post  c.year#c.pcHealthbaseline i.year	if year>=2005 [aw=pop_sizebaseline], fe cl(kabuid)
		
    estadd loc thisstat25 = `e(N)': col7
    estadd loc thisstat26 = "05-14": col7

	sigstar post, prec(3)
    estadd loc thisstat3 = "`r(bstar)'": col7
    estadd loc thisstat4 = "`r(sestar)'": col7
	

	sigstar post_pcHealthbaseline, prec(3)
    estadd loc thisstat21 = "`r(bstar)'": col7
    estadd loc thisstat22 = "`r(sestar)'": col7	
	loc sem = `r(sestar)'*2.8
    estadd loc thisstat24= string(`sem', "%9.3f"): col7
	 
 
loc rowlabels " "Dependent variable: Suicide rate " "\cline{1-1} " "Treatment" " " " ""Treatment $\times$" "Fract poor (z)" " "  "Treatment $\times$" "Perc. Farmers (z)" " " "Treatment $\times$" "Per Capita Excp (z)" " " "Treatment $\times$" "Per Capita Crimes (z)" " " "Treatment $\times$" "Per Capita Social Institutions (z)" " " "Treatment $\times$" "Per Capita Health Institutions (z)" " " "\hline Minimum detectable effect size" "N" "Census waves" "
loc rowstats ""

forval i = 1/26 {
    loc rowstats "`rowstats' thisstat`i'"
}




esttab * using "$tables/TableA27_hetero.tex", replace cells(none) booktabs nonotes nomtitle compress ///
 alignment(c) nogap noobs nobaselevels label stats(`rowstats', labels(`rowlabels')) 
 


eststo clear
	
	
 
