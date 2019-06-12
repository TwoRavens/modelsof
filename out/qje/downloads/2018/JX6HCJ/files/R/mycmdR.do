global cluster = "id"

use DatR, clear

global i = 1
global j = 1

*Table 3 
foreach Y in 1 0 {
	foreach X in expend_total_you_resp exp_total_private_you_resp exp_sharedfood_you_resp exp_medical_you_resp exp_children_you_resp exp_allother_shared_you_resp exp_transport_you_resp {
		mycmd (receive_shock_resp_150 receive_shock_sp_150) areg `X' receive_shock_resp_150 receive_shock_sp_150 week2-week14 if gender==`Y', absorb(id) cluster(id)
		}
	}
 
*Table 4 
foreach Y in 1 0 {
	foreach X in tot_flow_spouse_you_resp tot_flow_other_you_resp lab_hrs_you_resp lab_income_you_resp bank_rosca_savings_you_resp savings_you_resp {
		mycmd (receive_shock_resp_150 receive_shock_sp_150) areg `X' receive_shock_resp_150 receive_shock_sp_150 week2-week14 if gender==`Y', absorb(id) cluster(id) 
		}
	}



