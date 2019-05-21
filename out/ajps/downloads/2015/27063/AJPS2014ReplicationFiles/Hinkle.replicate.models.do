**********************************************************
* Replication code for                                   *
* Into the Words: Using Statutory Text to Explore the    *
* Impact of Federal Courts on State Policy Diffusion     *
* Rachael K. Hinkle                                      *
* Forthcoming, AJPS                                      *
* Stata/SE 12.1                                          *
**********************************************************

* Put your working directory here
cd "~/Downloads/AJPS2014ReplicationFiles"

* Open dyadic data
use "Hinkle.AJPS.dyadic.data.dta", clear

********************
** PRIMARY MODELS **
********************

* Adoption Model: Figure 1 and Table 3
probit adopt_i b2.scttrt_fac b2.scirtrt_fac b2.dcirtrt_fac neighbor numpa prevstat_i insession_i electionyr_i init_i init_adopt_j legprof_i legprof_j repcontrol_i repcontrol_j goviddiff abortionex_i abortionex_j population2_i population2_j pcincome2_i pcincome2_j age b2.subtopic2, robust cluster(stateyr) nolog

* Export data necessary to run simulations
matrix coef = e(b)
matrix cov = e(V)
svmat coef, names(coef)
svmat cov, names(cov)
outsheet coef* using "adopt.coef.csv" if cov1!=., comma replace
outsheet cov* using "adopt.covariance.csv" if cov1!=., comma replace
drop cov*
drop coef*

*Borrowed Text Model: Figure 3 and Table 4
regress omperone b2.scttrt_fac b2.scirtrt_fac b2.dcirtrt_fac neighbor numpa prevstat_i electionyr_i init_adopt_i init_adopt_j  legprof_i legprof_j  repcontrol_i repcontrol_j goviddiff tototherbtpa population2_i population2_j pcincome2_i pcincome2_j age wc2_i wc2_j b2.subtopic2, robust cluster(stateyr)

matrix coef = e(b)
matrix cov = e(V)
svmat coef, names(coef)
svmat cov, names(cov)
outsheet coef* using "borrow.coef.csv" if cov1!=., comma replace
outsheet cov* using "borrow.covariance.csv" if cov1!=., comma replace
drop cov*
drop coef*

*************************************
** SUPPLEMENTAL MODELS IN APPENDIX **
*************************************

* Heckman Selection Model: Table 5
heckman omperone b2.scttrt_fac b2.scirtrt_fac b2.dcirtrt_fac neighbor numpa prevstat_i electionyr_i init_adopt_i init_adopt_j  legprof_i legprof_j  repcontrol_i repcontrol_j goviddiff tototherbtpa population2_i population2_j pcincome2_i pcincome2_j age wc2_i wc2_j b2.subtopic2, sel(b2.scttrt_fac b2.scirtrt_fac b2.dcirtrt_fac neighbor numpa prevstat_i insession_i electionyr_i init_i init_adopt_j legprof_i legprof_j repcontrol_i repcontrol_j goviddiff abortionex_i abortionex_j population2_i population2_j pcincome2_i pcincome2_j age b2.subtopic2) robust cluster(stateyr)   level(95) nolog

* Monadic Adoption Model: Table 6
use "Hinkle.AJPS.monadic.data.dta", clear
probit adopt_i b2.scttrt_fac_m b2.scirtrt_fac_m b2.dcirtrt_fac_m propNeighAdopt numpa prevstat_i insession_i electionyr_i init_i legprof_i repcontrol_i abortionex_i population2_i pcincome2_i age b2.subtopic, robust cluster(stateyr) level(95) nolog

* Note: The code to replicate Table 7 is located in the file named "Hinkle.simulation.code.R"


*****************************
** OTHER REFERENCED MODELS **
*****************************

use "Hinkle.AJPS.dyadic.data.dta", clear

*** Iteratively excluding each subtopic from analysis
* Analysis without Partial Birth
probit adopt_i b2.scttrt_fac b2.scirtrt_fac b2.dcirtrt_fac neighbor numpa prevstat_i insession_i electionyr_i init_i init_adopt_j legprof_i legprof_j repcontrol_i repcontrol_j goviddiff abortionex_i abortionex_j population2_i population2_j pcincome2_i pcincome2_j age b2.subtopic2 if subtopic != "pb", robust cluster(stateyr) nolog
regress omperone b2.scttrt_fac b2.scirtrt_fac b2.dcirtrt_fac neighbor numpa prevstat_i electionyr_i init_adopt_i init_adopt_j  legprof_i legprof_j  repcontrol_i repcontrol_j goviddiff tototherbtpa population2_i population2_j pcincome2_i pcincome2_j age wc2_i wc2_j b2.subtopic2 if subtopic != "pb", robust cluster(stateyr)

* Analysis without Public Funding
probit adopt_i b2.scttrt_fac b2.scirtrt_fac b2.dcirtrt_fac neighbor numpa prevstat_i insession_i electionyr_i init_i init_adopt_j legprof_i legprof_j repcontrol_i repcontrol_j goviddiff abortionex_i abortionex_j population2_i population2_j pcincome2_i pcincome2_j age b2.subtopic2 if subtopic != "pf", robust cluster(stateyr) nolog
regress omperone b2.scttrt_fac b2.scirtrt_fac b2.dcirtrt_fac neighbor numpa prevstat_i electionyr_i init_adopt_i init_adopt_j  legprof_i legprof_j  repcontrol_i repcontrol_j goviddiff tototherbtpa population2_i population2_j pcincome2_i pcincome2_j age wc2_i wc2_j b2.subtopic2 if subtopic != "pf", robust cluster(stateyr)

* Analysis without Parental Notice
probit adopt_i b2.scttrt_fac b2.scirtrt_fac b2.dcirtrt_fac neighbor numpa prevstat_i insession_i electionyr_i init_i init_adopt_j legprof_i legprof_j repcontrol_i repcontrol_j goviddiff abortionex_i abortionex_j population2_i population2_j pcincome2_i pcincome2_j age b2.subtopic2 if subtopic != "pn", robust cluster(stateyr) nolog
regress omperone b2.scttrt_fac b2.scirtrt_fac b2.dcirtrt_fac neighbor numpa prevstat_i electionyr_i init_adopt_i init_adopt_j  legprof_i legprof_j  repcontrol_i repcontrol_j goviddiff tototherbtpa population2_i population2_j pcincome2_i pcincome2_j age wc2_i wc2_j b2.subtopic2 if subtopic != "pn", robust cluster(stateyr)

* Analysis without Post-Viability
probit adopt_i b2.scttrt_fac b2.scirtrt_fac b2.dcirtrt_fac neighbor numpa prevstat_i insession_i electionyr_i init_i init_adopt_j legprof_i legprof_j repcontrol_i repcontrol_j goviddiff abortionex_i abortionex_j population2_i population2_j pcincome2_i pcincome2_j age b2.subtopic2 if subtopic != "pv", robust cluster(stateyr) nolog
regress omperone b2.scttrt_fac b2.scirtrt_fac b2.dcirtrt_fac neighbor numpa prevstat_i electionyr_i init_adopt_i init_adopt_j  legprof_i legprof_j  repcontrol_i repcontrol_j goviddiff tototherbtpa population2_i population2_j pcincome2_i pcincome2_j age wc2_i wc2_j b2.subtopic2 if subtopic != "pv", robust cluster(stateyr)

* Analysis without Waiting Period
probit adopt_i b2.scttrt_fac b2.scirtrt_fac b2.dcirtrt_fac neighbor numpa prevstat_i insession_i electionyr_i init_i init_adopt_j legprof_i legprof_j repcontrol_i repcontrol_j goviddiff abortionex_i abortionex_j population2_i population2_j pcincome2_i pcincome2_j age b2.subtopic2 if subtopic != "wp", robust cluster(stateyr) nolog
regress omperone b2.scttrt_fac b2.scirtrt_fac b2.dcirtrt_fac neighbor numpa prevstat_i electionyr_i init_adopt_i init_adopt_j  legprof_i legprof_j  repcontrol_i repcontrol_j goviddiff tototherbtpa population2_i population2_j pcincome2_i pcincome2_j age wc2_i wc2_j b2.subtopic2 if subtopic != "wp", robust cluster(stateyr)

* Analysis without Parental Consent
probit adopt_i b2.scttrt_fac b2.scirtrt_fac b2.dcirtrt_fac neighbor numpa prevstat_i insession_i electionyr_i init_i init_adopt_j legprof_i legprof_j repcontrol_i repcontrol_j goviddiff abortionex_i abortionex_j population2_i population2_j pcincome2_i pcincome2_j age b2.subtopic2 if subtopic != "pc", robust cluster(stateyr) nolog
regress omperone b2.scttrt_fac b2.scirtrt_fac b2.dcirtrt_fac neighbor numpa prevstat_i electionyr_i init_adopt_i init_adopt_j  legprof_i legprof_j  repcontrol_i repcontrol_j goviddiff tototherbtpa population2_i population2_j pcincome2_i pcincome2_j age wc2_i wc2_j b2.subtopic2 if subtopic != "pc", robust cluster(stateyr)



*** Borrowed Text Model: alternative specifications of outcome variable
* Matching phrases 10 words or more
regress omper_ten b2.scttrt_fac b2.scirtrt_fac b2.dcirtrt_fac neighbor numpa prevstat_i electionyr_i init_adopt_i init_adopt_j  legprof_i legprof_j  repcontrol_i repcontrol_j goviddiff tototherbtpa population2_i population2_j pcincome2_i pcincome2_j age wc2_i wc2_j b2.subtopic2, robust cluster(stateyr)

* Matching phrases 4 words or more
regress omper_four b2.scttrt_fac b2.scirtrt_fac b2.dcirtrt_fac neighbor numpa prevstat_i electionyr_i init_adopt_i init_adopt_j  legprof_i legprof_j  repcontrol_i repcontrol_j goviddiff tototherbtpa population2_i population2_j pcincome2_i pcincome2_j age wc2_i wc2_j b2.subtopic2, robust cluster(stateyr)

* Not allowing any imperfections in the matching process
regress pmperone b2.scttrt_fac b2.scirtrt_fac b2.dcirtrt_fac neighbor numpa prevstat_i electionyr_i init_adopt_i init_adopt_j  legprof_i legprof_j  repcontrol_i repcontrol_j goviddiff tototherbtpa population2_i population2_j pcincome2_i pcincome2_j age wc2_i wc2_j b2.subtopic2, robust cluster(stateyr)

* Not ignoring case, numbers, and outer punctuation in the matching process
regress omper_npr b2.scttrt_fac b2.scirtrt_fac b2.dcirtrt_fac neighbor numpa prevstat_i electionyr_i init_adopt_i init_adopt_j  legprof_i legprof_j  repcontrol_i repcontrol_j goviddiff tototherbtpa population2_i population2_j pcincome2_i pcincome2_j age wc2_i wc2_j b2.subtopic2, robust cluster(stateyr)



*** Alternative model specifications of adoption analysis (footnote 11)
* Logit
logit adopt_i b2.scttrt_fac b2.scirtrt_fac b2.dcirtrt_fac neighbor numpa prevstat_i insession_i electionyr_i init_i init_adopt_j legprof_i legprof_j repcontrol_i repcontrol_j goviddiff abortionex_i abortionex_j population2_i population2_j pcincome2_i pcincome2_j age b2.subtopic2, robust cluster(stateyr) nolog

* Cloglog
cloglog adopt_i b2.scttrt_fac b2.scirtrt_fac b2.dcirtrt_fac neighbor numpa prevstat_i insession_i electionyr_i init_i init_adopt_j legprof_i legprof_j repcontrol_i repcontrol_j goviddiff abortionex_i abortionex_j population2_i population2_j pcincome2_i pcincome2_j age b2.subtopic2, robust cluster(stateyr) nolog

* rare events logit
relogit adopt_i sctuncon sctcon sciruncon scircon dciruncon dcircon neighbor numpa prevstat_i insession_i electionyr_i init_i init_adopt_j legprof_i legprof_j repcontrol_i repcontrol_j goviddiff abortionex_i abortionex_j population2_i population2_j pcincome2_i pcincome2_j age pb pf pv pn wp, cluster(stateyr)



*** Alternative model specifications of borrowed text analysis (footnote 12)
* Negative Binomial
nbreg omperone b2.scttrt_fac b2.scirtrt_fac b2.dcirtrt_fac neighbor numpa prevstat_i electionyr_i init_adopt_i init_adopt_j  legprof_i legprof_j  repcontrol_i repcontrol_j goviddiff tototherbtpa population2_i population2_j pcincome2_i pcincome2_j age wc2_i wc2_j b2.subtopic2, robust cluster(stateyr) nolog

* Zero-Inflated Poisson
zip omperone b2.scttrt_fac b2.scirtrt_fac b2.dcirtrt_fac neighbor numpa prevstat_i electionyr_i init_adopt_i init_adopt_j  legprof_i legprof_j  repcontrol_i repcontrol_j goviddiff tototherbtpa population2_i population2_j pcincome2_i pcincome2_j age wc2_i wc2_j b2.subtopic2, inflate(b2.scttrt_fac b2.scirtrt_fac b2.dcirtrt_fac neighbor numpa prevstat_i electionyr_i init_adopt_i init_adopt_j  legprof_i legprof_j  repcontrol_i repcontrol_j goviddiff tototherbtpa population2_i population2_j pcincome2_i pcincome2_j age wc2_i wc2_j b2.subtopic2) robust cluster(stateyr)  level(95) nolog

* Outocme variable transformed by taking its natural log
regress omperone_ln b2.scttrt_fac b2.scirtrt_fac b2.dcirtrt_fac neighbor numpa prevstat_i electionyr_i init_adopt_i init_adopt_j  legprof_i legprof_j  repcontrol_i repcontrol_j goviddiff tototherbtpa population2_i population2_j pcincome2_i pcincome2_j age wc2_i wc2_j b2.subtopic2, robust cluster(stateyr) 

* Outcome variable transformed by taking its square root
regress omperone2 b2.scttrt_fac b2.scirtrt_fac b2.dcirtrt_fac neighbor numpa prevstat_i electionyr_i init_adopt_i init_adopt_j  legprof_i legprof_j  repcontrol_i repcontrol_j goviddiff tototherbtpa population2_i population2_j pcincome2_i pcincome2_j age wc2_i wc2_j b2.subtopic2, robust cluster(stateyr)



*** GEE with exchangeable error structure (footnote 14)
encode stateyr, gen(stateyr2)
encode idone, gen(idone2)
xtset stateyr2
* Adoption GEE
xtgee adopt_i b2.b2.scttrt_fac b2.scirtrt_fac b2.dcirtrt_fac neighbor numpa prevstat_i insession_i electionyr_i init_i init_adopt_j legprof_i legprof_j repcontrol_i repcontrol_j goviddiff abortionex_i abortionex_j population2_i population2_j pcincome2_i pcincome2_j age b2.subtopic2, family(binomial) link(probit) vce(robust) i(idone2) corr(exchangeable) nolog

* Borrowed Text GEE
xtgee omperone b2.scttrt_fac b2.scirtrt_fac b2.dcirtrt_fac neighbor numpa prevstat_i electionyr_i init_adopt_i init_adopt_j  legprof_i legprof_j  repcontrol_i repcontrol_j goviddiff tototherbtpa population2_i population2_j pcincome2_i pcincome2_j age wc2_i wc2_j b2.subtopic2, family(normal) link(identity) i(idone2) vce(robust) corr(exchangeable) nolog



*** Alternative measure of Other Borrowed Text normalized by the number of previous adopters (footnote 23)
gen meanbtpa = tototherbtpa / numpa
regress omperone b2.scttrt_fac b2.scirtrt_fac b2.dcirtrt_fac neighbor prevstat_i electionyr_i init_adopt_i init_adopt_j  legprof_i legprof_j  repcontrol_i repcontrol_j goviddiff meanbtpa population2_i population2_j pcincome2_i pcincome2_j age wc2_i wc2_j b2.subtopic2, robust cluster(stateyr)

