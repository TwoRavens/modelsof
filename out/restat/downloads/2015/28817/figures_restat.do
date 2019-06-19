*This Stata .do file produces figures 3a and 3b, 4, 5, 6a and 6b
	*All variables are described in the readme and regressions.do files, and not repeated here
	*Any new variable created for the purposes of producing figures are generated and explained in this document.

use clean-2005-9-s, clear
	*This figure is based on prices at a point in time, so claims data from one particular month prior to 2006 (Sept 2005) was chosen.
sort key_plan
merge key_plan using plans-20042005 
	*plans-20042005.dta containes the name of insurers (parent organization), which we merge to the claims data on the Rx plan id variable; plan id-to-insurer crosswalk was provided by the pharmacy  
keep if _merge == 3
egen tag_firm_ndc_qty = tag( parent_organization_id nbr_ndc qty_packed)
bysort nbr_ndc qty_packed: egen avg_rm_ndc_qty = mean( amt_total_reimburse)
bysort nbr_ndc qty_packed: egen total_rm_ndc_qty = sum( amt_total_reimburse)
replace total_rm_ndc_qty = round(total_rm_ndc_qty)

gen rel_price =  (amt_total_reimburse-avg_rm_ndc_qty)/avg_rm_ndc_qty 
graph twoway (hist  rel_price if rel_price >-.5 & rel_price< .5 & tag_firm_ndc_qty ==1 & branded ==1 [fw=total_rm_ndc_qty], fcolor(gs10) lcolor(none) bin(45) ) (hist  rel_price if rel_price >-.5 & rel_price <.5 & tag_firm_ndc_qty ==1 &  branded ==0 [fw=total_rm_ndc_qty], fcolor(none) lcolor(black) bin(45) lwidth(medthick)), legend(label(1 "Branded") label(2 "Generics")) title("Figure 3a. Distribution of Retail Prices") xtitle("Price Relative to Average Price for NDC")
	*Note that trimming was performed to improve scaling for the figure, and biases against finding a wide distribution of negotiated prices (trimming eliminates .1% of sample, weighted by presciption count).  
gen dev_price =  (amt_total_reimburse-avg_rm_ndc_qty) 
gen abs_dev_price =  abs((amt_total_reimburse-avg_rm_ndc_qty))
graph twoway (hist  abs_dev_price if abs_dev_price < 15 & tag_firm_ndc_qty ==1 & branded ==1 [fw=total_rm_ndc_qty], fcolor(gs10) lcolor(none) bin(40) ) (hist  abs_dev_price if abs_dev_price < 15 & tag_firm_ndc_qty ==1 &  branded ==0 [fw=total_rm_ndc_qty], fcolor(none) lcolor(black) bin(40) lwidth(medthick)), legend(label(1 "Branded") label(2 "Generics")) title("Figure 3b. Distribution of Retail Prices") xtitle("Absolute Deviation from Average Price for NDC ($)")


*Figure 4
use claims_enrollment_merged_nation, clear
scatter enrollment_total_1m_2006 noseniors_firm_noprivhi_06M if humana ~=1 & mainsample==1, title("Figure 4. Actual and Potential Part D Enrollment") xtitle("Potential 2006 Part D Enrollment (M)") ytitle("Actual 2006 Part D Enrollment (M)") note("Humana not shown: Potential Enrollment = 13.85M; Actual Enrollment = 4.54M")

*Figure 5
use claims_enrollment_merged_nation, clear
egen tag_firm = tag(parent_organization_id)
hist adjfe_log if tag_firm == 1, bin(15) title("Figure 5. Distribution of Quality-adjusted Premiums") xtitle("Quality-adjusted Premiums") subtitle("Difference in ln(Premium) Relative to Market Average (2006)")
	
*Figures 6a and 6b
use claims_enrollment_merged_nation, clear
areg cl_rm_pill_ndc_firm6254 cl_qty_rx_ndc_firm6254 cl_share_exposure_WG6254 cl_adj_awp_pill_ndc6254 [pweight=ndc_firm_ind_wt6254]if  & mainsample==1, absorb(nbr_ndc) cluster(parent_organization_id)
	*note that this regression duplicates the main OLS regression of changes in average price/pill at the insurer-NDC level between "62" (average over the first two quarters of 2006) and "54" (the average over the second half of 2005) on covariates, except that insurer enrollment size is not included as a regressor
egen tag_firm_all = tag( parent_organization_id) if e(sample)==1
predict residuals if e(sample) == 1, residuals
predict dresiduals if e(sample) == 1, dresiduals
gen netresiduals = residuals - dresiduals if e(sample) == 1
bysort parent_organization_id: egen firm_ind_wt6254 = sum(ndc_firm_ind_wt6254)
	*generates a firm-level weight based on the number of claims per insurer
	*It is simply the sum of the insurer-NDC level weight (defined in the regressions file) that is used in the main regressions
bysort parent_organization_id: egen avg_residuals_firm_all = mean(residuals*ndc_firm_ind_wt6254/firm_ind_wt6254 )
	*averages the insurer-NDC level residuals over the insurer, by weighing each NDC-firm by the fraction of an insurer's claims accounted for by that NDC 
scatter avg_residuals_firm_all enrollment_total_1m_2006 if humana ~= 1 & enrollment_total_1m_2006 <=1.1 & tag_firm_all == 1 [pweight=ndc_firm_ind_wt6254], msymbol(circle_hollow) mlcolor(black) mfcolor(none) mlwidth(medthick) title("Figure 6a. Changes in Drug Prices and Enrollment") xlabel(0(.25)1.1) xtitle("2006 Part D Enrollment Increases (M)") ytitle("Residuals") note("The figure does not include the observation from Humana")
scatter avg_residuals_firm_all enrollment_total_1m_2006 if enrollment_total_1m_2006 <=5 & tag_firm_all == 1 [pweight=ndc_firm_ind_wt6254], msymbol(circle_hollow) mlcolor(black) mfcolor(none) mlwidth(medthick) title("Figure 6b. Changes in Drug Prices and Enrollment") xlabel(0(.5)4.75) xtitle("2006 Part D Enrollment Increases (M)") ytitle("Residuals") 
