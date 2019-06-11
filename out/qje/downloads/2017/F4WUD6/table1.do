clear
set more off 

capture program drop makestars
program define makestars, rclass
	syntax , Pointest(real) PVal(real) [bdec(integer 3)]
	**** Formats the coefficient with stars

	local fullfloat = `bdec' + 1
	
	local outstr = string(`pointest',"%`fullfloat'.`bdec'f")
	
	if `pval' <= 0.01 {
		local outstr = "`outstr'" + "***"
	}
	else if `pval' <= 0.05 {
		local outstr = "`outstr'" + "**"
	}
	else if `pval' <= 0.1 {
		local outstr = "`outstr'" + "*"
	}	
		
	return local coeff = "`outstr'"
		
end

***---Create table structure
capture program drop rowtitles
program define rowtitles
	g rowtitle = ""
	for num 1/2: g outcolX = ""
	g indexnum = _n
	
	*Pre-period Bombing
	replace rowtitle = "Bombing" if indexnum == 1
	
	*Security characteristics
	replace rowtitle = "Security LCA" if indexnum == 2
	replace rowtitle = "Enemy Forces Present" if indexnum == 3
	replace rowtitle = "Village Guerrilla Squad" if indexnum == 4
	replace rowtitle = "VC Main Force Squad" if indexnum == 5
	replace rowtitle = "VC Base Nearby" if indexnum == 6
	replace rowtitle = "VC Attack" if indexnum == 7
	replace rowtitle = "Active VC Infrastructure" if indexnum == 8
	replace rowtitle = "\% Households Participate VC" if indexnum == 9
	replace rowtitle = "VC Propoganda" if indexnum == 10
	replace rowtitle = "VC Taxation" if indexnum == 11
	
	**Troop characteristics
	replace rowtitle = "Friendly Forces Nearby" if indexnum == 12
	replace rowtitle = "US Operations" if indexnum == 13
	replace rowtitle = "US Initiated Attacks" if indexnum == 14
	replace rowtitle = "US Deaths" if indexnum == 15
	replace rowtitle = "SVN Deaths" if indexnum == 16
	replace rowtitle = "VC Deaths" if indexnum == 17
	
	**Governance
	replace rowtitle = "Administration LCA" if indexnum == 18
	replace rowtitle = "Local Government Taxes" if indexnum == 19
	replace rowtitle = "Village Committee Filled" if indexnum == 20
	replace rowtitle = "Local Chief Visits Hamlet" if indexnum == 21
	replace rowtitle = "Education LCA" if indexnum == 22
	replace rowtitle = "Primary School Access" if indexnum == 23
	replace rowtitle = "Secondary School Access" if indexnum == 24
	replace rowtitle = "Health LCA" if indexnum == 25
	replace rowtitle = "Public Works Under Construction" if indexnum == 26
	
	**Civic Socity
	replace rowtitle = "Civic Society LCA" if indexnum == 27
	replace rowtitle = "HH Participation in Civic Orgs" if indexnum == 28
	replace rowtitle = "HH Participation in PSDF" if indexnum == 29
	replace rowtitle = "HH Participation in Econ Training" if indexnum ==30
	replace rowtitle = "HH Participation in Devo Projects" if indexnum == 31
	replace rowtitle = "Self Devo Projects Underway" if indexnum == 32
	replace rowtitle = "Youth Organization Exists" if indexnum == 33
	replace rowtitle = "Council Meets Regularly with Citizens" if indexnum ==34
	
	**Economics
	replace rowtitle = "Economic LCA" if indexnum == 35
	replace rowtitle = "Non-Rice Food Available" if indexnum == 36
	replace rowtitle = "Manufactures Available" if indexnum == 37
	replace rowtitle = "Surplus Goods Produced" if indexnum ==38
	replace rowtitle = "Fields Fallow Due to Insecurity" if indexnum == 39
	replace rowtitle = "HH With Motorized Vehicle" if indexnum == 40
	replace rowtitle = "HH Require Assistance to Subsist" if indexnum == 41
	replace rowtitle = "Hamlet Population Growth" if indexnum ==42
	
	**Demographics
	replace rowtitle = "Urban" if indexnum == 43
	
	**Demographics
	replace rowtitle = "\textbf{Observations}" if indexnum == 46
end

******Immed spc (bombing)
do plac_fs .2 1 1
rowtitles
local i=1

reg fr_strikes_mean below md_* ab bc cd de i.qdate vmb22-vt54 [aw=oweight20], nocons cluster(villageid)	
local colnum = 2
local tval = (_b[below]/_se[below])	
local pval = 2*ttail(e(df_r),abs(`tval'))
replace outcol`colnum' = "'(" + string(_se[below],"%4.3f") + ")" if indexnum == `i'	
local pe = _b[below]
makestars,pointest(`pe') pval(`pval') bdec(3)
local colnum = 1
replace outcol`colnum' = r(coeff) if indexnum == `i'
keep outcol* indexnum rowtitle
keep if indexnum==`i'
tempfile f`i'
save `f`i'', replace

******Cum spec (bombing)
do plac_fs .2 1 16
for num 3/4: g outcolX = ""
g indexnum = _n

reg fr_strikes_mean below md_* ab bc cd de i.qdate vmb22-vt54 [aw=oweight20], nocons cluster(villageid)	
local colnum = 4
local tval = (_b[below]/_se[below])	
local pval = 2*ttail(e(df_r),abs(`tval'))
replace outcol`colnum' = "'(" + string(_se[below],"%4.3f") + ")" if indexnum == `i'	
local pe = _b[below]
local pval = `pval'
makestars,pointest(`pe') pval(`pval') bdec(3)
local colnum = 3
replace outcol`colnum' = r(coeff) if indexnum == `i'
keep outcol* indexnum 
keep if indexnum==`i'
tempfile temp
save `temp', replace

use `f`i'', clear
merge 1:1 indexnum using `temp'
drop _merge
save `f`i'', replace

*prep data
do plac_out .2 1 1 12 /*last # doesn't matter since RF and not ussing bombing*/
do plac_out .2 1 16 12 /*last # doesn't matter since RF and not ussing bombing*/


foreach V in sec_p1 en_pres guer_squad  mainforce_squad  en_base  all_atk  vc_infr_vilg  part_vc_cont  en_prop  entax_vilg  fr_forces_mean  fw_opday_dummy  fw_init  fw_d  fr_d  en_d admin_p1  gvn_taxes  village_comm  chief_visit  educ_p1  prim_access  sec_school_vilg  health_p1  pworks_under_constr  soccap_p1  civic_org_part  phh_psdf  econ_train  self_dev_part  selfdev_vilg  youth_act  vilg_council_meet econ_p1  nonrice_food  manuf_avail  surplus_goods  nofarm_sec  p_own_vehic  p_require_assist  pop_g urban {
	
	******Immed spc 
	use placout1, clear
	rowtitles
	local i=`i'+1
	di "`i'"
	
	reg `V' below md_* ab bc cd de i.qdate vmb22-vt54 [aw=oweight20], nocons cluster(villageid)	
	
	local colnum = 2
	local tval = (_b[below]/_se[below])	
	local pval = 2*ttail(e(df_r),abs(`tval'))
	replace outcol`colnum' = "'(" + string(_se[below],"%4.3f") + ")" if indexnum == `i'	
	local pe = _b[below]
	local pval = `pval'
	makestars,pointest(`pe') pval(`pval') bdec(3)
	local colnum = 1
	replace outcol`colnum' = r(coeff) if indexnum == `i'
	keep outcol* indexnum rowtitle
	keep if indexnum==`i'
	tempfile f`i'
	save `f`i'', replace
	
	******Cum spec 
	use placout16, clear
	for num 3/4: g outcolX = ""
	g indexnum = _n
	
	reg `V' below md_* ab bc cd de i.qdate vmb22-vt54 [aw=oweight20], nocons cluster(villageid)	
	local colnum = 4
	local tval = (_b[below]/_se[below])	
	local pval = 2*ttail(e(df_r),abs(`tval'))
	replace outcol`colnum' = "'(" + string(_se[below],"%4.3f") + ")" if indexnum == `i'	
	local pe = _b[below]
	local pval = `pval'
	makestars,pointest(`pe') pval(`pval') bdec(3)
	local colnum = 3
	replace outcol`colnum' = r(coeff) if indexnum == `i'
	keep outcol* indexnum 
	keep if indexnum==`i'
	tempfile temp
	save `temp', replace
	
	use `f`i'', clear
	merge 1:1 indexnum using `temp'
	drop _merge
	save `f`i'', replace
}

use `f1', clear
foreach N of num 2/`i' {
	di `N'
	append using `f`N''
}

outsheet rowtitle outcol1 outcol2 outcol3 outcol4 using table_balance.out, replace noquote 


	