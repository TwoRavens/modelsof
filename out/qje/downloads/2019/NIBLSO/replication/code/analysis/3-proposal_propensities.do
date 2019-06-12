/*****************************************************************************************
AUTHORS: David Chan and Michael Dickstein, QJE (2019), "Industry Input in Policymaking: 
Evidence from Medicare"

PURPOSE: Propensities, predicted affiliation

INPUTS:
- ${spec_linking_dir}/specialty_specid_xwalk.dta
- See .ado files for inputs indirectly used

OUTPUTS:
- Figure A-7
- Figure A-8
- Figure A-9
- cf_proposer_aff.dta

ALGORITHM (for Figure A-9):
1. Calculate probability of proposal with logit model, which considers specialty 
   identities and service volume
2. Will have dataset with each row corresponding to proposal-specialty combination
   . Identify threshold volume required to be on proposal, drop all specialties that 
     don't clear this threshold
3. Set number of draws for each proposal. 
   . If number of draws is smaller or close to number of candidate specialties or 
     combinations, may want to just systematically evaluate all potential choices.
   . Otherwise, 
     . Draw random numbers for each row. Subtract random numbers from probability in #1,
       call this x_is.
     . Choose top N_i specialties, where N_i is number of actual specialties on proposal.
       Alternative could be to bound N_i between 1 and some N_max, with default to choose
	   any x_is>0.
   . Record specialty identities and probability of particular draw
   . Check to make sure that draw hasn't been drawn before; discard if it has. If it 
     hasn't, evaluate affiliation.
*****************************************************************************************/

if "${dir}"!="" cd "${dir}"
	// Can set global macro for root directory of replication package ending with
	// "/replication". Otherwise, ensure that Stata is in the root directory.
assert regexm("`c(pwd)'","replication$")
clear all
program drop _all
adopath + ado

global min_prob=.01
global comp_combo=50
global cptchars Survey_Pre_Eval_Time Survey_Pre_Positioning_Time ///
	Survey_Pre_Service_Scrub_Dress_W Survey_Median_Pre_Service_Time ///
	Survey_Median_Intra_Time Survey_Median_Post__ZZZ_XXX_000_ ///
	Survey_Day_of_Proc__090_010_ Survey_Length_of_Hosp_Stay Survey_Median_Post_Time ///
	Survey_Immediate_Post_Time Total_RUC_Survey_Time A99204 A99211 A99212 A99213 ///
	A99214 A99215 A99231 A99232 A99233 A99238 A99239 A99291 A99292 A99296 A99297
	
*** Load data ****************************************************************************
gen_working_data, specwt spec_wt_opts(keepall) 

keep specialty obs_id ruc_yr specialty_wt cpt_code ruc_rec
rename specialty_wt med_wt
foreach type in medicare marketscan {
	if "`type'"=="medicare" local prefix med
	else local prefix mkt
	gen_util_expend, type(`type') year(ruc_yr) yearincs(-3/7) genprefix(`prefix') specexp
	gen `prefix'_revsh=ruc_rec*`prefix'freq/`prefix'specexp
	if "`type'"=="marketscan" gen mkt_wt=mktfreq/mktcptfreq
	drop *freq *specexp
}

tempfile master
save `master', replace
gen_working_data, cptfreq keepvars(${cptchars}) aff collapse
gen_var, prervu
proc_pred_vars, jackknife cptterms pos_medbene drop
keep obs_id mtgid lnxb_cptchars lnxb_survey lnxb_cptterms lnprervu prervu_miss ///
	lnxb_pos_medbene lncptfreq ruc_yr mtg_num aff
merge 1:m obs_id using `master', keep(match) nogen
save `master', replace

gen_working_data
gen_specialty
keep obs_id specialty
gen byte true_spec=1
merge 1:1 obs_id specialty using `master', keep(match using) nogen
replace true_spec=0 if true_spec==.
by obs_id, sort: egen tot_specs=total(true_spec)
save `master', replace

preserve
keep obs_id aff
duplicates drop
sum aff
// scalar mean_aff=r(mean)
// scalar sd_aff=r(sd)
scalar mean_aff=.72674351
scalar sd_aff=  .07942596
restore
merge m:1 specialty using "data/crosswalks/specialty_specid_xwalk", keep(match) nogen

*** Logit ********************************************************************************
// Additional sample selection
drop if aff==. // 11 obs_id's
drop if mkt_wt==.|lncptfreq==. // 200 obs_id's

// Further transformations
foreach var of varlist *_wt *_revsh {
	gen byte `var'_0=`var'==0
	gen ln`var'=cond(`var'_0,0,ln(`var'))
}

qui logit true_spec ln* prervu_miss *_0 i.specid i.tot_specs
predict prob, pr

*** Figure A-7 ***************************************************************************
qui sum prob
assert round(r(mean)*10^8)==2762151&round(r(sd)*10^8)==13156427
gsort obs_id -prob
by obs_id: gen rank=_n
kdensity prob if true_spec, xtitle(Proposal probability) title("") ///
	 graphregion(color(white)) ylabel(, nogrid) lcolor(gs8) note("") ///
	 name(Figure_A7, replace)
graph export output/Figure_A-7.eps, as(eps) replace

*** Figure A-8 ***************************************************************************
kdensity prob if rank==1, xtitle(Proposal probability) ///
	title(A: First Rank, color(black)) name(first, replace) note("") ///
	graphregion(color(white)) ylabel(, nogrid) lcolor(gs8)
kdensity prob if rank==2&tot_specs>=2, xtitle(Proposal probability) ///
	title(B: Second Rank, color(black)) name(second, replace) note("") ///
	graphregion(color(white)) ylabel(, nogrid) lcolor(gs8)
kdensity prob if rank==3&tot_specs>=3, xtitle(Proposal probability) ///
	title(C: Third Rank, color(black)) name(third, replace) note("") ///
	graphregion(color(white)) ylabel(, nogrid) lcolor(gs8)
kdensity prob if rank==4&tot_specs>=4, xtitle(Proposal probability) ///
	title(D: Fourth Rank, color(black)) name(fourth, replace) note("") ///
	graphregion(color(white)) ylabel(, nogrid) lcolor(gs8)
graph combine first second third fourth, ysize(6) iscale(*.9) ///
	graphregion(color(white)) name(Figure_A8, replace)
graph export output/Figure_A-8.eps, as(eps) replace

preserve
keep obs_id tot_specs
duplicates drop
tab tot_specs
assert _N==4202
restore
/*
  tot_specs |      Freq.     Percent        Cum.
------------+-----------------------------------
          1 |      2,677       63.71       63.71
          2 |        957       22.77       86.48
          3 |        264        6.28       92.77
          4 |        134        3.19       95.95
          5 |         87        2.07       98.02
          6 |         55        1.31       99.33
          7 |          8        0.19       99.52
          8 |          4        0.10       99.62
         11 |         16        0.38      100.00
------------+-----------------------------------
      Total |      4,202      100.00
*/
	  
sum prob if rank==1
sum prob if rank==2&tot_specs>=2
sum prob if rank==3&tot_specs>=3
sum prob if rank==4&tot_specs>=4
/*
. sum prob if rank==1

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
        prob |      4,202    .8030421    .1855008   .0058976    .997977

. sum prob if rank==2&tot_specs>=2

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
        prob |      1,525    .6710183    .2717277   .0025228   .9965011

. sum prob if rank==3&tot_specs>=3

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
        prob |        568    .6232799    .2628371   .0036797   .9840502

. sum prob if rank==4&tot_specs>=4

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
        prob |        304    .5169753    .2342581   .0091452    .921875
*/

*** Figure A-9 ***************************************************************************
keep if true_spec|(prob>.01&prob!=.)
keep obs_id prob true_spec specid aff mtgid specialty ruc_yr mtg_num tot_specs
sort obs_id specid
by obs_id: gen combos=comb(_N,tot_specs)
by obs_id: gen N=_N
by obs_id: gen specnum=_n
tempfile master Ndata combos1 combos1_long combos2_long combos2_short specs working
save `specs', replace

// Comprehensive set of combinations for small sets
keep obs_id combos N tot_specs
keep if combos<=${comp_combo}
duplicates drop
save `master', replace
levelsof N, local(levels1)
qui foreach N in `levels1' {
	use `master', clear
	keep if N==`N'
	local nums
	foreach num of numlist 1/`N' {
		local nums `nums' `num'
	}
	save `Ndata', replace
	levelsof tot_specs, local(levels2)
	foreach tot_specs in `levels2' {
		noi disp as text "`N' `tot_specs'" 
		use `Ndata', clear
		keep if tot_specs==`tot_specs'
		macro drop _tuple*
		if `tot_specs'>1 tuples `nums', min(`tot_specs') max(`tot_specs')
		else tuples `nums', max(`tot_specs')
		expand $_ntuples
		sort obs_id
		gen tuple=""
		foreach id of numlist 1/$_ntuples {
			by obs_id: replace tuple="${_tuple`id'}" if _n==`id'
		}
		capture append using `combos1'
		save `combos1', replace
	}
}
expand tot_specs
by obs_id tuple, sort: gen specnum=real(word(tuple,_n))
keep obs_id tuple specnum
save `combos1_long', replace

// Random set of combinations for large sets
use `specs', clear
set seed 0
keep if combos>${comp_combo}
keep obs_id specnum prob tot_specs
save `working', replace
local workingobs=_N
local counter=0
local maxcount=0
local mincount=0
local samecombos=0
local combosaved=0
qui while `workingobs'>0&(`maxcount'<${comp_combo}|`samecombos'<1) {
	noi disp as text `counter' ": " as result `workingobs' as text ", (" ///
		as result `mincount' as text ", " as result `maxcount' as text "), " ///
		as result `combosaved' as text ", " as result `samecombos'
	gen rand=runiform()
	gen rand_index=prob-rand
	sort obs_id rand_index
	by obs_id: keep if _n<=tot_specs
	sort obs_id specnum
	by obs_id: gen tuple=string(specnum) if _n==1
	by obs_id: replace tuple=tuple[_n-1]+" "+string(specnum)
	by obs_id: replace tuple=tuple[_N]
	keep obs_id specnum tuple
	if `counter' {
		merge m:1 obs_id tuple using `combos2_short', keep(master) nogen
		append using `combos2_long'
	}
	capture drop combocount
	save `combos2_long', replace
	keep obs_id tuple
	duplicates drop
	by obs_id, sort: gen combocount=_N
	assert combocount<=${comp_combo}
	sum combocount
	local maxcount=r(max)
	local mincount=r(min)
	if `combosaved'==_N&`maxcount'==${comp_combo} local samecombos=`samecombos'+1
	else local samecombos=0
	local combosaved=_N
	save `combos2_short', replace
	if `maxcount'==$comp_combo {
		keep if combocount==${comp_combo}
		keep obs_id
		duplicates drop
		merge 1:m obs_id using `working', keep(using) nogen
		save `working', replace
	}
	else use `working', clear
	local workingobs=_N
	local counter=`counter'+1
}
use `combos2_long', clear
append using `combos1_long'
merge m:1 obs_id specnum using `specs', keep(match) assert(match using) nogen
isid obs_id tuple specnum
sort obs_id tuple specid
by obs_id tuple: gen tuple_specid=string(specid) if _n==1
by obs_id tuple: replace tuple_specid=tuple_specid[_n-1]+" "+string(specid)
by obs_id tuple: replace tuple_specid=tuple_specid[_N]
drop tuple
rename tuple_specid tuple

gen_aff, long prefix(cf_) affsource(1) affvar(1) moments(mean) useid(obs_id tuple)
gen lnprob=ln(prob)
by obs_id tuple, sort: egen llt=total(ln(prob))
keep obs_id tuple llt mtgid tot_specs N combos aff cf_aff
duplicates drop
isid obs_id tuple
by obs_id: egen totwt=total(exp(llt))
by obs_id: gen totdraws=_N
gen wt=exp(llt)/totwt
gen cf_naff=(cf_aff-mean_aff)/sd_aff
gen naff=(aff-mean_aff)/sd_aff
gen diff_naff=(aff-cf_aff)/sd_aff
save data/intermediate/cf_proposer_aff, replace

// Plot difference between actual and potential affiliations
sum diff_naff if diff_naff>=-1&diff_naff<=1 [aw=wt]
assert round(r(mean)*10^7)==-163935&round(r(sd)*10^7)==2432093
/*
    Variable |     Obs      Weight        Mean   Std. Dev.       Min        Max
-------------+-----------------------------------------------------------------
   diff_naff |  51,663  4017.25981   -.0163935   .2432093  -.9998803   .9992334
*/
scalar xline=r(mean)
kdensity diff_naff if diff_naff>=-1&diff_naff<=1&diff_naff!=0, ///
	graphregion(color(white)) ylabel(, nogrid) lcolor(gs8) name(Figure_A9, replace) ///
	xtitle(Pseudo-affiliation difference) note("") title("") xline(`=xline', lcolor(gs8))
graph export output/Figure_A-9.eps, as(eps) replace	
