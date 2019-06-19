
/******************************
1. IMPORT DATA: COMBINE BGT LABOR/INSIGHT DATA PULLS
******************************/

use bgt_employer_firm_2007_2010_2012v3.dta, clear

gen educ=edu
replace educ=maxedu if educ==.

gen exper=exp
replace exper=maxexp if exp==.

drop edu maxedu exp maxexp

	*generate experience and education categories
	gen expreq=exper!=.
	
	gen exp_0to1=(exper>0 & exper<1 & !missing(exper))
	gen exp_1to2=(exper>=1 & exper<2 &  !missing(exper))
	gen exp_2to3=(exper>=2 & exper<3 & !missing(exper))
	gen exp_3to5=(exper>=3 & exper<5 & !missing(exper))
	gen exp_5to7=(exper>=5 & exper<7 & !missing(exper))
	gen exp_7to15=(exper>=7 & exper<15 & !missing(exper))

	gen edureq=educ!=.
	
	gen eduhs=educ==12 & !missing(educ)
	gen edusc=(educ==13 | educ==14) &!missing(educ)
	gen edubd=(educ==16  &!missing(educ))
	gen eduma=(educ==18 &!missing(educ))
	gen eduphd=(educ==21 &!missing(educ))
		
	gen totalopenings=1
	
bys statefip occsoc year: egen avg_exp=mean(exper)
bys statefip occsoc year: egen avg_edu=mean(educ)

collapse (sum) totalopenings expreq exp_0to1 exp_1to2 exp_2to3 exp_3to5 exp_5to7 exp_7to15 edureq eduhs edusc edubd eduma eduphd (mean) avg_exp avg_edu, by(statefip occsoc year)
	
save bgt_state_occ_2007_2010_2012.dta, replace


/******************************
2. ADDRESS OCCUPATION CODING CHANGES FROM 2000 to 2010
******************************/
use bgt_state_occ_2007_2010_2012.dta, clear

drop if inlist(statefip, 11, 66, 72)

replace occsoc="435111" if occsoc=="43511."
replace occsoc="191029" if occsoc=="191020" // general code for marine biologist combine

drop if substr(occsoc,1,2)=="55"

/*Crosswalk Occupation Changes*/
*occupations codes that split 1:many from 2000 to 2010
preserve
	import excel soc2000 soc2000_name soc2010 soc2010_name using soc_2000_to_2010_crosswalk.xlsx, clear cellrange(A9:D868) allstring
	drop if soc2000==soc2010
	duplicates tag soc2000, gen(dup00)
	duplicates tag soc2010, gen(dup10)
	keep if dup10==0 & dup00!=0

	gen occsoc=soc2010
	tempfile a
	save `a', replace
restore

merge m:1 occsoc using `a', keepusing(soc2000 soc2000_name) gen(_m_soc2000)

unique occsoc //821
replace occsoc=soc2000 if _m_soc2000==3 

/*Collapse split occupations*/

preserve
	collapse (mean) avg_exp [fw=expreq], by(statefip year occsoc)
	tempfile a
	save `a', replace
restore

preserve
	collapse (mean) avg_edu [fw=edureq], by(statefip year occsoc)
	tempfile b
	save `b', replace
restore


gen i_soc2010_count=1 

collapse (sum) edu* exp* totalopenings i_soc2010_count, by(statefip year occsoc)
merge 1:1 statefip year occsoc using `a'
assert expreq==0 if _m==1
drop _m

merge 1:1 statefip year occsoc using `b'
assert edureq==0 if _m==1
drop _m


label variable i_soc2010_count "number of unique SOC2010 in SOC2000 aggregation"
unique occsoc // 800

/*Occupation Names*/
*2010 names
preserve
import excel soc2000 soc2000_name soc2010 soc2010_name using soc_2000_to_2010_crosswalk.xlsx, clear cellrange(A9:D868) allstring
duplicates drop soc2010, force
gen occsoc=soc2010
gen soc_name=soc2010_name
tempfile b
save `b', replace
restore

*2000 names
preserve
import excel soc2000 soc2000_name soc2010 soc2010_name using soc_2000_to_2010_crosswalk.xlsx, clear cellrange(A9:D868) allstring
duplicates drop soc2000, force
gen occsoc=soc2000
gen soc_name=soc2000_name
tempfile c
save `c', replace
restore

merge m:1 occsoc using `b', keepusing(soc_name) gen(_m1) keep(master match)
merge m:1 occsoc using `c', keepusing(soc_name) gen(_m2) update keep(master match match_update match_conflict)
assert soc_name!=""
drop _m1 _m2

/*STATEFIP CODES*/
merge m:1 statefip using ./reference/statefips.dta, keep(match) nogen keepusing(st state)

save $pathUPS/revised_paper/data/temp/bgt_state_occ_2007_2010_2012_collapsed.dta, replace

/********************************
3. PRELIMINARY DATA WORK 
********************************/

use bgt_state_occ_2007_2010_2012_collapsed.dta, clear

/*PRELIMINARY VARIABLE CREATION*/

gen occsoc_minor=substr(occsoc,1,3)
replace occsoc_minor="396" if occsoc_minor=="397" // change for tour guides in 2010

gen occsoc_broad=substr(occsoc,1,2)
destring occsoc_broad, replace

gen occsoc_broadgroup=2 if occsoc_broad>=11 & occsoc_broad<=13
replace occsoc_broadgroup=3 if occsoc_broad>=15 & occsoc_broad<=29
replace occsoc_broadgroup=4 if occsoc_broad>=31 & occsoc_broad<=39
replace occsoc_broadgroup=5 if occsoc_broad>=41 & occsoc_broad<=43
replace occsoc_broadgroup=6 if occsoc_broad>=45 & occsoc_broad<=49
replace occsoc_broadgroup=7 if occsoc_broad>=51 & occsoc_broad<=53
label variable occsoc_broadgroup "Groups of 2-digit SOC CODES- for HWOL data merge"

tostring occsoc_broad, replace

encode occsoc, gen(occsoc_num)


/********************************
5. MERGE IN DATA
********************************/

merge m:1 statefip year using bls_state_laborforce_statistics_2007_2014.dta, keep(master match) gen(_m_bls)
assert _m_bls==3
drop _m_bls
foreach var of varlist s_totalpop s_laborforce s_employment s_unemployment s_unemprate {
note `var': "bls_state_laborforce_statistics_2007_2014.dta"
}

/*BLS OCCUPATIONAL EMPLOYMENT STATISTICS*/
merge 1:1 statefip year occsoc using oes_wage_employment.dta, keep(master match) gen(_m_oes)
rename tot_emp s_occ_emp
foreach var of varlist h_mean a_mean h_pct25 h_median h_pct75 a_pct25 a_median a_pct75 s_occ_emp {
note `var': "oes_wage_employment.dta"
}

/*MINOR OCCUPATION NAMES*/
preserve
import excel occupation_master_list.xlsx, sheet("occsocminor") firstrow clear allstring
tempfile b
save `b'
restore
merge m:1 occsoc_minor using `b', keep(master match) nogen


/*ACS COVARIATES*/

* UR BY EDUCATION
merge m:1 statefip year using  acs_ur_state_educ_year.dta, keep(master match)  keepusing(unemprate_bd) gen(_m_acs)
assert _m_acs==3
drop _m_acs
note unemprate_bd: "acs_ur_state_educ_year.dta"

* TRADED/NON-TRADED
merge m:1 occsoc_minor using acs_traded_nontraded_occsocminor.dta, keep(master match) gen(_m_traded)
assert _m_traded==3
drop _m_traded
note traded: "acs_traded_nontraded_occsocminor.dta"
note nontraded: "acs_traded_nontraded_occsocminor.dta"
merge m:1 occsoc using oes_traded_nontraded_occsocminor.dta, keep(master match) nogen

/*BLS COVARIATES: UR BY AGE*/
merge m:1 statefip year using bls_ur_state_age35plus_2007_2013.dta, keep(master match) gen(_m_blsageur)
assert _m_blsageur==3
drop _m_blsageur
note unemprate_35plus: "bls_ur_state_age35plus_2007_2013.dta"

/*CPS COVARIATES*/
preserve
use cps_allcovars.dta, clear
duplicates drop statefip avgage2000 bdshare2000, force
tempfile d
save `d', replace
restore 

merge m:1 statefip using `d', keep(master match) keepusing(avgage2000 bdshare2000) gen(_m_cps)
assert _m_cps==3
drop _m_cps
note avgage2000: "cps_allcovars.dta"
note bdshare2000: "cps_allcovars.dta"

/*VET OCCUPATION SHARES*/
merge m:1 occsoc using acs3yr_2005to2007_veteran_employment_shares.dta, gen(_m_vetshare) keep(master match)
assert _m_vetshare==3
drop _m_vetshare
foreach var of varlist occsoc countcivilian countveteran_post911 civilian_share vetshare_osve totaloccsoc vetshare_vsoe {
note `var': "acs3yr_2005to2007_veteran_employment_shares.dta"
}

/*VET Supply Shock and Supply/Demand Rate*/
merge m:1 statefip year occsoc_broadgroup using acs_vet_supdemrate_occsocbroad_year_allmeasures.dta, keep(master match) gen(_m_vetshock)
assert _m_vetshock==3
drop _m_vetshock
foreach var of varlist vet_supdem_hwol_pums vet_supdem_bgt_pums vet_stlf1yr vet_supdem_hwol vet_supdem_bgt hwol_occsocbroad_to bgt_occsocbroad_to vet_stpopsf vet_supdem_hwol_bp vet_supdem_bgt_bp occsoc_broadgroup vet_bplf1yr {
note `var': "acs_vet_supdemrate_occsocbroad_year_allmeasures.dta"
}

/*HWOL SUPDEM RATE*/
merge m:1 statefip year occsoc_broadgroup using hwol_supdemrate_state_year_occsoc_broadgroup_newads.dta, keep(master match) nogen assert(2 3)
note HWOLsupdemrate_occsoc_broad: "hwol_supdemrate_state_year_occsoc_broadgroup_newads.dta"

merge m:1 statefip year using hwol_supdemrate_state_year_nsa.dta, keep(master match) nogen assert(2 3)
note HWOLsupdemrate: "hwol_supdemrate_state_year_nsa.dta"

/*BGT SUPDEM RATE*/
merge m:1 statefip year occsoc_broadgroup using bgt_supdemrate_state_year_occsoc_broadgroup.dta, keep(master match) nogen assert(2 3)
rename LIsupdemrate_occsoc_broad BGTsupdemrate_occsoc_broad
note BGTsupdemrate_occsoc_broad: "bgt_supdemrate_state_year_occsoc_broadgroup.dta"

merge m:1 statefip year using bgt_supdemrate_state_year.dta, keep(master match) nogen assert(2 3)
rename LIsupdemrate BGTsupdemrate
note BGTsupdemrate: "/data/merge/bgt_supdemrate_state_year.dta"

/*CPS UNEMPLOYMENT*/
merge m:1 statefip year using cps_reasonsforunemp.dta, keep(master match) nogen
note share_unemp_bdplus: "cps_reasonsforunemp.dta"
label variable share_unemp_bdplus "state share of unemployed workers with BD+"

/*CPS EMPLOYMENT*/
merge m:1 statefip year using cps_educ_foremp.dta, keep(master match) nogen
note share_emp_bdplus: "/data/merge/cps_reasonsforemp.dta"
label variable share_emp_bdplus "state share of employed workers with BD+"

/********************************
6. LABELS VARIABLES AND CLEAN DATA 
********************************/
label variable occsoc "occupation code: combination of 5/6 digit SOC codes"
label variable occsoc_minor "SOC: minor, 3 digit level"
label variable occsoc_broad "SOC: major, 2 digit level"

label variable s_unemprate "State UR"
label variable s_totalpop "State Total Population"
label variable s_laborforce "State Total LF"
label variable s_employment "State Total Emp"
label variable s_unemployment "State Total Unemployment Level"
rename unemprate_bd s_unemprate_bd
label variable s_unemprate_bd "State UR for Workers with BD+"
rename unemprate_35plus s_unemprate_35plus
label variable s_unemprate_35plus "State UR for Workers 35+"

gen exp_lt2=exp_lt5-exp_2to5
label variable exp_lt2 "experience: <2 yrs"
label variable exp_2to5 "experience: 2to5 yrs"
label variable exp_5to8 "experience: 5to8 yrs"
label variable exp_8plus "experience: >8 yrs"
label variable exp_na "experience: not available"
label variable educ_bd "education: bachelors degree"
label variable educ_gd "education: graduate degree"
label variable educ_unknown "education: unknown"
label variable educ_bd_gd "education: bachelors + graduate"
label variable totalopenings "total number of postings"

rename soc_name occsoc_name
replace occsoc_name=trim(occsoc_name)
label variable occsoc_name "Occupation (occsoc) Name"

replace occsoc_minor_name=trim(occsoc_minor_name)
label variable occsoc_minor_name "Occupation (occsoc_minor) Name"

label variable bdshare2000 "Share of State Population with BD in 2000"
label variable avgage2000 "Average Age of State Population in 2000"

label variable HWOLsupdemrate_occsoc_broad "HWOL sup/dem rate for broad occs: [(annual#postings)/12]/[broad occsoc unemplevel]"

label variable HWOLsupdemrate "HWOL sup/dem rate: annual average of monthly (NSA) estimates"

label variable BGTsupdemrate_occsoc_broad "LI sup/dem rate for broad occs: [(annual#postings)/12]/[broad occsoc unemplevel]"

label variable BGTsupdemrate "LI sup/dem rate: [(annual#postings)/12]/[state unemplevel]"

label variable traded "minor occ traded share"
label variable nontraded "minor occ non-traded share"

foreach var of varlist s_occ_emp h_mean a_mean h_pct25 h_median h_pct75 a_pct25 a_median a_pct75 {
label variable `var' "OES state/occ level data"
}

/********************************
DATASET CREATION
********************************/

sort statefip year occsoc
egen panelid=group(occsoc statefip)
xtset panelid year

save allyear_tempfile_final.dta, replace

foreach dataset in 2007_2010 2010_2012 /*2010_2011 2011_2012 2012_2013 2010_2013 2007_2012 2012_2014*/ {
set varabbrev off
	use $pathUPS/revised_paper/data/temp/allyear_tempfile_final.dta, clear
	xtset panelid year

	if "`dataset'"=="2007_2010" {
		keep if year==2007 | year==2010
		local lag "L3."
	}

	if "`dataset'"=="2010_2012" {
		keep if year==2010 | year==2012
		local lag "L2."
	}

	if "`dataset'"=="2010_2011" {
		keep if year==2010 | year==2011
		local lag "L1."
	}

	if "`dataset'"=="2011_2012" {
		keep if year==2011 | year==2012
		local lag "L1."
	}

	if "`dataset'"=="2012_2013" {
		keep if year==2012 | year==2013
		local lag "L1."
	}

	if "`dataset'"=="2010_2013" {
		keep if year==2010 | year==2013
		local lag "L3."
	}

	if "`dataset'"=="2007_2012" {
		keep if year==2007 | year==2012
		local lag "L5."
	}
	
	if "`dataset'"=="2012_2014" {
		keep if year==2012 | year==2014
		local lag "L2."
	}


	/*COVARIATES*/
	
	*****Supply Shocks*****
	
	*difference in state unemployment rate
	gen du =  s_unemprate-`lag's_unemprate
	gen dubd = s_unemprate_bd-`lag's_unemprate_bd
	gen du35plus= s_unemprate_35plus-`lag's_unemprate_35plus

	*difference in HWOL supply/demand rate
	gen pHWOLsupdemrate=ln(HWOLsupdemrate)-ln(`lag'HWOLsupdemrate)
	*gen pHWOLsupdemrate=[HWOLsupdemrate -`lag'HWOLsupdemrate]/`lag'HWOLsupdemrate
	label variable pHWOLsupdemrate "% change  in HWOL supdemrate (t+n)-t"

	gen dHWOLsupdemrate=[HWOLsupdemrate -`lag'HWOLsupdemrate]
	label variable dHWOLsupdemrate "change  in HWOL supdemrate (t+n)-t"

	gen pHWOLsupdemratebroad=ln(HWOLsupdemrate_occsoc_broad)-ln(`lag'HWOLsupdemrate_occsoc_broad)
	*gen pHWOLsupdemratebroad=[HWOLsupdemrate_occsoc_broad-`lag'HWOLsupdemrate_occsoc_broad]/`lag'HWOLsupdemrate_occsoc_broad
	label variable pHWOLsupdemratebroad "% change  in BroadOCC HWOL supdemrate (t+n)-t"

	gen dHWOLsupdemratebroad=[HWOLsupdemrate_occsoc_broad-`lag'HWOLsupdemrate_occsoc_broad]
	*gen dHWOLsupdemratebroad_cps=[HWOLsupdemrate_occsoc_broad_cps-`lag'HWOLsupdemrate_occsoc_broad_cps]
	label variable dHWOLsupdemratebroad "change  in BroadOCC HWOL supdemrate (t+n)-t"


	*difference in LI supply/demand rate
	*gen pBGTsupdemrate=ln(BGTsupdemrate)-ln(`lag'BGTsupdemrate)
	gen pBGTsupdemrate=[BGTsupdemrate -`lag'BGTsupdemrate]/`lag'BGTsupdemrate
	label variable pBGTsupdemrate "% change in LI supdemrate (t+n)-t"

	gen dBGTsupdemrate=[BGTsupdemrate -`lag'BGTsupdemrate]
	label variable dBGTsupdemrate "change in LI supdemrate (t+n)-t"

	*gen pBGTsupdemratebroad=ln(BGTsupdemrate_occsoc_broad)-ln(`lag'BGTsupdemrate_occsoc_broad)
	gen pBGTsupdemratebroad=[BGTsupdemrate_occsoc_broad-`lag'BGTsupdemrate_occsoc_broad]/`lag'BGTsupdemrate_occsoc_broad
	label variable pBGTsupdemratebroad "% change  in BroadOCC LI supdemrate (t+n)-t"

	gen dBGTsupdemratebroad=[BGTsupdemrate_occsoc_broad-`lag'BGTsupdemrate_occsoc_broad]
	label variable dBGTsupdemratebroad "% change  in BroadOCC LI supdemrate (t+n)-t"

	/*VET SHOCKS*/

	gen dvet_stlf1yr=[vet_stlf1yr-`lag'vet_stlf1yr]
	gen dvet_stpopsf=vet_stpopsf-`lag'vet_stpopsf
	gen dvet_bplf1yr=vet_bplf1yr-`lag'vet_bplf1yr
		
	gen ldvet=ln(vet_stpopsf)-ln(`lag'vet_stpopsf)
	gen ldvet_vsoe=ldvet*vetshare_vsoe
	gen ldvet_osve=ldvet*vetshare_osve

	gen ldvet_bp=ln(vet_bplf1yr)-ln(`lag'vet_bplf1yr)
	gen ldvet_vsoe_bp=ldvet_bp*vetshare_vsoe
	gen ldvet_osve_bp=ldvet_bp*vetshare_osve
	
	gen ldvet_pums=ln(vet_stlf1yr)-ln(`lag'vet_stlf1yr)
	gen ldvet_vsoe_pums=ldvet_pums*vetshare_vsoe
	gen ldvet_osve_pums=ldvet_pums*vetshare_osve
	
	gen dvet_shock=(vet_stpopsf/totalopenings-`lag'vet_stpopsf/`lag'totalopenings)*vetshare_vsoe
	gen dvet_shock_bp=(vet_bplf1yr/totalopenings-`lag'vet_bplf1yr/`lag'totalopenings)*vetshare_vsoe
	gen dvet_shock_pums=(vet_stlf1yr/totalopenings-`lag'vet_stlf1yr/`lag'totalopenings)*vetshare_vsoe
	
	label variable ldvet "(log diff # vets)"
	label variable ldvet_vsoe "(log diff # vets)*(vetshare OCC emp)"
	label variable ldvet_osve "(log diff # vets)*(occshare VET emp)"

	gen dvetsperopening=[vet_stlf1yr-`lag'vet_stlf1yr]/totalopenings
	gen dvetsperopening_vsoe=dvetsperopening*vetshare_vsoe
	gen dvetsperopening_osve=dvetsperopening*vetshare_osve

	label variable dvetsperopening "(difference in #vets)/totalopenings"
	label variable dvetsperopening_vsoe "[(difference in #vets)/totalopenings]*[vetshare OCC emp]"
	label variable dvetsperopening_osve "[(difference in #vets)/totalopenings]*[occshare VET emp]"

	foreach var of varlist vet_supdem_bgt vet_supdem_hwol vet_supdem_bgt_bp vet_supdem_hwol_bp vet_supdem_bgt_pums vet_supdem_hwol_pums {
		gen d`var'=`var'-`lag'.`var'
	}

	/*CONTROLS*/
	gen lto=`lag'totalopenings
	gen minto=min(lto,totalopenings)
	gen dto = totalopenings-lto
	label variable lto "first period total openings"
	label variable minto "minimum total openings: first vs. second period"
	label variable dto "difference in total openings: second-first period"

	gen coded_edu=(edureq)/totalopenings
	gen coded_exp=(expreq)/totalopenings
	label variable coded_edu "share of total postings with coded educational qualifications"
	label variable coded_exp "share of total postings with coded experience qualifications"

	gen mcoded_edu=min(coded_edu, `lag'coded_edu)
	gen mcoded_exp=min(coded_exp, `lag'coded_exp)
	label variable coded_edu "min. [t,t-n] share of total postings with coded educational qualifications"
	label variable coded_exp "min. [t,t-n] share of total postings with coded experience qualifications"

	gen openings_per_emp=totalopenings/s_occ_emp
	label variable openings_per_emp "total postings/ state-occupation total employment"

	/*WEIGHTING STRUCTURE*/
	*weight based on industry share of total state job postings 
	gen ato=(lto+totalopenings)/2
	egen state_ato=sum(ato), by (statefip year)
	gen occshare_state_ato=(ato/state_ato)
	drop ato state_ato
	label variable occshare_state_ato "occupation share of state's average total openings"

	/*WAGES*/
	gen dhwagepremium=ln(h_pct75/h_pct25)-ln(`lag'h_pct75/`lag'h_pct25)
	label variable dhwagepremium "difference in hourly wage premium"

	gen dh_mean=ln(h_mean/`lag'h_mean)
	label variable dh_mean "difference in mean hourly wage"
	
	/*CPS REASONS*/
	gen dshare_unemp_gtbd=share_unemp_bdplus-`lag'share_unemp_bdplus
	gen dshare_emp_gtbd=share_emp_bdplus-`lag'share_emp_bdplus

	
	/*DEPENDENT VARIABLES*/
	gen neednoedu=((totalopenings-edureq)/totalopenings)*100
	foreach type in hs sc bd ma phd {
	gen need`type'=(edu`type'/totalopenings)*100
	}
	
	egen needgths=rowtotal(needsc needbd needma needphd)
	egen needbd_plus = rowtotal(needbd needma needphd)
	egen needgd=rowtotal(needma needphd)	

	gen needna=((totalopenings-expreq)/totalopenings)*100
	foreach type in 0to1 1to2 2to3 3to5 5to7 7to15 {
	gen need`type'=(exp_`type'/totalopenings)*100
	}
	
	egen need2= rowtotal(need2to3 need3to5 need5to7 need7to15)
	egen need5= rowtotal(need5to7 need7to15)
	egen need3= rowtotal(need3to5 need5to7 need7to15)
	
	label variable needbd "share of job postings requesting BD"
	label variable needbd_plus "share of job posting pref. BD+"
	label variable need5 "share of jobs postings requiring at least 5 years experience"
	label variable need2 "share of jobs postings requiring at least 2 years experience"

	foreach var of varlist needbd_plus needgd needgths need2 need5 need3 ///
	need0to1 need1to2 need2to3 need3to5 need5to7 need7to15 ///
	needhs needbd needma needphd needsc needna neednoedu  {
		gen d`var'=`var'-`lag'`var'
	}

	/*
	/*ROBUST CHECK VARS*/

	gen needba_coded = ((educ_bd + educ_gd)/(totalopenings-educ_unknown))*100
	gen needba_pref_coded = ((educ_bd_gd)/(totalopenings-educ_unknown))*100
	*gen needba_req_coded = ((totalopenings-educ_hd_ad-educ_unknown)/(totalopenings-educ_unknown))*100

	gen need5_coded= ((exp_5to8 + exp_8plus)/(totalopenings-exp_na))*100
	gen need2_coded= ((exp_2to5 + exp_5to8 + exp_8plus)/(totalopenings-exp_na))*100
	gen need2to5_coded= ((exp_2to5)/(totalopenings-exp_na))*100

	gen dneedba_pref_coded=needba_pref_coded-`lag'needba_pref_coded
	*gen dneedba_req_coded=needba_req_coded-`lag'needba_req_coded
	gen dneed5_coded=need5_coded-`lag'need5_coded
	gen dneed2_coded=need2_coded-`lag'need2_coded
	gen dneed2to5_coded=need2to5_coded-`lag'need2to5_coded
	*/

	save BGT_`dataset'_withvars.dta, replace
}





/*******************
2007-2010; 2010-2012
********************/

use BGT_2010_2012_withvars.dta, clear
keep if year==2012
append using BGT_2007_2010_withvars.dta

preserve
collapse (sum) totalopenings, by(state occsoc)
bys state: egen total=total(totalopenings)
gen occshare_state=totalopenings/total
label variable occshare_state "Occupation Share of State's Total Openings (WEIGHT)"
tempfile a
save `a', replace
restore

merge m:1 state occsoc using `a', keepusing(occshare_state) nogen

sort state year occsoc
xtset panelid year

gen initial_openings_per_emp=L3.openings_per_emp if year==2010
replace initial_openings_per_emp=L5.openings_per_emp if year==2012
label variable initial_openings_per_emp "2007 number of postings per employee"
	   
foreach var of varlist neednoedu needhs needsc needbd needma needphd needgths needbd_plus ///
needgd needna need0to1 need1to2 need2to3 need3to5 need5to7 need7to15 need2 need5 need3 {
gen initial_`var'07=L3.`var' if year==2010
replace initial_`var'07=L5.`var' if year==2012
}


gen hwagepremium_07=ln(L3.h_pct75/L3.h_pct25) if year==2010
replace hwagepremium_07=ln(L5.h_pct75/L5.h_pct25) if year==2012

gen h_mean_07=ln(h_mean/h_mean) if year==2007
bys panelid: carryforward h_mean_07, replace

gen change_openings_per_emp=(F2.totalopenings-L3.totalopenings)/L3.s_occ_emp if year==2010
replace change_openings_per_emp=(totalopenings-L5.totalopenings)/L5.s_occ_emp if year==2012
label variable change_openings_per_emp "Change in Number of Postings per employed person"

gen estsample=0
replace estsample=1 if (year==2010 | year==2012) & change_openings_per_emp!=. & minto>15 & du!=.
label variable estsample "dummy: identifies observations in main specifications (used for change summary stats)"

gen sumsample=estsample
replace sumsample=1 if F3.estsample==1
label variable sumsample "dummy: identifies observations to be used for level summary statistics"


*fixed effects
capture egen styear=group(state year)
capture egen occyear=group(occsoc year)
capture egen occst=group(occsoc state)


saveold BGT_2007_2010_2012_withvars_122815.dta, replace version(11)
