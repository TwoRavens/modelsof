clear
set more off


cap program drop rd_plot
program rd_plot
	args out titlex titley bw inputfile
	
	**reg lines & SEs
	use `inputfile', clear
	local increment = `bw'/100
	
	gen bin10=.
	foreach X of num 0(`increment')`bw' {
		di "`X'"
		replace bin=(-`X'+(`increment'/2)) if (min_dist>=-`X' & min_dist<(-`X'+`increment') & min_dist<0)
		replace bin=(`X'+(`increment'/2)) if (min_dist>`X' & min_dist<=(`X'+`increment'))
	}
	tab bin10
	drop if bin10==.
	
	collapse (sum) Nobs, by(bin10)

	lpoly N bin10 if bin10>0, kernel(rectangle) bwidth(`bw') degree(1)  generate(x s) se(se) nograph
	keep x s se 
	drop if x==.
	save RD, replace

	use `inputfile', clear
	local increment = `bw'/100
	
	gen bin10=.
	foreach X of num 0(`increment')`bw' {
		di "`X'"
		replace bin=(-`X'+(`increment'/2)) if (min_dist>=-`X' & min_dist<(-`X'+`increment') & min_dist<0)
		replace bin=(`X'+(`increment'/2)) if (min_dist>`X' & min_dist<=(`X'+`increment'))
	}
	tab bin10
	drop if bin10==.
	
	collapse (sum) Nobs, by(bin10)
	
	lpoly N bin10 if bin10<0, kernel(rectangle) bwidth(`bw') degree(1)  generate(x s) se(se) nograph
	keep x s se 
	drop if x==.
	append using RD
	
	g ciplus=s+1.96*se
	g ciminus=s-1.96*se
	keep if abs(x)<`bw'
	save RD, replace
	
	**bin data ***all discontinuities
	
	use `inputfile', replace
	
	local increment = `bw'/100
	
	gen bin10=.
	foreach X of num 0(`increment')`bw' {
		di "`X'"
		replace bin=(-`X'+(`increment'/2)) if (min_dist>=-`X' & min_dist<(-`X'+`increment') & min_dist<0)
		replace bin=(`X'+(`increment'/2)) if (min_dist>`X' & min_dist<=(`X'+`increment'))
	}
	tab bin10
	drop if bin10==.
		
	collapse (sum) Nobs (mean) min_dist, by(bin10)

	append using RD
	
	local biginc= `increment'*10
	
	twoway (connected s x if x>0, sort msymbol(none) clcolor(black) clpat(solid) clwidth(medthick)) (connected ciplus x if x>0, sort msymbol(none) clcolor(black) clpat(shortdash) clwidth(thin)) (connected ciminus x if x>0, sort msymbol(none) clcolor(black) clpat(shortdash) clwidth(thin)) (connected s x if x<0, sort msymbol(none) clcolor(black) clpat(solid) clwidth(medthick)) (connected ciplus x if x<0, sort msymbol(none) clcolor(black) clpat(shortdash) clwidth(thin)) (connected ciminus x if x<0, sort msymbol(none) clcolor(black) clpat(shortdash) clwidth(thin))  (scatter Nobs min_dist, sort msize(med)xline(0) mcolor(black)),  legend(off) graphregion(color(white)) xtitle(`titlex')  ytitle(`titley') xlabel(-`bw'(`biginc')`bw') xsc(r(-`bw' `bw')) /*ylabel(0(.1)1) ysc(r(0 1))*/ xline(0, lpattern(shortdash) lc(black)) ylab(,nogrid) saving(Fig3.gph,replace)

	graph export mccrary.pdf, replace

end

***Panel A: bombing at t+1, distance to threhold at t RD scatter plot
do firstclose 1 1 1
g Nobs=1
save firstclose_post, replace
rd_plot Nobs "distance to threshold in period t" "Observations" 1 "firstclose_post"

