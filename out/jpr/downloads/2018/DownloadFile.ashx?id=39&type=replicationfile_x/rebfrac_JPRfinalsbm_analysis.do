

* REPLICATION DATA AND DO FILE
* THE RISE OF REBEL CONTENDERS: BARRIERS TO ENTRY AND FRAGMENTATION IN CIVIL WARS
* JOURNAL OF PEACE RESEARCH
* HANNE FJELDE AND DESIREE NILSSON


clear
use "rebfrac_JPRfinalsbm.dta"

*********************************************************************************************
* ANALYSIS
*********************************************************************************************

tsset uniquepisode year 

global TIME1 rebelenter_yrs rebelenter_spl1 rebelenter_spl2 rebelenter_spl3
global TIME2 rebelenter_yrs rebelenter_yrs_sq rebelenter_yrs_cu

*Table I, Model 1-3  
logit rebelenter l.leftist_conflict_du l.ethnic_clre_du l.rel_clre_conflict, cl(uniquepisode)
outreg2 using table_main.doc, dec(2) 10pct replace  

logit rebelenter l.leftist_conflict_du l.ethnic_clre_du l.rel_clre_conflict episodeduration l.conflictwar l.internationalized, cl(uniquepisode)
outreg2 using table_main.doc, dec(2) 10pct append  

logit rebelenter l.leftist_conflict_du l.ethnic_clre_du l.rel_clre_conflict episodeduration l.conflictwar l.internationalized rebelenter_decay l.multiparty, cl(uniquepisode)
outreg2 using table_main.doc, dec(2) 10pct append  


*Table I, Model 4-6
logit rebelenter firstnegyear l.dem_pol2 lrepressionshock, cl(uniquepisode)
outreg2 using table_main.doc, dec(2) 10pct append  

logit rebelenter firstnegyear l.dem_pol2 lrepressionshock episodeduration l.conflictwar l.internationalized, cl(uniquepisode)
outreg2 using table_main.doc, dec(2) 10pct append  

logit rebelenter firstnegyear l.dem_pol2 lrepressionshock episodeduration l.conflictwar l.internationalized rebelenter_decay l.multiparty, cl(uniquepisode)
outreg2 using table_main.doc, dec(2) 10pct append  

*Table I, Model 7
logit rebelenter l.leftist_conflict_du l.ethnic_clre_du l.rel_clre_conflict firstnegyear l.dem_pol2 lrepressionshock episodeduration l.conflictwar l.internationalized rebelenter_decay l.multiparty, cl(uniquepisode)
outreg2 using table_main.doc, dec(2) 10pct append  


****************************************************
* Substantive effects - Reported in Figure 1

capture drop b*
estsimp logit rebelenter lleftist_conflict_du lethnic_clre_du lrel_clre_conflict firstnegyear ldem_pol2 lrepressionshock episodeduration lconflictwar linternationalized rebelenter_decay l.multiparty, cl(uniquepisode)

* Leftist rebels
setx median 
setx episodeduration mean rebelenter_decay mean
setx lleftist_conflict_du 0
simqi, pr

setx median
setx episodeduration mean rebelenter_decay mean
setx lleftist_conflict_du 1
simqi, pr

simqi, fd(pr) changex(lleftist_conflict_du 0 1)

* Ethnic rebels
capture drop b*
estsimp logit rebelenter lleftist_conflict_du lethnic_clre_du lrel_clre_conflict firstnegyear ldem_pol2 lrepressionshock episodeduration lconflictwar linternationalized rebelenter_decay l.multiparty, cl(uniquepisode)

setx median
setx episodeduration mean rebelenter_decay mean
setx lethnic_clre_du 0
simqi, pr

setx median
setx episodeduration mean rebelenter_decay mean
setx lethnic_clre_du 1
simqi, pr

simqi, fd(pr) changex(lethnic_clre_du 0 1)

* First neg
capture drop b*
estsimp logit rebelenter lleftist_conflict_du lethnic_clre_du lrel_clre_conflict firstnegyear ldem_pol2 lrepressionshock episodeduration lconflictwar linternationalized rebelenter_decay l.multiparty, cl(uniquepisode)

setx median
setx episodeduration mean rebelenter_decay mean
setx firstnegyear 0
simqi, pr

setx median
setx episodeduration mean rebelenter_decay mean
setx firstnegyear 1
simqi, pr

simqi, fd(pr) changex(firstnegyear 0 1)

* Democratization

capture drop b*
estsimp logit rebelenter lleftist_conflict_du lethnic_clre_du lrel_clre_conflict firstnegyear ldem_pol2 lrepressionshock episodeduration lconflictwar linternationalized rebelenter_decay l.multiparty, cl(uniquepisode)

setx median
setx episodeduration mean rebelenter_decay mean
setx ldem_pol2 0
simqi, pr

setx median
setx episodeduration mean rebelenter_decay mean
setx ldem_pol2 1
simqi, pr

simqi, fd(pr) changex(ldem_pol2 0 1)

****************************************************
** APPENDIX - Robustness also reported in paper
****************************************************

*Table A1: Summary statistics
****************************************************
logit rebelenter l.rebelenter_decay , cl(uniquepisode)
tab rebelenter if e(sample)
su rebelenter leftist_conflict_du ethnic_clre_du rel_clre_conflict firstnegyear dem_pol2 lrepressionshoc episodeduration conflictwar internationalized rebelenter_decay multiparty if e(sample)

* Table A2: Trimmed models and additional controls
****************************************************
* A2.1: Trimmed model - keep only significant variables
logit rebelenter l.leftist_conflict_du l.ethnic_clre_du firstnegyear l.dem_pol2 lrepressionshock episodeduration l.conflictwar l.internationalized rebelenter_decay l.multiparty , cl(uniquepisode)
logit rebelenter l.leftist_conflict_du l.ethnic_clre_du firstnegyear l.dem_pol2 rebelenter_decay, cl(uniquepisode)
outreg2 using table_A2A.doc, dec(2) 10pct replace  

* A2.2: Cold War control
logit rebelenter l.leftist_conflict_du l.ethnic_clre_du l.rel_clre_conflict firstnegyear l.dem_pol2 lrepressionshock episodeduration   l.conflictwar l.internationalized rebelenter_decay l.coldwar l.multiparty, cl(uniquepisode)
outreg2 using table_A2A.doc, dec(2) 10pct append  

* A2.3: natural resources
logit rebelenter l.leftist_conflict_du l.ethnic_clre_du l.rel_clre_conflict firstnegyear l.dem_pol2 lrepressionshock episodeduration l.conflictwar l.internationalized rebelenter_decay l.resources l.multiparty, cl(uniquepisode)
outreg2 using table_A2A.doc, dec(2) 10pct append  
 
* A2.4: lngdppc
logit rebelenter l.leftist_conflict_du l.ethnic_clre_du l.rel_clre_conflict firstnegyear l.dem_pol2 lrepressionshock episodeduration   l.conflictwar l.internationalized rebelenter_decay l.lngdppc   l.multiparty, cl(uniquepisode)
outreg2 using table_A2A.doc, dec(2) 10pct append  

* A2.5: territorial
logit rebelenter l.leftist_conflict_du l.ethnic_clre_du l.rel_clre_conflict firstnegyear l.dem_pol2 lrepressionshock episodeduration   l.conflictwar l.internationalized rebelenter_decay l.territorial l.multiparty, cl(uniquepisode)
outreg2 using table_A2A.doc, dec(2) 10pct append  


****************************************************
* Table A2B: Additional controls ***
****************************************************

* A2B.1 episodeduration_sq
logit rebelenter l.leftist_conflict_du l.ethnic_clre_du l.rel_clre_conflict firstnegyear l.dem_pol2 lrepressionshock episodeduration episodeduration_sq l.conflictwar l.internationalized rebelenter_decay l.multiparty, cl(uniquepisode)
outreg2 using table_A2B.doc, dec(2) 10pct append  

* A2B.2: number_group
logit rebelenter l.leftist_conflict_du l.ethnic_clre_du l.rel_clre_conflict firstnegyear l.dem_pol2 lrepressionshock episodeduration   l.conflictwar l.internationalized rebelenter_decay l.number_group, cl(uniquepisode)
outreg2 using table_A2B.doc, dec(2) 10pct append  

* A2B.3: strong group
logit rebelenter l.leftist_conflict_du l.ethnic_clre_du l.rel_clre_conflict firstnegyear l.dem_pol2 lrepressionshock episodeduration  l.conflictwar l.internationalized rebelenter_decay l.dummystrong, cl(uniquepisode)
outreg2 using table_A2B.doc, dec(2) 10pct append  

* A2B.4: mountains
logit rebelenter l.leftist_conflict_du l.ethnic_clre_du l.rel_clre_conflict firstnegyear l.dem_pol2 lrepressionshock episodeduration  l.conflictwar l.internationalized rebelenter_decay l.mt, cl(uniquepisode)
outreg2 using table_A2B.doc, dec(2) 10pct append  


****************************************************
* Table A3 - Alternative specifications, structural and strategic barriers to entry ***
****************************************************

*Combining different types of ties
logit rebelenter l.ties  firstnegyear l.dem_pol2 lrepressionshock episodeduration l.conflictwar l.internationalized rebelenter_decay l.multiparty, cl(uniquepisode)
outreg2 using table_A3.doc, dec(2) 10pct replace  

* Alternative negotiation variable*
logit rebelenter l.leftist_conflict_du l.ethnic_clre_du l.rel_clre_conflict negotiationyear l.dem_pol2 lrepressionshock episodeduration l.conflictwar l.internationalized rebelenter_decay l.multiparty, cl(uniquepisode)
outreg2 using table_A3.doc, dec(2) 10pct append  

* Replace democracy with polity revised measure in model 4-7
logit rebelenter l.leftist_conflict_du l.ethnic_clre_du l.rel_clre_conflict firstnegyear l.dem_xpol lrepressionshock episodeduration l.conflictwar l.internationalized rebelenter_decay l.multiparty, cl(uniquepisode)
outreg2 using table_A3.doc, dec(2) 10pct append  

* Add autocratization move dummy 
logit rebelenter l.leftist_conflict_du l.ethnic_clre_du l.rel_clre_conflict firstnegyear l.dem_pol2 l.aut_pol2 lrepressionshock rebelenter_decay episodeduration l.conflictwar l.internationalized l.multiparty, cl(uniquepisode)

* Add static measures of regime type and repression levels
logit rebelenter l.leftist_conflict_du l.ethnic_clre_du l.rel_clre_conflict firstnegyear l.dem_pol2 l.polity2 lrepressionshock l.latentmean episodeduration l.conflictwar l.internationalized rebelenter_decay l.multiparty, cl(uniquepisode)
outreg2 using table_A3.doc, dec(2) 10pct append  
  
 
****************************************************
*** Table A4: Add temporal decay function w. cubic splines ***
****************************************************

*(Table I, Model 1-3)  
logit rebelenter l.leftist_conflict_du l.ethnic_clre_du l.rel_clre_conflict $TIME1, cl(uniquepisode)
outreg2 using table_A4.doc, dec(2) 10pct replace  

logit rebelenter l.leftist_conflict_du l.ethnic_clre_du l.rel_clre_conflict episodeduration l.conflictwar l.internationalized $TIME1, cl(uniquepisode)
outreg2 using table_A4.doc, dec(2) 10pct append  

logit rebelenter l.leftist_conflict_du l.ethnic_clre_du l.rel_clre_conflict episodeduration l.conflictwar l.internationalized l.multiparty $TIME1 , cl(uniquepisode)
outreg2 using table_A4.doc, dec(2) 10pct append  

*(Table I, Model 4-6)
logit rebelenter firstnegyear l.dem_pol2 lrepressionshock $TIME1, cl(uniquepisode)
outreg2 using table_A4.doc, dec(2) 10pct append  

logit rebelenter firstnegyear l.dem_pol2 lrepressionshock episodeduration l.conflictwar l.internationalized $TIME1, cl(uniquepisode)
outreg2 using table_A4.doc, dec(2) 10pct append  

logit rebelenter firstnegyear l.dem_pol2 lrepressionshock episodeduration l.conflictwar l.internationalized  l.multiparty $TIME1, cl(uniquepisode)
outreg2 using table_A4.doc, dec(2) 10pct append  
 
*(Table I, Model 7)
logit rebelenter l.leftist_conflict_du l.ethnic_clre_du l.rel_clre_conflict firstnegyear l.dem_pol2 lrepressionshock episodeduration l.conflictwar l.internationalized  l.multiparty $TIME1, cl(uniquepisode)
outreg2 using table_A4.doc, dec(2) 10pct append  
 

****************************************************
* Table A5: Alternative dependent variable - the number of enters in a year
****************************************************
 
regress enter_number l.leftist_conflict_du l.ethnic_clre_du l.rel_clre_conflict, cl(uniquepisode)
outreg2 using table_A5.doc, dec(2) 10pct replace  

regress enter_number l.leftist_conflict_du l.ethnic_clre_du l.rel_clre_conflict episodeduration l.conflictwar l.internationalized, cl(uniquepisode)
outreg2 using table_A5.doc, dec(2) 10pct append  

regress enter_number l.leftist_conflict_du l.ethnic_clre_du l.rel_clre_conflict episodeduration l.conflictwar l.internationalized rebelenter_decay l.multiparty, cl(uniquepisode)
outreg2 using table_A5.doc, dec(2) 10pct append  

regress enter_number firstnegyear l.dem_pol2 lrepressionshock, cl(uniquepisode)
outreg2 using table_A5.doc, dec(2) 10pct append  

regress enter_number firstnegyear l.dem_pol2 lrepressionshock episodeduration l.conflictwar l.internationalized, cl(uniquepisode)
outreg2 using table_A5.doc, dec(2) 10pct append  

regress enter_number firstnegyear l.dem_pol2 lrepressionshock episodeduration l.conflictwar l.internationalized rebelenter_decay l.multiparty, cl(uniquepisode)
outreg2 using table_A5.doc, dec(2) 10pct append  

regress enter_number l.leftist_conflict_du l.ethnic_clre_du l.rel_clre_conflict firstnegyear l.dem_pol2 lrepressionshock episodeduration l.conflictwar l.internationalized rebelenter_decay l.multiparty, cl(uniquepisode)
outreg2 using table_A5.doc, dec(2) 10pct append  


****************************************************
* Table A6: multinomial logit models, separating joiners and splinter groups
****************************************************
generate ml_enter2=rebelenternospl
replace ml_enter2=2 if splinter==1

mlogit ml_enter2 l.leftist_conflict_du l.ethnic_clre_du l.rel_clre_conflict, cl(uniquepisode)
outreg2 using table_A6.doc, dec(2) 10pct replace  

mlogit ml_enter2 l.leftist_conflict_du l.ethnic_clre_du l.rel_clre_conflict episodeduration l.conflictwar l.internationalized, cl(uniquepisode)
outreg2 using table_A6.doc, dec(2) 10pct append  

mlogit ml_enter2 l.leftist_conflict_du l.ethnic_clre_du l.rel_clre_conflict episodeduration l.conflictwar l.internationalized rebelenter_decay l.multiparty, cl(uniquepisode)
outreg2 using table_A6.doc, dec(2) 10pct append  

mlogit ml_enter2 firstnegyear l.dem_pol2 lrepressionshock, cl(uniquepisode)
outreg2 using table_A6.doc, dec(2) 10pct append  

mlogit ml_enter2 firstnegyear l.dem_pol2 lrepressionshock episodeduration l.conflictwar l.internationalized, cl(uniquepisode)
outreg2 using table_A6.doc, dec(2) 10pct append  

mlogit ml_enter2 firstnegyear l.dem_pol2 lrepressionshock episodeduration l.conflictwar l.internationalized rebelenter_decay l.multiparty, cl(uniquepisode)
outreg2 using table_A6.doc, dec(2) 10pct append  

mlogit ml_enter2 l.leftist_conflict_du l.ethnic_clre_du l.rel_clre_conflict firstnegyear l.dem_pol2 lrepressionshock episodeduration l.conflictwar l.internationalized rebelenter_decay l.multiparty, cl(uniquepisode)
outreg2 using table_A6.doc, dec(2) 10pct append  

