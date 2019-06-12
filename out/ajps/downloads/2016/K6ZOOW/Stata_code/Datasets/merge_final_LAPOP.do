***************************************************************************
* File:               merge_final_LAPOP.do
* Author:             Miguel R. Rueda
* Description:        Prepares LAPOP survey data.
* Created:            June - 10 - 2013
* Last Modified: 	  
* Language:           STATA 13.1
* Related Reference:  "Small aggregates..."
***************************************************************************
clear
*This is the location of the original renamed LAPOP files
cd ""
set more off


**Preliminary changes
use Colombia_2011.dta, clear
rename codmunicipio municipio
save Colombia_2011_aux.dta,replace

use Colombia_2010.dta, clear
rename colupm municipio
rename cct1 colfamacc


recode vb3 (801=901) (802=902) (803=903)(804=904) (805=905) (806=906) (807=907) 
save Colombia_2010_aux.dta,replace

use Colombia_2007.dta,clear
gen municipio=COLDEPA*1000+UPM
rename CP5 cp5_b
recode cp5_b (2=0) (8=.)
rename  COLCP14 cp20
keep year CLUSTER municipio UR OCUP4 IT1 OCUP1A Q10 Q11 Q1 Q2 A1 A2 A3 A4I IDIO1 IDIO2 cp5_b L1 CP6 CP7 CP8 CP9 CP13 cp20 AOJ11 ///
 L1 POL1 B10 B15 EXC7 ED COLSISBEN COLFAMACC PP1 PP2 VB2 COLVB3 COLVB25A COLVB25B COLVB25C COLVB25D COLVB26A COLVB26B VIC1 VB10 NP2 ///
 VIC2 AOJ1 WC1 WC2 WC3 B21 B47 B14 B4 PN4 PN5 ING4 IT1 R1 R3 R4 R4A R5 R6 R7 R8 R12 R14 R15
 
rename CLUSTER cluster
rename UR ur
rename OCUP4 ocup4
rename OCUP1A ocup1a
rename Q10 q10
rename Q1 q1
rename Q2 q2
rename A1 a1
rename A2 a2
rename A3 a3
rename A4I a4i
rename IDIO1 idio1
rename IDIO2 idio2
rename CP6 cp6
rename CP7 cp7
rename CP8 cp8
rename CP9 cp9
rename CP13 cp13
rename L1 l1
rename B10 b10
rename B15 b15
rename EXC7 exc7
rename ED ed
rename PP2 pp2
rename COLSISBEN colsisben
rename COLFAMACC colfamacc
rename VB2 vb2 
rename COLVB3 vb3
rename POL1 pol1
rename PP1 pp1
rename COLVB25A colvb25a 
rename COLVB25B colvb25b 
rename COLVB25C colvb25c 
rename COLVB25D colvb25d
rename COLVB26A colvb26a
rename COLVB26B colvb26b
rename IT1 it1
rename AOJ1 aoj1
rename VIC1 vic1ext
rename VIC2 vic2
rename WC1 wc1
rename WC2 wc2
rename WC3 wc3
rename Q11 q11
rename B21 b21
rename B47 b47
rename B14 b14
rename B4 b4
rename PN4 pn4
rename PN5 pn5
rename ING4 ing4
rename VB10 vb10
rename NP2 np2
rename R1 r1
rename R3 r3
rename R4 r4
rename R4A r4a
rename R5 r5
rename R6 r6
rename R7 r7
rename R8 r8
rename R12 r12
rename R14 r14
rename R15 r15
recode vb3 (1=901) (2=902) (3=903)(4=904) (5=905) (6=906) (7=907) 
save Colombia_2007_aux.dta,replace



**Appending datasets
use Colombia_2012.dta, clear

rename cct1b colfamacc 

keep municipio cluster ur tamano q5a ///
 ocup4a ocup1a q10n q1 q2 year ///
 a1 a2 a3 a4i idio1 idio2 cp5 cp6 cp6l cp7 cp7l cp8 cp8l q5b cp9 cp13 cp20 l1 prot4 q11 ocup1b1 ocup1b2 vic1exta q10e munnac ///
 prot6 b10a exc7 ed pp1 pp2 colfamacc vb1 vb2 vb3 pol1 colvb25a colvb25b colvb25c colvb25d clien1 clien2 it1 gi0 aoj11 vic1ext vic2 vic2aa vic1hogar ///
 wc1 wc2 wc3 colwc5 colwc6 colwc7 colwctiempo collt5  b21 b47 b14 b4 pn4 pn5 ing4 eff1 eff2 vb11 vb10 q12b q12c colwctiempo prot3 ///
 r1 r3 r4 r4a r5 r6 r7 r8 r12 r14 r15 
rename b47a b47
 
*Changes to income for compatibility across years
gen q10=q10n
recode q10 (4=3) (5 6 7 8=4) (9 10 11=5) (12=6) (13=7) (14=8) (15=9) (16=10)
 
append using Colombia_2011_aux.dta, keep(year cluster municipio ur q5a ocup4a ocup1b1 ocup1b2 q10e vic1exta munnac ///
 ocup1a q10 q1 q2 year a1 a2 a3 a4i idio1 idio2 cp5 q5b cp6 cp7 cp8 cp9 cp13 cp20 l1 prot4 b10a b15 pp1 pp2 it1 gi0 aoj11 vic1ext q11 prot3 ///
 exc7 ed colsisben colfamacc q5a vb1 vb2 vb3 pol1 colvb25a colvb25b colvb25c colvb25d clien1 clien2 vic1ext vic2 vic2aa vb10 q10f vic1hogar wc1 wc2 wc3 ///
 b21 b47 b14 b4 pn4 pn5 ing4 eff1 eff2 vb11 r1 r3 r4 r4a r5 r6 r7 r8 r12 r14 r15) 
 
append using Colombia_2010_aux.dta, keep(year cluster municipio ur q5a ocup4a ocup1b1 ocup1b2 q10e vic1exta munnac ///
 ocup1a q10 q1 q2 year a1 a2 a3 a4i idio1 idio2 cp5 q5b cp6 cp7 cp8 cp9 cp13 cp20 l1 prot4 b10a b15 pp1 pp2 it1 gi0 aoj11 vic1ext q11 prot3 ///
 exc7 ed colsisben colfamacc q5a vb1 vb2 vb3 pol1 colvb25a colvb25b colvb25c colvb25d clien1 clien2 vic1ext vic2 vic2aa vic1hogar vb10 q10f  ///
 wc1 wc2 wc3  b21 b47 b14 b4 pn4 pn5 ing4 eff1 eff2 vb11 r1 r3 r4 r4a r5 r6 r7 r8 r12 r14 r15)  
 
*Compatibility of question CP5
recode cp5 (1 2 3=1) (4=0), gen(cp5_b)
replace cp5_b=. if cp5>80

*Compatibility of vote buying questions 
recode clien1 (1 2=1) (3=2), gen (colvb26a)
recode clien2 (1 2=1) (3=2), gen (colvb26b)

append using Colombia_2007_aux.dta



**Post-append modifications
drop tamano


*Rural area*
recode ur (1=0) (2=1), gen(rural)
label var rural "rural area"
label define rural_l 0 "urban" 1 "rural"
label values rural rural_l
drop ur

*Alone*
recode q11 (4 6 5 = 1) (2 3 =0 ), gen(alone)
label var alone "Single"
label define alone_l 0 "Has parthner" 1 "single"
label values alone alone_l
drop q11 

*Gender*
gen female=q1-1
label var female "gender"
label define gender_l 0 "male" 1 "female"
label values female gender_l
drop q1

*Religion importance
recode q5b (4=1) (3=2) (2=3) (1=4), gen(reli)
label var reli "importance of religion"
label define reli_l 1 "not important" 2 "not very important" 3 "important" 4 "very important"
label values reli reli_l
drop q5b

*Trust in community
recode it1 (4=1) (3=2) (2=3) (1=4), gen(trust_c)
label var trust_c "how trustworthy are the people in your community?"
label define trust_c_l 1 "not trustworthy" 2 "not very trustworthy" 3 "trustworthy" 4 "very trustworthy"
label values trust_c trust_c_l
drop it1

*Age
rename q2 age
label var age "age"

*Municipality*
gen muni_code=municipio
label var muni_code "municipality code" 
replace muni_code=97001 if municipio==97001006
replace muni_code=97001 if municipio==97555

*Informed radio
recode a1 (1=4) (2=3) (4=1) (3=2), gen(iradio)
label var iradio "informed radio (Do you listen to news shows in the radio?)"
label define iradio_l 1 "never" 2 "rarely" 3 "once or twice a week" 4 "almost everyday"
label values iradio iradio_l
drop a1

*Informed TV
recode a2 (1=4) (2=3) (4=1) (3=2), gen(iTV)
label var iTV "informed TV (Do you watch the news shows on TV?)"
label define iTV_l 1 "never" 2 "rarely" 3 "once or twice a week" 4 "almost everyday"
label values iTV iTV_l
drop a2

*Informed newpaper
recode a3 (1=4) (2=3) (4=1) (3=2), gen(ipaper)
label var ipaper "informed newspaper (Do you read the newspapers?)"
label define ipaper_l 1 "never" 2 "rarely" 3 "once or twice a week" 4 "almost everyday"
label values ipaper ipaper_l
drop a3

*Informed internet
recode a4i (1=4) (2=3) (4=1) (3=2), gen(iinternet)
label var iinternet "informed internet (Do you read/listen to the news on the internet?)"
label define iinternet_l 1 "never" 2 "rarely" 3 "once or twice a week" 4 "almost everyday"
label values iinternet iinternet_l
drop a4i

*News*
recode gi0 (5=0) (4=1) (3=2) (2=3) (1=4), gen(news)
label var news "how frequently do you follow the news?"
label define news_l 0 "never" 1 "rarely" 2 "few times in a month" 3 "few times in a week" 4 "daily"
label values news news_l
drop gi0

*Crime
recode vic1ext (2=0), gen(crime)
label var crime "Have you been a victim of a crime last year?"
label define vic1ext_l 0 "no" 1 "yes" 
label values crime vic1ext_l
drop vic1ext

*Crime household
recode vic1hogar (2=0), gen(household_crime)
label var household_crime "Has other person in the household being victim of a crime?"
label values household_crime vic1ext_l
drop vic1hogar

*Family member victim of recruited 
recode colwc5 (2=0), gen(force_recruit)
label var force_recruit "Has a member of your family been recruited by an armed group by force? (armed conflict)"
label define colwc5_l 0 "no" 1 "yes" 
label values force_recruit colwc5_l
drop colwc5

*Family member victim of rape
recode colwc6 (2=0), gen(rape_f)
label var rape_f "Has a member of your family been raped or sexually assaulted? (armed conflict)"
label define colwc6_l 0 "no" 1 "yes" 
label values rape_f colwc6_l
drop colwc6

*Family member victim of torture
recode colwc7 (2=0), gen(torture_f)
label var torture_f "Has a member of your family been tortured? (armed conflict)"
label define colwc7_l 0 "no" 1 "yes" 
label values torture_f colwc7_l
drop colwc7

*Family member killed
recode wc1 (2=0), gen(killed_f)
label var killed_f "Have you lost a member of your family? (armed conflict)"
label values killed_f colwc7_l
drop wc1

recode wc2 (2=0), gen(displace_f)
label var displace_f "Has a member of your family been forced to leave his house? (armed conflict)"
label values displace_f colwc7_l
drop wc2

recode wc3 (2=0), gen(leave_c_f)
label var leave_c_f "Has a member of your family left the country? (armed conflict)"
label values leave_c_f colwc7_l
drop wc3

gen victim_c=killed_f+leave_c_f+displace_f
recode victim_c (1 2 3=1) ,gen(victim_dis)
label var victim_c "sum of killed_f displace_f leave_c_f"

gen victim_old=victim_c
replace victim_old=0 if colwctiempo==1

*Registered 
recode vb1 (3 4 2=0),gen(registered)
label var registered "are you registered to vote?"
label values registered vic1ext_l
drop vb1

*Vote Buying
recode colvb26a (2=0),gen(VB_self)
label var VB_self "have you been offered material benefits in exchange for your vote?"
label define VB_l 0 "no" 1 "yes"
label values VB_self VB_l
drop colvb26a

recode colvb26b (2=0),gen(VB_comply)
label var VB_comply "Were you influenced by the offer?"
label values VB_comply VB_l
drop colvb26b

*Threats/influence
recode colvb25a (2=0),gen(influence_self)
label var influence_self "have you been pressured into voting for a given party?"
label values influence_self VB_l
drop colvb25a 

*Threats/influence others
recode colvb25b (2=0),gen(influence_others)
label var influence_others "has anyone close to you been pressured into voting for a given party?"
label values influence_others VB_l
drop colvb25b 

*Turnout suppression self
recode colvb25c (2=0),gen(turnouts_self)
label var turnouts_self "has anyone tried to persuade or force you into not voting?"
label values turnouts_self VB_l
drop colvb25c 

*Turnout suppression others
recode colvb25d (2=0),gen(turnouts_others)
label var turnouts_others "Has anyone tried to persuade or force a close one into not voting?"
label values turnouts_others VB_l
drop colvb25d 

*Household income declined in last two years because a member of the family died or left or because the person was displaced
gen inc_family=0
gen inc_displa=0
replace inc_family=1 if q10f==6
replace inc_displa=1 if q10f==10

*Ideology
rename  l1 ideo
label var ideo "ideology (higher values right)"

*Cluster
replace cluster=cluster+256 if year==2011
replace cluster=cluster+256+226 if year==2010
replace cluster=cluster+256+226+226 if year==2007

*Unemployed 
gen unemp=cond(ocup4a==3,1,0)
replace unemp=. if ocup4a==98|ocup4a==88 

*Not interested in politics
rename pol1 disint_pol
label var disint_pol "how interested are you in politics?"
label define disint_pol_l 1 "very" 2 "some" 3 "not much" 4 "not at all"
label values disint_pol disint_pol_l

*Attempts to convince others of political views
recode pp1 (4=1)(2=3)(3=2)(1=4),generate(pol_dissem)
label var pol_dissem "do you try to convince others to vote for a given candidate/party?"
label define pol_dissem_l 1 "never" 2 "rarely" 3 "sometimes" 4 "frequently"
label values pol_dissem pol_dissem_l
drop pp1

*Work for political campaign
recode pp2 (2=0),gen(w_pol)
label var w_pol "did you work for a political campaign in the previous presidential election?"
label define w_pol_l 0 "no" 1 "yes" 
label values w_pol w_pol_l
drop pp2
 
*Help others in the community
recode cp5 (1=4) (2=3) (4=1) (3=2), gen(help_c)
label var  help_c "how often do you help people in your community to solve a problem?"
label define help_c_l 1 "never" 2 "once or twice a year" 3 "once or twice a month" 4 "once a week"
label values help_c help_c_l
replace help_c=. if year==2007
drop cp5

*Help others in the community (discrete)
rename cp5_b help_c_d
label var help_c_d "Have you helped your community to solve a problem?"
label define help_c_dl 1 "yes" 0 "no"
label values help_c_d help_c_dl

*Wealth

gen onecar=.
replace onecar=1 if r5==1
replace onecar=0 if r5 !=1
       
gen nocar=.
replace nocar=1 if r5==0
replace nocar=0 if r5 !=0
       
gen twocar=.
replace twocar=1 if r5==2
replace twocar=0 if r5 !=2

gen threecar=.
replace threecar=1 if r5==3
replace threecar=0 if r5 !=3

pca r1 r3 r4 r4a onecar twocar threecar nocar r6 r7 r8 r12 r14 r15


predict wealth, score
centile wealth, c(0, 20)
gen firstq = (wealth >= r(c_1) & wealth < r(c_2))
centile wealth, c(21, 40)
gen secondq = (wealth >= r(c_1) & wealth < r(c_2))
centile wealth, c(41, 60)
gen thirdq = (wealth >= r(c_1) & wealth < r(c_2))
centile wealth, c(61, 80)
gen fourthq = (wealth >= r(c_1) & wealth <= r(c_2))
centile wealth, c(81, 100)
gen fifthq = (wealth >= r(c_1) & wealth <= r(c_2))
centile wealth, c(61, 90)
 
gen quintile =.
replace quintile = 5 if fifthq == 1
replace quintile = 4 if fourthq == 1
replace quintile = 3 if thirdq == 1
replace quintile = 2 if secondq == 1
replace quintile = 1 if firstq == 1 

label var quintile "Wealth quintile"
 
*Trust in the judiciary
rename b10a trust_ju
label var trust_ju "do you trust the judiciary?"

order muni_code year
sort muni_code year
save survey_dat.dta,replace

*Non discrete manipulation
recode clien1 (3=0)(2=1)(1=2),gen(nd_VB)
label var nd_VB "With what frequency have you been offered material benefits in exchange for your vote?"
label define nd_VB_l 0 "never" 1 "rarely" 2 "frequently"
label values nd_VB nd_VB_l
drop clien1


*Insecurity in neighborhood
rename aoj11 insecurity
label var insecurity "how safe do you feel in this neighborhood?"
label define insecurity_l 1 "very safe" 2 "safe" 3 "not very safe" 4 "very unsafe"
label values insecurity insecurity_l


*Factor analysis participation in groups
factor cp6 cp7 cp8 cp9 cp13 cp20,pcf
predict factor_g
label var factor_g "scores for factor 1 participation in groups"

*Filling missings in leaders for those that answered in groups in 2012
recode cp6l (1=0) (2=1), gen(leader_rel)
label define leader_l 0 "not leader" 1 "leader" 
label values leader_rel leader_l
replace leader_rel=0 if (year==2012&cp6!=.&cp6l==.)|(year==2012&cp6!=.&cp6l==.c)

recode cp7l (1=0) (2=1), gen(leader_pa)
label define leader_pa 0 "not leader" 1 "leader" 
label values leader_pa leader_l
replace leader_pa=0 if (year==2012&cp7!=.&cp7l==.)|(year==2012&cp7!=.&cp7l==.c)

recode cp8l (1=0) (2=1), gen(leader_com)
label define leader_com 0 "not leader" 1 "leader" 
label values leader_com leader_l
replace leader_com=0 if (year==2012&cp8!=.&cp8l==.)|(year==2012&cp8!=.&cp8l==.c)

*Factor analysis informed
factor iradio iTV ipaper iinternet,pcf
predict factor_in
label var factor_in  "scores for factor 1 information"
*Corruption
recode exc7 (1=4)(2=3)(3=2)(4=1),gen(corrupt)
label var corrupt "corruption among public officials is:"
label define corrupt_l 1 "Very uncommon" 2 "Uncommon" 3 "Common" 4 "Very common"
label values corrupt corrupt_l
drop exc7

*Crime 
gen crime2=0 
replace vic1ext=1 if crime==1&vic1ext==.
replace crime2=1 if (vic2<11&vic1ext==1)
replace crime2=. if crime==.

*Political efficacy and attitudes

rename b21 trust_parties
rename b47 trust_elections
rename b14 trust_nat_gov
rename b4 proud_pol_sys
rename pn4 diss_democracy
rename pn5 non_democracy


*Generating indicators of associational life of the municipality
gen o_reli=0 if cp6!=.
replace o_reli=1 if cp6==1|cp6==2|cp6==3
label var o_reli "dummy religious organization"
label define o_reli_l 1 "yes" 0 "No"
label values o_reli o_reli_l

recode cp6 (4=0) (3=1)(2=2)(1=3),gen(c_reli)
label var o_reli "participation religious organization"


gen o_pare=0 if cp7!=.
replace o_pare=1 if cp7==1|cp7==2|cp7==3
label var o_pare "dummy parents association"
label define o_pare_l 1 "yes" 0 "No"
label values o_pare o_pare_l

recode cp7 (4=0)(3=1)(2=2)(1=3),gen(c_pare)
label var c_pare "participation parents organization"

gen o_comm=0 if cp8!=.
replace o_comm=1 if cp8==1|cp8==2|cp8==3
label var o_comm "dummy community association"
label define o_comm_l 1 "yes" 0 "No"
label values o_comm o_comm_l

recode cp8 (4=0)(3=1)(2=2)(1=3),gen(c_comm)
label var c_comm "participation community organization"

gen o_prof=0 if cp9!=.
replace o_prof=1 if cp9==1|cp9==2|cp9==3
label var o_prof "dummy professional association"
label define o_prof_l 1 "yes" 0 "No"
label values o_prof o_prof_l

recode cp9 (4=0)(3=1)(2=2)(1=3),gen(c_prof)
label var c_prof "participation prof organization"

gen o_pol=0 if cp13!=.
replace o_pol=1 if cp13==1|cp13==2|cp13==3
label var o_pol "dummy political organization"
label define o_pol_l 1 "yes" 0 "No"
label values o_pol o_pol_l

recode cp13 (4=0)(3=1)(2=2)(1=3),gen(c_pol)
label var c_pol "participation political organization"

recode cp20 (4=0)(3=1)(2=2)(1=3),gen(c_mom)
label var c_mom "participation womens organization"


recode c_mom (1 2 3 =1),gen(o_mom)
label var o_mom "dummy womens organization"
label define o_mom_l 1 "yes" 0 "No"
label values o_mom o_mom_l


gen sum_o=0
replace sum_o=o_reli+o_pare+o_comm+o_pol+o_mom+o_prof
replace sum_o=1 if sum_o>=1
label var sum_o "dummy belongs to an organization"
label define sum_o_l 1 "Member" 0 "Not a member"
label values sum_o sum_o_l

gen participa=o_reli+o_pare+o_comm+o_pol+o_mom+o_prof
label var participa "number of organizations respondent belongs to"

gen participa_nopol=o_reli+o_pare+o_comm+o_mom+o_prof
label var participa "number of organizations respondent belongs to (no politics)"

gen participa12=o_reli+o_pare+o_comm
label var participa12 "number of organizations respondent belongs to, out of 3 2012"
replace participa12=. if year!=2012

gen leader=0 
replace leader=1 if (leader_rel==1|leader_pa==1|leader_com==1)
replace leader=. if (leader_rel==.&leader_pa==.&leader_com==.)

factor o_reli o_pare o_comm o_pol o_prof o_mom,pcf
predict factor_asso

label var factor_asso "Factor participation"


*Members of household that are not children (above 13 years old)

gen old_household=q12c-q12b


save survey_dat.dta,replace

*Creating panel dataset
gen ones=1
collapse (sum) VB_self o_reli o_pare o_comm o_pol o_mom o_prof ones sum_o (mean) trust_parties trust_elections trust_nat_gov proud_pol_sys  diss_democracy non_democracy eff1 eff2, by(muni_code year)

*Creating shares of respondents
foreach var in VB_self o_reli o_pare o_comm o_pol o_prof o_mom sum_o{
gen `var'_s=`var'/ones
}

gen asso=(o_reli_s+o_pare_s+o_comm_s+o_pol_s+o_prof_s+o_mom_s)/6

factor o_reli_s o_pare_s o_comm_s o_pol_s o_prof_s o_mom_s,pcf
predict factor_asso

gen lones=log(ones)
gen lsum_o=log(sum_o)

*drop if year==2007
save panel_lapop.dta,replace

collapse (mean) lones lsum_o VB_self_s sum_o_s sum_o VB_self asso o_reli_s o_pare_s o_comm_s o_pol_s o_prof_s o_mom_s factor_asso trust_parties trust_elections trust_nat_gov proud_pol_sys  diss_democracy non_democracy eff1 eff2, by(muni_code)
save cross_lapop.dta,replace


***Merging with aggregates dataset
**Merging with non election controls
use controls.dta,replace
keep year muni_code nbi_i lnbi_i lown_resources own_resources armed_actor coca_area lpopulation closeness_CG

*Remember I am adding 1 so that the survey data is matched to the lag of the aggregate controls.
replace year=year+1 
save non_election.dta,replace


*Merging with election controls
use controls.dta,replace
keep year muni_code lpob_mesa lsize l4lsize closeness_CG margin_index2
tsset muni_code year, yearly
gen llpob_mesa=l.lpob_mesa
gen ll4lsize=l.l4lsize

rename llpob_mesa llpob_mesa_n
rename lpob_mesa llpob_mesa_l
rename l4lsize l2lsize_l
rename ll4lsize l2lsize_n

gen llpob_mesa_r=llpob_mesa_l
gen llsize_r=l2lsize_l
gen l2margin_index2_l=L4.margin_index2
gen l2margin_index2_n=L5.margin_index2
gen lmargin_index2_r=l2margin_index2_l

replace year=year+1
drop if year!=2012
drop lsize
save election2012.dta,replace

use controls.dta,replace
keep year muni_code lpob_mesa lsize l4lsize closeness_CG margin_index2
tsset muni_code year, yearly
gen l3lpobmesa=l3.lpob_mesa
gen l7lsize=l7.lsize
gen l3lsize=l3.lsize


rename l3lpobmesa llpob_mesa_l
rename l7lsize l2lsize_l
rename l3lsize llsize_l
rename lpob_mesa llpob_mesa_n
rename l4lsize l2lsize_n

gen llpob_mesa_r=llpob_mesa_n
gen llsize_r=llsize_l
gen lmargin_index2_l=l3.margin_index2
gen l2margin_index2_n=l4.margin_index2
gen l2margin_index2_l=l7.margin_index2
gen lmargin_index2_r=lmargin_index2_l

replace year=year+1
drop lsize 
drop if year!=2011
save election2011.dta,replace


use controls.dta,replace
keep year muni_code lpob_mesa lsize l4lsize closeness_CG margin_index2
tsset muni_code year, yearly
gen llpob_mesa=l.lpob_mesa
gen llsize=l.lsize
gen l5lsize=l5.lsize

rename lpob_mesa llpob_mesa_l
rename llpob_mesa llpob_mesa_n
rename lsize llsize_l
rename llsize llsize_n
rename l4lsize l2lsize_l
rename l5lsize l2lsize_n

gen l2margin_index2_n=l5.margin_index2
gen l2margin_index2_l=l4.margin_index2
gen lmargin_index2_l=margin_index2
gen lmargin_index2_n=l.margin_index2
gen lmargin_index2_r=lmargin_index2_l
gen llpob_mesa_r=llpob_mesa_l
gen llsize_r=llsize_l

drop if year!=2007
replace year=2010
save election2010.dta,replace

use controls.dta,replace
keep year muni_code lpob_mesa lsize l4lsize closeness_CG margin_index2
tsset muni_code year, yearly

gen llpob_mesa=l.lpob_mesa
gen l3lpob_mesa=l3.lpob_mesa
gen l3lsize=l3.lsize
gen l7lsize=l7.lsize


rename lpob_mesa llpob_mesa_n
rename lsize llsize_n
rename l3lpob_mesa llpob_mesa_l
rename l3lsize llsize_l
rename l4lsize l2lsize_n
rename l7lsize l2lsize_l

gen l2margin_index2_n=l4.margin_index2
gen l2margin_index2_l=l7.margin_index2
gen lmargin_index2_l=l3.margin_index2
gen lmargin_index2_n=margin_index2
gen lmargin_index2_r=lmargin_index2_n
gen llpob_mesa_r=llpob_mesa_n
gen llsize_r=llsize_n

drop if year~=2006
replace year=2007
drop llpob_mesa

save election2007.dta, replace

append using election2010.dta
append using election2011.dta
append using election2012.dta

label var llsize_n "average electorate size in most recent national election"
label var llsize_l "average electorate size in most recent local election"
label var l2lsize_n "average electorate size in second most recent national election"
label var l2lsize_l "average electorate size in second most recent local election"
label var llsize_r "average electorate size in most recent election"

label var llpob_mesa_l "voting age population per polling station in most recent local election"
label var llpob_mesa_n "voting age population per polling station in most recent national election"
label var llpob_mesa_r "voting age population per polling station in most recent election"

label var lmargin_index2_l "average margin of victory in most recent local election"
label var lmargin_index2_n "average margin of victory in most recent national election"
label var lmargin_index2_r "average margin of victory in most recent election"
label var l2margin_index2_l "average margin of victory in second most recent local election"
label var l2margin_index2_n "average margin of victory in second most recent national election"


gen l2margin_index2_av=(l2margin_index2_n+l2margin_index2_l)/2
gen l2lsize_av=log((exp(l2lsize_n)+exp(l2lsize_l))/2)
gen llpob_mesa_av=log(exp(llpob_mesa_l)+exp(llpob_mesa_n)/2)

gen l2size_av=exp(l2lsize_av)
gen lpob_mesa_av=exp(llpob_mesa_av)


save election_all.dta,replace


use survey_dat.dta,clear
merge m:1 muni_code year using non_election.dta
drop if _merge==2
drop _merge
merge m:1 muni_code year using election_all.dta
drop if _merge==2
drop _merge

gen population=exp(lpopulation)
*Data in levels to use in summary stats

*Moved from place of birth
gen migra=0 if year!=2007
replace migra=1 if muni_code!=munnac&munnac!=.


*Creating number of people in each group per municipality per year
foreach var in reli pare comm pol mom prof{
gen aux_`var'_vb=0 if o_`var'!=.
replace aux_`var'_vb=1 if VB_self==1&o_`var'==1

bysort year muni_code: egen muni_`var'=sum(o_`var')
bysort year muni_code: egen muni_`var'_vb=sum(aux_`var'_vb)
*Taking out the voter in question
replace muni_`var'_vb=muni_`var'_vb-1 if VB_self==1&o_`var'==1
replace muni_`var'=muni_`var'-1 if  o_`var'==1

gen fr_vb_`var'_mun=muni_`var'_vb/muni_`var'
drop aux_`var'_vb muni_`var' muni_`var'_vb
}
label var fr_vb_reli_mun "fraction of respondents in religious group who were offered bribes"
label var fr_vb_pare_mun "fraction of respondents in parents group who were offered bribes"
label var fr_vb_comm_mun "fraction of respondents in community group who were offered bribes"
label var fr_vb_mom_mun "fraction of respondents in mothers group who were offered bribes"
label var fr_vb_prof_mun "fraction of respondents in professional group who were offered bribes"
label var fr_vb_pol_mun "fraction of respondents in political group who were offered bribes"

gen fr_vb_gr_mun_nw=(o_reli*fr_vb_reli_mun+o_pare*fr_vb_pare_mun+o_comm*fr_vb_comm_mun+o_mom*fr_vb_mom_mun+o_prof*fr_vb_prof_mun+o_pol*fr_vb_pol_mun)/(o_reli+o_mom+o_comm+o_prof+o_pol+o_pare)  	
replace fr_vb_gr_mun_nw=0 if sum_o==0
label var fr_vb_gr_mun_nw "Average fraction of respondents in group that respondent belongs to who were offered bribes"

gen fr_vb_gr_mun_nw2=(c_reli*fr_vb_reli_mun+c_pare*fr_vb_pare_mun+c_comm*fr_vb_comm_mun+c_mom*fr_vb_mom_mun+c_prof*fr_vb_prof_mun+c_pol*fr_vb_pol_mun)/(c_reli+c_mom+c_comm+c_prof+c_pol+c_pare)  	
replace fr_vb_gr_mun_nw2=0 if sum_o==0
label var fr_vb_gr_mun_nw2 "Average fraction of respondents in group that respondent belongs to who were offered bribes c"

*Fraction of people in each group who have party preferences
foreach var in reli pare comm pol mom prof{
gen aux_`var'_p=0 if o_`var'!=.
replace aux_`var'_p=1 if vb10==1&o_`var'==1

bysort year muni_code: egen muni_`var'=sum(o_`var')
bysort year muni_code: egen muni_`var'_p=sum(aux_`var'_p)

*Taking out the voter in question
replace muni_`var'_p=muni_`var'_p-1 if vb10==1&o_`var'==1
replace muni_`var'=muni_`var'-1 if  o_`var'==1

gen fr_p_`var'_mun=muni_`var'_p/muni_`var'
drop aux_`var'_p muni_`var' muni_`var'_p
}
label var fr_p_reli_mun "fraction of respondents in religious group who have party preferences"
label var fr_p_pare_mun "fraction of respondents in parents group who have party preferences"
label var fr_p_comm_mun "fraction of respondents in community group who have party preferences"
label var fr_p_mom_mun "fraction of respondents in mothers group who have party preferences"
label var fr_p_prof_mun "fraction of respondents in professional who have party preferences"
label var fr_p_pol_mun "fraction of respondents in political group who have party preferences"
*Creating number of people in each group with same partisan preferences

replace vb11=799 if vb11==77

foreach var in reli pare comm pol mom prof{

gen fr_`var'_muni=0
gen o_`var'_aux=o_`var'
replace o_`var'_aux=0 if vb11==.|vb11==.c
bysort muni_code year: egen muni_`var'=sum(o_`var'_aux)

*Fraction of each party in each group
forvalue i=798(1)827{
	gen aux_`var'_`i'=0 if o_`var'!=.
	replace aux_`var'_`i'=1 if vb11==`i'&o_`var'==1
	bysort muni_code year : egen muni_`var'_`i'=sum(aux_`var'_`i')
	gen fr_`var'_`i'_mun=muni_`var'_`i'/muni_`var'
	replace fr_`var'_muni=fr_`var'_muni+fr_`var'_`i'_mun*(vb11==`i')
	drop fr_`var'_`i'_mun muni_`var'_`i' aux_`var'_`i'
	} 
drop  o_`var'_aux
	}

save survey_dat.dta,replace

collapse (mean) fr_reli_muni fr_pare_muni fr_comm_muni fr_mom_muni fr_prof_muni fr_pol_muni, by(muni_code year vb11)
drop if vb11==.|vb==.c     
foreach var in reli pare comm pol mom prof{
replace fr_`var'_muni=fr_`var'_muni^2
bysort muni_code year : egen het_`var'_muni=sum(fr_`var'_muni)
replace het_`var'_muni=. if fr_`var'_muni==.
}
collapse (mean) het_reli_muni het_pare_muni het_comm_muni het_mom_muni het_prof_muni het_pol_muni, by(muni_code year)
drop if year==2007
save het_party_group.dta,replace

use survey_dat.dta,clear

merge m:1 muni_code year using het_party_group.dta
foreach var in reli pare comm pol mom prof{
drop fr_`var'_muni muni_`var'
}


gen het_gr_mun_nw2=(c_mom*het_mom_muni+c_reli*het_reli_muni+c_pare*het_pare_muni+c_comm*het_comm_muni+c_prof*het_prof_muni+c_pol*het_pol_muni)/(c_mom+c_reli+c_pare+c_comm+c_prof+c_pol)  	
label var het_gr_mun_nw "Index of party preference group information not weighted by fraction with preferences"

gen het_gr_mun_nw1=(o_mom*het_mom_muni+o_reli*het_reli_muni+o_pare*het_pare_muni+o_comm*het_comm_muni+o_prof*het_prof_muni+o_pol*het_pol_muni)/(o_mom+o_reli+o_pare+o_comm+o_prof+o_pol)  	
label var het_gr_mun_nw1 "Index of party preference group information not weighted by fraction with preferences"
replace het_gr_mun_nw1=0 if sum_o==0 


gen p_gr_mun=(c_mom*fr_p_mom_mun+c_reli*fr_p_reli_mun+c_pare*fr_p_pare_mun+c_comm*fr_p_comm_mun+c_prof*fr_p_comm_mun+c_pol*fr_p_pol_mun)/(c_mom+c_reli+c_pare+c_comm+c_prof+c_pol)  	
replace p_gr_mun=0 if sum_o==0 
label var p_gr_mun "average fraction of group with partisan preferences weighted by participation"

gen p_gr_mun2=(o_mom*het_mom_muni*fr_p_mom_mun+o_reli*het_reli_muni*fr_p_reli_mun+o_pare*het_pare_muni*fr_p_pare_mun+o_comm*het_comm_muni*fr_p_comm_mun+o_prof*het_prof_muni*fr_p_prof_mun+o_pol*het_pol_muni*fr_p_pol_mun)/(o_mom*het_mom_muni+o_reli*het_reli_muni+o_pare*het_pare_muni+o_comm*het_comm_muni+o_prof*het_comm_muni+o_pol*het_pol_muni)  	
replace p_gr_mun2=0 if sum_o==0 
label var p_gr_mun2 "average fraction of group with partisan preferences weighted by participation and heterogeneity"

gen p_gr_mun3=(o_mom*fr_p_mom_mun+o_reli*fr_p_reli_mun+o_pare*fr_p_pare_mun+o_comm*fr_p_comm_mun+o_prof*fr_p_prof_mun+o_pol*fr_p_pol_mun)/(o_mom+o_reli+o_pare+o_comm+o_prof+o_pol)  	
replace p_gr_mun3=0 if sum_o==0 
label var p_gr_mun3 "average fraction of group with partisan preferences  o"
*Standard error in ideological self-placement by group in municipality

foreach var in reli comm prof pare pol mom{
bysort muni_code year o_`var': egen sd_ideo_`var'=sd(ideo)
bysort muni_code year o_`var': egen min_ideo_`var'=min(ideo)
bysort muni_code year o_`var': egen max_ideo_`var'=max(ideo)
gen range_`var'=max_ideo_`var'-min_ideo_`var' 
drop min_ideo_`var' max_ideo_`var'
}
gen sd_group=(c_mom*sd_ideo_mom+c_pare*sd_ideo_pare+c_comm*sd_ideo_comm+c_pol*sd_ideo_pol+c_prof*sd_ideo_prof)/(c_mom+c_reli+c_pare+c_comm+c_prof+c_pol)
label var sd_group "weighted average of standard deviation of ideology of the groups"
replace sd_group=0 if sum_o==0 

gen sd_group2=(o_mom*sd_ideo_mom+o_pare*sd_ideo_pare+o_comm*sd_ideo_comm+o_pol*sd_ideo_pol+o_prof*sd_ideo_prof)/(o_mom+o_reli+o_pare+o_comm+o_prof+o_pol)
label var sd_group2 "weighted average of standard deviation of ideology of the groups o"
replace sd_group2=0 if sum_o==0 

gen range_group=(c_mom*range_mom+c_pare*range_pare+c_comm*range_comm+c_pol*range_pol+c_prof*range_prof)/(c_mom+c_reli+c_pare+c_comm+c_prof+c_pol)
label var range_group "weighted average of ranges of ideology of the groups"
replace range_group=0 if sum_o==0

gen range_group2=(o_mom*range_mom+o_pare*range_pare+o_comm*range_comm+o_pol*range_pol+o_prof*range_prof)/(o_mom+o_reli+o_pare+o_comm+o_prof+o_pol)
label var range_group2 "weighted average of ranges of ideology of the groups o"
replace range_group2=0 if sum_o==0

replace lnbi_i=exp(lnbi_i)
gen supporter=vb10
recode supporter (2=0)
gen int_pol=-1*disint_pol

keep VB_self age female registered ed q10 reli news trust_c disint_pol help_c rural llpob_mesa_av lown_resources lnbi_i lpopulation supporter vb10 w_pol ///
l2margin_index2_av l2lsize_av l2size_av armed_actor muni_code turnouts_self year corrupt insecurity crime diss_democracy factor_i trust_c trust_j factor_g ///
llpob_mesa_av lpob_mesa_av llpob_mesa_l population nbi_i llpob_mesa_n lown_resources lnbi_i lpopulation l2margin_index2_l l2margin_index2_n l2margin_index2_av l2lsize_l ///
l2lsize_n l2lsize_av pol_dissem int_pol
label var int_pol "Interest in politics"
label var l2size_av "average electorate size in the second most recent local and national elections"
label var year "year of interview"
label var diss_democracy "how satisfied are you with how democracy works in Colombia?"
label var vb10 "do you support a political party?"
label var ed "Number of years in school"
label var q10 "income level (increasing in income)"
label var lnbi_i "poverty index lagged"
label var armed_actor "guerrillas or paramilitaries operate in municipality, CERAC"
label var lown_resources "local revenues % of total revenues lagged, DNP"
label var l2margin_index2_av "average margin of victory in the second most recent local and national election"
label var l2lsize_av "ln of average electorate size in the second most recent local and national elections"
label var llpob_mesa_av "ln of average population older than 20 per polling station in most recent local and national election"
label var supporter "political party supporter"
label define diss_democracy_l 1 "very satisfied " 2 "satisfied" 3 "not very satisfied" 4 "not satisfied at all"
label values diss_democracy diss_democracy_l

save final_LAPOP.dta,replace

erase election_all.dta
erase cross_lapop.dta
erase election2007.dta
erase election2010.dta
erase election2011.dta
erase election2012.dta
erase het_party_group.dta
erase panel_lapop.dta
erase survey_dat.dta
erase non_election.dta
erase Colombia_2007_aux.dta
erase Colombia_2010_aux.dta
erase Colombia_2011_aux.dta


sort muni_code year turnouts_self corrupt insecurity crime diss_democracy supporter factor_i trust_ju registered trust_c reli help_c ed VB_self q10 vb10 female disint_pol w_pol pol_dissem reli news factor_g age rural llpob_mesa_av llpob_mesa_l llpob_mesa_n lown_resources lnbi_i lpopulation l2margin_index2_l l2margin_index2_n l2margin_index2_av l2lsize_l l2lsize_n l2lsize_av armed_actor
*Database to export to Matlab misclassification model
keep muni_code year turnouts_self corrupt insecurity crime diss_democracy supporter factor_i trust_ju registered trust_c reli help_c ed VB_self q10 vb10 female disint_pol w_pol pol_dissem reli news factor_g age rural llpob_mesa_av llpob_mesa_l llpob_mesa_n lown_resources lnbi_i lpopulation l2margin_index2_l l2margin_index2_n l2margin_index2_av l2lsize_l l2lsize_n l2lsize_av armed_actor
keep if year~=2007
export excel using "panel_matlab_LAPOP.xls", sheet("panel_logit") sheetreplace firstrow(variables) nola



