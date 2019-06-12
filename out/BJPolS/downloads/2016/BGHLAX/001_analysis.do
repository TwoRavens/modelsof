clear

global path1 = "/Users/hangartn/Dropbox/"

cd "$path1/List Survey Experiment/ReplicationArchive"

*** load merged data ***
use ers_experiment.dta, clear

*** start recoding ***
gen partyvote_num = .
replace partyvote_num = 1 if partyvote=="Conservative Party"
replace partyvote_num = 2 if partyvote=="Green Party" 
replace partyvote_num = 3 if partyvote=="Labour Party" 
replace partyvote_num = 4 if partyvote=="Liberal Democrats"
replace partyvote_num = 5 if partyvote=="UK Independence Party" 

forvalues i=1/5 {
gen partyvote_`i' = (partyvote_num==`i')
}


gen openlist_num = .
replace openlist_num = 1 if treatmentarmopenlist=="true"
replace openlist_num = 0 if treatmentarmopenlist=="false"

gen information_num = .
replace information_num = 1 if treatmentarmwithinformation=="true"
replace information_num = 0 if treatmentarmwithinformation=="false"

gen pro_eu = .
replace pro_eu = 1 if inrange(eumembershipsupport,7,10)
replace pro_eu = 0 if inrange(eumembershipsupport,0,6)

gen anti_eu = .
replace anti_eu = 1 if inrange(eumembershipsupport,0,3)
replace anti_eu = 0 if inrange(eumembershipsupport,4,10)

gen openlistXinformation = openlist_num * information_num

*** code binary treatment closed list / no info vs open list / with info ***
gen openinf = .
replace openinf = 1 if treatmentarmopenlist=="true" & treatmentarmwithinformation=="true"
replace openinf = 0 if treatmentarmopenlist=="false" & treatmentarmwithinformation=="false"

*** identify position of eurosceptic CON candidate***
gen euroscepticCONpos1 = 0 if information_num==1
gen euroscepticCONpos2 = 0 if information_num==1
gen euroscepticCONpos12 = 0 if information_num==1

replace euroscepticCONpos1 = 1 if euroskepticcandidate1==name1 
replace euroscepticCONpos2 = 1 if euroskepticcandidate1==name2 
replace euroscepticCONpos12 = 1 if euroskepticcandidate1==name1 | euroskepticcandidate1==name2 




*** identify eurosceptic/proeurope candidate vote ***
gen eurosceptic_candidatevote = 0 if information_num==1
foreach candname in "Andrew Linden" "Andy Kingsley" "Christine Kendall"	"Conor O'Brien" ///
	"Dom Courtney" "Evelyn Preston" "Jessica Hunter" "Harry Stern" "Ken Chase" "Kenny Greene" ///
	"Kimberley Franks" "Nigel Wyatt" "Richard Grey" "Rosie Travers" "Rowan Jarod" 			{
	replace eurosceptic_candidatevote = -1 if (proeuropecandidate1=="`candname'" | ///
		proeuropecandidate2=="`candname'" | proeuropecandidate3=="`candname'" | ///
		proeuropecandidate4=="`candname'") & candidatevote=="`candname'"
	replace eurosceptic_candidatevote = 1 if (euroskepticcandidate1=="`candname'" | ///
		euroskepticcandidate2=="`candname'" | euroskepticcandidate3=="`candname'" | ///
		euroskepticcandidate4=="`candname'") & candidatevote=="`candname'"
	replace eurosceptic_candidatevote = 1 if (name13=="`candname'" | name14=="`candname'" | ///
	name15=="`candname'") & candidatevote=="`candname'" 
}
	
	 

*** restrict subsample ***

gen sample2use2 = 1 // drop all that take too long / not long enough on common screens
forvalues i=1/3	{
replace sample2use2 = 0 if timeonscreen`i' < 2
replace sample2use2 = 0 if timeonscreen`i' >= 100
}
forvalues i=5/6	{
replace sample2use2 = 0 if timeonscreen`i' < 2
replace sample2use2 = 0 if timeonscreen`i' >= 100
}

*** set survey design / weights ***
svyset, clear
svyset _n [pweight=w8]

*** share of eurosceptic voters ***

svy: tab partyvote  if anti_eu &  treatment == 1
svy: tab partyvote  if anti_eu &  treatment == 4

*** further crosstabs ***

svy: tab treatment
svy: tab partyvote treatment
svy: tab partyvote treatment if gender==2 // female
svy: tab partyvote treatment if gender==1 // male

svy: tab eumembershipsupport 
svy: tab partyvote  treatment if anti_eu   
svy: tab partyvote  treatment if pro_eu == anti_eu
svy: tab partyvote  treatment if pro_eu  


*** code more variables

gen female = (gender==2)

gen lab_partyid = (profile_partyid_2010==1)
gen con_partyid = (profile_partyid_2010==2)
gen lib_partyid = (profile_partyid_2010==3)
gen gre_partyid = (profile_partyid_2010==6)
gen uki_partyid = (profile_partyid_2010==7)
gen no_partyid = (profile_partyid_2010==10)

gen lab_vote = (profile_past_vote_2010==3) 
gen con_vote = (profile_past_vote_2010==2)
gen lib_vote = (profile_past_vote_2010==4) 
gen gre_vote = (profile_past_vote_2010==8) 
gen uki_vote = (profile_past_vote_2010==10) 
gen no_vote = (profile_past_vote_2010==1)


gen reg_north = (region==1)
gen reg_midl = (region==2)
gen reg_east = (region==3)
gen reg_london = (region==4)
gen reg_south = (region==5)
gen reg_wales = (region==6)
gen reg_scot = (region==7)

*** get interview dates ***
gen day1=day(starttime)


*** save final data ***
save data.dta, replace


*** load final data ***
use data.dta, clear

*** set survey design / weights ***
svyset, clear
svyset _n [pweight=w8]

/* Note the ordering of the parties follows the numerical coding of partyvote
. tab partyvote

                       Party Vote |      Freq.     Percent        Cum.
----------------------------------+-----------------------------------
               Conservative Party |      2,078       22.85       22.85
                      Green Party |      1,157       12.72       35.57
                     Labour Party |      2,723       29.94       65.50
                Liberal Democrats |        840        9.23       74.74
            UK Independence Party |      2,298       25.26      100.00
----------------------------------+-----------------------------------
                            Total |      9,096      100.00
*/

*** TABLE 1: design table  ***
forvalues i=1/4	{
svy: tab treatment  if treatment==`i'
}

*** TABLE 2: main regression; FIGURE 4 lincom estimates*** 
svy: reg partyvote_1 
outreg2 using voteshares.xls , excel  stats(coef tstat) noaster cttop("delete") dec(2) replace
forvalues i=1/5	{
	svy: reg partyvote_`i' openlist_num information_num openlistXinformation 
	outreg2 using voteshares.xls , excel  stats(coef tstat) noaster cttop("p=`i'") dec(2) append
}

forvalues i=1/5	{
svy: reg partyvote_`i' openlist_num information_num openlistXinformation 
lincomest openlist_num   + openlistXinformation 
qui svy: reg partyvote_`i' openlist_num information_num openlistXinformation 
scal baseline = _b[_cons] + _b[information_num]
lincom (openlist_num   + openlistXinformation) / baseline
}

*** TABLE 6: balance tests; estimates for FIGURE 11: Q-Q plot***

forvalues i=1/4	{
svy: mean eumembershipsupport if treatment==`i'
}
svy: reg eumembershipsupport openlist_num##information_num

forvalues i=1/4	{
svy: mean female if treatment==`i'
}
svy: reg female openlist_num##information_num

forvalues i=1/4	{
svy: mean age if treatment==`i'
}
svy: reg age openlist_num##information_num

forvalues i=1/4	{
svy: mean lab_partyid if treatment==`i'
}
svy: reg lab_partyid openlist_num##information_num
forvalues i=1/4	{
svy: mean con_partyid if treatment==`i'
}
svy: reg con_partyid openlist_num##information_num 
forvalues i=1/4	{
svy: mean lib_partyid if treatment==`i'
}
svy: reg lib_partyid openlist_num##information_num 
forvalues i=1/4	{
svy: mean gre_partyid if treatment==`i'
}
svy: reg gre_partyid openlist_num##information_num 
forvalues i=1/4	{
svy: mean uki_partyid if treatment==`i'
}
svy: reg uki_partyid openlist_num##information_num 
forvalues i=1/4	{
svy: mean no_partyid if treatment==`i'
}
svy: reg no_partyid openlist_num##information_num 

forvalues i=1/4	{
svy: mean lab_vote if treatment==`i'
}
svy: reg lab_vote openlist_num##information_num
forvalues i=1/4	{
svy: mean con_vote if treatment==`i'
}
svy: reg con_vote openlist_num##information_num 
forvalues i=1/4	{
svy: mean lib_vote if treatment==`i'
}
svy: reg lib_vote openlist_num##information_num 
forvalues i=1/4	{
svy: mean gre_vote if treatment==`i'
}
svy: reg gre_vote openlist_num##information_num 
forvalues i=1/4	{
svy: mean uki_vote if treatment==`i'
}
svy: reg uki_vote openlist_num##information_num 
forvalues i=1/4	{
svy: mean no_vote if treatment==`i'
}
svy: reg no_vote openlist_num##information_num 

forvalues i=1/4	{
svy: mean reg_north if treatment==`i'
}
svy: reg reg_north openlist_num##information_num 
forvalues i=1/4	{
svy: mean reg_midl if treatment==`i'
}
svy: reg reg_midl openlist_num##information_num 
forvalues i=1/4	{
svy: mean reg_east if treatment==`i'
}
svy: reg reg_east openlist_num##information_num 
forvalues i=1/4	{
svy: mean reg_london if treatment==`i'
}
svy: reg reg_london openlist_num##information_num 
forvalues i=1/4	{
svy: mean reg_south if treatment==`i'
}
svy: reg reg_south openlist_num##information_num  
forvalues i=1/4	{
svy: mean reg_wales if treatment==`i'
}
svy: reg reg_wales openlist_num##information_num 
forvalues i=1/4	{
svy: mean reg_scot if treatment==`i'
}
svy: reg reg_scot openlist_num##information_num 

forvalues i=1/4	{
svy: reg treatment if treatment==`i'
}
svy: reg treatment openlist_num##information_num 

*** Figure 6: results by EU stance ***
svy: reg partyvote_1 openlist_num information_num openlistXinformation  if pro_eu
lincomest openlist_num   + openlistXinformation 
svy: reg partyvote_5 openlist_num information_num openlistXinformation   if pro_eu
lincomest openlist_num   + openlistXinformation 

svy: reg partyvote_1 openlist_num information_num openlistXinformation if anti_eu==0 & pro_eu==0
lincomest openlist_num   + openlistXinformation 
svy: reg partyvote_5 openlist_num information_num openlistXinformation if anti_eu==0 & pro_eu==0
lincomest openlist_num   + openlistXinformation 

svy: reg partyvote_1 openlist_num information_num openlistXinformation if anti_eu
lincomest openlist_num   + openlistXinformation 
svy: reg partyvote_5 openlist_num information_num openlistXinformation  if anti_eu
lincomest openlist_num   + openlistXinformation 

*** TABLE 8: Position on list ***
svy: reg partyvote_1 euroscepticCONpos1  if treatment==2 & anti_eu
outreg2 using listpos.xls , excel  stats(coef tstat) noaster cttop("CON 1st") dec(2) replace
svy: reg partyvote_1 euroscepticCONpos2  if treatment==2 & anti_eu
outreg2 using listpos.xls , excel  stats(coef tstat) noaster cttop("CON 2nd") dec(2) append
svy: reg partyvote_1 euroscepticCONpos12  if treatment==2 & anti_eu
outreg2 using listpos.xls , excel  stats(coef tstat) noaster cttop("CON 1st2nd") dec(2) append

svy: reg partyvote_5 euroscepticCONpos1  if treatment==2 & anti_eu
outreg2 using listpos.xls , excel  stats(coef tstat) noaster cttop("UKIP 1st") dec(2) append
svy: reg partyvote_5 euroscepticCONpos2  if treatment==2 & anti_eu
outreg2 using listpos.xls , excel  stats(coef tstat) noaster cttop("UKIP 2nd") dec(2) append
svy: reg partyvote_5 euroscepticCONpos12  if treatment==2 & anti_eu
outreg2 using listpos.xls , excel  stats(coef tstat) noaster cttop("UKIP 1st2nd") dec(2) append

*** gen party support indicators***
gen sup_con = (dpq1==1)
gen sup_lab = (dpq1==2)
gen sup_lib = (dpq1==3)
gen sup_gre = (dpq2==1)
gen sup_ukip= (dpq2==2)
gen sup_no  = (dpq1==3 |  inrange(dpq1,6,7) | inrange(dpq2,3,6) ) 

gen party_sup = .
replace party_sup = 1 if sup_con == 1
replace party_sup = 2 if sup_gre == 1
replace party_sup = 3 if sup_lab == 1
replace party_sup = 4 if sup_lib == 1
replace party_sup = 5 if sup_ukip== 1

*** TABLE 7: subsample analysis; FIGURE 5:  lincom estimates ***
outreg2 using party_sup.xls , excel  stats(coef tstat) noaster cttop("delete") dec(2) replace
forvalues j=1/5	{
	forvalues i=1/5	{
		svy: reg partyvote_`i' openlist_num information_num openlistXinformation  if party_sup==`j'
		outreg2 using party_sup.xls , excel  stats(coef tstat) noaster cttop("p=`i' v=`j'") dec(2) append
	}
}

global tflist2 ""
global modseq2=0
foreach subset in 		"party_sup==2" "party_sup==3" "party_sup==4" "party_sup==1" "party_sup==5"  {
	foreach outcome in  "partyvote_2"  "partyvote_3"  "partyvote_4"  "partyvote_1"  "partyvote_5" {
		global modseq2=$modseq2+1
		tempfile tf2$modseq2
		svy: reg `outcome' openlist_num information_num openlistXinformation if `subset'
		lincomest openlist_num  + openlistXinformation 
		parmest, format(estimate min95 max95 %8.1e) idn($modseq2) label  ///
                 saving("$path1\tf2$modseq2.dta", replace) flist(tflist2)
	}
}

preserve
	dsconcat $tflist2
	saveold parmest2.dta, replace
restore

*** TABLE 5: candidates' and respondents' stance on EU ***
forvalues i=1/5	{
di `i'
svy: tab eurosceptic_candidatevote if treatment==4 & partyvote_`i'==1
}

gen eu_stance_cat3 = .
replace eu_stance_cat3 = -1 if pro_eu==1
replace eu_stance_cat3 = 0 if pro_eu ==0 & anti_eu==0
replace eu_stance_cat3 = 1 if  anti_eu==1

forvalues i=1/5	{
di `i'
svy: tab eu_stance_cat3 if treatment==4 & partyvote_`i'==1
}




