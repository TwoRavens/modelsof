***Cavalieri-Russo-Verzichelli April 2017***
***Special issue ITPSR**********************
***This code creates a dataset of budgetary*
***authorization in Italy for the period ***
***1993-2016. Data are in millions of*******
***current Euros. **************************

*Declare Stata version

version 12

*open log

log using logfile, replace

*open replication dataset

use replication_dataset

*Generate new funcions


	*Function A: General Administration
	gen dlb_A = 0 

	qui foreach v of var s1_dlb s19_dlb s21_dlb s5_dlb dlb1_1 dlb1_2 dlb1_3  dlb1_4 dlb1_6 { 
		replace dlb_A = dlb_A + `v' if !missing(`v') 
	}

	gen lb_A = 0 

	qui foreach v of var s1_lb s19_lb s21_lb s5_lb lb1_1 lb1_2 lb1_3  lb1_4 lb1_6 { 
		replace lb_A = lb_A + `v' if !missing(`v') 
	}

	*Function B: Loan reimbursement and debt servicing (omessa perché per il momento non c'è negli anni 1993-1997)

	//gen B_dlb = 0 

	//qui foreach v of var s20_dlb s22_dlb dlb1_7 { 
	//	replace B_dlb = B_dlb + `v' if !missing(`v') 
	//}


	//gen B_lb = 0 

	//qui foreach v of var s20_lb s22_lb lb1_7 { 
	//	replace B_lb = B_lb + `v' if !missing(`v') 
	//}

	*Function C: Defence
	gen dlb_C = 0 

	qui foreach v of var s2_dlb dlb2_1 dlb2_3 dlb2_4 dlb2_5{ 
		replace dlb_C = dlb_C + `v' if !missing(`v') 
	}

	gen lb_C = 0 

	qui foreach v of var s2_lb lb2_1 lb2_3 lb2_4 lb2_5{ 
		replace lb_C = lb_C + `v' if !missing(`v') 
	}


	*Function D: Civil defence
	gen dlb_D = 0 

	qui foreach v of var s18_dlb dlb2_2{ 
		replace dlb_D = dlb_D + `v' if !missing(`v') 
	}

	gen lb_D = 0 

	qui foreach v of var s18_lb lb2_2{ 
		replace lb_D = lb_D + `v' if !missing(`v') 
	}

	*Function E: Public order
	gen dlb_E = 0 

	qui foreach v of var s4_dlb dlb3_1 dlb3_2 dlb3_5 dlb3_6{ 
		replace dlb_E = dlb_E + `v' if !missing(`v') 
	}

	gen lb_E = 0 

	qui foreach v of var s4_lb lb3_1 lb3_2 lb3_5 lb3_6{ 
		replace lb_E = lb_E + `v' if !missing(`v') 
	}

	*Function F: Law courts & prison
	gen dlb_F = 0 

	qui foreach v of var s3_dlb dlb3_3 dlb3_4{ 
		replace dlb_F = dlb_F + `v' if !missing(`v') 
	}

	gen lb_F = 0 

	qui foreach v of var s3_lb lb3_3 lb3_4{ 
		replace lb_F = lb_F + `v' if !missing(`v') 
	}

	*Fuzione G: Economic affairs
	gen dlb_G = 0 

	qui foreach v of var s16_dlb s17_dlb dlb4_1 dlb4_3 dlb4_4 dlb4_7 dlb4_8 dlb4_9{ 
		replace dlb_G = dlb_G + `v' if !missing(`v') 
	}

	gen lb_G = 0 

	qui foreach v of var s16_lb s17_lb lb4_1 lb4_3 lb4_4 lb4_7 lb4_8 lb4_9{ 
		replace lb_G = lb_G + `v' if !missing(`v') 
	}

	*Function H: Transport and communication
	gen dlb_H = 0 

	qui foreach v of var s12_dlb dlb4_5 dlb4_6{ 
		replace dlb_H = dlb_H + `v' if !missing(`v') 
	}

	gen lb_H = 0 

	qui foreach v of var s12_lb lb4_5 lb4_6{ 
		replace lb_H = lb_H + `v' if !missing(`v') 
	}

	*Function I: Agriculture and Environment
	gen dlb_I = 0 

	qui foreach v of var s13_dlb s15_dlb dlb4_2 dlb5_1 dlb5_2 dlb5_3 dlb5_4 dlb5_5 dlb5_6{ 
		replace dlb_I = dlb_I + `v' if !missing(`v') 
	}

	gen lb_I = 0 

	qui foreach v of var s13_lb s15_lb lb4_2 lb5_1 lb5_2 lb5_3 lb5_4 lb5_5 lb5_6{ 
		replace lb_I = lb_I + `v' if !missing(`v') 
	}

	*Function J: Local and regional levels of government
	gen dlb_J = 0 

	qui foreach v of var s17_dlb dlb1_8{ 
		replace dlb_J = dlb_J + `v' if !missing(`v') 
	}

	gen lb_J = 0 

	qui foreach v of var s17_lb lb1_8{ 
		replace lb_J = lb_J + `v' if !missing(`v') 
	}

	*Function K: Housing and community amenities
	gen dlb_K = 0 

	qui foreach v of var s8_dlb dlb6_1 dlb6_2 dlb6_3 dlb6_6{ 
		replace dlb_K = dlb_K + `v' if !missing(`v') 
	}

	gen lb_K = 0 

	qui foreach v of var s8_lb lb6_1 lb6_2 lb6_3 lb6_6{ 
		replace lb_K = lb_K + `v' if !missing(`v') 
	}

	*Function L: Social protection
	gen dlb_L = 0 

	qui foreach v of var s9_dlb s10_dlb dlb10_1 dlb10_2 dlb10_3 dlb10_4 dlb10_5 dlb10_6 dlb10_7 dlb10_9{ 
		replace dlb_L = dlb_L + `v' if !missing(`v') 
	}


	gen lb_L = 0 

	qui foreach v of var s9_lb s10_lb lb10_1 lb10_2 lb10_3 lb10_4 lb10_5 lb10_6 lb10_7 lb10_9{ 
		replace lb_L = lb_L + `v' if !missing(`v')
	}

	*Function M: Health
	gen dlb_M = 0 

	qui foreach v of var s11_dlb dlb7_1 dlb7_2 dlb7_3 dlb7_4 dlb7_5 dlb7_6{ 
		replace dlb_M = dlb_M + `v' if !missing(`v') 
	}

	gen lb_M = 0 

	qui foreach v of var s11_lb lb7_1 lb7_2 lb7_3 lb7_4 lb7_5 lb7_6{ 
		replace lb_M = lb_M + `v' if !missing(`v') 
	}

	*Function N: Education, culture, religion
	gen dlb_N = 0 

	qui foreach v of var s6_dlb dlb8_1 dlb8_2 dlb8_3 dlb8_4 dlb8_5 dlb8_6 dlb9_1 dlb9_2 dlb9_3 dlb9_5 dlb9_6 dlb9_8{ 
		replace dlb_N = dlb_N + `v' if !missing(`v') 
	}

	gen lb_N = 0 

	qui foreach v of var s6_lb lb8_1 lb8_2 lb8_3 lb8_4 lb8_5 lb8_6 lb9_1 lb9_2 lb9_3 lb9_5 lb9_6 lb9_8{ 
		replace lb_N = lb_N + `v' if !missing(`v') 
	}

	*Function O: University and research
	gen dlb_O = 0 

	qui foreach v of var s7_dlb dlb9_4 dlb9_7{ 
		replace dlb_O = dlb_O + `v' if !missing(`v') 
	}


	gen lb_O = 0 

	qui foreach v of var s7_lb lb9_4 lb9_7{ 
		replace lb_O = lb_O + `v' if !missing(`v') 
	}




*generate variables measuring authorizations in the Budget Law in terms of GDP
gen GDP_lbA = (lb_A)*100/gdp_current
label variable GDP_lbA "General administration"
gen GDP_lbC = (lb_C)*100/gdp_current
label variable GDP_lbC "Defence"
gen GDP_lbD = (lb_D)*100/gdp_current
label variable GDP_lbD "Civil defence"
gen GDP_lbE = (lb_E)*100/gdp_current
label variable GDP_lbE "Public order"
gen GDP_lbF = (lb_F)*100/gdp_current
label variable GDP_lbF "Law courts and prisons"
gen GDP_lbG = (lb_G)*100/gdp_current
label variable GDP_lbG "Economic affairs"
gen GDP_lbH = (lb_H)*100/gdp_current
label variable GDP_lbH "Transport and communication"
gen GDP_lbI = (lb_I)*100/gdp_current
label variable GDP_lbI "Agriculture and Environment"
gen GDP_lbJ = (lb_J)*100/gdp_current
label variable GDP_lbJ "Local and Reg. gov"
gen GDP_lbK = (lb_K)*100/gdp_current
label variable GDP_lbK "Housing"
gen GDP_lbL = (lb_L)*100/gdp_current
label variable GDP_lbL "Social protection"
gen GDP_lbM = (lb_M)*100/gdp_current
label variable GDP_lbM "Health"
gen GDP_lbN = (lb_N)*100/gdp_current
label variable GDP_lbN "Education and culture"
gen GDP_lbO = (lb_O)*100/gdp_current
label variable GDP_lbO "University and research"

*generate variables measuring authorizations in the Budget Bill in terms of GDP

gen GDP_dlbA = (dlb_A)*100/gdp_current
label variable GDP_dlbA "General administration"
gen GDP_dlbC = (dlb_C)*100/gdp_current
label variable GDP_dlbC "Defence"
gen GDP_dlbD = (dlb_D)*100/gdp_current
label variable GDP_dlbD "Civil defence"
gen GDP_dlbE = (dlb_E)*100/gdp_current
label variable GDP_dlbE "Public order"
gen GDP_dlbF = (dlb_F)*100/gdp_current
label variable GDP_dlbF "Law courts and prisons"
gen GDP_dlbG = (dlb_G)*100/gdp_current
label variable GDP_dlbG "Economic affairs"
gen GDP_dlbH = (dlb_H)*100/gdp_current
label variable GDP_dlbH "Transport and communication"
gen GDP_dlbI = (dlb_I)*100/gdp_current
label variable GDP_dlbI "Agriculture and Environment"
gen GDP_dlbJ = (dlb_J)*100/gdp_current
label variable GDP_dlbJ "Local and Reg. gov"
gen GDP_dlbK = (dlb_K)*100/gdp_current
label variable GDP_dlbK "Housing"
gen GDP_dlbL = (dlb_L)*100/gdp_current
label variable GDP_dlbL "Social protection"
gen GDP_dlbM = (dlb_M)*100/gdp_current
label variable GDP_dlbM "Health"
gen GDP_dlbN = (dlb_N)*100/gdp_current
label variable GDP_dlbN "Education and culture"
gen GDP_dlbO = (dlb_O)*100/gdp_current
label variable GDP_dlbO "University and research"

*generate variables with differences between Budget Bill & Budget Law in terms of GDP

gen LB_DLB_gdp1 = GDP_lbA - GDP_dlbA
label variable LB_DLB_gdp1 "General administration"
gen LB_DLB_gdp2 = GDP_lbC - GDP_dlbC
label variable LB_DLB_gdp2 "Defence"
gen LB_DLB_gdp3 = GDP_lbD - GDP_dlbD
label variable LB_DLB_gdp3 "Civil Defense"
gen LB_DLB_gdp4 = GDP_lbE - GDP_dlbE
label variable LB_DLB_gdp4 "Public order"
gen LB_DLB_gdp5 = GDP_lbF - GDP_dlbF
label variable LB_DLB_gdp5 "Law courts and prisons"
gen LB_DLB_gdp6 = GDP_lbG - GDP_dlbG
label variable LB_DLB_gdp6 "Economic affairs"
gen LB_DLB_gdp7 = GDP_lbH - GDP_dlbH
label variable LB_DLB_gdp7 "Transport and communication"
gen LB_DLB_gdp8 = GDP_lbI - GDP_dlbI
label variable LB_DLB_gdp8 "Agriculture and Environment"
gen LB_DLB_gdp9 = GDP_lbJ - GDP_dlbJ
label variable LB_DLB_gdp9 "Local and Reg. gov"
gen LB_DLB_gdp10 = GDP_lbK - GDP_dlbK
label variable LB_DLB_gdp10 "Housing"
gen LB_DLB_gdp11 = GDP_lbL - GDP_dlbL
label variable LB_DLB_gdp11 "Social protection"
gen LB_DLB_gdp12 = GDP_lbM - GDP_dlbM
label variable LB_DLB_gdp12 "Health"
gen LB_DLB_gdp13 = GDP_lbN - GDP_dlbN
label variable LB_DLB_gdp13 "Education and culture"
gen LB_DLB_gdp14 = GDP_lbO - GDP_dlbO
label variable LB_DLB_gdp14 "University and research" 

*generate variables with  percentage differences between Budget Law & Budget Bill 

gen LB_DLB_per1 = ((GDP_lbA - GDP_dlbA)/GDP_dlbA)*100
label variable LB_DLB_per1 "General administration"
gen LB_DLB_per2 = ((GDP_lbC - GDP_dlbC)/GDP_dlbC)*100
label variable LB_DLB_per2 "Defence"
gen LB_DLB_per3 = ((GDP_lbD - GDP_dlbD)/GDP_dlbD)*100
label variable LB_DLB_per3 "Civil Defense"
gen LB_DLB_per4 = ((GDP_lbE - GDP_dlbE)/GDP_dlbE)*100
label variable LB_DLB_per4 "Public order"
gen LB_DLB_per5 = ((GDP_lbF - GDP_dlbF)/GDP_dlbF)*100
label variable LB_DLB_per5 "Law courts and prisons"
gen LB_DLB_per6 = ((GDP_lbG - GDP_dlbG)/GDP_dlbG)*100
label variable LB_DLB_per6 "Economic affairs"
gen LB_DLB_per7 = ((GDP_lbH - GDP_dlbH)/GDP_dlbH)*100
label variable LB_DLB_per7 "Transport and communication"
gen LB_DLB_per8 = ((GDP_lbI - GDP_dlbI)/GDP_dlbI)*100
label variable LB_DLB_per8 "Agriculture and Environment"
gen LB_DLB_per9 = ((GDP_lbJ - GDP_dlbJ)/GDP_dlbJ)*100
label variable LB_DLB_per9 "Local and Reg. gov"
gen LB_DLB_per10 = ((GDP_lbK - GDP_dlbK)/GDP_dlbK)*100
label variable LB_DLB_per10 "Housing"
gen LB_DLB_per11 = ((GDP_lbL - GDP_dlbL)/GDP_dlbL)*100
label variable LB_DLB_per11 "Social protection"
gen LB_DLB_per12 = ((GDP_lbM - GDP_dlbM)/GDP_dlbM)*100
label variable LB_DLB_per12 "Health"
gen LB_DLB_per13 = ((GDP_lbN - GDP_dlbN)/GDP_dlbN)*100
label variable LB_DLB_per13 "Education and culture"
gen LB_DLB_per14 = ((GDP_lbO - GDP_dlbO)/GDP_dlbO)*100
label variable LB_DLB_per14 "University and research" 


*generate Budget law total spending in terms of GDP (excluding loan reimbursement)
gen TotLB_GDP = GDP_lbA + GDP_lbC + GDP_lbG + GDP_lbH + GDP_lbJ + GDP_lbL + GDP_lbM + GDP_lbD + GDP_lbE + GDP_lbF + GDP_lbI + GDP_lbK + GDP_lbN + GDP_lbO

*generate Budget bill total spending in terms of GDP (excluding loan reimbursement)
gen TotDLB_GDP = GDP_dlbA + GDP_dlbC + GDP_dlbG + GDP_dlbH + GDP_dlbJ + GDP_dlbL + GDP_dlbM + GDP_dlbD + GDP_dlbE + GDP_dlbF + GDP_dlbI + GDP_dlbK + GDP_dlbN + GDP_dlbO

*generate variables with proportion of expenditure to each section in Budget law
*generate the row total

foreach v of varlist  GDP_lbA-GDP_lbO {
gen Perc_`v' = (`v'/TotLB_GDP)*100
}

*generate variables with proportion of expenditure to each section in Budget bill
*generate the row total
foreach v of varlist  GDP_dlbA-GDP_dlbO {
gen Perc_`v' = (`v'/TotDLB_GDP)*100
}

*generate sum of squared deviations between the proportions of spending per category
gen IndexChangeAuth_rel =  1/14 *((Perc_GDP_lbA - Perc_GDP_dlbA)^2 + (Perc_GDP_lbC - Perc_GDP_dlbC)^2 + (Perc_GDP_lbD - Perc_GDP_dlbD)^2 + (Perc_GDP_lbE - Perc_GDP_dlbE)^2 + (Perc_GDP_lbF - Perc_GDP_dlbF)^2 + (Perc_GDP_lbG - Perc_GDP_dlbG)^2 + (Perc_GDP_lbH - Perc_GDP_dlbH)^2 + (Perc_GDP_lbI - Perc_GDP_dlbI)^2 + (Perc_GDP_lbJ - Perc_GDP_dlbJ)^2 + (Perc_GDP_lbK-Perc_GDP_dlbK)^2 + (Perc_GDP_lbL - Perc_GDP_dlbL)^2 + (Perc_GDP_lbM - Perc_GDP_dlbM)^2 + (Perc_GDP_lbN - Perc_GDP_dlbN)^2 + (Perc_GDP_lbO - Perc_GDP_dlbO)^2) 
label variable IndexChangeAuth_rel "Index of change in authorizations (relative)"
summarize IndexChangeAuth_rel, detail


*generate Spending growth in terms of GDP
gen SpendingGrowth = TotLB_GDP - TotDLB_GDP
label variable SpendingGrowth "Change in total expenditures (GDP points)"


*Drop old varibles
drop  s1_dlb s1_lb s2_dlb s2_lb s3_dlb s3_lb s4_dlb s4_lb s5_dlb s5_lb s6_dlb s6_lb s7_dlb s7_lb s8_dlb s8_lb s9_dlb s9_lb s10_dlb s10_lb s11_dlb s11_lb s12_dlb s12_lb s13_dlb s13_lb s14_dlb s14_lb s15_dlb s15_lb s16_dlb s16_lb s17_dlb s17_lb s18_dlb s18_lb s19_dlb s19_lb s20_dlb s20_lb s21_dlb s21_lb dlb1 lb1 dlb1_1 lb1_1 dlb1_2 lb1_2 dlb1_3 lb1_3 dlb1_4 lb1_4 dlb1_6 lb1_6 dlb1_7 lb1_7 dlb1_8 lb1_8 dlb2 lb2 dlb2_1 lb2_1 dlb2_2 lb2_2 dlb2_3 lb2_3 dlb2_4 lb2_4 dlb2_5 lb2_5 dlb3 lb3 dlb3_1 lb3_1 dlb3_2 lb3_2 dlb3_3 lb3_3 dlb3_4 lb3_4 dlb3_5 lb3_5 dlb3_6 lb3_6 dlb4 lb4 dlb4_1 lb4_1 dlb4_2 lb4_2 dlb4_3 lb4_3 dlb4_4 lb4_4 dlb4_5 lb4_5 dlb4_6 lb4_6 dlb4_7 lb4_7 dlb4_8 lb4_8 dlb4_9 lb4_9 dlb5 lb5 dlb5_1 lb5_1 dlb5_2 lb5_2 dlb5_3 lb5_3 dlb5_4 lb5_4 dlb5_5 lb5_5 dlb5_6 lb5_6 dlb6 lb6 dlb6_1 lb6_1 dlb6_2 lb6_2 dlb6_3 lb6_3 dlb6_6 lb6_6 dlb7 lb7 dlb7_1 lb7_1 dlb7_2 lb7_2 dlb7_3 lb7_3 dlb7_4 lb7_4 dlb7_5 lb7_5 dlb7_6 lb7_6 dlb8 lb8 dlb8_1 lb8_1 dlb8_2 lb8_2 dlb8_3 lb8_3 dlb8_4 lb8_4 dlb8_5 lb8_5 dlb8_6 lb8_6 dlb9 lb9 dlb9_1 lb9_1 dlb9_2 lb9_2 dlb9_3 lb9_3 dlb9_4 lb9_4 dlb9_5 lb9_5 dlb9_6 lb9_6 dlb9_7 lb9_7 dlb9_8 lb9_8 dlb10 lb10 dlb10_1 lb10_1 dlb10_2 lb10_2 dlb10_3 lb10_3 dlb10_4 lb10_4 dlb10_5 lb10_5 dlb10_6 lb10_6 dlb10_7 lb10_7 dlb10_9 lb10_9 _merge1 _merge2 _merge

* Drop year 2003 for which data are missing
keep if year!=2003

* FIGURE 1

twoway (scatter IndexChangeAuth_rel SpendingGrowth, mlabel(year)) (lfit IndexChangeAuth_rel SpendingGrowth)

* FIGURE 2 
graph hbar (asis) LB_DLB_gdp1 LB_DLB_gdp2 LB_DLB_gdp3 LB_DLB_gdp4 LB_DLB_gdp5 LB_DLB_gdp6 LB_DLB_gdp7 LB_DLB_gdp8 LB_DLB_gdp9 LB_DLB_gdp10 LB_DLB_gdp11 LB_DLB_gdp12 LB_DLB_gdp13 LB_DLB_gdp14 if year==1995, title(1995) showyvars yvaroptions(label(angle(forty_five) labsize(small))) legend(off) scheme(s2mono)
graph save graph1995, replace
graph export graph1995.png, replace

graph hbar (asis) LB_DLB_gdp1 LB_DLB_gdp2 LB_DLB_gdp3 LB_DLB_gdp4 LB_DLB_gdp5 LB_DLB_gdp6 LB_DLB_gdp7 LB_DLB_gdp8 LB_DLB_gdp9 LB_DLB_gdp10 LB_DLB_gdp11 LB_DLB_gdp12 LB_DLB_gdp13 LB_DLB_gdp14 if year==1997,  title(1997) showyvars yvaroptions(label(angle(forty_five) labsize(small))) legend(off) scheme(s2mono)
graph save graph1997, replace
graph export graph1997.png, replace

graph hbar (asis) LB_DLB_gdp1 LB_DLB_gdp2 LB_DLB_gdp3 LB_DLB_gdp4 LB_DLB_gdp5 LB_DLB_gdp6 LB_DLB_gdp7 LB_DLB_gdp8 LB_DLB_gdp9 LB_DLB_gdp10 LB_DLB_gdp11 LB_DLB_gdp12 LB_DLB_gdp13 LB_DLB_gdp14 if year==2009, title(2009) showyvars yvaroptions(label(angle(forty_five) labsize(small))) legend(off) scheme(s2mono)
graph save graph2009,  replace
graph export graph2009.png, replace

graph hbar (asis)LB_DLB_gdp1 LB_DLB_gdp2 LB_DLB_gdp3 LB_DLB_gdp4 LB_DLB_gdp5 LB_DLB_gdp6 LB_DLB_gdp7 LB_DLB_gdp8 LB_DLB_gdp9 LB_DLB_gdp10 LB_DLB_gdp11 LB_DLB_gdp12 LB_DLB_gdp13 LB_DLB_gdp14 if year==2012, title(2012) showyvars yvaroptions(label(angle(forty_five) labsize(small))) legend(off) scheme(s2mono)
graph save graph2012, replace
graph export graph2012.png, replace

gr combine graph1995.gph graph1997.gph graph2009.gph graph2012.gph, scheme(s2mono) xcommon saving(graph2, replace)


*close


