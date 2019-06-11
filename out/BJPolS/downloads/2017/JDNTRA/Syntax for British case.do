* =======================================
* INVESTIGATING MCP IN THE BRITISH SAMPLE
* =======================================

* MCP
* ---
capture drop w2_oxf_q20re
gen w2_oxf_q20re = 6-w2_oxf_q20
label drop rev
label define rev  1 "strongly disagree" 2 "tend to disagree" 3 "neither agree nor disagree" 4 "tend to agree" 5 "strongly agree"
label values w2_oxf_q20re rev
label variable w2_oxf_q20re "according to my personal values, using stereotypes about immigrants is not ok"
capture drop mcp1 mcp2 mcp3 mcp4 mcp5 mcp6

recode w2_oxf_q19 (6=.),into(mcp1)
recode w2_oxf_q20re (0=.),into(mcp2)
recode w2_oxf_q21 (6=.),into(mcp3)
recode w2_oxf_q22 (6=.),into(mcp4)
recode w2_oxf_q23 (6=.),into(mcp5)
recode w2_oxf_q24 (6=.),into(mcp6)
alpha mcp1 mcp2 mcp3 mcp4 mcp5 mcp6, reverse(mcp1 mcp2 mcp3 mcp4 mcp5 mcp6) std item gen(mcp)
gen mcp_2 = (6-mcp1)+(6-mcp2)+(6-mcp3)+(6-mcp4)+(6-mcp5)+(6-mcp6)
gen mcp01 = mcp/4

recode w2_oxf_q13 w2_oxf_q14 w2_oxf_q15 w2_oxf_q16 w2_oxf_q17 w2_oxf_q18 (6=.)
alpha w2_oxf_q13 w2_oxf_q14 w2_oxf_q15 w2_oxf_q16 w2_oxf_q17 w2_oxf_q18, item reverse(w2_oxf_q13 w2_oxf_q14 w2_oxf_q15 w2_oxf_q16 w2_oxf_q17 w2_oxf_q18) gen(extmcp)

* Immigrants
* ----------
gen immbadeco = w2_q121m
gen redimm = 6-w2_q123m
alpha redimm immbadeco, std item gen(immscale)
gen immscale2 = redimm+immbadeco
alpha w2_q121m w2_q122m w2_q123m, reverse(w2_q122m w2_q123m) std item gen(immfull)
alpha w2_q121m w2_q122m w2_q123m, reverse(w2_q122m w2_q123m) std item
gen immscale01 = (immscale-1)/4

* Vote
* ----
gen radrtever = 0
replace radrtever = . if  w1_p10q1==.
replace radrtever = 1 if  w1_p807q1==8
replace radrtever = 1 if  w1_p814q1==8
replace radrtever = 1 if  w2_p807q1==8
replace radrtever = 1 if  w2_p814q1==8
replace radrtever = 1 if  w3_p807q1==8
replace radrtever = 1 if  w3_p814q1==8
replace radrtever = 1 if  w4_p807q1==8
replace radrtever = 1 if  w4_p814q1==8
replace radrtever = 1 if  w5_p807q1==8
replace radrtever = 1 if  w5_p814q1==8
replace radrtever = 1 if w6_p10050q4==8
replace radrtever = 1 if  w1_p807q1==7
replace radrtever = 1 if  w1_p814q1==7
replace radrtever = 1 if  w2_p807q1==7
replace radrtever = 1 if  w2_p814q1==7
replace radrtever = 1 if  w3_p807q1==7
replace radrtever = 1 if  w3_p814q1==7
replace radrtever = 1 if  w4_p807q1==7
replace radrtever = 1 if  w4_p814q1==7
replace radrtever = 1 if  w5_p807q1==7
replace radrtever = 1 if  w5_p814q1==7
replace radrtever = 1 if w6_p10050q4==7

gen bnpever = 0
replace bnpever = 1 if  w1_p807q1==7
replace bnpever = 1 if  w1_p814q1==7
replace bnpever = 1 if  w2_p807q1==7
replace bnpever = 1 if  w2_p814q1==7
replace bnpever = 1 if  w3_p807q1==7
replace bnpever = 1 if  w3_p814q1==7
replace bnpever = 1 if  w4_p807q1==7
replace bnpever = 1 if  w4_p814q1==7
replace bnpever = 1 if  w5_p807q1==7
replace bnpever = 1 if  w5_p814q1==7
replace bnpever = 1 if w6_p10050q4==7
replace bnpever = . if  w1_p10q1==.

gen votebnp = 0
replace votebnp = 1 if  w2_p807q1==8
replace votebnp = 1 if  w2_p814q1==8

gen ukipever = 0
replace ukipever=1 if radrtever==1 & bnpever==0

* Gender
* ------
recode gender (1=1) (2=0)
label define gndr 0 "female" 1 "male"
label values gender gndr

* Controls
* --------
gen noqual = 0
replace noqual = 1 if term_edu==1
gen gcse = 0
replace gcse = 1 if term_edu>1 & term_edu<11
gen alevel = 0
replace alevel = 1 if term_edu>10 & term_edu<13
gen degree = 0
replace degree = 1 if term_edu==15
replace degree = 1 if term_edu==16
replace degree = 1 if term_edu==17
gen othqual = 0
replace othqual = 1 if term_edu==13
replace othqual = 1 if term_edu==14
replace othqual = 1 if term_edu==18
egen education=group(noqual gcse degree othqual)

recode w2_p960q1 (16 17=.), gen(income)
recode w2_p310q1 (999=.), gen(leftright)
recode w1_p1020q1 (1 2 3=3) (4 5 6=2) (7/11=1), gen(work)

* Standardizing
* -------------

egen std_mcp = std(mcp)
egen std_extmcp = std(extmcp)
egen std_immscale = std(immscale)
egen std_immfull = std(immfull)

* Listwise deletion
* =================
foreach var of varlist gender immscale mcp {
drop if `var'==.
}

* ====================
* Descriptive analyses
* ====================

egen mcp3g = cut(mcp), group(3)
lab define mcp3Lab 0 "low" 1 "medium" 2 "high"
lab value mcp3g mcp3Lab

egen immscale3 = cut(immscale), group(3)
lab define immscale3Lab 0 "low" 1 "medium" 2 "high"
lab value immscale3 immscale3Lab

tab mcp3g gender, nofreq column chi
tab immscale3 gender, nofreq column chi

tab mcp3, gen(mcp3)
ttest mcp31, by(gender)
ttest mcp32, by(gender)
ttest mcp33, by(gender)
tab immscale3, gen(immscale3)
ttest immscale31, by(gender)
ttest immscale32, by(gender)
ttest immscale33, by(gender)

mean bnpever, over(gender)

mean std_mcp std_extmcp std_immscale std_immfull, over(gender)
ttest std_mcp, by(gender)
ttest std_extmcp, by(gender)
ttest std_immscale, by(gender)

bys gender: alpha w2_q121m w2_q122m w2_q123m, item
bys gender: sum w2_q121m w2_q122m w2_q123m

kdensity mcp if gender == 0, plot(kdensity mcp if gender == 1) ///
	legend(label(1 "Women") label(2 "Men") rows(1))

* ===========
* Regressions
* ===========

* Prediciting IMCP
regress std_mcp gender
regress std_mcp gender i.education i.work age income, beta

* Prediciting vote
logit bnpever gender
listcoef, std constant
logit bnpever gender immscale
listcoef, std constant
logit bnpever gender mcp
listcoef, std constant
logit bnpever gender immscale mcp
listcoef, std constant

* Full models
logit bnpever gender				i.education income leftright age i.work
estimates store m1
listcoef, std constant
logit bnpever gender immscale		i.education income leftright age i.work
estimates store m2
listcoef, std constant
logit bnpever gender mcp			i.education income leftright age i.work
estimates store m3
listcoef, std constant
logit bnpever gender mcp immscale	i.education income leftright age i.work
estimates store m4
listcoef, std constant

esttab m1 m2 m3 m4, cells(b(star fmt(%9.3f)))  stats(r2_a N, fmt(%9.3f %9.0g) labels(R-squared))      ///
legend label collabels(none) varlabels(_cons Constant)

* ===
* CFA
* ===

sem (MCP -> mcp1 mcp2 mcp3 mcp4 mcp5 mcp6), stand
estat gof, stats(all)
estat mindices

sem (MCP -> mcp1 mcp2 mcp3 mcp4 mcp5 mcp6) (IMMSCALE -> redimm immbadeco), stand
* chi2(19) = 523.94
sem (ONE_LATENT -> mcp1 mcp2 mcp3 mcp4 mcp5 mcp6 redimm immbadeco), stand
* chi2(20) = 730.38
* difference: 206.44

estat gof, stats(all)
estat mindices

