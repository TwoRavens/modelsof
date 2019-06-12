
use "$data/podes_pkhrollout.dta", clear


 set scheme  lean2 


	
	global year year2000 year2003 year2005 year2011 year2014

	
	
	xtset kecid2000 t
	
 
	gen treat_pkhrct_2003 = treat_pkhrct*year2003
 	gen treat_pkhrct_2005 = treat_pkhrct*year2005
	gen treat_pkhrct_2011 = treat_pkhrct*year2011
	gen treat_pkhrct_2014 = treat_pkhrct*year2014
	
	 
 
	xtreg nsuicidespc treat_pkhrct_2003 treat_pkhrct_2005 treat_pkhrct_2011 treat_pkhrct_2014  $year [aw=pop_sizebaseline] , fe cluster(kecid)
		
	
gen treatmenteffect=0 if year==2000
gen standarderror=0 if year==2000


	 

replace treatmenteffect=_b[treat_pkhrct_2003] if  year==2003
replace standarderror=_se[treat_pkhrct_2003] if  year==2003

replace treatmenteffect=_b[treat_pkhrct_2005] if  year==2005
replace standarderror=_se[treat_pkhrct_2005] if  year==2005
	

replace treatmenteffect=_b[treat_pkhrct_2011] if  year==2011
replace standarderror=_se[treat_pkhrct_2011] if  year==2011

replace treatmenteffect=_b[treat_pkhrct_2014] if  year==2014
replace standarderror=_se[treat_pkhrct_2014] if  year==2014
		
 collapse (mean) treatmenteffect standarderror, by(year)
		
	
generate hiz_avg = treatmenteffect + 1.96*(standarderror)
generate lowz_avg = treatmenteffect - 1.96*(standarderror)
 

 gen zero = 0

 
   twoway    (connected treatmenteffect  year)  (rcap hiz_avg lowz_avg year)  , ///
 	xlabel( 2000 "2000" 2003 "2003" 2005 "2005"  2011 "2011" 2014 "2014", labsize(3) noticks) ///
	yline( 0, lwidth(medium)) ///
		ytitle("Treatment effect on suicide rate") ///	
	xtitle("Year") 	xline(2005.5, lc(red)) ///
	xline(2013.5, lc(red)) ///
	legend(order(1 "Treatment Effect" 2 "95 % CI") ring(1) position(6) row(1)) ///
 	name(eventstudy, replace)	

	 graph export "$figures/FigureA5_rct_eventstudy_norm2000.pdf", as(pdf) replace
	
