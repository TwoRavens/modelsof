/*
Written by Leila Agha and David Molitor
Date: 2/3/17
Creates figures and tables reported in the paper
*/

cap clear matrix
set more off
set linesize 250
set matsize 1600


* Project Home Directory
local home PATH_TO_PROJECT_HOME_DIRECTORY



* Load the baseline regression file
use `home'/regdata_hrr_new, clear


***********PART A: Variables needed for regressions**********

*Generate authorship region variables
gen ol_na= (no_proxol_hrr2==1 & a_group==0)
label var ol_na "Other or last author region, non-author practice group"
gen ol_a= (no_proxol_hrr2==1 & a_group==1)
label var ol_a "Other or last author region, author practice group"
gen f_a= (no_proxf_hrr2==1 & a_group==1)
label var f_a "First author region, author practice group"
gen f_na = (no_proxf_hrr2==1 & a_group==0)
label var f_na "First author region, non-author practice group"
gen o_na= (no_proxo_hrr2==1 & a_group==0)
label var o_na "Other author region, non-author practice group"
gen o_a= (no_proxo_hrr2==1 & a_group==1)
label var o_a "Other author region, author practice group"
gen l_na= (no_proxl_hrr2==1 & a_group==0)
label var o_na "Last author region, non-author practice group"
gen l_a= (no_proxl_hrr2==1 & a_group==1)
label var l_a "Last author region, author practice group"

*Generate indicators for being top-cited author
gen cites_rank_top1 = (cites_rank==1)
gen cites_rank_top2 = (1<=cites_rank & cites_rank<=2)
bys drug: egen N = max(cites_rank)
gen cites_rank_top10pctl = (0<cites_rank & cites_rank<=ceil(.10*N))
gen cites_rank_top50pctl = (0<cites_rank & cites_rank<=ceil(.50*N))
gen cites_top50_group=(cites_rank_top50pctl & a_group)
gen cites_top50_nogr=(cites_rank_top50pctl==1 & a_group==0)
gen cites_top10_group=(cites_rank_top10pctl & a_group)
gen cites_top10_nogr=(cites_rank_top10pctl==1 & a_group==0)


*Create 5-year age bins
gen age65=(age<65)
forvalues i=70(5)100 {
gen age`i'=(age<`i' & age>=`i'-5)
}
gen age105=(age>=100)

destring sex, replace
destring race, replace
gen female=sex-1

*Defining regional adoption speed index
egen drugyr=group(ndrug eventyr)
tab race, gen(racedum)
quietly: tab phrrnum, gen(phrrdum)
areg chem_drug   phrrdum*   newspell racedum2-racedum7 female age65-age100  if 1<=eventyr & eventyr<=2 & !(latecode & eventyr==1) & no_proxf_hrr2!=1 & no_proxol_hrr2!=1, absorb(drugyr)
predict phrr_tech
replace phrr_tech=phrr_tech - _b[newspell]*newspell - _b[female]*female
forvalues i=65(5)100 {
replace phrr_tech=phrr_tech-_b[age`i']*age`i'
}
forvalues i=2/7 {
replace phrr_tech=phrr_tech-_b[racedum`i']
}
label var phrr_tech "Regional fixed effect predicting adoption speed in first 2 years"
gen f_tech=no_proxf_hrr2*(phrr_tech-r(mean))/r(sd)
label var f_tech "First author region * Regional Index of Tech Adopt Speed"
gen ol_tech=no_proxol_hrr2*(phrr_tech-r(mean))/r(sd)
label var ol_tech "Other or last author region * Regional Index of Tech Adopt Speed"

*Create interactions of travel status and author regions
gen traveler = (resident==0)
gen traveler_f=traveler*no_proxf_hrr2
gen traveler_ol=traveler*no_proxol_hrr2

*************FIGURES**************
*Figure 2: generate summary statistics needed for Excel graph
* Data should be balanced panel (i.e. drug codes start in eventyr==1, and extend through 4 eventyrs)
preserve
	keep if bal_4 & !latecode & (1<=eventyr & eventyr<=4)
	bys drug eventyr no_proxf_hrr2 no_proxol_hrr2: egen mean_druguse = mean(chem_drug)
	bys drug eventyr no_proxf_hrr2 no_proxol_hrr2: keep if _n==1

	* Stats for figure
	tabstat mean_druguse if no_proxf_hrr2, by(eventyr)
	tabstat mean_druguse if no_proxol_hrr2, by(eventyr)
	tabstat mean_druguse if !no_proxf_hrr2 & !no_proxol_hrr2, by(eventyr)
restore
preserve

*Figure 3: Event year graph
areg chem_drug i.no_proxf_hrr2#i.eventyr      newspell         i.race female age65-age105                         i.ndrug##i.eventyr if 1<=eventyr & eventyr<=4 & !(latecode & eventyr==1),   a(phrrcancer3) cluster(phrrdrug)
areg chem_drug i.no_proxf_hrr2#i.eventyr     i.no_proxol_hrr2#i.eventyr   newspell  i.race female age65-age105     i.ndrug##i.eventyr if 1<=eventyr & eventyr<=4 & !(latecode & eventyr==1),   a(phrrcancer3) cluster(phrrdrug)
estimates store PATH_TO_PROJECT_HOME_DIRECTORY/tables/eventyrreg
	estimates clear
		estimates use PATH_TO_PROJECT_HOME_DIRECTORY/tables/eventyrreg
		
	foreach author in f ol {
		clear
		set obs 4
		gen coefs = 0 
		gen coefs_ciL = 0 
		gen coefs_ciH = 0 
		gen eventyr = _n
		forvalues yr = 1/4 {
			lincom _b[1.no_prox`author'_hrr2#`yr'.eventyr]
				replace coefs = r(estimate) if eventyr==`yr'
				replace coefs_ciL = coefs - 1.96*`r(se)' if eventyr==`yr'
				replace coefs_ciH = coefs + 1.96*`r(se)' if eventyr==`yr'
		}
		
		* Plot line graphs
		sort eventyr
		local ibeam (rcap coefs_ciL coefs_ciH eventyr, lcolor(gs9) lwidth(thin))
		local lineH (line coefs_ciH eventyr,           lcolor(gs9) lwidth(thin))
		local lineM (connected coefs eventyr,          lcolor(ebblue*2) mlcolor(ebblue*2) mlwidth(thin) mfcolor(bluishgray*1.2))
		local lineL (line coefs_ciL eventyr,           lcolor(gs9) lwidth(thin))
		local xlabel 1 (1) 4
		local xtitle "{it:t} = Years Since FDA Approval"
		local ylabel 0 (.025) .05, grid glc(gs14)
		local ytitle 
		if "`author'"=="ol" local title "Other author proximity effect" 
		if "`author'"=="f" local title "First author proximity effect" 
		local subtitle "phrrcancer3-eventyr fixed effects"
		local legend cols(1) order(3 "95% Confidence Interval" 5 "Estimated difference, by year since move" )
		local graphregion color(white)
		
		* Graph with no legend
	graph twoway `ibeam' `lineM', xlabel(`xlabel') xtitle(`xtitle') ytitle(`ytitle') yline(0, lc(black)) title(`"`title'"')  ylabel(`ylabel') legend(off) graphregion(`graphregion')
*"	
	graph save PATH_TO_PROJECT_HOME_DIRECTORY/tables/graph`author'.gph, replace
	restore
	}

	
	local g1 PATH_TO_PROJECT_HOME_DIRECTORY/tables/graphf.gph
	local g2 PATH_TO_PROJECT_HOME_DIRECTORY/tables/graphol.gph
	graph combine `g1' `g2', ycommon imargin(medsmall) graphregion(margin(small) fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
	graph save PATH_TO_PROJECT_HOME_DIRECTORY/tables/combined.gph, replace
	graph export PATH_TO_PROJECT_HOME_DIRECTORY/tables/combined.eps, as(eps) replace
	
	

**************TABLES**************************	
*Table 2: summary statistics
*Column 1
	sum chem_drug a_group if no_proxf_hrr2 & 1<=eventyr & eventyr<=2 & !(latecode & eventyr==1)
	codebook phrrnum if no_proxf_hrr2 & 1<=eventyr & eventyr<=2 & !(latecode & eventyr==1)
	codebook phrrdrug if no_proxf_hrr2 & 1<=eventyr & eventyr<=2 & !(latecode & eventyr==1)
*Column 2
	sum chem_drug a_group if no_proxol_hrr2 & 1<=eventyr & eventyr<=2 & !(latecode & eventyr==1)
	codebook phrrnum if no_proxol_hrr2 & 1<=eventyr & eventyr<=2 & !(latecode & eventyr==1)
	codebook phrrdrug if no_proxol_hrr2 & 1<=eventyr & eventyr<=2 & !(latecode & eventyr==1)
*Column 3
	sum chem_drug a_group if !no_proxf_hrr2 & !no_proxol_hrr2 & everproxa==1 & 1<=eventyr & eventyr<=2 & !(latecode & eventyr==1)
	codebook phrrnum if !no_proxf_hrr2 & !no_proxol_hrr2 & everproxa==1& 1<=eventyr & eventyr<=2 & !(latecode & eventyr==1)
	codebook phrrdrug if !no_proxf_hrr2 & !no_proxol_hrr2 & everproxa==1 & 1<=eventyr & eventyr<=2 & !(latecode & eventyr==1)
*Column 4	
	sum chem_drug a_group if !no_proxf_hrr2 & !no_proxol_hrr2 & !everproxa==1 & 1<=eventyr & eventyr<=2 & !(latecode & eventyr==1)
	codebook phrrnum if !no_proxf_hrr2 & !no_proxol_hrr2 & !everproxa==1& 1<=eventyr & eventyr<=2 & !(latecode & eventyr==1)
	codebook phrrdrug if !no_proxf_hrr2 & !no_proxol_hrr2 & !everproxa==1 & 1<=eventyr & eventyr<=2 & !(latecode & eventyr==1)

	
*TABLE 3: main results & sample variations
* Full sample
*Column 1
areg chem_drug no_proxf_hrr2               no_proxol_hrr2             newspell  i.race female age65-age105 i.ndrug##i.eventyr if 1<=eventyr & eventyr<=2 & !(latecode & eventyr==1),   a(phrrcancer3) cluster(phrrdrug)
outreg2 no_proxf_hrr2 no_proxol_hrr2  using PATH_TO_PROJECT_HOME_DIRECTORY/tables/table1.out, se nolabel bdec(4) sdec(4) rdec(3)  nocons symbol(***, **, *) excel replace
*Column 2
areg chem_drug f_a f_na ol_a ol_na i.ndrug##i.eventyr newspell i.race female age65-age105 if 1<=eventyr & eventyr<=2 & !(latecode & eventyr==1),   a(phrrcancer3) cluster(phrrdrug)
outreg2 no_proxf_nogr_hrr2 no_f_group2 no_proxol_nogr_hrr2 no_ol_group2  using PATH_TO_PROJECT_HOME_DIRECTORY/tables/table1.out, se nolabel bdec(4) sdec(4) rdec(3)  nocons symbol(***, **, *) excel append

* Author regions
*Column 3
areg chem_drug no_proxf_hrr2               no_proxol_hrr2            newspell     i.ndrug##i.eventyr i.race female age65-age105 if 1<=eventyr & eventyr<=2 & !(latecode & eventyr==1) & everproxa==1,   a(phrrcancer3) cluster(phrrdrug)
outreg2 no_proxf_hrr2 no_proxol_hrr2  using PATH_TO_PROJECT_HOME_DIRECTORY/tables/table1.out, se nolabel bdec(4) sdec(4) rdec(3)  nocons symbol(***, **, *) excel append
*Column 4
areg chem_drug f_a f_na ol_a ol_na i.ndrug##i.eventyr i.race female age65-age105 if 1<=eventyr & eventyr<=2 & !(latecode & eventyr==1) & everproxa==1,   a(phrrcancer3) cluster(phrrdrug)
outreg2  no_proxf_nogr_hrr2 no_f_group2 no_proxol_nogr_hrr2 no_ol_group2 using PATH_TO_PROJECT_HOME_DIRECTORY/tables/table1.out, se nolabel bdec(4) sdec(4) rdec(3)  nocons symbol(***, **, *) excel append

*New cancer patients
*Column 5
areg chem_drug no_proxf_hrr2               no_proxol_hrr2  newspell        i.race female age65-age105      i.ndrug##i.eventyr if 1<=eventyr & eventyr<=2 & !(latecode & eventyr==1) & newspell==1,   a(phrrcancer3) cluster(phrrdrug)
outreg2 no_proxf_hrr2 no_proxol_hrr2  using PATH_TO_PROJECT_HOME_DIRECTORY/tables/table1.out, se nolabel bdec(4) sdec(4) rdec(3)  nocons symbol(***, **, *) excel append
*Column 6
areg chem_drug f_a f_na ol_a ol_na i.ndrug##i.eventyr newspell i.race female age65-age105 if 1<=eventyr & eventyr<=2 & !(latecode & eventyr==1) & newspell==1,   a(phrrcancer3) cluster(phrrdrug)
outreg2  no_proxf_nogr_hrr2 no_f_group2 no_proxol_nogr_hrr2 no_ol_group2  using PATH_TO_PROJECT_HOME_DIRECTORY/tables/table1.out, se nolabel bdec(4) sdec(4) rdec(3)  nocons symbol(***, **, *) excel append

***TABLE 4: Superstar Author Effects
*Column 1, first author
areg chem_drug no_proxf_hrr2   newspell   i.race female age65-age105      i.ndrug##i.no_proxa_hrr2 i.ndrug##i.eventyr if 1<=eventyr & eventyr<=2 & !(latecode & eventyr==1), a(phrrcancer3) cluster(phrrdrug)
outreg2 no_proxf_hrr2 using PATH_TO_PROJECT_HOME_DIRECTORY/tables/table2.out, se nolabel bdec(4) sdec(4) rdec(3)  nocons symbol(***, **, *) excel replace

*Column 2, top 50
areg chem_drug cites_rank_top50pctl newspell i.race female age65-age105 i.ndrug##i.no_proxa_hrr2 i.ndrug##i.eventyr if 1<=eventyr & eventyr<=2 & !(latecode & eventyr==1), a(phrrcancer3) cluster(phrrdrug)
outreg2 cites_rank_top50pctl using PATH_TO_PROJECT_HOME_DIRECTORY/tables/table2.out, se nolabel bdec(4) sdec(4) rdec(3)  nocons symbol(***, **, *) excel append

*Column 3, top 10
areg chem_drug cites_rank_top10pctl i.ndrug##i.no_proxa_hrr2 newspell i.race female age65-age105 i.ndrug##i.eventyr if 1<=eventyr & eventyr<=2 & !(latecode & eventyr==1), a(phrrcancer3) cluster(phrrdrug)
outreg2 cites_rank_top10pctl using PATH_TO_PROJECT_HOME_DIRECTORY/tables/table2.out, se nolabel bdec(4) sdec(4) rdec(3)  nocons symbol(***, **, *) excel append

*Column 4, first, top 50
areg chem_drug no_proxf_hrr2 cites_rank_top50pctl cites_rank_top10pctl newspell i.race female age65-age105 i.ndrug##i.no_proxa_hrr2 i.ndrug##i.eventyr if 1<=eventyr & eventyr<=2 & !(latecode & eventyr==1), a(phrrcancer3) cluster(phrrdrug)
outreg2 no_proxf_hrr2 cites_rank_top50pctl cites_rank_top10pctl using PATH_TO_PROJECT_HOME_DIRECTORY/tables/table2.out, se nolabel bdec(4) sdec(4) rdec(3)  nocons symbol(***, **, *) excel append

*Column 5, first, top 10
areg chem_drug no_proxf_hrr2 cites_rank_top10pctl i.ndrug##i.no_proxa_hrr2 newspell i.race female age65-age105 i.ndrug##i.eventyr if 1<=eventyr & eventyr<=2 & !(latecode & eventyr==1), a(phrrcancer3) cluster(phrrdrug)
outreg2 no_proxf_hrr2 cites_rank_top50pctl cites_rank_top10pctl using PATH_TO_PROJECT_HOME_DIRECTORY/tables/table2.out, se nolabel bdec(4) sdec(4) rdec(3)  nocons symbol(***, **, *) excel append

*Column 6, top 50, top 10
areg chem_drug no_proxf_hrr2 cites_rank_top50pctl i.ndrug##i.no_proxa_hrr2 newspell i.race female age65-age105 i.ndrug##i.eventyr if 1<=eventyr & eventyr<=2 & !(latecode & eventyr==1), a(phrrcancer3) cluster(phrrdrug)
outreg2 no_proxf_hrr2 cites_rank_top50pctl cites_rank_top10pctl using PATH_TO_PROJECT_HOME_DIRECTORY/tables/table2.out, se nolabel bdec(4) sdec(4) rdec(3)  nocons symbol(***, **, *) excel append


***TABLE 5:
*Column 1: tech adoption speed
areg chem_drug no_proxf_hrr2    f_tech           no_proxol_hrr2   ol_tech   newspell i.race female age65-age105         i.ndrug##i.eventyr if 1<=eventyr & eventyr<=2 & !(latecode & eventyr==1),   a(phrrcancer3) cluster(phrrdrug)
outreg2 no_proxf_hrr2    f_tech           no_proxol_hrr2   ol_tech         using PATH_TO_PROJECT_HOME_DIRECTORY/tablesscope.out, se nolabel bdec(4) sdec(4) rdec(3)  nocons symbol(***, **, *) excel replace
*Column 2: only author regions
areg chem_drug no_proxf_hrr2    f_tech           no_proxol_hrr2   ol_tech  newspell  i.race female age65-age105         i.ndrug##i.eventyr if 1<=eventyr & eventyr<=2 & !(latecode & eventyr==1) & everproxa,   a(phrrcancer3) cluster(phrrdrug)
outreg2 no_proxf_hrr2    f_tech           no_proxol_hrr2   ol_tech         using PATH_TO_PROJECT_HOME_DIRECTORY/tablesscope.out, se nolabel bdec(4) sdec(4) rdec(3)  nocons symbol(***, **, *) excel append

*Column 3: neighbor region drug adoption
areg chem_drug no_proxf_hrr2  pneighborf_hrr2_dum             no_proxol_hrr2  pneighborol_hrr2_dum newspell   i.race female age65-age105          i.ndrug##i.eventyr if 1<=eventyr & eventyr<=2 & !(latecode & eventyr==1) ,   a(phrrcancer3) cluster(phrrdrug)
outreg2  no_proxf_hrr2  pneighborf_hrr2_dum             no_proxol_hrr2  pneighborol_hrr2_dum  i.race female age65-age105  using PATH_TO_PROJECT_HOME_DIRECTORY/tables/scope.out, se nolabel bdec(4) sdec(4) rdec(3)  nocons symbol(***, **, *) excel append
*Column 4: only neighbor, author & neighbor regions 
areg chem_drug no_proxf_hrr2  pneighborf_hrr2_dum             no_proxol_hrr2  pneighborol_hrr2_dum   newspell     i.race female age65-age105      i.ndrug##i.eventyr if 1<=eventyr & eventyr<=2 & !(latecode & eventyr==1) & (everproxa==1 | everpneighbora==1),   a(phrrcancer3) cluster(phrrdrug)
outreg2  no_proxf_hrr2  pneighborf_hrr2_dum             no_proxol_hrr2  pneighborol_hrr2_dum    using PATH_TO_PROJECT_HOME_DIRECTORY/tables/scope.out, se nolabel bdec(4) sdec(4) rdec(3)  nocons symbol(***, **, *) excel append

use PATH_TO_PROJECT_HOME_DIRECTORY/offlabel_reg.dta, clear
*Statistics reported in paper, but not in table
sum chem_drug if 1<=eventyr & eventyr<=2 & !(latecode & eventyr==1) & everproxa==1 & !onlabel_narrow
*Column 5: off-label drug use
areg chem_drug no_proxf_hrr2               no_proxol_hrr2          newspell  i.race female age65-age105       i.ndrug##i.eventyr if 1<=eventyr & eventyr<=2 & !(latecode & eventyr==1) & !onlabel_narrow,   a(phrrcancer3) cluster(phrrdrug)
outreg2 no_proxf_hrr2 no_proxol_hrr2  using PATH_TO_PROJECT_HOME_DIRECTORY/tables/offlabel.out, se nolabel bdec(4) sdec(4) rdec(3)  nocons symbol(***, **, *) excel replace
*Column 6: only author regions
areg chem_drug no_proxf_hrr2               no_proxol_hrr2          newspell  i.race female age65-age105       i.ndrug##i.eventyr if 1<=eventyr & eventyr<=2 & !(latecode & eventyr==1) & !onlabel_narrow & everproxa,   a(phrrcancer3) cluster(phrrdrug)
outreg2 no_proxf_hrr2 no_proxol_hrr2  using PATH_TO_PROJECT_HOME_DIRECTORY/tables/offlabel.out, se nolabel bdec(4) sdec(4) rdec(3)  nocons symbol(***, **, *) excel append

restore
preserve

*****TABLE 6:
*Column 1, traveler
areg traveler no_proxf_hrr2               no_proxol_hrr2      newspell      i.race female age65-age105    i.ndrug##i.eventyr if 1<=eventyr & eventyr<=2 & !(latecode & eventyr==1),   a(phrrcancer3) cluster(phrrdrug)
outreg2 no_proxf_hrr2 no_proxol_hrr2  using PATH_TO_PROJECT_HOME_DIRECTORY/tables/table3.out, se nolabel bdec(4) sdec(4) rdec(3)  nocons symbol(***, **, *) excel replace
**Column 2: traveler, author regions only
areg traveler no_proxf_hrr2               no_proxol_hrr2      newspell  i.race female age65-age105        i.ndrug##i.eventyr if 1<=eventyr & eventyr<=2 & !(latecode & eventyr==1) & everproxa==1,   a(phrrcancer3) cluster(phrrdrug)
outreg2 no_proxf_hrr2 no_proxol_hrr2  using PATH_TO_PROJECT_HOME_DIRECTORY/tables/table3.out, se nolabel bdec(4) sdec(4) rdec(3)  nocons symbol(***, **, *) excel append

*Column 3: traveler drug use
areg chem_drug no_proxf_hrr2  traveler_f             no_proxol_hrr2  traveler_ol     newspell   i.race female age65-age105      i.ndrug##i.eventyr if 1<=eventyr & eventyr<=2 & !(latecode & eventyr==1),   a(phrrcancer3) cluster(phrrdrug)
outreg2 no_proxf_hrr2  traveler_f            no_proxol_hrr2  traveler_ol using PATH_TO_PROJECT_HOME_DIRECTORY/tables/table3.out, se nolabel bdec(4) sdec(4) rdec(3)  nocons symbol(***, **, *) excel append
*Column 4: traveler drug use, author regions only
areg chem_drug no_proxf_hrr2  traveler_f             no_proxol_hrr2  traveler_ol  newspell     i.race female age65-age105       i.ndrug##i.eventyr if 1<=eventyr & eventyr<=2 & !(latecode & eventyr==1) & everproxa==1,   a(phrrcancer3) cluster(phrrdrug)
outreg2 no_proxf_hrr2  traveler_f            no_proxol_hrr2  traveler_ol using PATH_TO_PROJECT_HOME_DIRECTORY/tables/table3.out, se nolabel bdec(4) sdec(4) rdec(3)  nocons symbol(***, **, *) excel append

****TABLE 7
*Panel A RF results
*Column 1 main
areg chem_drug no_broxf_hrr2 no_broxol_hrr2               newspell      i.race female age65-age105    i.ndrug##i.eventyr if 1<=eventyr & eventyr<=2 & !(latecode & eventyr==1),   a(phrrcancer3) cluster(phrrdrug)
outreg2 no_broxf_hrr2 no_broxol_hrr2       using PATH_TO_PROJECT_HOME_DIRECTORY/tables/rf.out, se nolabel bdec(4) sdec(4) rdec(3)  nocons symbol(***, **, *) excel replace

*Column 2 author regions only
areg chem_drug no_broxf_hrr2    no_broxol_hrr2    newspell   i.race female age65-age105               i.ndrug##i.eventyr if 1<=eventyr & eventyr<=2 & !(latecode & eventyr==1) & everproxa==1,   a(phrrcancer3) cluster(phrrdrug)
outreg2 no_broxf_hrr2 no_broxol_hrr2       using PATH_TO_PROJECT_HOME_DIRECTORY/tables/rf.out, se nolabel bdec(4) sdec(4) rdec(3)  nocons symbol(***, **, *) excel append

*Column 3 include neighbor instrument
areg chem_drug no_broxf_hrr2        bneighborf_hrr2_dum    no_broxol_hrr2       bneighborol_hrr2_dum  newspell     i.race female age65-age105       i.ndrug##i.eventyr if 1<=eventyr & eventyr<=2 & !(latecode & eventyr==1),   a(phrrcancer3) cluster(phrrdrug)
outreg2 no_broxf_hrr2        bneighborf_hrr2_dum    no_broxol_hrr2       bneighborol_hrr2_dum          using PATH_TO_PROJECT_HOME_DIRECTORY/tables/rf.out, se nolabel bdec(4) sdec(4) rdec(3)  nocons symbol(***, **, *) excel append

*Column 4: IV
keep if !missing(no_broxf_hrr2) & !missing(no_broxol_hrr2) & 1<=eventyr & eventyr<=2 & !(latecode & eventyr==1)
foreach var of varlist chem_drug no_proxf_hrr2 no_proxol_hrr2 no_broxf_hrr2 no_broxol_hrr2 female age65-age105 racedum* newspell {
		qui areg `var' i.ndrug##i.eventyr, a(p`prov'cancer3)
		predict e_`var', residuals
	}
ivregress 2sls e_chem_drug (e_no_proxf_hrr2 e_no_proxol_hrr2 = e_no_broxf_hrr2 e_no_broxol_hrr2) e_newspell e_female e_age65-e_age105 e_racedum* if 1<=eventyr & eventyr<=2 & !(latecode & eventyr==1), cluster(phrrdrug) noempty first

*Column 5: IV authors only
restore
preserve
keep if !missing(no_broxf_hrr2) & !missing(no_broxol_hrr2) & 1<=eventyr & eventyr<=2 & !(latecode & eventyr==1) & everproxa==1
foreach var of varlist chem_drug no_proxf_hrr2 no_proxol_hrr2 no_broxf_hrr2 no_broxol_hrr2 female age65-age105 racedum* newspell {
		qui areg `var' i.ndrug##i.eventyr, a(p`prov'cancer3)
		predict e_`var', residuals
	}
ivregress 2sls e_chem_drug (e_no_proxf_hrr2 e_no_proxol_hrr2 = e_no_broxf_hrr2 e_no_broxol_hrr2) e_female e_age65-e_age105 e_newspell e_racedum* if 1<=eventyr & eventyr<=2 & !(latecode & eventyr==1) & everproxa==1, cluster(phrrdrug) noempty first

*Column 6: IV include neighbor instrument
restore
preserve
keep if !missing(no_broxf_hrr2) & !missing(no_broxol_hrr2) & 1<=eventyr & eventyr<=2 & !(latecode & eventyr==1) & everproxa==1
foreach var of varlist chem_drug no_proxf_hrr2 no_proxol_hrr2 no_broxf_hrr2 no_broxol_hrr2 bneighborf_hrr2_dum bneighborol_hrr2_dum newspell female age65-age105 racedum* {
		qui areg `var' i.ndrug##i.eventyr, a(phrrcancer3)
		predict e_`var', residuals
	}	
ivregress 2sls e_chem_drug (e_no_proxf_hrr2 e_no_proxol_hrr2 = e_no_broxf_hrr2 e_bneighborf_hrr2_dum e_no_broxol_hrr2 e_bneighborol_hrr2_dum) e_newspell e_female e_age65-e_age105 e_racedum* if 1<=eventyr & eventyr<=2 & !(latecode & eventyr==1), cluster(phrrdrug) noempty first




