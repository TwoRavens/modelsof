/*** This Stata .do file produces the main regression results reported in 
	"Insurers’ Negotiating Leverage and the External Effects of Medicare Part D"
	Regressions corresponding to Main Tables 4, 5, 6 and Appendix Table 1, 2, 3, 4, 5 and 6, and column numbers, are noted by the regression commands.

	The main analytic file is claims_enrollment_merged_nation.dta. As described in the readme file, 
	this is a insurer-NDC level file that contains Rx claims-based variable collapsed down to the Insurer-NDC level. 
	Data from other sources, such as Part D plan, premium and enrollment data, were merged into the claims-based data at the insurer level, 
	to form the main analytic file.
	*/
 

use claims_enrollment_merged_nation, clear

*** create main first-difference Rx claims-based variable ***
	*price per pill (where price is the total reimbursement paid to the retailer)
	gen c_rm_pill_ndc_firm754 = rm_pill_ndc_firm7 - rm_pill_ndc_firm
	gen c_rm_pill_ndc_firm6454 = rm_pill_ndc_firm64 - rm_pill_ndc_firm
	gen c_rm_pill_ndc_firm6254 = rm_pill_ndc_firm62 - rm_pill_ndc_firm
	gen c_rm_pill_ndc_firm5444 = rm_pill_ndc_firm - rm_pill_ndc_firm44

	*pills per prescription
	gen c_qty_rx_ndc_firm754 =  qty_rx_ndc_firm7 -  qty_rx_ndc_firm
	gen c_qty_rx_ndc_firm6454 =  qty_rx_ndc_firm64 -  qty_rx_ndc_firm
	gen c_qty_rx_ndc_firm6254 =  qty_rx_ndc_firm62 -  qty_rx_ndc_firm
	gen c_qty_rx_ndc_firm5444 =  qty_rx_ndc_firm -  qty_rx_ndc_firm44

	gen c_qty100_rx_ndc_firm754 = c_qty_rx_ndc_firm754/100
	gen c_qty100_rx_ndc_firm6454 =  c_qty_rx_ndc_firm6454/100
	gen c_qty100_rx_ndc_firm6254 =  c_qty_rx_ndc_firm6254/100
	gen c_qty100_rx_ndc_firm5444 =  c_qty_rx_ndc_firm5444/100

	*published average wholesale price
	gen c_adj_awp_pill_ndc6454 = adj_awp_pill_ndc64 - adj_awp_pill_ndc54 
	gen c_adj_awp_pill_ndc6254 = adj_awp_pill_ndc62 - adj_awp_pill_ndc54 
	gen c_adj_awp_pill_ndc5452 = adj_awp_pill_ndc54 - adj_awp_pill_ndc52
 
*** Main Regressions ***
	* generate insurer sample variable for consistent sample across specification
	* mainsample=1 if insurer has no missing values for the IV sample
	gen mainsample=1 if _merge_marketsizeiv == 3 & adjfe_log ~= .
	

local X = 6254
global k = 6254

foreach X in 6254 6454 754 5444 {
	if `X' == 6254 {
		global k = 6254	
	}
	else if `X' == 6454 {
		global k = 6454	
	}
	else if `X' == 754 {
		global k = 6454	
	}
	else {
		global k = 5452
	}

log using price-nationfe`X'.log, replace
*** all drugs ***
*TABLE 4 (when `X' = 6254; Appendix Table 2 (`X'=5444, 6454 and 754) 
	*column 1
	areg  c_rm_pill_ndc_firm`X' c_qty100_rx_ndc_firm`X' cl_share_exposure_WG`X'  enrollment_total_1m_2006  [pweight=ndc_firm_ind_wt6254] if rank <= 1000 & mainsample==1, absorb(nbr_ndc) cluster(parent_organization_id) 
		outreg2 using price-nationfe_`X', se replace aster(coef) bdec(3) sdec(3) title("prices `X'") ctitle("OLS; all")
	*column 2
	xtivreg2  c_rm_pill_ndc_firm`X' c_qty100_rx_ndc_firm`X' cl_share_exposure_WG`X'  (enrollment_total_1m_2006 = noseniors_firm_noprivhi_06M) [pweight=ndc_firm_ind_wt6254] if rank <= 1000 & mainsample==1, i( nbr_ndc) fe robust  first
		outreg2 using price-nationfe_`X', se append aster(coef) bdec(3) sdec(3)        ctitle("IV; all")
	*linear full sample two instruments (not reported)
	xtivreg2  c_rm_pill_ndc_firm`X' c_qty100_rx_ndc_firm`X' cl_share_exposure_WG`X'  (enrollment_total_1m_2006 = adjfe_log noseniors_firm_noprivhi_06M) [pweight=ndc_firm_ind_wt6254] if rank <= 1000 & mainsample==1, i( nbr_ndc) fe robust  first
		outreg2 using price-nationfe_`X', se append aster(coef) bdec(3) sdec(3)        ctitle("IV; all")

	*column 3
	areg  c_rm_pill_ndc_firm`X' c_qty100_rx_ndc_firm`X' cl_share_exposure_WG`X'  enrollment_total_1m_2006  [pweight=ndc_firm_ind_wt6254]if humana ~= 1 &  rank <= 1000 & mainsample==1, absorb(nbr_ndc) cluster(parent_organization_id)
		outreg2 using price-nationfe_`X', se append aster(coef) bdec(3) sdec(3)        ctitle("OLS; all; prederr/NoHum")
	*column 4
	xtivreg2  c_rm_pill_ndc_firm`X' c_qty100_rx_ndc_firm`X' cl_share_exposure_WG`X'  (enrollment_total_1m_2006 = noseniors_firm_noprivhi_06M) [pweight=ndc_firm_ind_wt6254] if humana~=1 &  rank <= 1000 & mainsample==1, i(nbr_ndc) fe robust first
		*estimates store consistent
		outreg2 using price-nationfe_`X', se append aster(coef) bdec(3) sdec(3)        ctitle("IV; all; prederr/NoHum")
	*linear no Humana, two instruments (not reported)
	xtivreg2  c_rm_pill_ndc_firm`X' c_qty100_rx_ndc_firm`X' cl_share_exposure_WG`X'  (enrollment_total_1m_2006 = adjfe_log noseniors_firm_noprivhi_06M) [pweight=ndc_firm_ind_wt6254] if humana~=1 &  rank <= 1000 & mainsample==1, i(nbr_ndc) fe robust first
		*estimates store efficient
		outreg2 using price-nationfe_`X', se append aster(coef) bdec(3) sdec(3)        ctitle("IV; all; prederr/NoHum")

*TABLE 5 (when `X'=6254)
*** branded drugs ***
	* restricted to sample with premium iv *
	areg  c_rm_pill_ndc_firm`X' c_qty100_rx_ndc_firm`X' cl_share_exposure_WG`X'  enrollment_total_1m_2006  [pweight=ndc_firm_ind_wt6254]if humana ~= 1 &  rank <= 1000 & mainsample==1 & branded==1, absorb(nbr_ndc) cluster(parent_organization_id) 
		outreg2 using price-nationfe_`X', se append aster(coef) bdec(3) sdec(3)        ctitle("OLS;  branded; prederr/NoHum")
	xtivreg2  c_rm_pill_ndc_firm`X' c_qty100_rx_ndc_firm`X' cl_share_exposure_WG`X'  (enrollment_total_1m_2006 = noseniors_firm_noprivhi_06M) [pweight=ndc_firm_ind_wt6254] if humana~=1 &  rank <= 1000 & mainsample==1 & branded==1, i(nbr_ndc) fe robust first
		outreg2 using price-nationfe_`X', se append aster(coef) bdec(3) sdec(3)        ctitle("IV;  branded; prederr/NoHum")
	xtivreg2  c_rm_pill_ndc_firm`X' c_qty100_rx_ndc_firm`X' cl_share_exposure_WG`X'  (enrollment_total_1m_2006 = adjfe_log noseniors_firm_noprivhi_06M) [pweight=ndc_firm_ind_wt6254] if humana~=1 &  rank <= 1000 & mainsample==1 & branded==1, i(nbr_ndc) fe robust first
		outreg2 using price-nationfe_`X', se append aster(coef) bdec(3) sdec(3)        ctitle("IV;  branded; prederr/NoHum")
	areg  c_rm_pill_ndc_firm`X' c_qty100_rx_ndc_firm`X' cl_share_exposure_WG`X'  enrollment_total_1m_2006 enrollment_total_1m_2006_2 [pweight=ndc_firm_ind_wt6254] if  rank <= 1000 & mainsample==1 & branded==1, absorb(nbr_ndc) cluster(parent_organization_id) 
		outreg2 using price-nationfe_`X', se append aster(coef) bdec(3) sdec(3)        ctitle("OLS; branded; prederr")
	xtivreg2  c_rm_pill_ndc_firm`X' c_qty100_rx_ndc_firm`X' cl_share_exposure_WG`X'  (enrollment_total_1m_2006 enrollment_total_1m_2006_2 = adjfe_log adjfe_log2 noseniors_firm_noprivhi_06M noseniors_firm_noprivhi_06M_2) [pweight=ndc_firm_ind_wt6254] if   rank <= 1000 & mainsample==1 & branded==1, i(nbr_ndc) fe robust first
		outreg2 using price-nationfe_`X', se append aster(coef) bdec(3) sdec(3)        ctitle("IV;  branded; prederr")


*** generic drugs ***
	* restricted to sample with premium iv *
	areg  c_rm_pill_ndc_firm`X' c_qty100_rx_ndc_firm`X' cl_share_exposure_WG`X'  enrollment_total_1m_2006  [pweight=ndc_firm_ind_wt6254]if humana ~= 1 &  rank <= 1000 & mainsample==1 & branded==0, absorb(nbr_ndc) cluster(parent_organization_id) 
		outreg2 using price-nationfe_`X', se append aster(coef) bdec(3) sdec(3)        ctitle("OLS;  generics; prederr/NoHum")
	xtivreg2  c_rm_pill_ndc_firm`X' c_qty100_rx_ndc_firm`X' cl_share_exposure_WG`X'  (enrollment_total_1m_2006 = noseniors_firm_noprivhi_06M) [pweight=ndc_firm_ind_wt6254] if humana~=1 &  rank <= 1000 & mainsample==1 & branded==0, i(nbr_ndc) fe robust first
		outreg2 using price-nationfe_`X', se append aster(coef) bdec(3) sdec(3)        ctitle("IV;  generics; prederr/NoHum")
	xtivreg2  c_rm_pill_ndc_firm`X' c_qty100_rx_ndc_firm`X' cl_share_exposure_WG`X'  (enrollment_total_1m_2006 = adjfe_log noseniors_firm_noprivhi_06M) [pweight=ndc_firm_ind_wt6254] if humana~=1 &  rank <= 1000 & mainsample==1 & branded==0, i(nbr_ndc) fe robust first
		outreg2 using price-nationfe_`X', se append aster(coef) bdec(3) sdec(3)        ctitle("IV;  generics; prederr/NoHum")
	areg  c_rm_pill_ndc_firm`X' c_qty100_rx_ndc_firm`X' cl_share_exposure_WG`X'  enrollment_total_1m_2006 enrollment_total_1m_2006_2 [pweight=ndc_firm_ind_wt6254] if  rank <= 1000 & mainsample==1 & branded==0, absorb(nbr_ndc) cluster(parent_organization_id) 
		outreg2 using price-nationfe_`X', se append aster(coef) bdec(3) sdec(3)        ctitle("OLS; generics; prederr")
	xtivreg2  c_rm_pill_ndc_firm`X' c_qty100_rx_ndc_firm`X' cl_share_exposure_WG`X'  (enrollment_total_1m_2006 enrollment_total_1m_2006_2 = adjfe_log adjfe_log2 noseniors_firm_noprivhi_06M noseniors_firm_noprivhi_06M_2) [pweight=ndc_firm_ind_wt6254] if  rank <= 1000 & mainsample==1 & branded==0, i(nbr_ndc) fe robust first
		outreg2 using price-nationfe_`X', se append aster(coef) bdec(3) sdec(3)        ctitle("IV;  generics; prederr")


log close
}



*Need correct standard errors on xtivreg2 specification, due to need for clustering at the insurer level
	*recall that ivxtreg2 doesn't allow clustering at levels that span the level specified in the "i() fe" 
	
log using standard_errors.log, replace
	*SEs for TABLE 4
	local X = 6254
	*column 2
		qui xtivreg2  c_rm_pill_ndc_firm`X' c_qty100_rx_ndc_firm`X' cl_share_exposure_WG`X'  (enrollment_total_1m_2006 = noseniors_firm_noprivhi_06M) [pweight=ndc_firm_ind_wt6254] if  rank <= 1000 & mainsample==1, i( nbr_ndc) fe robust  first
			qui tab nbr_ndc if e(sample)==1, gen(nbr_ndc)
			egen group = group(nbr_ndc) if e(sample)==1
			egen maxgroup = max(group)
			global m = maxgroup
			display $m
			qui ivreg2  c_rm_pill_ndc_firm`X' c_qty100_rx_ndc_firm`X' cl_share_exposure_WG`X' nbr_ndc1-nbr_ndc$m (enrollment_total_1m_2006 = noseniors_firm_noprivhi_06M)  [pweight=ndc_firm_ind_wt6254] if  rank <= 1000 & mainsample==1, cluster(parent_organization_id)
			display _se[ enrollment_total_1m_2006]
			display _se[ enrollment_total_1m_2006_2]
			drop group maxgroup nbr_ndc1-nbr_ndc$m
		*SE on instruments in the first stage 
			areg  enrollment_total_1m_2006 c_qty100_rx_ndc_firm`X' cl_share_exposure_WG`X' noseniors_firm_noprivhi_06M  [pweight=ndc_firm_ind_wt6254] if  rank <= 1000 & mainsample==1, absorb(nbr_ndc) cluster(parent_organization_id)
	*column 4
		qui xtivreg2  c_rm_pill_ndc_firm`X' c_qty100_rx_ndc_firm`X' cl_share_exposure_WG`X'  (enrollment_total_1m_2006 = noseniors_firm_noprivhi_06M) [pweight=ndc_firm_ind_wt6254] if humana~=1 &  rank <= 1000 & mainsample==1, i(nbr_ndc) fe robust first
			qui tab nbr_ndc if e(sample)==1, gen(nbr_ndc)
			egen group = group(nbr_ndc) if e(sample)==1
			egen maxgroup = max(group)
			global m = maxgroup
			display $m
			qui ivreg2  c_rm_pill_ndc_firm`X' c_qty100_rx_ndc_firm`X' cl_share_exposure_WG`X' nbr_ndc1-nbr_ndc$m (enrollment_total_1m_2006 = noseniors_firm_noprivhi_06M) [pweight=ndc_firm_ind_wt6254] if humana~=1 &  rank <= 1000 & mainsample==1, cluster(parent_organization_id)
			display _se[ enrollment_total_1m_2006]
			display _se[ enrollment_total_1m_2006_2]
			drop group maxgroup nbr_ndc1-nbr_ndc$m
		*SE on instruments in the first stage 
			areg enrollment_total_1m_2006 c_qty100_rx_ndc_firm`X' cl_share_exposure_WG`X' noseniors_firm_noprivhi_06M [pweight=ndc_firm_ind_wt6254] if humana~=1 &  rank <= 1000 & mainsample==1, absorb(nbr_ndc) cluster(parent_organization_id)
	*column 6
		local X = 5444
		qui xtivreg2  c_rm_pill_ndc_firm`X' c_qty100_rx_ndc_firm`X' cl_share_exposure_WG`X'  (enrollment_total_1m_2006 = noseniors_firm_noprivhi_06M) [pweight=ndc_firm_ind_wt6254] if humana~=1 &  rank <= 1000 & mainsample==1, i(nbr_ndc) fe robust first
			qui tab nbr_ndc if e(sample)==1, gen(nbr_ndc)
			egen group = group(nbr_ndc) if e(sample)==1
			egen maxgroup = max(group)
			global m = maxgroup
			display $m
			qui ivreg2  c_rm_pill_ndc_firm`X' c_qty100_rx_ndc_firm`X' cl_share_exposure_WG`X' nbr_ndc1-nbr_ndc$m (enrollment_total_1m_2006 = noseniors_firm_noprivhi_06M) [pweight=ndc_firm_ind_wt6254] if humana~=1 &  rank <= 1000 & mainsample==1, cluster(parent_organization_id)
			display _se[ enrollment_total_1m_2006]
			display _se[ enrollment_total_1m_2006_2]
			drop group maxgroup nbr_ndc1-nbr_ndc$m
		*SE on instruments in the first stage 
			areg enrollment_total_1m_2006 c_qty100_rx_ndc_firm`X' cl_share_exposure_WG`X' noseniors_firm_noprivhi_06M [pweight=ndc_firm_ind_wt6254] if humana~=1 &  rank <= 1000 & mainsample==1, absorb(nbr_ndc) cluster(parent_organization_id)

	*SE's for TABLE 5
	*Column 1 is repeat of Table 4 column 1
	*Column 2
		local X = 5444
		qui xtivreg2  c_rm_pill_ndc_firm`X' c_qty100_rx_ndc_firm`X' cl_share_exposure_WG`X'  (enrollment_total_1m_2006 = noseniors_firm_noprivhi_06M) [pweight=ndc_firm_ind_wt6254] if humana~=1 &  rank <= 1000 & mainsample==1 & branded==1, i(nbr_ndc) fe 
			qui tab nbr_ndc if e(sample)==1, gen(nbr_ndc)
			egen group = group(nbr_ndc) if e(sample)==1
			egen maxgroup = max(group)
			global m = maxgroup
			display $m
			qui ivreg2  c_rm_pill_ndc_firm`X' c_qty100_rx_ndc_firm`X' cl_share_exposure_WG`X' nbr_ndc1-nbr_ndc$m (enrollment_total_1m_2006 = noseniors_firm_noprivhi_06M) [pweight=ndc_firm_ind_wt6254] if  humana~=1 &  rank <= 1000 & mainsample==1 & branded==1, cluster(parent_organization_id)
			display _se[ enrollment_total_1m_2006]
			display _se[ enrollment_total_1m_2006_2]
			drop group maxgroup nbr_ndc1-nbr_ndc$m 
		*SE on instruments in the first stage 
			areg enrollment_total_1m_2006 c_qty100_rx_ndc_firm`X' cl_share_exposure_WG`X' noseniors_firm_noprivhi_06M [pweight=ndc_firm_ind_wt6254] if humana~=1 &  rank <= 1000 & mainsample==1& branded==1, absorb(nbr_ndc) cluster(parent_organization_id)
	*column 3
		local X = 5444
		qui xtivreg2  c_rm_pill_ndc_firm`X' c_qty100_rx_ndc_firm`X' cl_share_exposure_WG`X'  (enrollment_total_1m_2006 = noseniors_firm_noprivhi_06M) [pweight=ndc_firm_ind_wt6254] if  humana~=1 &  rank <= 1000 & mainsample==1 & branded==0, i(nbr_ndc) fe 
			qui tab nbr_ndc if e(sample)==1, gen(nbr_ndc)
			egen group = group(nbr_ndc) if e(sample)==1
			egen maxgroup = max(group)
			global m = maxgroup
			display $m
			qui ivreg2  c_rm_pill_ndc_firm`X' c_qty100_rx_ndc_firm`X' cl_share_exposure_WG`X' nbr_ndc1-nbr_ndc$m (enrollment_total_1m_2006 = noseniors_firm_noprivhi_06M) [pweight=ndc_firm_ind_wt6254] if  humana~=1 &  rank <= 1000 & mainsample==1 & branded==0, cluster(parent_organization_id)
			display _se[ enrollment_total_1m_2006]
			display _se[ enrollment_total_1m_2006_2]
			drop group maxgroup nbr_ndc1-nbr_ndc$m 
		*SE on instruments in the first stage 
			areg enrollment_total_1m_2006 c_qty100_rx_ndc_firm`X' cl_share_exposure_WG`X' noseniors_firm_noprivhi_06M [pweight=ndc_firm_ind_wt6254] if humana~=1 &  rank <= 1000 & mainsample==1 & branded==0, absorb(nbr_ndc) cluster(parent_organization_id)
	*Column 4 is repeat of Table 4 column 6
	*Column 5
		local X = 6254
		qui xtivreg2  c_rm_pill_ndc_firm`X' c_qty100_rx_ndc_firm`X' cl_share_exposure_WG`X'  (enrollment_total_1m_2006 = noseniors_firm_noprivhi_06M) [pweight=ndc_firm_ind_wt6254] if  humana~=1 &  rank <= 1000 & mainsample==1 & branded==1, i(nbr_ndc) fe 
			qui tab nbr_ndc if e(sample)==1, gen(nbr_ndc)
			egen group = group(nbr_ndc) if e(sample)==1
			egen maxgroup = max(group)
			global m = maxgroup
			display $m
			qui ivreg2  c_rm_pill_ndc_firm`X' c_qty100_rx_ndc_firm`X' cl_share_exposure_WG`X' nbr_ndc1-nbr_ndc$m (enrollment_total_1m_2006 = noseniors_firm_noprivhi_06M) [pweight=ndc_firm_ind_wt6254] if  humana~=1 &  rank <= 1000 & mainsample==1 & branded==1, cluster(parent_organization_id)
			display _se[ enrollment_total_1m_2006]
			display _se[ enrollment_total_1m_2006_2]
			drop group maxgroup nbr_ndc1-nbr_ndc$m 
		*SE on instruments in the first stage 
			areg enrollment_total_1m_2006 c_qty100_rx_ndc_firm`X' cl_share_exposure_WG`X' noseniors_firm_noprivhi_06M [pweight=ndc_firm_ind_wt6254] if humana~=1 &  rank <= 1000 & mainsample==1 & branded==1, absorb(nbr_ndc) cluster(parent_organization_id)
	*column 6
		local X = 6254
		qui xtivreg2  c_rm_pill_ndc_firm`X' c_qty100_rx_ndc_firm`X' cl_share_exposure_WG`X'  (enrollment_total_1m_2006 = noseniors_firm_noprivhi_06M) [pweight=ndc_firm_ind_wt6254] if humana~=1 &  rank <= 1000 & mainsample==1 & branded==0, i(nbr_ndc) fe 
			qui tab nbr_ndc if e(sample)==1, gen(nbr_ndc)
			egen group = group(nbr_ndc) if e(sample)==1
			egen maxgroup = max(group)
			global m = maxgroup
			display $m
			qui ivreg2  c_rm_pill_ndc_firm`X' c_qty100_rx_ndc_firm`X' cl_share_exposure_WG`X' nbr_ndc1-nbr_ndc$m (enrollment_total_1m_2006 = noseniors_firm_noprivhi_06M) [pweight=ndc_firm_ind_wt6254] if humana~=1 &  rank <= 1000 & mainsample==1 & branded==0, cluster(parent_organization_id)
			display _se[ enrollment_total_1m_2006]
			display _se[ enrollment_total_1m_2006_2]
			drop group maxgroup nbr_ndc1-nbr_ndc$m 
		*SE on instruments in the first stage 
			areg enrollment_total_1m_2006 c_qty100_rx_ndc_firm`X' cl_share_exposure_WG`X' noseniors_firm_noprivhi_06M [pweight=ndc_firm_ind_wt6254] if humana~=1 &  rank <= 1000 & mainsample==1 & branded==0, absorb(nbr_ndc) cluster(parent_organization_id)

	*** SE's for APPENDIX TABLE 5
	* Column 1
		local X = 5444
		qui xtivreg2  c_rm_pill_ndc_firm`X' c_qty100_rx_ndc_firm`X' cl_share_exposure_WG`X'  (enrollment_total_1m_2006 enrollment_total_1m_2006_2 = adjfe_log adjfe_log2 noseniors_firm_noprivhi_06M noseniors_firm_noprivhi_06M_2) [pweight=ndc_firm_ind_wt6254] if   rank <= 1000 & mainsample==1, i(nbr_ndc) fe 
			qui tab nbr_ndc if e(sample)==1, gen(nbr_ndc)
			egen group = group(nbr_ndc) if e(sample)==1
			egen maxgroup = max(group)
			global m = maxgroup
			display $m
			qui ivreg2  c_rm_pill_ndc_firm`X' c_qty100_rx_ndc_firm`X' cl_share_exposure_WG`X' nbr_ndc1-nbr_ndc$m (enrollment_total_1m_2006 enrollment_total_1m_2006_2 = adjfe_log adjfe_log2 noseniors_firm_noprivhi_06M noseniors_firm_noprivhi_06M_2) [pweight=ndc_firm_ind_wt6254] if  rank <= 1000 & mainsample==1, cluster(parent_organization_id)
			display _se[ enrollment_total_1m_2006]
			display _se[ enrollment_total_1m_2006_2]
			drop group maxgroup nbr_ndc1-nbr_ndc$m
		*SE on instruments in the first stage 
			areg enrollment_total_1m_2006  c_rm_pill_ndc_firm`X' c_qty100_rx_ndc_firm`X' cl_share_exposure_WG`X' adjfe_log adjfe_log2 noseniors_firm_noprivhi_06M noseniors_firm_noprivhi_06M_2 [pweight=ndc_firm_ind_wt6254] if   rank <= 1000 & mainsample==1, absorb(nbr_ndc) cluster(parent_organization_id)			
			areg enrollment_total_1m_2006_2 c_rm_pill_ndc_firm`X' c_qty100_rx_ndc_firm`X' cl_share_exposure_WG`X' adjfe_log adjfe_log2 noseniors_firm_noprivhi_06M noseniors_firm_noprivhi_06M_2 [pweight=ndc_firm_ind_wt6254] if  rank <= 1000 & mainsample==1, absorb(nbr_ndc) cluster(parent_organization_id)			
	* Column 2
		local X = 5444
		qui xtivreg2  c_rm_pill_ndc_firm`X' c_qty100_rx_ndc_firm`X' cl_share_exposure_WG`X'  (enrollment_total_1m_2006 enrollment_total_1m_2006_2 = adjfe_log adjfe_log2 noseniors_firm_noprivhi_06M noseniors_firm_noprivhi_06M_2) [pweight=ndc_firm_ind_wt6254] if   rank <= 1000 & mainsample==1 & branded==1, i(nbr_ndc) fe 
			qui tab nbr_ndc if e(sample)==1, gen(nbr_ndc)
			egen group = group(nbr_ndc) if e(sample)==1
			egen maxgroup = max(group)
			global m = maxgroup
			display $m
			qui ivreg2  c_rm_pill_ndc_firm`X' c_qty100_rx_ndc_firm`X' cl_share_exposure_WG`X' nbr_ndc1-nbr_ndc$m (enrollment_total_1m_2006 enrollment_total_1m_2006_2 = adjfe_log adjfe_log2 noseniors_firm_noprivhi_06M noseniors_firm_noprivhi_06M_2) [pweight=ndc_firm_ind_wt6254] if  rank <= 1000 & mainsample==1 & branded==1, cluster(parent_organization_id)
			display _se[ enrollment_total_1m_2006]
			display _se[ enrollment_total_1m_2006_2]
			drop group maxgroup nbr_ndc1-nbr_ndc$m
		*SE on instruments in the first stage 
			areg enrollment_total_1m_2006  c_rm_pill_ndc_firm`X' c_qty100_rx_ndc_firm`X' cl_share_exposure_WG`X' adjfe_log adjfe_log2 noseniors_firm_noprivhi_06M noseniors_firm_noprivhi_06M_2 [pweight=ndc_firm_ind_wt6254] if   rank <= 1000 & mainsample==1 & branded==1, absorb(nbr_ndc) cluster(parent_organization_id)			
			areg enrollment_total_1m_2006_2 c_rm_pill_ndc_firm`X' c_qty100_rx_ndc_firm`X' cl_share_exposure_WG`X' adjfe_log adjfe_log2 noseniors_firm_noprivhi_06M noseniors_firm_noprivhi_06M_2 [pweight=ndc_firm_ind_wt6254] if   rank <= 1000 & mainsample==1 & branded==1, absorb(nbr_ndc) cluster(parent_organization_id)			
	* Column 3
		local X = 5444	
		qui xtivreg2  c_rm_pill_ndc_firm`X' c_qty100_rx_ndc_firm`X' cl_share_exposure_WG`X'  (enrollment_total_1m_2006 enrollment_total_1m_2006_2 = adjfe_log adjfe_log2 noseniors_firm_noprivhi_06M noseniors_firm_noprivhi_06M_2) [pweight=ndc_firm_ind_wt6254] if  rank <= 1000 & mainsample==1 & branded==0, i(nbr_ndc) fe 
			qui tab nbr_ndc if e(sample)==1, gen(nbr_ndc)
			egen group = group(nbr_ndc) if e(sample)==1
			egen maxgroup = max(group)
			global m = maxgroup
			display $m
			qui ivreg2  c_rm_pill_ndc_firm`X' c_qty100_rx_ndc_firm`X' cl_share_exposure_WG`X' nbr_ndc1-nbr_ndc$m (enrollment_total_1m_2006 enrollment_total_1m_2006_2 = adjfe_log adjfe_log2 noseniors_firm_noprivhi_06M noseniors_firm_noprivhi_06M_2) [pweight=ndc_firm_ind_wt6254] if   rank <= 1000 & mainsample==1 & branded==1, cluster(parent_organization_id)
			display _se[ enrollment_total_1m_2006]
			display _se[ enrollment_total_1m_2006_2]
			drop group maxgroup nbr_ndc1-nbr_ndc$m
		*SE on instruments in the first stage 
			areg enrollment_total_1m_2006  c_rm_pill_ndc_firm`X' c_qty100_rx_ndc_firm`X' cl_share_exposure_WG`X' adjfe_log adjfe_log2 noseniors_firm_noprivhi_06M noseniors_firm_noprivhi_06M_2 [pweight=ndc_firm_ind_wt6254] if   rank <= 1000 & mainsample==1 & branded==0, absorb(nbr_ndc) cluster(parent_organization_id)			
			areg enrollment_total_1m_2006_2 c_rm_pill_ndc_firm`X' c_qty100_rx_ndc_firm`X' cl_share_exposure_WG`X' adjfe_log adjfe_log2 noseniors_firm_noprivhi_06M noseniors_firm_noprivhi_06M_2 [pweight=ndc_firm_ind_wt6254] if  rank <= 1000 & mainsample==1 & branded==0, absorb(nbr_ndc) cluster(parent_organization_id)			
	* Column 4
		local X = 6254
		qui xtivreg2  c_rm_pill_ndc_firm`X' c_qty100_rx_ndc_firm`X' cl_share_exposure_WG`X'  (enrollment_total_1m_2006 enrollment_total_1m_2006_2 = adjfe_log adjfe_log2 noseniors_firm_noprivhi_06M noseniors_firm_noprivhi_06M_2) [pweight=ndc_firm_ind_wt6254] if   rank <= 1000 & mainsample==1, i(nbr_ndc) fe 
			qui tab nbr_ndc if e(sample)==1, gen(nbr_ndc)
			egen group = group(nbr_ndc) if e(sample)==1
			egen maxgroup = max(group)
			global m = maxgroup
			display $m
			qui ivreg2  c_rm_pill_ndc_firm`X' c_qty100_rx_ndc_firm`X' cl_share_exposure_WG`X' nbr_ndc1-nbr_ndc$m (enrollment_total_1m_2006 enrollment_total_1m_2006_2 = adjfe_log adjfe_log2 noseniors_firm_noprivhi_06M noseniors_firm_noprivhi_06M_2) [pweight=ndc_firm_ind_wt6254] if  rank <= 1000 & mainsample==1, cluster(parent_organization_id)
			display _se[ enrollment_total_1m_2006]
			display _se[ enrollment_total_1m_2006_2]
			drop group maxgroup nbr_ndc1-nbr_ndc$m
		*SE on instruments in the first stage 
			areg enrollment_total_1m_2006  c_rm_pill_ndc_firm`X' c_qty100_rx_ndc_firm`X' cl_share_exposure_WG`X' adjfe_log adjfe_log2 noseniors_firm_noprivhi_06M noseniors_firm_noprivhi_06M_2 [pweight=ndc_firm_ind_wt6254] if  rank <= 1000 & mainsample==1, absorb(nbr_ndc) cluster(parent_organization_id)			
			areg enrollment_total_1m_2006_2 c_rm_pill_ndc_firm`X' c_qty100_rx_ndc_firm`X' cl_share_exposure_WG`X' adjfe_log adjfe_log2 noseniors_firm_noprivhi_06M noseniors_firm_noprivhi_06M_2 [pweight=ndc_firm_ind_wt6254] if  rank <= 1000 & mainsample==1, absorb(nbr_ndc) cluster(parent_organization_id)			
	* Column 5
		local X = 6254
		qui xtivreg2  c_rm_pill_ndc_firm`X' c_qty100_rx_ndc_firm`X' cl_share_exposure_WG`X'  (enrollment_total_1m_2006 enrollment_total_1m_2006_2 = adjfe_log adjfe_log2 noseniors_firm_noprivhi_06M noseniors_firm_noprivhi_06M_2) [pweight=ndc_firm_ind_wt6254] if   rank <= 1000 & mainsample==1 & branded==1, i(nbr_ndc) fe 
			qui tab nbr_ndc if e(sample)==1, gen(nbr_ndc)
			egen group = group(nbr_ndc) if e(sample)==1
			egen maxgroup = max(group)
			global m = maxgroup
			display $m
			qui ivreg2  c_rm_pill_ndc_firm`X' c_qty100_rx_ndc_firm`X' cl_share_exposure_WG`X' nbr_ndc1-nbr_ndc$m (enrollment_total_1m_2006 enrollment_total_1m_2006_2 = adjfe_log adjfe_log2 noseniors_firm_noprivhi_06M noseniors_firm_noprivhi_06M_2) [pweight=ndc_firm_ind_wt6254] if   rank <= 1000 & mainsample==1 & branded==1, cluster(parent_organization_id)
			display _se[ enrollment_total_1m_2006]
			display _se[ enrollment_total_1m_2006_2]
			drop group maxgroup nbr_ndc1-nbr_ndc$m
		*SE on instruments in the first stage 
			areg enrollment_total_1m_2006  c_rm_pill_ndc_firm`X' c_qty100_rx_ndc_firm`X' cl_share_exposure_WG`X' adjfe_log adjfe_log2 noseniors_firm_noprivhi_06M noseniors_firm_noprivhi_06M_2 [pweight=ndc_firm_ind_wt6254] if   rank <= 1000 & mainsample==1 &  branded==1, absorb(nbr_ndc) cluster(parent_organization_id)			
			areg enrollment_total_1m_2006_2 c_rm_pill_ndc_firm`X' c_qty100_rx_ndc_firm`X' cl_share_exposure_WG`X' adjfe_log adjfe_log2 noseniors_firm_noprivhi_06M noseniors_firm_noprivhi_06M_2 [pweight=ndc_firm_ind_wt6254] if  rank <= 1000 & mainsample==1 &  branded==1, absorb(nbr_ndc) cluster(parent_organization_id)			
	* Column 6
		local X = 6254	
		qui xtivreg2  c_rm_pill_ndc_firm`X' c_qty100_rx_ndc_firm`X' cl_share_exposure_WG`X'  (enrollment_total_1m_2006 enrollment_total_1m_2006_2 = adjfe_log adjfe_log2 noseniors_firm_noprivhi_06M noseniors_firm_noprivhi_06M_2) [pweight=ndc_firm_ind_wt6254] if  rank <= 1000 & mainsample==1 & branded==0, i(nbr_ndc) fe 
			qui tab nbr_ndc if e(sample)==1, gen(nbr_ndc)
			egen group = group(nbr_ndc) if e(sample)==1
			egen maxgroup = max(group)
			global m = maxgroup
			display $m
			qui ivreg2  c_rm_pill_ndc_firm`X' c_qty100_rx_ndc_firm`X' cl_share_exposure_WG`X' nbr_ndc1-nbr_ndc$m (enrollment_total_1m_2006 enrollment_total_1m_2006_2 = adjfe_log adjfe_log2 noseniors_firm_noprivhi_06M noseniors_firm_noprivhi_06M_2) [pweight=ndc_firm_ind_wt6254] if  rank <= 1000 & mainsample==1 & branded==1, cluster(parent_organization_id)
			display _se[ enrollment_total_1m_2006]
			display _se[ enrollment_total_1m_2006_2]
			drop group maxgroup nbr_ndc1-nbr_ndc$m
		*SE on instruments in the first stage 
			areg enrollment_total_1m_2006  c_rm_pill_ndc_firm`X' c_qty100_rx_ndc_firm`X' cl_share_exposure_WG`X' adjfe_log adjfe_log2 noseniors_firm_noprivhi_06M noseniors_firm_noprivhi_06M_2 [pweight=ndc_firm_ind_wt6254] if   rank <= 1000 & mainsample==1 & branded==0, absorb(nbr_ndc) cluster(parent_organization_id)			
			areg enrollment_total_1m_2006_2 c_rm_pill_ndc_firm`X' c_qty100_rx_ndc_firm`X' cl_share_exposure_WG`X' adjfe_log adjfe_log2 noseniors_firm_noprivhi_06M noseniors_firm_noprivhi_06M_2 [pweight=ndc_firm_ind_wt6254] if   rank <= 1000 & mainsample==1 & branded==0, absorb(nbr_ndc) cluster(parent_organization_id)			

			

* Baseline Unit Price per Pill
local X = 6254
	* full sample: B+G
	qui areg  c_rm_pill_ndc_firm`X' c_qty100_rx_ndc_firm`X' cl_share_exposure_WG`X'  enrollment_total_1m_2006  [pweight=ndc_firm_ind_wt6254] if  rank <= 1000 & mainsample==1, absorb(nbr_ndc) cluster(parent_organization_id) 
		sum rm_pill_ndc_firm [weight=ndc_firm_ind_wt6254] if e(sample)==1
	* no humama: B+G
	qui areg  c_rm_pill_ndc_firm`X' c_qty100_rx_ndc_firm`X' cl_share_exposure_WG`X'  enrollment_total_1m_2006  [pweight=ndc_firm_ind_wt6254] if humana~=1 &  rank <= 1000 & mainsample==1, absorb(nbr_ndc) cluster(parent_organization_id) 
		sum rm_pill_ndc_firm [weight=ndc_firm_ind_wt6254] if e(sample)==1
		* no humama: B only
	qui areg  c_rm_pill_ndc_firm`X' c_qty100_rx_ndc_firm`X' cl_share_exposure_WG`X'  enrollment_total_1m_2006  [pweight=ndc_firm_ind_wt6254] if humana~=1 &  rank <= 1000 & mainsample==1 & branded==1, absorb(nbr_ndc) cluster(parent_organization_id) 
		sum rm_pill_ndc_firm [weight=ndc_firm_ind_wt6254] if e(sample)==1
		* no humama: G only
	qui areg  c_rm_pill_ndc_firm`X' c_qty100_rx_ndc_firm`X' cl_share_exposure_WG`X'  enrollment_total_1m_2006  [pweight=ndc_firm_ind_wt6254] if humana~=1 &  rank <= 1000 & mainsample==1 & branded==0, absorb(nbr_ndc) cluster(parent_organization_id) 
		sum rm_pill_ndc_firm [weight=ndc_firm_ind_wt6254] if e(sample)==1
		
local X = 5444
	* full sample: B+G
	qui areg  c_rm_pill_ndc_firm`X' c_qty100_rx_ndc_firm`X' cl_share_exposure_WG`X'  enrollment_total_1m_2006  [pweight=ndc_firm_ind_wt6254] if  rank <= 1000 & mainsample==1, absorb(nbr_ndc) cluster(parent_organization_id) 
		sum rm_pill_ndc_firm44 [weight=ndc_firm_ind_wt6254] if e(sample)==1
		* no humama: B+G
	qui areg  c_rm_pill_ndc_firm`X' c_qty100_rx_ndc_firm`X' cl_share_exposure_WG`X'  enrollment_total_1m_2006  [pweight=ndc_firm_ind_wt6254] if  rank <= 1000 & mainsample==1, absorb(nbr_ndc) cluster(parent_organization_id) 
		sum rm_pill_ndc_firm44 [weight=ndc_firm_ind_wt6254] if e(sample)==1
	* no humama: B only
	qui areg  c_rm_pill_ndc_firm`X' c_qty100_rx_ndc_firm`X' cl_share_exposure_WG`X'  enrollment_total_1m_2006  [pweight=ndc_firm_ind_wt6254] if humana~=1 &  rank <= 1000 & mainsample==1 & branded==1, absorb(nbr_ndc) cluster(parent_organization_id) 
				sum rm_pill_ndc_firm44 [weight=ndc_firm_ind_wt6254] if e(sample)==1
	* no humama: G only
	qui areg  c_rm_pill_ndc_firm`X' c_qty100_rx_ndc_firm`X' cl_share_exposure_WG`X'  enrollment_total_1m_2006  [pweight=ndc_firm_ind_wt6254] if humana~=1 &  rank <= 1000 & mainsample==1 & branded==0, absorb(nbr_ndc) cluster(parent_organization_id) 
		sum rm_pill_ndc_firm44 [weight=ndc_firm_ind_wt6254] if e(sample)==1

		
*** APPENDIX TABLE 1
	bysort parent_organization_id: egen total_rm_firm = sum(totalrm_ndc_firm)
	bysort parent_organization_id: egen total_count_firm = sum( countrx_ndc_firm)
	sort total_rm_firm 
	tab total_rm_firm if   rank <= 1000 & mainsample==1
	gen ln_total_rm_firm = ln(total_rm_firm)
	gen total_rm_firm_1M = total_rm_firm/1000000
	gen total_rm_firm_1M_2 = total_rm_firm_1M^2 
	gen ln_total_count_firm = ln(total_count_firm)
	gen total_count_firm_1M = total_count_firm/1000000
	gen total_count_firm_1M_2 = total_count_firm_1M^2 

	gen small = [total_rm_firm <= 72000]
	gen medium = [total_rm_firm > 72000 & total_rm_firm <= 380000]
	gen large  = [total_rm_firm > 380000]

	*test whether trend in prices prior to part d differs by insurer size
	reg cl_rm_pill_ndc_firm5444 total_rm_firm_1M cl_qty_rx_ndc_firm5444 cl_share_exposure_WG5444 cl_adj_awp_pill_ndc5452  [pweight= totalrm_ndc_firm] if  rank <= 1000 & mainsample==1, cluster(parent_organization_id)
		outreg2 using firmsize_validity, se replace aster(coef) bdec(4) sdec(4) title("Firm Size and Price Trends") 
	reg cl_rm_pill_ndc_firm5444 total_rm_firm_1M total_rm_firm_1M_2 cl_qty_rx_ndc_firm5444 cl_share_exposure_WG5444 cl_adj_awp_pill_ndc5452  [pweight= totalrm_ndc_firm] if  rank <= 1000 & mainsample==1, cluster(parent_organization_id)
		outreg2 using firmsize_validity, se append aster(coef) bdec(4) sdec(4)
	reg cl_rm_pill_ndc_firm5444 ln_total_rm_firm cl_qty_rx_ndc_firm5444 cl_share_exposure_WG5444 cl_adj_awp_pill_ndc5452  [pweight= totalrm_ndc_firm] if  rank <= 1000 & mainsample==1, cluster(parent_organization_id)
		outreg2 using firmsize_validity, se append aster(coef) bdec(4) sdec(4)
	reg cl_rm_pill_ndc_firm5444 medium large cl_qty_rx_ndc_firm5444 cl_share_exposure_WG5444 cl_adj_awp_pill_ndc5452  [pweight= totalrm_ndc_firm] if  rank <= 1000 & mainsample==1, cluster(parent_organization_id)
		outreg2 using firmsize_validity, se append aster(coef) bdec(4) sdec(4)

	reg cl_rm_pill_ndc_firm5444 total_count_firm_1M cl_qty_rx_ndc_firm5444 cl_share_exposure_WG5444 cl_adj_awp_pill_ndc5452  [pweight= totalrm_ndc_firm] if  rank <= 1000 & mainsample==1, cluster(parent_organization_id)
		outreg2 using firmsize_validity, se append aster(coef) bdec(4) sdec(4)
	reg cl_rm_pill_ndc_firm5444 total_count_firm_1M total_count_firm_1M_2 cl_qty_rx_ndc_firm5444 cl_share_exposure_WG5444 cl_adj_awp_pill_ndc5452  [pweight= totalrm_ndc_firm] if  rank <= 1000 & mainsample==1, cluster(parent_organization_id)
		outreg2 using firmsize_validity, se append aster(coef) bdec(4) sdec(4)
	reg cl_rm_pill_ndc_firm5444 ln_total_count_firm cl_qty_rx_ndc_firm5444 cl_share_exposure_WG5444 cl_adj_awp_pill_ndc5452  [pweight= totalrm_ndc_firm] if  rank <= 1000 & mainsample==1, cluster(parent_organization_id)
		outreg2 using firmsize_validity, se append aster(coef) bdec(4) sdec(4)

		
		
*** APPENDIX TABLE 2
* Testing whether changes in Market Power of WG is responsive to changes in insurer enrollment as a result of Part D

log using wgshare.log, replace
	bysort parent_organization_id: egen  totalrm_firm = sum( totalrm_ndc_firm)
	global k = 5452
	local X = 5444
	reg cl_rm_pill_ndc_firm`X' cl_qty_rx_ndc_firm`X' cl_share_exposure_WG`X' cl_adj_awp_pill_ndc$k  enrollment_total_1m_2006  [pweight=totalrm_firm] if  rank <= 1000 & mainsample==1, cluster(parent_organization_id) 
	gen sample`X' = 1 if e(sample)==1
	egen tag_firm`X' = tag(parent_organization_id) if sample`X'==1
	drop sample`X'
		reg cl_share_exposure_WG`X' enrollment_total_1m_2006  [pweight=totalrm_firm] if tag_firm`X'==1 & humana~=1, cluster(parent_organization_id) 
		outreg2 using wgshare, se replace aster(coef) bdec(3) sdec(3) title("WG Share") ctitle("`X';OLS")
		ivreg2 cl_share_exposure_WG`X' (enrollment_total_1m_2006 = adjfe_log noseniors_firm_noprivhi_06M) [pweight=totalrm_firm] if tag_firm`X'==1 & humana~=1, cluster(parent_organization_id) 
		outreg2 using wgshare, se append aster(coef) bdec(3) sdec(3) ctitle("`X';IV")
		ivreg2 cl_share_exposure_WG`X' (enrollment_total_1m_2006 = noseniors_firm_noprivhi_06M ) [pweight=totalrm_firm] if tag_firm`X'==1 & humana~=1, cluster(parent_organization_id)
		outreg2 using wgshare, se append aster(coef) bdec(3) sdec(3) ctitle("`X';IV")

	global k = 6254
	local X = 6254
	reg cl_rm_pill_ndc_firm`X' cl_qty_rx_ndc_firm`X' cl_share_exposure_WG`X' cl_adj_awp_pill_ndc$k  enrollment_total_1m_2006  [pweight=totalrm_firm]if  rank <= 1000 & mainsample==1, cluster(parent_organization_id) 
	gen sample`X' = 1 if e(sample)==1
	egen tag_firm`X' = tag(parent_organization_id) if sample`X'==1
	drop sample`X'
		reg cl_share_exposure_WG`X' enrollment_total_1m_2006  [pweight=totalrm_firm] if tag_firm`X'==1 & humana~=1, cluster(parent_organization_id) 
		outreg2 using wgshare, se append aster(coef) bdec(3) sdec(3) ctitle("`X';OLS")
		*ivreg2 cl_share_exposure_WG`X' (enrollment_total_1m_2006 = adjfe_log noseniors_firm_noprivhi_06M) [pweight=totalrm_firm] if tag_firm`X'==1, cluster(parent_organization_id) 
		*outreg2 using wgshare, se append aster(coef) bdec(3) sdec(3) ctitle("`X';IV")
		ivreg2 cl_share_exposure_WG`X' (enrollment_total_1m_2006 = noseniors_firm_noprivhi_06M ) [pweight=totalrm_firm] if tag_firm`X'==1 & humana~=1, cluster(parent_organization_id)
		outreg2 using wgshare, se append aster(coef) bdec(3) sdec(3) ctitle("`X';IV")

	global k = 6454
	local X = 6454
	reg cl_rm_pill_ndc_firm`X' cl_qty_rx_ndc_firm`X' cl_share_exposure_WG`X' cl_adj_awp_pill_ndc$k  enrollment_total_1m_2006  [pweight=totalrm_firm] if  rank <= 1000 & mainsample==1, cluster(parent_organization_id) 
	gen sample`X' = 1 if e(sample)==1
	egen tag_firm`X' = tag(parent_organization_id) if sample`X'==1
	drop sample`X'
		reg cl_share_exposure_WG`X' enrollment_total_1m_2006  [pweight=totalrm_firm] if tag_firm`X'==1 & humana~=1, cluster(parent_organization_id) 
		outreg2 using wgshare, se append aster(coef) bdec(3) sdec(3) ctitle("`X';OLS")
		ivreg2 cl_share_exposure_WG`X' (enrollment_total_1m_2006 = adjfe_log noseniors_firm_noprivhi_06M) [pweight=totalrm_firm] if tag_firm`X'==1, cluster(parent_organization_id) 
		outreg2 using wgshare, se append aster(coef) bdec(3) sdec(3) ctitle("`X';IV")
		ivreg2 cl_share_exposure_WG`X' (enrollment_total_1m_2006 = noseniors_firm_noprivhi_06M ) [pweight=totalrm_firm] if tag_firm`X'==1 & humana~=1, cluster(parent_organization_id)
		outreg2 using wgshare, se append aster(coef) bdec(3) sdec(3) ctitle("`X';IV")

	global k = 6454
	local X = 754
	reg cl_rm_pill_ndc_firm`X' cl_qty_rx_ndc_firm`X' cl_share_exposure_WG`X' cl_adj_awp_pill_ndc$k  enrollment_total_1m_2006  [pweight=totalrm_firm]if  rank <= 1000 & mainsample==1, cluster(parent_organization_id) 
	gen sample`X' = 1 if e(sample)==1
	egen tag_firm`X' = tag(parent_organization_id) if sample`X'==1
	drop sample`X'
		reg cl_share_exposure_WG`X' enrollment_total_1m_2006  [pweight=totalrm_firm] if tag_firm`X'==1 & humana~=1, cluster(parent_organization_id) 
		outreg2 using wgshare, se append aster(coef) bdec(3) sdec(3) ctitle("`X';OLS")
		ivreg2 cl_share_exposure_WG`X' (enrollment_total_1m_2006 = adjfe_log noseniors_firm_noprivhi_06M) [pweight=totalrm_firm] if tag_firm`X'==1, cluster(parent_organization_id) 
		outreg2 using wgshare, se append aster(coef) bdec(3) sdec(3) ctitle("`X';IV")
		ivreg2 cl_share_exposure_WG`X' (enrollment_total_1m_2006 = noseniors_firm_noprivhi_06M ) [pweight=totalrm_firm] if tag_firm`X'==1 & humana~=1, cluster(parent_organization_id)
		outreg2 using wgshare, se append aster(coef) bdec(3) sdec(3) ctitle("`X';IV")

log close


*** APPENDIX TABLE 4: Predictors of PDP Premiums
	use claims_enrollment_merged_nation_2010_01_09_withp.dta, clear
	
	gen l_share_exposure_WG_2005 = ln( share_exposure_WG_2005)
	gen l_share_exposure_WG_2006 = ln( share_exposure_WG_2006)
	gen l_share_exposure_WG_2007 = ln( share_exposure_WG_2007)
	gen l_adj_awp_pill_ndc = ln(  adj_awp_pill_ndc54)
	gen l_adj_awp_pill_ndc62 = ln( adj_awp_pill_ndc62)
	gen l_adj_awp_pill_ndc64 = ln( adj_awp_pill_ndc64)

	global k = 6254
	local X = 6254
	ivreg2 cl_rm_pill_ndc_firm`X' cl_qty_rx_ndc_firm`X' cl_share_exposure_WG`X' cl_adj_awp_pill_ndc$k  (enrollment_total_1m_2006 enrollment_total_1m_2006_2 = adjfe_log adjfe_log2 noseniors_firm_noprivhi_06M noseniors_firm_noprivhi_06M_2) [pweight=ndc_firm_ind_wt6254] if   rank <= 1000 & mainsample==1, cluster(parent_organization_id) 
	gen sample = [e(sample)==1]
	reg   l_rm_pill_ndc_firm adjfe_log l_qty_rx_ndc_firm l_adj_awp_pill_ndc l_share_exposure_WG_2005 [pweight=  totalreimburse_ndc] if   rank <= 1000 & mainsample==1 & e(sample)==1, cluster( parent_organization_id)
		outreg2 using appendix2, se replace aster(coef) bdec(3) sdec(3) title("Appendix 2") 
	reg   l_rm_pill_ndc_firm62 adjfe_log l_qty_rx_ndc_firm62 l_adj_awp_pill_ndc62 l_share_exposure_WG_2006 [pweight=  totalreimburse_ndc] if  rank <= 1000 & mainsample==1 & e(sample)==1, cluster( parent_organization_id)
		outreg2 using appendix2, se append aster(coef) bdec(3) sdec(3)
	reg   cl_rm_pill_ndc_firm6254 adjfe_log cl_qty_rx_ndc_firm6254 cl_adj_awp_pill_ndc6254 cl_share_exposure_WG6254 [pweight=  totalreimburse_ndc] if   rank <= 1000 & mainsample==1 & e(sample)==1, cluster( parent_organization_id)
		outreg2 using appendix2, se append aster(coef) bdec(3) sdec(3)

	* get some measure of drug cost by firm, to be used in the analysis below
	areg   l_rm_pill_ndc_firm l_qty_rx_ndc_firm l_adj_awp_pill_ndc [pweight=  totalreimburse_ndc], absorb(parent_organization_id)
	predict relcost_firm54, d
	areg   l_rm_pill_ndc_firm62 l_qty_rx_ndc_firm62 l_adj_awp_pill_ndc62 [pweight=  totalreimburse_ndc], absorb(parent_organization_id)
	predict relcost_firm62, d
	areg   l_rm_pill_ndc_firm64 l_qty_rx_ndc_firm64 l_adj_awp_pill_ndc64 [pweight=  totalreimburse_ndc], absorb(parent_organization_id)
	predict relcost_firm64, d
	areg   cl_rm_pill_ndc_firm6454 cl_qty_rx_ndc_firm6454 cl_adj_awp_pill_ndc6454 [pweight=  totalreimburse_ndc], absorb(parent_organization_id)
	predict rel_c_cost_firm6454, d
	keep if sample==1
	collapse (mean) relcost_firm54 relcost_firm62 relcost_firm64 rel_c_cost_firm6454, by(parent_organization_id)
	sort parent_organization_id
	save relcost_firm, replace

	* merge in relcost of drugs by firm into the premium data, in order to test how much premiums reflect prices
	use premiums0607, clear
		*This data comes from publicly available data on Part D plan premiums and design

	qui tab gap_coverage, gen(gapcoverage)
	qui tab parent_organization_id, gen(firm)
	gen premium_yr = premium_month*12
	gen ln_premium_yr = ln(premium_yr)
	gen gentype = 1 if benefit_type == "Basic"
	replace gentype = 0 if benefit_type == "Enhanced"
	gen year2007 = [period == 2007]
	gen year2006 = [period == 2006]
	gen firm_plan_id = parent_organization_id*1000 + plan_id
	bysort firm_plan_id: egen basic = max(gentype)
	qui tab pdp_region, gen(pdp)
	egen tag_firm = tag(parent_organization_id)
	gen deductible_year_1K = deductible_year/1000
	sort parent_organization_id
	merge m:1 parent_organization_id using relcost_firm, generate(_merge_relcost_firm)
	
	*Column 1
	reg ln_premium_yr deductible_year_1K zeroprem_lis gapcoverage2-gapcoverage4 pdp1-pdp34 if basic ==1  & period == 2006 & _merge_relcost_firm==3, cluster(parent_organization_id)
		outreg2 using appendix2, se append aster(coef) bdec(3) sdec(3)
	*Column 2
	reg ln_premium_yr deductible_year_1K zeroprem_lis gapcoverage2-gapcoverage4 pdp1-pdp34 relcost_firm54 if basic ==1  & period == 2006 & _merge_relcost_firm==3, cluster(parent_organization_id)
		outreg2 using appendix2, se append aster(coef) bdec(3) sdec(3)
	*Column 3
	reg ln_premium_yr deductible_year_1K zeroprem_lis gapcoverage2-gapcoverage4 pdp1-pdp34 relcost_firm64 if basic ==1  & period == 2006 & _merge_relcost_firm==3, cluster(parent_organization_id)
		outreg2 using appendix2, se append aster(coef) bdec(3) sdec(3)
	*Column 4
	reg ln_premium_yr deductible_year_1K zeroprem_lis gapcoverage2-gapcoverage4 pdp1-pdp34 rel_c_cost_firm6454 if basic ==1  & period == 2006 & _merge_relcost_firm==3, cluster(parent_organization_id)
		outreg2 using appendix2, se append aster(coef) bdec(3) sdec(3)

