*Replication file for "Friendly Fire" by Martin Haselmayer & Marcelo Jenny
*Stata 15
*10.07.2018

set more off
clear mata
global DATADIR  "" //Customize working directories
global GRAPHDIR ""

cd  "$DATADIR"
use friendlyfire_replication_R2.dta, clear
d,s //3453 obs.

**Aggregate data to the level of directed party dyads
collapse (count)freq=helpvar (mean)satzscore_dsk  , by(pair year) 
su satzscore_dsk  
d,s

merge 1:n pair year using friendlyfire_replication_R2.dta
drop _merge
duplicates drop pair year, force
describe, sh //76 Cases

lab var freq "Freq. of negative campaigning"
standard2 freq 

*Generate variable that contains a sum of frequency for each party
bysort subj: egen total_neg_subj=total(freq)
lab var total_neg_subj "Total freq/subj"
tab subj total_neg	

save friendlyfire_replication_R2_agg.dta, replace // dataset for Figure 1 

***Descriptive analysis***

*Figure 1: use R script (see documentation)

*Figure 2: Bivariate evidence on hypothesis

*Frequency (right panel)
graph bar freq , title("") ytitle("Mean number") ///
	over(pairgov, relabel(1 `""Gov-Gov" "(8)" "' 2 `""Opp<>Gov" "(46)" "' 3 `""Opp-Opp" "(22)" "') ) ///
	yla(0(50)150, nogrid notick) graphregion(color(white)) yline(45.4, lpattern(dash)) xsize(4)   ///
	name(gr1a, replace)	
	

*Tonality (left panel)
bysort pairgov: su freq satzscore_dsk //Description of graphs in the text info
graph bar satzscore_dsk , title("") ytitle("Mean tonality") ///
	over(pairgov, relabel(1 `""Gov-Gov" "(8)" "' 2 `""Opp<>Gov" "(46)" "' 3 `""Opp-Opp" "(22)" "' ) ) ///
	yla(0(0.5)3, nogrid notick) graphregion(color(white)) yline(2.23, lpattern(dash)) xsize(4)   ///
	name(gr1b, replace)


graph combine gr1a gr1b , col(2) note("Note: Dashed line indicates mean value. Number of party dyads in four elections studied is listed in parentheses.", size(*0.95))
	
	
cd "$GRAPHDIR"
graph export graph_ff_fig2.png, width(2000) replace
cd "$DATADIR" 		

*Comparing different measures of negative campaigning:
correl pairshare_all pairshare freq satzscore_dsk

***Multivariate analyses***

*Please note that slight variation in the results is due to boostrapped SEs

*M1: Number of attacks
xi: nbreg freq   /// //gov. status
	ib2.pairgov  c.skapgrof_ranksum  c.pairpoldis    i.year, vce(bootstrap, reps(200))
	est store m1
	ereturn list  r2_p //0.09	
*M2: Tonality of attacks	
xi: regress satzscore_dsk  /// //gov. status
	ib2.pairgov c.skapgrof_ranksum c.pairpoldis  i.year, vce(bootstrap, reps(200)) 	 
	ereturn list r2_a //0.15	
	est store m2
	 	 
*M3: M2 controlling for number (not reported in the paper)
xi: regress satzscore_dsk  /// 
	ib2.pairgov c.skapgrof_ranksum c.pairpoldis freq  i.year, vce(bootstrap, reps(200))  	 
	est store m3

*M4: M2 controlling for attacks from junior coalition parties (not reported in the paper)
xi: regress satzscore_dsk  /// 
	ib2.pairgov c.skapgrof_ranksum  c.pairpoldis freq 1.subj_junior i.year, vce(bootstrap, reps(200))  	 
	ereturn list r2_a //0.13	
	est store m3	
	
	  	 
*Table 2: Regression results
esttab m1 m2, se(2) b(a2)  /// 
	indicate("Election fixed effects = *year*") ///
	star(# 0.1 * 0.05 ** 0.01 *** 0.001) ///
	stats(ar2 pr2 bic N) style(fixed) /// 
	order(1.pairgov ) ///
	mtitle("Model 1" "Model 2" ) ///
	label nonumbers nobaselevels 

	
*Graph for marginal effects (fig 3/1):

gen x=_n in 1/4

gen effect=.
gen lower95=.
gen upper95=.

est restore m1
margins,at(pairgov=2) at(pairgov=1)   pwcompare post
matrix b=r(b_vs)
matrix V=r(V_vs)
matrix list b
matrix list V
replace effect=b[1,1] 					  if x==1
replace upper95=b[1,1] + 1.96*sqrt(V[1,1]) if x==1
replace lower95=b[1,1] - 1.96*sqrt(V[1,1]) if x==1

est restore m1
margins, at(pairgov=2) at(pairgov=3)   pwcompare post
matrix b=r(b_vs)
matrix V=r(V_vs)
matrix list b
matrix list V
replace effect=b[1,1] 					  if x==2
replace upper95=b[1,1] + 1.96*sqrt(V[1,1]) if x==2
replace lower95=b[1,1] - 1.96*sqrt(V[1,1]) if x==2


est restore m1
margins, dydx(skapgrof_ranksum)  post
matrix b=r(b)
matrix V=r(V)
matrix list b
matrix list V
replace effect=b[1,1] 					  if x==3
replace upper95=b[1,1] + 1.96*sqrt(V[1,1]) if x==3
replace lower95=b[1,1] - 1.96*sqrt(V[1,1]) if x==3


est restore m1
margins, dydx(pairpoldis)  post
matrix b=r(b)
matrix V=r(V)
matrix list b
matrix list V
replace effect=b[1,1] 					  if x==4
replace upper95=b[1,1] + 1.96*sqrt(V[1,1]) if x==4
replace lower95=b[1,1] - 1.96*sqrt(V[1,1]) if x==4

gen x_graph=x*10
replace x_graph=8 if x==1
replace x_graph=14 if x==2
replace x_graph=20 if x==3
replace x_graph=26 if x==4

label define Hyp  8 "Gov-Gov"  14 "Opp-Opp"   ///
					20 "Intensity of competition"  26 "L-R distance" 
label values x_graph  Hyp
sort x_graph
eclplot effect lower95 upper95 x_graph in 1/45, ///
	rplottype(rspike) ///
	estopts(msymbol(circle) mcolor(black)) ///
	ciopts(lcolor(black) lwidth(medium))	///
	legend(off) ///
	title(Frequency of negative campaigning,size(medsmall)) ///
	graphregion(color(white)) ///
	yscale(range(5 30)) ///
	xscale(range(-0.1 0.1)) ///
    ylabel(8 14 20 26  , valuelabel labsize(small) notick nogrid) ///
	xlabel(-150(50)150, labsize(small) ) ///
	ytitle("") ///
	xtitle("Marginal effect",size(small)) ///
	ysize(4) ///
	xsize(7) ///
	xline(0, lcolor(black)) ///
	horizontal name(gr1, replace) 

	
drop x effect x_graph upper95 lower95
matrix drop _all
label drop Hyp

*Graph for marginal effects (fig 3/2):

gen x=_n in 1/4

gen effect=.
gen lower95=.
gen upper95=.

est restore m2
margins,at(pairgov=2) at(pairgov=1)   pwcompare post
matrix b=r(b_vs)
matrix V=r(V_vs)
matrix list b
matrix list V
replace effect=b[1,1] 					  if x==1
replace upper95=b[1,1] + 1.96*sqrt(V[1,1]) if x==1
replace lower95=b[1,1] - 1.96*sqrt(V[1,1]) if x==1

est restore m2
margins, at(pairgov=2) at(pairgov=3)   pwcompare post
matrix b=r(b_vs)
matrix V=r(V_vs)
matrix list b
matrix list V
replace effect=b[1,1] 					  if x==2
replace upper95=b[1,1] + 1.96*sqrt(V[1,1]) if x==2
replace lower95=b[1,1] - 1.96*sqrt(V[1,1]) if x==2

est restore m2
margins, dydx(skapgrof_ranksum)  post
matrix b=r(b)
matrix V=r(V)
matrix list b
matrix list V
replace effect=b[1,1] 					  if x==3
replace upper95=b[1,1] + 1.96*sqrt(V[1,1]) if x==3
replace lower95=b[1,1] - 1.96*sqrt(V[1,1]) if x==3

est restore m2
margins, dydx(pairpoldis)  post
matrix b=r(b)
matrix V=r(V)
matrix list b
matrix list V
replace effect=b[1,1] 					  if x==4
replace upper95=b[1,1] + 1.96*sqrt(V[1,1]) if x==4
replace lower95=b[1,1] - 1.96*sqrt(V[1,1]) if x==4

gen x_graph=x*10
replace x_graph=8 if x==1
replace x_graph=14 if x==2
replace x_graph=20 if x==3
replace x_graph=26 if x==4

label define Hyp  8 "Gov-Gov"  14 "Opp-Opp"   ///
					20 "Intensity of competition"  26 "L-R distance" 
label values x_graph  Hyp
sort x_graph
eclplot effect lower95 upper95 x_graph in 1/45, ///
	rplottype(rspike) ///
	estopts(msymbol(circle) mcolor(black)) ///
	ciopts(lcolor(black) lwidth(medium))	///
	legend(off) ///
	title(Tonality of negative campaigning,size(medsmall)) ///
	graphregion(color(white)) ///
	yscale(range(5 30)) ///
	xscale(range(-0.1 0.1)) ///
    ylabel(8 14 20 26  , valuelabel labsize(small) notick nogrid) ///
	xlabel(-1(0.25)1, labsize(small) ) ///
	ytitle("") ///
	xtitle("Marginal effect",size(small)) ///
	ysize(4) ///
	xsize(7) ///
	xline(0, lcolor(black)) horizontal name(gr2, replace) ///
    note("Notes: Continuous variables  are standardized." "Whiskers indicate 95% confidence intervals.", size(*0.95))	


drop x effect x_graph upper95 lower95
matrix drop _all
label drop Hyp

graph combine gr1 gr2, col(1) xsize(3) ysize(4)

cd "$GRAPHDIR"
graph export graph_ff_fig3.png, width(2000) replace
cd "$DATADIR" 


*******APPENDIX
*APPENDIX A1: Competitive status of sender & target parties
tab2 frontrun_subj challeng_subj frontrun_obj challeng_obj trailing_subj trailing_obj


*APPENDIX C: Mean tonality and frequency of negative statements in party press releases, 2002-2013
bysort pair year: egen total_pair=total(freq)
bysort year pair:su satzscore_dsk total_pair

*APPENDIX D: Robustness tests

*M1
xi: nbreg freq   /// 
	ib2.pairgov  c.skapgrof_ranksum  c.pairpoldis i.year 
	est store m_a1
	ereturn list  r2_p
*M2:
xi: regress satzscore_dsk  /// 
	ib2.pairgov c.skapgrof_ranksum c.pairpoldis i.year  	 	 
	est store m_a2
*M3:
 xi: regress satzscore_dsk  /// 
	ib2.pairgov c.skapgrof_ranksum c.pairpoldis c.freq i.year 	 	 
	est store m_a3
	 	
*Table D1:
esttab m_a1 m_a2 m_a3, se(2) b(a2)  /// 
	indicate("Election fixed effects = *year*") ///
	star(# 0.1 * 0.05 ** 0.01 *** 0.001) ///
	stats(ar2 pr2 bic N) style(fixed) /// 
	order(1.pairgov ) ///
	mtitle("Model 1" "Model 2" "Model 3" ) ///
	label nonumbers nobaselevels //	  
	
*Excluding Team Stronach
*M4:
xi: nbreg freq   /// 
	ib2.pairgov  c.skapgrof_ranksum  c.pairpoldis i.year  if subj<6 & obj<6, vce(bootstrap,reps(200))
	est store m_a4
 *M5:
 xi: regress satzscore_dsk  /// 
	ib2.pairgov c.skapgrof_ranksum c.pairpoldis i.year if subj<6 & obj<6, vce(bootstrap,reps(200))  	 	 
	est store m_a5
	*AR:0.14
*M6:		
 xi: regress satzscore_dsk  /// 
	ib2.pairgov c.skapgrof_ranksum c.pairpoldis freq i.year if subj<6 & obj<6 , vce(bootstrap,reps(200)) 	 
	est store m_a6
	*Ar: 0.13
	 

* Table D2:
esttab m_a4 m_a5 m_a6, se(2) b(a2)  /// 
	indicate("Election fixed effects = *year*") ///
	star(# 0.1 * 0.05 ** 0.01 *** 0.001) ///
	stats(ar2 pr2 bic N) style(fixed) /// 
	order(1.pairgov ) ///
	mtitle("Model 4" "Model 5" "Model 6" ) ///
	label nonumbers nobaselevels //	  


*R2: Share of attacks
correl pairshare_all pairshare freq satzscore_dsk

*M1a
xi: regress pairshare_all   /// 
	ib2.pairgov  c.skapgrof_ranksum  c.pairpoldis i.year, vce(bootstrap, reps(200))
	est store m_a7
*M2a:
xi: regress satzscore_dsk  /// 
	ib2.pairgov c.skapgrof_ranksum c.pairpoldis i.year , vce(bootstrap, reps(200)) 	 	 
	est store m_a8a
	
*M2a:
xi: regress satzscore_dsk  /// 
	ib2.pairgov c.skapgrof_ranksum c.pairpoldis i.year pairshare_all, vce(bootstrap, reps(200))  	 	 
	est store m_a8b	
	
*Table D3:
esttab m_a7 m_a8a m_a8b, se(2) b(a2)  /// 
	indicate("Election fixed effects = *year*") ///
	star(# 0.1 * 0.05 ** 0.01 *** 0.001) ///
	stats(ar2 pr2 bic N) style(fixed) /// 
	order(1.pairgov ) ///
	mtitle("Model 1a" "Model 1b" "Model 2a" "Model 2b" ) ///
	label nonumbers nobaselevels //	  	
	
	
*Replicating the analyses at the level of indiv. statements
use friendlyfire_replication_R2.dta, clear
d,s //3453 obs.

*Additional control: number of dyadic attacks/day (logged)
gen log_count=log(count_at)
lab var log_count "Number of dyadic attacks/day"

**OLS 
xi: regress satzscore_dsk  /// 
	ib2.pairgov c.skapgrof_ranksum c.pairpoldis i.year distelday log_count, vce(bootstrap, reps(200))  
	est store m_a10	

xi: regress satzscore_dsk  /// 
	ib2.pairgov c.pairpoldis i.year distelday c.log_count 1.subj_junior, vce(bootstrap, reps(200))   
	est store m_a11	 
 
* Table D4:
esttab m_a10 m_a11 , se(2) b(a2)  /// 
	indicate("Election fixed effects = *year*") ///
	star(# 0.1 * 0.05 ** 0.01 *** 0.001) ///
	stats(ar2 pr2 bic N) style(fixed) /// 
	order(1.pairgov ) ///
	mtitle("Model 7" "Model 8") ///
	label nonumbers nobaselevels //	  

graph close
