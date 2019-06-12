
    
use "$data/podes_pkhrollout.dta", clear

	set scheme  lean2 

	xi:hdfe nsuicidespc z_rain [aw=pop_sizebaseline], absorb(kecid#c.year i.kecid i.year) gen(h_)

	lpoly h_nsuicidespc h_z_rain [aw=pop_sizebaseline], nograph gen(x2 y2) 
	lpoly h_nsuicidespc h_z_rain [aw=pop_sizebaseline], nograph   se(se2) at(x2) 
	gen ci_u2=y2+1.96*se2
	gen ci_l2=y2-1.96*se2
	
	sum h_z_rain, d
	

	twoway  (rarea ci_u2 ci_l2 x2 if x2>`r(p1)' &x2<`r(p99)', color(gs12%50) ) (line y2 x2 if x2>`r(p1)' &x2<`r(p99)'), ///	
	legend( order(2 "Local Effect" 1 "95 % CI") pos(6) row(1)) ylabel(#5) xlabel(#5) xtitle("Residual: Rainfall (z-scored)") ytitle("Residual: Suicide rate")
	
	graph export "$figures/Figure3_nonpar_rainfall_suiciderate.pdf", replace
	
	
