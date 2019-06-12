// Seasonal sleep-wage models
//
// Jeff Shrader & Matthew Gibson
// Creation date: 2014-12-03
// Time-stamp: "2017-09-22 18:59:39 jgs"


// Preliminaries
clear

local work "/DIRECTORY"

timer clear 1
timer on 1
graph set window fontface "CMU Serif"
set scheme jleanc


/////////////////////////////////
// Locals for program flow
/////////////////////////////////
// Controls whether tables are produced
local output = 1
local log = 1

// Control whether sections of estimates are run
local summary_stats = 1
local linear = 1
local linear_robust = 1
local other_time = 1
local nonlinear = 1
local seasonal = 1
local part_time = 1

if `log' == 1 {
   capture log close
   log using "`work'/logs/ATUS_models_season.log", replace
}

/////////////////////////////////
// Data                        //
/////////////////////////////////
use "`work'/data/atus_proc.dta", clear


// Subsetting to sleep levels that don't obviously reflect disease
drop if sleep <= 2*7
// Prime age
drop if age >= 65
drop if age <=17

capture rename date0 date
gen weekend = (tudiaryday == 1 | tudiaryday == 7)
capture drop age_cut
capture drop age_cut_*
gen age_cut = 1 if inrange(age, 0, 24)
replace age_cut = 2 if inrange(age, 25, 34)
replace age_cut = 3 if inrange(age, 35, 44)
replace age_cut = 4 if inrange(age, 45, 54)
replace age_cut = 5 if inrange(age, 55, 150)
tab age_cut, gen(age_cut_)


/////////////////////////////////
// Locals for sets of controls
/////////////////////////////////
local individual = "race_1 race_2 race_3 race_4 age age2"
local gender = "gender"
local time = "holiday tudiaryday_1 tudiaryday_2 tudiaryday_3 tudiaryday_4 tudiaryday_5 tudiaryday_6 tudiaryday_7 year_1 year_2 year_3 year_4 year_5 year_6 year_7 year_8 year_9 year_10 year_11"
local ind_occ = "primary_occupation_1 primary_occupation_2 primary_occupation_3 primary_occupation_4 primary_occupation_5 primary_occupation_6 primary_occupation_7 primary_occupation_8 primary_occupation_9 primary_occupation_10 primary_occupation_11 primary_occupation_12 primary_occupation_13 primary_occupation_14 primary_occupation_15 primary_occupation_16 primary_occupation_17 primary_occupation_18 primary_occupation_19 primary_occupation_20 primary_occupation_21 primary_occupation_22 primary_occupation_23" 
local base_control = "`individual' `gender' `ind_occ' `time'"

gen other_time_exnaps = other_time - nap_sst1
gen quarter = quarter(date)
gen yq = yq(year, quarter)
quietly: tab yq, gen(yq_)
encode time_zone, gen(tz)
gen sunset_time_season = sunset_time - sunset_time_avg
quietly: tab trdpftpt, gen(full_time_)

local lhs "ln_wkly_wage" 
label var `lhs' "ln(earnings)"
label var sleep "Sleep"
label var ln_wage "ln(wage)"
quietly: su sleep if `lhs' != . & trdpftpt ==1
local avg_sleep = r(mean)
local iv "sunset_time_season" 
label var sunset_time_season "Daily sunset time"
encode fips, gen(fips_id)
xtset fips_id

// We have some singleton groups, so we can't estimate FEs on them
** To detect singletons, use:
capture drop count
quietly: reg `lhs' `iv' sleep `base_control' if `lhs'!= .
bysort fips_id: gen count = _N if e(sample)
list id if count == 1
drop if count == 1
drop count

//////////////////////////
// Summary stats        //
//////////////////////////
if `summary_stats' == 1 {
   preserve
   replace wage = . if wage <= 0
   capture gen weekend = (tudiaryday == 1 | tudiaryday == 7)
   gen educa_2 = (educ_1 == 1 | educ_2 == 1)
   gen educa_4 = (peeduca == 43)
   gen married = (pemaritl != 6)
   label var sleep "Sleep (hour/week)"
   label var nap_sst1 "Naps (hour/week)"
   label var wkly_wage "Weekly earnings (\\$/week)"
   label var wage "Hourly wage (\\$/week)"
   label var work "Work (hour/week)"
   label var educa_2 "HS or less (0/1)"
   label var married "Ever married (0/1)"
   label var trchildnum "Number of children"
   label var sunset_time "Sunset time (24 hr)"
   label var gender "Female (0/1)"
   label var age "Age (years)"
   label var race_1 "Race, white (0/1)"
   label var race_2 "Race, black (0/1)"
   label var holiday "Holiday (0/1)"
   label var weekend "Weekend (0/1)"
   label var educ_3 "Some college (0/1)"
   label var educa_4 "College (0/1)"
   

   capture drop SSTquartile
   summarize sunset_time, de
   gen SSTquartile = .
   replace SSTquartile = 1 if inrange(sunset_time, -24, r(p50))
   replace SSTquartile = 2 if inrange(sunset_time, r(p50), 24)
   
   local min_group = 1
   quietly: su SSTquartile
   local max_group = r(max)
   label def SSTquartile 1 "Early sunset" 2 "Late sunset", modify

   eststo drop *
   ereturn clear
   ettests wkly_wage wage sleep sunset_time work gender age race_1 race_2 ///
          weekend educa_2 educa_4 trchildnum   ///
          if !missing(ln_wkly_wage) & (SSTquartile == `min_group' ///
          | SSTquartile == `max_group') & trdpftpt ==1, by(SSTquartile) casewise

   esttab using "`work'/tables/ATUS_summary_bySST.tex", ///
          cells("mu_1(fmt(a2) label(Mean)) mu_2(fmt(a2) label(Mean)) d(star pvalue(p) label(Diff.)) N(label(Total obs.))" "sd_1(par fmt(a2) label((SD))) sd_2(par fmt(a2) label((SD))) se(par fmt(a2) label((SE)))") ///
          star(* 0.10 ** 0.05 *** 0.01) ///
          stats(N, label("Observations") fmt(%9.0gc)) ///
          compress nogaps fragment label tex replace not noobs nomtitles nonum
   ** You will still need to delimit the $ signs, and add \hline after cell labels, but
   ** pretty close to a complete solution.
   restore
}

////////////////////////////////////////////////////////////////
// Estimation
// Model 1: linear
////////////////////////////////////////////////////////////////
if `linear' == 1 {
   label var sunset_time_season "Daily sunset"
   label var ln_wage "ln(wage)"
   // Baseline model //
   eststo drop *
   // First stage
   xtivreg2 sleep `iv' `base_control'  if `lhs' != . & trdpftpt ==1, cluster(fips_id) fe
   eststo fs
   xtivreg2 sleep `iv' `base_control'  if ln_wage != . & trdpftpt ==1, cluster(fips_id) fe
   eststo fsw
   // Reduced form
   xtivreg2 `lhs' `iv' `base_control' if `lhs' != . & trdpftpt ==1, cluster(fips_id) fe
   eststo rf
   xtivreg2 ln_wage `iv' `base_control' if ln_wage != . & trdpftpt ==1, cluster(fips_id) fe
   eststo rfw
   // Calculating elasticity
   quietly: xtivreg2 ln_wkly_wage (ln_sleep = `iv') `base_control'  if `lhs' != . & trdpftpt ==1, cluster(fips) fe
   local elasticity = _b[ln_sleep]
   local elasticity : display %3.2f `elasticity'   
   quietly: xtivreg2 ln_wage (ln_sleep = `iv') `base_control'  if ln_wage != . & trdpftpt ==1, cluster(fips) fe
   local elasticity = _b[ln_sleep]
   local elasticity : display %3.2f `elasticity'   
   // Main spec
   xtivreg2 `lhs' (sleep = `iv') `base_control'  if `lhs' != . & trdpftpt ==1, cluster(fips) fe
   local beta_sleep = _b[sleep]
   local f_stat = round(e(cdf), 0.01)
   local f_stat : display %3.2f `f_stat'
   estadd local f_stat `f_stat', replace
   estadd local elasticity `elasticity', replace
   eststo iv


   if `output' == 1 {
      * First, the first stage and reduced form
      esttab fs rf fsw rfw using "`work'/tables/ATUS_season_fsrf.tex", ///
             indicate("Individual controls=`individual'" ///
             "Time controls=`time'"  "Location FEs=gender") ///
             drop(`ind_occ') star(* 0.10 ** 0.05 *** 0.01) stats(N r2_a, label("Observations" "Adjusted $ R^2$") fmt(%9.0gc a2)) ///
             se(a2) b(a2) noconstant nogaps label tex noobs ///
             fragment replace  nonumbers

      * Second stage, for putting together with cross sectional results
      esttab iv using "`work'/tables/ATUS_season_iv.tex", ///
             scalars("f_stat F-stat on IV" "elasticity Elasticity") ///
             indicate("Individual controls=`individual'" ///
             "Time controls=`time'"  "Location FEs=gender") ///
             drop(`ind_occ') star(* 0.10 ** 0.05 *** 0.01) stats(N r2_a, label("Observations" "Adjusted $ R^2$") fmt(%9.0gc a2)) ///
             se(a2) b(a2) noconstant nogaps label tex ///
             fragment replace nonumbers
      
      * All results with controls, for reference
      eststo ols: xtivreg2 `lhs' sleep `base_control'  if `lhs' != . & trdpftpt ==1, cluster(fips_id) fe
      esttab fs rf iv ols using "`work'/tables/ATUS_season.tex", ///
        drop( ) ///
        star(* 0.10 ** 0.05 *** 0.01) stats(N r2_a, label("Observations" "Adjusted $ R^2$") fmt(%9.0gc a2)) ///
        se noconstant nonumbers nogaps label tex fragment replace  b(a2) se(a2)
   }


   // First-stage scatter plot
   binscatter sleep `iv' if e(sample), controls(`base_control') ytitle("Residualized sleep") xtitle("Residualized daily sunset time") absorb(fips_id)
   if `output' == 1 {
      graph export "`work'/graphs/1st_stage_scatter_season.pdf", as(pdf) replace
   }
   binscatter sleep `iv' if e(sample), ytitle("Sleep") xtitle("Daily sunset time")
   if `output' == 1 {
      graph export "`work'/graphs/1st_stage_scatter_season_nocontrols.pdf", as(pdf) replace
   }
   capture: window manage close graph _all

   // Reduced form scatter plot
   binscatter `lhs' `iv' if e(sample), controls(`base_control') ytitle("Residualized log earnings") xtitle("Residualized daily sunset time") absorb(fips_id)
   if `output' == 1 {
      graph export "`work'/graphs/rf_scatter_season.pdf", as(pdf) replace
   }
   binscatter `lhs' `iv' if e(sample), ytitle("Log earnings") xtitle("Daily sunset time")
   if `output' == 1 {
      graph export "`work'/graphs/rf_scatter_season_nocontrols.pdf", as(pdf) replace
   }
   capture: window manage close graph _all


   // Calculating implied annual change in income if no work hour shift
   // Assumes working 50 weeks, since our data has mostly missing values in teernwkp.
   // First, how much variation is actually induced in sleep by our instrument?
   xtreg sleep `iv' `base_control' if `lhs' != . & trdpftpt ==1, cluster(fips_id) fe
   preserve
   foreach i of varlist `base_control' {
      quietly: replace `i' = 0
   }
   predict sleep_hat if e(sample), xb
   su sleep_hat
   di r(max) - r(min)
   restore

   // Delta is the hours changed per day, so 1 each day is 1,
   // 5 hours over the week is 5/7
   // 20 minutes per day is 2 hours per week or 2/7
   local delta = (2/7) 
   quietly: su tehruslt  if e(sample) & tehruslt > 0
   local avg_hours = r(mean)
   gen hourly_wk_wage = wkly_wage/tehruslt
   su hourly_wk_wage  if e(sample)
   local avg_wage = r(mean)
   local eps_w = 0
   local wks = 50
   local beta_sleep = `beta_sleep'*7
   di "Annual change in income implied by `delta' hour extra sleep per night, holding work constant"
   di `wks'*(`avg_wage'*(1 + (exp(`beta_sleep')-1)*`delta')*(`avg_hours' - 7*`delta'*`eps_w') - `avg_wage'*`avg_hours')
   di "Implied value of leisure:" 
   di (`wks'*(`avg_wage'*(1 + (exp(`beta_sleep')-1)*`delta')*(`avg_hours' - 7*`delta'*`eps_w') - `avg_wage'*`avg_hours'))/(`delta'*`wks'*7)
   *pause


   // Now with more data implied hour shifting
   xtivreg2 work (sleep = `iv') , fe
   local eps_w = -1*_b[sleep]
   di "Annual change in income implied by `delta' hour extra sleep per night, allowing work to vary"
   di `wks'*(`avg_wage'*(1 + (exp(`beta_sleep')-1)*`delta')*(`avg_hours' - 7*`delta'*`eps_w') - `avg_wage'*`avg_hours')

   local eps_w = 1
   di "Annual change in income implied by `delta' hour extra sleep per night, taking all time out of work"
   di `wks'*(`avg_wage'*(1 + (exp(`beta_sleep')-1)*`delta')*(`avg_hours' - 7*`delta'*`eps_w') - `avg_wage'*`avg_hours')

   // Break even point will be
   di "Break even work response"
   di (`avg_hours'/(1 + (exp(`beta_sleep')-1)*`delta')- `avg_hours')*(-7*`delta')^(-1)
   di "So, if a workers trades this amount of work hours for sleep on the margin, they will break even."



} // End linear conditional 

////////////////////////////////////////////////////////////////
// Robustness for Model 1
////////////////////////////////////////////////////////////////
if `linear_robust' == 1 {
   // Hourly wage
   label var ln_wage "ln(wage)" 
   eststo drop *
   eststo fs_w: xtivreg2 sleep `iv' `base_control'  if ln_wage != . & trdpftpt ==1, cluster(fips_id) fe
   eststo rf_w: xtivreg2 ln_wage `iv' `base_control'  if ln_wage != . & trdpftpt ==1, cluster(fips_id) fe
   eststo: xtivreg2 ln_wage (sleep = `iv') `base_control'  if ln_wage != . & trdpftpt ==1, cluster(fips) fe 
 
   // Salaried only
   eststo fs_s: xtivreg2 sleep `iv' `base_control'  if ln_wage == . & trdpftpt ==1, cluster(fips_id) fe
   eststo rf_s: xtivreg2 `lhs' `iv' `base_control'  if ln_wage == . & trdpftpt ==1, cluster(fips_id) fe
   eststo: xtivreg2 `lhs' (sleep = `iv') `base_control'  if ln_wage == . & trdpftpt ==1, cluster(fips) fe 

   // Earnings for hourly workers
   eststo fs_we: xtivreg2 sleep `iv' `base_control'  if ln_wage != . & trdpftpt ==1, cluster(fips_id) fe
   eststo rf_we: xtivreg2 `lhs' `iv' `base_control'  if ln_wage != . & trdpftpt ==1, cluster(fips_id) fe
   eststo: xtivreg2 `lhs' (sleep = `iv') `base_control'  if ln_wage != . & trdpftpt ==1, cluster(fips) fe 

   // Output a table with hourly wage and non-hourly wage people
   if `output' == 1 {
      esttab rf_w rf_s rf_we using "`work'/tables/ATUS_season_flex.tex", ///
        star(* 0.10 ** 0.05 *** 0.01) stats(N, label("Observations") fmt(%9.0gc)) ///
        drop(`base_control'  ) ///
        se(a2) b(a2) noconstant nonumbers nogaps  label tex fragment replace nomtitles nolines 
   }

   // Union vs. non-union and government vs. non-government
   gen union = (peernlab == 1)
   gen ss_union = sunset_time_season*union
   gen govt = (prcowpg == 2)
   gen ss_gov = sunset_time_season*govt
   gen ss  =sunset_time_season
   label var ss "$\beta_1\$: Sunset time"
   label var union "$\beta_2\$: Union member"
   label var govt "$\beta_3\$: Government employee"
   label var ss_union "$\beta_4\$: Union $\times$ sunset"
   label var ss_gov "$\beta_5\$: Government $\times$ sunset"
   
   eststo drop *
   eststo rf_u_g: xtivreg2 `lhs' union govt ss ss_union ss_gov `base_control' if `lhs' != . & trdpftpt ==1, cluster(fips_id) fe
   estadd scalar b_union = _b[ss] + _b[ss_union]
   test ss + ss_union == 0
   estadd scalar test_union = r(p)
   estadd scalar b_gov = _b[ss] + _b[ss_gov]
   test ss + ss_gov == 0
   estadd scalar test_gov = r(p)
   * The stats are not all displaying, so they need to be placed manually
   if `output' == 1 {
      esttab rf_u_g using "`work'/tables/ATUS_season_flex_union_govt.tex", ///
             star(* 0.10 ** 0.05 *** 0.01) ///
             stats(N b_union test_union b_gov test_gov, label("Observations" "$\beta_1+\beta_4$" "P-value for test $\beta_1+\beta_4=0$" "$\beta_1+\beta_5$" "P-value for test $\beta_1+\beta_5=0$") fmt(%9.0gc %9.4gc %9.3gc %9.4gc %9.3gc)) ///
             drop(`base_control'  ) ///
             se(a2) b(a2) noconstant nonumbers nogaps label tex fragment ///
             replace nomtitles nolines
   }

   // People reporting overtime or comission
   xtivreg2 `lhs' `iv' `base_control' if teernuot != 1 & `lhs' != . & trdpftpt ==1, cluster(fips_id) fe

   
   // No Occupation
   eststo drop *
   eststo: xtivreg2 sleep `iv' `individual' `gender' `time'  if `lhs' != . & trdpftpt ==1, cluster(fips_id) fe
   eststo rf: xtivreg2 `lhs' `iv' `individual' `gender' `time'  if `lhs' != . & trdpftpt ==1, cluster(fips_id) fe
   eststo: xtivreg2 `lhs' (sleep = `iv') `individual' `time'  if `lhs' != . & trdpftpt ==1, cluster(fips) fe 

  if `output' == 1 { 
      esttab rf using "`work'/tables/ATUS_season_robust_noocc.tex", ///
        star(* 0.10 ** 0.05 *** 0.01)  ///
        drop(`individual' `gender' `time'  ) ///
        se(a2) b(a2) noconstant nonumbers noobs nogaps  label tex begin(" & ") fragment wide replace nomtitles nolines
   }

   // By occupation
   eststo drop *
   forvalues i = 1/22 {
      tab trdtocc1 if trdtocc1 == `i'
      quietly: xtivreg2 `lhs' (sleep = `iv') `individual' `time'  if `lhs' != . & trdpftpt ==1 & trdtocc1 == `i', cluster(fips) fe
      di _b[sleep]
      di _se[sleep]
   }

   // Just FEs
   eststo drop *
   eststo: xtivreg2 sleep `iv'  if `lhs' != . & trdpftpt ==1, cluster(fips_id) fe
   eststo rf: xtivreg2 `lhs' `iv'  if `lhs' != . & trdpftpt ==1, cluster(fips_id) fe
   eststo: xtivreg2 `lhs' (sleep = `iv') if `lhs' != . & trdpftpt ==1, cluster(fips) fe 
  if `output' == 1 { 
      esttab rf using "`work'/tables/ATUS_season_robust_justfe.tex", ///
        star(* 0.10 ** 0.05 *** 0.01)  ///
        drop( ) ///
        se(a2) b(a2) noconstant nonumbers noobs nogaps  label tex begin(" & ") fragment wide replace nomtitles nolines
   }
   
   // Just FEs and time stuff
   eststo drop *
   eststo: xtivreg2 sleep `iv' `time'  if `lhs' != . & trdpftpt ==1, cluster(fips_id) fe
   eststo rf: xtivreg2 `lhs' `iv' `time'  if `lhs' != . & trdpftpt ==1, cluster(fips_id) fe
   eststo: xtivreg2 `lhs' (sleep = `iv') `time'  if `lhs' != . & trdpftpt ==1, cluster(fips) fe 
  if `output' == 1 { 
      esttab rf using "`work'/tables/ATUS_season_robust_fetime.tex", ///
        star(* 0.10 ** 0.05 *** 0.01) ///
        drop(`time'   ) ///
        se(a2) b(a2) noconstant nonumbers noobs nogaps  label tex begin(" & ") fragment wide replace nomtitles nolines
   }

   // No controls what-so-ever
   eststo drop *
   eststo: reg sleep `iv'  if `lhs' != . & trdpftpt ==1, cluster(fips_id) 
   eststo rf: reg `lhs' `iv'  if `lhs' != . & trdpftpt ==1, cluster(fips_id) 
   eststo: ivreg2 `lhs' (sleep = `iv') if `lhs' != . & trdpftpt ==1, cluster(fips)
  if `output' == 1 { 
      esttab rf using "`work'/tables/ATUS_season_robust_nocontrol.tex", ///
        star(* 0.10 ** 0.05 *** 0.01) ///
        drop(_cons) ///
        se(a2) b(a2) noconstant nonumbers noobs nogaps  label tex begin(" & ") fragment wide replace nomtitles nolines
   }
   

   // Just time stuff
   eststo drop *
   eststo: reg sleep `iv' `time'  if `lhs' != . & trdpftpt ==1, cluster(fips_id) 
   eststo rf: reg `lhs' `iv' `time'  if `lhs' != . & trdpftpt ==1, cluster(fips_id) 
   eststo: ivreg2 `lhs' (sleep = `iv') `time'  if `lhs' != . & trdpftpt ==1, cluster(fips) 
  if `output' == 1 { 
      esttab rf using "`work'/tables/ATUS_season_robust_justtime.tex", ///
        star(* 0.10 ** 0.05 *** 0.01) ///
        drop(`time'  _cons ) ///
        se(a2) b(a2) noconstant nonumbers noobs nogaps  label tex begin(" & ") fragment wide replace nomtitles nolines
   }


   // Leave out one time zone
   
   foreach i in "e" "c" "m" "p" {
      eststo drop *
      eststo: xtivreg2 sleep `iv' `base_control'  if `lhs' != . & trdpftpt ==1 & time_zone != "`i'" & time_zone != upper("`i'"), cluster(fips_id) fe
      eststo rf: xtivreg2 `lhs' `iv' `base_control'  if `lhs' != . & trdpftpt ==1 & time_zone != "`i'" & time_zone != upper("`i'"), cluster(fips_id) fe
      eststo: xtivreg2 `lhs' (sleep = `iv') `base_control'  if `lhs' != . & trdpftpt ==1 & time_zone != "`i'" & time_zone != upper("`i'"), cluster(fips) fe 
     if `output' == 1 { 
         esttab rf using "`work'/tables/ATUS_season_robust_noTZ`i'.tex", ///
           star(* 0.10 ** 0.05 *** 0.01) ///  
           drop( `base_control'  ) ///
           se(a2) b(a2) noconstant nonumbers noobs nogaps  label tex begin(" & ") fragment wide replace nomtitles nolines
      }
   }

   // Just with one time zone
   foreach i in "e" "c" "m" "p" {
      eststo drop *
      eststo: xtivreg2 sleep `iv' `base_control'  if `lhs' != . & trdpftpt ==1 & (time_zone == "`i'" | time_zone == upper("`i'")), cluster(fips_id) fe
      eststo rf: xtivreg2 `lhs' `iv' `base_control'  if `lhs' != . & trdpftpt ==1 & (time_zone == "`i'" | time_zone == upper("`i'")), cluster(fips_id) fe
      eststo: xtivreg2 `lhs' (sleep = `iv') `base_control'  if `lhs' != . & trdpftpt ==1 & (time_zone == "`i'" | time_zone == upper("`i'")), cluster(fips) fe 
     if `output' == 1 { 
         esttab rf using "`work'/tables/ATUS_season_robust_justTZ`i'.tex", ///
           star(* 0.10 ** 0.05 *** 0.01) ///  
           drop( `base_control'  ) ///
           se(a2) b(a2) noconstant nonumbers noobs nogaps  label tex begin(" & ") fragment wide replace nomtitles nolines
      }
   }

   // With controls for last CPS earnings
   replace prernwa = . if prernwa == -1
   eststo: xtivreg2 sleep `iv' prernwa `base_control'  if `lhs' != . & trdpftpt ==1, cluster(fips_id) fe
   eststo rf: xtivreg2 `lhs' `iv' prernwa `base_control'  if `lhs' != . & trdpftpt ==1, cluster(fips_id) fe
   eststo: xtivreg2 `lhs' (sleep = `iv') prernwa `base_control'  if `lhs' != . & trdpftpt ==1, cluster(fips) fe 
   if `output' == 1 { 
      esttab rf using "`work'/tables/ATUS_season_robust_cpsearn.tex", ///
      star(* 0.10 ** 0.05 *** 0.01) ///  
      drop( `base_control' prernwa) ///
      se(a2) b(a2) noconstant nonumbers noobs nogaps  label tex begin(" & ") fragment wide replace nomtitles nolines
   }


   // Weekend weighting
   capture gen weekend_weight = 1
   replace weekend_weight = 4/7 if weekend == 1
   eststo: xtivreg2 sleep `iv' `base_control' [aweight=weekend_weight]  if `lhs' != . & trdpftpt ==1, cluster(fips_id) fe
   eststo rf: xtivreg2 `lhs' `iv' `base_control' [aweight=weekend_weight] if `lhs' != . & trdpftpt ==1, cluster(fips_id) fe
   eststo: xtivreg2 `lhs' (sleep = `iv') `base_control' [aweight=weekend_weight] if `lhs' != . & trdpftpt ==1, cluster(fips) fe 
   if `output' == 1 { 
      esttab rf using "`work'/tables/ATUS_season_robust_weekendweight.tex", ///
      star(* 0.10 ** 0.05 *** 0.01) ///  
      drop( `base_control') ///
      se(a2) b(a2) noconstant nonumbers noobs nogaps  label tex begin(" & ") fragment wide replace nomtitles nolines
   }
   
   // Drop Boston, NY, Chicago
   eststo drop *
   eststo: xtivreg2 sleep `iv' `base_control'  if `lhs' != . & trdpftpt ==1 & fips != "17000" & fips != "25000" & fips != "36005" & fips != "36047" & fips != "36061" & fips != "36081" & fips != "36085", cluster(fips_id) fe
   eststo rf: xtivreg2 `lhs' `iv' `base_control'  if `lhs' != . & trdpftpt ==1 & fips != "17000" & fips != "25000" & fips != "36005" & fips != "36047" & fips != "36061" & fips != "36081" & fips != "36085", cluster(fips_id) fe
   eststo: xtivreg2 `lhs' (sleep = `iv') `base_control'  if `lhs' != . & trdpftpt ==1 & fips != "17000" & fips != "25000" & fips != "36005" & fips != "36047" & fips != "36061" & fips != "36081" & fips != "36085", cluster(fips) fe 
  if `output' == 1 { 
      esttab rf using "`work'/tables/ATUS_season_robust_noNyChiBos.tex", ///
        star(* 0.10 ** 0.05 *** 0.01) ///  
        drop( `base_control'  ) ///
        se(a2) b(a2) noconstant nonumbers noobs nogaps  label tex begin(" & ") fragment wide replace nomtitles nolines
   }

   // Drop EST, PST, and Chicago
   eststo drop *
   eststo: xtivreg2 sleep `iv' `base_control'  if `lhs' != . & trdpftpt ==1 & time_zone != "E" & time_zone != "P" & time_zone != "e" & fips != "17000" & fips != "25000" & fips != "36005" & fips != "36047" & fips != "36061" & fips != "36081" & fips != "36085", cluster(fips_id) fe
   eststo rf: xtivreg2 `lhs' `iv' `base_control'  if `lhs' != . & trdpftpt ==1 & time_zone != "E" & time_zone != "P" & time_zone != "e" & fips != "17000" & fips != "25000" & fips != "36005" & fips != "36047" & fips != "36061" & fips != "36081" & fips != "36085", cluster(fips_id) fe
   eststo: xtivreg2 `lhs' (sleep = `iv') `base_control'  if `lhs' != . & trdpftpt ==1 & time_zone != "E" & time_zone != "P" & time_zone != "e" & fips != "17000" & fips != "25000" & fips != "36005" & fips != "36047" & fips != "36061" & fips != "36081" & fips != "36085", cluster(fips) fe 
  if `output' == 1 { 
      esttab rf using "`work'/tables/ATUS_season_robust_noEstPstChi.tex", ///
        star(* 0.10 ** 0.05 *** 0.01) ///  
        drop( `base_control'  ) ///
        se(a2) b(a2) noconstant nonumbers noobs nogaps  label tex begin(" & ") fragment wide replace nomtitles nolines
   }

   // Drop EST, PST, and Illinois
   eststo drop *
   eststo: xtivreg2 sleep `iv' `base_control'  if `lhs' != . & trdpftpt ==1 & time_zone != "E" & time_zone != "P" & time_zone != "e" & fips != "17000" & fips != "25000" & fips != "36005" & fips != "36047" & fips != "36061" & fips != "36081" & fips != "36085", cluster(fips_id) fe
   eststo rf: xtivreg2 `lhs' `iv' `base_control'  if `lhs' != . & trdpftpt ==1& time_zone != "E" & time_zone != "P" & time_zone != "e" & fips != "17000" & fips != "25000" & fips != "36005" & fips != "36047" & fips != "36061" & fips != "36081" & fips != "36085", cluster(fips_id) fe
   eststo: xtivreg2 `lhs' (sleep = `iv') `base_control'  if `lhs' != . & trdpftpt ==1 & time_zone != "E" & time_zone != "P" & time_zone != "e" & fips != "17000" & fips != "25000" & fips != "36005" & fips != "36047" & fips != "36061" & fips != "36081" & fips != "36085", cluster(fips) fe 
  if `output' == 1 { 
      esttab rf using "`work'/tables/ATUS_season_robust_noEstPstIl.tex", ///
        star(* 0.10 ** 0.05 *** 0.01) ///  
        drop( `base_control'  ) ///
        se(a2) b(a2) noconstant nonumbers noobs nogaps  label tex begin(" & ") fragment wide replace nomtitles nolines
   }

   // Usual hours worked
   eststo drop *
   eststo: xtivreg2 sleep `iv' `base_control' tehruslt  if `lhs' != . & trdpftpt ==1, cluster(fips_id) fe
   eststo rf: xtivreg2 `lhs' `iv' `base_control' tehruslt  if `lhs' != . & trdpftpt ==1, cluster(fips_id) fe
   eststo: xtivreg2 `lhs' (sleep = `iv') `base_control' tehruslt  if `lhs' != . & trdpftpt ==1, cluster(fips) fe 
  if `output' == 1 { 
      esttab rf using "`work'/tables/ATUS_season_robust_usualhours.tex", ///
        star(* 0.10 ** 0.05 *** 0.01) ///  
        drop( `base_control' tehruslt  ) ///
        se(a2) b(a2) noconstant nonumbers noobs nogaps  label tex begin(" & ") fragment wide replace nomtitles nolines
   }
   
   // Usual hours worked quadratic -- this is what Hamermesh says satisfies Borjas
   eststo drop *
   gen tehruslt2 = tehruslt^2
   eststo: xtivreg2 sleep `iv' `base_control' tehruslt tehruslt2  if `lhs' != . & trdpftpt ==1, cluster(fips_id) fe
   eststo rf: xtivreg2 `lhs' `iv' `base_control' tehruslt tehruslt2  if `lhs' != . & trdpftpt ==1, cluster(fips_id) fe
   eststo: xtivreg2 `lhs' (sleep = `iv') `base_control' tehruslt tehruslt2  if `lhs' != . & trdpftpt ==1, cluster(fips) fe 
  if `output' == 1 { 
      esttab rf using "`work'/tables/ATUS_season_robust_usualhoursquad.tex", ///
        star(* 0.10 ** 0.05 *** 0.01) ///  
        drop( `base_control' tehruslt*  ) ///
        se(a2) b(a2) noconstant nonumbers noobs nogaps  label tex begin(" & ") fragment wide replace nomtitles nolines
   }

   // All sleep (ATUS base definition)
   label var sleep_base "Sleep and naps"
   eststo drop *
   eststo fs: xtivreg2 sleep_base `iv' `base_control'  if `lhs' != . & trdpftpt ==1, cluster(fips_id) fe
   eststo rf: xtivreg2 `lhs' `iv' `base_control'  if `lhs' != . & trdpftpt ==1, cluster(fips_id) fe
   eststo ts: xtivreg2 `lhs' (sleep_base = `iv') `base_control'  if `lhs' != . & trdpftpt ==1, cluster(fips) fe 
  if `output' == 1 { 
      esttab fs rf ts using "`work'/tables/ATUS_season_robust_sleepbase.tex", ///
        star(* 0.10 ** 0.05 *** 0.01) ///  
        drop( `base_control'  ) ///
        se(a2) b(a2) noconstant nonumbers nogaps  label tex  fragment replace nomtitles nolines
   }

   // Time trend
   eststo drop *
   capture gen date2 = date*date
   capture gen date3 = date2*date
   capture gen date4 = date3*date
   capture gen date5 = date4*date
   capture gen date6 = date5*date
   eststo: xtivreg2 sleep `iv' `base_control' date date2 date3  if `lhs' != . & trdpftpt ==1, cluster(fips_id) fe
   eststo rf: xtivreg2 `lhs' `iv' `base_control' date date2 date3  if `lhs' != . & trdpftpt ==1, cluster(fips_id) fe
   eststo: xtivreg2 `lhs' (sleep = `iv') `base_control' date date2 date3  if `lhs' != . & trdpftpt ==1, cluster(fips) fe 
  if `output' == 1 { 
      esttab rf using "`work'/tables/ATUS_season_robust_time.tex", ///
        star(* 0.10 ** 0.05 *** 0.01) ///  
        drop( `base_control' date date2 date3) ///
        se(a2) b(a2) noconstant nonumbers noobs nogaps  label tex begin(" & ") fragment wide replace nomtitles nolines
   }


   // More controls: race and kids
   eststo drop *
   foreach i of varlist race_* {
      gen hisp_`i' = hispanic*`i'
   }
   quietly: tab pemaritl, gen(married_)
   eststo: xtivreg2 sleep `iv' `base_control' hisp_race_* married_* trchildnum  if `lhs' != . & trdpftpt ==1, cluster(fips_id) fe
   eststo rf: xtivreg2 `lhs' `iv' `base_control' hisp_race_* married_* trchildnum  if `lhs' != . & trdpftpt ==1, cluster(fips_id) fe
   eststo: xtivreg2 `lhs' (sleep = `iv') `base_control' hisp_race_* married_* trchildnum  if `lhs' != . & trdpftpt ==1, cluster(fips) fe 
  if `output' == 1 { 
      esttab rf using "`work'/tables/ATUS_season_robust_hispanic.tex", ///
        star(* 0.10 ** 0.05 *** 0.01) ///  
        drop(`base_control' hisp_* married_* trchildnum) ///
        se(a2) b(a2) noconstant nonumbers noobs nogaps  label tex begin(" & ") fragment wide replace nomtitles nolines
   }

   // More controls: race and kids and educ
   eststo drop *
   eststo: xtivreg2 sleep `iv' `base_control' hisp_race_* married_* trchildnum years_educ  if `lhs' != . & trdpftpt ==1, cluster(fips_id) fe
   eststo rf: xtivreg2 `lhs' `iv' `base_control' hisp_race_* married_* trchildnum  years_educ  if `lhs' != . & trdpftpt ==1, cluster(fips_id) fe
   eststo: xtivreg2 `lhs' (sleep = `iv') `base_control' hisp_race_* married_* trchildnum years_educ  if `lhs' != . & trdpftpt ==1, cluster(fips) fe 
  if `output' == 1 { 
      esttab rf using "`work'/tables/ATUS_season_robust_hispaniceduc.tex", ///
        star(* 0.10 ** 0.05 *** 0.01) ///  
        drop(`base_control' hisp_*   married_* trchildnum years_educ) ///
        se(a2) b(a2) noconstant nonumbers noobs nogaps  label tex begin(" & ") fragment wide replace nomtitles nolines
   }


   // More controls: education categories
   eststo drop *
   eststo: xtivreg2 sleep `iv' `base_control' educ_*  if `lhs' != . & trdpftpt ==1, cluster(fips_id) fe
   eststo rf: xtivreg2 `lhs' `iv' `base_control' educ_*  if `lhs' != . & trdpftpt ==1, cluster(fips_id) fe
   eststo: xtivreg2 `lhs' (sleep = `iv') `base_control' educ_*  if `lhs' != . & trdpftpt ==1, cluster(fips) fe 
  if `output' == 1 { 
      esttab rf using "`work'/tables/ATUS_season_robust_educcat.tex", ///
        star(* 0.10 ** 0.05 *** 0.01) ///  
        drop( `base_control' educ_*) ///
        se(a2) b(a2) noconstant nonumbers noobs nogaps  label tex begin(" & ") fragment wide replace nomtitles nolines
   }

   // Kitchen sink 
   capture drop quarter_*
   quietly: tab quarter, gen(quarter_)
   eststo drop *
   eststo rf0: xtivreg2 `lhs' `iv' `base_control' if `lhs' != . & trdpftpt ==1, cluster(fips_id) fe
   eststo rf1: xtivreg2 `lhs' `iv' `base_control' educ_*   if `lhs' != . & trdpftpt ==1, cluster(fips_id) fe
   eststo rf2: xtivreg2 `lhs' `iv' `base_control' educ_* hisp_race_* married_* trchildnum  if `lhs' != . & trdpftpt ==1, cluster(fips_id) fe
   eststo rf3: xtivreg2 `lhs' `iv' `base_control' educ_* hisp_race_* married_* trchildnum temperature0 if `lhs' != . & trdpftpt ==1, cluster(fips_id) fe
   eststo rf4: xtivreg2 `lhs' `iv' `base_control' educ_* hisp_race_* married_* trchildnum temperature0 quarter_* if `lhs' != . & trdpftpt ==1, cluster(fips_id) fe
   
  if `output' == 1 { 
      esttab rf0 rf1 rf2 rf3 rf4 using "`work'/tables/ATUS_season_robust_many_controls.tex", ///
        star(* 0.10 ** 0.05 *** 0.01) ///  
        drop( `base_control' educ_* hisp_race_* married_* temperature0 quarter_* trchildnum) ///
        se(a2) b(a2) noconstant nonumbers noobs nogaps  label tex fragment replace nomtitles nolines
   }

   // State clustering
   eststo drop *
   bysort fips: egen modal_state = mode(gestfips)
   eststo: xtivreg2 sleep `iv' `base_control'  if `lhs' != . & trdpftpt ==1, cluster(modal_state) fe
   eststo rf: xtivreg2 `lhs' `iv' `base_control'  if `lhs' != . & trdpftpt ==1, cluster(modal_state) fe
   eststo: xtivreg2 `lhs' (sleep = `iv') `base_control'  if `lhs' != . & trdpftpt ==1, cluster(modal_state) fe 
  if `output' == 1 { 
      esttab rf using "`work'/tables/ATUS_season_robust_cluster_state.tex", ///
        drop(`base_control'  ) ///
        star(* 0.10 ** 0.05 *** 0.01) ///
        se(a2) b(a2) noconstant nonumbers noobs nogaps  label tex begin(" & ") fragment wide replace nomtitles nolines
   }
   
   // Removing donut
   * Defining "donuts" around TZ boundaries
   eststo drop *
   local donutPM "-117.38, -114.74"
   local donutMC "-104.58, -100.58"
   local donutCE "-89.28, -84.93"
   eststo: xtivreg2 sleep `iv' `base_control'  if `lhs' != . & trdpftpt ==1  & !inrange(longitude, `donutPM') & !inrange(longitude, `donutMC') & !inrange(longitude, `donutCE'), cluster(fips_id) fe
   eststo rf: xtivreg2 `lhs' `iv' `base_control'  if `lhs' != . & trdpftpt ==1 &  !inrange(longitude, `donutPM') & !inrange(longitude, `donutMC') & !inrange(longitude, `donutCE'), cluster(fips_id) fe
   eststo: xtivreg2 `lhs' (sleep = `iv') `base_control'  if `lhs' != . & trdpftpt ==1&  !inrange(longitude, `donutPM') & !inrange(longitude, `donutMC') & !inrange(longitude, `donutCE'), cluster(fips) fe 
  if `output' == 1 { 
      esttab rf using "`work'/tables/ATUS_season_robust_nooverlap.tex", ///
        drop(`base_control'  ) ///
        star(* 0.10 ** 0.05 *** 0.01) stats(N, label("Observations") fmt(%9.0gc)) ///
        se(a2) b(a2) noconstant nonumbers nogaps  label tex begin(" & ") fragment wide replace nomtitles nolines
   }


   // State geocoding only
   eststo drop *
   eststo: xtivreg2 sleep `iv' `base_control'  if `lhs' != . & trdpftpt ==1 & cntygeomerge==1, cluster(fips_id) fe
   eststo rf: xtivreg2 `lhs' `iv' `base_control'  if `lhs' != . & trdpftpt ==1 & cntygeomerge==1, cluster(fips_id) fe
   eststo: xtivreg2 `lhs' (sleep = `iv') `base_control'  if `lhs' != . & trdpftpt ==1 & cntygeomerge==1, cluster(fips) fe 
  if `output' == 1 { 
      esttab rf using "`work'/tables/ATUS_season_robust_state_geo.tex", ///
        drop(`base_control'  ) ///
        star(* 0.10 ** 0.05 *** 0.01) ///
        se(a2) b(a2) noconstant nonumbers noobs nogaps  label tex begin(" & ") fragment wide replace nomtitles nolines
   }

   // County geocoding only
   eststo drop *
   eststo: xtivreg2 sleep `iv' `base_control'  if `lhs' != . & trdpftpt ==1 & cntygeomerge==3, cluster(fips_id) fe
   eststo rf: xtivreg2 `lhs' `iv' `base_control'  if `lhs' != . & trdpftpt ==1 & cntygeomerge==3, cluster(fips_id) fe
   eststo: xtivreg2 `lhs' (sleep = `iv') `base_control'  if `lhs' != . & trdpftpt ==1 & cntygeomerge==3, cluster(fips) fe 
  if `output' == 1 { 
      esttab rf using "`work'/tables/ATUS_season_robust_county_geo.tex", ///
        drop(`base_control'  ) ///
        star(* 0.10 ** 0.05 *** 0.01) ///
        se(a2) b(a2) noconstant nonumbers noobs nogaps  label tex begin(" & ") fragment wide replace nomtitles nolines
   }


   // Dropping weekends
   preserve
   drop if tudiaryday == 1
   drop if tudiaryday == 7
   eststo drop *
   eststo: xtivreg2 sleep `iv' `base_control'  if `lhs' != . & trdpftpt ==1, cluster(fips_id) fe
   eststo rf: xtivreg2 `lhs' `iv' `base_control'  if `lhs' != . & trdpftpt ==1, cluster(fips_id) fe
   eststo: xtivreg2 `lhs' (sleep = `iv') `base_control'  if `lhs' != . & trdpftpt ==1, cluster(fips) fe 
  if `output' == 1 { 
      esttab rf using "`work'/tables/ATUS_season_robust_noweekend.tex", ///
        drop(`base_control'  ) ///
        star(* 0.10 ** 0.05 *** 0.01) stats(N, label("Observations") fmt(%9.0gc)) ///
        se(a2) b(a2) noconstant nonumbers nogaps  label tex begin(" & ") fragment wide replace nomtitles nolines
   }
   restore
   
   // Only workdays
   eststo drop *
   preserve
   keep if work > 0
   eststo: xtivreg2 sleep `iv' `base_control'  if `lhs' != . & trdpftpt ==1, cluster(fips_id) fe
   eststo rf: xtivreg2 `lhs' `iv' `base_control'  if `lhs' != . & trdpftpt ==1, cluster(fips_id) fe
   eststo: xtivreg2 `lhs' (sleep = `iv') `base_control'  if `lhs' != . & trdpftpt ==1, cluster(fips) fe 
  if `output' == 1 { 
      esttab rf using "`work'/tables/ATUS_season_robust_onlyworkdays.tex", ///
        drop(`base_control'  ) ///
        star(* 0.10 ** 0.05 *** 0.01) stats(N, label("Observations") fmt(%9.0gc)) ///
        se(a2) b(a2) noconstant nonumbers nogaps  label tex begin(" & ") fragment wide replace nomtitles nolines
   }
   restore
   
   
   // No counties near TZ boundary
   eststo drop *
   preserve
   gen tz_boundary = 0
   replace tz_boundary = 1 if inrange(longitude, -118, -110) | inrange(longitude, -107, -99)  | inrange(longitude, -90, -82)
   keep if tz_boundary == 0
   eststo: xtivreg2 sleep `iv' `base_control'  if `lhs' != . & trdpftpt ==1, cluster(fips_id) fe
   eststo rf: xtivreg2 `lhs' `iv' `base_control'  if `lhs' != . & trdpftpt ==1, cluster(fips_id) fe
   eststo: xtivreg2 `lhs' (sleep = `iv') `base_control'  if `lhs' != . & trdpftpt ==1, cluster(fips) fe 
  if `output' == 1 { 
      esttab rf using "`work'/tables/ATUS_season_robust_noborder.tex", ///
        drop(`base_control'  ) ///
        star(* 0.10 ** 0.05 *** 0.01) stats(N, label("Observations") fmt(%9.0gc)) ///
        se(a2) b(a2) noconstant nonumbers nogaps  label tex begin(" & ") fragment wide replace nomtitles nolines
   }
   restore
   
   /// Seasonality
   // Temperature
   label var temperature0 "Temperature ($\degree$ C)"
   eststo drop *
   eststo: xtivreg2 sleep `iv' temperature0 temperatureL1 `base_control'  if `lhs' != . & trdpftpt ==1, cluster(fips_id) fe
   eststo rf: xtivreg2 `lhs' `iv' temperature0 temperatureL1 `base_control'  if `lhs' != . & trdpftpt ==1, cluster(fips_id) fe
   eststo: xtivreg2 `lhs' (sleep = `iv') temperature0 temperatureL1 `base_control'  if `lhs' != . & trdpftpt ==1, cluster(fips) fe 
   if `output' == 1 { 
       esttab rf using "`work'/tables/ATUS_season_robust_temperature.tex", ///
       drop(`base_control'  temperature*) ///
       star(* 0.10 ** 0.05 *** 0.01)  ///
       se(a2) b(a2) noconstant nonumbers nogaps  label tex begin(" & ") fragment wide replace nomtitles nolines noobs
   }

   // Other weather
   gen prcp_bin = (prcp>0 & prcp!=.)
   gen snow_bin = (snow>0 & snow!=.)   
   label var prcp "Precipitation (mm)"
   eststo drop *
   eststo: xtivreg2 sleep `iv' temperature0 temperatureL1 prcp `base_control'  if `lhs' != . & trdpftpt ==1, cluster(fips_id) fe
   eststo rf: xtivreg2 `lhs' `iv' temperature0 temperatureL1 prcp `base_control'  if `lhs' != . & trdpftpt ==1, cluster(fips_id) fe
   eststo: xtivreg2 `lhs' (sleep = `iv') temperature0 temperatureL1 prcp `base_control'  if `lhs' != . & trdpftpt ==1, cluster(fips) fe 
   if `output' == 1 { 
       esttab rf using "`work'/tables/ATUS_season_robust_temprain.tex", ///
       drop(`base_control'  temperature* prcp) ///
       star(* 0.10 ** 0.05 *** 0.01)  ///
       se(a2) b(a2) noconstant nonumbers nogaps  label tex begin(" & ") fragment wide replace nomtitles nolines noobs
   }

   
   
   
   // Some helpful graphs
   gen week = week(date)
   gen cos_doy = cos(((2*_pi)/365)*doy)
   reg sleep cos_doy

   // Using declination as IV
   gen sun_dec_rad = sun_dec*(_pi/180)
   label var sun_dec_rad "Solar declination"
   eststo drop *
   eststo: xtivreg2 sleep sun_dec_rad `base_control'  if `lhs' != . & trdpftpt ==1, cluster(fips_id) fe
   eststo rf: xtivreg2 `lhs' sun_dec_rad `base_control'  if `lhs' != . & trdpftpt ==1, cluster(fips_id) fe
   eststo: xtivreg2 `lhs' (sleep = sun_dec_rad) `base_control'  if `lhs' != . & trdpftpt ==1, cluster(fips) fe 
  if `output' == 1 { 
      esttab rf using "`work'/tables/ATUS_season_robust_solardec.tex", ///
        drop(`base_control'  ) ///
        star(* 0.10 ** 0.05 *** 0.01) stats(N, label("Observations") fmt(%9.0gc)) ///
        se(a2) b(a2) noconstant nonumbers nogaps  label tex begin(" & ") fragment wide replace nomtitles nolines noobs
   }

   // seasonalize wage
   quietly: su `lhs'
   local avg_`lhs' = r(mean)
   gen des_wage = .
   forvalues i = 1/12 {
      su `lhs' if month == `i'
      replace des_wage = `lhs' - r(mean) if month == `i'
   }
   eststo drop *
   eststo: xtivreg2 sleep `iv' `base_control'  if `lhs' != . & trdpftpt ==1, cluster(fips_id) fe
   eststo rf: xtivreg2 des_wage `iv' `base_control'  if `lhs' != . & trdpftpt ==1, cluster(fips_id) fe
   eststo: xtivreg2 des_wage (sleep = `iv') `base_control'  if `lhs' != . & trdpftpt ==1, cluster(fips) fe 
  if `output' == 1 { 
      esttab rf using "`work'/tables/ATUS_season_robust_seasonalizedwage.tex", ///
        drop(`base_control'   ) ///
        star(* 0.10 ** 0.05 *** 0.01) ///
        se(a2) b(a2) noconstant nonumbers noobs nogaps  label tex begin(" & ") fragment wide replace nomtitles nolines
   }
   
   // No holiday season
   eststo drop *
   eststo: xtivreg2 sleep `iv' `base_control'  if `lhs' != . & trdpftpt ==1 & doy <=325 & doy >= 10, cluster(fips_id) fe
   eststo rf: xtivreg2 `lhs' `iv' `base_control'  if `lhs' != . & trdpftpt ==1  & doy <=325 & doy >= 10, cluster(fips_id) fe
   eststo: xtivreg2 `lhs' (sleep = `iv') `base_control'  if `lhs' != . & trdpftpt ==1 & doy <=325 & doy >= 10, cluster(fips) fe 
  if `output' == 1 { 
      esttab rf using "`work'/tables/ATUS_season_robust_nochristmas.tex", ///
        drop(`base_control') ///
        star(* 0.10 ** 0.05 *** 0.01) stats(N, label("Observations") fmt(%9.0gc)) ///
        se(a2) b(a2) noconstant nonumbers nogaps  label tex begin(" & ") fragment wide replace nomtitles nolines
   }

   // No winter
   eststo drop *
   eststo: xtivreg2 sleep `iv' `base_control'  if `lhs' != . & trdpftpt ==1 & quarter != 1 & quarter != 4, cluster(fips_id) fe
   eststo rf: xtivreg2 `lhs' `iv' `base_control'  if `lhs' != . & trdpftpt ==1  & quarter != 1 & quarter != 4, cluster(fips_id) fe
   eststo: xtivreg2 `lhs' (sleep = `iv') `base_control'  if `lhs' != . & trdpftpt ==1  & quarter != 1 & quarter != 4, cluster(fips) fe 
  if `output' == 1 { 
      esttab rf using "`work'/tables/ATUS_season_robust_nowinter.tex", ///
        drop(`base_control') ///
        star(* 0.10 ** 0.05 *** 0.01) stats(N, label("Observations") fmt(%9.0gc)) ///
        se(a2) b(a2) noconstant nonumbers nogaps  label tex begin(" & ") fragment wide replace nomtitles nolines
   }
   
   // All combinations of 2 quarters
   foreach i in 1 2 3 4 {
      foreach j in 1 2 3 4 {
         if  `i' < `j' {
            di "Quarter `i' and `j'."
            quietly: xtivreg2 `lhs' `iv' `base_control' if `lhs' != . & trdpftpt ==1  & quarter == `i' | quarter == `j', cluster(fips_id) fe
            di _b[`iv']
            di _se[`iv']
         }
      }
   }
   // With quarter FEs
   eststo drop *
   eststo: xtivreg2 sleep `iv' `base_control' quarter_*  if `lhs' != . & trdpftpt ==1, cluster(fips_id) fe
   eststo rf: xtivreg2 `lhs' `iv' `base_control' quarter_*  if `lhs' != . & trdpftpt ==1, cluster(fips_id) fe
   eststo: xtivreg2 `lhs' (sleep = `iv') `base_control' quarter_*  if `lhs' != . & trdpftpt ==1, cluster(fips) fe 
   if `output' == 1 { 
      esttab rf using "`work'/tables/ATUS_season_robust_quarter.tex", ///
        drop(`base_control'  quarter_* ) ///
        star(* 0.10 ** 0.05 *** 0.01) ///
        se(a2) b(a2) noconstant nonumbers noobs nogaps  label tex begin(" & ") fragment wide replace nomtitles nolines
   }
   // With month FEs
   eststo drop *
   quietly: tab month, gen(month_)
   eststo: xtivreg2 sleep `iv' `base_control' month_*  if `lhs' != . & trdpftpt ==1, cluster(fips_id) fe
   eststo rf: xtivreg2 `lhs' `iv' `base_control' month_*  if `lhs' != . & trdpftpt ==1, cluster(fips_id) fe
   eststo: xtivreg2 `lhs' (sleep = `iv') `base_control' month_*  if `lhs' != . & trdpftpt ==1, cluster(fips) fe 
   if `output' == 1 { 
      esttab rf using "`work'/tables/ATUS_season_robust_month.tex", ///
        drop(`base_control'  month_* ) ///
        star(* 0.10 ** 0.05 *** 0.01) ///
        se(a2) b(a2) noconstant nonumbers noobs nogaps  label tex begin(" & ") fragment wide replace nomtitles nolines
   }

   // Intermediate seasonal dummies
   capture drop seas_cont*
   xtile seas_cont = doy, nquantiles(6)
   quietly: tab seas_cont, gen(seas_cont_)
   eststo: xtivreg2 `lhs' (sleep = `iv') `base_control' seas_cont_*  if `lhs' != . & trdpftpt ==1, cluster(fips) fe 


   // Just wage and DoY
   capture drop doyt_*
   quietly: tab doy, gen(doyt_)
   regress `lhs' doyt_1-doyt_317 doyt_319-doyt_365  if !missing(`lhs'), vce(cluster fips)
   coefplot, keep(*doyt_*) vertical generate(doyt_b_)
   coefplot, keep(*doyt_*) vertical
   graph export "`work'/graphs/doy_coefficients_coefplot.pdf", as(pdf) replace   
   twoway (spike doyt_b_ul doyt_b_ll doyt_b_at, col(gray gray)) (scatter doyt_b_b doyt_b_at, col(black)), legend(off) xtitle("Day of Year") ytitle("Coefficient value")
   graph export "`work'/graphs/doy_coefficients.pdf", as(pdf) replace
   drop doyt_* 



   // Running each month
   eststo drop *
   forvalues i=1/12 {
      xtivreg2 sleep `iv' `base_control'  if `lhs' != . & trdpftpt ==1 & month == `i', cluster(fips_id) fe
      di _b[`iv']
      xtivreg2 `lhs' (sleep = `iv') `base_control'  if `lhs' != . & trdpftpt ==1 & month == `i', cluster(fips) fe       
      di _b[sleep]
      eststo
   }
  if `output' == 1 { 
      esttab using "`work'/tables/ATUS_season_robust_eachmonth.tex", ///
        drop(`base_control'   ) ///
        star(* 0.10 ** 0.05 *** 0.01) ///
        se(a2) b(a2) noconstant nonumbers noobs nogaps label tex begin(" & ") fragment wide replace nomtitles nolines
   }
   
   
   /// Alternative sleep truncation
   preserve
   
   // Cutoffs at 1st and 99th percentiles
   quietly su sleep, de
   local sleepmin = r(p1)
   local sleepmax = r(p99)
   keep  if inrange(sleep, `sleepmin', `sleepmax')
   eststo drop *
   eststo: xtivreg2 sleep `iv' `base_control'  if `lhs' != . & trdpftpt ==1, cluster(fips_id) fe
   eststo rf: xtivreg2 `lhs' `iv' `base_control'  if `lhs' != . & trdpftpt ==1, cluster(fips_id) fe
   eststo: xtivreg2 `lhs' (sleep = `iv') `base_control'  if `lhs' != . & trdpftpt ==1, cluster(fips) fe 
  if `output' == 1 { 
      esttab rf using "`work'/tables/ATUS_season_robust_truncate1pct.tex", ///
        drop(`base_control'   ) ///
        star(* 0.10 ** 0.05 *** 0.01) stats(N, label("Observations") fmt(%9.0gc)) ///
        se(a2) b(a2) noconstant nonumbers nogaps  label tex begin(" & ") fragment wide replace nomtitles nolines
   }
   restore
   
   // Cutoffs at 5th and 95th percentiles
   preserve
   quietly su sleep, de
   local sleepmin = r(p5)
   local sleepmax = r(p95)
   keep if inrange(sleep, `sleepmin', `sleepmax')
   eststo drop *
   eststo: xtivreg2 sleep `iv' `base_control'  if `lhs' != . & trdpftpt ==1, cluster(fips_id) fe
   eststo rf: xtivreg2 `lhs' `iv' `base_control'  if `lhs' != . & trdpftpt ==1, cluster(fips_id) fe
   eststo: xtivreg2 `lhs' (sleep = `iv') `base_control'  if `lhs' != . & trdpftpt ==1, cluster(fips) fe 
  if `output' == 1 { 
      esttab rf using "`work'/tables/ATUS_season_robust_truncate5pct.tex", ///
     drop(`base_control'   ) ///
        star(* 0.10 ** 0.05 *** 0.01) stats(N, label("Observations") fmt(%9.0gc)) ///
        se(a2) b(a2) noconstant nonumbers nogaps  label tex begin(" & ") fragment wide replace nomtitles nolines
   }
   restore

   label var sunset_time_season "Daily sunset time"
} // End robustness conditional

//////////////////////////////////
// Seasonal confouding bounding
//////////////////////////////////
if `seasonal' == 1 {
   * The idea here is that we want to find out how robust our result is to
   * other, correlated seasonal patterns. If the seasonal pattern has the
   * same frequency and phase, then we cannot identify against it. In the
   * limit, however, we can technically identify our result relative to any
   * other seasonal pattern given enough data. The idea is similar to fixed
   * effects: you put in a control for all things that don't vary, so
   * if your result still holds, then you are identified only at a higher
   * frequency. We are generalizing that idea along two dimentions. First,
   * we are allowing the frequency to be non-zero. Second, we test things
   * that have the same frequency but different phase. For details on the
   * statistics behind this, see seasonal_patterns.R.

   * Note that an approximate formula for the seasonal sunset pattern is
   * -2*cos((360/365)*(_pi/180)*(doy+10))

   * Plot the seasonal sunset time
   preserve
   keep sunset_time sunset_time_season doy
   duplicates drop 
   label var doy "Day of the year"
   twoway scatter sunset_time doy, msymbol(p) color(gs4) xlabel(79 172 265 355)
   graph export "`work'/graphs/ATUS_sunset_time_doy.pdf", as(pdf) replace
   twoway scatter sunset_time_season doy, msymbol(p) color(gs4)  xlabel(79 172 265 355)
   graph export "`work'/graphs/ATUS_sunset_time_season_doy.pdf", as(pdf) replace
   restore
   
   * Get baseline coefficient
   quietly: xtivreg2 `lhs' `iv' `base_control' if `lhs' != . & trdpftpt ==1, cluster(fips_id) fe
   local rf = _b[`iv']
   local rf_se = _se[`iv']
   local rf_u = `rf' + 1.96*`rf_se'
   local rf_l = `rf' - 1.96*`rf_se'
   
   * Phase shifting
   * Going a half cycle off gets us all series correlated with true sunset of
   * degree = (-1,1). Going a quarter cycle off would get all positive
   * correlations, which is sufficient for bounding, but doesn't illustrate
   * the full degree of bias.
   capture drop phase_shift*
   gen phase_shift_b = .
   gen phase_shift_se = .
   gen phase_shift_bs = .
   gen phase_shift_ses = .
   gen phase_shift = .
   local j = 1
   forvalues i = 1(1)183 {
      di `i'
      replace phase_shift = `i' in `j'
      gen phase_shift_sst = -1*cos((360/365)*(_pi/180)*(doy+10+`i'))
      quietly: xtivreg2 `lhs' `iv' phase_shift_sst `base_control' if `lhs' != . & trdpftpt ==1, cluster(fips_id) fe
      replace phase_shift_b = _b[`iv'] in `j'
      replace phase_shift_se = _se[`iv'] in `j'
      replace phase_shift_bs = _b[phase_shift_sst] in `j'
      replace phase_shift_ses = _se[phase_shift_sst] in `j'      
      drop phase_shift_sst
      local j = `j' + 1
   }
   gen phase_shift_u = phase_shift_b + 1.96*phase_shift_se
   gen phase_shift_l = phase_shift_b - 1.96*phase_shift_se
   
   twoway ///
          (line phase_shift_u phase_shift_l phase_shift, lpattern(dash dash) lcolor(black black)) ///
          (line phase_shift_b phase_shift, lcolor(black) ) ///
          , yline(`rf', lwidth(thin)) yline(0, lcolor(black) lwidth(thin)) ///
          legend(off) xtitle("Phase shift (days)") ytitle("Coefficient")
   graph export "`work'/graphs/season_iv_valid_phase.pdf", as(pdf) replace

          
   * Frequency
   * Similar to phase shifting, but just spanning the frequency of of our
   * actual sunset time. Note that unlike the phase shifting case, there is
   * just a limiting statement--as the frequency goes to infinity, the
   * correlation between the constructed variable and sunset goes to zero.
   capture drop freq_shift*
   gen freq_shift_b = .
   gen freq_shift_se = .
   gen freq_shift = .
   local j = 1
   forvalues i = .05(.025)3 {
      di `i'
      replace freq_shift = `i' in `j'
      gen freq_shift_sst = -1*cos((360/365)*(_pi/180)*((doy+10)*`i'))
      quietly: xtivreg2 `lhs' `iv' freq_shift_sst `base_control' if `lhs' != . & trdpftpt ==1, cluster(fips_id) fe
      replace freq_shift_b = _b[`iv'] in `j'
      replace freq_shift_se = _se[`iv'] in `j'      
      drop freq_shift_sst
      local j = `j' + 1
   }
   gen freq_shift_u = freq_shift_b + 1.96*freq_shift_se
   gen freq_shift_l = freq_shift_b - 1.96*freq_shift_se
   
   twoway ///
          (line freq_shift_b freq_shift, lcolor(black) ) ///
          (line freq_shift_u freq_shift_l freq_shift, lpattern(dash dash) lcolor(black black)) ///
          , yline(`rf', lwidth(thin)) yline(0, lcolor(black) lwidth(thin)) ///
          legend(off label(1 "")) xtitle("Relative frequency") ytitle("Coefficient")
   graph export "`work'/graphs/season_iv_valid_freq.pdf", as(pdf) replace

   * Phase shifting without sunset
   * Going a half cycle off gets us all series correlated with true sunset of
   * degree = (-1,1). Going a quarter cycle off would get all positive
   * correlations, which is sufficient for bounding, but doesn't illustrate
   * the full degree of bias.
   capture drop synthetic_wo*
   gen synthetic_wo_b = .
   gen synthetic_wo_se = .
   gen synthetic_wo = .
   local j = 1
   forvalues i = 1(1)190 {
      di `i'
      replace synthetic_wo = `i' in `j'
      gen synthetic_sst = -1*cos((360/365)*(_pi/180)*(doy+`i'))
      quietly: xtivreg2 `lhs' synthetic_sst `base_control' if `lhs' != . & trdpftpt ==1, cluster(fips_id) fe
      replace synthetic_wo_b = _b[synthetic_sst] in `j'
      replace synthetic_wo_se = _se[synthetic_sst] in `j'      
      drop synthetic_sst
      local j = `j' + 1
   }
   gen synthetic_wo_u = synthetic_wo_b + 1.96*synthetic_wo_se
   gen synthetic_wo_l = synthetic_wo_b - 1.96*synthetic_wo_se
   
   twoway ///
          (line synthetic_wo_u synthetic_wo_l synthetic_wo, lpattern(dash dash) lcolor(black black)) ///
          (line synthetic_wo_b synthetic_wo, lcolor(black) ) ///
          , yline(`rf') yline(0) xline(10)  ///
          legend(off) xtitle("Phase shift (days)") ytitle("Coefficient on synthetic variable")
   graph export "`work'/graphs/season_iv_valid_phase_synth.pdf", as(pdf) replace
}

if `part_time' == 1 {
   gen part_time = (trdpftpt == 2)
   replace part_time = . if trdpftpt == -1
   gen employed = (trdpftpt == 1 | trdpftpt == 2)

   label var part_time "Part-time employed"
   label var employed "Employed"
   
   eststo rfs: xtivreg2 part_time sunset_time_season `base_control', cluster(fips_id) fe partial(`base_control')

   if `output' == 1 {
      esttab rfs  using "`work'/tables/ATUS_season_part_time.tex", ///
             star(* 0.10 ** 0.05 *** 0.01) stats(N, label("Observations") fmt(%9.0gc)) ///
             se(a2) noconstant nonumbers nogaps  label tex fragment replace ///
             nomtitles nolines  b(a2)
   }

}

//////////////////////////////////
// Time shifting
//////////////////////////////////
if `other_time' == 1 {
   
   // Gronau time categories
   // We want to run this over the baseline sample, part time, and unemployed
   // Baseline sample
   eststo c_2: xtivreg2 sleep `iv' `base_control'  if `lhs' != . & trdpftpt ==1, cluster(fips_id) fe
   eststo c_1: xtivreg2 time_c_1 `iv' `base_control'  if `lhs' != . & trdpftpt ==1, cluster(fips_id) fe
   eststo c_4: xtivreg2 time_c_4 `iv' `base_control'  if `lhs' != . & trdpftpt ==1, cluster(fips_id) fe
   eststo c_3: xtivreg2 time_c_3 `iv' `base_control'  if `lhs' != . & trdpftpt ==1, cluster(fips_id) fe
   if `output' == 1 {
      esttab c_2 c_1 c_4 c_3 using "`work'/tables/ATUS_season_modeltime_base.tex", ///
             drop(`base_control' ) ///
             star(* 0.10 ** 0.05 *** 0.01) stats(N, label("Observations") fmt(%9.0gc)) ///
             se(a2) noconstant nonumbers nogaps  label tex fragment replace ///
             nomtitles nolines  b(a2)
   }
   su sleep time_c_1 time_c_4 time_c_3 if `lhs' != . & trdpftpt ==1
   
   // Part-time sample
   eststo c_2: xtivreg2 sleep `iv' `base_control'  if `lhs' != . & trdpftpt == 2, cluster(fips_id) fe
   eststo c_1: xtivreg2 time_c_1 `iv' `base_control'  if `lhs' != . & trdpftpt == 2, cluster(fips_id) fe
   eststo c_4: xtivreg2 time_c_4 `iv' `base_control'  if `lhs' != . & trdpftpt == 2, cluster(fips_id) fe
   eststo c_3: xtivreg2 time_c_3 `iv' `base_control'  if `lhs' != . & trdpftpt == 2, cluster(fips_id) fe
   if `output' == 1 {
      esttab c_2 c_1 c_4 c_3 using "`work'/tables/ATUS_season_modeltime_part.tex", ///
             drop(`base_control' ) ///
             star(* 0.10 ** 0.05 *** 0.01) stats(N, label("Observations") fmt(%9.0gc)) ///
             se(a2) noconstant nonumbers nogaps  label tex fragment replace ///
             nomtitles nolines  b(a2)
   }
   // Not employed sample
   eststo c_2: xtivreg2 sleep `iv' `individual' `gender' `time'   if trdpftpt == -1, cluster(fips_id) fe
   eststo c_4: xtivreg2 time_c_4 `iv' `individual' `gender' `time'  if trdpftpt == -1, cluster(fips_id) fe
   eststo c_3: xtivreg2 time_c_3 `iv' `individual' `gender' `time'  if trdpftpt == -1, cluster(fips_id) fe
   if `output' == 1 {
      esttab c_2 c_4 c_3 using "`work'/tables/ATUS_season_modeltime_noemp.tex", ///
             drop(`individual' `gender' `time') ///
             star(* 0.10 ** 0.05 *** 0.01) ///
             stats(N, label("Observations") fmt(%9.0gc)) ///
             se(a2) noconstant nonumbers nogaps  label tex fragment replace ///
             nomtitles nolines  b(a2) extracols(2) noobs
   }
   su sleep time_c_1 time_c_4 time_c_3 if trdpftpt == -1

   // Other time shifting stuff--not Gronau related
   // Work hours
   eststo drop *
   label var work "Work time"
   eststo: xtivreg2 sleep `iv' `base_control' work  if `lhs' != . & trdpftpt ==1, cluster(fips_id) fe
   eststo rf: xtivreg2 `lhs' `iv' `base_control' work  if `lhs' != . & trdpftpt ==1, cluster(fips_id) fe
   eststo: xtivreg2 `lhs' (sleep = `iv') `base_control' work  if `lhs' != . & trdpftpt ==1, cluster(fips) fe
   gen in_sample = (e(sample))
   if `output' == 1 {
      esttab using "`work'/tables/ATUS_season_work.tex", ///
        drop(`base_control'  ) ///
        star(* 0.10 ** 0.05 *** 0.01) stats(N, label("Observations") fmt(%9.0gc)) ///
        se(a2) noconstant nonumbers nogaps  label tex fragment replace nomtitles nolines  b(a2)
   }
   * Summary stats
   summ work  if in_sample == 1, detail
   summ work  if in_sample == 1 & work>0, detail
   summ sleep  if in_sample == 1, detail
   summ tehruslt if in_sample == 1, detail

   // Other hours
   label var other_time_exnaps "Other time"
   eststo drop *
   eststo: xtivreg2 sleep `iv' `base_control' other_time_exnaps  if `lhs' != . & trdpftpt ==1, cluster(fips_id) fe
   eststo rf: xtivreg2 `lhs' `iv' `base_control' other_time_exnaps  if `lhs' != . & trdpftpt ==1, cluster(fips_id) fe
   eststo: xtivreg2 `lhs' (sleep = `iv') `base_control' other_time_exnaps  if `lhs' != . & trdpftpt ==1, cluster(fips) fe
  if `output' == 1 {
      esttab using "`work'/tables/ATUS_season_othertime.tex", ///
        drop(`base_control'  ) ///
        star(* 0.10 ** 0.05 *** 0.01) stats(N, label("Observations") fmt(%9.0gc)) ///
        se(a2) noconstant nonumbers nogaps  label tex fragment replace nomtitles nolines  b(a2)
   }
   

   * Work duration as fxn of sunset
   eststo clear
   eststo: xtivreg2 work `base_control' `iv'  if `lhs' != . & trdpftpt ==1 , cluster(fips_id) fe
   * Other time as fxn of sunset
   eststo: xtivreg2 other_time_exnaps `base_control' `iv'  if `lhs' != . & trdpftpt ==1, cluster(fips_id) fe
   if `output' == 1 {
      esttab using "`work'/tables/ATUS_season_workothertime_IV.tex", ///
        drop(`base_control') ///
        star(* 0.10 ** 0.05 *** 0.01) stats(N, label("Observations") fmt(%9.0gc)) ///
             se(a2) noconstant nonumbers nogaps  label tex fragment replace ///
             nomtitles nolines noeqlines b(a2) noobs
   }
   eststo: xtivreg2 nap_sst1 `base_control' `iv'  if `lhs' != . & trdpftpt ==1, cluster(fips_id) fe

   * Bedtime and wake time
   eststo clear
   eststo: xtivreg2 bedtime `base_control' `iv'  if `lhs' != . & trdpftpt ==1 , cluster(fips_id) fe
   eststo: xtivreg2 waketime `base_control' `iv'  if `lhs' != . & trdpftpt ==1, cluster(fips_id) fe
   if `output' == 1 {
      esttab using "`work'/tables/ATUS_season_bedwake.tex", ///
             drop(`base_control') ///
             star(* 0.10 ** 0.05 *** 0.01) ///
             se(a2) noconstant nonumbers nogaps noobs label tex fragment replace nomtitles nolines noeqlines b(a2)
   }
   eststo clear
   eststo: xtivreg2 bedtime `base_control' sunrise_time  if `lhs' != . & trdpftpt ==1 , cluster(fips_id) fe
   eststo: xtivreg2 waketime `base_control' sunrise_time  if `lhs' != . & trdpftpt ==1, cluster(fips_id) fe
   if `output' == 1 {
      esttab using "`work'/tables/ATUS_season_bedwake_sunrise.tex", ///
             drop(`base_control') ///
             star(* 0.10 ** 0.05 *** 0.01) ///
             se(a2) noconstant nonumbers nogaps noobs ///
             label tex fragment replace nomtitles nolines noeqlines b(a2)
   }

   
} /* End control loop for other time */


////////////////////////////////////////////////////////////////
// Model 2: Nonlinear
////////////////////////////////////////////////////////////////

if `nonlinear' == 1 {
   ** Graph of conditional expectations
   ** We want to replicate the usual OLS conditional expectation plot, but in the IV case, so the
   ** x-axis will be bins of sleep conditional on instrument and covariates and the y-axis will be
   ** log wage conditional on the same stuff.
   ** First, condition both wage and sleep on controls
   capture drop sleep_resid wage_resid
   areg sleep `base_control' if `lhs' != . & trdpftpt ==1, absorb(fips_id)
   predict sleep_resid if e(sample), resid
   areg `lhs' `base_control' if `lhs' != . & trdpftpt ==1, absorb(fips_id)
   predict wage_resid if e(sample), resid
   local j = 1
   capture drop wr_a sr_a sst_tile count
   xtile sst_tile = sunset_time_season, nquantiles(30)
   bysort sst_tile: egen sr_a = mean(sleep_resid)
   bysort sst_tile: egen wr_a = mean(wage_resid)
   bysort sst_tile: gen count = _n
   twoway (scatter wr_a sr_a) (lfit wr_a sr_a) if count == 1
   twoway (scatter wr_a sr_a) (lfit wr_a sr_a) if sr_a > -6 & sr_a < 10
   twoway (lpolyci wr_a sr_a, bwidth(1)) if sr_a > -2 & sr_a < 10

   // Plot of wage residuals against instrumented sleep
   // sleep_hat computed above after first stage
   capture drop sleep_hat
   capture drop wage_resid
   capture drop wage_hat
   capture drop sleep_hat_resid
   capture drop sleep_hat_resid_avg
   areg sleep sunset_time_season `base_control' if `lhs' != . & trdpftpt ==1, absorb(fips_id)
   predict sleep_hat if e(sample), xb /* used for lpoly below */
   areg sleep_hat `base_control' if `lhs' != . & trdpftpt ==1, absorb(fips_id)
   predict sleep_hat_resid if e(sample), residuals
   areg `lhs' `base_control' if `lhs' != . & trdpftpt ==1, absorb(fips_id)
   predict wage_resid if e(sample), residuals
   predict wage_hat if e(sample)
   gen sleep_hat_resid_avg = sleep_hat_resid + `avg_sleep'
   lpoly wage_resid sleep_hat_resid, noscatter ci level(95) degree(1) ytitle("Residual log earnings") xtitle("Instrumented sleep") title("") bwidth(.29) legend(off)
   graph export "`work'/graphs/residwage_sleephat_lpoly_season.pdf", as(pdf) replace

   * Kim and Petrin
   ** Higher-order control functions and interactions often statistically significant, but do not appreciably change coefficients of interest
   preserve
   global base_control "`base_control'"
   global lhs "ln_wkly_wage"
   gen sleep2 = sleep^2
   gen sleep3 = sleep^3
   gen sleep4 = sleep^4
   capture program drop KPendog2step
   program KPendog2step, eclass
	version 14
      tempname b
      capture drop ehat* etilde*
      regress sleep $base_control sunset_time_season
      predict ehat1, residuals
      gen etilde1 = ehat1
      gen etilde1XSST = etilde1 * sunset_time_season
      gen ehat2 = ehat1^2
      quietly regress ehat2 sunset_time_season
      predict etilde2, residuals
      gen etilde2XSST = etilde2 * sunset_time_season
      regress $lhs $base_control sleep sleep2 /*sleep3 sleep4*/ etilde1* etilde2* [aweight=obs] if !missing($lhs)
      matrix `b' = e(b)
      ereturn post `b'
   end

   keep if !missing(ln_wkly_wage, sunset_time_season, sleep)
   eststo clear
   bootstrap _b[sleep] _b[sleep2] /*_b[sleep3] _b[sleep4]*/, reps(100) seed(47) cluster(fips): KPendog2step
   eststo
   
   twoway function y=(_b[_bs_1]*x)+(_b[_bs_2]*x^2)/*+(_b[_bs_3]*x^3)+(_b[_bs_4]*x^4)*/, range(56.9 59.15) lcolor(black) ///
          || function y=(1.96*(_se[_bs_1]+_se[_bs_2]/*+_se[_bs_3]+_se[_bs_4])*/)+(_b[_bs_1]*x)+(_b[_bs_2]*x^2)/*+(_b[_bs_3]*x^3)+(_b[_bs_4]*x^4)*/), range(56.9 59.15) lpattern(dash) lcolor(gs12) ///
          || function y=(-1.96*(_se[_bs_1]+_se[_bs_2]/*+_se[_bs_3]+_se[_bs_4])*/)+(_b[_bs_1]*x)+(_b[_bs_2]*x^2)/*+(_b[_bs_3]*x^3)+(_b[_bs_4]*x^4)*/), range(56.9 59.15) lpattern(dash) lcolor(gs12) ///
          xtitle("Sleep") ytitle("Residual log earnings") title("") legend(off)
   graph export "`work'/graphs/KPplot_season.pdf", as(pdf) replace
   restore
} // Nonlinear conditional



timer off 1
timer list 1
capture log close
