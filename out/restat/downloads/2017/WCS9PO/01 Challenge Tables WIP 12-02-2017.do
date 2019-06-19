
* Notes regarding "How Reliable is the Market for Technology" and the use of data from IMS. The following variables were constructed using proprietary data.
* Four patent characterstic variables were gatherd from IMS Patent Focus: method, composition, delivery and product. Data was matched into IMS Patent Focus by
* patent number. Patent numbers are in the data and also available in the FDA Orange Book.  Information on IMS Patent Focus is located here:
* http://www.imsbrogancapabilities.com/en/market-insights/lifecycle.html. The variable lnsales was obtained from IMS MIDAS. Academics may apply to IMS
* for access to data: https://www.iqvia.com/institute in lieu of purchashing data. 




************************************
* Challange regressions 03-29-2017 *
************************************

* Use Challenge Dataset: challenge.dta

*****
* Table 1 Descriptive Table
**** The descriptive of the variable "Challenge Outcome" comes from the outcome dataset
sum patent_piv patlaw licensed2 ln_sales product delivery composition ///
method claims bwd_cits fcite newpat pat_inn usa ///
quality_index_4 family_size patent_scope totalassets cumulative_pat ///
if licensed==1|inlic==0

*****
* Table 2: Impact of KSR on Para-IV challenges
*** Licensing subsample
* Model 1: Only controls
local control product delivery composition method claims bwd_cits fcite newpat pat_inn ln_sales 
eststo t2_0: xtreg patent_piv patlaw##usa inlic `control' if licensed2==1 | inlic==0, vce(cluster id) 

* Model 2: LPM with all controls + market FE
local control product delivery composition method claims bwd_cits fcite newpat pat_inn ln_sales i.atc_n   
eststo t2_1: xtreg patent_piv patlaw##usa inlic `control' if licensed2==1 | inlic==0, vce(cluster id) 

* Model 3: LPM with all controls + market FE + Firm FE
local control product delivery composition method claims bwd_cits fcite newpat pat_inn ln_sales i.atc_n i.firm
eststo t2_2: xtreg patent_piv patlaw##usa inlic `control' if licensed2==1 | inlic==0, vce(cluster id) 

esttab t2_* ///
	using challenge_tables.rtf, ///
	drop (*0* *.firm *.atc_n) b(%9.3f) se(%9.3f) star(* 0.11 ** 0.05 *** 0.01) append noobs notes ///
	mti num nogaps title("Table 2.Patent Level - Challenge - 2007 Change") ///
	order(patlaw usa 1.patlaw 1.usa 1.patlaw#1.usa inlic 1.inlic) ///
	scalars("N Obs.") sfmt(%12.0fc %12.3fc)



*****
* Table 3: Impact of KSR on Para-IV challenges with triple interactions
*** Licensing subsample
* Model 1: LPM with all controls
local control product delivery composition method claims bwd_cits fcite newpat pat_inn ln_sales
eststo t3_0: xtreg patent_piv patlaw##usa##inlic `control' if licensed2==1 | inlic==0, vce(cluster id) 
* Expected Values for Internal and External
margins inlic, at(usa==1 patlaw==1)
local inte el(r(table),floor(1),floor(1))
local int_p el(r(table),floor(4),floor(1))
local ext el(r(table),floor(1),floor(2))
local ext_p el(r(table),floor(4),floor(2))
qui eststo t3_0, add(inte `inte' int_p `int_p' ext `ext' ext_p `ext_p')
* Marginal effect (as difference between E(Internal) and E(External))
margins, dydx(inlic) at(usa==1 patlaw==1)
local diff el(r(table),floor(1),floor(2))
local diff_p el(r(table),floor(4),floor(2))
qui eststo t3_0, add(diff `diff' diff_p `diff_p')

* Model 2: LPM with all controls + market FE
local control product delivery composition method claims bwd_cits fcite newpat pat_inn ln_sales i.atc_n   
eststo t3_1: xtreg patent_piv patlaw##usa##inlic `control' if licensed2==1 | inlic==0, vce(cluster id) 
* Expected Values for Internal and External
margins inlic, at(usa==1 patlaw==1)
local inte el(r(table),floor(1),floor(1))
local int_p el(r(table),floor(4),floor(1))
local ext el(r(table),floor(1),floor(2))
local ext_p el(r(table),floor(4),floor(2))
qui eststo t3_1, add(inte `inte' int_p `int_p' ext `ext' ext_p `ext_p')
* Marginal effect (as difference between E(Internal) and E(External))
margins, dydx(inlic) at(usa==1 patlaw==1)
local diff el(r(table),floor(1),floor(2))
local diff_p el(r(table),floor(4),floor(2))
qui eststo t3_1, add(diff `diff' diff_p `diff_p')

* Model 3: LPM with all controls + market FE + Firm FE
local control product delivery composition method claims bwd_cits fcite newpat pat_inn ln_sales i.atc_n i.firm   
eststo t3_2: xtreg patent_piv patlaw##usa##inlic `control' if licensed2==1 | inlic==0, vce(cluster id) 
* Expected Values for Internal and External
margins inlic, at(usa==1 patlaw==1)
local inte el(r(table),floor(1),floor(1))
local int_p el(r(table),floor(4),floor(1))
local ext el(r(table),floor(1),floor(2))
local ext_p el(r(table),floor(4),floor(2))
qui eststo t3_2, add(inte `inte' int_p `int_p' ext `ext' ext_p `ext_p')
* Marginal effect (as difference between E(Internal) and E(External))
margins, dydx(inlic) at(usa==1 patlaw==1)
local diff el(r(table),floor(1),floor(2))
local diff_p el(r(table),floor(4),floor(2))
qui eststo t3_2, add(diff `diff' diff_p `diff_p')


esttab t3_* ///
	using challenge_tables.rtf, ///
	drop (*0* *.firm *.atc_n) b(%9.3f) se(%9.3f) star(* 0.11 ** 0.05 *** 0.01) append noobs notes ///
	mti num nogaps title("Table 3.Patent Level - Challenge with triple interaction - 2007 Change") ///
	order(1.patlaw 1.usa 1.inlic 1.patlaw#1.usa 1.patlaw#1.inlic 1.usa#1.inlic 1.patlaw#1.usa#1.inlic) ///
	scalars("N Obs." "inte Internal Patent" "int_p" "ext External Patent" "ext_p" "diff Difference" ///
	"diff_p p_value" "first F-stat" "first_p p-value") sfmt(%12.0fc %12.3fc)
	

****************
****************
* Appendix

* Table A1 Correlation Table
corr patent_piv outcome patlaw licensed2 ln_sales product delivery composition ///
method claims bwd_cits fcite newpat pat_inn usa ///
quality_index_4 family_size patent_scope totalassets cumulative_pat ///
if licensed==1|inlic==0


* Table A10
* Split sample based on OECD quality index

forvalues i = 1/4 {
disp `i'
local control product delivery composition method quality_index_4 newpat pat_inn ln_sales i.atc_n i.firm
eststo ta6b_`i': xtreg patent_piv patlaw##usa inlic `control' if q4==`i', vce(cluster id)
}

esttab ta6b_1 ta6b_2 ta6b_3 ta6b_4 ///
	using challenge_tables.rtf, ///
	drop (*0* *.firm *.atc_n) b(%9.3f) se(%9.3f) star(* 0.11 ** 0.05 *** 0.01) append noobs notes ///
	mti num nogaps title("Table A10.Probability of challenge based on OECD patent quality index (quartiles)") ///
	order(1.patlaw 1.usa 1.patlaw#1.usa inlic) ///
	scalars("N Obs.") sfmt(%12.0fc)

	


