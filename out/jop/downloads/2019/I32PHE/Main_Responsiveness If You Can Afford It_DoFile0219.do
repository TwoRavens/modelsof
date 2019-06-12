********************************************************************************
*
* This do file creates the replication results for 
* "Responsiveness, If You Can Afford It: Policy Responsiveness in Good and Bad 
* Economic Times"
*
* Ezrow, Lawrence, Timothy Hellwig, and Michele Fenzl
*
* Created, Jan 2019
*
********************************************************************************

version 13

drop _all
clear matrix
clear mata

cap net install outreg2, from(http://fmwww.bc.edu/RePEc/bocode/o)			
cap ssc install xtserial
cap net install st0039.pkg
cap net install grinter, from(http://myweb.uiowa.edu/fboehmke/stata)
cap ssc install xttest3

/* outreg2 is used to compute the tables in the paper 				*/
/* xtserial is used to compute the Wooldrige (2002) test 			*/
/* grinter is used to plot the interaction term in Figure 1 (A)		*/
/* xttest3 computes a modified Wald statistic for groupwise heteroskedasticity
in fixed effect models (Greene 2000) 								*/

********************************************************************************
local DIR = ""  /*change the path to the directory on your computer */
cd "`DIR'" /* you have to set the working directory, otherwise the xls outputs 
will not work and the outreg2 commands will return an error 		*/
********************************************************************************

use "Responsiveness If You Can Afford It.dta", replace

set more off

********************************************************************************
********************************************************************************
********************************************************************************

************** 			PRE-ANALYSIS DIAGNOSTICS					************

/* testing heteroskedasticity */

qui reg d.totgen l.totgen d.cmedianall l.cmedianall d.realgdpgr l.realgdpgr ///
d.labf1000 l.labf1000 i.emu
estat hettest

qui reg d.totgen l.totgen d.cmedianall l.cmedianall d.realgdpgr l.realgdpgr ///
d.labf1000 l.labf1000 i.emu i.cc
estat hettest

qui xtreg d.totgen l.totgen d.cmedianall l.cmedianall d.realgdpgr l.realgdpgr ///
d.labf1000 l.labf1000 i.emu , fe
xttest3

/* testing AR1 */

cap gen dtotgen = d.totgen
cap gen ltotgen = l.totgen
cap gen dcmedianall = d.cmedianall
cap gen lcmedianall = l.cmedianall
cap gen drealgdpgr = d.realgdpgr
cap gen lrealgdpgr = l.realgdpgr
cap gen dlabf1000 = d.labf1000
cap gen llabf1000 = l.labf1000

qui xtreg dtotgen ltotgen dcmedianall lcmedianall drealgdpgr lrealgdpgr ///
dlabf1000 llabf1000 , fe
xtserial dtotgen ltotgen dcmedianall lcmedianall drealgdpgr lrealgdpgr ///
	dlabf1000 llabf1000 

qui xtreg dtotgen ltotgen dcmedianall lcmedianall drealgdpgr lrealgdpgr ///
dlabf1000 llabf1000 emu, fe
xtserial dtotgen ltotgen dcmedianall lcmedianall drealgdpgr lrealgdpgr ///
	dlabf1000 llabf1000 emu
	
/* testing stationarity */

xtunitroot fisher D.totgen, pperron demean lags(3)
xtunitroot ips D.totgen, demean lags(3)

********************************************************************************
********************************************************************************
********************************************************************************

************** 			CODE FOR THE REPLICATION OF RESULTS			************


* code to replicate table 1 in paper

/* Please note, we export the table in Excel format. This will automatically 
create the table files in your working directory folder. This means that if you
haven't set the working directory, the commands in line 122,123,124 will not 
work. To avoid this, set the wd or skip those lines. If you prefer to output 
the tables in other formats, you can substitute the option "excel" with "word" 
or "tex". 		 															  */

xtset cc year

label var totgen "Welfare state generosity"
label var cmedianall "Median voter position"
label var realgdpgr "Economic growth"
label var labf1000 "Labor force"
label var emu "EMU membership"

xtpcse d.totgen l.totgen d.cmedianall l.cmedianall d.realgdpgr l.realgdpgr ///
	d.labf1000 l.labf1000 i.emu i.cc, corr(ar1)
cap gen used = e(sample)
outreg2 using t1, excel lab  ctitle("Model 1", "Coeff." "") side dec(3) ///
	keep(L.totgen D.cmedianall L.cmedianall D.realgdpgr L.realgdpgr D.labf1000 L.labf1000 i.emu ///
	c.D.realgdpgr#c.D.cmedianall c.L.realgdpgr#c.L.cmedianall) 	replace

xtpcse d.totgen l.totgen d.cmedianall l.cmedianall d.realgdpgr l.realgdpgr ///
	c.d.realgdpgr#c.d.cmedianall c.l.realgdpgr#c.l.cmedianall ///
	d.labf1000 l.labf1000 i.emu i.cc if used == 1, corr(ar1)
outreg2 using t1, excel lab ctitle("Model 2", "Coeff." "") side dec(3) ///
	keep(L.totgen D.cmedianall L.cmedianall D.realgdpgr L.realgdpgr D.labf1000 L.labf1000 i.emu ///
	c.D.realgdpgr#c.D.cmedianall c.L.realgdpgr#c.L.cmedianall) 	append
	
	
/* we find a result that is statistically significant but exhibits a boundary
p-value (0.049). To address potential concerns, we test the robustness of our 
results when centering the variables instead of using i.cc (so the model is more
parsimonious). The results are as follows. */

preserve

	foreach v of var totgen cmedianall realgdpgr labf1000 {
      cap egen mean_`v' = mean(`v') , by(cc)
}
	
cap gen ctotgen=totgen - mean_totgen
cap gen ccmedianall=cmedianall - mean_cmedianall
cap gen crealgdpgr=realgdpgr - mean_realgdpgr
cap gen clabf1000=labf1000 - mean_labf1000


/* we then compare the results when using dummies and when centering 		*/

xtpcse d.totgen l.totgen d.cmedianall l.cmedianall d.realgdpgr l.realgdpgr ///
	c.d.realgdpgr#c.d.cmedianall c.l.realgdpgr#c.l.cmedianall ///
	d.labf1000 l.labf1000 i.emu i.cc if used == 1, corr(ar1)
xtpcse d.ctotgen l.ctotgen d.ccmedianall l.ccmedianall d.crealgdpgr l.crealgdpgr ///
	c.d.crealgdpgr#c.d.ccmedianall c.l.crealgdpgr#c.l.ccmedianall ///
	d.clabf1000 l.clabf1000 i.emu if used == 1, corr(ar1)

restore
	
/* we find that our result now exhibits a lower p-value and more sizable 
coefficient. To be more conservative, we include our starting result in the
analysis. We further test the robustness of results to the inclusion of more 
controls in the supplementary materials. */

********************************************************************************
********************************************************************************
********************************************************************************

* code to replicate Figure 1A (based on estimates of model 2 in table 1)
	

cap gen dtotgen = d.totgen
cap gen ltotgen = l.totgen
cap gen dcmedianall = d.cmedianall
cap gen lcmedianall = l.cmedianall
cap gen drealgdpgr = d.realgdpgr
cap gen lrealgdpgr = l.realgdpgr
cap gen dlabf1000 = d.labf1000
cap gen llabf1000 = l.labf1000
cap gen Dinter = dcmedianall * drealgdpgr
cap gen Linter = lcmedianall * lrealgdpgr

label var dtotgen "Change in generosity (t)"
label var lcmedianall "Median voter position (t-1)"
label var lrealgdpgr "Economic growth (t-1)"

qui xtpcse dtotgen ltotgen dcmedianall lcmedianall drealgdpgr lrealgdpgr ///
	Dinter Linter dlabf1000 llabf1000 i.emu i.cc if used == 1, corr(ar1)
grinter (lcmedianall), inter(Linter) const(lrealgdpgr) ///
	yline(0, lc(gs7)) lc(black) nom non ///
	ytitle(Conditional coefficient on Median voter position (t-1)) ///
	graphr(c(white)) saving("Figure1A", replace)
graph export Figure1A.gph, as(pdf) replace	

***************************************	
	
* code to replicate Figure 1B 
	
/* Before, running place the following files in your working directory: 
dynsim.ado, dynsim_pcse, estsimp_pcse, simqi_pcse

Once you have those files in the working directory, run the following code 

[Credits to Williams, Laron K., and Guy D. Whitten. 2011. Dynamic Simulations 
of Autoregressive Relationships. Stata Journal 11(4):577-588]				*/	
	
cap gen l_totgen = l.totgen
cap gen l_cmedianall = l.cmedianall
cap gen l_realgdpgr = l.realgdpgr
cap gen l_labf1000 = l.labf1000
cap gen cmedxgro = cmedianall*realgdpgr
cap gen l_cmedxgro = l_cmedianall*l_realgdpgr
qui xtpcse totgen l_totgen cmedianall l_cmedianall realgdpgr l_realgdpgr ///
	cmedxgro l_cmedxgro labf1000 l_labf1000 emu i.cc, corr(ar1)
predict e if e(sample)
dynsim_pcse if e~=., dv(totgen) ldv(l_totgen) ldv_val(34) time(year) pv(cc) ///
	scen1(cmedianall 4.8 l_cmedianall 4.8 realgdpgr 5 l_realgdpgr 5 labf1000 ///
	6 l_labf1000 6 emu 0 cmedxgro 24 l_cmedxgro 24) scen2(cmedianall 4.8 ///
	l_cmedianall 4.8 realgdpgr 2.5 l_realgdpgr 2.5 labf1000 6 l_labf1000 6 emu ///
	0 cmedxgro 12 l_cmedxgro 12) scen3(cmedianall 4.8 l_cmedianall 4.8 realgdpgr ///
	0 l_realgdpgr 0 labf1000 6 l_labf1000 6 emu 0 cmedxgro 0 l_cmedxgro 0) ///
	command(xtpcse) sims(10000) n(7) scheme(s1mono) ///
	ytitle("Welfare generosity") legend(label(1 "5%") label(2 "2.5%") ///
	label(3 "0%")) note("Median voter position set to mean-1sd") ///
	xtitle("year + t") name(gen_left3, replace) scheme(s1mono) 
graph save Graph "`DIR'\dynsim_01282019.gph", replace
graph export "`DIR'\dynsim_01282019.tif", as(tif) replace
