clear

use "replication data_figures.dta", clear

***SET GRAYSCALE FOR FIGURES

set scheme s2mono

***SET DATA FOR SURVIVAL ANALYSIS

gen year1 = year+1
gen month=1
gen day=1
gen myend=mdy(month,day,year1)
gen mybegin=mdy(month,day,year)

stset myend, id(leadid) time0(mybegin) origin(time mybegin) ///
failure(coup_attempt=1) exit(time .) scale(365.25)


***FIGURE 1. MODE OF ENTRY, INSIDERS AND OUTSIDERS
**Note: This figure requires the coefplot package for Stata

proportion insider, over(entry)
estimates store insider1

coefplot insider1, keep(_prop_2:) ///
	vertical xtitle("") ytitle("Proportion of Regime Insiders") ///
	graphregion(color(white)) ///	
	ylabel(0(.2).8) ///
	recast(bar) barwidth(1) ///
	xlabel(1 "Legal" 2 "Extralegal") ///
	legend( order(1 "Regime Insider" 2 "95% Confidence Interval"  )) ///
	title("Figure 1. Mode of Entry, Insiders and Outsiders", color(black) size(medlarge)) ///
	ciopts(recast(rcap) color(black) lwidth(.4)) citop citype(logit) graphregion(lstyle(med))

graph export fig1.tif, replace

***FIGURE 2. MODE OF ENTRY AND COUP-PROOFING RESOURCES

gen consolidation = 1 if tenure<=10
replace consolidation = 2 if tenure>10 & tenure<=20
replace consolidation = 3 if tenure>20 

gen entry_ten = entry if consolidation==1
replace entry_ten = entry+2 if consolidation==2
replace entry_ten = entry+4 if consolidation==3

egen mean_coup_proof = mean(counterbal), by(entry consolidation)
egen sd_coup_proof = sd(counterbal), by(entry consolidation)
egen n = count(counterbal)
generate low_coup_proof = mean_coup_proof - invttail(n-1,0.025)*( sd_coup_proof  / sqrt(n))
generate hi_coup_proof = mean_coup_proof + invttail(n-1,0.025)*( sd_coup_proof / sqrt(n))

twoway (bar mean_coup_proof entry_ten if entry==0) ///
	   (bar mean_coup_proof entry_ten if entry==1) ///
	   (rcap hi_coup_proof low_coup_proof entry_ten, color(black) ), ///
	   graphregion(fcolor("white")) ///
	   xtitle("Tenure") /// 
	   ytitle("Coup-proofing Measure") ///
	   xlabel( 0.5 "Less than 10 years" 2.5 "10 to 20 years" 4.5 "More than 20 years", noticks) ///
	   legend(row(1) order(1 "Legal" 2 "Extralegal" 3 "95% Confidence Interval") ) ///
	   title("Figure 2. Mode of Entry and Coup-Proofing Resources", color(black) size(medlarge)) graphregion(lstyle(med))

graph export fig2.tif, replace

***FIGURE 3. MODE OF ENTRY AND COUP RISK

sts graph, hazard ci by(entry) noboundary ///
	xlab(0(5)30) graphregion(color(white)) ///
	xtitle("Years in Power") ///
	ytitle("Hazard of Coup Attempt") title("") ///
	legend(order(5 "Legal" 6 "Extralegal" 1 "95% Confidence Interval" 3 "95% Confidence Interval")) ///
	title("Figure 3. Mode of Entry and Coup Risk", color(black) size(medlarge)) graphregion(lstyle(med))

graph export fig3.tif, replace

***FIGURE 4. TARIFFS, UNREST, AND COUPS

egen tariff_median = median(tar_wb)
gen tariff_high = tar_wb>tariff_median
replace tariff_high = . if missing(tar_wb)

* Figure 4a: Tariffs and Unrest
egen meanprotest = mean(unrest), by(tariff_high)
egen sdprotest = sd(unrest), by(tariff_high)
egen n_protest = count(unrest)
generate low_protest = meanprotest - invttail(n-1,0.025)*( sdprotest  / sqrt(n_protest))
generate hi_protest = meanprotest + invttail(n-1,0.025)*( sdprotest / sqrt(n_protest))

twoway (bar meanprotest tariff_high) ///
	   (rcap hi_protest low_protest tariff_high, color(black) lwidth(.5)), ///
	   xtitle("") /// 
	   ylabel(0(200)1100) ///
	   xlabel(0 "Low Tariff" 1 "High Tariff") ///
	   legend( label(1 "Average Unrest") label(2 "95% CI")) ///
	   ytitle("Banks Unrest Index") ///
	   graphregion(color(white)) title("(a) Tariffs and Unrest", color(black))

graph save fig4a, replace	   

* Figure 4b: Tariffs and Coups
sts graph, ci level(95) by(tariff_high) haz ///
		   xlab(0(5)20) ///
		   noboundary xtitle("Years in Office") ///
		   ytitle("Hazard of Coup Attempt") title("") ///
		   legend(order(6 "High Tariff" 5 "Low Tariff" 3 ///
		   "95% Confidence Interval" 1 "95% Confidence Interval")) ///
	       graphregion(color(white)) title("(b) Tariffs and Coups", color(black))

graph save fig4b, replace

graph combine fig4a.gph fig4b.gph, ///
title("Figure 4. Tariffs, Unrest and Coups", color(black) size(vlarge)) ///
graphregion(color(white)) graphregion(lstyle(med))

graph display, ysize(2.5)

graph export fig4.tif, replace

