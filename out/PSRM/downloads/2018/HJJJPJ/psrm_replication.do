** In the following, data and results are replicated in the order of their
** appearance in the main text and appendices, by numbers of figures and
** tables. Replications per figures or tables are indicated by four
** asterisks (start) and four slashes (end), 
** analyses were run with Stata Version 15 and the ados spost13_ado, outreg2 and log2html

log using psrm_replication.smcl, replace

*copy this do file and following 4 datasets into wd:
*** psrm_election
*** psrm_1912vs1919
*** psrm_rcvdata
*** psrm_magnitudes

**** description of vars by dataset

*** psrm_election
** data on elections, candidacies, alliances
** data covers all 59 parties/political labels of candidates ever running in any Reichstag election
** each of them has a unique "single party code" (e.g. spd = 43) - though not all
** of them are "parties" - non-party candidates running under a political label
** (e.g. as = non-partisan anti-semite) are not analysed below
** these codes appear in vars [partyname]_single
** analyses in article address only 6 major parties (spd, dfp, nlp, z, drp, dkp)
** for convenience (lest tables in text explode), the various peasant parties
** (e.g. bbb) and ethnic parties (e.g. polen) have been grouped into two categories
** (peasant and ethnic), and second set of "short party codes" has been given to
** these and remaining parties (e.g. spd = 1); these codes appear in vars [partyname]_cr
** data: obs are elections by rounds by districts
** vars are:
*  lp: legislative period (8-13)
*  round: round of voting (number 1: first round of general election, 2: runoff,
*   3: first round of first by-election, 4: runoff, 5: first round if second
*   by-election, 6: runoff, etc.) - in following analyses only round 1 is addressed
*  rb: smallest administrative unit above municipal level (string)
*  provinz: Prussian province or state (string)
*  staat: state (string)
*  idpsrm: ID of elected candidate (=id of MP in other datasets, numeric)
*  mandate_single: party of elected candidate (numeric party code)
*  pop: population of district (number)
*  variables "as" to "z", "peasant" and "ethnic": always value 1, only used for calling vars below in loops
*  partyname abbreviation: from "as" to "z", followed by:
*   _single: single party code (numeric)
*   _cr: short party code 
*   _su: party supports other party's candidate: single party code of supported party
*   _sucr: party supports other party's candidate: short party codes of supported party
*   _re: candidate receiving support from at least one other party: yes/no (1/0)
*   _a: votes attained by party's candidate: number (>0)
*   _ac: party running in district: yes/no (1/0), missing if runoff and no participation in runoff

*** psrm_1912vs1919
** data on candidates and MPs in 1912 and 1919 parliaments/elections
** obs are MPs in 1912 term and candidates in 1919 term - some MPs of 1912 are also candidates in 1919
** vars are:
*  idpsrm: ID of MP as of 1912 (number, missing for obs that were not MPs in 1912)
*  mandate1912end: Weimar-era name of party whose member MPs was in 1912 (string)
*  kandidatennummer: ID of candidate as of 1919 (number, missing for obs that were not candidate in 1919)
*  listenplaz: list rank as of 1919; if running on several lists of one party: best list rank
*  party: Weimar-era name of party whose member candidate was in 1919 (string)
*  electedever: mandate gained at any point in time during 1919 term
*  electedmand: mandate gained as immediate result of 1919 election, including renounced mandates due to double- or trebble candidacies
****table 1: summary statistics of electoral alliances, runoffs, enps

*** psrm_rcvdata
** data on individual-level roll call vote (rcv) results in Reichstag 1890-1914
** obs are MPs in each first rcv held in each plenary session
** vars are:
*  rcv_id: ID of rcv (number)
*  rcvdate: date of rcv (date)
*  idpsrm: ID of MP (number)
*  lp: legislative period (values 8 - 13 for number of lp)
*  high_p: vote-share attained by MP in respective election (percent)
*  pfleader: MP being party or party group leader yes/no (1/0)
*  pfleaderspd: MP being party or party group leader of SPD yes/no (1/0)
*  spd: MP being SPD MP yes/no (1/0)
*  m_group: party of MP for 6 major parties (numeric, 1-5, 7 - missing is for MPs of other/no party)
*  alliance: MP elected within electoral alliance yes/no (1/0)
*  oppose: MP voted against party line yes/no (1/0)
*  rice_rcv: Rice score for MP's party per rcv (numeric, 0-1)
*  splitcount: number of party within MP's alliance with party line different from MP's party line
*  rcvbig6first: running number of MP within his party by rcv (1-113)

*** psrm_magnitude
** descriptive statistics on district magnitudes and population for 29 countries pre- and post-switch
** obs are electoral systems of independent European countries, British Dominions
** (excl. South-Africa) and the US in place in 1922 (if no switch) or a time of
** first introduction of PR
** vars are:
*  country: name of country (string)
*  procedures: way of switch (no/decree/parliamentary, string)
*  electoralsystem: class of electoral system post-switch (string)
*  yearofreform: year of decision on electoral reform (if any, if not: year addressed by data, string)
*  populationtotal: population in millions (number)
*  seatsbefore: number of parliamentary mandates pre-switch
*  seatsafter: number of parliamentary mandates post-switch
*  districtspost_allocation: number of districts for cross-party seat allocation post-switch
*  districtspost_nomination: number of districts for intra-party nomoniation post-switch
*  magavg_allocation: average magnitude allocation districts post-switch
*  magavg_nomination: average magnitude nomination districts post-switch
*  magmedian_nomination: median magnitude nomination districts post-switch
*  magmin_nomination: minimum magnitude nomination districts post-switch
*  magmax_nomination: maximum magnitude nomination districts post-switch
*  popavg_allocation: average population per allocation district post-switch
*  popavg_nomination: average population per nomination district post-switch


***** replication starts from here

***table 1, entries on alliances
use psrm_election, clear
*count number of supported candidates per district (
egen alldiscount = rowtotal(as_re - z_re)
*make dummy on at least one supported candidate in district
gen anyall = 0
replace anyall = 1 if alldiscount >0 
*count districts with at least one supported candidate, by round and election
bysort round election_year: egen alldistotal = total(anyall)
*count candidates with at least one supporting party other than own (= alliance),
*  by round and election
bysort round election_year: egen alldiscototal = total(alldiscount)

*account for alliance formed only in 2nd round, it is mentioned in main text
*  that there were few (as is the case)
gen newall = 0 if round == 2
sort reibel_nummer election_year round
by reibel_nummer election_year: replace newall = 1 if round ==2 & anyall == 1 & anyall[_n-1] == 0
tab election_year newall if round ==2 & election_year > 1887

*share of districts with alliance over all districts, by election
gen all_share = alldistotal * 100 / 397

***table 1, entries on enp
*calculate enp at district, regional and national levels
**district level
foreach var of varlist as_a - z_a{
gen `var'p = `var'  / valid_a
replace `var'p = `var'p ^2
}
egen ensum = rowtotal(as_ap - z_ap)
*enpd - this is variable for district-level enp
gen enpd = 1 / ensum
replace enpd = . if enpd >7 // delete enpd for districts with missing data on votes
sum enpd if election_year >=1887 & round ==1, detail

sort election_year round reibel_nummer
by election_year round: gen yearrounderster = _n
by election_year round: egen enpdmean = mean(enpd)
*enpdmean - this is variable for mean district-level enp, as used in article
replace enpdmean = round(enpdmean,0.1)
replace enpd = round(1 / ensum,0.1)
drop as_ap - z_ap ensum

** define districts for regional level
** (prussian provinces, bavarian Regierungsbezirke, states with at least 4 districts)
gen regional = provinz if staat == "K_Preussen" & provinz != "Rb_Sigmaringen"
replace regional = rb if staat == "K_Bayern"
replace regional = staat if staat == "G_Baden"
replace regional = staat if staat == "G_Hessen"
replace regional = staat if staat == "G_Mecklenburg-Schwerin"
replace regional = staat if staat == "K_Sachsen"
replace regional = staat if staat == "K_Wuerttemberg"
replace regional = staat if staat == "Rl_Elsass"
replace regional = "other" if regional == ""
tab regional

*calculate regional-level votes, vote-shares and enp
foreach var of varlist valid_a as_a - z_a{
bysort election_year round regional: egen `var'r = total(`var') if valid_a >20 & valid_a != .
}

foreach var of varlist as_a - z_a{
bysort election_year round regional: gen `var'rp = `var'r / valid_ar
replace `var'rp = `var'rp ^2
}
egen ensum = rowtotal(as_arp - z_arp)
*enpr - regional-level enp
gen enpr = round(1/ ensum,0.1)
sum enpr if round ==1
sort election_year round regional reibel_nummer
by election_year round regional: gen yearroundregionerster = _n 
*enprmean  - mean regional-level enp, as used in article
by election_year round regional: egen enprmean_stub = mean(enpr) if yearroundregionerster == 1 & regional != "other"
by election_year round: egen enprmean = max(enprmean_stub)

drop valid_ar as_ar - z_ar as_arp - z_arp ensum enprmean_stub 

*national level enp
foreach var of varlist valid_a as_a - z_a{
bysort election_year round: egen `var'n = total(`var') if valid_a >20 & valid_a != .
}

foreach var of varlist as_a - z_a{
bysort election_year round: gen `var'np = `var'n / valid_an
replace `var'np = `var'np ^2
}
egen ensum = rowtotal(as_anp - z_anp)
*enpn - national level enp, as used in article
gen enpn = round(1/ ensum,0.1)

*list results as they appear in table 1
sort lp reibel_nummer round
by lp: gen lpfirst = _n

***table 1, as in in article
list election_year alldistotal all_share alldiscototal enpdmean enprmean enpn  if lpfirst == 1 & election_year > 1887 & election_year != .

//// (end table 1)

****model A-1 (appendix A), figure 1 (main text), figure A-1 (appendix A)

***model A-1, data preparation
*get percentages of party votes at district level
foreach var of varlist as_a - z_a{
gen `var'p = `var' * 100 / valid_a
}

*identify vote-share main non-SPD-candidate
*sum percentages for small peasant and ethnic parties (this is for convenience
* only and does not affect who is main on-spd candidate, see 12 lines below)
egen peasant_ap = rowtotal(bbb_ap bbf_ap bbfs_ap dbb_ap divbauern_ap hessthuerbb_ap)
egen peasant_ac2 = rowtotal(bbb_ac bbf_ac bbfs_ac dbb_ac divbauern_ac hessthuerbb_ac)
replace peasant_ap = . if peasant_ap == 0
egen ethnic_ap = rowtotal(daenen_ap eautonomisten_ap eklerikale_ap eprotestler_ap litauer_ap lothringer_ap masurvp_ap elz_ap polen_ap )
replace ethnic_ap = . if ethnic_ap == 0
egen ethnic_ac2 = rowtotal(daenen_ac eautonomisten_ac eklerikale_ac eprotestler_ac litauer_ac lothringer_ac masurvp_ac elz_ac polen_ac )

*recent vote-share of main non-spd candidate
egen mainnonspd_ap = rowmax(ethnic_ap peasant_ap as_ap bdbr_ap - cs_ap demvg_ap - dhp_ap divkons_ap - dvp_ap eld_ap elv_ap fvg_ap - handwerkerpn_ap hrechtsp_ap lgsv_ap llp_ap lmpb_ap lrp_ap - lv_ap mittp_ap - pkons_ap pps_ap psh_ap undeclared_ap - z_ap)
replace mainnonspd_ap = . if mainnonspd_ap == 0
*sums above do not affect results of main non-spd candidate
list peasant_ap ethnic_ap peasant_ac2 ethnic_ac2 if mainnonspd == 1 & peasant_ap == 1 | mainnonspd == 1 & ethnic_ap ==1

*dummy for main non-spd candidate as concerns votes in recent election
gen mainnonspd = .
foreach var of varlist spd dvp dfp fvg divlib nlp z drp dtkp cs dhp mittp divkons bdl peasant ds drefp ethnic{
replace mainnonspd = `var'_cr if `var'_ap == mainnonspd_ap & mainnonspd_ap != .
}
label values mainnonspd partycrlabel

*dummy on support for main non-spd candidate as concerns votes in recent election
gen mainsupport = 0
*following: there could be >1 supported party - here: only support for most successful
foreach var of varlist spd dvp dfp fvg divlib nlp z drp dtkp cs dhp mittp divkons bdl peasant ds drefp ethnic{
replace mainsupport = 1 if `var'_sucr == mainnonspd & `var'_sucr != `var'_cr
}

*vote-share for each party in first round of previous election
*spd_apprev is previous spd vote-hsare
foreach var of varlist spd dvp dfp fvg divlib nlp z drp dtkp cs dhp mittp divkons bdl peasant ds drefp ethnic{
sort round reibel_nummer election_year
by round reibel_nummer: gen `var'_apprev_stub = `var'_ap[_n-1] if round ==1
bysort reibel_nummer election_year: egen `var'_apprev = max(`var'_apprev_stub)
drop `var'_apprev_stub
}

*incumbent
gen incumbent = 0
sort round reibel_nummer election_year 
by round reibel_nummer: replace incumbent = 1 if idpsrm == idpsrm[_n-1]

*make string variable on region a numeric one
encode regional, gen(regionalnum)


***model A-1, calculation
/* Notes on variables used: 
DV: 
 propensity of a non-SPD candidate being supported by at least one other
 party, due to
IV (on x-axis in figure 1): 
 spd_apprev: vote-share of SPD in first round of previous election
Controls:
 -incumbent: candidate is also incumbent
 -i.mainnonspd: party of main non-spd candidate (dummy battery), 
 -i.election_year: dummy battery for elections 1893, 1898, 1903, 1907, 1912 with
 1890 as reference category
 -geographical region (regionalnum)
 -in first round and excluding single-district states that make up joint artifical region ("if round == 1 & regionalnum != 28")
*/
logit mainsupport c.spd_apprev i.incumbent i.mainnonspd i.election_year i.regionalnum if round ==1 & regionalnum != 28
**summary of results (table A-1 in appendix A)
# delimit ;
outreg2
 using "results/psrm_appendix_a.doc",
 word replace label
 ctitle("Model I")
 sideway bdec(2) sdec(3) e(r2_p chi2 ll_0 N_clust) alpha(0.001, 0.01, 0.05)
;
# delimit cr

label define predlabel 3 "DFP" 6 "NLP" 7 "DRP" 8 "DKP" 11 "Z"
label values mainnonspd predlabel

**predicted probabilities from A-1 for figure 1: calculation
cap drop m4_*
mgen, at(spd_apprev=(0(5)80) mainnonspd=(3 6 7 8 11) incumbent=(0 1)) stub(m4_) pr(1)
label values m4_mainnonspd predlabel

***figure 1 - predicted probabilites on alliances in place for incumbents 
*** along SPD strength, by parties
# delimit ;
twoway
 (rarea m4_ll m4_ul m4_spd_ap, fcolor(gs12) lwidth(thin))
 (line m4_pr m4_spd_ap, sort lcolor(gs0) lpattern(longdash) lwidth(medthin))
 if m4_incumbent ==1,
 ytitle(Alliance in support of candidate) 
 xtitle(Previous share of SPD in district) xline(50, lwidth(thin))
 by(, note(., size(zero))) by(, legend(off))
 scheme(s1mono)
 by(m4_mainnonspd, rows(1)) subtitle(, nobox)
;
# delimit cr
graph export results/psrm_figure1.png, as(png) replace

** figure A-1 - predictions for non-incumbents; non-incumbency reinforces claims in
** main text, if anything
# delimit ;
twoway
 (rarea m4_ll m4_ul m4_spd_ap, fcolor(gs12) lwidth(thin))
 (line m4_pr m4_spd_ap, sort lcolor(gs0) lpattern(longdash) lwidth(medthin))
 if m4_incumbent ==0,
 ytitle(Alliance in support of candidate) 
 xtitle(Previous share of SPD in district) xline(50, lwidth(thin))
 by(, note(., size(zero))) by(, legend(off))
 scheme(s1mono)
 by(m4_mainnonspd, rows(1)) subtitle(, nobox)
;
# delimit cr
graph export results/psrm_figurea1.png, as(png) replace

****save dataset as for using some newly generated variables for appendix C below
save results/psrm_appendix_b, replace

*** save predictions in separate dataset
keep  m4_pr - m4_mainnonspd
keep if m4_pr1 != .
save results/psrm_appendix_a_predictions, replace

////(end model A-1, figure 1, figure A-1)

****table 2
use psrm_election, clear
keep if election_year > 1887 & election_year != .

bysort election_year round: gen lprounderster = _n

***get percentages of party votes at district level
foreach var of varlist as_a - z_a{
gen `var'p = `var' * 100 / valid_a
}

*calculate counts of districts for 6 major parties 
foreach var of varlist spd_ap dfp_ap nlp_ap drp_ap dtkp_ap z_ap{
bysort election_year round: egen `var'c = count(`var')
}

**counts of district where running by election
list election_year spd_apc dfp_apc nlp_apc drp_apc dtkp_apc z_apc if round ==1 & lprounderster ==1 

*calculate share of districts with candidature
foreach var of varlist spd_ap dfp_ap nlp_ap drp_ap dtkp_ap z_ap{
gen `var'cp = `var'c * 100 / 397
}

*calculate mean of share of districts with candidature
foreach var of varlist spd_ap dfp_ap nlp_ap drp_ap dtkp_ap z_ap{
egen `var'cmean = mean(`var'cp) if lprounderster ==1 & round ==1
egen `var'csd = sd(`var'cp) if lprounderster ==1 & round ==1
}

***first row of table 2
list  spd_apcmean spd_apcsd dfp_apcmean dfp_apcsd nlp_apcmean nlp_apcsd drp_apcmean drp_apcsd dtkp_apcmean dtkp_apcsd z_apcmean z_apcsd if round ==1 & lprounderster ==1 & election_year  == 1890

*count alliances in support of each of six major parties
*variables "[party]_su" give code of party supported by [party]
*codes of parties of interest: DFP = 9, DRP = 16, DKP = 18, NLP = 39, SPD = 43,
** Z = 47
*counts of parties in support for district candidates: spd
foreach var of varlist as_su - z_su{
gen `var'_stub = `var' 
replace `var'_stub = . if `var' != 43
}
egen spd_reco = rownonmiss(as_su_stub - z_su_stub)
tab spd_reco, mi
replace spd_reco = . if spd_ac != 1 //set count to missing if not running
replace spd_reco = . if round != 1
foreach var of varlist as_su - z_su{
drop `var'_stub
}
tab spd_reco election_year if round ==1
egen spd_recomean = mean(spd_reco)
egen spd_recosd = sd(spd_reco)
sum spd_recomean spd_recosd
*counts of parties in support for district candidates: DFP
foreach var of varlist as_su - z_su{
gen `var'_stub = `var' 
replace `var'_stub = . if `var' != 9
}
egen dfp_reco = rownonmiss(as_su_stub - z_su_stub)
tab dfp_reco, mi
replace dfp_reco = . if dfp_ac != 1 //set count to missing if not running
replace dfp_reco = . if round != 1
foreach var of varlist as_su - z_su{
drop `var'_stub
}
sum dfp_reco 
egen dfp_recomean = mean(dfp_reco)
egen dfp_recosd = sd(dfp_reco)
sum dfp_recomean dfp_recosd
*counts of parties in support for district candidates: NLP
foreach var of varlist as_su - z_su{
gen `var'_stub = `var' 
replace `var'_stub = . if `var' != 39
}
egen nlp_reco = rownonmiss(as_su_stub - z_su_stub)
tab nlp_reco, mi
replace nlp_reco = . if nlp_ac != 1 //set count to missing if not running
replace nlp_reco = . if round != 1
foreach var of varlist as_su - z_su{
drop `var'_stub
}
sum nlp_reco 
egen nlp_recomean = mean(nlp_reco)
egen nlp_recosd = sd(nlp_reco)
sum nlp_recomean nlp_recosd
*counts of parties in support for district candidates: DRP
foreach var of varlist as_su - z_su{
gen `var'_stub = `var' 
replace `var'_stub = . if `var' != 16
}
egen drp_reco = rownonmiss(as_su_stub - z_su_stub)
tab drp_reco, mi
replace drp_reco = . if drp_ac != 1 //set count to missing if not running
replace drp_reco = . if round != 1
foreach var of varlist as_su - z_su{
drop `var'_stub
}
sum drp_reco 
egen drp_recomean = mean(drp_reco)
egen drp_recosd = sd(drp_reco)
sum drp_recomean drp_recosd
*counts of parties in support for district candidates: DKP
foreach var of varlist as_su - z_su{
gen `var'_stub = `var' 
replace `var'_stub = . if `var' != 18
}
egen dtkp_reco = rownonmiss(as_su_stub - z_su_stub)
tab dtkp_reco, mi
replace dtkp_reco = . if dtkp_ac != 1 //set count to missing if not running
replace dtkp_reco = . if round != 1
foreach var of varlist as_su - z_su{
drop `var'_stub
}
sum dtkp_reco 
egen dtkp_recomean = mean(dtkp_reco)
egen dtkp_recosd = sd(dtkp_reco)
sum dtkp_recomean dtkp_recosd
*counts of parties in support for district candidates: Z
foreach var of varlist as_su - z_su{
gen `var'_stub = `var' 
replace `var'_stub = . if `var' != 47
}
egen z_reco = rownonmiss(as_su_stub - z_su_stub)
tab z_reco, mi
replace z_reco = . if z_ac != 1 //set count to missing if not running
replace z_reco = . if round != 1
foreach var of varlist as_su - z_su{
drop `var'_stub
}
sum z_reco 
egen z_recomean = mean(z_reco)
egen z_recosd = sd(z_reco)
sum z_recomean z_recosd

***second row of table 2
list spd_recomean spd_recosd dfp_recomean dfp_recosd nlp_recomean nlp_recosd drp_recomean drp_recosd dtkp_recomean dtkp_recosd z_recomean z_recosd if lprounderster == 1 & round == 1 & election_year == 1893

***counts of parties in support for elected district candidates
*SPD
gen spd_recom = spd_reco
replace spd_recom= . if mandate_single != 43
tab spd_recom spd_reco, mi
egen spd_recomeanm = mean(spd_recom)
egen spd_recosdm = sd(spd_recom)
*DFP
gen dfp_recom = dfp_reco
replace dfp_recom= . if mandate_single != 9
tab dfp_recom dfp_reco, mi
egen dfp_recomeanm = mean(dfp_recom)
egen dfp_recosdm = sd(dfp_recom)
*NLP
gen nlp_recom = nlp_reco
replace nlp_recom= . if mandate_single != 39
tab nlp_recom nlp_reco, mi
egen nlp_recomeanm = mean(nlp_recom)
egen nlp_recosdm = sd(nlp_recom)
*DRP
gen drp_recom = drp_reco
replace drp_recom= . if mandate_single != 16
tab drp_recom drp_reco, mi
egen drp_recomeanm = mean(drp_recom)
egen drp_recosdm = sd(drp_recom)
*DKP
gen dtkp_recom = dtkp_reco
replace dtkp_recom= . if mandate_single != 18
tab dtkp_recom dtkp_reco, mi
egen dtkp_recomeanm = mean(dtkp_recom)
egen dtkp_recosdm = sd(dtkp_recom)
*Z
gen z_recom = z_reco
replace z_recom= . if mandate_single != 47
tab z_recom z_reco, mi
egen z_recomeanm = mean(z_recom)
egen z_recosdm = sd(z_recom)

***third row of table 2
list spd_recomeanm spd_recosdm dfp_recomeanm dfp_recosdm nlp_recomeanm nlp_recosdm drp_recomeanm drp_recosdm dtkp_recomeanm dtkp_recosdm z_recomeanm z_recosdm if lprounderster == 1 & round == 1 & election_year == 1893

***nation-wide vote-shares
*valid_anat: count of all valid votes per election for FIRST round only
bysort election_year round: egen valid_anat = total(valid_a)
by election_year: gen valid_anatstub = valid_anat if round ==1
by election_year: egen valid_anatstub2 = max(valid_anatstub)
replace valid_anat = valid_anatstub2
drop valid_anatstub valid_anatstub2

*[party_single]_anat: count of votes for candidates of each of six major party_simple
*per election for FIRST round only
foreach var of varlist spd dfp drp dtkp nlp z{
bysort election_year round: egen `var'_anat = total(`var'_a)
by election_year: gen `var'_anatstub = `var'_anat if round ==1
by election_year: egen `var'_anatstub2 = max(`var'_anatstub)
replace `var'_anat = `var'_anatstub2
drop `var'_anatstub `var'_anatstub2
}

*[party_single]_anat: share (percent) of votes for candidates of each of six major party_simple
*per election for FIRST round only
foreach var of varlist spd dfp drp dtkp nlp z{
gen `var'_pnat = round(`var'_anat *100 / valid_anat,0.1)
}

*variable on average national vote-shares 1890-1912
foreach var of varlist spd dfp drp dtkp nlp z{
egen `var'_pnatmean = mean(`var'_pnat) if lprounderster ==1 & round ==1
egen `var'_pnatsd = sd(`var'_pnat) if lprounderster ==1 & round ==1
}

***fourth row in table 2
list spd_pnatmean spd_pnatsd dfp_pnatmean dfp_pnatsd nlp_pnatmean nlp_pnatsd drp_pnatmean drp_pnatsd dtkp_pnatmean dtkp_pnatsd z_pnatmean z_pnatsd if lprounderster == 1 & round == 1 & election_year == 1903



***party-wise seat-shares
keep if round == 1

gen counter = 1
*SPD
bysort election_year: egen spd_m_stub = total(counter) if mandate_single == 43
by election_year: egen spd_mco = max(spd_m_stub)
replace spd_mco = round(spd_mco * 100 / 397,0.1)
replace spd_mco = . if lprounderster != 1
drop spd_m_stub
egen spd_mcmean = mean(spd_mco)
egen spd_mcsd = sd(spd_mco)
sum spd_mcmean spd_mcsd spd_mco
*DFP
bysort election_year: egen dfp_m_stub = total(counter) if mandate_single == 9
by election_year: egen dfp_mco = max(dfp_m_stub)
replace dfp_mco = round(dfp_mco * 100 / 397,0.1)
replace dfp_mco = . if lprounderster != 1
drop dfp_m_stub
egen dfp_mcmean = mean(dfp_mco)
egen dfp_mcsd = sd(dfp_mco)
sum dfp_mcmean dfp_mcsd dfp_mco
*NLP
bysort election_year: egen nlp_m_stub = total(counter) if mandate_single == 39
by election_year: egen nlp_mco = max(nlp_m_stub)
replace nlp_mco = round(nlp_mco * 100 / 397,0.1)
replace nlp_mco = . if lprounderster != 1
drop nlp_m_stub
egen nlp_mcmean = mean(nlp_mco)
egen nlp_mcsd = sd(nlp_mco)
sum nlp_mcmean nlp_mcsd nlp_mco
*DRP
bysort election_year: egen drp_m_stub = total(counter) if mandate_single == 16
by election_year: egen drp_mco = max(drp_m_stub)
replace drp_mco = round(drp_mco * 100 / 397,0.1)
replace drp_mco = . if lprounderster != 1
drop drp_m_stub
egen drp_mcmean = mean(drp_mco)
egen drp_mcsd = sd(drp_mco)
sum drp_mcmean drp_mcsd drp_mco
*DKP
bysort election_year: egen dtkp_m_stub = total(counter) if mandate_single == 18
by election_year: egen dtkp_mco = max(dtkp_m_stub)
replace dtkp_mco = round(dtkp_mco * 100 / 397,0.1)
replace dtkp_mco = . if lprounderster != 1
drop dtkp_m_stub
egen dtkp_mcmean = mean(dtkp_mco)
egen dtkp_mcsd = sd(dtkp_mco)
sum dtkp_mcmean dtkp_mcsd dtkp_mco
*Z
bysort election_year: egen z_m_stub = total(counter) if mandate_single == 47
by election_year: egen z_mco = max(z_m_stub)
replace z_mco = round(z_mco * 100 / 397,0.1)
replace z_mco = . if lprounderster != 1
drop z_m_stub
egen z_mcmean = mean(z_mco)
egen z_mcsd = sd(z_mco)
sum z_mcmean z_mcsd z_mco

***fifth row of table 2
list spd_mcmean spd_mcsd dfp_mcmean dfp_mcsd nlp_mcmean nlp_mcsd drp_mcmean drp_mcsd dtkp_mcmean dtkp_mcsd z_mcmean z_mcsd if lprounderster == 1 & round == 1 & election_year == 1903

***population-adapted party-wise seat-shares
bysort election_year: egen poptotal = total(pop)
gen popshare = pop * 100 / poptotal
*SPD
gen spd_mpop = popshare if mandate_single == 43
by election_year: egen spd_mpopc = total(spd_mpop)
replace spd_mpopc = . if lprounderster != 1
egen spd_mpopcmean = mean(spd_mpopc)
egen spd_mpopcsd = sd(spd_mpopc)
*DFP
gen dfp_mpop = popshare if mandate_single == 9
by election_year: egen dfp_mpopc = total(dfp_mpop)
replace dfp_mpopc = . if lprounderster != 1
egen dfp_mpopcmean = mean(dfp_mpopc)
egen dfp_mpopcsd = sd(dfp_mpopc)
*NLP
gen nlp_mpop = popshare if mandate_single == 39
by election_year: egen nlp_mpopc = total(nlp_mpop)
replace nlp_mpopc = . if lprounderster != 1
egen nlp_mpopcmean = mean(nlp_mpopc)
egen nlp_mpopcsd = sd(nlp_mpopc)
*DRP
gen drp_mpop = popshare if mandate_single == 16
by election_year: egen drp_mpopc = total(drp_mpop)
replace drp_mpopc = . if lprounderster != 1
egen drp_mpopcmean = mean(drp_mpopc)
egen drp_mpopcsd = sd(drp_mpopc)
*DKP
gen dtkp_mpop = popshare if mandate_single == 18
by election_year: egen dtkp_mpopc = total(dtkp_mpop)
replace dtkp_mpopc = . if lprounderster != 1
egen dtkp_mpopcmean = mean(dtkp_mpopc)
egen dtkp_mpopcsd = sd(dtkp_mpopc)
*Z
gen z_mpop = popshare if mandate_single == 47
by election_year: egen z_mpopc = total(z_mpop)
replace z_mpopc = . if lprounderster != 1
egen z_mpopcmean = mean(z_mpopc)
egen z_mpopcsd = sd(z_mpopc)

***sixth row in table 2
list spd_mpopcmean spd_mpopcsd dfp_mpopcmean dfp_mpopcsd nlp_mpopcmean nlp_mpopcsd drp_mpopcmean drp_mpopcsd dtkp_mpopcmean dtkp_mpopcsd z_mpopcmean z_mpopcsd if lprounderster == 1 & round == 1 & election_year == 1903


****table 2 - assembling rows to table
sort lprounderster election_year
foreach var of varlist spd dfp nlp drp dtkp z{
gen `var'_mean = `var'_apcmean in 1
gen `var'_sd = `var'_apcsd in 1
replace `var'_mean = `var'_recomean in 2
replace `var'_sd = `var'_recosd in 2
replace `var'_mean = `var'_recomeanm in 3
replace `var'_sd = `var'_recosdm in 3
replace `var'_mean = `var'_pnatmean in 4
replace `var'_sd = `var'_pnatsd in 4
replace `var'_mean = `var'_mcmean in 5
replace `var'_sd = `var'_mcsd in 5
replace `var'_mean = `var'_mpopcmean in 6
replace `var'_sd = `var'_mpopcsd in 6
}

***prepare identifier of measure for later summary as in table 2
gen measure = "Avg. % of districts contested + sd" in 1
replace measure = "Avg. parties in support + sd " in 2
replace measure = "Avg. parties in support if mandate + sd" in 3
replace measure = "Avg. national voteshare + sd" in 4
replace measure = "Avg. seatshare + sd" in 5
replace measure = "Population-adapted avg. seatshare + sd" in 6

****table 2 - finished
list measure spd_mean  - z_sd if spd_mean != .

//// (end table 2)

*save upper part of table D-1 (calculated along calculation of table 2) as dataset
list spd_pnat dfp_pnat nlp_pnat drp_pnat dtkp_pnat z_pnat if lprounderster == 1 & round == 1 & election_year == 1912
list spd_mco  dfp_mco nlp_mco drp_mco dtkp_mco z_mco if lprounderster == 1 & round == 1 & election_year == 1912
keep if lprounderster == 1 & round == 1 & election_year == 1912
keep spd_pnat dfp_pnat nlp_pnat drp_pnat dtkp_pnat z_pnat spd_mco  dfp_mco nlp_mco drp_mco dtkp_mco z_mco

save results/psrm_tabled1, replace
**


****Appendix B (model B-1, figure B-1)
* start with dataset as used and documented for model 1 above
use results/psrm_appendix_b, clear

gen fifty = 0.5

*previous vote-share for main non-spd candidate of previous election
gen mainnonspd_apprev_stub = .
sort round reibel_nummer election_year 
foreach var of varlist spd dvp dfp fvg divlib nlp z drp dtkp cs dhp mittp divkons bdl peasant ds drefp ethnic{
by round reibel_nummer: replace mainnonspd_apprev_stub = `var'_ap[_n-1] if `var'_ap == mainnonspd_ap & round ==1
}
bysort reibel_nummer election_year: egen mainnonspd_apprev = max(mainnonspd_apprev_stub)
drop mainnonspd_apprev_stub


****Model B-1: beta regression on vote-share of main Non-SPD candidate
/*
DV:
mainnonspd_aps - recent vote-share of main Non-SPD candidate 
IV:
mainsupport: main Non-SPD candidate being supporty by other party (dummy)
Controls:
* spd_ap: recent vote-share of SPD (percent)
* (interaction mainsupport*spd_ap)
* incumbent: main Non-SPD candidate is also incumbent (dummy)
* mainnonspd_apprev: previous vote-share of main Non-SPD candidate (percent)
* (interaction incumbent*mainnonspd_apprev)
* i.mainnonspd: dummy battery on party of main Non-SPD candidate
* i.region: dummy battery on regions (see above, appendix A)
* i.election_year: dummy battery on election
* only first round of interest (if round == 1)
*/

gen mainnonspd_aps = mainnonspd_ap/100

***Model B-1: beta regression
betareg mainnonspd_aps i.mainsupport##c.spd_ap i.incumbent##c.mainnonspd_apprev i.mainnonspd i.election_year i.regionalnum if round ==1 

**table B-1
# delimit ;
outreg2
 using "results/psrm_appendix_b.doc",
 word replace label
 ctitle("V - Vote-shares")
 sideway bdec(2) sdec(3) e(r2_p chi2 ll_0 N_clust) alpha(0.001, 0.01, 0.05)
;
# delimit cr

cap drop m5_*
mgen, atmeans at(spd_ap=(0(5)50) mainsupport=(0 1) incumbent=(1) mainnonspd_apprev=(25 35 45 55)) stub(m5_)

**** Figure B-1
label define prevsharelabel 20 "Previous share: 20%" 25 "Previous share: 25%" 30 "Previous share: 30%" 35 "Previous share: 35%"  40 "Previous share: 40%" 45 "Previous share: 45%" 50 "Previous share: 50%" 55 "Previous share: 55%" 
label value m5_mainnonspd_apprev prevsharelabel
# delimit ;
twoway
 (line fifty m5_spd_ap, sort lpattern(longdash) lpattern(longdash) lwidth(thin))
 (rarea m5_ll m5_ul m5_spd_ap if m5_mainsupport == 0, fcolor(gs8) lcolor(gs0) lwidth(thin))
 (line m5_margin m5_spd_ap if m5_mainsupport == 0, sort lcolor(gs0) lpattern(longdash) lwidth(thin))
 (rarea m5_ll m5_ul m5_spd_ap if m5_mainsupport == 1, sort fcolor(gs12) lcolor(gs0) lwidth(vthin))
 (line m5_margin m5_spd_ap if m5_mainsupport == 1, sort lpattern(longdash) lwidth(thin))
 , ytitle(Predicted share of Non-SPD incumbent)
 yline(0.33, lwidth(thin) lpattern(dash) noextend)
 xtitle(Recent share of SPD in district)
 xlabel(0 10 20 30 40 50)
 by(, note(., size(zero)))
 by(, legend(on)) legend(order(2 "Sole party" 4 "In alliance")) 
 scheme(s1mono)
 by(m5_mainnonspd_apprev, rows(1))
 subtitle(, nobox size(small))
;
# delimit cr

graph export results/psrm_figure_b1.png, as(png) replace

keep if m5_margin != .
keep m5_margin - m5_mainsupport
save results/psrm_appendix_b_predictions, replace

//// (end appendix B)


****figure 2: line graph of party Rice scores (rice_rcv), by six major parties
use psrm_rcvdata, clear

# delimit ;
twoway
 (line rice_rcv rcvdate, sort)
 if m_group < 8 & m_group != 6 
 , ytitle(Rice score)
 xtitle(Date of RCV)
 xlabel(-25385 "1890" -23559 "1895" -21733 "1900" -19907 "1905" -18080 "1910" -16619 "1914", labsize(small))
 by(, note(., size(zero))) scheme(s1mono) by(m_group) subtitle(, nobox)
;
# delimit cr

graph export results/psrm_figure2.png, replace


label define mgrouplabel 1 "DFP" 2 "DRP" 3 "DKP" 4 "NLP" 5 "Z" 6 "unaff." 7 "SPD" 8 "DRefp" 9 "DS" 10 "DVP" 11 "FVg" 12 "Poles" 13 "WVg" 14 "SAG" 15 "ELZ" 16 "DtF" 66 "LV" 69 "LGSV"
label values m_group mgrouplabel
tab m_group

//// (end figure 2)


****Appendix C: figures 3 and 4 (main text), models C-1 - C-7, figure C-1, table C-1
use psrm_rcvdata, clear

*table C-1: observations not used
gen major6regular = 1
replace major6regular = 2 if (m_group == 6 | m_group > 7) & decisive_round >=3
replace major6regular = 3 if (m_group <6 | m_group == 7) & decisive_round >=3
replace major6regular = 4 if (m_group <6 | m_group == 7) & decisive_round <3
label define major6regularlabel 1 "small party, by-election" 2 "small party" 3 "major6, by-election" 4 "major6"
label values major6regular major6regularlabel
label variable nperses "Nth RCV per session"

tab nperses major6regular

*keep only observations for 6 major parties and for MPs elected at general election and for first six rcvs per session
keep if (m_group <6 | m_group == 7) & decisive_round <3 & high_p != . & nperses <2

*ModelS C-1, C-2, C-3 (propensity to oppose party line for party leaders vs MPs)
/*
DV:
 propensity of MP to oppose his party line in each RCV (dummy: 0 = not opposed, 1 = oppose)
IV:
 pfleader: party leader (1) or not (0)
Controls:
 -pfleaderspd: interaction of being party leader (pfleader = 1) * being SPD
 MP (m_group == 7)
 -alliance: having received support by at least one other party in previous
 election (1) or not (0)
 -high_p: vote-share received in first round of voting in district (percent)
 -lp: legislative term, (8 - 13), includes squared term
 -spd: dummy on SPD MPs (1) vs. Bourgeois MPs (0) - used for model C-1
 -m_group: major partliamentary party group - used for model C-2 and C-3
 -idpsrm: clustering along MPs
*/

***model C-1: all MPs
logit oppose pfleader pfleaderspd alliance high_p c.lp##c.lp spd, vce(cluster idpsrm)

*write summary of model C-1 into doc, this appears in table C-2
#delimit cr
# delimit ;
outreg2
 using "results/psrm_appendix_c_c1toc3.doc",
 word replace label
 ctitle("C-1 - All MP")
 sideway bdec(2) sdec(3) e(r2_p chi2 ll_0 N_clust) alpha(0.001, 0.01, 0.05)
;
# delimit cr

cap drop a1_pr1 - a1_spd
mgen, atmeans at(lp=(8(1)13) pfleader = (0 1) pfleaderspd = (0 1) spd = (0 1) alliance = (0 1)) stub(a1_) pr(1)
label define spdlabel 0 "Bourgeois" 1 "SPD"
label define alliancelabel 0 "no alliance" 1 "in alliance"
label define pfleaderlabel 0 "backbencher" 1 "party leader"
label values a1_spd spdlabel
label values a1_alliance alliancelabel
label values a1_pfleader pfleaderlabel
label values a1_pfleaderspd pfleaderlabel

****Figure C-1
#delimit ;
twoway
 (rarea a1_ll1 a1_ul1 a1_lp if a1_pfleader == 0, fcolor(gs8) lcolor(gs0) lwidth(vthin) sort)
 (rarea a1_ll1 a1_ul1 a1_lp if a1_pfleader == 1, fcolor(gs12) lcolor(gs0) lwidth(vthin) sort)
 (rarea a1_ll1 a1_ul1 a1_lp if a1_pfleader == 0, fcolor(gs8) lcolor(gs0) lwidth(vthin) sort)
 (rarea a1_ll1 a1_ul1 a1_lp if a1_pfleader == 1 & a1_pfleaderspd == 1, fcolor(gs12) lcolor(gs0) lwidth(vthin) sort)
 (line a1_pr1 a1_lp if a1_pfleader == 0, lcolor(gs0) lwidth(thin) lpattern(longdash) sort)
 (line a1_pr1 a1_lp if a1_pfleader == 1, lcolor(gs0)lwidth(thin) lpattern(longdash) sort)
 (line a1_pr1 a1_lp if a1_pfleader == 0, lcolor(gs0) lwidth(thin) lpattern(longdash) sort)
 (line a1_pr1 a1_lp if a1_pfleader == 1 & a1_pfleaderspd == 1, lcolor(gs0) lwidth(thin) lpattern(longdash) sort)
 if a1_spd == 1 & a1_pfleaderspd == 1 | a1_spd == 0 & a1_pfleaderspd == 0
 , 
 xtitle(LP) xlabel(8 "1890" 9 "1893" 10 "1898" 11 "1903" 12 "1907" 13 "1912", labsize(small))
 ytitle(Predicted probability of MP opposing his party line)
 by(, note(., size(zero)))
 legend(order(1 "Backbencher" 2 "Party leader"))
 scheme(s1mono)
 by(a1_spd a1_alliance) subtitle(, nobox)
;
#delimit cr

graph export results/psrm_figure_c1.png, as(png) replace

*save predictions from C-1 as dataset
keep a1_pr1 - a1_spd
save results/psrm_appendix_c_predictions1, replace

****model C-2: same as model C-1, but for Non-SPD MPs only, and with party dummies
use psrm_rcvdata, clear
*keep only observations for 6 major parties and for MPs elected at general election and for first six rcvs per session
keep if (m_group <6 | m_group == 7) & decisive_round <3 & high_p != . & nperses <2

logit oppose  pfleader alliance high_p c.lp##c.lp i.m_group if m_group != 7, vce(cluster idpsrm)
*write summary of model A-2 into doc via appending, this appears in table A-1 
# delimit ;
outreg2
 using "results/psrm_appendix_c_c1toc3.doc",
 word append label
 ctitle("C-2 - Non-SPD only")
 sideway bdec(2) sdec(3) e(r2_p chi2 ll_0 N_clust) alpha(0.001, 0.01, 0.05)
;
# delimit cr

****model C-3: same as model C-1, but for SPD MPs only
logit oppose  pfleader alliance high_p c.lp##c.lp if m_group == 7, vce(cluster idpsrm)
*write summary of model A-3 into doc via appending, this appears in table A-1 
# delimit ;
outreg2
 using "results/psrm_appendix_c_c1toc3.doc",
 word append label
 ctitle("C-3 - SPD only")
 sideway bdec(2) sdec(3) e(r2_p chi2 ll_0 N_clust) alpha(0.001, 0.01, 0.05)
;
# delimit cr


***model C-4 (all 6 major parties), same as model C-1, but also accounting for
***number supporting parties with different party line than own party line
use psrm_rcvdata, clear
*keep only observations for 6 major parties and for MPs elected at general election and for first six rcvs per session
keep if (m_group <6 | m_group == 7) & decisive_round <3 & high_p != . & nperses <2
logit oppose i.pfleader i.pfleaderspd splitcount i.alliance c.high_p c.lp##c.lp spd, vce(cluster idpsrm)
# delimit ;
outreg2
 using "results/psrm_appendix_c_c4toc5.doc",
 word replace label
 ctitle("C-4 - All parties")
 sideway bdec(2) sdec(3) e(r2_p chi2 ll_0 N_clust) alpha(0.001, 0.01, 0.05)
;
# delimit cr

***model C-5, same as C-4 but only 5 major bourgeois parties
keep if m_group != 7
logit oppose i.pfleader c.splitcount i.alliance c.high_p c.lp##c.lp i.m_group, vce(cluster idpsrm)
# delimit ;
outreg2
 using "results/psrm_appendix_c_c4toc5.doc",
 word append label
 ctitle("C-5 - Bourgeois parties")
 sideway bdec(2) sdec(3) e(r2_p chi2 ll_0 N_clust) alpha(0.001, 0.01, 0.05)
;
# delimit cr
cap drop mo*
mgen, atmeans at(splitcount = (0(1)4) m_group = (1 2 3 4 5) pfleader = (0 1) alliance = 1) stub(mo)
label define mgrouplabel 1 "DFP" 2 "DRP" 3 "DKP" 4 "NLP" 5 "Z"
label values mom_group mgrouplabel

**figure 3 (graph of predictions derived from model C-5)
# delimit ;
twoway 
 (rarea moll1 moul1 mosplitcount if mopfleader == 0, sort fcolor(gs8) lcolor(gs0) lwidth(vthin))
 (line mopr1 mosplitcount if mopfleader == 0, sort lcolor(gs0) lpattern(longdash) lwidth(thin))
 (rarea moll1 moul1 mosplitcount if mopfleader == 1, sort fcolor(gs12) lcolor(gs0) lwidth(vthin))
 (line mopr1 mosplitcount if mopfleader == 1, sort lcolor(gs0) lpattern(longdash) lwidth(thin))
 , xtitle(Count of dissenting committees within MP's electoral alliance)
 ytitle(Predicted probability of MP opposing his party line)
 by(, note(., size(zero)))
 legend(order(1 "MP" 3 "Party leader"))
 scheme(s1mono)
 by(mom_group, rows(1)) subtitle(, nobox)
;
# delimit cr 

graph export results/psrm_figure3.png, as(png) replace

*get frequencies of splitcounts by m_group into figure 3
cap drop  splitcounter_*
forval m=1(1)7{
forval n=1(1)7{
local c = `n' - 1
bysort splitcount: egen stub = count(splitcount) if m_group == `m' & splitcount == `c' & alliance == 1
egen splitcounter_`m'_`c' = max(stub)
drop stub
}
}
cap drop mosplitcounter
gen mosplitcounter = .
forval m = 1(1)7{
forval n = 1(1)7{
local c = `n' - 1
replace mosplitcounter = splitcounter_`m'_`c' if mom_group == `m' & mosplitcount == `c'
}
}
cap drop allvotes mosplitshare
bysort mom_group: egen allvotes = total(mosplitcounter)
gen mosplitshare = mosplitcounter / allvotes

tab mosplitshare mom_group

sort mom_group mosplitcount
order mosplitcounter, after(mom_group)
*repeat figure 3 with shares of obs on splitcounts
# delimit ;
twoway 
 (bar mosplitshare mosplitcount, sort yaxis(2))
 (rarea moll1 moul1 mosplitcount if mopfleader == 1, sort fcolor(gs12) lcolor(gs0) lwidth(vthin))
 (line mopr1 mosplitcount if mopfleader == 1, sort lcolor(gs0) lpattern(longdash) lwidth(thin))
 (rarea moll1 moul1 mosplitcount if mopfleader == 0, sort fcolor(gs8) lcolor(gs0) lwidth(vthin))
 (line mopr1 mosplitcount if mopfleader == 0, sort lcolor(gs0) lpattern(longdash) lwidth(thin))
 , xtitle(Count of dissenting committees within MP's electoral alliance)
 ytitle(Predicted probability of MP opposing his party line)
 yscale(alt axis (2))
 yscale(alt axis (1))
 by(, note(., size(zero)))
 legend(order(2 "MP" 3 "Party leader"))
 scheme(s1mono)
 by(mom_group, rows(1)) subtitle(, nobox)
;
# delimit cr 

*save predictions from C-5 as dataset
keep mopr1 - mosplitcounter
save results/psrm_appendix_c_predictions2, replace


***Models C-6 and C-7, figure 4
use psrm_rcvdata, clear
*keep only observations for 6 major parties and for MPs elected at general election and for first six rcvs per session
keep if (m_group <6 | m_group == 7) & decisive_round <3 & high_p != . & nperses <2
**preparation of data
*adapt Rice Scores as to be susceptible to beta regression
gen rice_rcvd = rice_rcv
replace rice_rcvd = 0.9999999 if rice_rcv == 1
replace rice_rcvd = 0.0000001 if rice_rcv == 0
sum rice_rcvd

*make variables for averages as to be used at level of m_groups, where Rice is measured
sort rcv_id m_group idpsrm
by rcv_id m_group: egen splitavg = mean(splitcount)
by rcv_id m_group: egen allianceavg = mean(alliance)
by rcv_id m_group: egen high_pavg = mean(high_p)

**Model C-6: all major parties
betareg rice_rcvd splitavg allianceavg high_pavg c.lp##c.lp i.m_group if rcvbig6first == 1, vce(cluster m_group)
# delimit ;
outreg2
 using "results/psrm_appendix_c_c6toc7.doc",
 word replace label
 ctitle("C-6 - All parties")
 sideway bdec(2) sdec(3) e(r2_p chi2 ll_0 N_clust) alpha(0.001, 0.01, 0.05)
;
# delimit cr


**Model C-7: five major bourgeois parties
keep if rcvbig6first == 1 & m_group <6
betareg rice_rcvd splitavg allianceavg high_pavg c.lp##c.lp i.m_group, vce(cluster m_group)
# delimit ;
outreg2
 using "results/psrm_appendix_c_c6toc7.doc",
 word append label
 ctitle("C-7 - Bourgeois parties")
 sideway bdec(2) sdec(3) e(r2_p chi2 ll_0 N_clust) alpha(0.001, 0.01, 0.05)
;
# delimit cr

cap drop do*
mgen, atmeans at(splitavg = (0(1)4) m_group = (1 2 3 4 5)) stub(do)
label values dom_group m_grouplabel

*Figure 4
# delimit ;
twoway 
 (rarea doll doul dosplitavg , sort fcolor(gs12) lcolor(gs0) lwidth(vthin))
 (line domargin dosplitavg, sort lcolor(gs0) lpattern(longdash) lwidth(thin))
 , xtitle(Average number of dissenting committees within MPs' electoral alliance)
 ytitle(Predicted Rice score)
 ylabel(0 0.25 0.5 0.75 1)
 by(, note(., size(zero)))
 by(, legend(off)) scheme(s1mono)
 by(dom_group, rows(1)) subtitle(, nobox)
;
# delimit cr 

graph export results/psrm_figure4.png, as(png) replace

*save predictions from C-7 as dataset
keep domargin - dom_group
save results/psrm_appendix_c_predictions3, replace

//// (end appendix C, figure 3, figure 4)

****Appendix D, table 3: 1918 reform - consequences and simulations 

***table 3: district magnitudes - preparation
use psrm_election, clear

* reduce size of dataset to variables on parties running 1903-1912
# delimit ;
drop bbf bbfs bfp demvg glb handwerkerpn hrechtsp lgsv lmpb lrp lv masurvp
 mrechtsp natarb pbayern pkassel pkons pps psh saguspd
;
# delimit cr
* reduce size of dataset by variable not of interest in the following
drop as_su - z_su as_re - z_re spd_cr - ethnic_cr spd_sucr - ethnic_sucr 

keep if election_year >= 1903 & round == 1
bysort election_year round: gen lprounderster = _n

sort election_year round
list election_year round spd_a if lprounderster ==1


*derive sizes of new districts following reform 1917/18, by numbers of districts
** affected according to Reibel (2007)
gen reform18 = 0
#delimit ;
replace reform18 = 1 if
 reibel_nummer ==31
 | reibel_nummer ==42
 | reibel_nummer ==46
 | reibel_nummer ==91
 | reibel_nummer ==93
 | reibel_nummer ==103
 | reibel_nummer ==104
 | reibel_nummer ==147
 | reibel_nummer ==158
 | reibel_nummer ==159
 | reibel_nummer ==172
 | reibel_nummer ==183
 | reibel_nummer ==184
 | reibel_nummer ==187
 | reibel_nummer ==192
 | reibel_nummer ==200
 | reibel_nummer ==201
 | reibel_nummer ==206
 | reibel_nummer ==207
 | reibel_nummer ==208
 | reibel_nummer ==210
 | reibel_nummer ==211
 | reibel_nummer ==212
 | reibel_nummer ==218
 | reibel_nummer ==237
 | reibel_nummer ==238
 | reibel_nummer ==267
 | reibel_nummer ==288
 | reibel_nummer ==289
 | reibel_nummer ==290
 | reibel_nummer ==296
 | reibel_nummer ==300
 | reibel_nummer ==308
 | reibel_nummer ==309
 | reibel_nummer ==335
 | reibel_nummer ==379
 | reibel_nummer ==380
;
#delimit cr

*assign artificial district numbers to new districts created by fusing old districts
** numbers are assigned to old district with lowest number
gen reibel_18 = reibel_nummer
replace reibel_18 = 398 if reibel_nummer ==31 //Berlin from 6 districts, districts no. 32-36 eliminated below
replace reibel_18 = 399 if reibel_nummer ==91 //Breslau from 2, 92 eliminated below
replace reibel_18 = 400 if reibel_nummer ==201 //Koeln from 2, 202 eliminated below
replace reibel_18 = 401 if reibel_nummer ==296 //Leipzig from 2, 297 eliminated below
replace reibel_18 = 402 if reibel_nummer ==380 //Hamburg from 3, 381-382 eliminated below
*eliminate district number of fused districts where applicable
#delimit ;
replace reibel_18 = . if
 reibel_nummer ==32
 | reibel_nummer ==33
 | reibel_nummer ==34
 | reibel_nummer ==35
 | reibel_nummer ==36
 | reibel_nummer ==92
 | reibel_nummer ==202
 | reibel_nummer ==297
 | reibel_nummer ==381
 | reibel_nummer ==382
;
#delimit cr

*assign mandate totals to districts affected by reform
*districts that are reduced in size, are assigned their previous mandate
*this and the following is hard-coded from lists and tables as provided in
*Reichsleitung 1918
gen magnitude18 = 1
replace magnitude18 = 10 if reibel_18 ==398
replace magnitude18 = 3 if reibel_18 ==42
replace magnitude18 = 7 if reibel_18 ==46
replace magnitude18 = 3 if reibel_18 ==399
replace magnitude18 = 1 if reibel_18 ==93
replace magnitude18 = 2 if reibel_18 ==103
replace magnitude18 = 2 if reibel_18 ==104
replace magnitude18 = 2 if reibel_18 ==147
replace magnitude18 = 2 if reibel_18 ==158
replace magnitude18 = 1 if reibel_18 ==159
replace magnitude18 = 2 if reibel_18 ==172
replace magnitude18 = 4 if reibel_18 ==183
replace magnitude18 = 3 if reibel_18 ==184
replace magnitude18 = 1 if reibel_18 ==187
replace magnitude18 = 2 if reibel_18 ==192
replace magnitude18 = 1 if reibel_18 ==200
replace magnitude18 = 3 if reibel_18 ==400
replace magnitude18 = 1 if reibel_18 ==206
replace magnitude18 = 1 if reibel_18 ==207
replace magnitude18 = 2 if reibel_18 ==208
replace magnitude18 = 2 if reibel_18 ==210
replace magnitude18 = 3 if reibel_18 ==211
replace magnitude18 = 3 if reibel_18 ==212
replace magnitude18 = 1 if reibel_18 ==218
replace magnitude18 = 3 if reibel_18 ==237
replace magnitude18 = 1 if reibel_18 ==238
replace magnitude18 = 2 if reibel_18 ==267
replace magnitude18 = 1 if reibel_18 ==288
replace magnitude18 = 3 if reibel_18 ==289
replace magnitude18 = 1 if reibel_18 ==290
replace magnitude18 = 4 if reibel_18 ==401
replace magnitude18 = 2 if reibel_18 ==300
replace magnitude18 = 2 if reibel_18 ==308
replace magnitude18 = 1 if reibel_18 ==309
replace magnitude18 = 2 if reibel_18 ==335
replace magnitude18 = 2 if reibel_18 ==379
replace magnitude18 = 5 if reibel_18 ==402
replace magnitude18 = . if reibel_18 ==.

****table 3: data on post-reform districts - data on post-reform mandates is
** calculated by multiplying magnitude18 with frequency of observations in the
** tab below
tab magnitude if election_year == 1912 & round ==1


****table D-1 (upper two rows) - 1912 results : 
** calculated as rows four and five of table 2 (see above)

****table D-1 (lower four rows)- 1912 simulations for party seats post-reform:
*1 variable per party as for entering data on votes in old and new districts
foreach var of varlist as - z{
gen `var'_a18 = `var'_a
label variable `var'_a18 `var'_votes_reform18
}

*variables on valid vote totals, etc.
gen valid_a18 = valid
gen pop_a18 = pop
gen electorate_a18 = electorate
gen voters_a18 = voters


*enter data as provided by source (Reichsleitung 1918), in each district
* and for each election_year 1903, 1907, 1912
replace pop_a18  = 1888848 if reibel_18 ==398 & election_year ==1903 & round ==1
replace pop_a18  = 293025 if reibel_18 ==42 & election_year ==1903 & round ==1
replace pop_a18  = 689170 if reibel_18 ==46 & election_year ==1903 & round ==1
replace pop_a18  = 428756 if reibel_18 ==399 & election_year ==1903 & round ==1
replace pop_a18  = 137440 if reibel_18 ==93 & election_year ==1903 & round ==1
replace pop_a18  = 309439 if reibel_18 ==103 & election_year ==1903 & round ==1
replace pop_a18  = 299007 if reibel_18 ==104 & election_year ==1903 & round ==1
replace pop_a18  = 264979 if reibel_18 ==147 & election_year ==1903 & round ==1
replace pop_a18  = 334353 if reibel_18 ==158 & election_year ==1903 & round ==1
replace pop_a18  = 126724 if reibel_18 ==159 & election_year ==1903 & round ==1
replace pop_a18  = 247924 if reibel_18 ==172 & election_year ==1903 & round ==1
replace pop_a18  = 556813 if reibel_18 ==183 & election_year ==1903 & round ==1
replace pop_a18  = 406434 if reibel_18 ==184 & election_year ==1903 & round ==1
replace pop_a18  = 157387 if reibel_18 ==187 & election_year ==1903 & round ==1
replace pop_a18  = 313382 if reibel_18 ==192 & election_year ==1903 & round ==1
replace pop_a18  = 122724 if reibel_18 ==200 & election_year ==1903 & round ==1
replace pop_a18  = 519173 if reibel_18 ==400 & election_year ==1903 & round ==1
replace pop_a18  = 116435 if reibel_18 ==206 & election_year ==1903 & round ==1
replace pop_a18  = 225784 if reibel_18 ==207 & election_year ==1903 & round ==1
replace pop_a18  = 298910 if reibel_18 ==208 & election_year ==1903 & round ==1
replace pop_a18  = 320320 if reibel_18 ==210 & election_year ==1903 & round ==1
replace pop_a18  = 402941 if reibel_18 ==211 & election_year ==1903 & round ==1
replace pop_a18  = 389835 if reibel_18 ==212 & election_year ==1903 & round ==1
replace pop_a18  = 99902 if reibel_18 ==218 & election_year ==1903 & round ==1
replace pop_a18  = 507736 if reibel_18 ==237 & election_year ==1903 & round ==1
replace pop_a18  = 68264 if reibel_18 ==238 & election_year ==1903 & round ==1
replace pop_a18  = 282276 if reibel_18 ==267 & election_year ==1903 & round ==1
replace pop_a18  = 121465 if reibel_18 ==288 & election_year ==1903 & round ==1
replace pop_a18  = 482410 if reibel_18 ==289 & election_year ==1903 & round ==1
replace pop_a18  = 163343 if reibel_18 ==290 & election_year ==1903 & round ==1
replace pop_a18  = 643582 if reibel_18 ==401 & election_year ==1903 & round ==1
replace pop_a18  = 276874 if reibel_18 ==300 & election_year ==1903 & round ==1
replace pop_a18  = 261824 if reibel_18 ==308 & election_year ==1903 & round ==1
replace pop_a18  = 131179 if reibel_18 ==309 & election_year ==1903 & round ==1
replace pop_a18  = 225508 if reibel_18 ==335 & election_year ==1903 & round ==1
replace pop_a18  = 224882 if reibel_18 ==379 & election_year ==1903 & round ==1
replace pop_a18  = 768349 if reibel_18 ==402 & election_year ==1903 & round ==1
replace electorate_a18  = 452341 if reibel_18 ==398 & election_year ==1903 & round ==1
replace electorate_a18  = 78307 if reibel_18 ==42 & election_year ==1903 & round ==1
replace electorate_a18  = 183030 if reibel_18 ==46 & election_year ==1903 & round ==1
replace electorate_a18  = 89538 if reibel_18 ==399 & election_year ==1903 & round ==1
replace electorate_a18  = 29150 if reibel_18 ==93 & election_year ==1903 & round ==1
replace electorate_a18  = 63729 if reibel_18 ==103 & election_year ==1903 & round ==1
replace electorate_a18  = 62667 if reibel_18 ==104 & election_year ==1903 & round ==1
replace electorate_a18  = 64329 if reibel_18 ==147 & election_year ==1903 & round ==1
replace electorate_a18  = 74450 if reibel_18 ==158 & election_year ==1903 & round ==1
replace electorate_a18  = 29068 if reibel_18 ==159 & election_year ==1903 & round ==1
replace electorate_a18  = 57621 if reibel_18 ==172 & election_year ==1903 & round ==1
replace electorate_a18  = 132177 if reibel_18 ==183 & election_year ==1903 & round ==1
replace electorate_a18  = 95835 if reibel_18 ==184 & election_year ==1903 & round ==1
replace electorate_a18  = 39772 if reibel_18 ==187 & election_year ==1903 & round ==1
replace electorate_a18  = 86301 if reibel_18 ==192 & election_year ==1903 & round ==1
replace electorate_a18  = 29955 if reibel_18 ==200 & election_year ==1903 & round ==1
replace electorate_a18  = 122509 if reibel_18 ==400 & election_year ==1903 & round ==1
replace electorate_a18  = 26080 if reibel_18 ==206 & election_year ==1903 & round ==1
replace electorate_a18  = 58521 if reibel_18 ==207 & election_year ==1903 & round ==1
replace electorate_a18  = 65482 if reibel_18 ==208 & election_year ==1903 & round ==1
replace electorate_a18  = 78381 if reibel_18 ==210 & election_year ==1903 & round ==1
replace electorate_a18  = 89414 if reibel_18 ==211 & election_year ==1903 & round ==1
replace electorate_a18  = 89092 if reibel_18 ==212 & election_year ==1903 & round ==1
replace electorate_a18  = 22484 if reibel_18 ==218 & election_year ==1903 & round ==1
replace electorate_a18  = 129722 if reibel_18 ==237 & election_year ==1903 & round ==1
replace electorate_a18  = 16381 if reibel_18 ==238 & election_year ==1903 & round ==1
replace electorate_a18  = 64813 if reibel_18 ==267 & election_year ==1903 & round ==1
replace electorate_a18  = 26009 if reibel_18 ==288 & election_year ==1903 & round ==1
replace electorate_a18  = 104772 if reibel_18 ==289 & election_year ==1903 & round ==1
replace electorate_a18  = 35497 if reibel_18 ==290 & election_year ==1903 & round ==1
replace electorate_a18  = 139121 if reibel_18 ==401 & election_year ==1903 & round ==1
replace electorate_a18  = 61385 if reibel_18 ==300 & election_year ==1903 & round ==1
replace electorate_a18  = 61153 if reibel_18 ==308 & election_year ==1903 & round ==1
replace electorate_a18  = 27960 if reibel_18 ==309 & election_year ==1903 & round ==1
replace electorate_a18  = 51314 if reibel_18 ==335 & election_year ==1903 & round ==1
replace electorate_a18  = 53480 if reibel_18 ==379 & election_year ==1903 & round ==1
replace electorate_a18  = 192937 if reibel_18 ==402 & election_year ==1903 & round ==1
replace voters_a18  = 333585 if reibel_18 ==398 & election_year ==1903 & round ==1
replace voters_a18  = 58818 if reibel_18 ==42 & election_year ==1903 & round ==1
replace voters_a18  = 133463 if reibel_18 ==46 & election_year ==1903 & round ==1
replace voters_a18  = 65290 if reibel_18 ==399 & election_year ==1903 & round ==1
replace voters_a18  = 22893 if reibel_18 ==93 & election_year ==1903 & round ==1
replace voters_a18  = 46596 if reibel_18 ==103 & election_year ==1903 & round ==1
replace voters_a18  = 44900 if reibel_18 ==104 & election_year ==1903 & round ==1
replace voters_a18  = 55038 if reibel_18 ==147 & election_year ==1903 & round ==1
replace voters_a18  = 56233 if reibel_18 ==158 & election_year ==1903 & round ==1
replace voters_a18  = 24490 if reibel_18 ==159 & election_year ==1903 & round ==1
replace voters_a18  = 44077 if reibel_18 ==172 & election_year ==1903 & round ==1
replace voters_a18  = 110346 if reibel_18 ==183 & election_year ==1903 & round ==1
replace voters_a18  = 78023 if reibel_18 ==184 & election_year ==1903 & round ==1
replace voters_a18  = 30773 if reibel_18 ==187 & election_year ==1903 & round ==1
replace voters_a18  = 49964 if reibel_18 ==192 & election_year ==1903 & round ==1
replace voters_a18  = 25653 if reibel_18 ==200 & election_year ==1903 & round ==1
replace voters_a18  = 85055 if reibel_18 ==400 & election_year ==1903 & round ==1
replace voters_a18  = 21127 if reibel_18 ==206 & election_year ==1903 & round ==1
replace voters_a18  = 43687 if reibel_18 ==207 & election_year ==1903 & round ==1
replace voters_a18  = 53910 if reibel_18 ==208 & election_year ==1903 & round ==1
replace voters_a18  = 52358 if reibel_18 ==210 & election_year ==1903 & round ==1
replace voters_a18  = 80504 if reibel_18 ==211 & election_year ==1903 & round ==1
replace voters_a18  = 75153 if reibel_18 ==212 & election_year ==1903 & round ==1
replace voters_a18  = 15834 if reibel_18 ==218 & election_year ==1903 & round ==1
replace voters_a18  = 84331 if reibel_18 ==237 & election_year ==1903 & round ==1
replace voters_a18  = 10458 if reibel_18 ==238 & election_year ==1903 & round ==1
replace voters_a18  = 50638 if reibel_18 ==267 & election_year ==1903 & round ==1
replace voters_a18  = 21991 if reibel_18 ==288 & election_year ==1903 & round ==1
replace voters_a18  = 86080 if reibel_18 ==289 & election_year ==1903 & round ==1
replace voters_a18  = 30932 if reibel_18 ==290 & election_year ==1903 & round ==1
replace voters_a18  = 114287 if reibel_18 ==401 & election_year ==1903 & round ==1
replace voters_a18  = 51392 if reibel_18 ==300 & election_year ==1903 & round ==1
replace voters_a18  = 47975 if reibel_18 ==308 & election_year ==1903 & round ==1
replace voters_a18  = 21663 if reibel_18 ==309 & election_year ==1903 & round ==1
replace voters_a18  = 41666 if reibel_18 ==335 & election_year ==1903 & round ==1
replace voters_a18  = 49307 if reibel_18 ==379 & election_year ==1903 & round ==1
replace voters_a18  = 162074 if reibel_18 ==402 & election_year ==1903 & round ==1
replace valid_a18  = 332654 if reibel_18 ==398 & election_year ==1903 & round ==1
replace valid_a18  = 58582 if reibel_18 ==42 & election_year ==1903 & round ==1
replace valid_a18  = 132918 if reibel_18 ==46 & election_year ==1903 & round ==1
replace valid_a18  = 65459 if reibel_18 ==399 & election_year ==1903 & round ==1
replace valid_a18  = 22857 if reibel_18 ==93 & election_year ==1903 & round ==1
replace valid_a18  = 46587 if reibel_18 ==103 & election_year ==1903 & round ==1
replace valid_a18  = 44865 if reibel_18 ==104 & election_year ==1903 & round ==1
replace valid_a18  = 54953 if reibel_18 ==147 & election_year ==1903 & round ==1
replace valid_a18  = 56156 if reibel_18 ==158 & election_year ==1903 & round ==1
replace valid_a18  = 24590 if reibel_18 ==159 & election_year ==1903 & round ==1
replace valid_a18  = 44178 if reibel_18 ==172 & election_year ==1903 & round ==1
replace valid_a18  = 110408 if reibel_18 ==183 & election_year ==1903 & round ==1
replace valid_a18  = 77950 if reibel_18 ==184 & election_year ==1903 & round ==1
replace valid_a18  = 30891 if reibel_18 ==187 & election_year ==1903 & round ==1
replace valid_a18  = 50054 if reibel_18 ==192 & election_year ==1903 & round ==1
replace valid_a18  = 25794 if reibel_18 ==200 & election_year ==1903 & round ==1
replace valid_a18  = 85047 if reibel_18 ==400 & election_year ==1903 & round ==1
replace valid_a18  = 21265 if reibel_18 ==206 & election_year ==1903 & round ==1
replace valid_a18  = 43811 if reibel_18 ==207 & election_year ==1903 & round ==1
replace valid_a18  = 53958 if reibel_18 ==208 & election_year ==1903 & round ==1
replace valid_a18  = 52426 if reibel_18 ==210 & election_year ==1903 & round ==1
replace valid_a18  = 80579 if reibel_18 ==211 & election_year ==1903 & round ==1
replace valid_a18  = 75220 if reibel_18 ==212 & election_year ==1903 & round ==1
replace valid_a18  = 15986 if reibel_18 ==218 & election_year ==1903 & round ==1
replace valid_a18  = 84189 if reibel_18 ==237 & election_year ==1903 & round ==1
replace valid_a18  = 10645 if reibel_18 ==238 & election_year ==1903 & round ==1
replace valid_a18  = 50741 if reibel_18 ==267 & election_year ==1903 & round ==1
replace valid_a18  = 22047 if reibel_18 ==288 & election_year ==1903 & round ==1
replace valid_a18  = 85608 if reibel_18 ==289 & election_year ==1903 & round ==1
replace valid_a18  = 30995 if reibel_18 ==290 & election_year ==1903 & round ==1
replace valid_a18  = 114266 if reibel_18 ==401 & election_year ==1903 & round ==1
replace valid_a18  = 51539 if reibel_18 ==300 & election_year ==1903 & round ==1
replace valid_a18  = 48187 if reibel_18 ==308 & election_year ==1903 & round ==1
replace valid_a18  = 21937 if reibel_18 ==309 & election_year ==1903 & round ==1
replace valid_a18  = 41927 if reibel_18 ==335 & election_year ==1903 & round ==1
replace valid_a18  = 49466 if reibel_18 ==379 & election_year ==1903 & round ==1
replace valid_a18  = 161822 if reibel_18 ==402 & election_year ==1903 & round ==1
replace dtkp_a18  = 41495 if reibel_18 ==398 & election_year ==1903 & round ==1
replace dtkp_a18  = 19608 if reibel_18 ==42 & election_year ==1903 & round ==1
replace dtkp_a18  = 36678 if reibel_18 ==46 & election_year ==1903 & round ==1
replace dtkp_a18  = 18937 if reibel_18 ==399 & election_year ==1903 & round ==1
replace dtkp_a18  = 13693 if reibel_18 ==93 & election_year ==1903 & round ==1
replace dtkp_a18  = 1123 if reibel_18 ==267 & election_year ==1903 & round ==1
replace dtkp_a18  = 10438 if reibel_18 ==288 & election_year ==1903 & round ==1
replace dtkp_a18  = 7473 if reibel_18 ==289 & election_year ==1903 & round ==1
replace drp_a18  = 25 if reibel_18 ==158 & election_year ==1903 & round ==1
replace drp_a18  = 4194 if reibel_18 ==159 & election_year ==1903 & round ==1
replace drp_a18  = 12070 if reibel_18 ==208 & election_year ==1903 & round ==1
replace drp_a18  = . if reibel_18 ==210 & election_year ==1903 & round ==1
replace drp_a18  = 20819 if reibel_18 ==211 & election_year ==1903 & round ==1
replace nlp_a18  = 1 if reibel_18 ==398 & election_year ==1903 & round ==1
replace nlp_a18  = . if reibel_18 ==42 & election_year ==1903 & round ==1
replace nlp_a18  = 7622 if reibel_18 ==46 & election_year ==1903 & round ==1
replace nlp_a18  = . if reibel_18 ==399 & election_year ==1903 & round ==1
replace nlp_a18  = . if reibel_18 ==93 & election_year ==1903 & round ==1
replace nlp_a18  = . if reibel_18 ==103 & election_year ==1903 & round ==1
replace nlp_a18  = . if reibel_18 ==104 & election_year ==1903 & round ==1
replace nlp_a18  = 10418 if reibel_18 ==147 & election_year ==1903 & round ==1
replace nlp_a18  = 11314 if reibel_18 ==158 & election_year ==1903 & round ==1
replace nlp_a18  = 7219 if reibel_18 ==159 & election_year ==1903 & round ==1
replace nlp_a18  = 4134 if reibel_18 ==172 & election_year ==1903 & round ==1
replace nlp_a18  = 33423 if reibel_18 ==183 & election_year ==1903 & round ==1
replace nlp_a18  = 21117 if reibel_18 ==184 & election_year ==1903 & round ==1
replace nlp_a18  = 6960 if reibel_18 ==187 & election_year ==1903 & round ==1
replace nlp_a18  = 6747 if reibel_18 ==192 & election_year ==1903 & round ==1
replace nlp_a18  = 8370 if reibel_18 ==200 & election_year ==1903 & round ==1
replace nlp_a18  = 10915 if reibel_18 ==400 & election_year ==1903 & round ==1
replace nlp_a18  = 6502 if reibel_18 ==206 & election_year ==1903 & round ==1
replace nlp_a18  = 7316 if reibel_18 ==207 & election_year ==1903 & round ==1
replace nlp_a18  = 4241 if reibel_18 ==208 & election_year ==1903 & round ==1
replace nlp_a18  = 7934 if reibel_18 ==210 & election_year ==1903 & round ==1
replace nlp_a18  = . if reibel_18 ==211 & election_year ==1903 & round ==1
replace nlp_a18  = 25415 if reibel_18 ==212 & election_year ==1903 & round ==1
replace nlp_a18  = 978 if reibel_18 ==218 & election_year ==1903 & round ==1
replace nlp_a18  = 15205 if reibel_18 ==237 & election_year ==1903 & round ==1
replace nlp_a18  = 588 if reibel_18 ==238 & election_year ==1903 & round ==1
replace nlp_a18  = 4005 if reibel_18 ==267 & election_year ==1903 & round ==1
replace nlp_a18  = 35046 if reibel_18 ==401 & election_year ==1903 & round ==1
replace nlp_a18  = 13078 if reibel_18 ==300 & election_year ==1903 & round ==1
replace nlp_a18  = 16330 if reibel_18 ==308 & election_year ==1903 & round ==1
replace nlp_a18  = 11098 if reibel_18 ==309 & election_year ==1903 & round ==1
replace nlp_a18  = 12250 if reibel_18 ==335 & election_year ==1903 & round ==1
replace nlp_a18  = . if reibel_18 ==379 & election_year ==1903 & round ==1
replace nlp_a18  = 36649 if reibel_18 ==402 & election_year ==1903 & round ==1
replace drefp_a18  = 4509 if reibel_18 ==192 & election_year ==1903 & round ==1
replace drefp_a18  = 514 if reibel_18 ==200 & election_year ==1903 & round ==1
replace drefp_a18  = 178 if reibel_18 ==400 & election_year ==1903 & round ==1
replace drefp_a18  = 21059 if reibel_18 ==289 & election_year ==1903 & round ==1
replace drefp_a18  = 11155 if reibel_18 ==290 & election_year ==1903 & round ==1
replace drefp_a18  = 3488 if reibel_18 ==401 & election_year ==1903 & round ==1
replace drefp_a18  = 2942 if reibel_18 ==402 & election_year ==1903 & round ==1
replace fvg_a18  = 3033 if reibel_18 ==104 & election_year ==1903 & round ==1
replace fvg_a18  = 12718 if reibel_18 ==147 & election_year ==1903 & round ==1
replace fvg_a18  = 23993 if reibel_18 ==379 & election_year ==1903 & round ==1
replace fvg_a18  = . if reibel_18 ==402 & election_year ==1903 & round ==1
replace dfp_a18  = 56144 if reibel_18 ==398 & election_year ==1903 & round ==1
replace dfp_a18  = 3679 if reibel_18 ==42 & election_year ==1903 & round ==1
replace dfp_a18  = 11710 if reibel_18 ==46 & election_year ==1903 & round ==1
replace dfp_a18  = 11962 if reibel_18 ==399 & election_year ==1903 & round ==1
replace dfp_a18  = 1181 if reibel_18 ==93 & election_year ==1903 & round ==1
replace dfp_a18  = 1284 if reibel_18 ==103 & election_year ==1903 & round ==1
replace dfp_a18  = . if reibel_18 ==104 & election_year ==1903 & round ==1
replace dfp_a18  = . if reibel_18 ==147 & election_year ==1903 & round ==1
replace dfp_a18  = 727 if reibel_18 ==158 & election_year ==1903 & round ==1
replace dfp_a18  = 1100 if reibel_18 ==184 & election_year ==1903 & round ==1
replace dfp_a18  = . if reibel_18 ==187 & election_year ==1903 & round ==1
replace dfp_a18  = 334 if reibel_18 ==192 & election_year ==1903 & round ==1
replace dfp_a18  = 1531 if reibel_18 ==200 & election_year ==1903 & round ==1
replace dfp_a18  = 8 if reibel_18 ==400 & election_year ==1903 & round ==1
replace dfp_a18  = 95 if reibel_18 ==206 & election_year ==1903 & round ==1
replace dfp_a18  = 12261 if reibel_18 ==207 & election_year ==1903 & round ==1
replace dfp_a18  = 4762 if reibel_18 ==208 & election_year ==1903 & round ==1
replace dfp_a18  = 292 if reibel_18 ==212 & election_year ==1903 & round ==1
replace dfp_a18  = . if reibel_18 ==218 & election_year ==1903 & round ==1
replace dfp_a18  = . if reibel_18 ==237 & election_year ==1903 & round ==1
replace dfp_a18  = . if reibel_18 ==238 & election_year ==1903 & round ==1
replace dfp_a18  = 13790 if reibel_18 ==267 & election_year ==1903 & round ==1
replace dfp_a18  = 184 if reibel_18 ==288 & election_year ==1903 & round ==1
replace dfp_a18  = 597 if reibel_18 ==289 & election_year ==1903 & round ==1
replace dfp_a18  = 334 if reibel_18 ==401 & election_year ==1903 & round ==1
replace dfp_a18  = 3703 if reibel_18 ==300 & election_year ==1903 & round ==1
replace dfp_a18  = 17987 if reibel_18 ==402 & election_year ==1903 & round ==1
replace dvp_a18  = 7543 if reibel_18 ==192 & election_year ==1903 & round ==1
replace dvp_a18  = 1474 if reibel_18 ==237 & election_year ==1903 & round ==1
replace dvp_a18  = 12 if reibel_18 ==238 & election_year ==1903 & round ==1
replace dvp_a18  = 2700 if reibel_18 ==308 & election_year ==1903 & round ==1
replace dvp_a18  = 2326 if reibel_18 ==309 & election_year ==1903 & round ==1
replace dvp_a18  = 2163 if reibel_18 ==335 & election_year ==1903 & round ==1
replace z_a18  = 6823 if reibel_18 ==398 & election_year ==1903 & round ==1
replace z_a18  = 763 if reibel_18 ==42 & election_year ==1903 & round ==1
replace z_a18  = 2013 if reibel_18 ==46 & election_year ==1903 & round ==1
replace z_a18  = . if reibel_18 ==399 & election_year ==1903 & round ==1
replace z_a18  = . if reibel_18 ==93 & election_year ==1903 & round ==1
replace z_a18  = 28071 if reibel_18 ==103 & election_year ==1903 & round ==1
replace z_a18  = 19992 if reibel_18 ==104 & election_year ==1903 & round ==1
replace z_a18  = 787 if reibel_18 ==147 & election_year ==1903 & round ==1
replace z_a18  = 2907 if reibel_18 ==158 & election_year ==1903 & round ==1
replace z_a18  = . if reibel_18 ==159 & election_year ==1903 & round ==1
replace z_a18  = 27388 if reibel_18 ==172 & election_year ==1903 & round ==1
replace z_a18  = 31408 if reibel_18 ==183 & election_year ==1903 & round ==1
replace z_a18  = 19472 if reibel_18 ==184 & election_year ==1903 & round ==1
replace z_a18  = 9186 if reibel_18 ==187 & election_year ==1903 & round ==1
replace z_a18  = 4688 if reibel_18 ==192 & election_year ==1903 & round ==1
replace z_a18  = 3987 if reibel_18 ==200 & election_year ==1903 & round ==1
replace z_a18  = 41043 if reibel_18 ==400 & election_year ==1903 & round ==1
replace z_a18  = 11882 if reibel_18 ==206 & election_year ==1903 & round ==1
replace z_a18  = . if reibel_18 ==207 & election_year ==1903 & round ==1
replace z_a18  = 5100 if reibel_18 ==208 & election_year ==1903 & round ==1
replace z_a18  = 23355 if reibel_18 ==210 & election_year ==1903 & round ==1
replace z_a18  = 35157 if reibel_18 ==211 & election_year ==1903 & round ==1
replace z_a18  = 21746 if reibel_18 ==212 & election_year ==1903 & round ==1
replace z_a18  = 13449 if reibel_18 ==218 & election_year ==1903 & round ==1
replace z_a18  = 17163 if reibel_18 ==237 & election_year ==1903 & round ==1
replace z_a18  = 4777 if reibel_18 ==238 & election_year ==1903 & round ==1
replace z_a18  = 2716 if reibel_18 ==267 & election_year ==1903 & round ==1
replace z_a18  = 91 if reibel_18 ==288 & election_year ==1903 & round ==1
replace z_a18  = 1243 if reibel_18 ==289 & election_year ==1903 & round ==1
replace z_a18  = 69 if reibel_18 ==290 & election_year ==1903 & round ==1
replace z_a18  = 567 if reibel_18 ==401 & election_year ==1903 & round ==1
replace z_a18  = 188 if reibel_18 ==300 & election_year ==1903 & round ==1
replace z_a18  = 2279 if reibel_18 ==308 & election_year ==1903 & round ==1
replace z_a18  = 412 if reibel_18 ==309 & election_year ==1903 & round ==1
replace z_a18  = 7104 if reibel_18 ==335 & election_year ==1903 & round ==1
replace z_a18  = . if reibel_18 ==379 & election_year ==1903 & round ==1
replace z_a18  = 2309 if reibel_18 ==402 & election_year ==1903 & round ==1
replace polen_a18  = 1838 if reibel_18 ==398 & election_year ==1903 & round ==1
replace polen_a18  = 241 if reibel_18 ==42 & election_year ==1903 & round ==1
replace polen_a18  = 815 if reibel_18 ==46 & election_year ==1903 & round ==1
replace polen_a18  = . if reibel_18 ==399 & election_year ==1903 & round ==1
replace polen_a18  = . if reibel_18 ==93 & election_year ==1903 & round ==1
replace polen_a18  = 6854 if reibel_18 ==103 & election_year ==1903 & round ==1
replace polen_a18  = 11670 if reibel_18 ==104 & election_year ==1903 & round ==1
replace polen_a18  = 3511 if reibel_18 ==172 & election_year ==1903 & round ==1
replace polen_a18  = 6208 if reibel_18 ==183 & election_year ==1903 & round ==1
replace polen_a18  = 2743 if reibel_18 ==184 & election_year ==1903 & round ==1
replace polen_a18  = . if reibel_18 ==187 & election_year ==1903 & round ==1
replace polen_a18  = . if reibel_18 ==192 & election_year ==1903 & round ==1
replace polen_a18  = . if reibel_18 ==200 & election_year ==1903 & round ==1
replace polen_a18  = 114 if reibel_18 ==400 & election_year ==1903 & round ==1
replace polen_a18  = . if reibel_18 ==206 & election_year ==1903 & round ==1
replace polen_a18  = . if reibel_18 ==207 & election_year ==1903 & round ==1
replace polen_a18  = 78 if reibel_18 ==208 & election_year ==1903 & round ==1
replace polen_a18  = 187 if reibel_18 ==210 & election_year ==1903 & round ==1
replace polen_a18  = 1589 if reibel_18 ==211 & election_year ==1903 & round ==1
replace polen_a18  = 2881 if reibel_18 ==212 & election_year ==1903 & round ==1
replace spd_a18  = 222390 if reibel_18 ==398 & election_year ==1903 & round ==1
replace spd_a18  = 34218 if reibel_18 ==42 & election_year ==1903 & round ==1
replace spd_a18  = 73852 if reibel_18 ==46 & election_year ==1903 & round ==1
replace spd_a18  = 33657 if reibel_18 ==399 & election_year ==1903 & round ==1
replace spd_a18  = 7868 if reibel_18 ==93 & election_year ==1903 & round ==1
replace spd_a18  = 10258 if reibel_18 ==103 & election_year ==1903 & round ==1
replace spd_a18  = 10044 if reibel_18 ==104 & election_year ==1903 & round ==1
replace spd_a18  = 30836 if reibel_18 ==147 & election_year ==1903 & round ==1
replace spd_a18  = 30831 if reibel_18 ==158 & election_year ==1903 & round ==1
replace spd_a18  = 8748 if reibel_18 ==159 & election_year ==1903 & round ==1
replace spd_a18  = 8897 if reibel_18 ==172 & election_year ==1903 & round ==1
replace spd_a18  = 39135 if reibel_18 ==183 & election_year ==1903 & round ==1
replace spd_a18  = 33305 if reibel_18 ==184 & election_year ==1903 & round ==1
replace spd_a18  = 12681 if reibel_18 ==187 & election_year ==1903 & round ==1
replace spd_a18  = 26023 if reibel_18 ==192 & election_year ==1903 & round ==1
replace spd_a18  = 11183 if reibel_18 ==200 & election_year ==1903 & round ==1
replace spd_a18  = 32065 if reibel_18 ==400 & election_year ==1903 & round ==1
replace spd_a18  = 2525 if reibel_18 ==206 & election_year ==1903 & round ==1
replace spd_a18  = 21412 if reibel_18 ==207 & election_year ==1903 & round ==1
replace spd_a18  = 27446 if reibel_18 ==208 & election_year ==1903 & round ==1
replace spd_a18  = 20699 if reibel_18 ==210 & election_year ==1903 & round ==1
replace spd_a18  = 22773 if reibel_18 ==211 & election_year ==1903 & round ==1
replace spd_a18  = 23284 if reibel_18 ==212 & election_year ==1903 & round ==1
replace spd_a18  = 1266 if reibel_18 ==218 & election_year ==1903 & round ==1
replace spd_a18  = 47338 if reibel_18 ==237 & election_year ==1903 & round ==1
replace spd_a18  = 2886 if reibel_18 ==238 & election_year ==1903 & round ==1
replace spd_a18  = 28812 if reibel_18 ==267 & election_year ==1903 & round ==1
replace spd_a18  = 11032 if reibel_18 ==288 & election_year ==1903 & round ==1
replace spd_a18  = 53260 if reibel_18 ==289 & election_year ==1903 & round ==1
replace spd_a18  = 19437 if reibel_18 ==290 & election_year ==1903 & round ==1
replace spd_a18  = 70959 if reibel_18 ==401 & election_year ==1903 & round ==1
replace spd_a18  = 34266 if reibel_18 ==300 & election_year ==1903 & round ==1
replace spd_a18  = 26513 if reibel_18 ==308 & election_year ==1903 & round ==1
replace spd_a18  = 7777 if reibel_18 ==309 & election_year ==1903 & round ==1
replace spd_a18  = 20037 if reibel_18 ==335 & election_year ==1903 & round ==1
replace spd_a18  = 25076 if reibel_18 ==379 & election_year ==1903 & round ==1
replace spd_a18  = 100412 if reibel_18 ==402 & election_year ==1903 & round ==1
replace dhp_a18  = 9934 if reibel_18 ==158 & election_year ==1903 & round ==1
replace dhp_a18  = 4253 if reibel_18 ==159 & election_year ==1903 & round ==1
replace ds_a18  = 3210 if reibel_18 ==398 & election_year ==1903 & round ==1
replace ds_a18  = . if reibel_18 ==42 & election_year ==1903 & round ==1
replace ds_a18  = . if reibel_18 ==46 & election_year ==1903 & round ==1
replace ds_a18  = 425 if reibel_18 ==399 & election_year ==1903 & round ==1
replace cs_a18  = 2591 if reibel_18 ==207 & election_year ==1903 & round ==1
replace cs_a18  = 9 if reibel_18 ==208 & election_year ==1903 & round ==1
replace cs_a18  = . if reibel_18 ==210 & election_year ==1903 & round ==1
replace cs_a18  = . if reibel_18 ==211 & election_year ==1903 & round ==1
replace cs_a18  = 1377 if reibel_18 ==212 & election_year ==1903 & round ==1
replace cs_a18  = . if reibel_18 ==218 & election_year ==1903 & round ==1
replace cs_a18  = 2618 if reibel_18 ==237 & election_year ==1903 & round ==1
replace cs_a18  = 82 if reibel_18 ==238 & election_year ==1903 & round ==1
replace naso_a18  = 69 if reibel_18 ==398 & election_year ==1903 & round ==1
replace naso_a18  = 132 if reibel_18 ==46 & election_year ==1903 & round ==1
replace naso_a18  = 188 if reibel_18 ==158 & election_year ==1903 & round ==1
replace naso_a18  = 4 if reibel_18 ==288 & election_year ==1903 & round ==1
replace naso_a18  = 1545 if reibel_18 ==289 & election_year ==1903 & round ==1
replace naso_a18  = 9 if reibel_18 ==290 & election_year ==1903 & round ==1
replace naso_a18  = 3376 if reibel_18 ==401 & election_year ==1903 & round ==1
replace naso_a18  = 1094 if reibel_18 ==402 & election_year ==1903 & round ==1
replace bbb_a18  = 79 if reibel_18 ==237 & election_year ==1903 & round ==1
replace bbb_a18  = 2053 if reibel_18 ==238 & election_year ==1903 & round ==1
replace bdl_a18  = 1865 if reibel_18 ==187 & election_year ==1903 & round ==1
replace bdl_a18  = 2 if reibel_18 ==192 & election_year ==1903 & round ==1
replace bdl_a18  = 32 if reibel_18 ==308 & election_year ==1903 & round ==1
replace undeclared_a18  = 194 if reibel_18 ==400 & election_year ==1903 & round ==1
replace undeclared_a18  = 33 if reibel_18 ==218 & election_year ==1903 & round ==1
replace other_a18  = 286 if reibel_18 ==398 & election_year ==1903 & round ==1
replace other_a18  = 31 if reibel_18 ==42 & election_year ==1903 & round ==1
replace other_a18  = 50 if reibel_18 ==46 & election_year ==1903 & round ==1
replace other_a18  = 79 if reibel_18 ==399 & election_year ==1903 & round ==1
replace other_a18  = 22 if reibel_18 ==93 & election_year ==1903 & round ==1
replace other_a18  = 17 if reibel_18 ==103 & election_year ==1903 & round ==1
replace other_a18  = 22 if reibel_18 ==104 & election_year ==1903 & round ==1
replace other_a18  = 47 if reibel_18 ==147 & election_year ==1903 & round ==1
replace other_a18  = 72 if reibel_18 ==158 & election_year ==1903 & round ==1
replace other_a18  = 17 if reibel_18 ==159 & election_year ==1903 & round ==1
replace other_a18  = 76 if reibel_18 ==172 & election_year ==1903 & round ==1
replace other_a18  = 51 if reibel_18 ==183 & election_year ==1903 & round ==1
replace other_a18  = 29 if reibel_18 ==184 & election_year ==1903 & round ==1
replace other_a18  = 12 if reibel_18 ==187 & election_year ==1903 & round ==1
replace other_a18  = 16 if reibel_18 ==192 & election_year ==1903 & round ==1
replace other_a18  = 9 if reibel_18 ==200 & election_year ==1903 & round ==1
replace other_a18  = 130 if reibel_18 ==400 & election_year ==1903 & round ==1
replace other_a18  = 55 if reibel_18 ==206 & election_year ==1903 & round ==1
replace other_a18  = 24 if reibel_18 ==207 & election_year ==1903 & round ==1
replace other_a18  = 44 if reibel_18 ==208 & election_year ==1903 & round ==1
replace other_a18  = 41 if reibel_18 ==210 & election_year ==1903 & round ==1
replace other_a18  = 30 if reibel_18 ==211 & election_year ==1903 & round ==1
replace other_a18  = 13 if reibel_18 ==212 & election_year ==1903 & round ==1
replace other_a18  = 42 if reibel_18 ==218 & election_year ==1903 & round ==1
replace other_a18  = 75 if reibel_18 ==237 & election_year ==1903 & round ==1
replace other_a18  = 9 if reibel_18 ==238 & election_year ==1903 & round ==1
replace other_a18  = 28 if reibel_18 ==267 & election_year ==1903 & round ==1
replace other_a18  = 10 if reibel_18 ==288 & election_year ==1903 & round ==1
replace other_a18  = 142 if reibel_18 ==289 & election_year ==1903 & round ==1
replace other_a18  = 35 if reibel_18 ==290 & election_year ==1903 & round ==1
replace other_a18  = 95 if reibel_18 ==401 & election_year ==1903 & round ==1
replace other_a18  = 4 if reibel_18 ==300 & election_year ==1903 & round ==1
replace other_a18  = 25 if reibel_18 ==308 & election_year ==1903 & round ==1
replace other_a18  = 15 if reibel_18 ==309 & election_year ==1903 & round ==1
replace other_a18  = 38 if reibel_18 ==335 & election_year ==1903 & round ==1
replace other_a18  = 18 if reibel_18 ==379 & election_year ==1903 & round ==1
replace other_a18  = 27 if reibel_18 ==402 & election_year ==1903 & round ==1
replace pop_a18  = 2040148 if reibel_18 ==398 & election_year ==1907 & round ==1
replace pop_a18  = 391527 if reibel_18 ==42 & election_year ==1907 & round ==1
replace pop_a18  = 958851 if reibel_18 ==46 & election_year ==1907 & round ==1
replace pop_a18  = 473460 if reibel_18 ==399 & election_year ==1907 & round ==1
replace pop_a18  = 144402 if reibel_18 ==93 & election_year ==1907 & round ==1
replace pop_a18  = 363717 if reibel_18 ==103 & election_year ==1907 & round ==1
replace pop_a18  = 359216 if reibel_18 ==104 & election_year ==1907 & round ==1
replace pop_a18  = 322731 if reibel_18 ==147 & election_year ==1907 & round ==1
replace pop_a18  = 367188 if reibel_18 ==158 & election_year ==1907 & round ==1
replace pop_a18  = 133274 if reibel_18 ==159 & election_year ==1907 & round ==1
replace pop_a18  = 327311 if reibel_18 ==172 & election_year ==1907 & round ==1
replace pop_a18  = 660375 if reibel_18 ==183 & election_year ==1907 & round ==1
replace pop_a18  = 484893 if reibel_18 ==184 & election_year ==1907 & round ==1
replace pop_a18  = 175171 if reibel_18 ==187 & election_year ==1907 & round ==1
replace pop_a18  = 364833 if reibel_18 ==192 & election_year ==1907 & round ==1
replace pop_a18  = 132389 if reibel_18 ==200 & election_year ==1907 & round ==1
replace pop_a18  = 599611 if reibel_18 ==400 & election_year ==1907 & round ==1
replace pop_a18  = 125117 if reibel_18 ==206 & election_year ==1907 & round ==1
replace pop_a18  = 245708 if reibel_18 ==207 & election_year ==1907 & round ==1
replace pop_a18  = 318933 if reibel_18 ==208 & election_year ==1907 & round ==1
replace pop_a18  = 380770 if reibel_18 ==210 & election_year ==1907 & round ==1
replace pop_a18  = 474550 if reibel_18 ==211 & election_year ==1907 & round ==1
replace pop_a18  = 501979 if reibel_18 ==212 & election_year ==1907 & round ==1
replace pop_a18  = 108711 if reibel_18 ==218 & election_year ==1907 & round ==1
replace pop_a18  = 547302 if reibel_18 ==237 & election_year ==1907 & round ==1
replace pop_a18  = 74124 if reibel_18 ==238 & election_year ==1907 & round ==1
replace pop_a18  = 316702 if reibel_18 ==267 & election_year ==1907 & round ==1
replace pop_a18  = 128277 if reibel_18 ==288 & election_year ==1907 & round ==1
replace pop_a18  = 520262 if reibel_18 ==289 & election_year ==1907 & round ==1
replace pop_a18  = 172448 if reibel_18 ==290 & election_year ==1907 & round ==1
replace pop_a18  = 688687 if reibel_18 ==401 & election_year ==1907 & round ==1
replace pop_a18  = 313716 if reibel_18 ==300 & election_year ==1907 & round ==1
replace pop_a18  = 301476 if reibel_18 ==308 & election_year ==1907 & round ==1
replace pop_a18  = 140982 if reibel_18 ==309 & election_year ==1907 & round ==1
replace pop_a18  = 258159 if reibel_18 ==335 & election_year ==1907 & round ==1
replace pop_a18  = 263440 if reibel_18 ==379 & election_year ==1907 & round ==1
replace pop_a18  = 874878 if reibel_18 ==402 & election_year ==1907 & round ==1
replace electorate_a18  = 504859 if reibel_18 ==398 & election_year ==1907 & round ==1
replace electorate_a18  = 101593 if reibel_18 ==42 & election_year ==1907 & round ==1
replace electorate_a18  = 248116 if reibel_18 ==46 & election_year ==1907 & round ==1
replace electorate_a18  = 99684 if reibel_18 ==399 & election_year ==1907 & round ==1
replace electorate_a18  = 29582 if reibel_18 ==93 & election_year ==1907 & round ==1
replace electorate_a18  = 69801 if reibel_18 ==103 & election_year ==1907 & round ==1
replace electorate_a18  = 69421 if reibel_18 ==104 & election_year ==1907 & round ==1
replace electorate_a18  = 70782 if reibel_18 ==147 & election_year ==1907 & round ==1
replace electorate_a18  = 84760 if reibel_18 ==158 & election_year ==1907 & round ==1
replace electorate_a18  = 29911 if reibel_18 ==159 & election_year ==1907 & round ==1
replace electorate_a18  = 69620 if reibel_18 ==172 & election_year ==1907 & round ==1
replace electorate_a18  = 143835 if reibel_18 ==183 & election_year ==1907 & round ==1
replace electorate_a18  = 105498 if reibel_18 ==184 & election_year ==1907 & round ==1
replace electorate_a18  = 42892 if reibel_18 ==187 & election_year ==1907 & round ==1
replace electorate_a18  = 92923 if reibel_18 ==192 & election_year ==1907 & round ==1
replace electorate_a18  = 31509 if reibel_18 ==200 & election_year ==1907 & round ==1
replace electorate_a18  = 142186 if reibel_18 ==400 & election_year ==1907 & round ==1
replace electorate_a18  = 28184 if reibel_18 ==206 & election_year ==1907 & round ==1
replace electorate_a18  = 57142 if reibel_18 ==207 & election_year ==1907 & round ==1
replace electorate_a18  = 68263 if reibel_18 ==208 & election_year ==1907 & round ==1
replace electorate_a18  = 86621 if reibel_18 ==210 & election_year ==1907 & round ==1
replace electorate_a18  = 106804 if reibel_18 ==211 & election_year ==1907 & round ==1
replace electorate_a18  = 107627 if reibel_18 ==212 & election_year ==1907 & round ==1
replace electorate_a18  = 23942 if reibel_18 ==218 & election_year ==1907 & round ==1
replace electorate_a18  = 134985 if reibel_18 ==237 & election_year ==1907 & round ==1
replace electorate_a18  = 17895 if reibel_18 ==238 & election_year ==1907 & round ==1
replace electorate_a18  = 74081 if reibel_18 ==267 & election_year ==1907 & round ==1
replace electorate_a18  = 27128 if reibel_18 ==288 & election_year ==1907 & round ==1
replace electorate_a18  = 112539 if reibel_18 ==289 & election_year ==1907 & round ==1
replace electorate_a18  = 36760 if reibel_18 ==290 & election_year ==1907 & round ==1
replace electorate_a18  = 155472 if reibel_18 ==401 & election_year ==1907 & round ==1
replace electorate_a18  = 67652 if reibel_18 ==300 & election_year ==1907 & round ==1
replace electorate_a18  = 69932 if reibel_18 ==308 & election_year ==1907 & round ==1
replace electorate_a18  = 30283 if reibel_18 ==309 & election_year ==1907 & round ==1
replace electorate_a18  = 57430 if reibel_18 ==335 & election_year ==1907 & round ==1
replace electorate_a18  = 60968 if reibel_18 ==379 & election_year ==1907 & round ==1
replace electorate_a18  = 219502 if reibel_18 ==402 & election_year ==1907 & round ==1
replace voters_a18  = 391389 if reibel_18 ==398 & election_year ==1907 & round ==1
replace voters_a18  = 86081 if reibel_18 ==42 & election_year ==1907 & round ==1
replace voters_a18  = 200423 if reibel_18 ==46 & election_year ==1907 & round ==1
replace voters_a18  = 83222 if reibel_18 ==399 & election_year ==1907 & round ==1
replace voters_a18  = 24855 if reibel_18 ==93 & election_year ==1907 & round ==1
replace voters_a18  = 49646 if reibel_18 ==103 & election_year ==1907 & round ==1
replace voters_a18  = 58965 if reibel_18 ==104 & election_year ==1907 & round ==1
replace voters_a18  = 64056 if reibel_18 ==147 & election_year ==1907 & round ==1
replace voters_a18  = 74352 if reibel_18 ==158 & election_year ==1907 & round ==1
replace voters_a18  = 25857 if reibel_18 ==159 & election_year ==1907 & round ==1
replace voters_a18  = 58965 if reibel_18 ==172 & election_year ==1907 & round ==1
replace voters_a18  = 125699 if reibel_18 ==183 & election_year ==1907 & round ==1
replace voters_a18  = 92785 if reibel_18 ==184 & election_year ==1907 & round ==1
replace voters_a18  = 37657 if reibel_18 ==187 & election_year ==1907 & round ==1
replace voters_a18  = 74391 if reibel_18 ==192 & election_year ==1907 & round ==1
replace voters_a18  = 26638 if reibel_18 ==200 & election_year ==1907 & round ==1
replace voters_a18  = 112053 if reibel_18 ==400 & election_year ==1907 & round ==1
replace voters_a18  = 25760 if reibel_18 ==206 & election_year ==1907 & round ==1
replace voters_a18  = 50609 if reibel_18 ==207 & election_year ==1907 & round ==1
replace voters_a18  = 62871 if reibel_18 ==208 & election_year ==1907 & round ==1
replace voters_a18  = 72333 if reibel_18 ==210 & election_year ==1907 & round ==1
replace voters_a18  = 95022 if reibel_18 ==211 & election_year ==1907 & round ==1
replace voters_a18  = 93347 if reibel_18 ==212 & election_year ==1907 & round ==1
replace voters_a18  = 20052 if reibel_18 ==218 & election_year ==1907 & round ==1
replace voters_a18  = 96318 if reibel_18 ==237 & election_year ==1907 & round ==1
replace voters_a18  = 11972 if reibel_18 ==238 & election_year ==1907 & round ==1
replace voters_a18  = 63690 if reibel_18 ==267 & election_year ==1907 & round ==1
replace voters_a18  = 24308 if reibel_18 ==288 & election_year ==1907 & round ==1
replace voters_a18  = 98890 if reibel_18 ==289 & election_year ==1907 & round ==1
replace voters_a18  = 34033 if reibel_18 ==290 & election_year ==1907 & round ==1
replace voters_a18  = 136734 if reibel_18 ==401 & election_year ==1907 & round ==1
replace voters_a18  = 58368 if reibel_18 ==300 & election_year ==1907 & round ==1
replace voters_a18  = 57845 if reibel_18 ==308 & election_year ==1907 & round ==1
replace voters_a18  = 25789 if reibel_18 ==309 & election_year ==1907 & round ==1
replace voters_a18  = 51271 if reibel_18 ==335 & election_year ==1907 & round ==1
replace voters_a18  = 56761 if reibel_18 ==379 & election_year ==1907 & round ==1
replace voters_a18  = 187183 if reibel_18 ==402 & election_year ==1907 & round ==1
replace valid_a18  = 388624 if reibel_18 ==398 & election_year ==1907 & round ==1
replace valid_a18  = 85601 if reibel_18 ==42 & election_year ==1907 & round ==1
replace valid_a18  = 199570 if reibel_18 ==46 & election_year ==1907 & round ==1
replace valid_a18  = 82853 if reibel_18 ==399 & election_year ==1907 & round ==1
replace valid_a18  = 24794 if reibel_18 ==93 & election_year ==1907 & round ==1
replace valid_a18  = 49573 if reibel_18 ==103 & election_year ==1907 & round ==1
replace valid_a18  = 51485 if reibel_18 ==104 & election_year ==1907 & round ==1
replace valid_a18  = 64457 if reibel_18 ==147 & election_year ==1907 & round ==1
replace valid_a18  = 74115 if reibel_18 ==158 & election_year ==1907 & round ==1
replace valid_a18  = 25762 if reibel_18 ==159 & election_year ==1907 & round ==1
replace valid_a18  = 58851 if reibel_18 ==172 & election_year ==1907 & round ==1
replace valid_a18  = 125440 if reibel_18 ==183 & election_year ==1907 & round ==1
replace valid_a18  = 92457 if reibel_18 ==184 & election_year ==1907 & round ==1
replace valid_a18  = 37573 if reibel_18 ==187 & election_year ==1907 & round ==1
replace valid_a18  = 74070 if reibel_18 ==192 & election_year ==1907 & round ==1
replace valid_a18  = 26241 if reibel_18 ==200 & election_year ==1907 & round ==1
replace valid_a18  = 111720 if reibel_18 ==400 & election_year ==1907 & round ==1
replace valid_a18  = 25711 if reibel_18 ==206 & election_year ==1907 & round ==1
replace valid_a18  = 50509 if reibel_18 ==207 & election_year ==1907 & round ==1
replace valid_a18  = 62704 if reibel_18 ==208 & election_year ==1907 & round ==1
replace valid_a18  = 72171 if reibel_18 ==210 & election_year ==1907 & round ==1
replace valid_a18  = 94826 if reibel_18 ==211 & election_year ==1907 & round ==1
replace valid_a18  = 93077 if reibel_18 ==212 & election_year ==1907 & round ==1
replace valid_a18  = 19978 if reibel_18 ==218 & election_year ==1907 & round ==1
replace valid_a18  = 95929 if reibel_18 ==237 & election_year ==1907 & round ==1
replace valid_a18  = 11919 if reibel_18 ==238 & election_year ==1907 & round ==1
replace valid_a18  = 63511 if reibel_18 ==267 & election_year ==1907 & round ==1
replace valid_a18  = 24224 if reibel_18 ==288 & election_year ==1907 & round ==1
replace valid_a18  = 98531 if reibel_18 ==289 & election_year ==1907 & round ==1
replace valid_a18  = 33912 if reibel_18 ==290 & election_year ==1907 & round ==1
replace valid_a18  = 136229 if reibel_18 ==401 & election_year ==1907 & round ==1
replace valid_a18  = 58223 if reibel_18 ==300 & election_year ==1907 & round ==1
replace valid_a18  = 57680 if reibel_18 ==308 & election_year ==1907 & round ==1
replace valid_a18  = 25684 if reibel_18 ==309 & election_year ==1907 & round ==1
replace valid_a18  = 51082 if reibel_18 ==335 & election_year ==1907 & round ==1
replace valid_a18  = 56528 if reibel_18 ==379 & election_year ==1907 & round ==1
replace valid_a18  = 186241 if reibel_18 ==402 & election_year ==1907 & round ==1
replace dtkp_a18  = 27695 if reibel_18 ==398 & election_year ==1907 & round ==1
replace dtkp_a18  = . if reibel_18 ==42 & election_year ==1907 & round ==1
replace dtkp_a18  = 52484 if reibel_18 ==46 & election_year ==1907 & round ==1
replace dtkp_a18  = 860 if reibel_18 ==399 & election_year ==1907 & round ==1
replace dtkp_a18  = 12038 if reibel_18 ==93 & election_year ==1907 & round ==1
replace dtkp_a18  = 4110 if reibel_18 ==288 & election_year ==1907 & round ==1
replace dtkp_a18  = 7773 if reibel_18 ==289 & election_year ==1907 & round ==1
replace dtkp_a18  = . if reibel_18 ==290 & election_year ==1907 & round ==1
replace dtkp_a18  = . if reibel_18 ==401 & election_year ==1907 & round ==1
replace dtkp_a18  = 4869 if reibel_18 ==300 & election_year ==1907 & round ==1
replace drp_a18  = 1935 if reibel_18 ==398 & election_year ==1907 & round ==1
replace drp_a18  = 32759 if reibel_18 ==42 & election_year ==1907 & round ==1
replace drp_a18  = 22169 if reibel_18 ==399 & election_year ==1907 & round ==1
replace drp_a18  = 14157 if reibel_18 ==208 & election_year ==1907 & round ==1
replace nlp_a18  = 9219 if reibel_18 ==103 & election_year ==1907 & round ==1
replace nlp_a18  = 12230 if reibel_18 ==104 & election_year ==1907 & round ==1
replace nlp_a18  = . if reibel_18 ==147 & election_year ==1907 & round ==1
replace nlp_a18  = 13374 if reibel_18 ==158 & election_year ==1907 & round ==1
replace nlp_a18  = 9095 if reibel_18 ==159 & election_year ==1907 & round ==1
replace nlp_a18  = 6558 if reibel_18 ==172 & election_year ==1907 & round ==1
replace nlp_a18  = 40390 if reibel_18 ==183 & election_year ==1907 & round ==1
replace nlp_a18  = 25741 if reibel_18 ==184 & election_year ==1907 & round ==1
replace nlp_a18  = 9328 if reibel_18 ==187 & election_year ==1907 & round ==1
replace nlp_a18  = 8060 if reibel_18 ==192 & election_year ==1907 & round ==1
replace nlp_a18  = 11413 if reibel_18 ==200 & election_year ==1907 & round ==1
replace nlp_a18  = 20846 if reibel_18 ==400 & election_year ==1907 & round ==1
replace nlp_a18  = 8927 if reibel_18 ==206 & election_year ==1907 & round ==1
replace nlp_a18  = . if reibel_18 ==207 & election_year ==1907 & round ==1
replace nlp_a18  = 13214 if reibel_18 ==208 & election_year ==1907 & round ==1
replace nlp_a18  = 15048 if reibel_18 ==210 & election_year ==1907 & round ==1
replace nlp_a18  = 22162 if reibel_18 ==211 & election_year ==1907 & round ==1
replace nlp_a18  = 32045 if reibel_18 ==212 & election_year ==1907 & round ==1
replace nlp_a18  = 2255 if reibel_18 ==218 & election_year ==1907 & round ==1
replace nlp_a18  = 10866 if reibel_18 ==237 & election_year ==1907 & round ==1
replace nlp_a18  = 29295 if reibel_18 ==289 & election_year ==1907 & round ==1
replace nlp_a18  = 15367 if reibel_18 ==290 & election_year ==1907 & round ==1
replace nlp_a18  = 63733 if reibel_18 ==401 & election_year ==1907 & round ==1
replace nlp_a18  = 18645 if reibel_18 ==300 & election_year ==1907 & round ==1
replace nlp_a18  = 24787 if reibel_18 ==308 & election_year ==1907 & round ==1
replace nlp_a18  = 15442 if reibel_18 ==309 & election_year ==1907 & round ==1
replace nlp_a18  = 16900 if reibel_18 ==335 & election_year ==1907 & round ==1
replace nlp_a18  = . if reibel_18 ==379 & election_year ==1907 & round ==1
replace nlp_a18  = 29148 if reibel_18 ==402 & election_year ==1907 & round ==1
replace drefp_a18  = 167 if reibel_18 ==398 & election_year ==1907 & round ==1
replace drefp_a18  = 21 if reibel_18 ==42 & election_year ==1907 & round ==1
replace drefp_a18  = 7204 if reibel_18 ==288 & election_year ==1907 & round ==1
replace drefp_a18  = 5164 if reibel_18 ==289 & election_year ==1907 & round ==1
replace drefp_a18  = 618 if reibel_18 ==402 & election_year ==1907 & round ==1
replace wvg_a18  = 45 if reibel_18 ==289 & election_year ==1907 & round ==1
replace wvg_a18  = 6 if reibel_18 ==290 & election_year ==1907 & round ==1
replace fvg_a18  = 100 if reibel_18 ==398 & election_year ==1907 & round ==1
replace fvg_a18  = 84 if reibel_18 ==42 & election_year ==1907 & round ==1
replace fvg_a18  = 30813 if reibel_18 ==147 & election_year ==1907 & round ==1
replace fvg_a18  = 495 if reibel_18 ==184 & election_year ==1907 & round ==1
replace fvg_a18  = 162 if reibel_18 ==400 & election_year ==1907 & round ==1
replace fvg_a18  = 593 if reibel_18 ==210 & election_year ==1907 & round ==1
replace fvg_a18  = 41850 if reibel_18 ==402 & election_year ==1907 & round ==1
replace dfp_a18  = 87158 if reibel_18 ==398 & election_year ==1907 & round ==1
replace dfp_a18  = . if reibel_18 ==42 & election_year ==1907 & round ==1
replace dfp_a18  = 39063 if reibel_18 ==46 & election_year ==1907 & round ==1
replace dfp_a18  = 21357 if reibel_18 ==399 & election_year ==1907 & round ==1
replace dfp_a18  = 286 if reibel_18 ==93 & election_year ==1907 & round ==1
replace dfp_a18  = 2978 if reibel_18 ==187 & election_year ==1907 & round ==1
replace dfp_a18  = 1876 if reibel_18 ==192 & election_year ==1907 & round ==1
replace dfp_a18  = 2779 if reibel_18 ==200 & election_year ==1907 & round ==1
replace dfp_a18  = 16411 if reibel_18 ==207 & election_year ==1907 & round ==1
replace dfp_a18  = 249 if reibel_18 ==208 & election_year ==1907 & round ==1
replace dfp_a18  = 1091 if reibel_18 ==211 & election_year ==1907 & round ==1
replace dfp_a18  = 20905 if reibel_18 ==267 & election_year ==1907 & round ==1
replace dfp_a18  = 2719 if reibel_18 ==288 & election_year ==1907 & round ==1
replace dfp_a18  = 3814 if reibel_18 ==289 & election_year ==1907 & round ==1
replace dfp_a18  = 789 if reibel_18 ==401 & election_year ==1907 & round ==1
replace dfp_a18  = 28006 if reibel_18 ==379 & election_year ==1907 & round ==1
replace dvp_a18  = 17692 if reibel_18 ==192 & election_year ==1907 & round ==1
replace z_a18  = 9438 if reibel_18 ==398 & election_year ==1907 & round ==1
replace z_a18  = 1378 if reibel_18 ==42 & election_year ==1907 & round ==1
replace z_a18  = 2865 if reibel_18 ==46 & election_year ==1907 & round ==1
replace z_a18  = 279 if reibel_18 ==399 & election_year ==1907 & round ==1
replace z_a18  = 6400 if reibel_18 ==93 & election_year ==1907 & round ==1
replace z_a18  = 7961 if reibel_18 ==103 & election_year ==1907 & round ==1
replace z_a18  = 6575 if reibel_18 ==104 & election_year ==1907 & round ==1
replace z_a18  = 563 if reibel_18 ==147 & election_year ==1907 & round ==1
replace z_a18  = . if reibel_18 ==158 & election_year ==1907 & round ==1
replace z_a18  = . if reibel_18 ==159 & election_year ==1907 & round ==1
replace z_a18  = 35295 if reibel_18 ==172 & election_year ==1907 & round ==1
replace z_a18  = 33905 if reibel_18 ==183 & election_year ==1907 & round ==1
replace z_a18  = 22246 if reibel_18 ==184 & election_year ==1907 & round ==1
replace z_a18  = 10121 if reibel_18 ==187 & election_year ==1907 & round ==1
replace z_a18  = 4683 if reibel_18 ==192 & election_year ==1907 & round ==1
replace z_a18  = 57 if reibel_18 ==200 & election_year ==1907 & round ==1
replace z_a18  = 51483 if reibel_18 ==400 & election_year ==1907 & round ==1
replace z_a18  = 14244 if reibel_18 ==206 & election_year ==1907 & round ==1
replace z_a18  = 6094 if reibel_18 ==207 & election_year ==1907 & round ==1
replace z_a18  = 6244 if reibel_18 ==208 & election_year ==1907 & round ==1
replace z_a18  = 30293 if reibel_18 ==210 & election_year ==1907 & round ==1
replace z_a18  = 39634 if reibel_18 ==211 & election_year ==1907 & round ==1
replace z_a18  = 27322 if reibel_18 ==212 & election_year ==1907 & round ==1
replace z_a18  = 16151 if reibel_18 ==218 & election_year ==1907 & round ==1
replace z_a18  = 20176 if reibel_18 ==237 & election_year ==1907 & round ==1
replace z_a18  = 5394 if reibel_18 ==238 & election_year ==1907 & round ==1
replace z_a18  = 3036 if reibel_18 ==267 & election_year ==1907 & round ==1
replace z_a18  = 93 if reibel_18 ==288 & election_year ==1907 & round ==1
replace z_a18  = 1173 if reibel_18 ==289 & election_year ==1907 & round ==1
replace z_a18  = 65 if reibel_18 ==290 & election_year ==1907 & round ==1
replace z_a18  = 571 if reibel_18 ==401 & election_year ==1907 & round ==1
replace z_a18  = 155 if reibel_18 ==300 & election_year ==1907 & round ==1
replace z_a18  = 2417 if reibel_18 ==308 & election_year ==1907 & round ==1
replace z_a18  = 80 if reibel_18 ==309 & election_year ==1907 & round ==1
replace z_a18  = 8173 if reibel_18 ==335 & election_year ==1907 & round ==1
replace z_a18  = . if reibel_18 ==379 & election_year ==1907 & round ==1
replace z_a18  = 1493 if reibel_18 ==402 & election_year ==1907 & round ==1
replace polen_a18  = 2869 if reibel_18 ==398 & election_year ==1907 & round ==1
replace polen_a18  = 428 if reibel_18 ==42 & election_year ==1907 & round ==1
replace polen_a18  = 930 if reibel_18 ==46 & election_year ==1907 & round ==1
replace polen_a18  = 241 if reibel_18 ==399 & election_year ==1907 & round ==1
replace polen_a18  = . if reibel_18 ==93 & election_year ==1907 & round ==1
replace polen_a18  = 26414 if reibel_18 ==103 & election_year ==1907 & round ==1
replace polen_a18  = 27002 if reibel_18 ==104 & election_year ==1907 & round ==1
replace polen_a18  = 51 if reibel_18 ==147 & election_year ==1907 & round ==1
replace polen_a18  = 250 if reibel_18 ==158 & election_year ==1907 & round ==1
replace polen_a18  = . if reibel_18 ==159 & election_year ==1907 & round ==1
replace polen_a18  = 5507 if reibel_18 ==172 & election_year ==1907 & round ==1
replace polen_a18  = 8683 if reibel_18 ==183 & election_year ==1907 & round ==1
replace polen_a18  = 5087 if reibel_18 ==184 & election_year ==1907 & round ==1
replace polen_a18  = . if reibel_18 ==187 & election_year ==1907 & round ==1
replace polen_a18  = . if reibel_18 ==192 & election_year ==1907 & round ==1
replace polen_a18  = . if reibel_18 ==200 & election_year ==1907 & round ==1
replace polen_a18  = 84 if reibel_18 ==400 & election_year ==1907 & round ==1
replace polen_a18  = . if reibel_18 ==206 & election_year ==1907 & round ==1
replace polen_a18  = 76 if reibel_18 ==207 & election_year ==1907 & round ==1
replace polen_a18  = 38 if reibel_18 ==208 & election_year ==1907 & round ==1
replace polen_a18  = 268 if reibel_18 ==210 & election_year ==1907 & round ==1
replace polen_a18  = 2540 if reibel_18 ==211 & election_year ==1907 & round ==1
replace polen_a18  = 5455 if reibel_18 ==212 & election_year ==1907 & round ==1
replace spd_a18  = 258219 if reibel_18 ==398 & election_year ==1907 & round ==1
replace spd_a18  = 50858 if reibel_18 ==42 & election_year ==1907 & round ==1
replace spd_a18  = 104104 if reibel_18 ==46 & election_year ==1907 & round ==1
replace spd_a18  = 37867 if reibel_18 ==399 & election_year ==1907 & round ==1
replace spd_a18  = 6067 if reibel_18 ==93 & election_year ==1907 & round ==1
replace spd_a18  = 5974 if reibel_18 ==103 & election_year ==1907 & round ==1
replace spd_a18  = 5665 if reibel_18 ==104 & election_year ==1907 & round ==1
replace spd_a18  = 33008 if reibel_18 ==147 & election_year ==1907 & round ==1
replace spd_a18  = 37956 if reibel_18 ==158 & election_year ==1907 & round ==1
replace spd_a18  = 9241 if reibel_18 ==159 & election_year ==1907 & round ==1
replace spd_a18  = 11415 if reibel_18 ==172 & election_year ==1907 & round ==1
replace spd_a18  = 42430 if reibel_18 ==183 & election_year ==1907 & round ==1
replace spd_a18  = 38849 if reibel_18 ==184 & election_year ==1907 & round ==1
replace spd_a18  = 15138 if reibel_18 ==187 & election_year ==1907 & round ==1
replace spd_a18  = 36664 if reibel_18 ==192 & election_year ==1907 & round ==1
replace spd_a18  = 11968 if reibel_18 ==200 & election_year ==1907 & round ==1
replace spd_a18  = 38983 if reibel_18 ==400 & election_year ==1907 & round ==1
replace spd_a18  = 2526 if reibel_18 ==206 & election_year ==1907 & round ==1
replace spd_a18  = 20986 if reibel_18 ==207 & election_year ==1907 & round ==1
replace spd_a18  = 28641 if reibel_18 ==208 & election_year ==1907 & round ==1
replace spd_a18  = 25884 if reibel_18 ==210 & election_year ==1907 & round ==1
replace spd_a18  = 29378 if reibel_18 ==211 & election_year ==1907 & round ==1
replace spd_a18  = 27650 if reibel_18 ==212 & election_year ==1907 & round ==1
replace spd_a18  = 1543 if reibel_18 ==218 & election_year ==1907 & round ==1
replace spd_a18  = 45733 if reibel_18 ==237 & election_year ==1907 & round ==1
replace spd_a18  = 3374 if reibel_18 ==238 & election_year ==1907 & round ==1
replace spd_a18  = 35033 if reibel_18 ==267 & election_year ==1907 & round ==1
replace spd_a18  = 10088 if reibel_18 ==288 & election_year ==1907 & round ==1
replace spd_a18  = 51138 if reibel_18 ==289 & election_year ==1907 & round ==1
replace spd_a18  = 18463 if reibel_18 ==290 & election_year ==1907 & round ==1
replace spd_a18  = 71078 if reibel_18 ==401 & election_year ==1907 & round ==1
replace spd_a18  = 34547 if reibel_18 ==300 & election_year ==1907 & round ==1
replace spd_a18  = 30430 if reibel_18 ==308 & election_year ==1907 & round ==1
replace spd_a18  = 10147 if reibel_18 ==309 & election_year ==1907 & round ==1
replace spd_a18  = 25969 if reibel_18 ==335 & election_year ==1907 & round ==1
replace spd_a18  = 27362 if reibel_18 ==379 & election_year ==1907 & round ==1
replace spd_a18  = 112892 if reibel_18 ==402 & election_year ==1907 & round ==1
replace dhp_a18  = 10333 if reibel_18 ==158 & election_year ==1907 & round ==1
replace dhp_a18  = 4218 if reibel_18 ==159 & election_year ==1907 & round ==1
replace dhp_a18  = 36 if reibel_18 ==402 & election_year ==1907 & round ==1
replace divkons_a18  = 780 if reibel_18 ==398 & election_year ==1907 & round ==1
replace divkons_a18  = 12159 if reibel_18 ==158 & election_year ==1907 & round ==1
replace bdl_a18  = 14 if reibel_18 ==158 & election_year ==1907 & round ==1
replace bdl_a18  = 3197 if reibel_18 ==159 & election_year ==1907 & round ==1
replace bdl_a18  = 1142 if reibel_18 ==379 & election_year ==1907 & round ==1
replace ds_a18  = 27 if reibel_18 ==184 & election_year ==1907 & round ==1
replace ds_a18  = . if reibel_18 ==187 & election_year ==1907 & round ==1
replace ds_a18  = . if reibel_18 ==192 & election_year ==1907 & round ==1
replace ds_a18  = . if reibel_18 ==200 & election_year ==1907 & round ==1
replace ds_a18  = 80 if reibel_18 ==400 & election_year ==1907 & round ==1
replace cs_a18  = 21 if reibel_18 ==42 & election_year ==1907 & round ==1
replace cs_a18  = 6916 if reibel_18 ==207 & election_year ==1907 & round ==1
replace cs_a18  = 149 if reibel_18 ==208 & election_year ==1907 & round ==1
replace divlib_a18  = 588 if reibel_18 ==212 & election_year ==1907 & round ==1
replace divlib_a18  = . if reibel_18 ==218 & election_year ==1907 & round ==1
replace divlib_a18  = 18962 if reibel_18 ==237 & election_year ==1907 & round ==1
replace divlib_a18  = 1792 if reibel_18 ==238 & election_year ==1907 & round ==1
replace mittp_a18  = 5056 if reibel_18 ==192 & election_year ==1907 & round ==1
replace mittp_a18  = 44 if reibel_18 ==237 & election_year ==1907 & round ==1
replace mittp_a18  = 4533 if reibel_18 ==267 & election_year ==1907 & round ==1
replace bbb_a18  = 62 if reibel_18 ==237 & election_year ==1907 & round ==1
replace bbb_a18  = 1348 if reibel_18 ==238 & election_year ==1907 & round ==1
replace other_a18  = 263 if reibel_18 ==398 & election_year ==1907 & round ==1
replace other_a18  = 52 if reibel_18 ==42 & election_year ==1907 & round ==1
replace other_a18  = 124 if reibel_18 ==46 & election_year ==1907 & round ==1
replace other_a18  = 80 if reibel_18 ==399 & election_year ==1907 & round ==1
replace other_a18  = 3 if reibel_18 ==93 & election_year ==1907 & round ==1
replace other_a18  = 5 if reibel_18 ==103 & election_year ==1907 & round ==1
replace other_a18  = 13 if reibel_18 ==104 & election_year ==1907 & round ==1
replace other_a18  = 22 if reibel_18 ==147 & election_year ==1907 & round ==1
replace other_a18  = 29 if reibel_18 ==158 & election_year ==1907 & round ==1
replace other_a18  = 11 if reibel_18 ==159 & election_year ==1907 & round ==1
replace other_a18  = 76 if reibel_18 ==172 & election_year ==1907 & round ==1
replace other_a18  = 32 if reibel_18 ==183 & election_year ==1907 & round ==1
replace other_a18  = 12 if reibel_18 ==184 & election_year ==1907 & round ==1
replace other_a18  = 8 if reibel_18 ==187 & election_year ==1907 & round ==1
replace other_a18  = 39 if reibel_18 ==192 & election_year ==1907 & round ==1
replace other_a18  = 24 if reibel_18 ==200 & election_year ==1907 & round ==1
replace other_a18  = 82 if reibel_18 ==400 & election_year ==1907 & round ==1
replace other_a18  = 14 if reibel_18 ==206 & election_year ==1907 & round ==1
replace other_a18  = 26 if reibel_18 ==207 & election_year ==1907 & round ==1
replace other_a18  = 12 if reibel_18 ==208 & election_year ==1907 & round ==1
replace other_a18  = 85 if reibel_18 ==210 & election_year ==1907 & round ==1
replace other_a18  = 21 if reibel_18 ==211 & election_year ==1907 & round ==1
replace other_a18  = 17 if reibel_18 ==212 & election_year ==1907 & round ==1
replace other_a18  = 29 if reibel_18 ==218 & election_year ==1907 & round ==1
replace other_a18  = 86 if reibel_18 ==237 & election_year ==1907 & round ==1
replace other_a18  = 11 if reibel_18 ==238 & election_year ==1907 & round ==1
replace other_a18  = 4 if reibel_18 ==267 & election_year ==1907 & round ==1
replace other_a18  = 10 if reibel_18 ==288 & election_year ==1907 & round ==1
replace other_a18  = 129 if reibel_18 ==289 & election_year ==1907 & round ==1
replace other_a18  = 11 if reibel_18 ==290 & election_year ==1907 & round ==1
replace other_a18  = 58 if reibel_18 ==401 & election_year ==1907 & round ==1
replace other_a18  = 7 if reibel_18 ==300 & election_year ==1907 & round ==1
replace other_a18  = 46 if reibel_18 ==308 & election_year ==1907 & round ==1
replace other_a18  = 15 if reibel_18 ==309 & election_year ==1907 & round ==1
replace other_a18  = 40 if reibel_18 ==335 & election_year ==1907 & round ==1
replace other_a18  = 18 if reibel_18 ==379 & election_year ==1907 & round ==1
replace other_a18  = 204 if reibel_18 ==402 & election_year ==1907 & round ==1
replace pop_a18  = 2071257 if reibel_18 ==398 & election_year ==1912 & round ==1
replace pop_a18  = 529070 if reibel_18 ==42 & election_year ==1912 & round ==1
replace pop_a18  = 1315367 if reibel_18 ==46 & election_year ==1912 & round ==1
replace pop_a18  = 514947 if reibel_18 ==399 & election_year ==1912 & round ==1
replace pop_a18  = 149550 if reibel_18 ==93 & election_year ==1912 & round ==1
replace pop_a18  = 413786 if reibel_18 ==103 & election_year ==1912 & round ==1
replace pop_a18  = 419790 if reibel_18 ==104 & election_year ==1912 & round ==1
replace pop_a18  = 370358 if reibel_18 ==147 & election_year ==1912 & round ==1
replace pop_a18  = 407600 if reibel_18 ==158 & election_year ==1912 & round ==1
replace pop_a18  = 135912 if reibel_18 ==159 & election_year ==1912 & round ==1
replace pop_a18  = 444160 if reibel_18 ==172 & election_year ==1912 & round ==1
replace pop_a18  = 764777 if reibel_18 ==183 & election_year ==1912 & round ==1
replace pop_a18  = 568055 if reibel_18 ==184 & election_year ==1912 & round ==1
replace pop_a18  = 194603 if reibel_18 ==187 & election_year ==1912 & round ==1
replace pop_a18  = 414578 if reibel_18 ==192 & election_year ==1912 & round ==1
replace pop_a18  = 142278 if reibel_18 ==200 & election_year ==1912 & round ==1
replace pop_a18  = 671220 if reibel_18 ==400 & election_year ==1912 & round ==1
replace pop_a18  = 134516 if reibel_18 ==206 & election_year ==1912 & round ==1
replace pop_a18  = 271978 if reibel_18 ==207 & election_year ==1912 & round ==1
replace pop_a18  = 339409 if reibel_18 ==208 & election_year ==1912 & round ==1
replace pop_a18  = 149643 if reibel_18 ==210 & election_year ==1912 & round ==1
replace pop_a18  = 565577 if reibel_18 ==211 & election_year ==1912 & round ==1
replace pop_a18  = 615730 if reibel_18 ==212 & election_year ==1912 & round ==1
replace pop_a18  = 120698 if reibel_18 ==218 & election_year ==1912 & round ==1
replace pop_a18  = 608124 if reibel_18 ==237 & election_year ==1912 & round ==1
replace pop_a18  = 88392 if reibel_18 ==238 & election_year ==1912 & round ==1
replace pop_a18  = 357141 if reibel_18 ==267 & election_year ==1912 & round ==1
replace pop_a18  = 136699 if reibel_18 ==288 & election_year ==1912 & round ==1
replace pop_a18  = 551697 if reibel_18 ==289 & election_year ==1912 & round ==1
replace pop_a18  = 182110 if reibel_18 ==290 & election_year ==1912 & round ==1
replace pop_a18  = 763689 if reibel_18 ==401 & election_year ==1912 & round ==1
replace pop_a18  = 358786 if reibel_18 ==300 & election_year ==1912 & round ==1
replace pop_a18  = 340564 if reibel_18 ==308 & election_year ==1912 & round ==1
replace pop_a18  = 155442 if reibel_18 ==309 & election_year ==1912 & round ==1
replace pop_a18  = 295835 if reibel_18 ==335 & election_year ==1912 & round ==1
replace pop_a18  = 299526 if reibel_18 ==379 & election_year ==1912 & round ==1
replace pop_a18  = 1014664 if reibel_18 ==402 & election_year ==1912 & round ==1
replace electorate_a18  = 523702 if reibel_18 ==398 & election_year ==1912 & round ==1
replace electorate_a18  = 136712 if reibel_18 ==42 & election_year ==1912 & round ==1
replace electorate_a18  = 339200 if reibel_18 ==46 & election_year ==1912 & round ==1
replace electorate_a18  = 109116 if reibel_18 ==399 & election_year ==1912 & round ==1
replace electorate_a18  = 30036 if reibel_18 ==93 & election_year ==1912 & round ==1
replace electorate_a18  = 77314 if reibel_18 ==103 & election_year ==1912 & round ==1
replace electorate_a18  = 79126 if reibel_18 ==104 & election_year ==1912 & round ==1
replace electorate_a18  = 82039 if reibel_18 ==147 & election_year ==1912 & round ==1
replace electorate_a18  = 97379 if reibel_18 ==158 & election_year ==1912 & round ==1
replace electorate_a18  = 31469 if reibel_18 ==159 & election_year ==1912 & round ==1
replace electorate_a18  = 92533 if reibel_18 ==172 & election_year ==1912 & round ==1
replace electorate_a18  = 162995 if reibel_18 ==183 & election_year ==1912 & round ==1
replace electorate_a18  = 125551 if reibel_18 ==184 & election_year ==1912 & round ==1
replace electorate_a18  = 47812 if reibel_18 ==187 & election_year ==1912 & round ==1
replace electorate_a18  = 107458 if reibel_18 ==192 & election_year ==1912 & round ==1
replace electorate_a18  = 34138 if reibel_18 ==200 & election_year ==1912 & round ==1
replace electorate_a18  = 161205 if reibel_18 ==400 & election_year ==1912 & round ==1
replace electorate_a18  = 30458 if reibel_18 ==206 & election_year ==1912 & round ==1
replace electorate_a18  = 63878 if reibel_18 ==207 & election_year ==1912 & round ==1
replace electorate_a18  = 77457 if reibel_18 ==208 & election_year ==1912 & round ==1
replace electorate_a18  = 112650 if reibel_18 ==210 & election_year ==1912 & round ==1
replace electorate_a18  = 124551 if reibel_18 ==211 & election_year ==1912 & round ==1
replace electorate_a18  = 126929 if reibel_18 ==212 & election_year ==1912 & round ==1
replace electorate_a18  = 26917 if reibel_18 ==218 & election_year ==1912 & round ==1
replace electorate_a18  = 142426 if reibel_18 ==237 & election_year ==1912 & round ==1
replace electorate_a18  = 21125 if reibel_18 ==238 & election_year ==1912 & round ==1
replace electorate_a18  = 81200 if reibel_18 ==267 & election_year ==1912 & round ==1
replace electorate_a18  = 29606 if reibel_18 ==288 & election_year ==1912 & round ==1
replace electorate_a18  = 123468 if reibel_18 ==289 & election_year ==1912 & round ==1
replace electorate_a18  = 39893 if reibel_18 ==290 & election_year ==1912 & round ==1
replace electorate_a18  = 180460 if reibel_18 ==401 & election_year ==1912 & round ==1
replace electorate_a18  = 78912 if reibel_18 ==300 & election_year ==1912 & round ==1
replace electorate_a18  = 82373 if reibel_18 ==308 & election_year ==1912 & round ==1
replace electorate_a18  = 34671 if reibel_18 ==309 & election_year ==1912 & round ==1
replace electorate_a18  = 66311 if reibel_18 ==335 & election_year ==1912 & round ==1
replace electorate_a18  = 74449 if reibel_18 ==379 & election_year ==1912 & round ==1
replace electorate_a18  = 261177 if reibel_18 ==402 & election_year ==1912 & round ==1
replace voters_a18  = 433832 if reibel_18 ==398 & election_year ==1912 & round ==1
replace voters_a18  = 116805 if reibel_18 ==42 & election_year ==1912 & round ==1
replace voters_a18  = 280258 if reibel_18 ==46 & election_year ==1912 & round ==1
replace voters_a18  = 94076 if reibel_18 ==399 & election_year ==1912 & round ==1
replace voters_a18  = 26081 if reibel_18 ==93 & election_year ==1912 & round ==1
replace voters_a18  = 55532 if reibel_18 ==103 & election_year ==1912 & round ==1
replace voters_a18  = 59532 if reibel_18 ==104 & election_year ==1912 & round ==1
replace voters_a18  = 73593 if reibel_18 ==147 & election_year ==1912 & round ==1
replace voters_a18  = 86006 if reibel_18 ==158 & election_year ==1912 & round ==1
replace voters_a18  = 28034 if reibel_18 ==159 & election_year ==1912 & round ==1
replace voters_a18  = 78049 if reibel_18 ==172 & election_year ==1912 & round ==1
replace voters_a18  = 145282 if reibel_18 ==183 & election_year ==1912 & round ==1
replace voters_a18  = 109463 if reibel_18 ==184 & election_year ==1912 & round ==1
replace voters_a18  = 41081 if reibel_18 ==187 & election_year ==1912 & round ==1
replace voters_a18  = 90757 if reibel_18 ==192 & election_year ==1912 & round ==1
replace voters_a18  = 30834 if reibel_18 ==200 & election_year ==1912 & round ==1
replace voters_a18  = 127706 if reibel_18 ==400 & election_year ==1912 & round ==1
replace voters_a18  = 26896 if reibel_18 ==206 & election_year ==1912 & round ==1
replace voters_a18  = 57244 if reibel_18 ==207 & election_year ==1912 & round ==1
replace voters_a18  = 69356 if reibel_18 ==208 & election_year ==1912 & round ==1
replace voters_a18  = 87352 if reibel_18 ==210 & election_year ==1912 & round ==1
replace voters_a18  = 114041 if reibel_18 ==211 & election_year ==1912 & round ==1
replace voters_a18  = 111088 if reibel_18 ==212 & election_year ==1912 & round ==1
replace voters_a18  = 21937 if reibel_18 ==218 & election_year ==1912 & round ==1
replace voters_a18  = 115074 if reibel_18 ==237 & election_year ==1912 & round ==1
replace voters_a18  = 15143 if reibel_18 ==238 & election_year ==1912 & round ==1
replace voters_a18  = 70484 if reibel_18 ==267 & election_year ==1912 & round ==1
replace voters_a18  = 26696 if reibel_18 ==288 & election_year ==1912 & round ==1
replace voters_a18  = 110105 if reibel_18 ==289 & election_year ==1912 & round ==1
replace voters_a18  = 36682 if reibel_18 ==290 & election_year ==1912 & round ==1
replace voters_a18  = 159201 if reibel_18 ==401 & election_year ==1912 & round ==1
replace voters_a18  = 65764 if reibel_18 ==300 & election_year ==1912 & round ==1
replace voters_a18  = 73331 if reibel_18 ==308 & election_year ==1912 & round ==1
replace voters_a18  = 29232 if reibel_18 ==309 & election_year ==1912 & round ==1
replace voters_a18  = 57460 if reibel_18 ==335 & election_year ==1912 & round ==1
replace voters_a18  = 67414 if reibel_18 ==379 & election_year ==1912 & round ==1
replace voters_a18  = 226863 if reibel_18 ==402 & election_year ==1912 & round ==1
replace valid_a18  = 421724 if reibel_18 ==398 & election_year ==1912 & round ==1
replace valid_a18  = 116143 if reibel_18 ==42 & election_year ==1912 & round ==1
replace valid_a18  = 279018 if reibel_18 ==46 & election_year ==1912 & round ==1
replace valid_a18  = 93782 if reibel_18 ==399 & election_year ==1912 & round ==1
replace valid_a18  = 26001 if reibel_18 ==93 & election_year ==1912 & round ==1
replace valid_a18  = 55348 if reibel_18 ==103 & election_year ==1912 & round ==1
replace valid_a18  = 59354 if reibel_18 ==104 & election_year ==1912 & round ==1
replace valid_a18  = 73320 if reibel_18 ==147 & election_year ==1912 & round ==1
replace valid_a18  = 85769 if reibel_18 ==158 & election_year ==1912 & round ==1
replace valid_a18  = 27933 if reibel_18 ==159 & election_year ==1912 & round ==1
replace valid_a18  = 77895 if reibel_18 ==172 & election_year ==1912 & round ==1
replace valid_a18  = 144886 if reibel_18 ==183 & election_year ==1912 & round ==1
replace valid_a18  = 109016 if reibel_18 ==184 & election_year ==1912 & round ==1
replace valid_a18  = 41575 if reibel_18 ==187 & election_year ==1912 & round ==1
replace valid_a18  = 90458 if reibel_18 ==192 & election_year ==1912 & round ==1
replace valid_a18  = 30666 if reibel_18 ==200 & election_year ==1912 & round ==1
replace valid_a18  = 127244 if reibel_18 ==400 & election_year ==1912 & round ==1
replace valid_a18  = 26835 if reibel_18 ==206 & election_year ==1912 & round ==1
replace valid_a18  = 57028 if reibel_18 ==207 & election_year ==1912 & round ==1
replace valid_a18  = 69047 if reibel_18 ==208 & election_year ==1912 & round ==1
replace valid_a18  = 87188 if reibel_18 ==210 & election_year ==1912 & round ==1
replace valid_a18  = 113610 if reibel_18 ==211 & election_year ==1912 & round ==1
replace valid_a18  = 110733 if reibel_18 ==212 & election_year ==1912 & round ==1
replace valid_a18  = 21864 if reibel_18 ==218 & election_year ==1912 & round ==1
replace valid_a18  = 114604 if reibel_18 ==237 & election_year ==1912 & round ==1
replace valid_a18  = 15065 if reibel_18 ==238 & election_year ==1912 & round ==1
replace valid_a18  = 70194 if reibel_18 ==267 & election_year ==1912 & round ==1
replace valid_a18  = 26609 if reibel_18 ==288 & election_year ==1912 & round ==1
replace valid_a18  = 109399 if reibel_18 ==289 & election_year ==1912 & round ==1
replace valid_a18  = 36484 if reibel_18 ==290 & election_year ==1912 & round ==1
replace valid_a18  = 158325 if reibel_18 ==401 & election_year ==1912 & round ==1
replace valid_a18  = 65500 if reibel_18 ==300 & election_year ==1912 & round ==1
replace valid_a18  = 73593 if reibel_18 ==308 & election_year ==1912 & round ==1
replace valid_a18  = 29143 if reibel_18 ==309 & election_year ==1912 & round ==1
replace valid_a18  = 57214 if reibel_18 ==335 & election_year ==1912 & round ==1
replace valid_a18  = 67128 if reibel_18 ==379 & election_year ==1912 & round ==1
replace valid_a18  = 225839 if reibel_18 ==402 & election_year ==1912 & round ==1
replace dtkp_a18  = 14197 if reibel_18 ==398 & election_year ==1912 & round ==1
replace dtkp_a18  = 19078 if reibel_18 ==42 & election_year ==1912 & round ==1
replace dtkp_a18  = 29235 if reibel_18 ==46 & election_year ==1912 & round ==1
replace dtkp_a18  = 10822 if reibel_18 ==399 & election_year ==1912 & round ==1
replace dtkp_a18  = 9947 if reibel_18 ==93 & election_year ==1912 & round ==1
replace dtkp_a18  = . if reibel_18 ==103 & election_year ==1912 & round ==1
replace dtkp_a18  = . if reibel_18 ==104 & election_year ==1912 & round ==1
replace dtkp_a18  = 5199 if reibel_18 ==147 & election_year ==1912 & round ==1
replace dtkp_a18  = . if reibel_18 ==158 & election_year ==1912 & round ==1
replace dtkp_a18  = . if reibel_18 ==159 & election_year ==1912 & round ==1
replace dtkp_a18  = 6383 if reibel_18 ==172 & election_year ==1912 & round ==1
replace dtkp_a18  = . if reibel_18 ==183 & election_year ==1912 & round ==1
replace dtkp_a18  = . if reibel_18 ==184 & election_year ==1912 & round ==1
replace dtkp_a18  = . if reibel_18 ==187 & election_year ==1912 & round ==1
replace dtkp_a18  = 123 if reibel_18 ==192 & election_year ==1912 & round ==1
replace dtkp_a18  = 3996 if reibel_18 ==200 & election_year ==1912 & round ==1
replace dtkp_a18  = . if reibel_18 ==400 & election_year ==1912 & round ==1
replace dtkp_a18  = 254 if reibel_18 ==206 & election_year ==1912 & round ==1
replace dtkp_a18  = . if reibel_18 ==207 & election_year ==1912 & round ==1
replace dtkp_a18  = . if reibel_18 ==208 & election_year ==1912 & round ==1
replace dtkp_a18  = . if reibel_18 ==210 & election_year ==1912 & round ==1
replace dtkp_a18  = . if reibel_18 ==211 & election_year ==1912 & round ==1
replace dtkp_a18  = 1546 if reibel_18 ==212 & election_year ==1912 & round ==1
replace dtkp_a18  = . if reibel_18 ==218 & election_year ==1912 & round ==1
replace dtkp_a18  = 1081 if reibel_18 ==237 & election_year ==1912 & round ==1
replace dtkp_a18  = 26 if reibel_18 ==238 & election_year ==1912 & round ==1
replace dtkp_a18  = . if reibel_18 ==267 & election_year ==1912 & round ==1
replace dtkp_a18  = . if reibel_18 ==288 & election_year ==1912 & round ==1
replace dtkp_a18  = 2988 if reibel_18 ==289 & election_year ==1912 & round ==1
replace dtkp_a18  = 6289 if reibel_18 ==290 & election_year ==1912 & round ==1
replace dtkp_a18  = . if reibel_18 ==401 & election_year ==1912 & round ==1
replace dtkp_a18  = 6842 if reibel_18 ==300 & election_year ==1912 & round ==1
replace dtkp_a18  = 326 if reibel_18 ==308 & election_year ==1912 & round ==1
replace dtkp_a18  = 6269 if reibel_18 ==309 & election_year ==1912 & round ==1
replace dtkp_a18  = 624 if reibel_18 ==335 & election_year ==1912 & round ==1
replace dtkp_a18  = . if reibel_18 ==379 & election_year ==1912 & round ==1
replace dtkp_a18  = . if reibel_18 ==402 & election_year ==1912 & round ==1
replace drp_a18  = . if reibel_18 ==398 & election_year ==1912 & round ==1
replace drp_a18  = . if reibel_18 ==42 & election_year ==1912 & round ==1
replace drp_a18  = . if reibel_18 ==46 & election_year ==1912 & round ==1
replace drp_a18  = 9026 if reibel_18 ==399 & election_year ==1912 & round ==1
replace drp_a18  = . if reibel_18 ==93 & election_year ==1912 & round ==1
replace drp_a18  = . if reibel_18 ==103 & election_year ==1912 & round ==1
replace drp_a18  = . if reibel_18 ==104 & election_year ==1912 & round ==1
replace drp_a18  = . if reibel_18 ==147 & election_year ==1912 & round ==1
replace drp_a18  = 26 if reibel_18 ==158 & election_year ==1912 & round ==1
replace drp_a18  = 3372 if reibel_18 ==159 & election_year ==1912 & round ==1
replace drp_a18  = 16763 if reibel_18 ==208 & election_year ==1912 & round ==1
replace drp_a18  = 3231 if reibel_18 ==267 & election_year ==1912 & round ==1
replace drp_a18  = . if reibel_18 ==288 & election_year ==1912 & round ==1
replace drp_a18  = . if reibel_18 ==289 & election_year ==1912 & round ==1
replace drp_a18  = . if reibel_18 ==290 & election_year ==1912 & round ==1
replace drp_a18  = 8812 if reibel_18 ==401 & election_year ==1912 & round ==1
replace nlp_a18  = 12085 if reibel_18 ==399 & election_year ==1912 & round ==1
replace nlp_a18  = . if reibel_18 ==93 & election_year ==1912 & round ==1
replace nlp_a18  = 10176 if reibel_18 ==103 & election_year ==1912 & round ==1
replace nlp_a18  = 15170 if reibel_18 ==104 & election_year ==1912 & round ==1
replace nlp_a18  = . if reibel_18 ==147 & election_year ==1912 & round ==1
replace nlp_a18  = 635 if reibel_18 ==158 & election_year ==1912 & round ==1
replace nlp_a18  = 9338 if reibel_18 ==159 & election_year ==1912 & round ==1
replace nlp_a18  = . if reibel_18 ==172 & election_year ==1912 & round ==1
replace nlp_a18  = 43257 if reibel_18 ==183 & election_year ==1912 & round ==1
replace nlp_a18  = 25285 if reibel_18 ==184 & election_year ==1912 & round ==1
replace nlp_a18  = 6199 if reibel_18 ==187 & election_year ==1912 & round ==1
replace nlp_a18  = 4756 if reibel_18 ==192 & election_year ==1912 & round ==1
replace nlp_a18  = 8114 if reibel_18 ==200 & election_year ==1912 & round ==1
replace nlp_a18  = 17100 if reibel_18 ==400 & election_year ==1912 & round ==1
replace nlp_a18  = 2948 if reibel_18 ==206 & election_year ==1912 & round ==1
replace nlp_a18  = . if reibel_18 ==207 & election_year ==1912 & round ==1
replace nlp_a18  = 11543 if reibel_18 ==208 & election_year ==1912 & round ==1
replace nlp_a18  = 12007 if reibel_18 ==210 & election_year ==1912 & round ==1
replace nlp_a18  = 25937 if reibel_18 ==211 & election_year ==1912 & round ==1
replace nlp_a18  = 33934 if reibel_18 ==212 & election_year ==1912 & round ==1
replace nlp_a18  = 1801 if reibel_18 ==218 & election_year ==1912 & round ==1
replace nlp_a18  = . if reibel_18 ==237 & election_year ==1912 & round ==1
replace nlp_a18  = . if reibel_18 ==238 & election_year ==1912 & round ==1
replace nlp_a18  = . if reibel_18 ==267 & election_year ==1912 & round ==1
replace nlp_a18  = . if reibel_18 ==288 & election_year ==1912 & round ==1
replace nlp_a18  = 32790 if reibel_18 ==289 & election_year ==1912 & round ==1
replace nlp_a18  = 8242 if reibel_18 ==290 & election_year ==1912 & round ==1
replace nlp_a18  = 42484 if reibel_18 ==401 & election_year ==1912 & round ==1
replace nlp_a18  = 16506 if reibel_18 ==300 & election_year ==1912 & round ==1
replace nlp_a18  = 32900 if reibel_18 ==308 & election_year ==1912 & round ==1
replace nlp_a18  = 8505 if reibel_18 ==309 & election_year ==1912 & round ==1
replace nlp_a18  = 16136 if reibel_18 ==335 & election_year ==1912 & round ==1
replace nlp_a18  = . if reibel_18 ==379 & election_year ==1912 & round ==1
replace nlp_a18  = 26773 if reibel_18 ==402 & election_year ==1912 & round ==1
replace drefp_a18  = 8567 if reibel_18 ==288 & election_year ==1912 & round ==1
replace drefp_a18  = 5326 if reibel_18 ==289 & election_year ==1912 & round ==1
replace wvg_a18  = 3424 if reibel_18 ==401 & election_year ==1912 & round ==1
replace dfp_a18  = 70811 if reibel_18 ==398 & election_year ==1912 & round ==1
replace dfp_a18  = 12864 if reibel_18 ==42 & election_year ==1912 & round ==1
replace dfp_a18  = 70074 if reibel_18 ==46 & election_year ==1912 & round ==1
replace dfp_a18  = 10473 if reibel_18 ==399 & election_year ==1912 & round ==1
replace dfp_a18  = 2241 if reibel_18 ==93 & election_year ==1912 & round ==1
replace dfp_a18  = . if reibel_18 ==103 & election_year ==1912 & round ==1
replace dfp_a18  = . if reibel_18 ==104 & election_year ==1912 & round ==1
replace dfp_a18  = 28339 if reibel_18 ==147 & election_year ==1912 & round ==1
replace dfp_a18  = 22006 if reibel_18 ==158 & election_year ==1912 & round ==1
replace dfp_a18  = . if reibel_18 ==159 & election_year ==1912 & round ==1
replace dfp_a18  = 51 if reibel_18 ==172 & election_year ==1912 & round ==1
replace dfp_a18  = . if reibel_18 ==183 & election_year ==1912 & round ==1
replace dfp_a18  = . if reibel_18 ==184 & election_year ==1912 & round ==1
replace dfp_a18  = 5364 if reibel_18 ==187 & election_year ==1912 & round ==1
replace dfp_a18  = 32014 if reibel_18 ==192 & election_year ==1912 & round ==1
replace dfp_a18  = . if reibel_18 ==200 & election_year ==1912 & round ==1
replace dfp_a18  = 582 if reibel_18 ==400 & election_year ==1912 & round ==1
replace dfp_a18  = 2942 if reibel_18 ==206 & election_year ==1912 & round ==1
replace dfp_a18  = 15721 if reibel_18 ==207 & election_year ==1912 & round ==1
replace dfp_a18  = 271 if reibel_18 ==208 & election_year ==1912 & round ==1
replace dfp_a18  = . if reibel_18 ==210 & election_year ==1912 & round ==1
replace dfp_a18  = . if reibel_18 ==211 & election_year ==1912 & round ==1
replace dfp_a18  = 2231 if reibel_18 ==212 & election_year ==1912 & round ==1
replace dfp_a18  = . if reibel_18 ==218 & election_year ==1912 & round ==1
replace dfp_a18  = 32530 if reibel_18 ==237 & election_year ==1912 & round ==1
replace dfp_a18  = 20272 if reibel_18 ==267 & election_year ==1912 & round ==1
replace dfp_a18  = 5199 if reibel_18 ==288 & election_year ==1912 & round ==1
replace dfp_a18  = 7164 if reibel_18 ==289 & election_year ==1912 & round ==1
replace dfp_a18  = . if reibel_18 ==290 & election_year ==1912 & round ==1
replace dfp_a18  = 9167 if reibel_18 ==401 & election_year ==1912 & round ==1
replace dfp_a18  = . if reibel_18 ==300 & election_year ==1912 & round ==1
replace dfp_a18  = . if reibel_18 ==308 & election_year ==1912 & round ==1
replace dfp_a18  = . if reibel_18 ==309 & election_year ==1912 & round ==1
replace dfp_a18  = . if reibel_18 ==335 & election_year ==1912 & round ==1
replace dfp_a18  = 27791 if reibel_18 ==379 & election_year ==1912 & round ==1
replace dfp_a18  = 57099 if reibel_18 ==402 & election_year ==1912 & round ==1
replace z_a18  = 8899 if reibel_18 ==398 & election_year ==1912 & round ==1
replace z_a18  = 2182 if reibel_18 ==42 & election_year ==1912 & round ==1
replace z_a18  = 3926 if reibel_18 ==46 & election_year ==1912 & round ==1
replace z_a18  = 276 if reibel_18 ==399 & election_year ==1912 & round ==1
replace z_a18  = 5585 if reibel_18 ==93 & election_year ==1912 & round ==1
replace z_a18  = 12957 if reibel_18 ==103 & election_year ==1912 & round ==1
replace z_a18  = 11358 if reibel_18 ==104 & election_year ==1912 & round ==1
replace z_a18  = 950 if reibel_18 ==147 & election_year ==1912 & round ==1
replace z_a18  = 3024 if reibel_18 ==158 & election_year ==1912 & round ==1
replace z_a18  = . if reibel_18 ==159 & election_year ==1912 & round ==1
replace z_a18  = 40488 if reibel_18 ==172 & election_year ==1912 & round ==1
replace z_a18  = 37650 if reibel_18 ==183 & election_year ==1912 & round ==1
replace z_a18  = 25708 if reibel_18 ==184 & election_year ==1912 & round ==1
replace z_a18  = 9460 if reibel_18 ==187 & election_year ==1912 & round ==1
replace z_a18  = 7015 if reibel_18 ==192 & election_year ==1912 & round ==1
replace z_a18  = 3364 if reibel_18 ==200 & election_year ==1912 & round ==1
replace z_a18  = 57646 if reibel_18 ==400 & election_year ==1912 & round ==1
replace z_a18  = 15162 if reibel_18 ==206 & election_year ==1912 & round ==1
replace z_a18  = . if reibel_18 ==207 & election_year ==1912 & round ==1
replace z_a18  = 6046 if reibel_18 ==208 & election_year ==1912 & round ==1
replace z_a18  = 32730 if reibel_18 ==210 & election_year ==1912 & round ==1
replace z_a18  = 42832 if reibel_18 ==211 & election_year ==1912 & round ==1
replace z_a18  = 31559 if reibel_18 ==212 & election_year ==1912 & round ==1
replace z_a18  = 17005 if reibel_18 ==218 & election_year ==1912 & round ==1
replace z_a18  = 18397 if reibel_18 ==237 & election_year ==1912 & round ==1
replace z_a18  = 5706 if reibel_18 ==238 & election_year ==1912 & round ==1
replace z_a18  = 3892 if reibel_18 ==267 & election_year ==1912 & round ==1
replace z_a18  = 77 if reibel_18 ==288 & election_year ==1912 & round ==1
replace z_a18  = 1140 if reibel_18 ==289 & election_year ==1912 & round ==1
replace z_a18  = 53 if reibel_18 ==290 & election_year ==1912 & round ==1
replace z_a18  = 105 if reibel_18 ==401 & election_year ==1912 & round ==1
replace z_a18  = 144 if reibel_18 ==300 & election_year ==1912 & round ==1
replace z_a18  = 2034 if reibel_18 ==308 & election_year ==1912 & round ==1
replace z_a18  = 230 if reibel_18 ==309 & election_year ==1912 & round ==1
replace z_a18  = 8842 if reibel_18 ==335 & election_year ==1912 & round ==1
replace z_a18  = . if reibel_18 ==379 & election_year ==1912 & round ==1
replace z_a18  = 1738 if reibel_18 ==402 & election_year ==1912 & round ==1
replace polen_a18  = 2759 if reibel_18 ==398 & election_year ==1912 & round ==1
replace polen_a18  = 492 if reibel_18 ==42 & election_year ==1912 & round ==1
replace polen_a18  = 941 if reibel_18 ==46 & election_year ==1912 & round ==1
replace polen_a18  = 187 if reibel_18 ==399 & election_year ==1912 & round ==1
replace polen_a18  = . if reibel_18 ==93 & election_year ==1912 & round ==1
replace polen_a18  = 20671 if reibel_18 ==103 & election_year ==1912 & round ==1
replace polen_a18  = 17913 if reibel_18 ==104 & election_year ==1912 & round ==1
replace polen_a18  = 91 if reibel_18 ==147 & election_year ==1912 & round ==1
replace polen_a18  = 234 if reibel_18 ==158 & election_year ==1912 & round ==1
replace polen_a18  = . if reibel_18 ==159 & election_year ==1912 & round ==1
replace polen_a18  = 7748 if reibel_18 ==172 & election_year ==1912 & round ==1
replace polen_a18  = 10630 if reibel_18 ==183 & election_year ==1912 & round ==1
replace polen_a18  = 6878 if reibel_18 ==184 & election_year ==1912 & round ==1
replace polen_a18  = . if reibel_18 ==187 & election_year ==1912 & round ==1
replace polen_a18  = . if reibel_18 ==192 & election_year ==1912 & round ==1
replace polen_a18  = . if reibel_18 ==200 & election_year ==1912 & round ==1
replace polen_a18  = 212 if reibel_18 ==400 & election_year ==1912 & round ==1
replace polen_a18  = 1 if reibel_18 ==206 & election_year ==1912 & round ==1
replace polen_a18  = 155 if reibel_18 ==207 & election_year ==1912 & round ==1
replace polen_a18  = . if reibel_18 ==208 & election_year ==1912 & round ==1
replace polen_a18  = 507 if reibel_18 ==210 & election_year ==1912 & round ==1
replace polen_a18  = 3744 if reibel_18 ==211 & election_year ==1912 & round ==1
replace polen_a18  = 7270 if reibel_18 ==212 & election_year ==1912 & round ==1
replace polen_a18  = 42 if reibel_18 ==401 & election_year ==1912 & round ==1
replace polen_a18  = . if reibel_18 ==300 & election_year ==1912 & round ==1
replace polen_a18  = . if reibel_18 ==308 & election_year ==1912 & round ==1
replace polen_a18  = . if reibel_18 ==309 & election_year ==1912 & round ==1
replace polen_a18  = 46 if reibel_18 ==335 & election_year ==1912 & round ==1
replace polen_a18  = 58 if reibel_18 ==379 & election_year ==1912 & round ==1
replace polen_a18  = 173 if reibel_18 ==402 & election_year ==1912 & round ==1
replace spd_a18  = 318959 if reibel_18 ==398 & election_year ==1912 & round ==1
replace spd_a18  = 81370 if reibel_18 ==42 & election_year ==1912 & round ==1
replace spd_a18  = 163757 if reibel_18 ==46 & election_year ==1912 & round ==1
replace spd_a18  = 50127 if reibel_18 ==399 & election_year ==1912 & round ==1
replace spd_a18  = 8208 if reibel_18 ==93 & election_year ==1912 & round ==1
replace spd_a18  = 11534 if reibel_18 ==103 & election_year ==1912 & round ==1
replace spd_a18  = 14904 if reibel_18 ==104 & election_year ==1912 & round ==1
replace spd_a18  = 38709 if reibel_18 ==147 & election_year ==1912 & round ==1
replace spd_a18  = 46121 if reibel_18 ==158 & election_year ==1912 & round ==1
replace spd_a18  = 12021 if reibel_18 ==159 & election_year ==1912 & round ==1
replace spd_a18  = 21245 if reibel_18 ==172 & election_year ==1912 & round ==1
replace spd_a18  = 53333 if reibel_18 ==183 & election_year ==1912 & round ==1
replace spd_a18  = 48838 if reibel_18 ==184 & election_year ==1912 & round ==1
replace spd_a18  = 19068 if reibel_18 ==187 & election_year ==1912 & round ==1
replace spd_a18  = 45239 if reibel_18 ==192 & election_year ==1912 & round ==1
replace spd_a18  = 15177 if reibel_18 ==200 & election_year ==1912 & round ==1
replace spd_a18  = 49916 if reibel_18 ==400 & election_year ==1912 & round ==1
replace spd_a18  = 4965 if reibel_18 ==206 & election_year ==1912 & round ==1
replace spd_a18  = 26658 if reibel_18 ==207 & election_year ==1912 & round ==1
replace spd_a18  = 34106 if reibel_18 ==208 & election_year ==1912 & round ==1
replace spd_a18  = 37616 if reibel_18 ==210 & election_year ==1912 & round ==1
replace spd_a18  = 40503 if reibel_18 ==211 & election_year ==1912 & round ==1
replace spd_a18  = 34187 if reibel_18 ==212 & election_year ==1912 & round ==1
replace spd_a18  = 3021 if reibel_18 ==218 & election_year ==1912 & round ==1
replace spd_a18  = 62505 if reibel_18 ==237 & election_year ==1912 & round ==1
replace spd_a18  = 5690 if reibel_18 ==238 & election_year ==1912 & round ==1
replace spd_a18  = 42585 if reibel_18 ==267 & election_year ==1912 & round ==1
replace spd_a18  = 12763 if reibel_18 ==288 & election_year ==1912 & round ==1
replace spd_a18  = 59958 if reibel_18 ==289 & election_year ==1912 & round ==1
replace spd_a18  = 21888 if reibel_18 ==290 & election_year ==1912 & round ==1
replace spd_a18  = 94124 if reibel_18 ==401 & election_year ==1912 & round ==1
replace spd_a18  = 42000 if reibel_18 ==300 & election_year ==1912 & round ==1
replace spd_a18  = 38302 if reibel_18 ==308 & election_year ==1912 & round ==1
replace spd_a18  = 14126 if reibel_18 ==309 & election_year ==1912 & round ==1
replace spd_a18  = 31560 if reibel_18 ==335 & election_year ==1912 & round ==1
replace spd_a18  = 35862 if reibel_18 ==379 & election_year ==1912 & round ==1
replace spd_a18  = 138343 if reibel_18 ==402 & election_year ==1912 & round ==1
replace dhp_a18  = 9777 if reibel_18 ==158 & election_year ==1912 & round ==1
replace dhp_a18  = 3193 if reibel_18 ==159 & election_year ==1912 & round ==1
replace divkons_a18  = 3899 if reibel_18 ==158 & election_year ==1912 & round ==1
replace cs_a18  = 3087 if reibel_18 ==398 & election_year ==1912 & round ==1
replace cs_a18  = . if reibel_18 ==42 & election_year ==1912 & round ==1
replace cs_a18  = 807 if reibel_18 ==46 & election_year ==1912 & round ==1
replace cs_a18  = . if reibel_18 ==399 & election_year ==1912 & round ==1
replace cs_a18  = . if reibel_18 ==93 & election_year ==1912 & round ==1
replace cs_a18  = . if reibel_18 ==103 & election_year ==1912 & round ==1
replace cs_a18  = . if reibel_18 ==104 & election_year ==1912 & round ==1
replace cs_a18  = . if reibel_18 ==147 & election_year ==1912 & round ==1
replace cs_a18  = . if reibel_18 ==158 & election_year ==1912 & round ==1
replace cs_a18  = . if reibel_18 ==159 & election_year ==1912 & round ==1
replace cs_a18  = 1942 if reibel_18 ==172 & election_year ==1912 & round ==1
replace cs_a18  = . if reibel_18 ==183 & election_year ==1912 & round ==1
replace cs_a18  = 1570 if reibel_18 ==184 & election_year ==1912 & round ==1
replace cs_a18  = . if reibel_18 ==187 & election_year ==1912 & round ==1
replace cs_a18  = 1289 if reibel_18 ==192 & election_year ==1912 & round ==1
replace cs_a18  = . if reibel_18 ==200 & election_year ==1912 & round ==1
replace cs_a18  = 535 if reibel_18 ==400 & election_year ==1912 & round ==1
replace cs_a18  = 538 if reibel_18 ==206 & election_year ==1912 & round ==1
replace cs_a18  = 14481 if reibel_18 ==207 & election_year ==1912 & round ==1
replace cs_a18  = 307 if reibel_18 ==208 & election_year ==1912 & round ==1
replace cs_a18  = 2332 if reibel_18 ==210 & election_year ==1912 & round ==1
replace cs_a18  = 578 if reibel_18 ==211 & election_year ==1912 & round ==1
replace cs_a18  = 3397 if reibel_18 ==379 & election_year ==1912 & round ==1
replace cs_a18  = . if reibel_18 ==402 & election_year ==1912 & round ==1
replace divlib_a18  = 1430 if reibel_18 ==398 & election_year ==1912 & round ==1
replace divlib_a18  = 85 if reibel_18 ==42 & election_year ==1912 & round ==1
replace divlib_a18  = 9814 if reibel_18 ==46 & election_year ==1912 & round ==1
replace divlib_a18  = 642 if reibel_18 ==399 & election_year ==1912 & round ==1
replace divlib_a18  = . if reibel_18 ==93 & election_year ==1912 & round ==1
replace divlib_a18  = . if reibel_18 ==103 & election_year ==1912 & round ==1
replace divlib_a18  = . if reibel_18 ==104 & election_year ==1912 & round ==1
replace divlib_a18  = . if reibel_18 ==147 & election_year ==1912 & round ==1
replace divlib_a18  = . if reibel_18 ==158 & election_year ==1912 & round ==1
replace divlib_a18  = . if reibel_18 ==159 & election_year ==1912 & round ==1
replace divlib_a18  = . if reibel_18 ==172 & election_year ==1912 & round ==1
replace divlib_a18  = . if reibel_18 ==183 & election_year ==1912 & round ==1
replace divlib_a18  = 717 if reibel_18 ==184 & election_year ==1912 & round ==1
replace divlib_a18  = . if reibel_18 ==187 & election_year ==1912 & round ==1
replace divlib_a18  = . if reibel_18 ==192 & election_year ==1912 & round ==1
replace divlib_a18  = . if reibel_18 ==200 & election_year ==1912 & round ==1
replace divlib_a18  = 1161 if reibel_18 ==400 & election_year ==1912 & round ==1
replace divlib_a18  = . if reibel_18 ==206 & election_year ==1912 & round ==1
replace divlib_a18  = . if reibel_18 ==207 & election_year ==1912 & round ==1
replace divlib_a18  = . if reibel_18 ==208 & election_year ==1912 & round ==1
replace divlib_a18  = 1978 if reibel_18 ==210 & election_year ==1912 & round ==1
replace divlib_a18  = 2318 if reibel_18 ==238 & election_year ==1912 & round ==1
replace ds_a18  = 1327 if reibel_18 ==398 & election_year ==1912 & round ==1
replace ds_a18  = 1572 if reibel_18 ==402 & election_year ==1912 & round ==1
replace bbb_a18  = 30 if reibel_18 ==237 & election_year ==1912 & round ==1
replace bbb_a18  = 1319 if reibel_18 ==238 & election_year ==1912 & round ==1
replace bbb_a18  = 206 if reibel_18 ==267 & election_year ==1912 & round ==1
replace undeclared_a18  = . if reibel_18 ==398 & election_year ==1912 & round ==1
replace undeclared_a18  = . if reibel_18 ==42 & election_year ==1912 & round ==1
replace undeclared_a18  = 363 if reibel_18 ==46 & election_year ==1912 & round ==1
replace other_a18  = 255 if reibel_18 ==398 & election_year ==1912 & round ==1
replace other_a18  = 72 if reibel_18 ==42 & election_year ==1912 & round ==1
replace other_a18  = 101 if reibel_18 ==46 & election_year ==1912 & round ==1
replace other_a18  = 84 if reibel_18 ==399 & election_year ==1912 & round ==1
replace other_a18  = 20 if reibel_18 ==93 & election_year ==1912 & round ==1
replace other_a18  = 10 if reibel_18 ==103 & election_year ==1912 & round ==1
replace other_a18  = 9 if reibel_18 ==104 & election_year ==1912 & round ==1
replace other_a18  = 32 if reibel_18 ==147 & election_year ==1912 & round ==1
replace other_a18  = 47 if reibel_18 ==158 & election_year ==1912 & round ==1
replace other_a18  = 9 if reibel_18 ==159 & election_year ==1912 & round ==1
replace other_a18  = 38 if reibel_18 ==172 & election_year ==1912 & round ==1
replace other_a18  = 16 if reibel_18 ==183 & election_year ==1912 & round ==1
replace other_a18  = 20 if reibel_18 ==184 & election_year ==1912 & round ==1
replace other_a18  = 13 if reibel_18 ==187 & election_year ==1912 & round ==1
replace other_a18  = 22 if reibel_18 ==192 & election_year ==1912 & round ==1
replace other_a18  = 15 if reibel_18 ==200 & election_year ==1912 & round ==1
replace other_a18  = 92 if reibel_18 ==400 & election_year ==1912 & round ==1
replace other_a18  = 25 if reibel_18 ==206 & election_year ==1912 & round ==1
replace other_a18  = 13 if reibel_18 ==207 & election_year ==1912 & round ==1
replace other_a18  = 11 if reibel_18 ==208 & election_year ==1912 & round ==1
replace other_a18  = 18 if reibel_18 ==210 & election_year ==1912 & round ==1
replace other_a18  = 16 if reibel_18 ==211 & election_year ==1912 & round ==1
replace other_a18  = 6 if reibel_18 ==212 & election_year ==1912 & round ==1
replace other_a18  = 37 if reibel_18 ==218 & election_year ==1912 & round ==1
replace other_a18  = 61 if reibel_18 ==237 & election_year ==1912 & round ==1
replace other_a18  = 6 if reibel_18 ==238 & election_year ==1912 & round ==1
replace other_a18  = 8 if reibel_18 ==267 & election_year ==1912 & round ==1
replace other_a18  = 3 if reibel_18 ==288 & election_year ==1912 & round ==1
replace other_a18  = 33 if reibel_18 ==289 & election_year ==1912 & round ==1
replace other_a18  = 12 if reibel_18 ==290 & election_year ==1912 & round ==1
replace other_a18  = 167 if reibel_18 ==401 & election_year ==1912 & round ==1
replace other_a18  = 8 if reibel_18 ==300 & election_year ==1912 & round ==1
replace other_a18  = 31 if reibel_18 ==308 & election_year ==1912 & round ==1
replace other_a18  = 13 if reibel_18 ==309 & election_year ==1912 & round ==1
replace other_a18  = 6 if reibel_18 ==335 & election_year ==1912 & round ==1
replace other_a18  = 20 if reibel_18 ==379 & election_year ==1912 & round ==1
replace other_a18  = 141 if reibel_18 ==402 & election_year ==1912 & round ==1

*distribute mandate in multi-member districts to parties (d'Hondt method)
** assuming no joint party lists (assumptions stacks empirical deck against our argument)
**generate ten variables per party on ten highest numbers of votes as per d'Hondt method
foreach var of varlist as - z{
gen `var'_a18_1 = `var'_a18 / 1
gen `var'_a18_2 = `var'_a18 / 2
gen `var'_a18_3 = `var'_a18 / 3
gen `var'_a18_4 = `var'_a18 / 4
gen `var'_a18_5 = `var'_a18 / 5
gen `var'_a18_6 = `var'_a18 / 6
gen `var'_a18_7 = `var'_a18 / 7
gen `var'_a18_8 = `var'_a18 / 8
gen `var'_a18_9 = `var'_a18 / 9
gen `var'_a18_10 = `var'_a18 / 10
}

* variables on ranks of highest numbers for parties
foreach var of varlist as_a18_1 -  z_a18_10{
gen `var'rank = .
}
forval m = 1(1)10{
egen max`m' = rowmax(as_a18_1 - z_a18_10)
foreach var of varlist as_a18_1 -  z_a18_10{
replace `var'rank = `m' if `var' == max`m'
replace `var' = . if `var' == max`m'
}
drop max`m'
}

*conduct d'Hondt procedure for PR districts
foreach var of varlist as_a18_1rank - z_a18_10rank{
replace `var' = . if `var' > magnitude18 | reibel_18 == . | magnitude18 == 1
}

*get 1 variable per party, summing its mandates in PR districts (ONLY valid
** for PR districts)
foreach var of varlist as - z{
egen `var'_mgs = rownonmiss(`var'_a18_1rank - `var'_a18_10rank)
}

*get rid of variables only needed for d'Hondt procedure
drop as_a18_1 - z_a18_10 as_a18_1rank - z_a18_10rank

list election_year reform18 reibel_18 magnitude18 spd_mgs if spd_mgs != . & reform18 ==1 & magnitude >1

//assign single mandates to parties winning mandates in the 11 districts of reduced size that retained 1 mandate, per hand 
*these districts have the following reibel_nummer:
** 93, 159, 187, 200, 206, 207, 218, 238, 288, 290, 309
** if no winner according to first-round results: original winner assumed as winning if no bourgeois alliance (dfp-nlp-drp-dtkp-z) 
list reibel_nummer mandate_single  election_year if reform == 1 & magnitude18 == 1 & election_year == 1912
*1903 
replace dtkp_mgs = 1 if reibel_nummer == 93 & election_year == 1903 // no change in mandate
replace nlp_mgs = 1 if reibel_18 == 159 & election_year ==1903 // winner as per runoff result, no change
replace z_mgs = 1 if reibel_18 == 187 & election_year ==1903   // winner as per runoff, no change
replace nlp_mgs = 1 if reibel_18 == 200 & election_year ==1903 // winner as per runoff, no change
replace z_mgs = 1 if reibel_18 == 206 & election_year ==1903   // no change in mandate
replace spd_mgs = 1 if reibel_18 == 207 & election_year ==1903 // only tiny change in district structure, no change
replace z_mgs = 1 if reibel_18 == 218 & election_year ==1903 // no change in mandate
replace z_mgs = 1 if reibel_nummer == 238 & election_year == 1903 // as per runoff, change
replace spd_mgs = 1 if reibel_nummer == 288 & election_year == 1903 // no change in mandate
replace spd_mgs = 1 if reibel_nummer == 290 & election_year == 1903 //  no change in mandate
replace nlp_mgs = 1 if reibel_nummer == 309 & election_year == 1903 // 1st round majority, change
*1907
replace dtkp_mgs = 1 if reibel_nummer == 93 & election_year == 1907 // no change in mandate
replace nlp_mgs = 1 if reibel_nummer == 159 & election_year == 1907 // winner as per runoff result, no change
replace z_mgs = 1 if reibel_nummer == 187 & election_year == 1907 // winner as per runoff, change
replace nlp_mgs = 1 if reibel_nummer == 200 & election_year == 1907 // winner as per runoff, change
replace z_mgs = 1 if reibel_nummer == 206 & election_year == 1907 // no change in mandate
replace spd_mgs = 1 if reibel_nummer == 207 & election_year == 1907 // only tiny change in district structure, no change
replace z_mgs = 1 if reibel_nummer == 218 & election_year == 1907 // no change in mandate
replace z_mgs = 1 if reibel_nummer == 238 & election_year == 1907 // as per runoff, change
replace drefp_mgs = 1 if reibel_nummer == 288 & election_year == 1907 // as per runoff, Bulow-bloc alliance, change
replace spd_mgs = 1 if reibel_nummer == 290 & election_year == 1907 // no change in mandate
replace nlp_mgs = 1 if reibel_nummer == 309 & election_year == 1907 // 1st round majority, change
*1912
replace dtkp_mgs = 1 if reibel_nummer == 93 & election_year == 1912 // as per runoff, alliance in place no change in mandate, no change
replace nlp_mgs = 1 if reibel_nummer == 159 & election_year == 1912 // winner as per runoff, alliance in place, change
replace spd_mgs = 1 if reibel_nummer == 187 & election_year == 1912 // winner as per runoff, no change in mandate
replace nlp_mgs = 1 if reibel_nummer == 200 & election_year == 1912 // winner as per runoff, alliance in place, change
replace z_mgs = 1 if reibel_nummer == 206 & election_year == 1912 // no change in mandate
replace spd_mgs = 1 if reibel_nummer == 207 & election_year == 1912 // only tiny change in district structure, no change
replace z_mgs = 1 if reibel_nummer == 218 & election_year == 1912 // no change in mandate
replace spd_mgs = 1 if reibel_nummer == 238 & election_year == 1912 // as per runoff, no change in mandate
replace spd_mgs = 1 if reibel_nummer == 288 & election_year == 1912 // as per runoff, no change in mandate
replace spd_mgs = 1 if reibel_nummer == 290 & election_year == 1912 // no change in mandate
replace nlp_mgs = 1 if reibel_nummer == 309 & election_year == 1912 // winner as per runoff, alliance in place, change

*insert mandates into post-reform party-mandate variables for districts
**not affected by reform
foreach var of varlist as - z{
replace `var'_mgs = 1 if `var'_single == mandate_single & reform18 == 0 & reibel_18 != .
}

*calculate mandate-totals post-reform for six major parties
foreach var of varlist as - z{
bysort election_year: egen `var'_m18 = total(`var'_mgs)
}

foreach var of varlist as - z{
bysort election_year staat: egen `var'_m18r = total(`var'_mgs)
}
egen all_m18r = rowtotal(as_m18r - z_m18r)
sort staat reibel_18 election_year

egen all_mgs = rowtotal(as_mgs - z_mgs)
order election_year reibel_18 magnitude18 all_mgs all_m18r spd_mgs dfp_mgs nlp_mgs z_mgs drp_mgs dtkp_mgs drefp_mgs
order as_mgs - wvg_mgs, after(drefp_mgs)
*checks for inconsistencies, lists must be empty
list election_year reibel_18 if all_mgs != all_mgs[_n-1] & reibel_18 == reibel_18[_n-1]
list election_year reibel_18 if all_mgs != all_mgs[_n+1] & reibel_18 == reibel_18[_n+1]

*mandate total post-reform
egen all_m18 = rowtotal(as_m18 - z_m18)

*generate variable on recent mandate, for each party
foreach var of varlist as - z{
gen `var'_mg = 0
replace `var'_mg = 1 if `var'_single == mandate_single
}
*calculate mandate-totals pre-reform for six major parties
foreach var of varlist as - z{
bysort election_year: egen `var'_m18p = total(`var'_mg)
}
*mandate total pre-reform
egen all_m18p = rowtotal(as_m18p - z_m18p)

*list of mandate-totals post-reform (upper list) and pre-reform (lower list), for 3 elections
list election_year all_m18 spd_m18 dfp_m18 nlp_m18 drp_m18 dtkp_m18 z_m18 if lprounderster == 1
list election_year all_m18p spd_m18p dfp_m18p nlp_m18p drp_m18p dtkp_m18p z_m18p if lprounderster == 1

*get shares of mandates post-reform, for six major parties
foreach var of varlist spd dfp nlp drp dtkp z{
gen `var'_m18s = round( `var'_m18 *100 / all_m18, 0.1)
}

*third row in table D-1
list election_year all_m18 spd_m18s dfp_m18s nlp_m18s drp_m18s dtkp_m18s z_m18s if lprounderster == 1

*net gains (in mandates) from reform, for six major parties
foreach var of varlist spd dfp nlp drp dtkp z{
gen `var'_m18gain = `var'_m18  - `var'_m18p
}
*fourth row in table D-1
list election_year all_m18 spd_m18gain dfp_m18gain nlp_m18gain drp_m18gain dtkp_m18gain z_m18gain if lprounderster == 1

*mandates gained in multi-member districts, for six major parties + poles (latter only ethnic party affected)
foreach var of varlist spd dfp nlp drp dtkp z polen{
bysort election_year: egen stub = total(`var'_mgs) if magnitude18 >1 & magnitude18 != .
bysort election_year: egen `var'_mmdc = max(stub)
replace `var'_mmdc = 0 if `var'_mmdc == .
drop stub
}
*fifth row in table D-1
list election_year all_m18 spd_mmdc dfp_mmdc nlp_mmdc drp_mmdc dtkp_mmdc z_mmdc polen_mmdc if lprounderster == 1

*counts districts with more than one mandate, for six major parties
foreach var of varlist spd dfp nlp drp dtkp z polen{
bysort election_year: egen stub = count(`var') if `var'_mgs > 1 & `var'_mgs != .
bysort election_year: egen `var'_mto = max(stub)
replace `var'_mto = 0 if `var'_mto == .
drop stub
}
*sixth row in table D-1
list election_year all_m18 spd_mto dfp_mto nlp_mto drp_mto dtkp_mto z_mto polen_mto if lprounderster == 1 & election_year == 1912

****table D-1 (lower part) - preparation for assembling rows
sort lprounderster election_year 
foreach var of varlist spd dfp nlp drp dtkp z {
gen `var'_tab4 = `var'_m18s if lprounderster == 1
replace `var'_tab4 = `var'_m18gain if lprounderster == 2
replace `var'_tab4 = `var'_mmdc if lprounderster == 3
replace `var'_tab4 = `var'_mto if lprounderster == 4
}

***prepare identifier of measure for later summary as in table D-1
gen measure = "Seat-share (post-reform)" if lprounderster == 1
replace measure = "Seats gained by reform" if lprounderster == 2
replace measure = "Seats in multi-member districts post-reform" if lprounderster == 3
replace measure = "Districts with >1 seat post-reform" if lprounderster == 4

sort election_year lprounderster
****table D-1 (lower part) - final (appendix contains data on 1912 only)
by election_year: list election_year measure spd_tab4  - z_tab4 if spd_tab4 ! = .

**on comment in text as concerns spd gains:
gen spd_gains = spd_mgs - spd_mg if magnitude > 1 & magnitude18 != .
list election_year reibel_nummer magnitude18 spd_gains spd_mgs spd_mg if magnitude18 > 1 & magnitude18 != . & spd_gains >1 


*right-mid section of table D-2
foreach var of varlist spd dfp nlp drp dtkp z polen{
gen `var'_stub = 1 if `var'_mgs != 0 & `var'_mgs >1
}
egen all_stub = rowtotal(spd_stub - polen_stub)
drop spd_stub - polen_stub
gen stub = 1 if all_stub != 0 & all_stub != .
by election_year: egen all_mto = total(stub)
drop stub

list election_year all_mto spd_mto dfp_mto nlp_mto drp_mto dtkp_mto z_mto polen_mto if lprounderster == 1 

*left-mid section of table D-2 (counts of MMDs with 1 mandate gained)
foreach var of varlist spd dfp nlp drp dtkp z polen{
bysort election_year: egen stub = count(`var') if `var'_mgs == 1 & reform18 ==1 & magnitude18 != 1
bysort election_year: egen `var'_mone = max(stub)
replace `var'_mone = 0 if `var'_mone == .
drop stub
}
gen all_mone = 26 - all_mto

list election_year all_mone spd_mone dfp_mone nlp_mone drp_mone dtkp_mone z_mone polen_mone if lprounderster == 1

*left-most section of table D-2
foreach var of varlist spd dfp nlp drp dtkp z polen{
gen `var'_nothing = 26 - `var'_mto - `var'_mone
}
list election_year spd_nothing dfp_nothing nlp_nothing drp_nothing dtkp_nothing z_nothing polen_nothing if lprounderster == 1

*right-most section of table D-2
foreach var of varlist spd dfp nlp drp dtkp z polen{
gen `var'_many = `var'_mmdc - `var'_mone
}
list election_year spd_many dfp_many nlp_many drp_many dtkp_many z_many polen_many if lprounderster == 1

*note on DKP 2-mandate district
list reibel_nummer election_year magnitude spd_mgs nlp_mgs dfp_mgs dtkp_mgs z_mgs polen_mgs drp_mgs if dtkp_mgs > 1 | spd_mgs >1 | dfp_mgs >1 | nlp_mgs >1 | z_mgs > 1 | polen_mgs >1 | drp_mgs >1


****full table D-1 (upper + lower part) as in appendix D: preparation
keep if election_year == 1912 & spd_tab4 != .
keep measure spd_tab4  - z_tab4 
append using results/psrm_tabled1

****full table D-1 (upper + lower part) as in appendix D: results
list spd_pnat dfp_pnat nlp_pnat drp_pnat dtkp_pnat z_pnat if spd_pnat != .
list spd_mco  dfp_mco nlp_mco drp_mco dtkp_mco z_mco if spd_pnat != .
list  measure spd_tab4  - z_tab4 


//// (end Appendix D, table 3)

****table 4 (MPs and candidates in 1912/1919 elections)
use psrm_1912vs1919, replace
gen counter = 1

*1912-MPs running in 1919
sort mandate1912end idpsrm kandidatennummer
gen run19 = 0
replace run19 = 1 if mandate1912end != "" & listenplatz != .
*count of running
by mandate1912end: egen run19c = total(run19)
*share of running (percent)
by mandate1912end: egen mps12c = total(counter)
gen run19p = round(run19c * 100 /mps12c, 0.1)

by mandate1912end: gen mandateerster = _n

****table 4: first two columns
list mandate1912end mps12c run19p if mandateerster ==1 & mandate1912end != ""

*list ranks of sitting MPs 
sort party kandidatennummer idpsrm
by party: egen listmean12e_stub = mean(listenplatz) if kandidatennummer != . &  mandate1912end != ""
by party: egen listmean12e = max(listmean12e_stub)
drop listmean12e_stub

*list ranks of other candidates
by party: egen listmean12n_stub = mean(listenplatz) if kandidatennummer != . &  mandate1912end == ""
by party: egen listmean12n = max(listmean12n_stub)
drop listmean12n_stub

by party: gen partyerster = _n
gen majorfive = 1 if party == "SPD" | party == "DDP" | party == "DVP" | party == "DNVP" | party == "Z"

*success rates of sitting MPs
by party: egen electedcounte_stub = total(electedever) if kandidatennummer != . & mandate1912end != ""
by party: egen electedcounte = max(electedcounte_stub) 
by party: egen runec_stub = total(counter) if kandidatennummer != . & mandate1912end != ""
by party: egen runec = max(runec_stub)
gen successre = round(electedcounte * 100 /runec, 0.1)
drop electedcounte_stub

*success rates of other candidates
by party: egen electedcountn_stub = total(electedever) if kandidatennummer != . & mandate1912end == ""
by party: egen electedcountn = max(electedcountn_stub) 
by party: egen runnc_stub = total(counter) if kandidatennummer != . & mandate1912end == ""
by party: egen runnc = max(runnc_stub)
gen successrn = round(electedcountn * 100 /runnc, 0.1)
drop electedcountn_stub

*return rates
gen return = 0 if mandate1912end != ""
replace return = 1 if mandate1912end != "" & electedever == 1

bysort mandate1912end: egen returnc = total(return)
gen returnrate = round(returnc * 100 / mps12c,0.1)

*counts of mandates for parties
sort party kandidatennummer idpsrm
by party: egen partympcount = total(electedmand)

****table 4: variables related to pre-1919 counts of mandates
list mandate1912end mps12c run19p returnrate if mandateerster ==1 & mandate1912end != ""

****table 4: variables related to 1919 counts of mandates, excepting returnrate (listed above)
list party listmean12e listmean12n successre successrn partympcount if partyerster == 1 & majorfive ==1

//// (end table 4)

****table 5 (district magnitude data pre/post-switch)

use psrm_magnitudes, clear

*table E-1: preparation
list country - popavg_nomination

# delimit ;
label define classlabel 
 1 "No Switch" 2 "Decree" 3 "Parliamentary" 4 "< 15 Million"  
 5 "> 15 Million" 6 "Decree + < 15 Million" 7 "Decree + > 15 Million" 
 8 "Parliamentary +< 15 Million" 9 "Parliamentary +> 15 Million"
;
# delimit cr

gen  class = 1 if procedure == "no Switch"
replace class = 2 if procedure == "decree"
replace class = 3 if procedure == "parliamentary"

append using psrm_magnitudes
replace class = 4 if class == . & populationmill <= 15 & procedure != "no Switch"
replace class = 5 if class == . & populationmill > 15  & procedure != "no Switch"
*remove obs on non-switchers for following
drop if class == . & procedure == "no Switch"
append using psrm_magnitudes
replace class = 6 if class == . & populationmill <= 15 & procedure == "decree"
replace class = 7 if class == . & populationmill > 15 & procedure == "decree"
replace class = 8 if class == . & populationmill <= 15 & procedure == "parliamentary"
replace class = 9 if class == . & populationmill > 15 & procedure == "parliamentary"
*remove obs on non-switchers for following
drop if class == . & procedure == "no Switch"
label values class classlabel

*table 5: averages of population in districts, number of districts and district magnitudes, pre and post-switch
sort class
by class: gen cases  = _N
by class: egen pop = mean(populationmill)

by class: egen predistricts = mean(seatsbefore)
by class: egen postseats = mean(seatsafter)
by class: egen postdistrict_a = mean(districtspost_allocation)
by class: egen postdistrict_n = mean(districtspost_nomination)
by class: egen postmag_a = mean(magavg_allocation)
by class: egen postmag_n = mean(magavg_nomination)
by class: egen postmedian_n = mean(magmedian_nomination)
by class: egen postmin_n = mean(magmin_nomination)
by class: egen postmax_n = mean(magmax_nomination)
by class: egen postpopavg_n = mean(popavg_nomination)
foreach var of varlist pop - postpopavg_n{
replace `var' = round(`var',0.1)
}
by class: keep if _n == 1

*table E-1: preparation, as in paper
list class cases pop - postpopavg_n
putdocx clear
putdocx begin, font(Garamond, 10) landscape
putdocx table table5 = data(class cases pop - postpopavg_n), varnames border(left,nil) border(insideV, nil) border(insideH,nil) border(right,nil)
putdocx table table5(.,.),nformat(%12.1f)
putdocx table table5(.,2),nformat(%12.0f)
putdocx save results/table5.docx, replace

//// (end table 5, table E-1)

*This is it.
log close
log2html psrm_replication.smcl, replace
