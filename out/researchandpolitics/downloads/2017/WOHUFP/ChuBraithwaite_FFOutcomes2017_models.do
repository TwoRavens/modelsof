/* 
Replication file for Chu & Braithwaite (2017)
"Foreign Fighters and Civil Conflict Outcomes"
*/

*Establish working directory
cd /Volumes/tchu/Dropbox/Collaborations/ForeignFighters/FinalSubmission/Dataverse/

*Open dataset file
use "ChuBraithwaite_FFOutcomes2017_data.dta"




** Table 1 in manuscript, columns (1); setting the sample
** Binary coding of foreign fighters
** 4 outcomes: 1=agmt, 2=gov vic, 3=reb vic, 4=other

mlogit outcome_nsa ForeignFighter lnduration epolity2 elogged_gdp elogged_pop numdyads fighting mobilization eColdWar e_post911, vce(cl ccode) b(4)

** Probabilities of an outcome vs another given foreign fighters
listcoef 1.ForeignFighter, help

** Summary statistics, table A1 in Appendix
sutex2 outcome_nsa ForeignFighter beyondneighboring_ff coethnic_ff duration lnduration epolity2 elogged_gdp elogged_pop numdyads fighting mobilization eColdWar e_post911 if e(sample)==1, minmax

** Testing IIA, table A2 in Appendix
mlogit outcome_nsa ForeignFighter lnduration epolity2 elogged_gdp elogged_pop numdyads fighting mobilization eColdWar e_post911,  b(4)
mlogtest, iia



****************
****************


** Disaggregating foreign fighter by
** beyond neighboring and co-ethnics

** Table 1 in manuscript, columns (2)
mlogit outcome_nsa beyondneighboring_ff coethnic_ff lnduration epolity2 elogged_gdp elogged_pop numdyads fighting mobilization eColdWar e_post911, vce(cl ccode) b(4)

** Probabilities of an outcome vs another given foreign fighter type
listcoef 1.beyondneighboring_ff 1.coethnic_ff, help

** Testing IIA, table A3 in Appendix
mlogit outcome_nsa beyondneighboring_ff coethnic_ff lnduration epolity2 elogged_gdp elogged_pop numdyads fighting mobilization eColdWar e_post911, b(4) nolog
mlogtest, iia




****************
****************



** Competing risks models
** Results for binary FF in table A4 of Appendix
** Results for disaggregated FF types in table A5 of Appendix


** Failure=agmt
stset duration, id(dyadep) failure(outcome_nsa=1)
stcrreg ForeignFighter epolity2 elogged_gdp elogged_pop numdyads fighting mobilization eColdWar e_post911, compete(outcome_nsa = 2,3,4) vce(cl ccode)
stcrreg beyondneighboring_ff coethnic_ff epolity2 elogged_gdp elogged_pop numdyads fighting mobilization eColdWar e_post911, compete(outcome_nsa = 2,3,4) vce(cl ccode)


** Failure=gov victory
stset duration, id(dyadep) failure(outcome_nsa=2)
stcrreg ForeignFighter epolity2 elogged_gdp elogged_pop numdyads fighting mobilization eColdWar e_post911, compete(outcome_nsa = 1,3,4) vce(cl ccode)
**Figure 1 in Manuscript, Row 1 Column 1 
stcurve, cif at0(ForeignFighter=0) at1(ForeignFighter=1) title("Cumulative Incidence Function")  xtitle("Years of Conflict") ytitle("Likelihood of Govt. Victory") lpattern(solid dash) clcolor(black black) legend(order(1 "ForeignFighter=0" 2 "ForeignFighter=1")) graphregion(color(white)) 
stcrreg beyondneighboring_ff coethnic_ff epolity2 elogged_gdp elogged_pop numdyads fighting mobilization eColdWar e_post911, compete(outcome_nsa = 1,3,4) vce(cl ccode)
** Figure 1 in Manuscript, Row 1 Column 2
stcurve, cif at0(beyondneighboring_ff=0) at1(beyondneighboring_ff=1) title("Cumulative Incidence Function")  xtitle("Years of Conflict") ytitle("Likelihood of Govt. Victory") lpattern(solid dash) clcolor(black black) legend(order(1 "Beyond Neighboring FF=0" 2 "Beyond Neighboring FF=1")) graphregion(color(white)) 


 
** Failure=reb victory
stset duration, id(dyadep) failure(outcome_nsa=3)
stcrreg ForeignFighter epolity2 elogged_gdp elogged_pop numdyads fighting mobilization eColdWar e_post911, compete(outcome_nsa = 1,2,4) vce(cl ccode)
** Figure 1 in Manuscript, Row 2 Column 1
stcurve, cif at0(ForeignFighter=0) at1(ForeignFighter=1) title("Cumulative Incidence Function")  xtitle("Years of Conflict") ytitle("Likelihood of Rebel Victory") lpattern(solid dash) clcolor(black black) legend(order(1 "ForeignFighter=0" 2 "ForeignFighter=1")) graphregion(color(white)) 
stcrreg beyondneighboring_ff coethnic_ff epolity2 elogged_gdp elogged_pop numdyads fighting mobilization eColdWar e_post911, compete(outcome_nsa = 1,2,4) vce(cl ccode)
** Figure 1 in Manuscript, Row 2 Column 2
stcurve, cif at0(beyondneighboring_ff=0) at1(beyondneighboring_ff=1) title("Cumulative Incidence Function")  xtitle("Years of Conflict") ytitle("Likelihood of Rebel Victory") lpattern(solid dash) clcolor(black black) legend(order(1 "Beyond Neighboring FF=0" 2 "Beyond Neighboring FF=1")) graphregion(color(white)) 


* Failure=othercome
stset duration, id(dyadep) failure(outcome_nsa=4)
stcrreg ForeignFighter epolity2 elogged_gdp elogged_pop numdyads fighting mobilization eColdWar e_post911, compete(outcome_nsa = 1,2,3) vce(cl ccode)
stcrreg beyondneighboring_ff coethnic_ff epolity2 elogged_gdp elogged_pop numdyads fighting mobilization eColdWar e_post911, compete(outcome_nsa = 1,2,3) vce(cl ccode)


