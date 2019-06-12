
    
use "$data/podes_pkhrollout.dta", clear

	
	gen treat_1213_2000 =  treat12_2000 + treat13_2000
    gen treat_1213_2003 =  treat12_2003 + treat13_2003
    gen treat_1213_2005 =  treat12_2005 + treat13_2005
    gen treat_1213_2011 =  treat12_2011 + treat13_2011
    gen treat_1213_2014 =  treat12_2014 + treat13_2014

	
	global year year2000 year2003 year2005 year2011 year2014
 
	

  xtreg   n_suicides_possionpc treat0708_2000 treat0708_2003 treat0708_2011 treat0708_2014 ///
   treat1011_2000 treat1011_2003 treat1011_2011 treat1011_2014  ///
      treat1213_2000 treat1213_2003 treat1213_2005  treat1213_2014  $year [aw=pop_sizebaseline], fe cluster(kabuid)
	  
	  

foreach k in 0708 1011 1213 {
   
gen treatmenteffect`k'=.  in 1/6
gen standarderror`k'=.  in 1/6

  

replace treatmenteffect`k' =. in 1
replace standarderror`k'=. in 1 

replace treatmenteffect`k'=_b[treat`k'_2000]  in 2
replace standarderror`k'=_se[treat`k'_2000]  in 2
    

replace treatmenteffect`k'=_b[treat`k'_2003]  in 3
replace standarderror`k' =_se[treat`k'_2003]  in 3


if `k' == 1213 {


replace treatmenteffect`k'=_b[treat`k'_2005]  in 4
replace standarderror`k'=_se[treat`k'_2005] in 4

replace treatmenteffect`k'=0  in 5
replace standarderror`k'=0 in 5
}
else {


replace treatmenteffect`k'=0  in 4
replace standarderror`k'=0 in 4

replace treatmenteffect`k'=_b[treat`k'_2011]  in 5
replace standarderror`k'=_se[treat`k'_2011] in 5
}


replace treatmenteffect`k'=_b[treat`k'_2014]  in 6
replace standarderror`k'=_se[treat`k'_2014] in 6
  
  
      
generate hiz_avg`k' = treatmenteffect`k' + 1.96*(standarderror`k')
generate lowz_avg`k' = treatmenteffect`k' - 1.96*(standarderror`k')
 
}   
************************

    
 
keep t treatmenteffect* hiz* lowz* standard* 
keep in 1/6
replace t=_n-2
gen t07=t-0.14
gen t12=t+0.14-1
replace t12=. in 1


 gen zero = 0
 set scheme lean2

 
	 
	


twoway  || connected treatmenteffect0708 t07 ,  msymbol(Dh) lp(dash)|| rcap hi*0708 lo*0708 t07  ///
	 || connected treatmenteffect1011 t  ,  msymbol(Sh) lp( dash_dot ) || rcap hi*1011 lo*1011 t  ///
	 || connected treatmenteffect1213 t12 ,  msymbol(Th) lp(longdash) || rcap hi*1213 lo*1213 t12   , ///
	 legend(order( 1 "Treatment 07/08" 3 "Treatment 10/11" 5 "Treatment 12/13" ///
2 "95% CI") pos(6) rows(2))  ytitle("Suicide Rate") xline(2.2, lc(red)) ///
xscale(range(-1.05, 4.5)) xlab( -1 "-3" 0 "-2" 1"-1" 2 "0" 3 "1" 4 "2") xtitle("Period")


     graph export "$figures/FigureA7_eventstudy_poisson.pdf", as(pdf) replace
        
    

