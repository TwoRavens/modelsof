use "hr.env.data.dta", clear

label variable d_main "Main"
label variable d_litigation "Litigation"
label variable d_accountability "Accountability"
label variable d_leverage "Leverage"
label variable d_symbolic "Symbolic"
label variable d_information "Information"
label variable d_capacity "Capacity"
      
label variable female "Female"
label variable international "International"
label variable ngo_budget_100m "Budget > 100m"
label variable policy_area "Environmental NGO"
label variable econ "Econ Background"
label variable law "Law Degree"
label variable ideology "Ideology"

reg d_main policy_area ngo_budget_100m international law econ ideology female, robust 
outreg2 using ngo_regressions.doc, label replace bdec(1) sdec(2) 
reg d_litigation policy_area ngo_budget_100m international law econ ideology female, robust 
outreg2 using ngo_regressions.doc, label append bdec(1) sdec(2)
reg d_accountability policy_area ngo_budget_100m international law econ ideology female, robust 
outreg2 using ngo_regressions.doc, label append bdec(1) sdec(2)
reg d_leverage policy_area ngo_budget_100m international law econ ideology female, robust 
outreg2 using ngo_regressions.doc, label append bdec(1) sdec(2)
reg d_symbolic policy_area ngo_budget_100m international law econ ideology female, robust 
outreg2 using ngo_regressions.doc, label append bdec(1) sdec(2)
reg d_information policy_area ngo_budget_100m international law econ ideology female, robust 
outreg2 using ngo_regressions.doc, label append bdec(1) sdec(2)
reg d_capacity policy_area ngo_budget_100m international law econ ideology female, robust 
outreg2 using ngo_regressions.doc, label append bdec(1) sdec(2)