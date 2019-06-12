/*******************************************************************************
	This do file replicates Tables 1-7 in the RESTAT paper,
	"Transfers, behavior change communication, and intimate partner violence:
	Post-program evidence from rural Bangladesh."
	
	Data file used: RESTAT Bangladesh IPV_Replication.dta
	Output file produced: RESTAT Bangladesh IPV_Replication.doc
	
	Last modified: Shalini Roy
	Date last modified: August 16, 2018
********************************************************************************/
clear
clear matrix
set more off

****************** USE REPLICATION DATA FILE ***************************
************************************************************************
* File with merged variables on IPV, characteristics of woman respondent and husband, mechanisms
	use "RESTAT Bangladesh IPV_Replication.dta", clear

	
****************** GLOBALS FOR OUTCOME VARIABLES, COVARIATES, MECHANISMS ***********************
************************************************************************************************

	* Globals for prevalence of IPV in last 6 months at post-endline
		local w last6m
		global ipv_emotional_`w' "ipv_`w'1 ipv_`w'2 ipv_`w'3 ipv_`w'4"
		global ipv_physical_`w' "ipv_`w'5 ipv_`w'6 ipv_`w'7 ipv_`w'8 ipv_`w'9 ipv_`w'10"
		global ipv_`w' "ipv_anyviol_`w' ipv_anyemot_`w' ipv_anyphys_`w'"
		
	* Globals for frequency of IPV in last 6 months at post-endline
		global freq_violence_p "freqany freqemot freqphys"
		global maxfreq_violence_p "maxfreqany maxfreqemot maxfreqphys"

	* Globals for covariates - baseline characteristics of woman respondent and husband
		local r resp
		local rh rhusb
		global resp_char `r'_age_b `r'_relat1 `r'_relat2 `r'_relat4 `r'_lit `r'_educ_b `r'_mother_inlaw_b `r'_father_inlaw_b resp_nchild0t5 resp_nchild6t15
		global rhusb_char `rh'_age_b `rh'_lit `rh'_educ_b

	* Globals for mechanisms
		global agency_e "internallocus_e haverights_e canchange_e responsible_e"
		global hhecon_e "pcmexp_e totasset_cash_e"

******************** SPECIFICATIONS FOR REGRESSIONS *********************
*************************************************************************
* set specifications for regressions

		* specify survey design: randomization at village level, stratified at zone level
		* Relevant survey design is based on baseline location
		svyset a03_b, str(zone_b)
		
		* specify treatment arms relevant to each zone at post-endline
		global treat_north "cash cash_bcc"
		global treat_south "food food_bcc"

	
**************** CORE IMPACT ESTIMATES: IPV at post-endline **********************
**********************************************************************************
/* Specifications:
	- Sample: women who are married at baseline and are the respondents in midline, endline, and post-endline
	- Controls: respondent's age, edu, literacy, relationship to head, num of children
				husband's age, edu, literacy
				hhsize
	- randomization at village level, stratified at zone level
*/


* control variables
	global controls_basic north
	global controlsp north 	resp_age_b resp_relat2 resp_lit resp_educ_b resp_nchild0t5 resp_nchild6t15 rhusb_age_b rhusb_educ rhusb_lit hhsize_b
	global controls 		resp_age_b resp_relat2 resp_lit resp_educ_b resp_nchild0t5 resp_nchild6t15 rhusb_age_b rhusb_educ rhusb_lit hhsize_b

local TableX=0

* Table 1: Prevalence IPV post endline on treatment arms, probit

	outreg, clear
	foreach IPV of varlist $ipv_last6m {
		local lab: var label `IPV'
		
		*means
			sum `IPV' if control==1 
			local mean : display %4.2f r(mean)
		*probit, base specification
			svy: probit `IPV' transfer transfer_bcc $controls_basic 
			margin,dydx(*) post
		*test equality of coefficient
			testnl _b[transfer]=_b[transfer_bcc]
			local p1 : display %4.2f r(p)
			
		xi:outreg, merge varlabels bdec(2) se starlevels(10 5 1) keep(transfer transfer_bcc) ctitle("","`lab'") ///
		addrows("Mean of Control", "`mean'"\"Strata Indicator","X"\"Extended Controls", ""\"P-value: Transfer=Transfer+BCC",`p1')
}
	foreach IPV of varlist $ipv_last6m {
		local lab: var label `IPV'

		*means
			sum `IPV' if control==1 & rhusb_age_b~=.
			local mean : display %4.2f r(mean)
		*probit, extended controls
			svy: probit `IPV' transfer transfer_bcc $controlsp
			margin,dydx(*) post
		*test equality of coefficient
			testnl _b[transfer]=_b[transfer_bcc]
			local p2 : display %4.2f r(p)
		
		xi:outreg, merge varlabels bdec(2) se starlevels(10 5 1) keep(transfer transfer_bcc) ctitle("","`lab'") ///
		addrows("Mean of Control", "`mean'"\"Strata Indicator","X"\"Extended Controls", "X"\"P-value: Transfer=Transfer+BCC",`p2')
		}	
		
		local TableX=`TableX'+1		
		outreg using "RESTAT Bangladesh IPV_Replication", replay replace bdec(2) se starlevels(10 5 1) coljust(l;c)  ///
		title("Table `TableX': Impact of treatment arms on prevalence of IPV in past 6 months, post-endline, pooled North and South") colwidth(30 10 10 10 10 10 10) ///
		basefont(fs10) titlfont(fs11 b) hlines(1{0};1{0};{0}1;1{0}1) hlstyle(s;d;s;s)   ///
		note("Marginal effects of probit models. Extended controls include baseline characteristics of woman and husband." ///
		"Standard errors clustered at village level.* p<0.1; ** p<0.05; *** p<0.01.") landscape ///
		ctitle("", Emotional or physical, Emotional, Physical, Emotional or physical, Emotional, Physical)

* Table 2: Frequency IPV post endline on treatment arms, OLS

		outreg, clear
		foreach IPV in $freq_violence_p $maxfreq_violence_p  {
		*means
			sum `IPV' if control==1 & rhusb_age_b~=.
			local mean : display %4.2f r(mean)
		*OLS, extended controls
			svy: reg `IPV' transfer transfer_bcc $controlsp 
		*test equality of coefficient
			testnl _b[transfer]=_b[transfer_bcc]
			local p2 : display %4.2f r(p)
		
		xi:outreg, merge varlabels bdec(2) se starlevels(10 5 1) keep(transfer transfer_bcc) ///
		addrows("Mean of Control", "`mean'"\"Strata Indicator","X"\"Extended Controls", "X"\"P-value: Transfer=Transfer+BCC",`p2')
		}	
		
		local TableX=`TableX'+1		
		outreg using "RESTAT Bangladesh IPV_Replication", replay addtable bdec(2) se starlevels(10 5 1) coljust(l;c)  ///
		title("Table `TableX': Impact of treatment arms on frequency of IPV in past 6 months, post-endline, pooled North and South")  ///
		basefont(fs10) titlfont(fs11 b) hlines(1{0};1{0};{0}1;1{0}1) hlstyle(s;d;s;s)  pretext("\page")  ///
		note("Extended controls include baseline characteristics of woman and husband." ///
		"Standard errors clustered at village level. * p<0.1; **p<0.05; *** p<0.01.") landscape colwidth(35 10 10 10 10 10 10) ///
		
* Table 3: Prevalence IPV individual acts post endline on treatment arms, probit

	local i=0
	foreach var of varlist $ipv_emotional_last6m $ipv_physical_last6m {
		outreg, clear
		local lab: var label `var'
		local i=`i'+1
		
		*mean
			mean `var' if control==1 
			outreg, merge  bdec(2) se nostars  rtitle("`lab'") noautosumm stats(b)

		*regression, extended controls
			svy: probit `var' transfer transfer_bcc $controlsp
			margin, dydx(*) post
			xi:outreg, merge bdec(2) se starlevels(10 5 1) keep(transfer) noautosumm nolegend rtitle("`lab'") ///
			
			svy: probit `var' transfer transfer_bcc $controlsp
			margin, dydx(*) post
		*test equality of coefficient
			testnl _b[transfer]=_b[transfer_bcc]
			local p1 : display %4.2f r(p)
			
		xi:outreg, merge bdec(2) se starlevels(10 5 1) keep(transfer_bcc) noautosumm nolegend rtitle("`lab'")  ///
			addcols(`p1')
		
		outreg, replay store(`i')
		local j=`i'-1
		outreg, replay(`j') append(`i') store(`i')
		}
	
		local TableX=`TableX'+1		
		outreg using "RESTAT Bangladesh IPV_Replication", replay(`i') addtable bdec(2) se starlevels(10 5 1) coljust(l;c)  ///
		title("Table `TableX': Impact of treatment arms on prevalence of IPV acts in past 6 months, post-endline, pooled North and South")  ///
		basefont(fs10) titlfont(fs11 b)   pretext("\page")  ///
		note("Marginal effects of probit models. Extended controls include baseline characteristics of woman and husband." ///
		"Standard errors clustered at village level. * p<0.1; ** p<0.05; *** p<0.01.") landscape colwidth(40 10 10 10 10) ///
		ctitle("", "Mean of control", Coefficient of transfer, "Coefficient of transfer +BCC", "P-value: Transfer=Transfer+BCC" )

* Table 4: Prevalence IPV post endline, cash and food treatment by zones to compare coefficients, probit
	
		outreg, clear
		
		*North
		local i=0
		foreach W in $ipv_last6m {
			local i=`i'+1
			svy: probit `W' cash cash_bcc $controls if zone_b=="North"
			est store cash_`i'
			margin,dydx(*) post
		
			testnl _b[cash]=_b[cash_bcc] 
			local p1 : display %4.2f r(p)
			
			sum `W' if treat_b==6 & zone_b=="North"
			local mean : display %4.2f r(mean)
			
			xi:outreg, merge varlabels bdec(2) se starlevels(10 5 1) keep(cash cash_bcc ) noauto ///
			addrows("Mean of control", "`mean'"\"P-value: Cash=Cash+BCC","`p1'"\South )
		}
		outreg, replay store(North)
		
		*South
		outreg, clear
		local i=0
		foreach W in $ipv_last6m {
			local i=`i'+1
			svy: probit `W' food food_bcc $controls if zone_b=="South"
			est store food_`i'
			margin,dydx(*) post
		
			testnl _b[food]=_b[food_bcc] 
			local p1 : display %4.2f r(p)
			
			sum `W' if treat_b==6 & zone_b=="South"
			local mean : display %4.2f r(mean)
			xi:outreg, merge varlabels bdec(2) se starlevels(10 5 1) keep(food food_bcc )noauto ///
				addrows("Mean of control", "`mean'"\"P-value: Food=Food+BCC","`p1'" ) 
		}
		outreg, replay store(South)
		outreg, replay(North) append(South)
		
			*testing difference btween cash and food
			local i=0
			foreach W in $ipv_last6m {
				local i=`i'+1
				suest cash_`i' food_`i'
				testnl [cash_`i'_`W']cash=[food_`i'_`W']food
					local p2_`W' : display %4.2f r(p)
				testnl [cash_`i'_`W']cash_bcc=[food_`i'_`W']food_bcc
					local p3_`W' : display %4.2f r(p)
			}

		local TableX=`TableX'+1
		outreg using "RESTAT Bangladesh IPV_Replication", replay addtable bdec(2) se starlevels(10 5 1) coljust(l;c)  ///
		title("Table `TableX': Impact of treatment arms on prevalence of IPV in past 6 months, post-endline, North vs. South") colwidth(35 10 10 10 10 10 10 ) ///
		basefont(fs10) titlfont(fs11 b) hlines(11000001000000101)   ///
		note("Marginal effects of probit models. Extended controls include baseline characteristics of woman " ///
		"and husband. Standard errors clustered at village level. * p<0.1; ** p<0.05; *** p<0.01.") ///
		ctitle("", Emotional or physical, Emotional, Physical)  pretext("\page") ///
		addrows("P-value: Cash=Food", "`p2_ipv_anyviol_last6m'", "`p2_ipv_anyemot_last6m'","`p2_ipv_anyphys_last6m'"\ ///
		"P-value: Cash+BCC=Food+BCC", "`p3_ipv_anyviol_last6m'", "`p3_ipv_anyemot_last6m'","`p3_ipv_anyphys_last6m'") 
		
	

********************************* Mechanisms ************************************
**********************************************************************************

* 1. WOMEN'S THREATPOINT

	* Table 5: Economic resources
	
		* Controls money across rounds, probit
			outreg, clear
			foreach var of varlist control_money_m control_money_e control_money_p  {
				
				*means
					sum `var' if control==1 & rhusb_age_b~=.
					local mean : display %4.2f r(mean)
				*probit, extended controls
					svy: prob `var' transfer transfer_bcc $controlsp 
					margin, dydx(*) post
				*test equality of coefficient
					testnl _b[transfer]=_b[transfer_bcc]
					local p2 : display %4.2f r(p)
				
			xi:outreg, merge varlabels bdec(2) se starlevels(10 5 1) keep(transfer transfer_bcc)   ///
			addrows("Mean of Control", "`mean'"\"P-value: Transfer=Transfer+BCC",`p2'\"Panel B: Probability that a woman works" )
			}	
			outreg, replay store(control)
			
		* Probability that women works across rounds, probit
			outreg, clear
			foreach var of varlist u1_01_m u1_01_e u1_01_p  {
		
				*means
					sum `var' if control==1 & rhusb_age_b~=.
					local mean : display %4.2f r(mean)
				*probit, extended controls
					svy: prob `var' transfer transfer_bcc $controlsp 
					margin, dydx(*) post
				*test equality of coefficient
					testnl _b[transfer]=_b[transfer_bcc]
					local p2 : display %4.2f r(p)
			
			xi:outreg, merge varlabels bdec(2) se starlevels(10 5 1) keep(transfer transfer_bcc) ///
			addrows("Mean of Control", "`mean'"\"P-value: Transfer=Transfer+BCC",`p2')
			}	
			
			outreg, replay store(work)
			outreg, replay(control) append(work)
			
			local TableX=`TableX'+1
			outreg using "RESTAT Bangladesh IPV_Replication", replay addtable bdec(2) se starlevels(10 5 1) coljust(l;c)  ///
			title("Table `TableX': Impact of treatment arms on a woman's economic resources, across rounds, pooled North and South")  ///
			basefont(fs10) titlfont(fs11 b) ctitle("", Midline, Endline, Post-endline) hlines(11000000100000001)  ///
			note("Marginal effects of probit models. Extended controls include baseline characteristics of woman" ///
			"and husband. Standard errors clustered at village level.* p<0.1; ** p<0.05; *** p<0.01. Control " ///
			"over money defined as controlling money needed to buy food, clothes, medicine, toiletries." ///
			"Woman working defined as working or doing business that brings in cash, food, or assets.") ///
			landscape colwidth(30 10 10 10)  pretext("\page")

	* Table 6: Agency, endline, OLS
		local i=0
		foreach var of varlist $agency_e  {
			outreg, clear
			local lab: var label `var'
			local i=`i'+1
			
			*means
				mean `var' if control==1 
				outreg, merge  bdec(2) se nostars  rtitle("`lab'") noautosumm stats(b) nocoltitl  

			*OLS, extended controls, transfer coefficient
				svy: reg `var' transfer transfer_bcc $controlsp
				xi:outreg, merge bdec(2) se starlevels(10 5 1) keep(transfer) noautosumm nolegend rtitle("`lab'") nocoltitl   ///
			
			*OLS, extended controls, transfer+BCC coefficient
				svy: reg `var' transfer transfer_bcc $controlsp
				*test equality of coefficient
				test _b[transfer]=_b[transfer_bcc]
				local p1 : display %4.2f r(p)
				xi:outreg, merge bdec(2) se starlevels(10 5 1) keep(transfer_bcc) noautosumm nolegend rtitle("`lab'")  ///
				addcols(`p1') nocoltitl  
			
			outreg, replay store(`i')
			local j=`i'-1
			outreg, replay(`j') append(`i') store(`i')
			}	
			
			local TableX=`TableX'+1		
			outreg using "RESTAT Bangladesh IPV_Replication", replay(`i') addtable bdec(2) se starlevels(10 5 1) coljust(l;c)  ///
			title("Table `TableX': Impact of treatment arms on agency, endline, pooled North and South")  ///
			basefont(fs10) titlfont(fs11 b) hlines(1{0};1{0};{0}1;1{0}1) hlstyle(s;d;s;s)  pretext("\page")  ///
			note("Extended controls include baseline characteristics of woman and husband." ///
			"Standard errors clustered at village level. * p<0.1; ** p<0.05; *** p<0.01.") landscape colwidth(40 10 10 10 10) ///
			ctitle("", "Mean of control", Coefficient of transfer, "Coefficient of transfer +BCC", "P-value: Transfer=Transfer+BCC" )
			

* 2. POVERTY RELATED STRESS

	* Table 7: Household expenditures and assets, endline, OLS
		local i=0
		foreach var of varlist $hhecon_e  {
			outreg, clear
			local lab: var label `var'
			local i=`i'+1
			
			*mean
				mean `var' if control==1 
				outreg, merge  bdec(2) se nostars  rtitle("`lab'") noautosumm stats(b) nocoltitl  

			*OLS, extended controls, transfer coefficient
				svy: reg `var' transfer transfer_bcc $controlsp
				xi:outreg, merge bdec(2) se starlevels(10 5 1) keep(transfer) noautosumm nolegend rtitle("`lab'") nocoltitl   ///
			
			*OLS, extended controls, transfer+BCC coefficient
				svy: reg `var' transfer transfer_bcc $controlsp
			*test equality of coefficient
				test _b[transfer]=_b[transfer_bcc]
				local p1 : display %4.2f r(p)
				
			xi:outreg, merge bdec(2) se starlevels(10 5 1) keep(transfer_bcc) noautosumm nolegend rtitle("`lab'")  ///
				addcols(`p1') nocoltitl  
			
			outreg, replay store(`i')
			local j=`i'-1
			outreg, replay(`j') append(`i') store(`i')
			}
			
			local TableX=`TableX'+1		
			outreg using "RESTAT Bangladesh IPV_Replication", replay(`i') addtable bdec(2) se starlevels(10 5 1) coljust(l;c)  ///
			title("Table `TableX': Impact of treatment arms on household resources, endline, pooled North and South")  ///
			basefont(fs10) titlfont(fs11 b)   pretext("\page")  ///
			note("Extended controls include baseline characteristics of woman and husband." ///
			"Standard errors clustered at village level. * p<0.1; ** p<0.05; *** p<0.01.") landscape colwidth(40 10 10 10 10) ///
			ctitle("", "Mean of control", Coefficient of transfer, "Coefficient of transfer +BCC", "P-value: Transfer=Transfer+BCC" )

