
*preliminaries
cd "C:\Users\Chris\Dropbox\Research\Dangerous Lessons - JPR - 2016\Data\"
log using figures, text replace


*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* DANGEROUS LESSONS
*
* Christopher Linebarger
*
* Journal of Peace Research
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------

/*
*obtain figure 1
use "militant groups per year.dta", clear

drop if dateofformation >= 2006

# delimit;
twoway (bar count dateofformation, color(gs10) 
		xtitle("Year", size(large))
		ytitle("Freq. of militant groups formation",size(large) )) ;
		*graph export figure1.tif,replace width(2000);
clear




*obtain figure 2
use "revolutionary regimes per year.dta", clear
keep if revdummy==1
collapse (count) revdummy, by (year)
# delimit ;
twoway (bar revdummy year, color(gs10) ) if (year > 1967 & year < 2002),
		xtitle("Year", size(large))
		ytitle("Freq. of revolutionary regimes",size(large) ) 
		yscale (range(5 25));
		*graph export figure2.tif,replace width(2000);
clear
*/





*open and organize data
set more off
use jpr-main-data2.dta, clear

order ccode year abbrev isocode iso3let binaryformation groupst

*sort data
sort ccode year
xtset ccode year


*generate splines for war years
btscs allons3 year ccode , generate(py) nspline(3)
rename _spline1 warspline1
rename _spline2 warspline2
rename _spline3 warspline3
gen py2 = py*py
gen py3 = py*py*py
drop warspline*



*TABLE I. Logit Models of Armed Conflict Onset and Militant Group Emergence, 1968–2001.

*M1 - a modified replication of Buhaug & Gleditsch (2008)
logit allons3 ncivwar  demo demo3000prop neighlgdp lgdp96l lnpop py py2 py3  if year >1967 , robust cl(ccode)

		
*M2 - same as above model, but with DV replaced, polynomials set for appropriate DV, and time dummies used
logit binaryformation ncivwar allinc3  demo demo3000prop neighlgdp lgdp96l lnpop  group1 group2 group3 i.year if year >1967 , robust cl(ccode)

			
			
			
			
*TABLE II. Logit models of learning and Militant Group Emergence, 1968–2001.		
			
*(cultural and regime simularity variables)
	
set more off
*M3
logit binaryformation l_cwongoing_sim_contig1 l_cwongoing_sim_contig6 l_cwongoing_dissim_contig1  l_cwongoing_dissim_contig6 allinc3  demo demo3000prop neighlgdp lgdp96l lnpop group1 group2 group3 i.year if year >1967 , robust cl(ccode)
		
*M4
logit binaryformation l_cwongoingsimcontig1regime l_cwongoingsimcontig6regime l_cwongoingdissimcontig1regime  l_cwongoingdissimcontig6regime allinc3  demo demo3000prop neighlgdp lgdp96l lnpop group1 group2 group3 i.year if year > 1967 , robust cl(ccode)
	
*M5
logit binaryformation   l_beaconongoing_sim_contig1 l_beaconongoing_sim_contig6 l_beaconongoing_dissim_contig1 l_beaconongoing_dissim_contig6 ncivwar allinc3  demo demo3000prop neighlgdp lgdp96l lnpop group1 group2 group3 i.year if year >1967 , robust cl(ccode)
		
	/*
	*FIGURES FOR M5
	
	*Figure 3
	# delimit ;
	qui margins, at((mean) _all demo=0 allinc3=0 ncivwar=0  l_beaconongoing_sim_contig1=(1(1)5) ) vsquish;
		qui marginsplot, noci 
		xtitle("Revolutionary Cultural Similarity (contiguous)", size(large))
		ytitle(Pr(Militant Group Emergence), size(large)) 
		title("")
		plot1opts(msymbol(none)lcolor(black)lp(solid)lw(thick)) ;
		*qui graph export figure3.tif,replace width(2000);
	
		
		
	*Figure 4
	# delimit ;
	qui margins, at((mean) _all demo=0 allinc3=0 ncivwar=0  l_beaconongoing_sim_contig6=(1(1)5) ) vsquish;
		qui marginsplot, noci
		xtitle("Revolutionary Cultural Similarity (non-contiguous)", size(large))
		ytitle(Pr(Militant Group Emergence), size(large)) 
		title("")
		plot1opts(msymbol(none)lcolor(black)lp(solid)lw(thick)) ;
		*qui graph export figure4.tif,replace width(2000);
	*/
		

	
	
*M6
set more off
logit binaryformation l_beaconsimcontig1regime l_beacondissimcontig1regime l_beaconsimcontig6regime l_beacondissimcontig6regime allinc3 ncivwar demo demo3000prop neighlgdp lgdp96l lnpop group1 group2 group3 i.year if year > 1967, robust cl(ccode)
																		   
	*FIGURES FOR M6
	/*
	*Figure 5
	# delimit ;
	qui margins, at((mean) _all demo=0 allinc3=0 ncivwar=0  l_beaconsimcontig6regime=(1(1)5) ) vsquish;
		qui marginsplot, noci
		xtitle("Political Revolutionary Similarity (non-contiguous)", size(large))
		ytitle(Pr(Militant Group Emergence), size(large)) 
		title("")
		plot1opts(msymbol(none)lcolor(black)lp(solid)lw(thick)) ;
		*qui graph export figure5.tif,replace width(2000);
		*/
			
	
	
	
	
*ROBUSTNESS CHECKS
set more off
	
*TABLE VI. Logit robustness tests of militant group emergence and minimum 
*distance to nearest armed conflict or revolutionary regime, 1968–2001.


*M7
*nearest civil wars (cultural sim)
logit binaryformation l_cwsimmindist    l_cwdissimmindist allinc3  demo demo3000prop neighlgdp lgdp96l lnpop group1 group2 group3 i.year if year > 1967 , robust cl(ccode)
		
*M8
*nearest civil wars (regime sim)
logit binaryformation l_cwregimesimmindist l_cwregimedissimmindist    allinc3  demo demo3000prop neighlgdp lgdp96l lnpop group1 group2 group3 i.year if year > 1967 , robust cl(ccode)

*M9
*nearest rev regimes (cultural sim)		
logit binaryformation l_beaconsimmindist  l_beacondissimmindist allinc3 ncivwar demo demo3000prop neighlgdp lgdp96l lnpop group1 group2 group3 i.year if year > 1967 , robust cl(ccode)

*M10
*nearest rev regimes (regime sim)	
logit binaryformation l_beaconregimesimmindist l_beaconregimedissimmindist  ncivwar  allinc3  demo demo3000prop neighlgdp lgdp96l lnpop group1 group2 group3 i.year if year > 1967 , robust cl(ccode)


	
	
*Table 7. Logit robustness tests with Young and Dugan’s (2011) measure of militant group emergence, 1968–2001.
* run models with Young and Dugan / Aksoy and Carter dependent variable

*M11
logit groupst l_cwongoing_sim_contig1 l_cwongoing_sim_contig6 l_cwongoing_dissim_contig1  l_cwongoing_dissim_contig6 allinc3  demo demo3000prop neighlgdp lgdp96l lnpop emergeyrs emergeyrs2 emergeyrs3 i.year if year >1967 , robust cl(ccode)

*M12
logit groupst l_cwongoingsimcontig1regime l_cwongoingsimcontig6regime l_cwongoingdissimcontig1regime  l_cwongoingdissimcontig6regime allinc3  demo demo3000prop neighlgdp lgdp96l lnpop emergeyrs emergeyrs2 emergeyrs3 i.year if year > 1967 , robust cl(ccode)

*M13
logit groupst l_beaconongoing_sim_contig1 l_beaconongoing_sim_contig6 l_beaconongoing_dissim_contig1  l_beaconongoing_dissim_contig6 allinc3 ncivwar  demo demo3000prop neighlgdp lgdp96l lnpop emergeyrs emergeyrs2 emergeyrs3 i.year if year >1967 , robust cl(ccode)

*M14
logit groupst l_beaconsimcontig1regime l_beaconsimcontig6regime l_beacondissimcontig1regime l_beacondissimcontig6regime allinc3 ncivwar  demo demo3000prop neighlgdp lgdp96l lnpop emergeyrs emergeyrs2 emergeyrs3 i.year if year > 1967, robust cl(ccode)	

	
*obtain descriptive statistics
su l_beaconongoing_sim_contig1 l_beaconongoing_sim_contig6 l_beaconongoing_dissim_contig1  l_beaconongoing_dissim_contig6 if year > 1968, detail	


	
	
clear
log close



