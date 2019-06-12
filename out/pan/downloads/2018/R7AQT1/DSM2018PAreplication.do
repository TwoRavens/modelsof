**************************************
**************************************

*Users who use the replication code should cite the replication materials: 
*Dion, Michelle; Sumner, Jane Lawrence; Mitchell, Sara McLaughlin, 2018, "Replication Data for: Gendered Citation Patterns across Political Science and Social Science Methodology Fields", doi:10.7910/DVN/R7AQT1, Harvard Dataverse

**************************************
**************************************

**************************************
* Table 1
**************************************
use "DSM2018PAreplication_articlesonly.dta", clear
tab newjnlid authorteam, row

**************************************
* Table 2
**************************************
use "DSM2018PAreplication.dta", clear
tab newjnlid if refauthcomplete == 1
tab newjnlid refteam, row

**************************************
* Table 3: Model 1 by journals + pooled
**************************************
* set up loop for Y = reference if all fem = 1, mixed/male = 0
levelsof newjnlid, local(groups) 
local estimates_list
* repeat 
foreach g of local groups {
    qui: logit reffemonly i.authorteam if newjnlid == `g', cluster(newartid)
	estimates store m1jnl`g'
    local estimates_list `estimates_list' m1jnl`g'
}
* run logit for all journals
qui: logit reffemonly i.authorteam i.newjnlid, cluster(newartid)
est store m1jnl_all
* export results
outreg2 [`estimates_list' m1jnl_all] using "Table3.txt", label se replace dec(2) noas noni e(all)

**************************************
*
* figures
*
**************************************
* set font to Verdana
graph set window fontface "Verdana"
**************************************
* Figure 1: predicted probabilities & figures by journal
**************************************
* apsr
est restore m1jnl1
margins i.authorteam
marginsplot ,   recast(bar) scheme(s1mono) ytitle("Pr(Female only reference)", size(large)) xtitle(, size(large)) title("APSR", size(large)) ciopts(lcolor(black) lwidth(medthick)) xlab( , labsize(large)) ylab(.05(.1).65, labsize(large)) yscale(axis(.05(.1).65)) ytick(.05(.05).65) ysize(4) xsize(5)
* graph save Graph "femonlyDV_APSR_predictedprobs.gph", replace
graph export Figure1a.tif, height(8000) width(10000) replace
* P&G
est restore m1jnl2
margins i.authorteam
marginsplot ,   recast(bar) scheme(s1mono) ytitle("Pr(Female only reference)", size(large)) xtitle(, size(large)) title("Politics & Gender", size(large)) ciopts(lcolor(black) lwidth(medthick)) xlab( , labsize(large)) ylab(.05(.1).65, labsize(large)) yscale(axis(.05(.1).65)) ytick(.05(.05).65) ysize(4) xsize(5)
*graph save Graph "femonlyDV_PG_predictedprobs.gph", replace
graph export Figure1b.tif, height(8000) width(10000) replace
* PA
est restore m1jnl3
margins i.authorteam
marginsplot ,   recast(bar) scheme(s1mono) ytitle("Pr(Female only reference)", size(large)) xtitle(, size(large)) title("Political Analysis", size(large)) ciopts(lcolor(black) lwidth(medthick)) xlab( , labsize(large)) ylab(.05(.1).65, labsize(large)) yscale(axis(.05(.1).65)) ytick(.05(.05).65) ysize(4) xsize(5)
*graph save Graph "femonlyDV_PA_predictedprobs.gph", replace
graph export Figure1c.tif, height(8000) width(10000) replace
* Econ
est restore m1jnl4
margins i.authorteam
marginsplot ,   recast(bar) scheme(s1mono) ytitle("Pr(Female only reference)", size(large)) xtitle(, size(large)) title("Econometrica", size(large)) ciopts(lcolor(black) lwidth(medthick)) xlab( , labsize(large)) ylab(.05(.1).65, labsize(large)) yscale(axis(.05(.1).65)) ytick(.05(.05).65) ysize(4) xsize(5)
*graph save Graph "femonlyDV_Econ_predictedprobs.gph", replace
graph export Figure1d.tif, height(8000) width(10000) replace
* SMR
est restore m1jnl5
margins i.authorteam
marginsplot ,   recast(bar) scheme(s1mono) ytitle("Pr(Female only reference)", size(large)) xtitle(, size(large)) title("Soc. Methods & Res.", size(large)) ciopts(lcolor(black) lwidth(medthick)) xlab( , labsize(large)) ylab(.05(.1).65, labsize(large)) yscale(axis(.05(.1).65)) ytick(.05(.05).65) ysize(4) xsize(5)
*graph save Graph "20171127_femonlyDV_SMR_predictedprobs.gph", replace
graph export Figure1e.tif, height(8000) width(10000) replace

*******************************************************************
* Figure 2: Plots of odds-ratios 
*******************************************************************
**** Figure to compare the coefficients across the different models 1-5 - Fem only ref authors
coefplot (m1jnl1, keep(*.authorteam) label(APSR) eform ) (m1jnl2, label("P. & Gender") keep(*.authorteam) eform) (m1jnl3, label("P. Analyisis") keep(*.authorteam) eform) (m1jnl4, label(Econometrica) keep(*.authorteam) eform) (m1jnl5, label("Soc. Methods & Res.") keep(*.authorteam) eform) (m1jnl_all, label("Pooled") keep(*.authorteam) eform), ysize(4) xsize(5) xtitle("Odds of citing female-only authors") xline(1) scheme(s1mono) legend(cols(2) region(lstyle(none)))
*graph save Graph "femonlyDV_wpooled.gph", replace
graph export Figure2.tif, height(8000) width(10000) replace

