/* "Overseas Credit Claiming and Domestic Support for Foreign Aid" */
/* Simone Dietrich, Susan Hyde, and Matthew S. Winters */
/* Journal of Experimental Political Science */

use "DietrichEtAl_JEPS_BrandedAid.dta"

/***********/
/* TABLE 2 */
/***********/

tab condition

tab condition left

/***********/
/* TABLE 3 */
/***********/

tab condition open_uk, row chi2
tab condition bangladeshis_knowsscfunds, row chi2

reg open_uk branded_video_01 highlighted_video_01 strategic_video_01 i.survey, vce(robust)
testparm branded_video_01 highlighted_video_01 strategic_video_01

reg bangladeshis_knowsscfunds branded_video_01 highlighted_video_01 strategic_video_01 i.survey, vce(robust)
testparm branded_video_01 highlighted_video_01 strategic_video_01

/***********/
/* TABLE 4 */
/***********/

bysort condition: ameans aid_spentwell
tab condition aid_spentwell, row chi2

bysort condition: ameans aid_spentwell if left==0
tab condition aid_spentwell if left==0, row chi2

bysort condition: ameans aid_spentwell if left==1
tab condition aid_spentwell if left==1, row chi2

reg aid_spentwell purecontrol_01 branded_video_01 highlighted_video_01 strategic_video_01 i.survey, vce(robust)
testparm purecontrol_01 branded_video_01 highlighted_video_01 strategic_video_01

reg aid_spentwell purecontrol_01 branded_video_01 highlighted_video_01 strategic_video_01 i.survey if left==0, vce(robust)
testparm purecontrol_01 branded_video_01 highlighted_video_01 strategic_video_01

reg aid_spentwell purecontrol_01 branded_video_01 highlighted_video_01 strategic_video_01  i.survey if left==1, vce(robust)
testparm purecontrol_01 branded_video_01 highlighted_video_01 strategic_video_01

/***********/
/* TABLE 5 */
/***********/

bysort condition: ameans support_ssc
tab condition support_ssc, row chi2

bysort condition: ameans support_ssc if left==0
tab condition support_ssc if left==0, row chi2

bysort condition: ameans support_ssc if left==1
tab condition support_ssc if left==1, row chi2

tab condition ssc_othercountries, row chi2

tab condition ssc_othercountries if left==0, row chi2

tab condition ssc_othercountries if left==1, row chi2

bysort condition: ameans aid_spendmore 
tab condition aid_spendmore, row chi2

bysort condition: ameans aid_spendmore if left==0
tab condition aid_spendmore if left==0, row chi2

bysort condition: ameans aid_spendmore if left==1
tab condition aid_spendmore if left==1, row chi2

reg support_ssc branded_video_01 highlighted_video_01 strategic_video_01 i.survey, vce(robust)
testparm branded_video_01 highlighted_video_01 strategic_video_01

reg support_ssc branded_video_01 highlighted_video_01 strategic_video_01 i.survey if left==0, vce(robust)
testparm branded_video_01 highlighted_video_01 strategic_video_01

reg support_ssc branded_video_01 highlighted_video_01 strategic_video_01 i.survey if left==1, vce(robust)
testparm branded_video_01 highlighted_video_01 strategic_video_01

reg ssc_othercountries branded_video_01 highlighted_video_01 strategic_video_01 i.survey, vce(robust)
testparm branded_video_01 highlighted_video_01 strategic_video_01

reg ssc_othercountries branded_video_01 highlighted_video_01 strategic_video_01 i.survey if left==0, vce(robust)
testparm branded_video_01 highlighted_video_01 strategic_video_01

reg ssc_othercountries branded_video_01 highlighted_video_01 strategic_video_01 i.survey if left==1, vce(robust)
testparm branded_video_01 highlighted_video_01 strategic_video_01

reg aid_spendmore purecontrol_01 branded_video_01 highlighted_video_01 strategic_video_01  i.survey , vce(robust)
testparm purecontrol_01 branded_video_01 highlighted_video_01 strategic_video_01

reg aid_spendmore purecontrol_01 branded_video_01 highlighted_video_01 strategic_video_01 i.survey if left==0 , vce(robust)
testparm purecontrol_01 branded_video_01 highlighted_video_01 strategic_video_01

reg aid_spendmore purecontrol_01 branded_video_01 highlighted_video_01 strategic_video_01 i.survey if left==1 , vce(robust)
testparm purecontrol_01 branded_video_01 highlighted_video_01 strategic_video_01

/********************/
/* APPENDIX TABLE 1 */
/********************/

* Note: Condition-specific mean values and chi-squared tests are as reported in Table 5

* Support SSC

reg support_ssc brandedvideoonly_v_controlvideo i.survey, vce(robust)
reg support_ssc brandedvideoonly_v_controlvideo i.survey if left==0, vce(robust)
reg support_ssc brandedvideoonly_v_controlvideo i.survey if left==1, vce(robust)

reg support_ssc highlightedvideo_v_controlvideo i.survey, vce(robust)
reg support_ssc highlightedvideo_v_controlvideo i.survey if left==0, vce(robust)
reg support_ssc highlightedvideo_v_controlvideo i.survey if left==1, vce(robust)

reg support_ssc strategicvideo_v_controlvideo i.survey, vce(robust)
reg support_ssc strategicvideo_v_controlvideo i.survey if left==0, vce(robust)
reg support_ssc strategicvideo_v_controlvideo i.survey if left==1, vce(robust)

reg support_ssc highlightedvideo_v_brandedvideo i.survey, vce(robust)
reg support_ssc highlightedvideo_v_brandedvideo i.survey if left==0, vce(robust)
reg support_ssc highlightedvideo_v_brandedvideo i.survey if left==1, vce(robust)

reg support_ssc strategicvideo_v_brandedvideo i.survey, vce(robust)
reg support_ssc strategicvideo_v_brandedvideo i.survey if left==0, vce(robust)
reg support_ssc strategicvideo_v_brandedvideo i.survey if left==1, vce(robust)

reg support_ssc stratgicvideo_v_highlightedvideo i.survey, vce(robust)
reg support_ssc stratgicvideo_v_highlightedvideo i.survey if left==0, vce(robust)
reg support_ssc stratgicvideo_v_highlightedvideo i.survey if left==1, vce(robust)

* Expand SSC

reg ssc_othercountries brandedvideoonly_v_controlvideo i.survey, vce(robust)
reg ssc_othercountries brandedvideoonly_v_controlvideo i.survey if left==0, vce(robust)
reg ssc_othercountries brandedvideoonly_v_controlvideo i.survey if left==1, vce(robust)

reg ssc_othercountries highlightedvideo_v_controlvideo i.survey, vce(robust)
reg ssc_othercountries highlightedvideo_v_controlvideo i.survey if left==0, vce(robust)
reg ssc_othercountries highlightedvideo_v_controlvideo i.survey if left==1, vce(robust)

reg ssc_othercountries strategicvideo_v_controlvideo i.survey, vce(robust)
reg ssc_othercountries strategicvideo_v_controlvideo i.survey if left==0, vce(robust)
reg ssc_othercountries strategicvideo_v_controlvideo i.survey if left==1, vce(robust)

reg ssc_othercountries highlightedvideo_v_brandedvideo i.survey, vce(robust)
reg ssc_othercountries highlightedvideo_v_brandedvideo i.survey if left==0, vce(robust)
reg ssc_othercountries highlightedvideo_v_brandedvideo i.survey if left==1, vce(robust)

reg ssc_othercountries strategicvideo_v_brandedvideo i.survey, vce(robust)
reg ssc_othercountries strategicvideo_v_brandedvideo i.survey if left==0, vce(robust)
reg ssc_othercountries strategicvideo_v_brandedvideo i.survey if left==1, vce(robust)

reg ssc_othercountries stratgicvideo_v_highlightedvideo i.survey, vce(robust)
reg ssc_othercountries stratgicvideo_v_highlightedvideo i.survey if left==0, vce(robust)
reg ssc_othercountries stratgicvideo_v_highlightedvideo i.survey if left==1, vce(robust)

* Support Aid

reg aid_spendmore controlvideo_v_purecontrol i.survey, vce(robust)
reg aid_spendmore controlvideo_v_purecontrol i.survey if left==0, vce(robust)
reg aid_spendmore controlvideo_v_purecontrol i.survey if left==1, vce(robust)

reg aid_spendmore brandedvideoonly_v_purecontrol i.survey, vce(robust)
reg aid_spendmore brandedvideoonly_v_purecontrol i.survey if left==0, vce(robust)
reg aid_spendmore brandedvideoonly_v_purecontrol i.survey if left==1, vce(robust)

reg aid_spendmore highlightedvideo_v_purecontrol i.survey, vce(robust)
reg aid_spendmore highlightedvideo_v_purecontrol i.survey if left==0, vce(robust)
reg aid_spendmore highlightedvideo_v_purecontrol i.survey if left==1, vce(robust)

reg aid_spendmore strategicvideo_v_purecontrol i.survey, vce(robust)
reg aid_spendmore strategicvideo_v_purecontrol i.survey if left==0, vce(robust)
reg aid_spendmore strategicvideo_v_purecontrol i.survey if left==1, vce(robust)

reg aid_spendmore brandedvideoonly_v_controlvideo i.survey, vce(robust)
reg aid_spendmore brandedvideoonly_v_controlvideo i.survey if left==0, vce(robust)
reg aid_spendmore brandedvideoonly_v_controlvideo i.survey if left==1, vce(robust)

reg aid_spendmore highlightedvideo_v_controlvideo i.survey, vce(robust)
reg aid_spendmore highlightedvideo_v_controlvideo i.survey if left==0, vce(robust)
reg aid_spendmore highlightedvideo_v_controlvideo i.survey if left==1, vce(robust)

reg aid_spendmore strategicvideo_v_controlvideo i.survey, vce(robust)
reg aid_spendmore strategicvideo_v_controlvideo i.survey if left==0, vce(robust)
reg aid_spendmore strategicvideo_v_controlvideo i.survey if left==1, vce(robust)

reg aid_spendmore highlightedvideo_v_brandedvideo i.survey, vce(robust)
reg aid_spendmore highlightedvideo_v_brandedvideo i.survey if left==0, vce(robust)
reg aid_spendmore highlightedvideo_v_brandedvideo i.survey if left==1, vce(robust)

reg aid_spendmore strategicvideo_v_brandedvideo i.survey, vce(robust)
reg aid_spendmore strategicvideo_v_brandedvideo i.survey if left==0, vce(robust)
reg aid_spendmore strategicvideo_v_brandedvideo i.survey if left==1, vce(robust)

reg aid_spendmore stratgicvideo_v_highlightedvideo i.survey, vce(robust)
reg aid_spendmore stratgicvideo_v_highlightedvideo i.survey if left==0, vce(robust)
reg aid_spendmore stratgicvideo_v_highlightedvideo i.survey if left==1, vce(robust)

reg aid_spendmore brandedvideo_v_bothcontrols i.survey, vce(robust)
reg aid_spendmore brandedvideo_v_bothcontrols i.survey if left==0, vce(robust)
reg aid_spendmore brandedvideo_v_bothcontrols i.survey if left==1, vce(robust)

/********************/
/* APPENDIX TABLE 2 */
/********************/

* Aid Reduces Poverty

mean statement_poverty, over(condition)
tab condition statement_poverty, chi2 

reg statement_poverty controlvideo_v_purecontrol i.survey, vce(robust)
reg statement_poverty brandedvideoonly_v_purecontrol i.survey, vce(robust)
reg statement_poverty highlightedvideo_v_purecontrol i.survey, vce(robust)
reg statement_poverty strategicvideo_v_purecontrol i.survey, vce(robust)
reg statement_poverty brandedvideoonly_v_controlvideo i.survey, vce(robust)
reg statement_poverty highlightedvideo_v_controlvideo i.survey, vce(robust)
reg statement_poverty strategicvideo_v_controlvideo i.survey, vce(robust)
reg statement_poverty highlightedvideo_v_brandedvideo i.survey, vce(robust)
reg statement_poverty strategicvideo_v_brandedvideo i.survey, vce(robust)
reg statement_poverty stratgicvideo_v_highlightedvideo i.survey, vce(robust)

* Perceptions of Foreign Aid as Effective Global Health Tool

mean statement_globalhealth, over(condition)
tab condition statement_globalhealth, chi2 

reg statement_globalhealth controlvideo_v_purecontrol i.survey, vce(robust)
reg statement_globalhealth brandedvideoonly_v_purecontrol i.survey, vce(robust)
reg statement_globalhealth highlightedvideo_v_purecontrol i.survey, vce(robust)
reg statement_globalhealth strategicvideo_v_purecontrol i.survey, vce(robust)
reg statement_globalhealth brandedvideoonly_v_controlvideo i.survey, vce(robust)
reg statement_globalhealth highlightedvideo_v_controlvideo i.survey, vce(robust)
reg statement_globalhealth strategicvideo_v_controlvideo i.survey, vce(robust)
reg statement_globalhealth highlightedvideo_v_brandedvideo i.survey, vce(robust)
reg statement_globalhealth strategicvideo_v_brandedvideo i.survey, vce(robust)
reg statement_globalhealth stratgicvideo_v_highlightedvideo i.survey, vce(robust)

* U.K. Does Good Job of Ensuring Aid is Well Spent

mean aid_spentwell, over(condition)
tab condition aid_spentwell, chi2 

reg aid_spentwell controlvideo_v_purecontrol i.survey, vce(robust)
reg aid_spentwell brandedvideoonly_v_purecontrol i.survey, vce(robust)
reg aid_spentwell highlightedvideo_v_purecontrol i.survey, vce(robust)
reg aid_spentwell strategicvideo_v_purecontrol i.survey, vce(robust)
reg aid_spentwell brandedvideoonly_v_controlvideo i.survey, vce(robust)
reg aid_spentwell highlightedvideo_v_controlvideo i.survey, vce(robust)
reg aid_spentwell strategicvideo_v_controlvideo i.survey, vce(robust)
reg aid_spentwell highlightedvideo_v_brandedvideo i.survey, vce(robust)
reg aid_spentwell strategicvideo_v_brandedvideo i.survey, vce(robust)
reg aid_spentwell stratgicvideo_v_highlightedvideo i.survey, vce(robust)

/********************/
/* APPENDIX TABLE 3 */
/********************/

mean govt_foreignpolicy, over(condition)
tab condition if govt_foreignpolicy!=.
mean govt_foreignpolicy if left==0, over(condition)
tab condition if govt_foreignpolicy!=. & left==0
mean govt_foreignpolicy if left==1, over(condition)
tab condition if govt_foreignpolicy!=. & left==1

reg govt_foreignpolicy controlvideo_v_purecontrol i.survey, vce(robust)
reg govt_foreignpolicy controlvideo_v_purecontrol i.survey if left==0, vce(robust)
reg govt_foreignpolicy controlvideo_v_purecontrol i.survey if left==1, vce(robust)

reg govt_foreignpolicy brandedvideoonly_v_purecontrol i.survey, vce(robust)
reg govt_foreignpolicy brandedvideoonly_v_purecontrol i.survey if left==0, vce(robust)
reg govt_foreignpolicy brandedvideoonly_v_purecontrol i.survey if left==1, vce(robust)

reg govt_foreignpolicy highlightedvideo_v_purecontrol i.survey, vce(robust)
reg govt_foreignpolicy highlightedvideo_v_purecontrol i.survey if left==0, vce(robust)
reg govt_foreignpolicy highlightedvideo_v_purecontrol i.survey if left==1, vce(robust)

reg govt_foreignpolicy strategicvideo_v_purecontrol i.survey, vce(robust)
reg govt_foreignpolicy strategicvideo_v_purecontrol i.survey if left==0, vce(robust)
reg govt_foreignpolicy strategicvideo_v_purecontrol i.survey if left==1, vce(robust)

reg govt_foreignpolicy brandedvideoonly_v_controlvideo i.survey, vce(robust)
reg govt_foreignpolicy brandedvideoonly_v_controlvideo i.survey if left==0, vce(robust)
reg govt_foreignpolicy brandedvideoonly_v_controlvideo i.survey if left==1, vce(robust)

reg govt_foreignpolicy highlightedvideo_v_controlvideo i.survey, vce(robust)
reg govt_foreignpolicy highlightedvideo_v_controlvideo i.survey if left==0, vce(robust)
reg govt_foreignpolicy highlightedvideo_v_controlvideo i.survey if left==1, vce(robust)

reg govt_foreignpolicy strategicvideo_v_controlvideo i.survey, vce(robust)
reg govt_foreignpolicy strategicvideo_v_controlvideo i.survey if left==0, vce(robust)
reg govt_foreignpolicy strategicvideo_v_controlvideo i.survey if left==1, vce(robust)

reg govt_foreignpolicy highlightedvideo_v_brandedvideo i.survey, vce(robust)
reg govt_foreignpolicy highlightedvideo_v_brandedvideo i.survey if left==0, vce(robust)
reg govt_foreignpolicy highlightedvideo_v_brandedvideo i.survey if left==1, vce(robust)

reg govt_foreignpolicy strategicvideo_v_brandedvideo i.survey, vce(robust)
reg govt_foreignpolicy strategicvideo_v_brandedvideo i.survey if left==0, vce(robust)
reg govt_foreignpolicy strategicvideo_v_brandedvideo i.survey if left==1, vce(robust)

reg govt_foreignpolicy stratgicvideo_v_highlightedvideo i.survey, vce(robust)
reg govt_foreignpolicy stratgicvideo_v_highlightedvideo i.survey if left==0, vce(robust)
reg govt_foreignpolicy stratgicvideo_v_highlightedvideo i.survey if left==1, vce(robust)

* Perceptions of Government's Foreign Aid Policy Performance

mean govt_foreignaid, over(condition)
tab condition if govt_foreignaid!=.
mean govt_foreignaid if left==0, over(condition)
tab condition if govt_foreignaid!=. & left==0
mean govt_foreignaid if left==1, over(condition)
tab condition if govt_foreignaid!=. & left==1

reg govt_foreignaid controlvideo_v_purecontrol i.survey, vce(robust)
reg govt_foreignaid controlvideo_v_purecontrol i.survey if left==0, vce(robust)
reg govt_foreignaid controlvideo_v_purecontrol i.survey if left==1, vce(robust)

reg govt_foreignaid brandedvideoonly_v_purecontrol i.survey, vce(robust)
reg govt_foreignaid brandedvideoonly_v_purecontrol i.survey if left==0, vce(robust)
reg govt_foreignaid brandedvideoonly_v_purecontrol i.survey if left==1, vce(robust)

reg govt_foreignaid highlightedvideo_v_purecontrol i.survey, vce(robust)
reg govt_foreignaid highlightedvideo_v_purecontrol i.survey if left==0, vce(robust)
reg govt_foreignaid highlightedvideo_v_purecontrol i.survey if left==1, vce(robust)

reg govt_foreignaid strategicvideo_v_purecontrol i.survey, vce(robust)
reg govt_foreignaid strategicvideo_v_purecontrol i.survey if left==0, vce(robust)
reg govt_foreignaid strategicvideo_v_purecontrol i.survey if left==1, vce(robust)

reg govt_foreignaid brandedvideoonly_v_controlvideo i.survey, vce(robust)
reg govt_foreignaid brandedvideoonly_v_controlvideo i.survey if left==0, vce(robust)
reg govt_foreignaid brandedvideoonly_v_controlvideo i.survey if left==1, vce(robust)

reg govt_foreignaid highlightedvideo_v_controlvideo i.survey, vce(robust)
reg govt_foreignaid highlightedvideo_v_controlvideo i.survey if left==0, vce(robust)
reg govt_foreignaid highlightedvideo_v_controlvideo i.survey if left==1, vce(robust)

reg govt_foreignaid strategicvideo_v_controlvideo i.survey, vce(robust)
reg govt_foreignaid strategicvideo_v_controlvideo i.survey if left==0, vce(robust)
reg govt_foreignaid strategicvideo_v_controlvideo i.survey if left==1, vce(robust)

reg govt_foreignaid highlightedvideo_v_brandedvideo i.survey, vce(robust)
reg govt_foreignaid highlightedvideo_v_brandedvideo i.survey if left==0, vce(robust)
reg govt_foreignaid highlightedvideo_v_brandedvideo i.survey if left==1, vce(robust)

reg govt_foreignaid strategicvideo_v_brandedvideo i.survey, vce(robust)
reg govt_foreignaid strategicvideo_v_brandedvideo i.survey if left==0, vce(robust)
reg govt_foreignaid strategicvideo_v_brandedvideo i.survey if left==1, vce(robust)

reg govt_foreignaid stratgicvideo_v_highlightedvideo i.survey, vce(robust)
reg govt_foreignaid stratgicvideo_v_highlightedvideo i.survey if left==0, vce(robust)
reg govt_foreignaid stratgicvideo_v_highlightedvideo i.survey if left==1, vce(robust)

/********************/
/* APPENDIX TABLE 4 */
/********************/

sum female
sum age
tab ethnicity
tab income
tab education




/* END OF FILE */
