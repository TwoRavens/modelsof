
    
use "$data/podes_pkhrollout.dta", clear


 
** manually code year since receipt of treatment ** 
 
gen years_pkh=7 if treat2007>0&treat2007<. &year==2014

replace years_pkh=6 if treat2008>0&treat2008<. &year==2014

replace years_pkh=4 if treat2010>0&treat2010<. &year==2014 
replace years_pkh=4 if treat2007>0&treat2007<. &year==2011

replace years_pkh=3 if treat2011>0&treat2011<. &year==2014 
replace years_pkh=3 if treat2008>0&treat2008<. &year==2011

replace years_pkh=2 if treat2012>0&treat2012<. &year==2014 

replace years_pkh=1 if treat2010>0&treat2010<. &year==2011
replace years_pkh=1 if treat2013>0&treat2013<. &year==2014

replace years_pkh=0 if treat2011>0&treat2011<. &year==2011

replace years_pkh=-13 if treat2013>0&treat2013<. &year==2000

replace years_pkh=-12 if treat2012>0&treat2012<. &year==2000

replace years_pkh=-11 if treat2011>0&treat2011<. &year==2000

replace years_pkh=-10 if treat2010>0&treat2010<. &year==2000
replace years_pkh=-10 if treat2013>0&treat2013<. &year==2003

replace years_pkh=-9 if treat2012>0&treat2012<. &year==2003

replace years_pkh=-8 if treat2008>0&treat2008<. &year==2000
replace years_pkh=-8 if treat2011>0&treat2011<. &year==2003
replace years_pkh=-8 if treat2013>0&treat2013<. &year==2005

replace years_pkh=-7 if treat2007>0&treat2007<. &year==2000
replace years_pkh=-7 if treat2010>0&treat2010<. &year==2003
replace years_pkh=-7 if treat2012>0&treat2012<. &year==2005


replace years_pkh=-6 if treat2011>0&treat2011<. &year==2005


replace years_pkh=-5 if treat2008>0&treat2008<. &year==2003
replace years_pkh=-5 if treat2010>0&treat2010<. &year==2005


replace years_pkh=-4 if treat2007>0&treat2007<. &year==2003

replace years_pkh=-3 if treat2008>0&treat2008<. &year==2005

replace years_pkh=-2 if treat2007>0&treat2007<. &year==2005


replace years_pkh=years_pkh+14

replace years_pkh=0 if years_pkh==.


** Main regression **
	
	global year year2000 year2003 year2005 year2011 year2014
	
	xtreg   nsuicidespc ib12.years_pkh  $year [aw=pop_sizebaseline], fe cluster(kabuid)
	  
	  
** Extract coefficients **
	  
gen treatmenteffect=.  in 1/21
gen standarderror=.  in 1/21

  
forval k= 0/21 {
cap replace treatmenteffect =_b[`k'.years_pkh]  in `k'
cap replace standarderror=_se[`k'.years_pkh] in `k'

}
  
      
generate hiz_avg = treatmenteffect + 1.96*(standarderror)
generate lowz_avg = treatmenteffect - 1.96*(standarderror)
 
************************

    
 
keep  treatmenteffect* hiz* lowz* standard* 
keep in 1/22
gen t=_n-14 in 1/21


 gen zero = 0
 set scheme lean2

     


twoway connected treatmenteffect t ,  msymbol(Dh) lp(solid) ||  rcap hiz_avg lowz_avg t , ///
legend(order( 1 "Treatment effect"  2 "95% CI") pos(6) rows(1))  ytitle("Suicide Rate") xline(-0.2, lc(black)) ///
xscale(range(-13.5, 7.5))  xtitle("Years relative to PKH start") xlab(-13(1)7)


graph export "$figures/Figure2_eventstudy_dynamic.pdf", as(pdf) replace
        
    

