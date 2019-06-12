*Data: CRdata_jpp_final
*Purpose: Replicate analysis for main text
*Date: 08/15/2017
*Output: Tables 2 and 3

cd "set file path here"

use "CRdata_jpp_final.dta", replace

**********************************************
*Main Text
**********************************************

*Policy liberalism level model
tsset state_panel cw_session, delta(1)

reg policy_score hou_chamber gov_rep cw_session ibn.state_panel, r nocon
est store model1

reg policy_score hou_chamber hou_majority gov_rep cw_session ibn.state_panel, r nocon
est store model4

*Abortion models
tsset, clear
tsset state_panel ab_session, delta(1)

*Level models
reg abortion_score hou_chamber gov_rep ab_session ibn.state_panel, nocon r
est store model2

reg abortion_score hou_chamber hou_majority gov_rep ab_session ibn.state_panel, nocon r
est store model5

*First-difference models
reg D.abortion_score D.hou_chamber gov_rep ibn.state_panel if ab_session!=., nocon r
est store model7

reg D.abortion_score D.hou_chamber D.hou_majority gov_rep ibn.state_panel if ab_session!=., nocon r
est store model9

*Charter school models
tsset, clear
tsset state_panel ch_session, delta(1)

*Level models
reg comp_score_coded hou_chamber gov_rep ch_session ibn.state_panel, nocon r
est store model3

reg comp_score_coded hou_chamber hou_majority gov_rep ch_session ibn.state_panel, nocon r
est store model6

*First-difference models
reg D.comp_score_coded D.hou_chamber gov_rep ibn.state_panel if ch_session!=., nocon r
est store model8

reg D.comp_score_coded D.hou_chamber D.hou_majority gov_rep ibn.state_panel if ch_session!=., nocon r
est store model10


****************************************************************************
*Export tables
****************************************************************************

*Table 2
#delimit ;
outreg2 [model1 model2 model3 model4 model5 model6] using "C:\Users\mdr\Dropbox\Vanderbilt\Fall 2013\Project\Charter\ClintonRichardson Draft\Tables\table2", 
sortvar(hou_chamber hou_majority gov_rep) tex(frag) replace dec(2) drop(ibn.state_panel*) label;
#delimit cr

*Table 3
#delimit ;
outreg2 [model7 model8 model9 model10] using "C:\Users\mdr\Dropbox\Vanderbilt\Fall 2013\Project\Charter\ClintonRichardson Draft\Tables\table3", 
sortvar(D.hou_chamber D.hou_majority gov_rep) tex(frag) replace dec(2) drop(ibn.state_panel*) label;
#delimit cr

