/* This .do file provides the code to produce all Figures and Tables in the main text and the Online Supplementary Materials of "Public-Sector Unions and the Size of Government" by Agustina S. Paglayan. 

Before executing the code, users need to download the following files in their selected path/ directory:

Paglayan Dataset.dta 		(.csv file also available)
UScoord.dta
CBA_Coverage.dta
CBA_Coverage.csv

*/

clear all
set more off, perm
version 11.0 	//Stata version number; note that results may differ slightly depending on the version of Stata used 
global path "C:\Users\apaglayan\Dropbox\Stanford\Teacher unions\AJPS Replication\FINAL\"  	// REPLACE WITH THE PATH YOU WANT TO USE
cd "${path}"


* FIGURE 1: 
*----------

	use "${path}Paglayan Dataset.dta", clear
	
	ssc install spmap 
	spmap CBstatusby1990 using "${path}UScoord.dta" if year==1990 & idmap!=1 & idmap!=56 & idmap!=4 & idmap!=13 & idmap!=40 & idmap!=46 & idmap!=55,  ///
		id(idmap) clmethod(unique) fcolor(gs14 gs10 gs6) legend(symy(*2) symx(*2) size(*2))  
	

* FIGURE 2 & SUPPLEMENTARY FIGURE A4: 
*------------------------------------

	use "${path}Paglayan Dataset.dta", clear

	net install grc1leg, from("http://www.stata.com/users/vwiggins")
	
	local vars studteachratio lnavgteachsal lnppexpend lnnonwageppexpend
	local titlestudteachratio "Student-teacher ratio"
	local titlelnavgteachsal "Annual teacher salary (log, 2010 $)"
	local titlelnppexpend "Per-pupil current expenditures (log, 2010 $)"
	local titlelnnonwageppexpend "Per-pupil non-wage expenditures (log, 2010 $)"

	local studteachratioyear 1959
	local lnavgteachsalyear 1939
	local lnppexpendyear 1919
	local lnnonwageppexpendyear 1959
	 
	replace lnavgteachsal=lnavginstrucsal if year==1949 | year==1939

	foreach y of local vars{
	capture drop `y'_all_mean `y'_CBproh_mean `y'_CBallow_mean `y'_CBreq_mean `y'_CBnotreq_mean
	bysort year: egen `y'_all_mean=mean(`y')
	bysort year: egen `y'_CBproh_mean=mean(`y') if CBstatusby1990==0
	bysort year: egen `y'_CBallow_mean=mean(`y') if CBstatusby1990==1
	bysort year: egen `y'_CBreq_mean=mean(`y') if CBstatusby1990==2
	bysort year: egen `y'_CBnotreq_mean=mean(`y') if CBstatusby1990==0 | CBstatusby1990==1

	twoway (line `y'_all_mean year, lpattern(dash) lcolor(black) lwidth(thin)) ///
	(line `y'_CBreq_mean year, lpattern(solid) lcolor(black) lwidth(thick)) ///
	(line `y'_CBallow_mean year, lpattern(solid) lcolor(gs10) lwidth(thick)) ///
	(line `y'_CBproh_mean year, lpattern(solid) lcolor(gs14) lwidth(thick)) if year>=1959 & year<=1990, ///
	ytitle(" ") title(`title`y'') xtitle("School Year") xlabel(1960(10)1990)  /// 
	legend(order(1 2 3 4) label (1 "All states") label (2 "States that by 1990 had mandatory CB") label (3 "States that by 1990 allowed but did not mandate CB") label (4 "States that by 1990 did not allow CB") size(small) rowgap(0.5)) ///
	scale(0.85)	scheme(s1manual)  nodraw name(`y', replace) 

	twoway (line `y'_all_mean year, lpattern(dash) lcolor(black) lwidth(thin)) ///
	(line `y'_CBreq_mean year, lpattern(solid) lcolor(gs4) lwidth(thick)) ///
	(line `y'_CBallow_mean year, lpattern(solid) lcolor(gs10) lwidth(thick)) ///
	(line `y'_CBproh_mean year, lpattern(solid) lcolor(gs14) lwidth(thick)) if year>=``y'year' & year<=1990, ///
	ytitle(" ") title(`title`y'') xtitle("School Year")  /// 
	legend(order(1 2 3 4) label (1 "All states") label (2 "States that by 1990 had mandatory CB") label (3 "States that by 1990 allowed but did not mandate CB") label (4 "States that by 1990 did not allow CB") size(vsmall) rowgap(0.5)) ///
	scale(0.85)	scheme(s1manual)  nodraw name(`y'his, replace) 
	}
	
* Figure 2:

	grc1leg studteachratio lnavgteachsal lnppexpend lnnonwageppexpend, ///
		scheme(s1manual) rows(2) scale(0.85) name(Figure2, replace) 

* Supplementary Figure A4:
	
	grc1leg lnavgteachsalhis lnppexpendhis, ///
		scheme(s1manual) rows(1) graphregion(margin(1 1 35 1)) scale(0.95) name(FigureA4, replace) 


* FIGURE 3: 
*----------

	use "${path}Paglayan Dataset.dta", clear

	drop if State=="DC" | State=="WI"
	drop if year<1959
	drop if year>1997
	
	gen yeargphcent=year-YearCBrequired
	gen treatment=(yeargphcent>=0 & yeargphcent!=.)
	
	local vars studteachratio lnavgteachsal lnppexpend lnnonwageppexpend
	foreach y of local vars {
		bysort year: egen c`y'=mean(`y') if CBstatusby1990==0    // mean `y' in each year among states that by 1990 did not allow CB with teachers
		bysort year: egen c2`y'=mean(c`y')						
	}
	sort State year

	preserve
	
	collapse (mean) studteachratio lnavgteachsal lnppexpend lnnonwageppexpend c2studteachratio c2lnavgteachsal c2lnppexpend c2lnnonwageppexpend, by(yeargphcent)
	
	local vars studteachratio lnavgteachsal lnppexpend lnnonwageppexpend
	local titstudteachratio 		"Student-teacher ratio"
	local titlnavgteachsal 			"Annual teacher salary (log, 2010 $)"
	local titlnppexpend 			"Per-pupil current expenditures (log, 2010 $)"
	local titlnnonwageppexpend 		"Per-pupil non-wage current expenditures (log, 2010 $)"
	local ylabstudteachratio 	16(2)26
	local ylablnavgteachsal		10(0.5)11.5
	local ylablnppexpend		7.5(0.5)9
	local ylablnnonwageppexpend 7(0.5)8.5
	
	foreach y of local vars {
		twoway (line `y' yeargphcent, lcolor(black) lpattern(solid) lwidth(thick)) ///
		(line c2`y' yeargphcent, lcolor(gs12) lpattern(solid) lwidth(thick)) ///
		if yeargphcent>=-6 & yeargphcent<=10, ///
		xtitle("Years relative to mandatory collective bargaining law") ytitle(" ") title(`tit`y'') ylabel(`ylab`y'') ///
		legend(order(1 2) label(1 "States that by 1990 had a mandatory CB law") label(2 "States that by 1990 did not allow CB with teachers") size(small) rows(3)) xlabel(-6(1)10) xlin(-0.1, lpattern(dash)) legend(off) scale(0.9) scheme(s1manual) name(F3`y', replace) nodraw
	}

	grc1leg F3studteachratio F3lnppexpend F3lnavgteachsal F3lnnonwageppexpend, scale(0.8) imargin(4 4 4 4) cols(2) scheme(s1manual) name(Figure3, replace) 

	restore


* FIGURE 4 & SUPPLEMENTARY TABLE A5: 
*-----------------------------------

	use "${path}Paglayan Dataset.dta", clear

	estimates clear
	tsset Stateid year

	drop if State=="DC" | State=="WI"
	keep if YearCBrequired!=.

	gen yeargphcent=year-YearCBrequired

	drop if year<1959
	drop if year>1997
				
	tsset Stateid year

	forvalues n = 1/6 {
		gen pre`n' = (yeargphcent==-`n')
	}
	forvalues n = 0/10 {
		gen post`n' = (yeargphcent==`n')
	}

		local vars studteachratio lnavgteachsal lnppexpend lnnonwageppexpend
		local titstudteachratio 		"Student-teacher ratio"
		local titlnavgteachsal 			"Annual teacher salary (log, 2010 $)"
		local titlnppexpend 			"Per-pupil current expenditures (log, 2010 $)"
		local titlnnonwageppexpend 		"Per-pupil non-wage current expenditures (log, 2010 $)"
		local ylabstudteachratio 	-2(1)2
		local ylablnavgteachsal		-0.2(0.1)0.2
		local ylablnppexpend		-0.2(0.1)0.2
		local ylablnnonwageppexpend -0.2(0.1)0.2
		
		foreach y of local vars {

		tempname memhold2`y'
		tempfile results2`y'
		postfile `memhold2`y'' year pre prese post postse using `results2`y''

		preserve

			xtreg  `y' i.year pre6 pre5 pre4 pre3 pre2 pre1 post0-post10,  fe vce(cluster Stateid)
			est store nonp`y'

			forval n = 1(1)6 {
				post `memhold2`y'' (`n') (_b[pre`n']) (_se[pre`n']) (.) (.)
			}
				
			forval n =0(1)10 {
				post `memhold2`y'' (`n') (.) (.) (_b[post`n']) (_se[post`n']) 
			}	

		postclose `memhold2`y''
		use `results2`y'', clear

		gen yearpre = -1*year if pre !=.
		gen yearpost = year if post !=.

		gen prehi = pre + 1.96*prese
		gen prelo = pre - 1.96*prese

		gen posthi = post + 1.96*postse
		gen postlo = post - 1.96*postse

		twoway (rcap prehi prelo yearpre, lpattern(solid) lcolor(gs8)) ///
		(rcap posthi postlo yearpost, lpattern(solid) lcolor(gs8))    ///
		(scatter pre yearpre, msymbol(o) msize(vlarge) mcolor(black)) ///
		(scatter post yearpost, msymbol(o) msize(vlarge) mcolor(black)) ,  ///
		xtitle("Years relative to mandatory collective bargaining law") ytitle("ATT Effect (Treated - Control)") title(`tit`y'') ///
		xlabel(-6(1)10) ylabel(`ylab`y'') yline(0) xlin(0) ///
		legend(off) scale(0.9) scheme(s1manual) name(gph`y'nonpe, replace) nodraw			

		restore
	}

* Supplementary Table A5:

	estout nonp* using "${path}TableA5.xls", replace ///
	cells(b(star fmt(6)) se(par(`"="("'`")""')fmt(4))) drop(*year) label stats(N r2_a, labels("Observations" "Adj. R-Square")) starlevels(* 0.05 ** 0.01) stardetach

* Figure 4: 

	graph combine gphstudteachrationonpe gphlnppexpendnonpe gphlnavgteachsalnonpe gphlnnonwageppexpendnonpe, scale(0.75) imargin(4 4 4 4) cols(2) scheme(s1manual) name(Figure4, replace) 


* TABLE 2: 
*-------------------------------------------------------------------------

	use "${path}Paglayan Dataset.dta", clear

	estimates clear
	tsset Stateid year

	preserve 	
	
	keep if YearCBrequired!=.
	
	drop if State=="DC" | State=="WI"
	drop if year<1959
	drop if year>1997
				
	tsset Stateid year
	fvset base 1 year
	estimates clear
	local vars studteachratio lnavgteachsal lnppexpend lnnonwageppexpend 
	foreach y of local vars {
	
		tsset Stateid year		
		xtreg `y' 	i.year  CBrequired_SY , fe vce(cluster Stateid)
		estimates store T2`y'		
	
	}
	
	estout T2* using "${path}Table2.xls", replace ///
	cells(b(star fmt(3)) se(par(`"="("'`")""')fmt(4)) ci(fmt(3))) drop(*year) label stats(N r2_a, labels("Observations" "Adj. R-Square")) starlevels(* 0.05 ** 0.01) stardetach
	* note: results may differ slightly depending on the version of Stata used 

	restore


* FIGURE 5: 
*----------

	clear all
	use "${path}CBA_Coverage.dta" 
			
	drop if YearCBrequired==.
	drop if State=="WI"
	
	gen yeargphcent=year-YearCBrequired
	gen treatment=(yeargphcent>=0 & yeargphcent!=.)    
	
	local vars CBteachers
	foreach y of local vars {
		bysort year: egen c`y'=mean(`y') if treatment==0   // control group's mean primratio in each year 
		bysort year: egen c2`y'=mean(c`y')				   // assigns control group mean values to each country in every year
	} 
	
	preserve
	
	collapse (mean) CBteachers c2CBteachers, by(yeargphcent)
		twoway (line CBteachers yeargphcent if yeargphcent>=-6 & yeargphcent<=-1, lcolor(black) lpattern(dash) lwidth(thick)) ///
		(line CBteachers yeargphcent if yeargphcent>=0 & yeargphcent<=10, lcolor(black) lpattern(solid) lwidth(thick)) ///
		(line c2CBteachers yeargphcent if yeargphcent>=-6 & yeargphcent<=-1, lcolor(gs10) lpattern(dash) lwidth(thick)) ///
		(line c2CBteachers yeargphcent if yeargphcent>=0 & yeargphcent<=10, lcolor(gs10) lpattern(solid) lwidth(thick)) , ///
		 xtitle("Years relative to mandatory collective bargaining law") ytitle("% of teachers covered by a CB agreement") ///
		legend(off) xlabel(-6(1)10) xlin(0) legend(off) scale(1) scheme(s1manual) name(Figure5, replace)		 

	restore
	
* TABLE 3: 
*---------

	use "${path}Paglayan Dataset.dta", clear

	estimates clear
	tsset Stateid year

	preserve 	
	
	keep if YearCBrequired!=.
	drop if State=="DC" | State=="WI"
	
	gen nopenalties=(State=="WI" | State=="CT" | State=="MI" | State=="MA" | State=="RI" | State=="VT" | State=="ME" | State=="AK" | ///
	State=="KS" | State=="HI" | State=="PA" | State=="ID" | State=="OR" | State=="MT")     		
	label var nopenalties "Mandatory CB law does not establish credible strike penalties" 
				/* note: 	coding of penalty types is based on the content of the mandatory collective bargaining law passed by a state in the year specified under the variable YearCBrequired. 
							states with non-credible penalties (nopenalties=1) are those where the law established no penalties whatsoever against strikes, or establishes only dismissal and/or jail as strike penalties.*/

	gen yeargphcent=year-YearCBrequired

	drop if year<1959
	drop if year>1997
				
	tsset Stateid year
	fvset base 1 year
	estimates clear
	local vars studteachratio lnavgteachsal lnppexpend lnnonwageppexpend 
	foreach y of local vars {
	
		tsset Stateid year		
		xtreg `y' 	i.year  CBrequired_SY c.CBrequired_SY#c.nopenalties , fe vce(cluster Stateid)
		estimates store T3`y'		

	}
	
	estout T3* using "${path}Table3.xls", replace ///
	cells(b(star fmt(6)) se(par(`"="("'`")""')fmt(4))) drop(*year) label stats(N r2_a, labels("Observations" "Adj. R-Square")) starlevels(* 0.05 ** 0.01) stardetach

	restore


* SUPPLEMENTARY FIGURE A1: 
*-------------------------

	clear all

	use "C:\Users\apaglayan\Dropbox\Stanford\Teacher unions\CreateData\CBA_Coverage.dta", clear
	collapse (mean) CBteachers, by(year)
	save "${path}CBA_Coverage_by_year.dta", replace

	use "${path}Paglayan Dataset.dta", clear
	drop if State=="DC"
	sort year
	collapse (sum) CBrequired_SY, by(year)
	save "${path}Timing_CB_laws.dta", replace

	merge 1:1 year using "${path}CBA_Coverage_by_year.dta"

	replace CBteachers=(69.1+69.4)/2 if year==1983   	// data come from Unionstats website (http://www.unionstats.com/)
	replace CBteachers=(67.3+68.9)/2 if year==1984		// data come from Unionstats website
	replace CBteachers=(66.7+67.6)/2 if year==1985		// data come from Unionstats website
	replace CBteachers=(64.7+68.4)/2 if year==1986		// data come from Unionstats website
	replace CBteachers=(66.7+67.5)/2 if year==1987		// data come from Unionstats website
	replace CBteachers=(66.1+69.3)/2 if year==1988		// data come from Unionstats website
	replace CBteachers=(65.7+67.3)/2 if year==1989		// data come from Unionstats website
	replace CBteachers=(65.6+66.6)/2 if year==1990		// data come from Unionstats website
	replace CBteachers=(63.6+66.1)/2 if year==1991		// data come from Unionstats website
	replace CBteachers=(62.2+66.7)/2 if year==1992		// data come from Unionstats website
	replace CBteachers=(66+65.9)/2 if year==1993		// data come from Unionstats website
	replace CBteachers=(64.4+66.5)/2 if year==1994		// data come from Unionstats website
	replace CBteachers=(63.4+65.2)/2 if year==1995		// data come from Unionstats website

	graph twoway (connect CBrequired_SY year, lwidth(medthick) lcolor(grey) mcolor(grey) msize(msmall)) ///
		(line CBteachers year, lwidth(thick) lcolor(red) msize(msmall) yaxis(2)) if year>=1959 & year<=1995,  ///
		xlabel(1960(5)1995) ylabel(0(10)50) ylabel(0(20)100, axis(2)) /// 
		xtitle("School year") ytitle("Number of states with duty-to-bargain laws") ytitle("% of teachers covered by a CBA", axis(2)) ///
		scheme(s1manual) scale(0.8) legend(order(1 2) label(1 "States that require CB (left)") label(2 "% of teachers covered by CB (right)")) name(FigureA1, replace)


* SUPPLEMENTARY FIGURE A2: 
*-------------------------

	use "${path}Paglayan Dataset.dta", clear

	keep if South==1

	local vars studteachratio lnavgteachsal lnppexpend lnnonwageppexpend
	local titlestudteachratio "Student-teacher ratio"
	local titlelnavgteachsal "Annual teacher salary (log, 2010 $)"
	local titlelnppexpend "Per-pupil current expenditures (log, 2010 $)"
	local titlelnnonwageppexpend "Per-pupil non-wage expenditures (log, 2010 $)"
	
	local studteachratioyear 1959
	local lnavgteachsalyear 1939
	local lnppexpendyear 1919
	local lnnonwageppexpendyear 1959

	replace lnavgteachsal=lnavginstrucsal if year==1949 | year==1939

	foreach y of local vars{
	capture drop `y'_all_mean `y'_CBproh_mean `y'_CBallow_mean `y'_CBreq_mean `y'_CBnotreq_mean
	bysort year: egen `y'_all_mean=mean(`y')
	bysort year: egen `y'_CBproh_mean=mean(`y') if CBstatusby1990==0
	bysort year: egen `y'_CBallow_mean=mean(`y') if CBstatusby1990==1
	bysort year: egen `y'_CBreq_mean=mean(`y') if CBstatusby1990==2
	bysort year: egen `y'_CBnotreq_mean=mean(`y') if CBstatusby1990==0 | CBstatusby1990==1

	twoway (line `y'_all_mean year, lpattern(dash) lcolor(black) lwidth(thin)) ///
	(line `y'_CBreq_mean year, lpattern(solid) lcolor(gs4) lwidth(thick)) ///
	(line `y'_CBallow_mean year, lpattern(solid) lcolor(gs10) lwidth(thick)) ///
	(line `y'_CBproh_mean year, lpattern(solid) lcolor(gs14) lwidth(thick)) if year>=1959 & year<=1990, ///
	title(`title`y'') ytitle(" ") xtitle("School Year") xlabel(1960(10)1990)  /// 
	legend(order(1 2 3 4) label (1 "All states") label (2 "States that required CB in 1990") label (3 "States that allowed CB in 1990") label (4 "States that did not allow CB in 1990") size(vsmall) rowgap(0.5)) ///
	scale(0.75)	scheme(s1manual)  nodraw name(`y'S, replace) 
	}
	
	net install grc1leg, from("http://www.stata.com/users/vwiggins")
	grc1leg studteachratioS lnavgteachsalS lnppexpendS lnnonwageppexpendS, ///
		scheme(s1manual) rows(2) scale(0.95) name(FigureA2, replace) 


* SUPPLEMENTARY FIGURE A3: 
*-------------------------

	use "${path}Paglayan Dataset.dta", clear

	tsset Stateid year

	levelsof State, local(state)
	local CByearWI	1960
	local CByearCT	1965
	local CByearMI	1965
	local CByearMA	1966
	local CByearRI	1966
	local CByearDC	1968
	local CByearNJ	1968
	local CByearNY	1968
	local CByearMD	1969
	local CByearND	1969
	local CByearNV	1969
	local CByearSD	1969
	local CByearAK	1970
	local CByearDE	1970
	local CByearHI	1970
	local CByearKS	1970
	local CByearME	1970
	local CByearVT	1970
	local CByearID	1971
	local CByearOK	1971
	local CByearPA	1971
	local CByearMN	1972
	local CByearIN	1973
	local CByearFL	1974
	local CByearOR	1974
	local CByearIA	1975
	local CByearMT	1975
	local CByearCA	1976
	local CByearNH	1976
	local CByearWA	1976
	local CByearTN	1978
	local CByearIL	1984
	local CByearOH	1984
	local CByearNE	1987
	 
	local vars studteachratio lnavgteachsal lnppexpend lnnonwageppexpend
	foreach y of local vars {
			gen `y'59t=.
			replace `y'59t=`y' if year==1959
			bysort Stateid: egen `y'59=mean(`y'59)
			gen `y'b=.
			replace `y'b=100 if year==1959
			replace `y'b=`y'*100/`y'59
			drop `y'59t `y'59
			rename `y'b `y'59
	}

	foreach j of local state {				
			graph twoway (line studteachratio59 year, lcolor(gs8) lpattern(dash)) ///
			(line lnavgteachsal59 year, lcolor(black) lpattern(dash)) ///
			(line lnppexpend59 year, lcolor(black) lpattern(solid)) ///
			(line lnnonwageppexpend59 year, lcolor(gs8) lpattern(solid)) ///
			if State=="`j'" & year>=1959, ///
			xlin(`CByear`j'') title("`j'") ytitle("Base Year 1959=100") xtitle("Year") ///
			legend(off) scheme(s1manual) scale(0.8) name(`j'base, replace) nodraw
	}

	graph combine CTbase MIbase MAbase RIbase NJbase NYbase MDbase NVbase NDbase, ///
		cols(3) scale(0.8) name(FigureA3a, replace) scheme(s1manual)

	graph combine SDbase AKbase DEbase HIbase KSbase MEbase VTbase IDbase OKbase, ///
		cols(3) scale(0.8) name(FigureA3b, replace) scheme(s1manual)
			
	graph combine PAbase MNbase INbase FLbase ORbase IAbase MTbase CAbase NHbase, ///
		cols(3) scale(0.8) name(FigureA3c, replace) scheme(s1manual)

	graph combine WAbase TNbase ILbase OHbase NEbase, ///
		cols(3) scale(0.8) imargin(1 1 15 1) name(FigureA3d, replace) scheme(s1manual)

	
* SUPPLEMENTARY FIGURE A4: 
*-------------------------

* code provided earlier in this file


* SUPPLEMENTARY FIGURE A5: 
*-------------------------

	use "${path}Paglayan Dataset.dta", clear

	estimates clear
	tsset Stateid year

	drop if State=="DC" | State=="WI"

	gen yeargphcent=year-YearCBrequired
	drop if yeargphcent<-6
	drop if yeargphcent>10 & yeargphcent!=.
	replace yeargphcent = year if yeargphcent==. 

	drop if year<1959
	drop if year>1997
				
	tsset Stateid year

	forvalues n = 1/6 {
		gen pre`n' = (yeargphcent==-`n')
	}
	forvalues n = 0/10 {
		gen post`n' = (yeargphcent==`n')
	}

		local vars studteachratio lnavgteachsal lnppexpend lnnonwageppexpend
		local titstudteachratio 		"Student-teacher ratio"
		local titlnavgteachsal 			"Annual teacher salary (log, 2010 $)"
		local titlnppexpend 			"Per-pupil current expenditures (log, 2010 $)"
		local titlnnonwageppexpend 		"Per-pupil non-wage current expenditures (log, 2010 $)"
		local ylabstudteachratio 	-2(1)2
		local ylablnavgteachsal		-0.2(0.1)0.2
		local ylablnppexpend		-0.2(0.1)0.2
		local ylablnnonwageppexpend -0.2(0.1)0.2
		
		foreach y of local vars {

		tempname memhold2`y'
		tempfile results2`y'
		postfile `memhold2`y'' year pre prese post postse using `results2`y''

		preserve

			xtreg  `y' i.year pre1-pre6 post0-post10,  fe vce(cluster Stateid)
			est store `y'nonp

			forval n = 1(1)6 {
				post `memhold2`y'' (`n') (_b[pre`n']) (_se[pre`n']) (.) (.)
			}
				
			forval n =0(1)10 {
				post `memhold2`y'' (`n') (.) (.) (_b[post`n']) (_se[post`n']) 
			}	

		postclose `memhold2`y''
		use `results2`y'', clear

		gen yearpre = -1*year if pre !=.
		gen yearpost = year if post !=.

		gen prehi = pre + 1.96*prese
		gen prelo = pre - 1.96*prese

		gen posthi = post + 1.96*postse
		gen postlo = post - 1.96*postse

		twoway (rcap prehi prelo yearpre, lpattern(solid) lcolor(gs8)) ///
		(rcap posthi postlo yearpost, lpattern(solid) lcolor(gs8))    ///
		(scatter pre yearpre, msymbol(o) msize(vlarge) mcolor(black)) ///
		(scatter post yearpost, msymbol(o) msize(vlarge) mcolor(black)) ,  ///
		xtitle("Years relative to mandatory collective bargaining law") ytitle("ATT Effect (Treated - Control)") title(`tit`y'') ///
		xlabel(-6(1)10) ylabel(`ylab`y'') yline(0) xlin(0) ///
		legend(off) scale(0.9) scheme(s1manual) name(gph`y'nonpe, replace) nodraw			

		restore
	}

	graph combine gphstudteachrationonpe gphlnppexpendnonpe gphlnavgteachsalnonpe gphlnnonwageppexpendnonpe, scale(0.75) imargin(4 4 4 4) cols(2) scheme(s1manual) name(FigureA5, replace) 


* SUPPLEMENTARY FIGURE A6: 
*-------------------------

	clear all
	use "C:\Users\apaglayan\Dropbox\Stanford\Teacher unions\CreateData\CBA_Coverage.dta", clear

	drop if State=="WI"
	
	gen yeargphcent=year-YearCBrequired
	gen treatment=(yeargphcent>=0 & yeargphcent!=.)    
	
	local vars CBteachers
	foreach y of local vars {
		bysort year: egen c`y'=mean(`y') if treatment==0   // control group's mean primratio in each year 
		bysort year: egen c2`y'=mean(c`y')				// assigns control group mean values to each country in every year
	}
	
	preserve
	collapse (mean) CBteachers c2CBteachers, by(yeargphcent)
		twoway (line CBteachers yeargphcent if yeargphcent>=-6 & yeargphcent<=-1, lcolor(black) lpattern(dash) lwidth(thick)) ///
		(line CBteachers yeargphcent if yeargphcent>=0 & yeargphcent<=5, lcolor(black) lpattern(solid) lwidth(thick)) ///
		(line c2CBteachers yeargphcent if yeargphcent>=-6 & yeargphcent<=-1, lcolor(gs10) lpattern(dash) lwidth(thick)) ///
		(line c2CBteachers yeargphcent if yeargphcent>=0 & yeargphcent<=5, lcolor(gs10) lpattern(solid) lwidth(thick)) , ///
		 xtitle("Years relative to mandatory collective bargaining law") ytitle("% of teachers covered by a CB agreement") ///
		legend(off) xlabel(-6(1)5) xlin(0) legend(off) scale(1) scheme(s1manual) name(FigureA6, replace)		
	restore


* SUPPLEMENTARY TABLE A1: 
*------------------------

	use "${path}Paglayan Dataset.dta", clear

	local vars perinc agr purban pnwht ESWI
	local yearperinc 1929
	local yearagr 1910
	local yearpurban 1910
	local yearpnwht 1910
	local yearESWI 1909
	foreach i of local vars {
	sum `i' if year==`year`i'' & CBstatusby1990==2
	sum `i' if year==`year`i'' & (CBstatusby1990==0 | CBstatusby1990==1)
	}


* SUPPLEMENTARY TABLE A2: 
*------------------------

	use "${path}Paglayan Dataset.dta", clear

	keep if South==1

	local vars perinc agr purban pnwht ESWI
	local yearperinc 1929
	local yearagr 1910
	local yearpurban 1910
	local yearpnwht 1910
	local yearESWI 1909
	foreach i of local vars {
	sum `i' if year==`year`i'' & CBstatusby1990==2
	sum `i' if year==`year`i'' & (CBstatusby1990==0 | CBstatusby1990==1)
	}


* SUPPLEMENTARY TABLE A3: 
*------------------------

	use "${path}Paglayan Dataset.dta", clear

	keep if South==1

	sum avginstrucsal if year==1939 & CBstatusby1990==2
	sum avginstrucsal if year==1939 & (CBstatusby1990==0 | CBstatusby1990==1)
	sum ppexpend if year==1919 & CBstatusby1990==2
	sum ppexpend if year==1919 & (CBstatusby1990==0 | CBstatusby1990==1)


* SUPPLEMENTARY TABLE A5: 
*------------------------

* code provided earlier in this file


* SUPPLEMENTARY TABLE A6: 
*------------------------

	use "${path}Paglayan Dataset.dta", clear

	estimates clear
	tsset Stateid year
	egen tagstate = tag(Stateid)

	keep if CBeverrequired==1
	drop if State=="DC" | State=="WI"
	drop if year<1959 
	drop if year>1997
		
	preserve 	
		
		fvset base 1 year
		estimates clear
		local vars studteachratio lnavgteachsal lnppexpend lnnonwageppexpend
		foreach y of local vars {
		
			tsset Stateid year		
			xtreg `y' 	i.year  i.Stateid#c.year CBrequired_SY , fe vce(cluster Stateid)
			estimates store TA6`y'		
		
		}
		estout TA6* using "${path}TableA6.xls", replace ///
		cells(b(star fmt(6)) se(par(`"="("'`")""')fmt(4))) drop(*year) label stats(N r2_a, labels("Observations" "Adj. R-Square")) starlevels(* 0.05 ** 0.01) stardetach

	restore


* SUPPLEMENTARY TABLE A7: 
*------------------------

	clear all
	insheet using "${path}CBA_Coverage-1.csv", names case comma
	gen stateid=_n
	reshape long CBteachers, i(State) j(year)
	replace CBteachers=CBteachers*100
	sort State year
	save "${path}CBA_Coverage2.dta", replace

	clear
	use "${path}Paglayan Dataset.dta"
	sort State year
	capture drop _merge
	merge State year using "${path}CBA_Coverage2.dta"

	drop if year<1959
	gen yeargphcent=year-YearCBrequired
	bysort State: ipolate CBteachers year, gen(iCBteachers_temp)
	gen iCBteachers=CBteachers
	replace iCBteachers=iCBteachers_temp if year<YearCBrequired & yeargphcent!=-1 & YearCBrequired!=.
	replace iCBteachers=iCBteachers_temp if year>=YearCBrequired & yeargphcent!=0 & YearCBrequired!=.
	replace iCBteachers=iCBteachers_temp if YearCBrequired==.
	drop if YearCBrequired==.

	browse State year Stateid YearCBrequired CBrequired_SY CBteachers iCBteachers_temp iCBteachers lnavgteachsal

	drop if State=="WI"
	drop if State=="DC"
	estimates clear
	tsset Stateid year
	local vars  studteachratio  lnavgteachsal lnppexpend  lnnonwageppexpend  
	foreach y of local vars {
		xtivreg `y'  (iCBteachers=CBrequired_SY) i.year , fe first vce(bootstrap, reps(1000))
		estimates store IV`y'
	}
	estout IV* using "${path}TableA7.xls", replace ///
		cells(b(star fmt(6)) se(par(`"="("'`")""')fmt(4)) p(par(`"="["'`"]""')fmt(4)))  drop(*year) label stats(N r2_a, labels("Observations" "Adj. R-Square")) starlevels(* 0.05 ** 0.01) stardetach


* SUPPLEMENTARY FIGURE B1: 
*-------------------------

	use "${path}Paglayan Dataset.dta", clear
	
	preserve 
	
	replace avgteachsal=. if year==1960 | year==1961 | year==1962 | year==1963 | year==1980 | year==1982 | year==1988 | year==1990  // reinstitute missing data
	replace avginstrucsal=. if year==1960 | year==1962  	// reinstitute missing data
	replace avgteachsal=. if (State=="DC" & year==1967) | (State=="MT" & year==1971) | (State=="MT" & year==1972) | (State=="MI" & year==1972) | (State=="NJ" & year==1974) | (State=="IL" & year==1975) | (State=="IL" & year==1978) | (State=="MA" & year==1976) | (State=="GA" & year==1977) |  (State=="GA" & year==1978) |  (State=="AK" & year==1978) | (State=="WI" & year==1978)  // reinstitute missing data
	replace avginstrucsal=. if (State=="DC" & year==1967) | (State=="MT" & year==1971) | (State=="MT" & year==1972) | (State=="MI" & year==1972) | (State=="NJ" & year==1974) | (State=="IL" & year==1975) | (State=="IL" & year==1978) | (State=="MA" & year==1976) | (State=="GA" & year==1977) |  (State=="GA" & year==1978) |  (State=="AK" & year==1978) | (State=="WI" & year==1978)  // reinstitute missing data
	
	local states ND NC NE NH NJ NM NV NY
	local ylblND 50000
	local ylblNC 60000
	local ylblNE 60000
	local ylblNH 70000
	local ylblNM 60000
	local ylblNJ 80000
	local ylblNV 60000
	local ylblNY 70000
	
	foreach i of local states {
	graph twoway (connect avginstrucsal year, mcolor(gs4) lcolor(gs4) lpattern(dash) mstyle(O))  ///
	(connect avgteachsal year, mcolor(gs10) lcolor(gs10) lpattern(dash) mstyle(O))  ///
	if State=="`i'" & year>=1959 & year<=2000, ///
	title("`i'") ///
	ytitle("Average annual salaries (at 2010 $)")  ///
	ylabel(30000(10000)`ylbl`i'') ///
	legend(order(1 2) label(1 "Instructional staff") label(2 "Teachers")) ///
	scheme(s1manual) ///
	name(g`i', replace) scale(0.8)
	}
	
	restore 

* SUPPLEMENTARY FIGURE B2: 
*-------------------------

	use "${path}Paglayan Dataset.dta", clear
	
	preserve 
	
	replace avgteachsal=. if year==1960 | year==1961 | year==1962 | year==1963 | year==1980 | year==1982 | year==1988 | year==1990  // reinstitute missing data
	replace avginstrucsal=. if year==1960 | year==1962  	// reinstitute missing data
	replace avgteachsal=. if (State=="DC" & year==1967) | (State=="MT" & year==1971) | (State=="MT" & year==1972) | (State=="MI" & year==1972) | (State=="NJ" & year==1974) | (State=="IL" & year==1975) | (State=="IL" & year==1978) | (State=="MA" & year==1976) | (State=="GA" & year==1977) |  (State=="GA" & year==1978) |  (State=="AK" & year==1978) | (State=="WI" & year==1978)  // reinstitute missing data
	replace avginstrucsal=. if (State=="DC" & year==1967) | (State=="MT" & year==1971) | (State=="MT" & year==1972) | (State=="MI" & year==1972) | (State=="NJ" & year==1974) | (State=="IL" & year==1975) | (State=="IL" & year==1978) | (State=="MA" & year==1976) | (State=="GA" & year==1977) |  (State=="GA" & year==1978) |  (State=="AK" & year==1978) | (State=="WI" & year==1978)  // reinstitute missing data
	
	local states DC MT MI NJ IL MA GA AK WI
	local ylblDC 80000
	local ylblMT 60000
	local ylblMI 80000
	local ylblNJ 80000
	local ylblIL 70000
	local ylblMA 80000
	local ylblGA 60000
	local ylblAK 90000
	local ylblWI 70000
	
	foreach i of local states {
	graph twoway (connect avginstrucsal year, mcolor(gs4) lcolor(gs4) lpattern(dash) mstyle(O))  ///
	(connect avgteachsal year, mcolor(gs10) lcolor(gs10) lpattern(dash) mstyle(O))  ///
	if State=="`i'" & year>=1959 & year<=2000, ///
	title("`i'") ///
	ytitle("Average annual salaries (at 2010 $)")  ///
	ylabel(30000(10000)`ylbl`i'') ///
	legend(order(1 2) label(1 "Instructional staff") label(2 "Teachers")) ///
	scheme(s1manual) ///
	name(g`i', replace) scale(0.8)
	}
	
	restore 


