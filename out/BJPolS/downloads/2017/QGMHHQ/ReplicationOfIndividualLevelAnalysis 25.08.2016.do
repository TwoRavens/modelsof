
***************************************************************************************************************************************************************************
**** August 25., 2016                                                                                                                                                  **** 
**** The current STATA-do file replicates tables in Rune Jørgen Sørensen: THe impact of state television on voter turnout.                                             ****
**** The analyses use the dataset ReplicationofIndividualLevelPanel.dta, and the file generates Table 3, 4 and 5, and                                                  ****
**** Appendix G (descriptive statisticxs).                                                                                                                             ****
**** Note that the municipality identification (knr) is ficticious to ensure that individual respondents remain anonymous.                                             ****
***************************************************************************************************************************************************************************

clear all
use "W:\users\fag89001\TVReplication\MicroData\ReplicationofIndividualLevelPanel.dta", replace

* Appendix G Descriptive statistics, National Election Surveys 1965, 1969 and 1973
tabstat IndPanel TVDummy TVElection Radio Newspaper PolInt ElInt LeaderNames Age Gender Income Education, by(year) stats(mean N) format(%9.2f) 

* Table 3. TV and media consumption
quietly areg TVElection TVDummy                               i.year i.knr if IndPanel==1, absorb(id) vce(cluster knr)
outreg2 using Table3.doc, replace   ctitle(TV-election I) label addstat(Respondents,  e(N_clust), Observations, e(N)) addtext(Control variables, NO, Respondent FE, YES, Municipality FE, YES, Election year FE, YES) keep(TVDummy) nocon bdec(3) 
quietly areg   TVElection TVDummy Age Gender Income Education i.year , absorb(knr) vce(cluster knr)
outreg2 using Table3.doc,   ctitle(TV-election II) label addstat(Municipalities,  e(N_clust)) addtext(Control variables, YES, Respondent FE, NO, Municipality FE, YES, Election year FE, YES) keep(TVDummy) nocon bdec(3) append

quietly areg Radio TVDummy                               i.year if IndPanel==1, absorb(id) vce(cluster knr)
outreg2 using Table3.doc,   ctitle(Radio I) label addstat(Respondents,  e(N_clust), Observations, e(N)) addtext(Control variables, NO, Respondent FE, YES, Municipality FE, YES, Election year FE, YES) keep(TVDummy) nocon bdec(3) append
quietly areg   Radio TVDummy Age Gender Income Education i.year, absorb(id) vce(cluster knr)
outreg2 using Table3.doc,   ctitle(Radio II) label addstat(Municipalities,  e(N_clust)) addtext(Control variables, YES, Respondent FE, NO, Municipality FE, YES, Election year FE, YES) keep(TVDummy) nocon bdec(3) append

quietly areg Newspaper TVDummy                               i.year if IndPanel==1, absorb(id) vce(cluster knr)
outreg2 using Table3.doc,   ctitle(NEWSPAPER I) label addstat(Respondents,  e(N_clust), Observations, e(N)) addtext(Control variables, NO, Respondent FE, YES, Municipality FE, YES, Election year FE, YES) keep(TVDummy) nocon bdec(3) append
quietly areg   Newspaper TVDummy Age Gender Income Education i.year, absorb(knr) vce(cluster knr)
outreg2 using Table3.doc,   ctitle(NEWSPAPER II) label addstat(Municipalities,  e(N_clust)) addtext(Control variables, YES, Respondent FE, NO, Municipality FE, YES, Election year FE, YES) keep(TVDummy) nocon bdec(3) ///
title("Table 3. Television access and media consumption") append

* Table 4. TV and political interest
quietly areg PolInt TVDummy i.year  i.knr if IndPanel==1, absorb(id) vce(cluster knr)
outreg2 using Table4.doc, replace   ctitle(INTEREST I) label addstat(Respondents,  e(N_clust), Observations, e(N)) addtext(Control variables, NO, Respondent FE, YES, Municipality FE, YES, Election year FE, YES) keep(TVDummy) nocon bdec(3) 
quietly areg PolInt TVDummy Age Gender Income Education i.year, absorb(knr) vce(cluster knr)
outreg2 using Table4.doc, append          ctitle(INTEREST II) label addstat(Municipalities,  e(N_clust)) addtext(Control variables, YES, Respondent FE, NO, Municipality FE, YES, Election year FE, YES) keep(TVDummy) nocon bdec(3) 
quietly areg ElInt TVDummy i.year  i.knr if IndPanel==1, absorb(id) vce(cluster knr)
outreg2 using Table4.doc, append   ctitle(RESULT I) label addstat(Respondents,  e(N_clust), Observations, e(N)) addtext(Control variables, NO, Respondent FE, YES, Municipality FE, YES, Election year FE, YES) keep(TVDummy) nocon bdec(3) 
quietly areg ElInt TVDummy Age Gender Income Education i.year, absorb(knr) vce(cluster knr)
outreg2 using Table4.doc, append          ctitle(RESULT II) label addstat(Municipalities,  e(N_clust)) addtext(Control variables, YES, Respondent FE, NO, Municipality FE, YES, Election year FE, YES) keep(TVDummy) nocon bdec(3)
quietly areg LeaderNames TVDummy  i.year i.knr  if IndPanel==1, absorb(id) vce(cluster knr)
outreg2 using Table4.doc, append   ctitle(KNOWLEDGE I) label addstat(Respondents,  e(N_clust), Observations, e(N)) addtext(Control variables, NO, Respondent FE, YES, Municipality FE, YES, Election year FE, YES) keep(TVDummy) nocon bdec(3) 
quietly areg   LeaderNames TVDummy Age Gender Income Education i.year, absorb(knr) vce(cluster knr)
outreg2 using Table4.doc, append   ctitle(KNOWLEDGE II) label addstat(Municipalities,  e(N_clust)) addtext(Control variables, YES, Respondent FE, NO, Municipality FE, YES, Election year FE, YES) keep(TVDummy) nocon bdec(3)  ///
title("Table 4. Television access and political interest") 

* Table 5. TV and political behavior
quietly areg Discussion TVDummy  i.year i.knr  if IndPanel==1, absorb(id) vce(cluster knr)
outreg2 using Table5.doc, replace   ctitle(DISCUSSIONS I) label addstat(Respondents,  e(N_clust), Observations, e(N)) addtext(Control variables, NO, Respondent FE, YES, Municipality FE, YES, Election year FE, YES) keep(TVDummy) nocon bdec(3) 
quietly areg Discussion TVDummy Age Gender Income Education i.year, absorb(knr) vce(cluster knr)
outreg2 using Table5.doc, append   ctitle(DISCUSSIONS II) label addstat(Municipalities,  e(N_clust)) addtext(Control variables, YES, Respondent FE, NO, Municipality FE, YES, Election year FE, YES) keep(TVDummy) nocon bdec(3)   
quietly areg Turnout TVDummy i.year i.knr  if IndPanel==1, absorb(id) vce(cluster knr)
outreg2 using Table5, append   ctitle(TURNOUT I) label addstat(Respondents,  e(N_clust), Observations, e(N)) addtext(Control variables, NO, Respondent FE, YES, Municipality FE, YES, Election year FE, YES) keep(TVDummy) nocon bdec(3) 
quietly areg Turnout TVDummy Age Gender Income Education i.year, absorb(knr) vce(cluster knr)
outreg2 using Table5.doc, append   ctitle(TURNOUT II) label addstat(Municipalities,  e(N_clust)) addtext(Control variables, YES, Respondent FE, NO, Municipality FE, YES, Election year FE, YES) keep(TVDummy) nocon bdec(3) /// 
title("Table 5. Television access and political behavior") 

* Erasing unneccesary files ********************************************************************************************************************************************************************************************************
erase Table3.txt
erase Table4.txt
erase Table5.txt
* Finished * Finished * Finished * Finished* Finished * Finished * Finished * Finished * Finished * Finished* Finished * Finished * Finished* Finished * Finished * Finished* Finished * Finished * Finished






