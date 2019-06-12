****************************************************************************************************
* Data for the replication of ALL IN THE FAMILY: 
*	Partisan Disagreement and Electoral Mobilization in Intimate Networks - a Spillover Experiment
* Florian Foos and Eline A. de Rooij 
* American Journal of Political Science
* Date: June 10, 2016
****************************************************************************************************

* The following analyses were carried out using Stata/SE 13.1 for Windows (64-bit x86-64) 

* download .dta and .grec files into new personal folder and specify it as the working directory:
cd " " 
** NOTE: insert correct link to folder between " " 

* open data (from folder set as working directory):
use "Foos&de Rooij_AJPS_data_10Jun2016.dta"

* recode existing variables:
recode title (1=999 "missing") (2/5 7=1 "male") (6=2 "female"), gen(gender)
label var gender "gender, with missing"

recode landlinemobileboth (1=3 "both") (2=1 "landline only") (3=2 "mobile only"), gen(landline1)
label var landline1 "landline, mobile or both number(s) recorded"
* NOTE: this data excludes all primary experimental subjects with a mobile phone number only or with both, 
** as well as their household members. These subjects were part of a separate experiment

recode treatment (1=1 "C1") (2 5=.) (3=2 "T1") (4=3 "T2") if landline1==1, gen(treatment1)
label var treatment1 "control and treatment groups for primary subjects with landlines"
* NOTE: 
** "C1" is control group consisting of primary experimental subjects assigned not to receive any treatment
** "T1" is high partisan intensity treatment group (primary experimental subjects)
** "T2" is low partisan intensity treatment group (primary experimental subjects)
** "C2" is control group consisting of secondary household members of primary experimental subjects assigned not to receive any treatment

recode vote_PCC2012 (1=0 "did not vote") (2=.) (3=1 "voted"), gen(turnout)
label var turnout "turnout in 2012 PCC election"

****************************
* PARTY ID VARIABLES
****************************

* NOTE: Meaning of latestvoterid values:
** 1=" " (i.e. missing); 4=d (don't know); 6=h ("either a code that is not in use anymore, or a typo"); 15=x (won't say); 17=z (non voter)
** 9 = l (Labour)
** 2=a (against); 3=b (UK Independence Party); 5=g (Green); 7=i (independent candidate); 8=j ("other party 1"); 10=n (SNP); 11=o ("other party 4"); 12=r (Respect); 13=s (Liberal Democrat); 14=t (Conservative); 16=y ("other party 6")
** No v=BNP for this variable

* create duplicate of latestvoterid with value names:
gen voterid=latestvoterid
label define voteridl 1 "missing" 2 "against" 3 "UKIP" 4 "don't know" 5 "Green" 6 "code not in use" 7 "independent candidate" 8 "other party 1" 9 "Labour" 10 "SNP" 11 "other party 4" 12 "Respect" 13 "Liberal Democrat" 14 "Conservative" 15 "won't say" 16 "other party 6" 17 "non voter"
label values voterid voteridl    
label var voterid "lastestvoterid with labels"

* create 3-category party id variable for primary experimental subjects only:
recode latestvoterid (1 4 6 15 17=3 "unknown") (9=2 "Labour") (2/3 5 7/8 10/14 16=1 "other party") if treatment!=2, gen(pid)
label define pidl 1 "other party" 2 "Labour" 3 "unknown" 
label values pid pidl 
label var pid "pid for primary experimental subjects only"

* create variable for the total number of registered voters per household
* with primary experimental subject listed first in each household:
gsort hh_id -random
egen hh_size = count(_N), by(hh_id)
label var hh_size "total number of regis. voters in household"

* create 3-category party id variable for all individuals in data
* and 3-category variable indicating for all household members the party id of the primary experimental subject in the household:
recode latestvoterid (1 4 6 15 17=3 "unknown") (9=2 "Labour") (2/3 5 7/8 10/14 16=1 "other party"), gen(all_pid)
egen pid_hh=total(pid), by(hh_id)
label values pid_hh pidl 
label var all_pid "pid for all individuals in data"
label var pid_hh "pid of only household member in experiment"

* create treatment variable per household:
gen temp=treatment if treatment!=2
egen treat_hh=total(temp), by(hh_id)
label values treat_hh treatment
drop temp
label var treat_hh "experimental assignment of household member in exp."

* create identifyer for each member within a household, with n=1 as the primary experimental subject:
by hh_id, sort: gen hh_n =_n
label var hh_n "unique identifyer within household"

* create full voterid variable indicating for all household members the party id of the primary experimental subject in the household:
gen tempid=voterid if hh_n==1
egen voterid_hh=total(tempid), by(hh_id)
label values voterid_hh voteridl
label var voterid_hh "latestvoterid of only household member in experiment"
drop tempid

****************************
* MISSING AND ABSENT VOTERS
****************************

* create identifyer per household for missing voters and postal voters 

* hh member in experiment has missing data on turnout:
recode turnout (.=1) (0 1=0), gen(tempmiss)
gen tempmiss2=tempmiss if hh_n==1
egen votemiss_hh=total(tempmiss2), by(hh_id)
label var votemiss_hh "household member in exp. has missing turnout data"
label define missl 0 "hh member in exp. has no missing turnout data" 1 "hh member in exp. has missing turnout data"  
label values votemiss_hh missl
* at least one hh member missing on turnout:
egen misvoted=count(turnout), by(hh_id)
gen tempmiss3=hh_size-misvoted
recode tempmiss3 (0=0 "no missing turnout data") (1/100=1 "missing t.o. data for at least 1 hh member"), gen(totalmiss_hh)
label var totalmiss_hh "missing turnout data within household"
drop tempmiss tempmiss2 misvoted tempmiss3

* hh member in experiment is an absent voter (postal or proxy):
gen temppost=currentabsentvoter if hh_n==1
egen postal_hh=total(temppost), by(hh_id)
recode postal_hh (1=0) (2=1)
label var postal_hh "household member in experiment is postal voter"
label define postl 0 "hh member in exp. is not a postal voter" 1 "hh member in exp. is postal voter"  
label values postal_hh postl 
drop temppost
* at least one hh member is a postal or proxy voter:
recode currentabsentvoter (1=0) (2 3=1), gen(postal)
label var postal "current postal or proxy voter"
label define postall 0 "not a postal/proxy voter" 1 "postal/proxy voter"  
label values postal postall 
egen totalpostal_hh=total(postal), by(hh_id)
label var totalpostal_hh "number of postal or proxy voters in household"

****************************
* CONTACT VARIABLE
****************************

* hh member in experiment assigned to either treatment was successfully contacted:
gen temp=contact 
egen contact_hh=total(temp), by(hh_id)
label var contact_hh "household member in exp. treatment group was successfully contacted"
label define contl 0 "no contact with hh member in exp." 1 "contact with hh member in exp."  
label values contact_hh contl
drop temp

**********************************
* HOUSEHOLD PARTY ID COMBINATIONS 
**********************************

** Combinations of party id within households
gen pid_com=.
replace pid_com=1 if pid_hh==1 & all_pid==1
replace pid_com=2 if pid_hh==1 & all_pid==2
replace pid_com=3 if pid_hh==1 & all_pid==3
replace pid_com=4 if pid_hh==2 & all_pid==1
replace pid_com=5 if pid_hh==2 & all_pid==2
replace pid_com=6 if pid_hh==2 & all_pid==3
replace pid_com=7 if pid_hh==3 & all_pid==1
replace pid_com=8 if pid_hh==3 & all_pid==2
replace pid_com=9 if pid_hh==3 & all_pid==3

label define pid_coml 1 "other/other" 2 "other/Labour" 3 "other/unknown" 4 "Labour/other" 5 "Labour/Labour" 6 "Labour/unknown" 7 "unknown/other" 8 "unknown/Labour" 9 "unknown/unknown" 
label values pid_com pid_coml 
label var pid_com "combination of pid of hh member in exp and other household member"
* NOTE: before the slash is party id of hh member included in experiment
* check:
* tab3way pid_com all_pid pid_hh
* tab pid_hh pid_com

tab pid_com if treatment==2
recode pid_com (1 2 3=1) (4 5 6=2) (7 8 9=3), into(blocks)
label var blocks "pid of only household member in experiment"
label values blocks pidl 
* NOTE: this is the same variable as pid_hh

** More fine-grained combinations of party id within households, with separate category for households that support two different parties, but not Labour:
gen diffrival=voterid!=voterid_hh if pid_com==1
label var diffrival "primary and sec. hh memb. support different other parties" 
gen pid_com2=pid_com
replace pid_com2=10 if diffrival==1
label define pid_com2l 1 "hom. other/other" 2 "other/Labour" 3 "other/unknown" 4 "Labour/other" 5 "Labour/Labour" 6 "Labour/unknown" 7 "unknown/other" 8 "unknown/Labour" 9 "unknown/unknown" 10 "het. other/other"
label values pid_com2 pid_com2l 
label var pid_com2 "combination of pid of hh member in exp and other household member"
* tab pid_com pid_com2
* tab voterid voterid_hh if pid_com2==10

*******************************
* SPILLOVER TREATMENT
*******************************

* create spillover-treatment variable for non-experimental (secondary) subjects
gen spill=treat_hh if treatment==2
recode spill (1=1 "C1") (3=2 "T1") (4=3 "T2"), into(spillover_treatment)
label var spillover_treatment "treatment group for non-experimental hh member"
drop spill
* check frequency
* tab pid_com spillover_treatment 

**********************************************************
* HOUSEHOLD PARTY ID COMBINATIONS
**********************************************************

* NOTE:	the value for these variables is the same for each household member (as opposed to the value for e.g., pid_com)

* creating a household variable for party id combinations:
gen temp=.
replace temp=pid_com if hh_n!=1
egen pid_com_hh=total(temp), by(hh_id)
label var pid_com_hh "combination of pid within households"
label values pid_com_hh pid_coml
drop temp
* NOTE: before the slash is party id of hh member included in experiment

recode pid_com_hh (1 5=2 "partisan hom.") (2 4=1 "partisan het.") (3 6 7 8 9=3 "unknown"), into(pid_comb)
label var pid_comb "combination of pid within households, 3 categories"
recode pid_com_hh (1=2 "other hom.") (5=3 "Labour hom.") (2 4=1 "partisan het.") (3 6 7 8=4 "unknown/partisan") (9=5 "both unknown"), into(pid_combi)
label var pid_combi "combination of pid within households, 5 categories"

*******************************
* DUMMY VARIABLES
*******************************

* recode spillover_treatment to combine both treatment groups vs. control:
recode spillover_treatment (1=0 "C1") (2 3=1 "T1&T2"), into(spill)
label var spill "treatment vs control for non-exp. hh member"

* create dummy for spillover high partisan intensity treatment (T1) vs. low partisan intensity treatment (T2):
recode spillover_treatment (1=.) (2=1 "T1") (3=0 "T2"), into(partisan)
label var partisan "partisan vs non-part. treatment for non-exp. hh member"

* create covariate dummies:
tab gender, gen(gender_)
tab ward, gen(ward_)
tab local2012, gen(local2012_)
tab local2011, gen(local2011_)
tab General2010, gen(General2010_)
tab elect5, gen(elect5_)
tab elect6, gen(elect6_)
tab elect7, gen(elect7_)
tab elect8, gen(elect8_)

recode age (.=1) (1/999=0), into(agenoresp)
label var agenoresp "missing on age"
* mean of age is 52 (in full data set)
recode age (.=52), into(agei)
label var agei "age, with mean for missing"
gen ageii=agei-18
label var ageii "agei, recoded"

* create variables grouping individuals based on either the primary experimental subjects' or their secondary, unassigned, household members' party id:
recode pid_com (1 2 3=1 "rival") (4 5 6=2 "Lab") (7 8 9=3 "unattached"), into(assigned)
label var assigned "assigned hh member's party id"
recode pid_com (1 4 7=1 "rival") (2 5 8=2 "Lab") (3 6 9=3 "unattached"), into(unassigned)
label var unassigned "unassigned hh member's party id"

* change variables from float to long for analysis in R
recast long voterid pid_hh treat_hh voterid_hh votemiss_hh totalmiss_hh postal_hh contact_hh pid_com blocks pid_com2 spillover_treatment pid_com_hh pid_comb pid_combi spill partisan assigned unassigned

* sort data
gsort hh_id -random

** SAVE dataset with missing values for attrition test:
save "Foos&de Rooij_AJPS_data_missingvalues.dta"

**********************************************
* DELETE HOUSEHOLDS WITH MISSING TURNOUT DATA
**********************************************

* remove 2-voter households that have one or more individuals for whom turnout in the 2012 PCC election is unknown:
drop if totalmiss_hh==1
*520 observations deleted

** SAVE dataset for further analysis:
save "Foos&de Rooij_AJPS_data_analysis.dta"


**********************************************
**********************************************
* ANALYSES
**********************************************
**********************************************

* NOTE: 
** "C1" is control group 
** "T1" is high partisan intensity treatment group
** "T2" is low partisan intensity treatment group


* TABLE 1 MANUSCRIPT 
** Execute Manuscript_Table1_20May2016.R


* TABLE 2 MANUSCRIPT
* NOTE: use "Foos&de Rooij_AJPS_data_analysis.dta"

* column I:
logit turnout i.blocks c.partisan i.pid_comb if contact_hh==1
* column II:
logit turnout i.blocks c.partisan i.pid_comb postal gender_2 gender_3 ward_2 ward_3 ward_4 ageii agenoresp elect5_2 elect6_2 elect7_2 elect8_2 local2012_2 local2011_2 General2010_2 if contact_hh==1
* column III:
logit turnout i.blocks c.partisan i.pid_comb i.pid_comb#c.partisan if contact_hh==1
* column IV:
logit turnout i.blocks c.partisan i.pid_comb i.pid_comb#c.partisan postal gender_2 gender_3 ward_2 ward_3 ward_4 ageii agenoresp elect5_2 elect6_2 elect7_2 elect8_2 local2012_2 local2011_2 General2010_2 if contact_hh==1 
* column V:
logit turnout i.blocks c.partisan i.pid_comb i.pid_comb#c.partisan postal gender_2 gender_3 ward_2 ward_3 ward_4 ageii agenoresp elect5_2 elect6_2 elect7_2 elect8_2 local2012_2 local2011_2 General2010_2 c.partisan#c.postal c.partisan#c.gender_2 c.partisan#c.gender_3 c.partisan#c.ward_2 c.partisan#c.ward_3 c.partisan#c.ward_4 c.partisan#c.ageii c.partisan#c.agenoresp c.partisan#c.elect5_2 c.partisan#c.elect6_2 c.partisan#c.elect7_2 c.partisan#c.elect8_2 c.partisan#c.local2012_2 c.partisan#c.local2011_2 c.partisan#c.General2010_2  if contact_hh==1


* FIGURE 3 MANUSCRIPT
* NOTE: use "Foos&de Rooij_AJPS_data_analysis.dta"

* Figure 3a:
logit turnout i.blocks c.spill i.pid_comb i.pid_comb#c.spill c.postal  gender_2 gender_3 ward_2 ward_3 ward_4 ageii agenoresp elect5_2 elect6_2 elect7_2 elect8_2 local2012_2 local2011_2 General2010_2 c.spill#c.postal  c.spill#c.gender_2 c.spill#c.gender_3 c.spill#c.ward_2 c.spill#c.ward_3 c.spill#c.ward_4 c.spill#c.ageii c.spill#c.agenoresp c.spill#c.elect5_2 c.spill#c.elect6_2 c.spill#c.elect7_2 c.spill#c.elect8_2 c.spill#c.local2012_2 c.spill#c.local2011_2 c.spill#c.General2010_2 
margins, dydx(spill) atmeans at (pid_comb=(1(1)3))
marginsplot
graph play "Figure3a.grec"
** NOTE: Figure3a.grec should have been previously downloaded into the folder set as working directory
graph save "Figure3a.gph"

* Figure 3b:
logit turnout i.blocks c.spill i.pid_combi i.pid_combi#c.spill postal  gender_2 gender_3 ward_2 ward_3 ward_4 ageii agenoresp elect5_2 elect6_2 elect7_2 elect8_2 local2012_2 local2011_2 General2010_2 c.spill#c.postal  c.spill#c.gender_2 c.spill#c.gender_3 c.spill#c.ward_2 c.spill#c.ward_3 c.spill#c.ward_4 c.spill#c.ageii c.spill#c.agenoresp c.spill#c.elect5_2 c.spill#c.elect6_2 c.spill#c.elect7_2 c.spill#c.elect8_2 c.spill#c.local2012_2 c.spill#c.local2011_2 c.spill#c.General2010_2
margins, dydx(spill) atmeans at (pid_combi=(1(1)5))
marginsplot
graph play "Figure3b.grec"
** NOTE: Figure3b.grec should have been previously downloaded into the folder set as working directory
graph save "Figure3b.gph"


* FIGURE 4 MANUSCRIPT
* NOTE: use "Foos&de Rooij_AJPS_data_analysis.dta"

* Figure 4a:
logit turnout c.spill i.assigned i.unassigned i.assigned#i.unassigned i.assigned#c.spill i.unassigned#c.spill i.assigned#i.unassigned#c.spill postal gender_2 gender_3 ward_2 ward_3 ward_4 ageii agenoresp elect5_2 elect6_2 elect7_2 elect8_2 local2012_2 local2011_2 General2010_2 c.spill#c.postal  c.spill#c.gender_2 c.spill#c.gender_3 c.spill#c.ward_2 c.spill#c.ward_3 c.spill#c.ward_4 c.spill#c.ageii c.spill#c.agenoresp c.spill#c.elect5_2 c.spill#c.elect6_2 c.spill#c.elect7_2 c.spill#c.elect8_2 c.spill#c.local2012_2 c.spill#c.local2011_2 c.spill#c.General2010_2
margins, dydx(spill) atmeans at (assigned=(1) unassigned=(1(1)3))
marginsplot
graph play "Figure4.grec"
** NOTE: Figure4.grec should have been previously downloaded into the folder set as working directory
** NOTE: the same graph format is used for Figures 4a, 4b and 4c, namely "Figure4.grec"
graph save "Figure4a.gph"

* Figure 4b:
margins, dydx(spill) atmeans at (assigned=(2) unassigned=(1(1)3))
marginsplot
graph play "Figure4.grec"
** NOTE: Figure4.grec should have been previously downloaded into the folder set as working directory
** NOTE: the same graph format is used for Figures 4a, 4b and 4c, namely "Figure4.grec"
graph save "Figure4b.gph"

* Figure 4c:
margins, dydx(spill) atmeans at (assigned=(3) unassigned=(1(1)3))
marginsplot
graph play "Figure4.grec"
** NOTE: Figure4.grec should have been previously downloaded into the folder set as working directory
** NOTE: the same graph format is used for Figures 4a, 4b and 4c, namely "Figure4.grec"
graph save "Figure4c.gph"

* Combined Figure:
graph combine "Figure4a.gph" "Figure4b.gph" "Figure4c.gph"
graph play "Figure4_combine.grec"
** NOTE: Figure4_combine.grec should have been previously downloaded into the folder set as working directory
graph save "Figure4_combine.gph"


* FIGURE 5 MANUSCRIPT
* NOTE: use "Foos&de Rooij_AJPS_data_analysis.dta"

* Figure 5a:
logit turnout i.blocks c.partisan i.pid_comb i.pid_comb#c.partisan postal gender_2 gender_3 ward_2 ward_3 ward_4 ageii agenoresp elect5_2 elect6_2 elect7_2 elect8_2 local2012_2 local2011_2 General2010_2 c.partisan#c.postal c.partisan#c.gender_2 c.partisan#c.gender_3 c.partisan#c.ward_2 c.partisan#c.ward_3 c.partisan#c.ward_4 c.partisan#c.ageii c.partisan#c.agenoresp c.partisan#c.elect5_2 c.partisan#c.elect6_2 c.partisan#c.elect7_2 c.partisan#c.elect8_2 c.partisan#c.local2012_2 c.partisan#c.local2011_2 c.partisan#c.General2010_2  if contact_hh==1
margins, dydx(partisan) atmeans at (pid_comb=(1(1)3))
marginsplot
graph play "Figure5a.grec"
** NOTE: Figure5a.grec should have been previously downloaded into the folder set as working directory
graph save "Figure5a.gph"

* Figure 5b:
logit turnout i.blocks c.partisan i.pid_combi i.pid_combi#c.partisan postal gender_2 gender_3 ward_2 ward_3 ward_4 ageii agenoresp elect5_2 elect6_2 elect7_2 elect8_2 local2012_2 local2011_2 General2010_2 c.partisan#c.postal c.partisan#c.gender_2 c.partisan#c.gender_3 c.partisan#c.ward_2 c.partisan#c.ward_3 c.partisan#c.ward_4 c.partisan#c.ageii c.partisan#c.agenoresp c.partisan#c.elect5_2 c.partisan#c.elect6_2 c.partisan#c.elect7_2 c.partisan#c.elect8_2 c.partisan#c.local2012_2 c.partisan#c.local2011_2 c.partisan#c.General2010_2 if contact_hh==1
margins, dydx(partisan) atmeans at (pid_combi=(1(1)5))
marginsplot
graph play "Figure5b.grec"
** NOTE: Figure5b.grec should have been previously downloaded into the folder set as working directory
graph save "Figure5b.gph"


* TABLE A1 SUPPORTING INFORMATION
** Execute Supporting_Information_Tables_A1_A2_A3.R


* TABLE A2 SUPPORTING INFORMATION
** Execute Supporting_Information_Tables_A1_A2_A3.R


* TABLE A3 SUPPORTING INFORMATION - ITT
* NOTE: use "Foos&de Rooij_AJPS_data_analysis.dta"

* column I:
logit turnout i.blocks c.spill i.pid_comb i.pid_comb#c.spill
* column II: 
logit turnout i.blocks c.spill i.pid_comb i.pid_comb#c.spill postal gender_2 gender_3 ward_2 ward_3 ward_4 ageii agenoresp elect5_2 elect6_2 elect7_2 elect8_2 local2012_2 local2011_2 General2010_2
* column III:
logit turnout i.blocks c.spill i.pid_comb i.pid_comb#c.spill c.postal  gender_2 gender_3 ward_2 ward_3 ward_4 ageii agenoresp elect5_2 elect6_2 elect7_2 elect8_2 local2012_2 local2011_2 General2010_2 c.spill#c.postal  c.spill#c.gender_2 c.spill#c.gender_3 c.spill#c.ward_2 c.spill#c.ward_3 c.spill#c.ward_4 c.spill#c.ageii c.spill#c.agenoresp c.spill#c.elect5_2 c.spill#c.elect6_2 c.spill#c.elect7_2 c.spill#c.elect8_2 c.spill#c.local2012_2 c.spill#c.local2011_2 c.spill#c.General2010_2 if hh_size==2, cluster(hh_id)


* TABLE A3 SUPPORTING INFORMATION - CACE
** Execute Supporting_Information_Tables_A1_A2_A3.R


* TABLE A4 SUPPORTING INFORMATION
* NOTE: use "Foos&de Rooij_AJPS_data_analysis.dta"

* column I:
logit turnout i.blocks c.spill i.pid_combi i.pid_combi#c.spill
* column II:
logit turnout i.blocks c.spill i.pid_combi i.pid_combi#c.spill postal gender_2 gender_3 ward_2 ward_3 ward_4 ageii agenoresp elect5_2 elect6_2 elect7_2 elect8_2 local2012_2 local2011_2 General2010_2
* column III:
logit turnout i.blocks c.spill i.pid_combi i.pid_combi#c.spill postal  gender_2 gender_3 ward_2 ward_3 ward_4 ageii agenoresp elect5_2 elect6_2 elect7_2 elect8_2 local2012_2 local2011_2 General2010_2 c.spill#c.postal  c.spill#c.gender_2 c.spill#c.gender_3 c.spill#c.ward_2 c.spill#c.ward_3 c.spill#c.ward_4 c.spill#c.ageii c.spill#c.agenoresp c.spill#c.elect5_2 c.spill#c.elect6_2 c.spill#c.elect7_2 c.spill#c.elect8_2 c.spill#c.local2012_2 c.spill#c.local2011_2 c.spill#c.General2010_2


* TABLE A5 SUPPORTING INFORMATION
* NOTE: use "Foos&de Rooij_AJPS_data_analysis.dta"

* column I:
logit turnout c.spill i.assigned i.unassigned i.assigned#i.unassigned i.assigned#c.spill i.unassigned#c.spill i.assigned#i.unassigned#c.spill
* column II:
logit turnout c.spill i.assigned i.unassigned i.assigned#i.unassigned i.assigned#c.spill i.unassigned#c.spill i.assigned#i.unassigned#c.spill postal gender_2 gender_3 ward_2 ward_3 ward_4 ageii agenoresp elect5_2 elect6_2 elect7_2 elect8_2 local2012_2 local2011_2 General2010_2 
* column III:
logit turnout c.spill i.assigned i.unassigned i.assigned#i.unassigned i.assigned#c.spill i.unassigned#c.spill i.assigned#i.unassigned#c.spill postal gender_2 gender_3 ward_2 ward_3 ward_4 ageii agenoresp elect5_2 elect6_2 elect7_2 elect8_2 local2012_2 local2011_2 General2010_2 c.spill#c.postal  c.spill#c.gender_2 c.spill#c.gender_3 c.spill#c.ward_2 c.spill#c.ward_3 c.spill#c.ward_4 c.spill#c.ageii c.spill#c.agenoresp c.spill#c.elect5_2 c.spill#c.elect6_2 c.spill#c.elect7_2 c.spill#c.elect8_2 c.spill#c.local2012_2 c.spill#c.local2011_2 c.spill#c.General2010_2


* TABLE A6 SUPPORTING INFORMATION
* NOTE: use "Foos&de Rooij_AJPS_data_analysis.dta"

* column I:
logit turnout i.blocks c.partisan i.pid_combi if contact_hh==1
* column II:
logit turnout i.blocks c.partisan i.pid_combi postal gender_2 gender_3 ward_2 ward_3 ward_4 ageii agenoresp elect5_2 elect6_2 elect7_2 elect8_2 local2012_2 local2011_2 General2010_2 if contact_hh==1
* column III:
logit turnout i.blocks c.partisan i.pid_combi i.pid_combi#c.partisan if contact_hh==1
* column IV:
logit turnout i.blocks c.partisan i.pid_combi i.pid_combi#c.partisan postal gender_2 gender_3 ward_2 ward_3 ward_4 ageii agenoresp elect5_2 elect6_2 elect7_2 elect8_2 local2012_2 local2011_2 General2010_2 if contact_hh==1
* column V:
logit turnout i.blocks c.partisan i.pid_combi i.pid_combi#c.partisan postal gender_2 gender_3 ward_2 ward_3 ward_4 ageii agenoresp elect5_2 elect6_2 elect7_2 elect8_2 local2012_2 local2011_2 General2010_2 c.partisan#c.postal c.partisan#c.gender_2 c.partisan#c.gender_3 c.partisan#c.ward_2 c.partisan#c.ward_3 c.partisan#c.ward_4 c.partisan#c.ageii c.partisan#c.agenoresp c.partisan#c.elect5_2 c.partisan#c.elect6_2 c.partisan#c.elect7_2 c.partisan#c.elect8_2 c.partisan#c.local2012_2 c.partisan#c.local2011_2 c.partisan#c.General2010_2 if contact_hh==1


* FIGURE A1 AND A2 SUPPORTING INFORMATION
** Execute Supporting_Information_Balance_Attrition.R
