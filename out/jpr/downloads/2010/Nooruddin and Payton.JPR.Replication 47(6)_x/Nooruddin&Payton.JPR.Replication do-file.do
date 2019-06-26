*************************************************************
* 21 January 2010
* Replication file for Nooruddin & Payton
* "Dynamics of Influence in International Politics"
* JOURNAL OF PEACE RESEARCH
* Please send comments/questions to nooruddin.3@osu.edu
*************************************************************


set more off
***** TABLE I: SUMMARY STATISTICS
desc signbia ratifybia exempt waiver_new sanction_anyfull /*
*/ lngdppc tradegdp_ba defensepact /*
*/ fhscore fhscore_changedummy ratifyicc /*
*/ wb_ruleoflaw spigot_actual_pergdp sanction_anyfull

summ signbia ratifybia exempt waiver_new sanction_anyfull /*
*/ lngdppc tradegdp_ba defensepact /*
*/ fhscore fhscore_changedummy ratifyicc /*
*/ wb_ruleoflaw spigot_actual_pergdp sanction_anyfull 

***** TABLE II: RATIFY ICC AS DEPENDENT VARIABLE

stset counter, f(ratifybia==1) exit(ratify_cens==1) id(ctryid)

/* AllStates = Cox model with all states and control for Exemption */
stcox exempt lngdppc tradegdp_ba defensepact fhscore fhscore_changedummy sanction_anyfull /*
*/ ratifyicc wb_ruleoflaw ratifyiccXwbruleoflaw, nohr efron cluster(ctrycode) schoenfeld(sc*) scaledsch(ssc*)
stphtest, detail
drop sc* ssc*

stcox exemptXlnt lngdppc tradegdp_baXlnt defensepact fhscoreXlnt fhscore_changedummyXlnt sanction_anyfullXlnt /*
*/ ratifyiccXlnt wb_ruleoflaw ratifyiccXwbruleoflawXlnt, nohr efron cluster(ctrycode) 

/* AtRiskICC = Cox model with non-exempt ICC Ratifiers Only */
stcox lngdppc tradegdp_ba defensepact fhscore fhscore_changedummy sanction_anyfull /*
*/ ratifyicc wb_ruleoflaw ratifyiccXwbruleoflaw if ratifyicc==1&exempt==0, nohr efron cluster(ctrycode) schoenfeld(sc*) scaledsch(ssc*)
stphtest, detail
drop sc* ssc*

***** FOOTNOTE 13: ROBUSTNESS CHECK 1: USING SIGNING A BIA AS THE DEPENDENT VARIABLE

stset counter, f(signbia==1) exit(sign_cens==1) id(ctryid)

/* AllStates = Cox model with all states and control for Exemption */
stcox exemptXlnt lngdppc tradegdp_baXlnt defensepact fhscoreXlnt fhscore_changedummyXlnt sanction_anyfullXlnt /*
*/ ratifyiccXlnt wb_ruleoflaw ratifyiccXwbruleoflawXlnt, nohr efron cluster(ctrycode)

/* AtRiskICC = Cox model with non-exempt ICC Ratifiers Only */
stcox lngdppc tradegdp_ba defensepact fhscore fhscore_changedummy sanction_anyfull /*
*/ ratifyicc wb_ruleoflaw ratifyiccXwbruleoflaw if ratifyicc==1&exempt==0, nohr efron cluster(ctrycode)

***** FOOTNOTE 13: ROBUSTNESS CHECK 2: TABLE 2 WITH FRAILTY TERM

stset counter, f(ratifybia==1) exit(ratify_cens==1) id(ctryid)

stcox exempt lngdppc tradegdp_ba defensepact fhscore fhscore_changedummy sanction_anyfull /*
*/ ratifyicc wb_ruleoflaw ratifyiccXwbruleoflaw, nohr efron shared(ctryid)
estimates store Frailty

***** FOOTNOTE 13: ROBUSTNESS CHECK 3: TABLE 2 AS A LOGIT

collapse signbia ratifybia exempt waiver_new sanction_anyfull lngdppc tradegdp_ba spigot_actual_pergdp defensepact /*
*/ fhscore fhscore_changedummy /*
*/ ratifyicc wb_ruleoflaw, by(ctryname)
recode signbia 0=0 .=. *=1
recode ratifybia 0=0 .=. *=1
recode exempt 0=0 .=. *=1
recode waiver_new 0=0 .=. *=1
recode sanction_anyfull 0=0 .=. *=1
recode defensepact 0=0 .=. *=1
recode ratifyicc 0=0 .=. *=1
tab1 signbia ratifybia exempt waiver_new sanction_anyfull defensepact ratifyicc
gen ratifyiccXwbruleoflaw = ratifyicc*wb_ruleoflaw
label var ratifyiccXwbruleoflaw "ICC Ratifier X Rule of Law"

logit ratifybia exempt lngdppc tradegdp_ba defensepact fhscore fhscore_changedummy sanction_anyfull /*
*/ ratifyicc wb_ruleoflaw ratifyiccXwbruleoflaw, nolog
logit ratifybia lngdppc tradegdp_ba defensepact fhscore fhscore_changedummy sanction_anyfull /*
*/ ratifyicc wb_ruleoflaw ratifyiccXwbruleoflaw if ratifyicc==1&exempt==0, nolog

***** TABLE III: EXEMPTIONS

logit exempt lngdppc tradegdp_ba defensepact fhscore fhscore_changedummy spigot_actual_pergdp ratifyicc wb_ruleoflaw

***** TABLE III: SANCTION

logit sanction_anyfull lngdppc tradegdp_ba defensepact fhscore fhscore_changedummy spigot_actual_pergdp wb_ruleoflaw if ratifyicc==1
ttest spigot_actual_pergdp if ratifyicc==1, by(sanction_anyfull)
ttest wb_ruleoflaw if ratifyicc==1&exempt==0, by(sanction_anyfull)
summ wb_ruleoflaw if ratifyicc==1&exempt==1
tab sanction_anyfull if ratifyicc==1&exempt==0


***************
* NOTE: Don't save this file at this stage since it has now been collapsed into a country-year dataset.
***************
