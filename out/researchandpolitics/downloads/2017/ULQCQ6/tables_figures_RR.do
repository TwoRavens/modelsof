/* Naval Paper Replication Materials */
/* Tables and Figures */

* Table 1 Models

	// Model 1
ivprobit ncmiddum ncmidlag polity2 open s_lead (ton10 = y_2000 urbprop) ///
	if year >= 1885 & landlocked == 0, vce(robust) nolog 

	// Model 2
ivprobit ncmiddum ncmidlag polity2 open s_lead (ton10 = y_2000 urbprop) ///
	if year >= 1885 & landlocked == 0  & MajshipAlt > 0, vce(robust) nolog

	// Model 3
ivprobit ncmiddum ncmidlag polity2 open s_lead (ton10 = y_2000 urbprop) ///
	if year >= 1885 & landlocked == 0  & MajshipAlt == 0, vce(robust) nolog

	// Model 4
ivprobit ncmiddum ncmidlag polity2 open s_lead (MajshipAlt = y_2000 urbprop) ///
	if year >= 1885 & landlocked == 0, vce(robust) nolog

* Figure 1 Code
ivprobit ncmiddum ncmidlag polity2 open s_lead (ton10 = y_2000 urbprop) ///
	if year >= 1885 & landlocked == 0, vce(robust) nolog first
	
margins, atmeans at(ton10=(3(3)39)) predict(pr) 

marginsplot, yline(0) level(90) /*name(base)*/

* Figure 2 Code
ivprobit ncmiddum ncmidlag polity2 open s_lead (MajshipAlt = y_2000 urbprop) ///
	if year >= 1885 & landlocked == 0, vce(robust) first nolog
	
margins, atmeans at(MajshipAlt=(0(1)5)) predict(pr) 

marginsplot, level(90) /*name(base)*/


* Table 2 Models

	// Model 5
ivreg2 ncmiddum ncmidlag polity2 open s_lead (ton10 = y_2000 urbprop) ///
	if year >= 1885 & landlocked == 0, robust first savefirst savefprefix(model5)
	
	// Model 6
ivreg2 ncmiddum ncmidlag polity2 open s_lead (MajshipAlt = y_2000 urbprop) ///
	if year >= 1885 & landlocked == 0, robust first savefirst savefprefix(model6)


* Additional Robustness Models (for the supplemental file)

	// Model 7
probit ncmiddum ton10 energy ncmidlag polity2 open s_lead ///
	if year >= 1885 & totton > 0 & landlocked == 0, cluster(ccode) nolog 

	// Model 8
probit ncmiddum ton10 energy ncmidlag polity2 open s_lead ///
	if year >= 1885 & totton > 0 & landlocked == 0  & MajshipAlt > 0, cluster(ccode) nolog
	
	// Model 9
probit ncmiddum ton10 energy ncmidlag polity2 open s_lead ///
	if year >= 1885 & totton > 0 & landlocked == 0  & MajshipAlt == 0, cluster(ccode) nolog
	
	// Model 10
probit ncmiddum MajshipAlt energy ncmidlag polity2 open s_lead ///
	if year >= 1885 & totton > 0 & landlocked == 0, cluster(ccode) nolog
	
	// Model 11
ivprobit ncmiddum ncmidlag polity2 open s_lead (ton10 = y_2000 urbprop) ///
	if year >= 1885 & totton > 0 & landlocked == 0  & majshipATTsub > 0, robust nolog
	
	// Model 12
ivprobit ncmiddum ncmidlag polity2 open s_lead (ton10 = y_2000 urbprop) ///
	if year >= 1885 & totton > 0 & landlocked == 0  & majshipATTsub == 0, robust nolog
	
	// Model 13
ivprobit ncmiddum ncmidlag polity2 open s_lead (majshipATTsub = y_2000 urbprop) ///
	if year >= 1885 & totton > 0 & landlocked == 0, vce(robust) nolog

