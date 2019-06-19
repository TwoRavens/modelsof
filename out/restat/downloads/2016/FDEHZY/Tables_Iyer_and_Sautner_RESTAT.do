
*****************************************************************************************************************************************************************************************************  
*****************************************************************************VARIABLE GENERATION*****************************************************************************************************  
*****************************************************************************************************************************************************************************************************  

gen monitoring_clauses = supplier_audit + financial_information + evaluation_meetings + kpi_monitoring_system + no_preferred_supplier
gen incentive_clauses = liability + product_warranty + availability_guarantee + penalty + bonus
gen moral_hazard_clauses = monitoring_clauses + incentive_clauses
gen log_spending_volume=log(spending_volume) 
	  
*****************************************************************************************************************************************************************************************************  
*****************************************************************************TABLES******************************************************************************************************************  
*****************************************************************************************************************************************************************************************************  
 
***TABLE 1: SUMMARY STATISTICS

***Panel A: SUPPLIER CHARACTERISTICS

tabstat critical_product_supplier good alternative_buyers   switching_time switching_costs   ///
domestic_firm privately_held_firm date above_market  spending_volume_th  total_assets_th ///
quality_problems  supplier_renegotiates, stats(mean p50 sd n) columns(statistics)

***Panel B: CONTRACT CHARACTERISTICS

tabstat moral_hazard_clauses  monitoring_clauses incentive_clauses  ///
supplier_audit financial_information evaluation_meetings kpi_monitoring_system no_preferred_supplier ///
liability product_warranty availability_guarantee penalt bonus  ///
transfer_ip_rights   duration_years open_duration, stats(mean n) columns(statistics)

***TABLE 2: DETERMINANTS OF CONTRACT DESIGN: MORAL-HAZARD PROBLEMS

sureg (supplier_audit   critical_product_supplier good domestic_firm privately_held_firm log_spending_volume) ///  
(financial_information  critical_product_supplier good domestic_firm privately_held_firm log_spending_volume) ///
(evaluation_meetings    critical_product_supplier good domestic_firm privately_held_firm log_spending_volume) /// 
(kpi_monitoring_system  critical_product_supplier good domestic_firm privately_held_firm log_spending_volume) /// 
(no_preferred_supplier  critical_product_supplier good domestic_firm privately_held_firm log_spending_volume) ///
(liability              critical_product_supplier good domestic_firm privately_held_firm log_spending_volume) ///
(product_warranty       critical_product_supplier good domestic_firm privately_held_firm log_spending_volume) ///
(availability_guarantee critical_product_supplier good domestic_firm privately_held_firm log_spending_volume) ///
(penalty                critical_product_supplier good domestic_firm privately_held_firm log_spending_volume) ///
(bonus                  critical_product_supplier good domestic_firm privately_held_firm log_spending_volume) ///

esttab, b(2) pr2 star(* 0.10 ** 0.05 *** 0.01)
 
***TABLE 3: DETERMINANTS OF AGREGATE CONTRACT DESIGN: MORAL-HAZARD PROBLEMS
   
local varlist moral_hazard_clauses  monitoring_clauses incentive_clauses 
eststo clear
foreach var in `varlist'{

eststo: reg  `var' critical_product_supplier good domestic_firm privately_held_firm log_spending_volume, robust  
eststo: reg  `var' critical_product_supplier good domestic_firm privately_held_firm log_spending_volume, robust  cluster(firm_id)
eststo: reg  `var' critical_product_supplier good domestic_firm privately_held_firm log_spending_volume above_market duration_years, robust
}
esttab, b(2) r2 star(* 0.10 ** 0.05 *** 0.01)
eststo clear

***TABLE 4: DETERMINANTS OF CONTRACT DESIGN: HOLDUP PROBLEMS 

eststo clear

eststo: reg  transfer_ip_rights switching_time   					good domestic_firm privately_held_firm log_spending_volume, robust
eststo: reg  transfer_ip_rights switching_costs  					good domestic_firm privately_held_firm log_spending_volume, robust
eststo: reg  transfer_ip_rights switching_time   alternative_buyers good domestic_firm privately_held_firm log_spending_volume, robust
eststo: reg  transfer_ip_rights switching_costs  alternative_buyers good domestic_firm privately_held_firm log_spending_volume, robust

eststo: reg  duration_years  switching_time  good domestic_firm privately_held_firm log_spending_volume, robust
eststo: reg  duration_years  switching_costs good domestic_firm privately_held_firm log_spending_volume, robust
eststo: reg  open_duration switching_time    good domestic_firm privately_held_firm log_spending_volume, robust
eststo: reg  open_duration switching_costs   good domestic_firm privately_held_firm log_spending_volume, robust

esttab, b(2) r2 star(* 0.10 ** 0.05 *** 0.01)
eststo clear

***TABLE 5: DYNAMIC CONTRACTING: MORAL-HAZARD PROBLEMS 

eststo clear

eststo: reg   moral_hazard_clauses second_contract third_or_more_contract critical_product_supplier good domestic_firm privately_held_firm log_spending_volume date if open_duration!=1, robust
eststo: xtreg moral_hazard_clauses second_contract third_or_more_contract critical_product_supplier good domestic_firm privately_held_firm log_spending_volume date if open_duration!=1, i(firm_id) fe robust

eststo: reg   monitoring_clauses second_contract third_or_more_contract   critical_product_supplier good domestic_firm privately_held_firm log_spending_volume date if open_duration!=1, robust
eststo: xtreg monitoring_clauses second_contract third_or_more_contract   critical_product_supplier good domestic_firm privately_held_firm log_spending_volume date if open_duration!=1, i(firm_id) fe robust

eststo: reg   incentive_clauses second_contract third_or_more_contract    critical_product_supplier good domestic_firm privately_held_firm log_spending_volume date if open_duration!=1, robust
eststo: xtreg incentive_clauses second_contract third_or_more_contract    critical_product_supplier good domestic_firm privately_held_firm log_spending_volume date if open_duration!=1, i(firm_id) fe robust

esttab, b(2) r2 star(* 0.10 ** 0.05 *** 0.01)
eststo clear

***TABLE 6: DYNAMIC CONTRACTING AND MORAL-HAZARD PROBLEMS: CONTRACTIBILITY AND SUPPLIER QUALITY PROBLEMS

***Panel A. Contractibility: Goods versus Services

eststo clear

eststo: reg  moral_hazard_clauses second_contract third_or_more_contract critical_product_supplier good domestic_firm privately_held_firm log_spending_volume date if open_duration!=1 & good==1, robust
eststo: reg  moral_hazard_clauses second_contract third_or_more_contract critical_product_supplier good domestic_firm privately_held_firm log_spending_volume date if open_duration!=1 & good==0, robust
eststo: reg  monitoring_clauses   second_contract third_or_more_contract critical_product_supplier good domestic_firm privately_held_firm log_spending_volume date if open_duration!=1 & good==1, robust
eststo: reg  monitoring_clauses   second_contract third_or_more_contract critical_product_supplier good domestic_firm privately_held_firm log_spending_volume date if open_duration!=1 & good==0, robust
eststo: reg  incentive_clauses    second_contract third_or_more_contract critical_product_supplier good domestic_firm privately_held_firm log_spending_volume date if open_duration!=1 & good==1, robust
eststo: reg  incentive_clauses    second_contract third_or_more_contract critical_product_supplier good domestic_firm privately_held_firm log_spending_volume date if open_duration!=1 & good==0, robust

esttab, b(2) r2 star(* 0.10 ** 0.05 *** 0.01)
eststo clear

***Panel B. Quality Problems with Suppliers

eststo clear

eststo: reg  moral_hazard_clauses second_contract third_or_more_contract critical_product_supplier good domestic_firm privately_held_firm log_spending_volume date if open_duration!=1 & quality_problems==1, robust
eststo: reg  moral_hazard_clauses second_contract third_or_more_contract critical_product_supplier good domestic_firm privately_held_firm log_spending_volume date if open_duration!=1 & quality_problems==0, robust
eststo: reg  monitoring_clauses   second_contract third_or_more_contract critical_product_supplier good domestic_firm privately_held_firm log_spending_volume date if open_duration!=1 & quality_problems==1, robust
eststo: reg  monitoring_clauses   second_contract third_or_more_contract critical_product_supplier good domestic_firm privately_held_firm log_spending_volume date if open_duration!=1 & quality_problems==0, robust
eststo: reg  incentive_clauses    second_contract third_or_more_contract critical_product_supplier good domestic_firm privately_held_firm log_spending_volume date if open_duration!=1 & quality_problems==1, robust
eststo: reg  incentive_clauses    second_contract third_or_more_contract critical_product_supplier good domestic_firm privately_held_firm log_spending_volume date if open_duration!=1 & quality_problems==0, robust

esttab, b(2) r2 star(* 0.10 ** 0.05 *** 0.01)
eststo clear

***Table 7: DYNAMIC CONTRACTING AND HOLDUP PROBLEMS

**Panel A. Property Rights Theory

eststo clear

eststo: reg transfer_ip_rights second_contract third_or_more_contract switching_time  good domestic_firm privately_held_firm log_spending_volume date if   open_duration!=1, robust
eststo: reg transfer_ip_rights second_contract third_or_more_contract switching_costs good domestic_firm privately_held_firm log_spending_volume date if   open_duration!=1, robust

eststo: reg transfer_ip_rights second_contract third_or_more_contract switching_time  good domestic_firm privately_held_firm log_spending_volume date if   open_duration!=1 & supplier_renegotiates==1, robust
eststo: reg transfer_ip_rights second_contract third_or_more_contract switching_costs good domestic_firm privately_held_firm log_spending_volume date if   open_duration!=1 & supplier_renegotiates==1, robust

eststo: reg transfer_ip_rights second_contract third_or_more_contract switching_time  good domestic_firm privately_held_firm log_spending_volume date if   open_duration!=1 & supplier_renegotiates==0, robust
eststo: reg transfer_ip_rights second_contract third_or_more_contract switching_costs good domestic_firm privately_held_firm log_spending_volume date if   open_duration!=1 & supplier_renegotiates==0, robust

esttab, b(2) r2 star(* 0.10 ** 0.05 *** 0.01)
eststo clear

*Panel B. Transaction Cost Economics

eststo clear

eststo: reg duration_years second_contract third_or_more_contract switching_time   good domestic_firm privately_held_firm log_spending_volume date if open_duration!=1, robust
eststo: reg duration_years second_contract third_or_more_contract switching_costs  good domestic_firm privately_held_firm log_spending_volume date if open_duration!=1, robust

eststo: reg duration_years second_contract third_or_more_contract switching_time   good domestic_firm privately_held_firm log_spending_volume date if open_duration!=1 & supplier_renegotiates==1, robust
eststo: reg duration_years second_contract third_or_more_contract switching_costs  good domestic_firm privately_held_firm log_spending_volume date if open_duration!=1 & supplier_renegotiates==1, robust

eststo: reg duration_years second_contract third_or_more_contract switching_time   good domestic_firm privately_held_firm log_spending_volume date if open_duration!=1 & supplier_renegotiates==0, robust
eststo: reg duration_years second_contract third_or_more_contract switching_costs  good domestic_firm privately_held_firm log_spending_volume date if open_duration!=1 & supplier_renegotiates==0, robust

esttab, b(2) r2 star(* 0.10 ** 0.05 *** 0.01)
eststo clear

***Table 8: SUBSTITUTABILITY AND COMPLEMENTARITY IN CONTRACTING 
    
*Panel A. Contract Clauses Across Groups

eststo clear
sureg (monitoring_clauses incentive_clauses  transfer_ip_rights duration_years 		 	       critical_product_supplier good domestic_firm privately_held_firm log_spending_volume)  ///
(incentive_clauses monitoring_clauses   transfer_ip_rights   duration_years  			       critical_product_supplier good domestic_firm privately_held_firm log_spending_volume)  ///
(transfer_ip_rights incentive_clauses monitoring_clauses   duration_years      switching_time  critical_product_supplier good domestic_firm privately_held_firm log_spending_volume)  ///
(duration_years  transfer_ip_rights incentive_clauses monitoring_clauses       switching_time  critical_product_supplier good domestic_firm privately_held_firm log_spending_volume)  ///

esttab, b(2) r2 star(* 0.10 ** 0.05 *** 0.01)
eststo clear

*Panel B. Contract Clauses Within Groups: Monitoring Clauses

eststo clear
sureg (supplier_audit financial_information evaluation_meetings kpi_monitoring_system no_preferred_supplier critical_product_supplier good domestic_firm privately_held_firm log_spending_volume)  ///
(financial_information supplier_audit evaluation_meetings kpi_monitoring_system  no_preferred_supplier      critical_product_supplier good domestic_firm privately_held_firm log_spending_volume)  ///
(evaluation_meetings financial_information supplier_audit  kpi_monitoring_system no_preferred_supplier      critical_product_supplier good domestic_firm privately_held_firm log_spending_volume)  ///
(kpi_monitoring_system evaluation_meetings financial_information supplier_audit  no_preferred_supplier      critical_product_supplier good domestic_firm privately_held_firm log_spending_volume)  /// 
(no_preferred_supplier evaluation_meetings financial_information supplier_audit  kpi_monitoring_system      critical_product_supplier good domestic_firm privately_held_firm log_spending_volume)  ///
   
esttab, b(2) r2 star(* 0.10 ** 0.05 *** 0.01)
eststo clear

*Panel C. Contract Clauses Within Groups: Incentive Clauses

eststo clear
sureg (liability product_warranty availability_guarantee penalty bonus  critical_product_supplier good domestic_firm privately_held_firm log_spending_volume)  ///
(product_warranty liability availability_guarantee penalty bonus        critical_product_supplier good domestic_firm privately_held_firm log_spending_volume)  ///
(availability_guarantee product_warranty liability  penalty bonus       critical_product_supplier good domestic_firm privately_held_firm log_spending_volume)  ///
(penalty availability_guarantee product_warranty liability bonus        critical_product_supplier good domestic_firm privately_held_firm log_spending_volume)  /// 
(bonus penalty availability_guarantee product_warranty liability        critical_product_supplier good domestic_firm privately_held_firm log_spending_volume)  /// 
   
esttab, b(2) r2 star(* 0.10 ** 0.05 *** 0.01)
eststo clear

*****************************************************************************************************************************************************************************************************  
**********************************************************************ONLINE APPENDIX****************************************************************************************************************  
*****************************************************************************************************************************************************************************************************  
 
***ONLINE APPENDIX TABLE A1.—SAMPLE CONSTRUCTION

tab date

***ONLINE APPENDIX TABLE A4.—DYNAMIC CONTRACTING: INDIVIDUAL MORAL-HAZARD CLAUSES

tabstat moral_hazard_clauses monitoring_clauses incentive_clauses   supplier_audit financial_information evaluation_meetings kpi_monitoring_system no_preferred_supplier ///
liability product_warranty availability_guarantee penalty bonus   if first_contract==1 & open_duration!=1, stats(mean n) columns(statistics)

tabstat moral_hazard_clauses monitoring_clauses incentive_clauses   supplier_audit financial_information evaluation_meetings kpi_monitoring_system no_preferred_supplier ///
liability product_warranty availability_guarantee penalty bonus    if second_contract==1 & open_duration!=1, stats(mean n) columns(statistics)

tabstat moral_hazard_clauses monitoring_clauses incentive_clauses   supplier_audit financial_information evaluation_meetings kpi_monitoring_system no_preferred_supplier ///
liability product_warranty availability_guarantee penalty bonus   if third_or_more_contract==1 & open_duration!=1, stats(mean n) columns(statistics)

***t-test: First versus Second Contract

foreach var of varlist moral_hazard_clauses monitoring_clauses incentive_clauses   supplier_audit financial_information evaluation_meetings kpi_monitoring_system no_preferred_supplier ///
liability product_warranty availability_guarantee penalty bonus   {
  ttest `var' if third_or_more_contract!=1 & open_duration!=1, by(first_contract)
  }

***t-test: First versus Third Contract

foreach var of varlist moral_hazard_clauses monitoring_clauses incentive_clauses   supplier_audit financial_information evaluation_meetings kpi_monitoring_system no_preferred_supplier ///
liability product_warranty availability_guarantee penalty bonus    {
  ttest `var' if second_contract!=1 & open_duration!=1, by(first_contract)
  }
  
***t-test: Second versus Third Contract

foreach var of varlist moral_hazard_clauses monitoring_clauses incentive_clauses   supplier_audit financial_information evaluation_meetings kpi_monitoring_system no_preferred_supplier ///
liability product_warranty availability_guarantee penalty bonus    {
  ttest `var' if first_contract!=1 & open_duration!=1, by(second_contract)
  }    
 