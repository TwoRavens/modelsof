/*****************************************************************************************
AUTHORS: David Chan and Michael Dickstein, QJE (2019), "Industry Input in Policymaking: 
Evidence from Medicare"

PURPOSE: Counterfactual analyses

INPUTS:
- mu_w_spec.dta
- specialty_spec_med_xwalk.dta
- specialty_specid_xwalk.dta
- workrvuhistory.dta
- See .ado files for inputs indirectly used

OUTPUTS:
- Figure 5
- Figure A-10
- Figure A-11

NOTES: 
- In RVU history and RUC data, we observe that not all RUC decisions are passed on to 
  RVUs in a 100% manner. This program keeps track of these ratios and adjusts for them
  when considering counterfactual RUC recommendations so as to keep on equal ground with 
  actual recommendations. 
- Also, in RVU history, some RVUs change even without a RUC vote. This feature is kept
  and allows for previously changed counterfactual recommendations to be passed down
  through the years in this way.
- Revenue figures displayed are in Medicare work revenue, about 51% of $70 billion annual
  budget. Can scale up to include practice expense revenue (also set by the RUC) by 
  adding an additional 45% of $70 billion to the denominator. Can include private 
  insurance by including $480 billion per year (Clemens and Gottlieb, 2017).
*****************************************************************************************/

if "${dir}"!="" cd "${dir}"
	// Can set global macro for root directory of replication package ending with
	// "/replication". Otherwise, ensure that Stata is in the root directory.
assert regexm("`c(pwd)'","replication$")
clear all
program drop _all
adopath + ado

scalar affbeta=.1 
	// Coefficient in baseline specification of effect of affiliation on prices
	// Columnn 4 of Table 3
scalar budgetm=70000*.51
	// Assume Medicare budget of $70 billion as total budget going to physician payments, 
	// 51% of which going to work component of RVUs

*** Short program to display summary statistics ******************************************
capture program drop disp_sumstats 
program disp_sumstats, rclass 
syntax , var(string) label(string)
	qui sum `var'
	disp as text "   `label'" _n ///
		"     Millions redistributed = " ///
		as result string(`r(mean)',"%9.0f") _n ///
		as text "      Percent redistributed = " as result ///
		string(`=`r(mean)'/scalar(budgetm)*100',"%9.2f")
		return scalar dollars=`r(mean)'
end

*** Construct counterfactual RVUs ********************************************************
/*
. cf = 1: Original counterfactual scenario, no variation in affiliation within each year
. cf = 2: Counterfactual RUC membership
*/
qui foreach cf of numlist 1/2 {
if `cf'==1 noi disp as text _n "Equal Affiliation"
else noi disp as text _n "Proportional RUC Representation"

gen_working_data
gen_aff, moments(mean) norm
if `cf'==2 gen_aff, moments(mean) ///
	norm gen_memspec_opts(cf_file(data/crosswalks/ruc_cf_members.csv)) prefix(cf_)	
	
gen ruc_cycle_yr=cond(mtg_num==3,ruc_yr+1,ruc_yr)
gen year=ruc_cycle_yr+1
drop if obs_id==4201
merge 1:1 cpt_code year using data/raw/workrvuhistory, keep(match) nogen ///
	keepusing(rvu_value rvu_tminus? rvu_tplus?)
replace year=cond(rvu_tplus1!=0,year+1,cond(rvu_tplus2!=0,year+2,year)) ///
	if rvu_value==0
	// 158 out of missing 293 RUC to RVU translations can be rematched based on this
drop rvu_value rvu_t*
drop if obs_id==16698|obs_id==5805
merge 1:1 cpt_code year using data/raw/workrvuhistory, keep(match using) ///
	keepusing(rvu_value rvu_tminus? rvu_tplus?)
gen byte match=_merge==3
drop if year==1992
gen rvu_prop=rvu_value/rvu_tminus1
gen rvuruc_prop=rvu_value/ruc_rec

// Now consider counterfactuals
if `cf'==1 {
	by year, sort: egen avgnaff=mean(naff)
	gen cf_lnruc_rec=lnruc_rec+affbeta*(avgnaff-naff)
}
else {
	assert `cf'==2
	gen cf_lnruc_rec=lnruc_rec+affbeta*(ncf_aff-naff)
}
gen cf_ruc_rec=exp(cf_lnruc_rec)
gen cf_rvu_tminus1=rvu_tminus1 if year==1993
gen cf_rvu=.
sort cpt_code year
qui foreach year of numlist 1993/2014 {
	replace cf_rvu= ///
		cond(match,cond(rvuruc_prop==.,0,cf_ruc_rec*rvuruc_prop), ///
		cond(rvu_prop==.,rvu_value,cf_rvu_tminus1*rvu_prop))
	replace cf_rvu_tminus1=cf_rvu[_n-1] if year==`year'+1
}

*** Spending by CPT categories ***********************************************************
// Average counterfactual spending for each CPT code
preserve
tempfile cf_rvus
save `cf_rvus', replace
use data/intermediate/mu_w_spec.dta, clear
by year cpt_code, sort: egen totfreq=total(freq)
keep cpt_code year totfreq
duplicates drop
rename totfreq freq 
merge 1:1 cpt_code year using `cf_rvus', keep(match) nogen
by year, sort: egen totrvus=total(rvu_value*freq)
gen spend=scalar(budgetm)/totrvus*rvu_value*freq
by year: egen cf_totrvus=total(cf_rvu*freq)
gen cf_spend=scalar(budgetm)/cf_totrvus*cf_rvu*freq
keep spend cf_spend cpt_code year freq
drop if spend==0
foreach var in spend cf_spend {
	by cpt_code, sort: egen tot`var'=total(`var')
	gen mean`var'=tot`var'/21
	drop tot`var' `var'
}
drop year freq
duplicates drop
egen redist_cpt=total((meancf_spend-meanspend)*(meancf_spend-meanspend>0))
noi disp_sumstats, var(redist_cpt) label(Across CPTs)
assert round(r(dollars))==cond(`cf'==1,1024,227)

// Aggregate to BETOS
gen_var, betos
foreach var in spend cf_spend {
	by betos_super, sort: egen `var'=total(mean`var')
	drop mean`var'
}
keep spend cf_spend betos_super*
duplicates drop
gen spendb=spend/1000
gen diff_spend=cf_spend-spend
gen diff_spendb=diff_spend/1000
egen redist=total(diff_spend*(diff_spend>0))
qui sum redist
noi disp_sumstats, var(redist) label(Across BETOS)
assert round(r(dollars))==cond(`cf'==1,884,192)

// Create graphs
rename betos_super_desc bdesc
gen lab=string(betos_super)
gen labpos=3
if `cf'==1 {
	replace lab=cond(inlist(betos_super,3,16,5,2,1,14,15),bdesc,"")
	replace labpos=12 if inlist(betos_super,3,1,14)
	replace labpos=4 if inlist(betos_super,11)
	replace labpos=6 if inlist(betos_super,11)
	replace labpos=9 if inlist(betos_super,1)
}
else {
	assert `cf'==2
	replace lab=cond(inlist(betos_super,20,15,16,3,5,2,1),bdesc,"")
	replace labpos=6 if inlist(betos_super,15,2)
	replace labpos=9 if inlist(betos_super,1)
	replace labpos=4 if inlist(betos_super,5)
	replace labpos=3 if inlist(betos_super,3)
	replace labpos=2 if inlist(betos_super,20,16)
}
if `cf'==1 local title title(A: Equal Affiliation, color(black) size(medlarge))
else local title title(B: Proportional RUC Representation, color(black) size(medlarge))
twoway scatter diff_spend spend if spend>1, ///
	mcolor(black) mlabel(lab) mlabc(black) mlabv(labpos) ///
	`title' xtitle("Spending (millions $)") ///
	ytitle("Counterfactual reallocation (millions $)") ///
	graphregion(color(white)) ylabel(,nogrid) name(betos_cf`cf', replace)
restore

*** Spending by specialties **************************************************************
preserve
tempfile cf_rvus
save `cf_rvus', replace
use data/intermediate/mu_w_spec.dta, clear
mergemm, using(data/crosswalks/specialty_spec_med_xwalk) by(spec) ///
	masterunit(year spec cpt_code) keepusingvar(specialty)
by year cpt_code specialty, sort: egen totfreq=total(freq)
keep year cpt_code totfreq specialty
duplicates drop
rename totfreq freq 
merge m:1 cpt_code year using `cf_rvus', keep(match) nogen
drop if specialty=="Chiropractic"|specialty=="Hospice & Palliative Medicine"| ///
	specialty=="Pain Medicine"|specialty=="Pharmaceutical"| ///
	specialty=="Registered Dieteticians"|specialty=="Sleep Medicine"
	// Drop 6 specialties with less than complete (21) yearly obs
by year, sort: egen totrvus=total(rvu_value*freq)
gen spend=scalar(budgetm)/totrvus*rvu_value*freq
by year: egen cf_totrvus=total(cf_rvu*freq)
gen cf_spend=scalar(budgetm)/cf_totrvus*cf_rvu*freq
foreach var of varlist spend cf_spend {
	by specialty year, sort: egen tot`var'=total(`var')
}
keep totspend totcf_spend year specialty
duplicates drop
foreach var in spend cf_spend {
	by specialty: egen `var'=mean(tot`var')
	drop tot`var'
}
drop year
duplicates drop
gen spendb=spend/1000
gen diff_spend=cf_spend-spend
gen diff_spendb=diff_spend/1000
egen redist=total(diff_spend*(diff_spend>0))
noi disp_sumstats, var(redist) label(Across specialties)
assert round(r(dollars))==cond(`cf'==1,678,142)

// Create graphs
merge 1:1 specialty using data/crosswalks/specialty_specid_xwalk, keep(match) nogen
gen specialty_lab=string(specid)
gen labpos=3
if `cf'==1 {
	replace specialty_lab=cond(inlist(specid,44,12,32,52,63,6,14,22,35,10), ///
		specialty,"")
	replace labpos=12 if inlist(specid,6,22,52)
	replace labpos=6 if inlist(specid,14,2,44)
}
else {
	assert `cf'==2
	replace specialty_lab=cond(inlist(specid,12,6,14,22,35,52,63,32,10,15), ///
		specialty,"")
	replace labpos=6 if inlist(specid,10,22,52)
	replace labpos=12 if inlist(specid,12)
	replace labpos=3 if specialty_lab!=""&labpos==.
}
if `cf'==1 local title title(A: Equal Affiliation, color(black) size(medlarge))
else local title title(B: Proportional RUC Representation, color(black) size(medlarge))
twoway scatter diff_spend spend, ///
	mcolor(black) mlabel(specialty_lab) mlabc(black) mlabv(labpos) ///
	`title' xtitle("Spending (millions $)") ///
	ytitle("Counterfactual reallocation (millions $)") ///
	graphregion(color(white)) ylabel(,nogrid) name(spec_cf`cf', replace)
restore
}
/*
Equal Affiliation
   Across CPTs
     Millions redistributed = 1024
      Percent redistributed = 2.87
   Across BETOS
     Millions redistributed = 884
      Percent redistributed = 2.48
   Across specialties
     Millions redistributed = 678
      Percent redistributed = 1.90

Proportional RUC Representation
   Across CPTs
     Millions redistributed = 227
      Percent redistributed = 0.64
   Across BETOS
     Millions redistributed = 192
      Percent redistributed = 0.54
   Across specialties
     Millions redistributed = 142
      Percent redistributed = 0.40
*/

*** Combine graphs ***********************************************************************
// Figure 5
graph combine spec_cf1 spec_cf2, ysize(6) xsize(4) cols(1) iscale(*1.1) ///
	graphregion(color(white)) name(Figure_5, replace)
graph export "output/Figure_5.eps", as(eps) replace

// Figure A-10
graph combine betos_cf1 betos_cf2, ysize(6) xsize(4) cols(1) iscale(*1.1) ///
	graphregion(color(white)) name(Figure_A10, replace)
graph export "output/Figure_A-10.eps", as(eps) replace	

*** Figure A-11 **************************************************************************
gen_working_data, specwt spec_wt_opts(keepall) collapse
gen_aff, moments(mean) norm 
gen_aff, moments(mean) ///
	gen_memspec_opts(cf_file(data/crosswalks/ruc_cf_members.csv)) prefix(cf_)
gen ncf_aff=(cf_aff-mean_aff)/sd_aff
gen diffaff=ncf_aff-naff
qui reg naff i.ruc_yr i.mtg_num specialty_wt*
predict naff_r, resid

capture drop x1 x2 den_naff den_ncf_aff den_diffaff den_naff_r
kdensity naff, gen(x1 den_naff) nograph
kdensity ncf_aff, gen(den_ncf_aff) nograph at(x1)
kdensity naff_r, gen(x2 den_naff_r) nograph
kdensity diffaff, gen(den_diffaff) nograph at(x2)
foreach var of varlist den_naff den_ncf_aff x1 x2 {
	qui sum `var'
	scalar mean_`var'=r(mean)
}
assert round(mean_den_naff*10^6)==112255
assert round(mean_den_ncf_aff*10^6)==114750
assert round(mean_x1*10^6)==-2935455
assert round(mean_x2*10^6)==-324118
label var den_naff Actual
label var den_ncf_aff Counterfactual
label var den_naff_r Residual
label var den_diffaff Difference
label var naff Actual
label var ncf_aff Counterfactual
label var naff_r Residual
label var diffaff Difference
twoway line den_naff den_ncf_aff x1, ytitle(Density) lpattern(solid dash) ///
	xtitle(Affiliation) title(A: Counterfactual Density, color(black)) name(A, replace) ///
	graphregion(color(white)) ylabel(, nogrid) lcolor(gs4 gs8) ///
	legend(region(col(white)) size(medsmall) symxsize(*.5) colgap(*.5))
twoway line den_naff_r den_diffaff x2, ytitle(Density) lpattern(solid dash) ///
	xtitle(Affiliation) title(B: Difference Density, color(black)) name(B, replace) ///
	graphregion(color(white)) ylabel(, nogrid) lcolor(gs4 gs8) ///
	legend(region(col(white)) size(medsmall) symxsize(*.5) colgap(*.5))
qqplot naff ncf_aff, title(C: Counterfactual Q-Q Plot, color(black)) ///
	name(C, replace) msize(small) graphregion(color(white)) ylabel(, nogrid) ///
	rlopts(lcolor(black)) mcolor(gs8)
qqplot naff_r diffaff, title(D: Difference Q-Q Plot, color(black)) name(D, replace) ///
	graphregion(color(white)) ylabel(, nogrid) msize(small) mcolor(gs8) ///
	rlopts(lcolor(black))
	
graph combine A B C D, ysize(6) iscale(*.8) graphregion(color(white)) ///
	name(Figure_A11, replace)
graph export "output/Figure_A-11.eps", as(eps) replace
