/*** This Stata .do file uses regression results and claims data to quantify: 
	a) the internal savings effect of Part D for seniors who became insured due to Part D, 
	b) the external spillover effects of lower unit prices on the commercial population; and 
	c) the savings to previously insured seniors who benefit from the lower unit price. ***/
	
	
	
*** I. Three effects of Part D related enrollment increases on Total Expenditures ***
	*A. Internal Effects on Cash Payers to Part D Enrollees
		* -need to know beta = the average percentage reduction in expenditures for a former cash paying senior, now in PDP
	*B1. External Effects on previously insured seniors thru price effects
		* -need to know beta = the average percentage reduction in expenditures due to enrollment increase for a continuously commerically enrolled senior 
		* -need to know alpha = how much of the commercial market is covered by insurers who partake in Part D
	*B2. External Effects on non senior commercial enrollees
		* -need to know beta = the average percentage reduction in expenditures due to enrollment increase for a continuously commerically enrolled non-senior
		* -need to know alpha = how much of this commercial market is covered by insurers who partake in Part D

*** II. alpha and betas from parts A, B1 and B2 applied to expenditures in MEPS, which as nationally representative expenditure shares by group
	* Declines in total Expenditures due to Part D then decomposed into A, B1 and B2

*B1. External Effects on previously insured seniors thru price effects
	* Use preferred specification from paper = non-linear full sample
	* i. predict change in log prices assuming the only thing that changes is the increases in insurer enrollment observed in data
	* ii. sum across all firm_drugs: SUM(baseline expenditures_ndc_firm * predicted change in price_ndc_firm)
	* iii. determine aggregate baseline expenditures within regression sample, and within all WG sample
	* iv: output 1, beta: percentage change in expenditures (equivalent to an ndc-expenditure-weighted change in log prices)
	* iv. output 2, alpha: estimate of how much of this commercial market is covered by insurers who partake in Part D 

	use claims_enrollment_merged_nation, clear
		ivreg2 cl_rm_pill_ndc_firm6254 cl_qty_rx_ndc_firm6254 cl_share_exposure_WG6254 cl_adj_awp_pill_ndc6254  (enrollment_total_1m_2006 enrollment_total_1m_2006_2 = adjfe_log adjfe_log2 noseniors_firm_noprivhi_06M noseniors_firm_noprivhi_06M_2) [pweight=ndc_firm_ind_wt6254] if  (samplemergedd == 1 | wellmark == 2) & rank <= 1000 & _merge_marketsizeiv == 3 & _merge_marketsizeiv2 == 3  & _merge_therap_class == 3 &  _merge_predictederrors == 3 & adjfe_log ~= ., cluster(parent_organization_id)		
		gen cl_rm_pill_ndc_firm6254_predict = _b[enrollment_total_1m_2006]*enrollment_total_1m_2006 + _b[enrollment_total_1m_2006_2]*enrollment_total_1m_2006_2 
		egen totalexp_post = sum(totalrm_ndc_firm*(1+cl_rm_pill_ndc_firm6254_predict))	if e(sample) == 1
		egen totalexp_pre = sum(totalrm_ndc_firm)	if e(sample) == 1
		* beta = (totalexp_post - totalexp_pre)/totalexp_pre is an estimate of the percentage decline in expenditures for enrollees in insurers partaking in Part D
		gen beta = (totalexp_post - totalexp_pre)/totalexp_pre if e(sample) == 1

	*browse nbr_ndc parent_organization_id cl_rm_pill_ndc_firm6254 cl_rm_pill_ndc_firm6254_predict if e(sample) == 1

	egen totalexp_pre_allmarket = sum(totalrm_ndc_firm)	
		* alpha = (totalexp_pre/totalexp_pre_allmarket) is  an estimate of the percentage of the entire commercial market enrollees in insurers partaking in Part D
		* alpha is an underestimate because this sample does not include all Part D insurers even within WG
		gen alpha = (totalexp_pre/totalexp_pre_allmarket) 
		*add UHC Pacificare into Numerator
		egen totalexp_pre2 = sum(totalrm_ndc_firm)	if (e(sample) == 1 | parent_organization_id == 240)
		gen alpha2 = (totalexp_pre2/totalexp_pre_allmarket) 
	sum beta alpha alpha2 totalexp*
	*** beta = -0.08542
	*** alpha = 0.31063
	*** alpha = 0.40066
	drop cl_rm_pill_ndc_firm6254_predict totalexp_post totalexp_pre beta totalexp_pre_allmarket alpha
	
	use cleansenior-2005-8-s, clear
	append using cleansenior-2005-9-s
	append using cleansenior-2005-10-s
	append using cleansenior-2005-11-s
		*these data are claims data for seniors in pharmacy claims extract, for Augsut, Sept, October and November of the year prior to the implementation of Part D
	egen totalexpenditures = sum(amt_total_reimburse)
		* alpha3 = (totalexp_pre/totalexpenditures) is a second estimate of the percentage of the entire commercial market enrollees in insurers partaking in Part D
		* but this may not compare apples to apples, given that the sample used in the num and dem of alpha2 were not developed using the same sample criteria
		gen alpha2 = (totalexp_pre/totalexpenditures)
	
	
*B2. External Effects on non senior commercial enrollees
	* Use preferred specification from paper = non-linear full sample
	* i. predict change in log prices assuming the only thing that changes is the increases in insurer enrollment observed in data
	* ii. sum across all firm_drugs: SUM(baseline expenditures_ndc_firm * predicted change in price_ndc_firm)
	* iii. determine aggregate baseline expenditures within regression sample, and within all WG sample
	* iv: output 1, beta: percentage change in expenditures (equivalent to an ndc-expenditure-weighted change in log prices)
	* iv. output 2, alpha: estimate of how much of this commercial market is covered by insurers who partake in Part D 

	* Note that this sample corresponds to only the 60-64 year olds; 
		* hence, this section assumes that 00-60 year olds are distributed across Part D insurers in a way similar to 60-64 year olds
		* and assumes that 00-60 year olds use drugs that are affected by Part D enrollment in the same way as drugs consumed by 60-64 year olds

	use claimscom_enrollment_merged_nation, clear
	ivreg2 cl_rm_pill_ndc_firm6254 cl_qty_rx_ndc_firm6254 cl_share_exposure_WG6254 cl_adj_awp_pill_ndc6254  (enrollment_total_1m_2006 enrollment_total_1m_2006_2 = adjfe_log adjfe_log2 noseniors_firm_noprivhi_06M noseniors_firm_noprivhi_06M_2) [pweight=ndc_firm_ind_wt6254] if  (samplemergedd == 1 | wellmark == 2) & rank <= 1000 & _merge_marketsizeiv == 3 & _merge_marketsizeiv2 == 3  & _merge_therap_class == 3 &  _merge_predictederrors == 3 & adjfe_log ~= ., cluster(parent_organization_id)		
		gen cl_rm_pill_ndc_firm6254_predict = _b[enrollment_total_1m_2006]*enrollment_total_1m_2006 + _b[enrollment_total_1m_2006_2]*enrollment_total_1m_2006_2 
		egen totalexp_post = sum(totalrm_ndc_firm*(1+cl_rm_pill_ndc_firm6254_predict))	if e(sample) == 1
		egen totalexp_pre = sum(totalrm_ndc_firm)	if e(sample) == 1
		* beta = (totalexp_post - totalexp_pre)/totalexp_pre is an estimate of the percentage decline in expenditures for enrollees in insurers partaking in Part D
		gen beta = (totalexp_post - totalexp_pre)/totalexp_pre if e(sample) == 1

		egen totalexp_pre_allmarket = sum(totalrm_ndc_firm)	
		* alpha = (totalexp_pre/totalexp_pre_allmarket) is  an estimate of the percentage of the entire commercial market enrollees in insurers partaking in Part D
		gen alpha = (totalexp_pre/totalexp_pre_allmarket) 
	sum beta alpha totalexp*
	*** beta = -0.05085
	*** alpha = 0.32349
	drop cl_rm_pill_ndc_firm6254_predict totalexp_post totalexp_pre beta totalexp_pre_allmarket alpha
	
	use cleancom-2005-8-s, clear
	append using cleancom-2005-9-s
	append using cleancom-2005-10-s
	append using cleancom-2005-11-s
	egen totalexpenditures = sum(amt_total_reimburse)
		* alpha2 = (totalexp_pre/totalexpenditures) is a second estimate of the percentage of the entire commercial market enrollees in insurers partaking in Part D
		* but this may not compare apples to apples, given that the sample used in the num and dem of alpha2 were not developed using the same sample criteria
		gen alpha2 = (totalexp_pre/totalexpenditures) 
		
*A. Internal Effects on Cash Payers to Part D Enrollees
	* regress change in log price (avg cash price/pill_ndc_firm to avg PDP insurer price/pill_ndc_firm) on PostPart D indicator and covariates
	* non-linear full sample
	* i. predict change prices and total expenditures assuming the only thing that changes is the Post Part D effect
	* ii. sum across all firm_drugs: SUM(baseline expenditures_ndc_firm * change in price_ndc_firm)
	* iii. note aggregate baseline expenditures; note that change in expenditures is an expenditure-weighted change in log prices
 
	* this will be at the drug level, as there is no "firm" in the pre-period cash payer sample
	* uses code from merge_statelevel_2009_07_12b, then will collapse on firm_ndc, as in merge_nationlevel_2010_01_09
	use cleansenior-2005-8-s, clear
	append using cleansenior-2005-9-s
	append using cleansenior-2005-10-s
	append using cleansenior-2005-11-s
	drop therap_class_desc
	gen period = 200512
	sort key_plan
	keep if key_plan == 1
	gen parent_organization_id = 999  
	gen parent_organization = "cash" 

	gen ones = 1
	bysort nbr_ndc name_drug pat_state: egen total_reimburse_ndc_state = sum( amt_total_reimburse)
	bysort nbr_ndc name_drug pat_state: egen total_copay_ndc_state = sum( amt_returnd_copay)
	bysort nbr_ndc name_drug pat_state: egen total_ar_ndc_state = sum( amt_returnd_ar)
	bysort nbr_ndc name_drug pat_state: egen countrx_ndc_state = sum(ones)
	bysort nbr_ndc name_drug pat_state: egen countpills_ndc_state = sum(qty_packed)
	bysort nbr_ndc name_drug: egen total_reimburse_ndc = sum(total_reimburse_ndc_state)

	collapse (mean) period total_reimburse_ndc_state total_reimburse_ndc total_copay_ndc_state total_ar_ndc_state countrx_ndc_state countpills_ndc_state branded, by(nbr_ndc name_drug therap_class pat_state)
	*note: different NDC's have same name, so place name_drug ***after*** nbr_ndc in "by" command
	gen avgqty_rx_ndc_state = countpills_ndc_state/countrx_ndc_state
	gen avgreimb_pill_ndc_state = total_reimburse_ndc_state/countpills_ndc_state
	gen avgreimb_ar_pill_ndc_state = total_ar_ndc_state/countpills_ndc_state
	egen tag_ndc = tag(nbr_ndc name_drug)

	sort nbr_ndc
	merge nbr_ndc using ndc-prepartd_ndc1000
		*This is the list of the top 1000 NDCs by spending
	keep if _merge == 3
	drop _merge
	sort  rank_ndc pat_state
	save claimssenior_cash_2005_Q4d, replace



	use cleansenior-2006-2-s, clear
	append using cleansenior-2006-3-s
	append using cleansenior-2006-4-s
	append using cleansenior-2006-5-s
	drop therap_class_desc

	gen period = 200605
	sort key_plan
	sort key_plan
	merge key_plan using plans-20062007
	*pacificare merger:
	*for 2004 and 2005 claims, the plans-20042005 file already has this change
	*for 2006 needed to create new plans-20062007 file that reflects the merge so that
	*all pacificare (including oxford and secure horizons) are edited to be 999 Pacificare
	*2006 claims data to be merged with plans-20062007_robertcoded-editedwyin_06 

	keep if _merge == 3
	keep if partd == 1
	drop _merge
	gen ones = 1
	bysort nbr_ndc name_drug pat_state: egen total_reimburse_ndc_state = sum( amt_total_reimburse)
	bysort nbr_ndc name_drug pat_state: egen total_copay_ndc_state = sum( amt_returnd_copay)
	bysort nbr_ndc name_drug pat_state: egen total_ar_ndc_state = sum( amt_returnd_ar)
	bysort nbr_ndc name_drug pat_state: egen countrx_ndc_state = sum(ones)
	bysort nbr_ndc name_drug pat_state: egen countpills_ndc_state = sum(qty_packed)
	bysort nbr_ndc name_drug: egen total_reimburse_ndc = sum(total_reimburse_ndc_state)

	collapse (mean) period total_reimburse_ndc_state_firm total_reimburse_firm total_copay_ndc_state_firm total_ar_ndc_state_firm countrx_ndc_state_firm countpills_ndc_state_firm branded, by(nbr_ndc name_drug therap_class pat_state)
	*note: different NDC's have same name, so place name_drug ***after*** nbr_ndc in "by" command
	gen avgqty_rx_ndc_state = countpills_ndc_state/countrx_ndc_state
	gen avgreimb_pill_ndc_state = total_reimburse_ndc_state/countpills_ndc_state
	gen avgreimb_ar_pill_ndc_state = total_ar_ndc_state/countpills_ndc_state
	egen tag_ndc = tag(nbr_ndc name_drug)

	sort nbr_ndc
	merge nbr_ndc using ndc-prepartd_ndc1000
	keep if _merge == 3
	drop _merge
	sort  rank_ndc pat_state
	save claimssenior_cash_2006_Q2d, replace

	keep nbr_ndc branded pat_state countrx_ndc_state avgreimb_pill_ndc_state avgreimb_ar_pill_ndc_state avgqty_rx_ndc_state branded 
	rename avgqty_rx_ndc_state  qty_rx_ndc_state62
	rename avgreimb_pill_ndc_state rm_pill_ndc_state62
	rename avgreimb_ar_pill_ndc_state rm_ar_pill_ndc_state62
	rename countrx_ndc_state countrx_ndc_state62
	sort nbr_ndc pat_state
	save claimssenior_cash_2006_Q2_reduced, replace

	use claimssenior_cash_2005_Q4d, clear
	rename avgqty_rx_ndc_state  qty_rx_ndc_state
	rename avgreimb_pill_ndc_state rm_pill_ndc_state
	rename avgreimb_ar_pill_ndc_state rm_ar_pill_ndc_state
	sort nbr_ndc pat_state
	merge nbr_ndc pat_state using claims_cash_2006_Q2_reduced, _merge(_merge_period62)
	sort nbr_ndc pat_state

	rename therap_class therap_class_WG_old
	gen therap_class_WG = therap_class_WG_old
	* regroup some pharmacy drug classes based on pharmacy's rules for mapping codes to MEPS codes
	replace therap_class_WG = 100 if therap_class_WG_old == 24 | therap_class_WG_old == 25 | therap_class_WG_old == 26
	replace therap_class_WG = 101 if therap_class_WG_old == 46 | therap_class_WG_old == 50 | therap_class_WG_old == 52
	replace therap_class_WG = 102 if therap_class_WG_old == 54 | therap_class_WG_old == 55 | therap_class_WG_old == 56
	replace therap_class_WG = 103 if therap_class_WG_old == 57 | therap_class_WG_old == 60 | therap_class_WG_old == 67 | therap_class_WG_old == 72
	replace therap_class_WG = 104 if therap_class_WG_old == 64 | therap_class_WG_old == 65 | therap_class_WG_old == 66
	replace therap_class_WG = 105 if therap_class_WG_old == 77 | therap_class_WG_old == 80
	replace therap_class_WG = 106 if therap_class_WG_old == 94 | therap_class_WG_old == 97

	sort  therap_class_WG
	merge therap_class_WG using meps_rx_class_trim, _merge(_merge_therap_class)

	gen l_rm_pill_ndc_state62 = ln( rm_pill_ndc_state62)
	gen l_rm_pill_ndc_state = ln( rm_pill_ndc_state)
	gen l_qty_rx_ndc_state62 = ln( qty_rx_ndc_state62)
	gen l_qty_rx_ndc_state = ln( qty_rx_ndc_state)
	gen pc_rm_pill_ndc_state254 = (rm_pill_ndc_state62-rm_pill_ndc_state)/rm_pill_ndc_state
	gen pc_qty_rx_ndc_state6254 = (qty_rx_ndc_state62-qty_rx_ndc_state)/ qty_rx_ndc_state
	gen cl_qty_rx_ndc_state6254 =   l_qty_rx_ndc_state62 - l_qty_rx_ndc_state
	gen cl_rm_pill_ndc_state6254 =  l_rm_pill_ndc_state62 - l_rm_pill_ndc_state
	
	gen store_state = pat_state
	sort store_state

	*** drop sample ***
	foreach X in  rm_pill_ndc_state62  rm_pill_ndc_state  {
		drop if `X' <= 0
	}

	sort nbr_ndc
	merge nbr_ndc using awp_byndc, _merge(_merge_awp)
	drop if _merge_awp == 2

*** cost A: min{Pd,f,t)-e
bysort nbr_ndc: egen base_qty_54 = mean(qty_rx_ndc_state)

***note that for WG data, qty_rx_ndc_state_firm rm_pill_ndc_state in 54 don't have "54" at at the end
foreach X in 54 {
	gen diff_qty_rx_ndc_state`X' =  (qty_rx_ndc_state - base_qty_54)/base_qty_54
	gen adjA_rm_pill_ndc_state`X' = rm_pill_ndc_state + (.249)*diff_qty_rx_ndc_state`X'   
	gen adj_rm_pill_ndc_state`X' = rm_pill_ndc_state + (.051)*diff_qty_rx_ndc_state`X' if branded == 1
	replace adj_rm_pill_ndc_state`X' = rm_pill_ndc_state + (.383)*diff_qty_rx_ndc_state`X' if branded == 0
}

foreach X in 62 {
	gen diff_qty_rx_ndc_state`X' =  (qty_rx_ndc_state`X' - base_qty_54)/base_qty_54
	gen adjA_rm_pill_ndc_state`X' = rm_pill_ndc_state`X' + (.249)*diff_qty_rx_ndc_state`X'   
	gen adj_rm_pill_ndc_state`X' = rm_pill_ndc_state`X' + (.051)*diff_qty_rx_ndc_state`X' if branded == 1
	replace adj_rm_pill_ndc_state`X' = rm_pill_ndc_state`X' + (.383)*diff_qty_rx_ndc_state`X' if branded == 0
}

foreach X in 54 62 {
	gen diff_qty_rx_awpndc`X' =  (avgqty_rx_ndc_`X' - base_qty_54)/base_qty_54
	gen adjA_awp_pill_ndc`X' =   avgawp_pill_ndc_`X' + (.249)*diff_qty_rx_awpndc`X'
	gen adj_awp_pill_ndc`X' =   avgawp_pill_ndc_`X' + (.051)*diff_qty_rx_awpndc`X' if branded == 1
	replace adj_awp_pill_ndc`X' = avgawp_pill_ndc_`X' + (.383)*diff_qty_rx_awpndc`X' if branded == 0
}

foreach X in 62 {
	gen cl_adj_awp_pill_ndc`X'54 = ln(adj_awp_pill_ndc`X') - ln(adj_awp_pill_ndc54)
}

sort nbr_ndc
merge nbr_ndc using therapeutic_class, _merge(_merge_therap_competition)
tab _merge_therap_competition _merge_therap_class
	* there obs that are _merge_therap_class==3 are also _merge_therap_competition==3

sort nbr_ndc
merge nbr_ndc using ndc_comp_reduced, _merge(_merge_ndc_comp)
*this file was created in ndccompetition_sharepoint.do
compress
sort nbr_ndc
save claimssenior_cash_merged_2010_01_09, replace

*develop average national prices, profits, controls, etc, at the ndc level
*note that adj_awp_pill_ndc are already at the firm-ndc level
sort  nbr_ndc

*pre-Part D expenditure weights by ndc: this is the Po*Qo
egen totalrm_ndc = sum(total_reimburse_ndc_state), by(nbr_ndc)

drop countrx_ndc 
egen countrx_ndc = sum(countrx_ndc_state), by(nbr_ndc)
egen countrx_ndc62 = sum(countrx_ndc_state62), by(nbr_ndc)
gen indicator_rx_ndc_state = [countrx_ndc_state ~= .]
gen indicator_rx_ndc_state62 = [countrx_ndc_state62 ~= .]
egen countrx_ind_ndc = sum(indicator_rx_ndc_state), by(nbr_ndc)
egen countrx_ind_ndc62 = sum(indicator_rx_ndc_state62), by(nbr_ndc)

gen ndc_wt6254 = (countrx_ndc62 + countrx_ndc)/2
gen ndc_ind_wt6254 = (countrx_ind_ndc62 + countrx_ind_ndc)/2
gen statewt_ndc = countrx_ndc_state/countrx_ndc
gen statewt_ndc62 = countrx_ndc_state62/countrx_ndc62

foreach X in rm_pill_ndc qty_rx_ndc {
	egen `X'62 = sum(`X'_state62*statewt_ndc62), by(nbr_ndc) missing
	egen `X' = sum(`X'_state*statewt_ndc), by(nbr_ndc) missing
}

gen l_rm_pill_ndc62 = ln( rm_pill_ndc62)
gen l_rm_pill_ndc = ln( rm_pill_ndc)
gen l_qty_rx_ndc62 = ln( qty_rx_ndc_state62)
gen l_qty_rx_ndc = ln( qty_rx_ndc)
gen cl_qty_rx_ndc6254 =   l_qty_rx_ndc62 - l_qty_rx_ndc 
gen cl_rm_pill_ndc6254 =  l_rm_pill_ndc62 - l_rm_pill_ndc
*browse parent_organization_id nbr_ndc pat_state  rm_pill_ndc_state62 rm_pill_ndc_state countrx_ndc_state62 countrx_ndc_state countrx_ndc62 countrx_ndc statewt_ndc62 statewt_ndc rm_pill_ndc62 rm_pill_ndc cl_rm_pill_ndc6254

 keep cl* _merge* rank therap_class* totalrm* countrx* ndc* adj* gen* brgen* number_* branded nbr_ndc  name_drug
 collapse (mean) cl* _merge* rank therap_class* totalrm* countrx* ndc* adj* gen* brgen* number_* branded , by(nbr_ndc  name_drug)
 compress
 sort nbr_ndc
 save claims_cash_merged_nation, replace

	reg cl_rm_pill_ndc6254 cl_qty_rx_ndc6254 cl_adj_awp_pill_ndc6254 if rank <= 1000, cluster(nbr_ndc)
	gen cl_qty_rx_ndc6254_b = cl_qty_rx_ndc6254 
	gen cl_adj_awp_pill_ndc6254_b = cl_adj_awp_pill_ndc6254 
	replace cl_qty_rx_ndc6254 = 0
	replace cl_adj_awp_pill_ndc6254 = 0
	predict cl_rm_pill_ndc6254_predict if e(sample) == 1 
	*browse nbr_ndc cl_rm_pill_ndc6254 cl_rm_pill_ndc6254_predict if e(sample) == 1

	egen totalexp_post = sum(totalrm_ndc*(1+cl_rm_pill_ndc6254_predict))	if e(sample) == 1
	egen totalexp_pre = sum(totalrm_ndc)	if e(sample) == 1
		* beta = (totalexp_post - totalexp_pre)/totalexp_pre is an estimate of the percentage decline in expenditures for enrollees in insurers partaking in Part D
		gen beta = (totalexp_post - totalexp_pre)/totalexp_pre 
	sum beta totalexp*
	*** beta = -.3351916


*** II. alpha and betas from parts A, B1 and B2 applied to expenditures in MEPS, which as nationally representative expenditure shares by group
	* Declines in total Expenditures due to Part D then decomposed into A, B1 and B2
	*use MEPS\year2005\h97.dta
	gen senior60 = [age05x >= 60]
	gen senior65 = [age05x >= 65]

	*define no rx coverage as having no 3rdparty rx payer or prescription drug coverage at anytime during the year: 31, 42, or 53
	gen rxcov = [pmedin31 == 1 | pmedin42 == 1 | pmedin53 == 1]
	gen rx3rdparty = [pmedup31 == 1 | pmedup42 == 1 | pmedup53 == 1]
	gen norxcov = [rx3rdparty == 0 & rxcov == 0]
	tab norxcov if senior == 1
	
	*define having commercial insurance as having prescription drug insurance at any time during year or has 3rd party payer at some point during year
	*has private or MA plan at some point but never medicaid or govt rx insurance
	gen commercialrxcov = [((pmedpy31 == 1 | pmedpy31 == 2) | (pmedpy42 == 1 | pmedpy42 == 2) | (pmedpy53 == 1 | pmedpy53 == 2)) & pmedpy31~= 3 & pmedpy42~= 3 & pmedpy53~= 3]
	gen commercialrxcovb = [((pmedpy31 == 1 | pmedpy31 == 2) | (pmedpy42 == 1 | pmedpy42 == 2) | (pmedpy53 == 1 | pmedpy53 == 2))]
	
	
	egen rxexp_seniorcommercial = sum(rxexp05*perwt05f) if commercialrxcovb == 1 & senior60 == 1
	egen rxexp_youngcommercial = sum(rxexp05*perwt05f) if commercialrxcovb == 1 & senior60 == 0
	*note that prior to part D, 24% seniors are cash; after 8% are cash, so 16% switch; which 16%? (ie which 2/3?) assume the highest expenditure 16% (or 2/3 of cash)
	gsort -senior60 -rxexp05
	bysort senior60: egen seniorpop = sum(perwt05f)
	gsort -senior60 -rxexp05
	bysort senior60: gen runningseniorpop = sum(perwt05f)
	gen fracpop = runningseniorpop/seniorpop 
	gsort -senior60 -rxexp05
	*browse senior60 rxexp05 seniorpop runningseniorpop fracpop
	egen rxexp_senior65cash = sum(rxexp05*perwt05f) if norxcov == 1 & senior65 == 1 & fracpop > .33

	sum rxexp_senior60cash rxexp_seniorcommercial rxexp_youngcommercial

*** Estimate average expenditure weighted over-60 share of drugs by over 60 pop and udner 60 pop
	* will be used to estimate Beta3
	use h97, clear
	gen commercialrxcovb = [((pmedpy31 == 1 | pmedpy31 == 2) | (pmedpy42 == 1 | pmedpy42 == 2) | (pmedpy53 == 1 | pmedpy53 == 2))]
	keep  duid pid dupersid age05x commercialrxcovb perwt05f
	sort dupersid
	save MEPS05_age_pid, replace
	use h94a.dta, clear
	sort dupersid
	merge m:1 dupersid using MEPS05_age_pid
	keep if _merge == 3
	
	gen senior65 = [age05x >= 65]
	*over 65 share by NDC, among commercial
	gen senior60 = [age05x >= 60]
	egen totalweight = sum(perwt05f)
	bysort rxndc: egen totalweight_ndc = sum(perwt05f)
	bysort rxndc: egen MMS = sum(senior65*(perwt05f)/totalweight_ndc) 

	bysort dupersid: egen totalexp_dupersid = sum(rxxp05x)
	bysort dupersid: egen MMS_dupersid = sum(MMS*(rxxp05x/totalexp_dupersid))
	collapse (mean) totalweight age05x commercialrxcovb perwt05f MMS_dupersid totalexp_dupersid senior60 senior65, by(dupersid)
	
	sum  MMS_dupersid if senior60 == 0 & commercialrxcovb == 1 [iweight =  perwt05f]
	sum  MMS_dupersid if senior60 == 1 & commercialrxcovb == 1 [iweight =  perwt05f]
	sum  MMS_dupersid if senior60 == 1 & senior65 == 0 & commercialrxcovb == 1 [iweight =  perwt05f]

	* get MMS at NDC level *
	use h94a.dta, clear
	sort dupersid
	merge m:1 dupersid using MEPS05_age_pid
	keep if _merge == 3
	
	gen senior65 = [age05x >= 65]
	*over 65 share by NDC, among commercial
	gen senior60 = [age05x >= 60]
	egen totalweight = sum(perwt05f)
	bysort rxndc: egen totalweight_ndc = sum(perwt05f)
	bysort rxndc: egen MMS = sum(senior65*(perwt05f)/totalweight_ndc)
	collapse (mean) MMS, by(rcndc)
