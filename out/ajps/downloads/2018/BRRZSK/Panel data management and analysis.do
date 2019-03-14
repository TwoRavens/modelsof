**MASTER DO FILE FOR ANALYSIS USING THE SECULAR AMERICA STUDY (SAS) PANEL

**This do file uses the original data file "original data for ajps.dta".  This data file 
**includes the original data provided to us by GfK for all of the variables used in 
**our analysis of the SAS panel data in "Putting Politics First."

**The do file does 3 things:
**(1) Creates and recodes the variables necessary for the analysis of the observed variables
**and the analysis of latent and observed variables in Mplus
**(2) Runs the analysis of observed variables from the SAS panel shown in the Supporting Information
**(3) Takes the steps necessary to set the data up for use in Mplus

**There are two steps you need to take before running this do file:

**(1) The exploratory factor analysis of religious and secular identities contained in this
**do file uses a polychoric correlation matrix, which is computed with the user-written command 
**"polychoric."  This command package needs to be installed before you run this do file.  To install 
**the polychoric command package, type "search polychoric," then click on the link for 
**"polychoric from http://staskolenikov.net/stata" and follow the directions to install.

**(2) Change the default directory in Stata to the folder on your computer where the "original data
**for ajps" data file is.

**Command to change default directory (change to folder containing data)
**cd "........."

set more 1

**Open data 
use "original data for ajps.dta", clear
	
	
**PART I: VARIABLE MANAGEMENT

**Creating new variables (if necessary)
**Recoding non-response to missing 
**Recoding variable to range from 0 to 1

**Religious attendance 
replace relattend_2=. if relattend_2<0
replace relattend_3=. if relattend_3<0
replace relattend_4=. if relattend_4<0
replace relattend_2=(relattend_2-1)/8
replace relattend_3=(relattend_3-1)/8
replace relattend_4=(relattend_4-1)/8
label values relattend* X

**Religious guidance
gen relguide_2=relguidance_2
replace relguide_2=0 if relimp_2==2
replace relguide_2=. if relguide_2<0
replace relguide_2=relguide_2/3
replace relguide_2=1-relguide_2
gen relguide_3=relguidance_3
replace relguide_3=0 if relimp_3==2
replace relguide_3=. if relguide_3<0
replace relguide_3=relguide_3/3
replace relguide_3=1-relguide_3
gen relguide_4=relguidance_4
replace relguide_4=0 if relimp_4==2
replace relguide_4=. if relguide_4<0
replace relguide_4=relguide_4/3
replace relguide_4=1-relguide_4

**Non-religious guidance
gen nonrelguide_2=nonrelguidance_2
replace nonrelguide_2=0 if nonrelimp_2==2
replace nonrelguide_2=. if nonrelguide_2<0
replace nonrelguide_2=nonrelguide_2/3
gen nonrelguide_3=nonrelguidance_3
replace nonrelguide_3=0 if nonrelimp_3==2
replace nonrelguide_3=. if nonrelguide_3<0
replace nonrelguide_3=nonrelguide_3/3
gen nonrelguide_4=nonrelguidance_4
replace nonrelguide_4=0 if nonrelimp_4==2
replace nonrelguide_4=. if nonrelguide_4<0
replace nonrelguide_4=nonrelguide_4/3

**Prayer
replace pray_2=. if pray_2<0
replace pray_3=. if pray_3<0
replace pray_4=. if pray_4<0
replace pray_2=(pray_2-1)/8
replace pray_3=(pray_3-1)/8
replace pray_4=(pray_4-1)/8
label values pray* X

**Belief in God
replace god_2=. if god_2<0
replace god_2=god_2/100
replace god_3=. if god_3<0
replace god_3=god_3/100
replace god_4=. if god_4<0
replace god_4=god_4/100

**Bible
replace bible_2=. if bible_2<0
replace bible_2=(bible_2-1)/3
replace bible_3=. if bible_3<0
replace bible_3=(bible_3-1)/3
replace bible_4=. if bible_4<0
replace bible_4=(bible_4-1)/3
label values bible_* X

**Factual evidence 
replace factual_2=. if factual_2<0
replace factual_2=(factual_2-1)/4
replace factual_2=1-factual_2
replace factual_3=. if factual_3<0
replace factual_3=(factual_3-1)/4
replace factual_3=1-factual_3
replace factual_4=. if factual_4<0
replace factual_4=(factual_4-1)/4
replace factual_4=1-factual_4
label define secdir 0 "Strongly disagree" 1 "Strongly agree"
label values factual_* secdir

**Great books of philosophy and science
replace philo_science_2=. if philo_science_2<0
replace philo_science_2=(philo_science_2-1)/4
replace philo_science_2=1-philo_science_2
replace philo_science_3=. if philo_science_3<0
replace philo_science_3=(philo_science_3-1)/4
replace philo_science_3=1-philo_science_3
replace philo_science_4=. if philo_science_4<0
replace philo_science_4=(philo_science_4-1)/4
replace philo_science_4=1-philo_science_4
label values philo_science_* secdir

**Hard to live life based on reason alone
replace reason_2=. if reason_2<0
replace reason_2=(reason_2-1)/4
replace reason_2=1-reason_2
replace reason_3=. if reason_3<0
replace reason_3=(reason_3-1)/4
replace reason_3=1-reason_3
replace reason_4=. if reason_4<0
replace reason_4=(reason_4-1)/4
replace reason_4=1-reason_4
label values reason_* secdir

**Free minds
replace freeminds_2=. if freeminds_2<0
replace freeminds_2=(freeminds_2-1)/4
replace freeminds_2=1-freeminds_2
replace freeminds_3=. if freeminds_3<0
replace freeminds_3=(freeminds_3-1)/4
replace freeminds_3=1-freeminds_3
replace freeminds_4=. if freeminds_4<0
replace freeminds_4=(freeminds_4-1)/4
replace freeminds_4=1-freeminds_4
label values freeminds_* secdir

**Values more important than evidence
replace values_2=. if values_2<0
replace values_2=(values_2-1)/4
replace values_2=1-values_2
replace values_3=. if values_3<0
replace values_3=(values_3-1)/4
replace values_3=1-values_3
replace values_4=. if values_4<0
replace values_4=(values_4-1)/4
replace values_4=1-values_4
label values values_* secdir


**Demographics
replace PPEDUC_2=(PPEDUC_2-1)/13
replace PPINCIMP_2=(PPINCIMP_2-1)/18
replace PPGENDER_2=PPGENDER_2-1
gen white2=0 if PPETHM_2~=.
replace white2=1 if PPETHM_2==1
gen south2=0 if PPREG4_2~=.
replace south2=1 if PPREG4_2==3
replace PPAGE_2=(PPAGE_2-18)/77
label values PP* X


**Party ID
gen partyid7_2=1 if partyid1_2==1 & partyid2_2==1
replace partyid7_2=2 if partyid1_2==1 & partyid2_2==2
replace partyid7_2=3 if partyid1_2>2 & partyid1_2<6 & partyid3_2==1
replace partyid7_2=4 if partyid1_2>2 & partyid1_2<6 & partyid3_2==3
replace partyid7_2=5 if partyid1_2>2 & partyid1_2<6 & partyid3_2==2
replace partyid7_2=6 if partyid1_2==2 & partyid2_2==2
replace partyid7_2=7 if partyid1_2==2 & partyid2_2==1
replace partyid7_2=(partyid7_2-1)/6
gen partyid7_3=1 if partyid1_3==1 & partyid2_3==1
replace partyid7_3=2 if partyid1_3==1 & partyid2_3==2
replace partyid7_3=3 if partyid1_3>2 & partyid1_3<6 & partyid3_3==1
replace partyid7_3=4 if partyid1_3>2 & partyid1_3<6 & partyid3_3==3
replace partyid7_3=5 if partyid1_3>2 & partyid1_3<6 & partyid3_3==2
replace partyid7_3=6 if partyid1_3==2 & partyid2_3==2
replace partyid7_3=7 if partyid1_3==2 & partyid2_3==1
replace partyid7_3=(partyid7_3-1)/6
gen partyid7_4=1 if partyid1_4==1 & partyid2_4==1
replace partyid7_4=2 if partyid1_4==1 & partyid2_4==2
replace partyid7_4=3 if partyid1_4>2 & partyid1_4<6 & partyid3_4==1
replace partyid7_4=4 if partyid1_4>2 & partyid1_4<6 & partyid3_4==3
replace partyid7_4=5 if partyid1_4>2 & partyid1_4<6 & partyid3_4==2
replace partyid7_4=6 if partyid1_4==2 & partyid2_4==2
replace partyid7_4=7 if partyid1_4==2 & partyid2_4==1
replace partyid7_4=(partyid7_4-1)/6
label define pid 0 "Strong Republican" 1 "Strong Democrat
label values partyid7* pid


**Ideology
replace ideology_2=. if ideology_2<0
replace ideology_2=ideology_2/100
replace ideology_2=1-ideology_2
replace ideology_3=. if ideology_3<0
replace ideology_3=ideology_3/100
replace ideology_3=1-ideology_3
replace ideology_4=. if ideology_4<0
replace ideology_4=ideology_4/100
replace ideology_4=1-ideology_4

**Gay Marriage
replace gaywed_2=. if gaywed_2<0
replace gaywed_2=gaywed_2/100
replace gaywed_3=. if gaywed_3<0
replace gaywed_3=gaywed_3/100
replace gaywed_4=. if gaywed_4<0
replace gaywed_4=gaywed_4/100

**Abortion
replace abortion_2=. if abortion_2<0
replace abortion_2=(abortion_2-1)/3
replace abortion_3=. if abortion_3<0
replace abortion_3=(abortion_3-1)/3
replace abortion_4=. if abortion_4<0
replace abortion_4=(abortion_4-1)/3


**Creating a "small" religious tradition measure in order to create dummy variables
**for evangelical Protestants, mainline Protestants, and Catholics (which are control 
**variables in the analysis of SAS panel data in Tables 4 and 5
label define reltradsmall 1 "Evangelical Protestant" 2 "Mainline Protestant" ///
	3 "Black Protestant" 4 "Catholic"

**Create the "reltradsmall_2" variable in 6 steps
**(1) Assigning respondents to religious traditions based on affiliation with a denomination

gen reltradsmall_2=0 if weight1_2~=.
replace reltradsmall_2=1 if whichchurch_2==5 | whichchurch_2==9 | whichchurch_2==11 | ///
	baptist_2==1 | baptist_2==5 | baptist_2>6 & baptist_2<12 | ///
	methodist_2==2 | ///
	nondenom_2<4 | ///
	lutheran_2==2 | lutheran_2==3 | ///
	presby_2>1 & presby_2<7 | ///
	christchurch_2==1 | ///
	cong_2==2 | cong_2==3 | ///
	reform_2==2
replace reltradsmall_2=2 if baptist_2==2 | methodist_2==1 |  ///
	lutheran_2==1 |	presby_2==1 | episcopal_2<3 | christchurch_2==2 | ///
	cong_2==1 | cong_2==4 | reform_2==1
replace reltradsmall_2=3 if baptist_2==3 | baptist_2==6 | methodist_2>2 & methodist_2<6 
replace reltradsmall_2=4 if relig_2==2



**(2) Assigning respondents who had ambiguous responses (e.g. something else, "other Methodist,"
**"other Lutheran") to religious traditions based on their open-ended responses when asked
**to "please specify."  Created a series of smaller religious tradition variables based
**on these open-ended responses.  Start with open-ended responses to more-general questions
**about religious preference, then move to open-ended responses to questions about specific 
**religious families (e.g. Methodist, Lutheran, Presbyterian).

**(a) Open-ended responses for the initial religion question (relig_oth_2). Variable created
**is called "reltradoth_2"

**	Responses coded as evangelical Protestant are Apostolic, Apostolic Pentecostal, 
**	Baptist, Born again Christian, Christian evangelical, Church of God, Church of Christ,
**	Evangelical Christian, Evangelical Free, Independent Baptist, Pentecostal, 
**	Seventh Day Adventist, Southern Baptist, and Holiness

**	Responses coded as mainline Protestant are Anglican and Episcopal

**	Responses coded as Catholic are Catholic, Catholic and Jewish

**	Responses coded as Ambiguous include Christian, Lutheran, Methodist, and non-denominational

**	Responses coded as Other include Wiccan, Christian Scientist, Unitarian Universalist


***(b) Open-ended responses for "whichchurch_2" -- the question "To which church or group do you 
**belong?" that was asked to all respondents identifying themselves as Protestants in the initial 
**religion question or responding "something else" and then identifying themselves as "Christians"
**in a follow-up question ("Is this a Christian religion?").  Variable created is "reltrad_which_oth_2"

**	Responses coded as evangelical Protestant are Assembly of God, Christian and Missionary Alliance,
**Church of God, Church of God (Anderson, IN), Church of the Nazarene, Community Holiness, Evangelical, 
**Evangelical Free, Faith Missionary Alliance, Full Gospel, Mennonite, Assembly of God, Born again 
**follower of Jesus Christ, Four Square, Nazarene, and Seventh Day Adventist

**	Responses coded as mainline Protestant are Church of England, Friends, congregationalist

**	Responses coded as Catholic are Catholic

**	Responses coded as Ambiguous include Christian, First Christian, conservative Lutheran, and life

**	Responses coded as Other include Eastern Catholic and Universal Unitarian


**(c) Open-ended responses for people responding "Other Lutheran" in response to lutheran_2
**Created variable called "luth_evan_2," coded 1 for people responding North American Lutheran 
**Churches (or NALC) or Association of Free Lutheran Churches (or AFLC)

**(d) Open-ended responses for people responding "Other Episcopalian or Anglican Church" in 
**response to episcopal_2.  Created variable called "epis_ml_2," coded 1 for people responding 
**"Anglican Church in the U.S.A.

**(e) Did not create any variables for open-ended responses for questions about other 
**religious families either because there were no open-ended responses or because all of the 
**open-ended responses were ambiguous (Christian, non-denominational, etc.)

**Assigning respondents to religious traditions based on open-ended responses

replace reltradsmall_2=1 if luth_evan_2==1 & reltradsmall==0

replace reltradsmall_2=2 if epis_ml_2==1 & reltradsmall==0

replace reltradsmall_2=1 if reltrad_which_oth_2==1 & reltradsmall==0
replace reltradsmall_2=2 if reltrad_which_oth_2==2 & reltradsmall==0
replace reltradsmall_2=4 if reltrad_which_oth_2==3 & reltradsmall==0

replace reltradsmall_2=1 if reltradoth_2==1 & reltradsmall==0
replace reltradsmall_2=2 if reltradoth_2==2 & reltradsmall==0
replace reltradsmall_2=4 if reltradoth_2==3 & reltradsmall==0


**(3) Creating variable for "ambiguous Protestants" -- people who identified themselves
**as Protestant or "something else," but have not yet been assigned to a religious tradition
**based on closed-ended responses about specific denominations or open-ended responses

gen ambigprot_2=0 if weight1_2~=.
replace ambigprot_2=1 if reltradsmall==0 & relig_2==1 
replace ambigprot_2=1 if reltradsmall==0 & relig_2==12 & whichchurch_2<14 
replace ambigprot_2=1 if reltradsmall==0 & relig_2==12 & reltrad_which_oth_2~=3 ///
	& reltrad_which_oth_2~=4
	
	
**(4) Recoding all Protestants (evangelical, mainline, and ambiguous) who are African American
**to black Protestant

replace reltradsmall_2=3 if reltradsmall_2>0 & reltradsmall_2<3 & PPETHM_2==2
replace reltradsmall_2=3 if ambigprot_2==1 & PPETHM_2==2


**(5) Creating an evangelical identity dummy from the religious IDs

gen evanid2=0 if weight1_2~=.
replace evanid2=1 if bornag_evan_2==1 | fund_2==1 | charism_pentecost_2==1 | traditional_2==1


**(6) Assigning non-black ambiguous Protestants to either mainline or evangelical 
**Protestant based on whether or not they have an evangelical identity

replace reltradsmall_2=1 if ambigprot_2==1 & evanid2==1
replace reltradsmall_2=2 if ambigprot_2==1 & evanid2==0

label values reltradsmall_2 reltradsmall


**Creating dummy variables for religious traditions from "reltradsmall" variable
gen evang_2=0 if weight1_2~=.
gen mlprot_2=0 if weight1_2~=.
gen catholic_2=0 if weight1_2~=.
replace evang_2=1 if reltradsmall_2==1
replace mlprot_2=1 if reltradsmall_2==2
replace catholic_2=1 if reltradsmall_2==4

**Creating secular identity count variables: 4 steps

**(1) Creating atheist and agnostic dummies based on responses to religious preference and 
**religious identity questions (i.e. atheist/agnostic in one or the other)
gen atheis2_2=0 if weight1_2~=.
replace atheis2_2=1 if relig_2==9 | atheist_2==1
gen agnos2_2=0 if weight1_2~=.
replace agnos2_2=1 if relig_2==10 | agnostic_2==1
gen atheis2_3=0 if weight1_3~=.
replace atheis2_3=1 if relig_3==9 | atheist_3==1
gen agnos2_3=0 if weight1_3~=.
replace agnos2_3=1 if relig_3==10 | agnostic_3==1
gen atheis2_4=0 if weight1_4~=.
replace atheis2_4=1 if relig_4==9 | atheist_4==1
gen agnos2_4=0 if weight1_4~=.
replace agnos2_4=1 if relig_4==10 | agnostic_4==1

**(2) Creating secular ID counts from IDs as secular, humanist, atheist, and agnostic
gen secidnum_2 =0 if weight1_2~=.
replace secidnum_2 =secidnum_2+1 if secular_2==1
replace secidnum_2 =secidnum_2+1 if humanist_2==1
replace secidnum_2 =secidnum_2+1 if atheis2_2==1
replace secidnum_2 =secidnum_2+1 if agnos2_2==1
gen secidnum_3 =0 if weight1_3~=.
replace secidnum_3 =secidnum_3+1 if secular_3==1
replace secidnum_3 =secidnum_3+1 if humanist_3==1
replace secidnum_3 =secidnum_3+1 if atheis2_3==1
replace secidnum_3 =secidnum_3+1 if agnos2_3==1
gen secidnum_4 =0 if weight1_4~=.
replace secidnum_4 =secidnum_4+1 if secular_4==1
replace secidnum_4 =secidnum_4+1 if humanist_4==1
replace secidnum_4 =secidnum_4+1 if atheis2_4==1
replace secidnum_4 =secidnum_4+1 if agnos2_4==1

**(3)Recoding secular ID counts to 3 if secular ID counts=4
replace secidnum_2=3 if secidnum_2==4
replace secidnum_3=3 if secidnum_3==4
replace secidnum_4=3 if secidnum_4==4

**(4) Recoding to range from 0 to 1
replace secidnum_2=secidnum_2/3
replace secidnum_3=secidnum_3/3
replace secidnum_4=secidnum_4/3


**Dummies for "nothing in particular"
gen nip_2=0 if weight1_2~=.
replace nip_2=1 if relig_2==11
gen nip_3=0 if weight1_3~=.
replace nip_3=1 if relig_3==11
gen nip_4=0 if weight1_4~=.
replace nip_4=1 if relig_4==11


**Talk about religion in politics, wave 1
rename relpol_1 relpol1
replace relpol1=. if relpol1<0


**Perceptions of evangelical partisanship
recode partyimage_evan_1 (1=3 "Mainly Republicans") (3=2 "Pretty even mix") ///
	(2=1 "Mainly Democrats") (-1=.), gen(evanrep1)


**Dummies for Democrats and Republicans, wave 2
gen democrat_2=0 if partyid7_2~=.
replace democrat_2=1 if partyid7_2>.5 & partyid7_2<1.01
gen repub_2=0 if partyid7_2~=.
replace repub_2=1 if partyid7_2<.5


**PART II: ANALYSIS OF OBSERVED VARIABLES

**Exploratory factor analysis of religious and secular IDs in Table A3 of SI
polychoric ecumenical_3 mainline_3 charism_pentecost_3 humanist_3 nontrad_3 secular_3 ///
	atheis2_3 fund_3 bornag_evan_3 agnos2_3 sbnr_3 [aweight=weight1_3]
display r(sum_w)
matrix r=r(R)
factormat r, n(1541) pcf
rotate, promax

**Exploratory factor analysis of secularism indicators in Table A4 of SI
factor relattend_2 relguide_2 pray_2 god_2 bible_2 factual_2 philo_science_2 reason_2 ///
	freeminds_2 values_2 nonrelguide_2 secidnum_2 [aweight=weight1_2], pcf
rotate, promax


**Analysis of overlap between passive secularism and active secularism: pp. 1-6 of Supporting Info

**(1) Creation of active and passive secularism factor scores based on confirmatory factor
**loadings in Table 1 (Generate the variable, then recode so that it ranges from 0 to 1)

gen passivesec_cfa_2=relattend_2+(1.3*relguide_2)+(1.15*pray_2)+(.89*god_2)+(.83*bible_2)
replace passivesec_cfa_2=passivesec_cfa_2/5.17

gen activesec_cfa_2=factual_2+(1.39*philo_science_2)+(-.94*reason_2) + (.99*freeminds_2) + ///
    (-.84*values_2) + (.84*nonrelguide_2) + (.75*secidnum_2)
replace activesec_cfa_2=(activesec_cfa_2+1.78)/(4.97+1.78)

**(2) Establishing cut points for defining passive secularists and active secularists based on 
**values described on pp. 1-2 of Supporting Information 

**Passive secularism cut point: factor loadings for variables multiplied by their cut point values
**Religious attendance = attends several times a year = .625
**Religious guidance = none = 1
**Prayer = at least once a week = .375
**God = value immediately above mean level of variable for full sample (mean = .197) = .2 
**Bible = Bible is a good book, but God had nothing to do with it = .6667
gen passcut=.625+(1.3*1)+(1.15*.375)+(.89*.2)+(.83*.6667)
replace passcut=passcut/5.17

**Active secularism cut point: factor loadings for variables multiplied by their cut point values
**Took secular position on 3 of 5 secular belief statements.  That equates to an average value of 
**	.6 on the statements worded in a secular direction (factual, great books of philosophy and science, 
**	and free minds) and of .4 on the statements worded in a non-secular direction (reason and values)
**Non-religious guidance = quite a bit of guidance = .6667
**Secular identity = one = .3333
gen actcut=.6+(1.39*.6)+(-.94*.4) + (.99*.6)+(-.84*.4)+(.84*.6667)+(.75*.3333)
replace actcut=(actcut+1.78)/(4.97+1.78)

**(3) Creating dummies for passive secularists and active secularists
gen passive_dummy_2=0 if weight1_2~=.
replace passive_dummy_2=1 if passivesec_cfa_2>=passcut & passivesec_cfa_2<1.01
gen active_dummy_2=0 if weight1_2~=.
replace active_dummy_2=1 if activesec_cfa_2>=actcut & activesec_cfa_2<1.01

**(4) Frequencies of passive and active secularists for general population
svyset [pw=weight1_2]
svy: tab passive_dummy_2
svy: tab active_dummy_2

**(5) Frequencies of passive and active secularists for non-religious people
svyset [pw=weight3_2]
svy: tab passive_dummy_2
svy: tab active_dummy_2

**(6) Creating low passive and active secularism cutpoints

**Low passive secularism cut point: factor loadings for variables multiplied by their cut point values
**Religious attendance = attends about once a week = .25
**Religious guidance = some=.6667
**Prayer = at least once a day = .125
**God = .1 
**Bible = Bible is the word of God (not literal) = .3333
gen lopasscut=.25+(1.3*.6667)+(1.15*.125)+(.89*.1)+(.83*.3333)
replace lopasscut=lopasscut/5.17

**Low active secularism cut point: factor loadings for variables multiplied by their cut point values
**Took non-secular position on 3 of 5 secular belief statements.  That equates to an average value of 
**	.4 on the statements worded in a secular direction (factual, great books of philosophy and science, 
**	and free minds) and of .6 on the statements worded in a non-secular direction (reason and values)
**Non-religious guidance = no guidance = 0
**Secular identity = zero = 0
gen loactcut=.4+(1.39*.4)+(-.94*.6) + (.99*.4)+(-.84*.6)+(.84*0)+(.75*0)
replace loactcut=(loactcut+1.78)/(4.97+1.78)

**(7) Creating 3-category passive and active secularism variables
label define cat3 1 "Low" 2 "Middle" 3 "High"
gen passive3_2=1 if passivesec_cfa_2<=lopasscut
replace passive3_2=3 if passive_dummy_2==1
replace passive3_2=2 if weight1_2~=. & passive3_2==.
label values passive3_2 cat3

gen active3_2=1 if activesec_cfa_2<=loactcut
replace active3_2=3 if active_dummy_2==1
replace active3_2=2 if weight1_2~=. & active3_2==.
label values active3_2 cat3

**(8) Crosstabs of 3-category active and passive secularism scales for general population
**and non-religious over-sample
svyset [pw=weight1_2]
svy: tab passive3_2 active3_2, cell
svyset [pw=weight3_2]
svy: tab passive3_2 active3_2, cell

**(9) Frequency distributions of passive secularism among active secularists and
**of active secularism among passive secularists
svyset [pw=weight1_2]
svy: tab passive3_2 if active3_2==3
svy: tab active3_2 if passive3_2==3

**Saving panel data in Stata format 
save "secam_pan_2-4.dta", replace


**PART III: PREPARING DATA FOR MPLUS

**Keeping only the necessary variables
keep caseid weight1* relattend* relguide* pray* god* bible* factual* philo* reason* ///
	freemind* values* nonrelguide* PPAGE_2 PPEDUC_2 PPGENDER_2 PPINCIMP_2 ///
	white2 south2 evang_2 mlprot_2 catholic_2 secid* nip* ideol* gaywed* abor* ///
	partyid7* relpol1 evanrep1 democrat_2 repub_2 
	
**Ordering variables
order caseid weight1* relattend* relguide* pray* god* bible* factual* philo* reason* ///
	freemind* values* nonrelguide* secid* nip* ideol* gaywed* abor* partyid7* PPEDUC_2 ///
	PPINCIMP_2 PPGENDER_2 PPAGE_2 white2 south2 evang_2 mlprot_2 catholic_2 relpol1 ///
	evanrep1 democrat_2 repub_2

save, replace

**Recoding all missing values to -99
mvencode _all, mv(-99)

**Exporting to a comma-separated delimited text file called "sas2-4.csv" 
**(No variable names and numeric values only)
export delimited using "sas2-4.csv", novarnames nolabel replace

	
	
