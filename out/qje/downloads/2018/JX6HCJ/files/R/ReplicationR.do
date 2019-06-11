
*Stata warns that robust covariance estimator is not of full rank, drops a variable for F test

use IH_final, clear

gen bank_rosca_savings_you_resp= bank_savings_you_resp +rosca_savings_you_resp
foreach X in receive_shock_resp receive_shock_sp {
	gen `X'_150=150*`X' 
	}



*Table 3 - All okay

foreach X in expend_total_you_resp exp_total_private_you_resp exp_sharedfood_you_resp exp_medical_you_resp exp_children_you_resp exp_allother_shared_you_resp exp_transport_you_resp {
	xtreg `X' receive_shock_resp_150 receive_shock_sp_150 week1-week14 if gender==1, i(id) fe cluster(id) 
	} 
foreach X in expend_total_you_resp exp_total_private_you_resp exp_sharedfood_you_resp exp_medical_you_resp exp_children_you_resp exp_allother_shared_you_resp exp_transport_you_resp {
	xtreg `X' receive_shock_resp_150 receive_shock_sp_150 week1-week14 if gender==0, i(id) fe cluster(id) 
	}

*My code
foreach Y in 1 0 {
	foreach X in expend_total_you_resp exp_total_private_you_resp exp_sharedfood_you_resp exp_medical_you_resp exp_children_you_resp exp_allother_shared_you_resp exp_transport_you_resp {
		xtreg `X' receive_shock_resp_150 receive_shock_sp_150 week2-week14 if gender==`Y', i(id) fe cluster(id)
		}
	}
 

*Table 4 - All okay
foreach X in tot_flow_spouse_you_resp tot_flow_other_you_resp lab_hrs_you_resp lab_income_you_resp bank_rosca_savings_you_resp savings_you_resp {
	xtreg `X' receive_shock_resp_150 receive_shock_sp_150 week1-week14 if gender==1, i(id) fe cluster(id) 
	}
foreach X in tot_flow_spouse_you_resp tot_flow_other_you_resp lab_hrs_you_resp lab_income_you_resp bank_rosca_savings_you_resp savings_you_resp {
	xtreg `X' receive_shock_resp_150 receive_shock_sp_150 week1-week14 if gender==0, i(id) fe cluster(id) 
	} 

*My code
foreach Y in 1 0 {
	foreach X in tot_flow_spouse_you_resp tot_flow_other_you_resp lab_hrs_you_resp lab_income_you_resp bank_rosca_savings_you_resp savings_you_resp {
		xtreg `X' receive_shock_resp_150 receive_shock_sp_150 week2-week14 if gender==`Y', i(id) fe cluster(id) 
		}
	}

*Remaining tables don't report coefficients on treatment variables

save DatR, replace






