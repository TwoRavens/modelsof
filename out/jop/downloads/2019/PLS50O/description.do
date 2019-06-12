
*     ***************************************************************** * 
*     ***************************************************************** * 
*       File-Name:      description.do                                  * 
*       Date:           April 5, 2019                                   * 
*       Author:         Bowler, Gschwend, Indridason                    * 
*       Purpose:      	Compiles description*.dta from all studies and  *
*                       generates overview table for APPENDIX           * 
* 	    Input File:     description*.dta                                * 
*       Data Output:    desc_g.tex, desc_a.tex, desc_a.tex              *              
*     ****************************************************************  * 
*     ****************************************************************  * 



// ****************************************************************************************
// ***** Descriptive Statistics: How many R place parties & coalitions on L/R scale? *******
// ****************************************************************************************


use description_g, clear
append using description_a
append using description_s

compress
save description, replace


***************
*** Germany ***
***************

eststo clear
estpost tabstat lr_cdu lr_spd lr_fdp lr_b90 coal_cduspd coal_cdufdp coal_spdb90 v_* know if country=="Germany",  stat(mean sd min max n) columns(statistics)

#delimit 
esttab using desc_g.tex, replace booktabs title(\sc Descriptive Overview: Germany \label{tab:desc:ger})
 cells("mean(fmt(1)) sd(fmt(1)) min(fmt(0)) max(fmt(0)) count(fmt(0))") noobs nonum 
 varlabels(lr_cdu "Left-Right CDU" lr_spd "Left-Right SPD" lr_fdp "Left-Right FDP" 
 lr_b90 "Left-Right Green" coal_cduspd "Left-Right CDU-SPD" coal_cdufdp "Left-Right CDU-FDP" coal_spdb90 "Left-Right SPD-Green" 
 know "Pol.~Knowledge" v_cdu "Predicted Vote Share CDU/CSU" v_spd "Predicted Vote Share SPD" v_fdp "Predicted Vote Share FDP"
 v_b90 "Predicted Vote Share Green" v_dl "Predicted Vote Share Left Party")
;
#delimit cr



***************
*** Austria ***
***************

eststo clear
estpost tabstat lr_spoe lr_oevp lr_fpoe lr_green coal_spoegreen coal_spoeoevp coal_oevpfpoe coal_spoefpoe know if country=="Austria",  stat(mean sd min max n) columns(statistics)

#delimit 
esttab using desc_a.tex, replace booktabs title(\sc Descriptive Overview: Austria \label{tab:desc:aut})
 cells("mean(fmt(1)) sd(fmt(1)) min(fmt(0)) max(fmt(0)) count(fmt(0))") noobs nonum
 varlabels(lr_spoe "Left-Right SPÖ" lr_oevp "Left-Right ÖVP" lr_fpoe "Left-Right FPÖ" 
 lr_green "Left-Right Green" coal_spoegreen "Left-Right SPÖ-Green" coal_spoeoevp "Left-Right ÖVP-SPÖ" coal_oevpfpoe "Left-Right ÖVP-FPÖ"  
 coal_spoefpoe "Left-Right SPÖ-FPÖ" know "Political Knowledge")
;
#delimit cr




**************
*** Sweden ***
**************

eststo clear
estpost tabstat lr_sap6 lr_gr6 lr_left6 coal_sapgr6 coal_sapgrl6   if country=="Sweden",  stat(mean sd min max n) columns(statistics)

#delimit 
esttab using desc_s.tex, replace booktabs title(\sc Descriptive Overview: Sweden \label{tab:desc:swe})
 cells("mean(fmt(1)) sd(fmt(1)) min(fmt(0)) max(fmt(0)) count(fmt(0))") noobs nonum
 varlabels(lr_sap6 "Left-Right SAP" lr_gr6 "Left-Right MP" coal_sapgr6 "Left-Right SAP-MP" know "Political Knowledge"
 coal_sapgrl6 "Left-Right SAP-MP-Left" coal_sapgrlf6 "Left-Right SAP-MP-Left-Feminist" lr_left6 "Left-Right Left Party")
;
#delimit cr



*************************
***** data clean-up *****
*************************

capture rm temp.dta  

exit
