***** Replication code for Aarøe & Petersen (2018) "Cognitive Biases and Communication Strength in Social Networks: The Case of Episodic Frames ****

***** replication dofile number 1 ****

* This do file reproduces analyses related to the main study reported in Tests 1-3
* Use the following replication data set: "Replication Data #1 - Test 1-3"
* See the main text in the article and the Online Appendix for details on question wording and survey flow

set more off

*****************************************************************************
* Recodings for Test 1
*****************************************************************************

* Experimental treatment variable identifying whether respondents read a pro or a con frame
gen pro=.
replace pro = 1 if text_shown ==1
replace pro = 1 if text_shown ==2
replace pro = 0 if text_shown ==3
replace pro = 0 if text_shown ==4
label define pro 1 "pro frame" 0 "con frame"
label values pro pro

* amount or correctly transmitted episodic information from the original news article
ta epikond
label variable epikond "correctly transmitted episodic information"

* amount of correctly transmitted thematic information from the original news article
ta temkond
label variable temkond "correctly transmitted thematic information"

*total amount of correctly transmitted information from the original news article
gen totalrecall01=(epikond+temkond)/2

* amount of received episodic input information from the original news article (rounds 2-3)
gen epiinput=.
replace epiinput = input2 if pro==1
replace epiinput = input4 if pro==0
replace epiinput = . if runde ==1

* amount of received thematic input information from the original news article (rounds 2-3)
gen teminput=.
replace teminput = input1 if pro==1
replace teminput = input3 if pro==0
replace teminput = . if runde ==1

*total amount of reveived input averaging across the episodic and thematic information (rounds 2-3)
gen totalinput01=(epiinput+teminput)/2
replace totalinput01 =. if runde ==1

* transmission round
ta runde
label define runde 1 "transmission 1" 2 "transmission 2" 3 "transmission 3"
label values runde runde
label variable runde "transmission round"


/* experimental treatment variable identifying whether the episodic 
for the thematic information appeared first in the news article read by the respondents */
gen epifirst=.
replace epifirst = 1 if text_shown ==1
replace epifirst = 0 if text_shown ==2
replace epifirst = 1 if text_shown ==3
replace epifirst = 0 if text_shown ==4
label define epifirst 1 "episodic information appeared first" 0 "thematic information appeared first"
label values epifirst epifirst

/* variable measuring the difference in the amount of correctly 
transmitted episodic information in round 1 and 2 */
gen epi12=epiinput-epikond
replace epi12 = . if runde ==3
replace epi12 = . if runde ==1

/* variable measuring the difference in the amount of correctly 
transmitted tematic information in round 1 and 2 */
gen tem12=teminput-temkond
replace tem12 = . if runde ==3
replace tem12 = . if runde ==1

/* variable measuring the difference in the amount of correctly 
transmitted episodic information in round 2 and 3 */
gen epi23=epiinput-epikond
replace epi23 = . if runde ==1
replace epi23 = . if runde ==2

/* variable measuring the difference in the amount of correctly 
transmitted tematic information in round 1 and 2 */
gen tem23=teminput-temkond
replace tem23 = . if runde ==1
replace tem23 = . if runde ==2

/* variable measuring the difference in the difference in in the amount of correctly
transmitted episodic and thematic information in round 1 and 2 */
gen epitem12=epi12-tem12

/* variable measuring the difference in the difference in in the amount of correctly
transmitted episodic and thematic information in round 2 and 3 */
gen epitem23=epi23-tem23

***********************************************
* Generation of stemmed versions of variables *
***********************************************

gen epikond_stemmed =.
gen temkond_stemmed =.
replace epikond_stemmed=optælkond2_stemmed if pro ==1 
replace epikond_stemmed=optælkond4_stemmed if pro ==0
replace temkond_stemmed=optælkond1_stemmed if pro ==1
replace temkond_stemmed=optælkond3_stemmed if pro ==0
replace temkond_stemmed=. if epikond==. & temkond==.
replace epikond_stemmed=. if epikond==. & temkond==.

gen totalrecall01_stemmed=(epikond_stemmed+temkond_stemmed)/2

gen epiinput_stemmed=.
replace epiinput_stemmed = input2_stemmed if pro==1
replace epiinput_stemmed = input4_stemmed if pro==0
replace epiinput_stemmed = . if runde ==1

gen teminput_stemmed=.
replace teminput_stemmed = input1_stemmed if pro==1
replace teminput_stemmed = input3_stemmed if pro==0
replace teminput_stemmed = . if runde ==1

*****************************************************************************
* Additional recodings for Test 2
*****************************************************************************

* support for the policy proposal to reduce social welfare benefits 
ta q4
recode q4 (8=.)
gen hold01=(q4-1)/6
ta hold01
label variable hold01 "Support for the policy proposal to reduce social welfare benefits"

* gender of the sender
gen afsenderfemale=.
replace afsenderfemale = gender_afs1 if runde ==2
replace afsenderfemale = gender_afs2 if runde ==3
sum afsenderfemale
recode afsenderfemale (2=0)
label define afsenderfemale 1 "female" 0 "male"
label variable afsenderfemale afsenderfemale

* age of the sender
gen afsenderalder =.
replace afsenderalder = age_afs1 if runde ==2
replace afsenderalder = age_afs2 if runde ==3
sum afsenderalder
label variable afsenderalder "Sender's age measured in years"

* ideology of the sender
gen afsenderideo =.
replace afsenderideo = q1_afs1 if runde ==2
replace afsenderideo = q1_afs2 if runde ==3
gen afsenderideo01=(afsenderideo-1)/6
sum afsenderideo01
label variable afsenderideo01 "Sender's ideology, higher values more right-wing"

* education of the sender
recode education_afs1 education_afs2 (1=1) (2=3) (3=3) (4=2) (5=4) (6=5) (7=6) (8=7) (else=.), gen (afs1_edu afs2_edu)
gen afsenderedu=.
replace afsenderedu=afs1_edu if runde==2
replace afsenderedu=afs2_edu if runde==3
gen afsenderedu01=(afsenderedu-1)/6
sum afsenderedu01
label variable afsenderedu01 "Sender's education"

* Policy opinion of the sender
gen afsenderhold=.
replace afsenderhold=q4_afs1 if runde==2
replace afsenderhold=q4_afs2 if runde==3
recode afsenderhold (8=.)
gen afsenderhold01=(afsenderhold-1)/6
sum afsenderhold01
label variable afsenderhold01 "Sender's policy opinion, higher values higher policy support for reducing social welfare benefits"

* need for affect of the sender
recode q8_5_afs1 q8_5_afs2 (1=7) (2=6) (3=5) (4=4) (5=3) (6=2) (7=1), gen (q8_5_afs1rc q8_5_afs2rc)
alpha q8_1_afs1  q8_2_afs1 q8_3_afs1  q8_4_afs1  q8_5_afs1rc , item casewise
alpha q8_1_afs2  q8_2_afs2 q8_3_afs2  q8_4_afs2  q8_5_afs2rc , item casewise
egen afsender1nfa=rmean (q8_1_afs1 q8_2_afs1 q8_3_afs1 q8_4_afs1 q8_5_afs1rc)
replace afsender1nfa = . if q8_1_afs1 ==.
egen afsender2nfa=rmean (q8_1_afs2 q8_2_afs2 q8_3_afs2 q8_4_afs2 q8_5_afs2rc)
replace afsender2nfa = . if q8_2_afs2 ==.
gen afsender1nfa01=(afsender1nfa-1)/6
gen afsender2nfa01=(afsender2nfa-1)/6

gen afsendernfa01=.
replace afsendernfa01=afsender1nfa01 if runde==2
replace afsendernfa01=afsender2nfa01 if runde==3
sum afsendernfa01
label variable afsendernfa01 "Sender's need for affect"

* need for cognition of the sender
recode q5_afs1 q5_afs2 (1=2) (2=1), gen (q5_afs1rc q5_afs2rc)
ta q5_afs1rc q5_afs2rc
egen afsender1nfc = rmean(q5_afs1rc q6_afs1)
egen afsender2nfc = rmean(q5_afs2rc q6_afs2)
ta afsender1nfc afsender2nfc
gen afsender1nfc01=(afsender1nfc-1)
gen afsender2nfc01=(afsender2nfc-1)
sum afsender2nfc01 afsender1nfc01

gen afsendernfc01=.
replace afsendernfc01=afsender1nfc01 if runde==2
replace afsendernfc01=afsender2nfc01 if runde==3
label variable afsendernfc01 "Sender's need for cognition"

* gender of the receiver
gen female =.
replace female = 1 if gender ==1
replace female = 0 if gender ==2
label define female 1 "female" 2 "male"
label values female female

* age of the receiver
sum age
label variable age "Age measured in years"

*ideology of the receiver
gen ideo01= (q1-1)/6
ta ideo01
label variable ideo01 "Ideological self-placement, higher values more conservative"

*education of the receiver
gen edurc=education
recode edurc (1=1) (2=3) (3=3) (4=2) (5=4) (6=5) (7=6) (8=7) (else=.)
gen edu01=(edurc-1)/6
ta edu01
label variable edu01 "Receiver' s education" 

* need for cognition of the receiver
recode q5 (1=2) (2=1), gen (q5rc)
ta q5rc
egen nfc = rmean(q5rc q6)
ta nfc
gen nfc01=(nfc-1)
ta nfc01
label variable nfc01 "Receiver's need for cognition"


* need for affect of the receiver
recode q8_5 (1=7) (2=6) (3=5) (4=4) (5=3) (6=2) (7=1), gen (q8_5rc)
alpha q8_1 q8_2 q8_3 q8_4 q8_5rc, item casewise
egen nfa=rmean (q8_1 q8_2 q8_3 q8_4 q8_5rc)
ta nfa
gen nfa01=(nfa-1)/6
ta nfa01
label variable nfa01 "Receiver's need for affect"


***********************************************************
* Analyses for Test 1
***********************************************************

* Figure 1, panel A: Transmitted information from the original episodic and thematic frames: Transmission 1-3 pooled 
reg epikond
margins
estimates store m1
reg temkond
margins
estimates store m2
coefplot (m1, keep("_cons") rename ("_cons" = Episodic)) (m2, keep("_cons") /*
*/ rename ("_cons" = Thematic)),recast(bar) mcolor(black black) fcolor(gray) /*
*/ citop ciopts(recast(rcap) graphregion(color(white)) mcolor(black) fcolor(gray) /*
*/ lcolor(black)) msize(medlarge) vertical yscale(range(0.30)) ylabel(0(.05).30) /*
*/ ytitle("Correct transmission") xtitle("") /*
*/ label(1 "Episodic frame" 2 "Thematic frame") legend(off) name(recall2o, replace) 
graph drop _all

*test of mean difference reported in the main text in the results section for Test 1
ttest epikond == temkond

* Cohen's d effect size measure reported in the main text in the results section for Test 1
esize unpaired epikond == temkond if !missing(epikond) & !missing(temkond),all

* Figure 1, panel B: Transmitted information from the original episodic 
* and thematic frames: By transmission round
ttest epikond == temkond if runde==1
ttest epikond == temkond if runde==2
ttest epikond == temkond if runde==3

/* to generate figure 1, Panel B we export the estimated mean 
transmitted episodic and thematic information as well as the standard errors to excel 
in excel we calculate the 95 percent confidence intervals around each mean and graph the results
the results of the paired samples t-test are reported in Online Appendix A2.1 */

* Cohen's d effect size measure
esize unpaired epikond == temkond if runde ==1 & !missing(epikond) & !missing(temkond),all
esize unpaired epikond == temkond if runde ==2 & !missing(epikond) & !missing(temkond),all
esize unpaired epikond == temkond if runde ==3 & !missing(epikond) & !missing(temkond),all

/* Supplemental t-test for footnote 18 testing the difference in the decay in the amount of correctly 
 transmitted episodic and thematic information between rounds 1-2 */
ttest epitem12 == 0

/* Supplemental t-test for footnote 18 testing the difference in the decay in the amount of correctly 
transmitted episodic and thematic information between rounds 2-3 */
ttest epitem23 == 0

* Analyses of robustness summarized in footnote 19 and Online Appendix A2.2

ttest epikond_stemmed == temkond_stemmed

esize unpaired epikond_stemmed == temkond_stemmed if !missing(epikond) & !missing(temkond),all

ttest epikond_stemmed == temkond_stemmed if runde==1
ttest epikond_stemmed == temkond_stemmed if runde==2
ttest epikond_stemmed == temkond_stemmed if runde==3

esize unpaired epikond_stemmed == temkond_stemmed if runde ==1 & !missing(epikond) & !missing(temkond),all
esize unpaired epikond_stemmed == temkond_stemmed if runde ==2 & !missing(epikond) & !missing(temkond),all
esize unpaired epikond_stemmed == temkond_stemmed if runde ==3 & !missing(epikond) & !missing(temkond),all

* Analyses of robustness summarized in footnote 19 and Online Appendix A2.3
** overall the respondents correctly recollected a larger proportion of the "pro" frames than the "con" frames
ttest totalrecall01, by(pro)
ttest totalrecall01_stemmed, by(pro)

** replicating the results in Figure 1, Panels A-B for "pro" and "con" frames separately
bys pro: ttest epikond == temkond

bys pro: ttest epikond == temkond if runde==1
bys pro: ttest epikond == temkond if runde==2
bys pro: ttest epikond == temkond if runde==3

** replicating the Cohen's d effect size measures for "pro" and "con" frames separately
bys pro: esize unpaired epikond == temkond if !missing(epikond) & !missing(temkond),all
bys pro: esize unpaired epikond == temkond if runde ==1 & !missing(epikond) & !missing(temkond),all
bys pro: esize unpaired epikond == temkond if runde ==2 & !missing(epikond) & !missing(temkond),all
bys pro: esize unpaired epikond == temkond if runde ==3 & !missing(epikond) & !missing(temkond),all

** "Pro" vs "con" frames using stemmed dictionaries

bys pro: ttest epikond_stemmed == temkond_stemmed

bys pro: ttest epikond_stemmed == temkond_stemmed if runde==1
bys pro: ttest epikond_stemmed == temkond_stemmed if runde==2
bys pro: ttest epikond_stemmed == temkond_stemmed if runde==3
bys pro: esize unpaired epikond_stemmed == temkond_stemmed if !missing(epikond) & !missing(temkond),all
bys pro: esize unpaired epikond_stemmed == temkond_stemmed if runde ==1 & !missing(epikond) & !missing(temkond),all
bys pro: esize unpaired epikond_stemmed == temkond_stemmed if runde ==2 & !missing(epikond) & !missing(temkond),all
bys pro: esize unpaired epikond_stemmed == temkond_stemmed if runde ==3 & !missing(epikond) & !missing(temkond),all

* Analyses of robustness summarized in footnote 20 and Online Appendix A2.4
** replicating the results in Figure 1, Panels A-B by the order of the episodic and the thematic frame in the news article
bys epifirst: ttest epikond == temkond

bys epifirst: ttest epikond == temkond if runde==1
bys epifirst: ttest epikond == temkond if runde==2
bys epifirst: ttest epikond == temkond if runde==3

** replicating the Cohen's d effect size measures by the order of the episodic and the thematic frame in the news article
bys epifirst: esize unpaired epikond == temkond if !missing(epikond) & !missing(temkond),all
bys epifirst: esize unpaired epikond == temkond if runde ==1 & !missing(epikond) & !missing(temkond),all
bys epifirst: esize unpaired epikond == temkond if runde ==2 & !missing(epikond) & !missing(temkond),all
bys epifirst: esize unpaired epikond == temkond if runde ==3 & !missing(epikond) & !missing(temkond),all

** Order of frames using stemmed dictionaries

bys epifirst: ttest epikond_stemmed == temkond_stemmed

bys epifirst: ttest epikond_stemmed == temkond_stemmed if runde==1
bys epifirst: ttest epikond_stemmed == temkond_stemmed if runde==2
bys epifirst: ttest epikond_stemmed == temkond_stemmed if runde==3

bys epifirst: esize unpaired epikond_stemmed == temkond_stemmed if !missing(epikond) & !missing(temkond),all
bys epifirst: esize unpaired epikond_stemmed == temkond_stemmed if runde ==1 & !missing(epikond) & !missing(temkond),all
bys epifirst: esize unpaired epikond_stemmed == temkond_stemmed if runde ==2 & !missing(epikond) & !missing(temkond),all
bys epifirst: esize unpaired epikond_stemmed == temkond_stemmed if runde ==3 & !missing(epikond) & !missing(temkond),all

*************************************************************
* Analyses for Test 2
************************************************************** 
 
* descriptive statistics for the measure of opinion on the policy proposal
bys runde: sum hold01
 
* Analyses for Table 1 and Online Appendix A5.1. The effect of received episodic information on the impact of the issue frame on opinion
** Simple model
*** Transmissions 2-3 (M1)
eststo: reg hold01 i.pro##c.epiinput i.pro##c.teminput i.afsenderfemale c.afsenderalder /*
*/ c.afsenderideo01 c.afsenderedu01 i.female c.age c.ideo01 c.edu01 if runde >1 & epikond!=. & temkond!=., robust
*** Transmission 2 (M2)
eststo: reg hold01 i.pro##c.epiinput i.pro##c.teminput i.afsenderfemale c.afsenderalder /*
*/ c.afsenderideo01 c.afsenderedu01 i.female c.age c.ideo01 c.edu01 if runde ==2 & epikond!=. & temkond!=., robust
*** Transmission 3 (M3)
eststo: reg hold01 i.pro##c.epiinput i.pro##c.teminput i.i.afsenderfemale c.afsenderalder /*
*/ c.afsenderideo01 c.afsenderedu01 i.female c.age c.ideo01 c.edu01 if runde ==3 & epikond!=. & temkond!=., robust

** Extended model 
*** Trasnmissions 2-3 (M4)
eststo: reg hold01 i.pro##c.epiinput i.pro##c.teminput i.female c.age c.ideo01 c.edu01 /*
*/ c.nfa01 c.nfc01 c.afsenderhold01 afsenderfemale afsenderalder afsenderedu01 /*
*/ afsenderideo01 afsendernfa01 afsendernfc01 if runde >1 & epikond!=. & temkond!=., robust
*** Transmission 2 (M5)
eststo: reg hold01 i.pro##c.epiinput i.pro##c.teminput i.female c.age c.ideo01 c.edu01 /*
*/ c.nfa01 c.nfc01 c.afsenderhold01 afsenderfemale afsenderalder afsenderedu01  /*
*/ afsenderideo01 afsendernfa01 afsendernfc01 if runde ==2 & epikond!=. & temkond!=., robust
*** Transmission 3 (M6)
eststo: reg hold01 i.pro##c.epiinput i.pro##c.teminput i.female c.age c.ideo01 c.edu01 /*
*/ c.nfa01 c.nfc01 c.afsenderhold01 afsenderfemale afsenderalder afsenderedu01 /*
*/ afsenderideo01 afsendernfa01 afsendernfc01 if runde ==3 & epikond!=. & temkond!=., robust
esttab, b(%5.2f) se(%5.2f), using table1.rtf, replace onecell star(* 0.05 ** 0.01 *** 0.001) wide constant ar2
eststo clear

*Generating Figure 2. Effect of receiving the pro compared to the con issue frame on support for the proposal by transmission and amount of received episodic and themtic information
** identifying the 80th and the 20th percentile on a variable averaging across the amount of received information from the episodic and thematic frames across transmissions 2-3
_pctile totalinput01 if runde > 1, p(80)
return list
_pctile totalinput01 if runde > 1, p(20)
return list

** generating the marginal effects illustrated in Figure 2, panel a
*** Transmission 2 (M2)
reg hold01 i.pro##c.epiinput i.pro##c.teminput i.afsenderfemale c.afsenderalder /*
*/ c.afsenderideo01 c.afsenderedu01 i.female c.age c.ideo01 c.edu01 if runde ==2 & epikond!=. & temkond!=., robust
margins, dydx(pro) at(c.epiinput =(0.25) c.teminput= (0.08))
*** Transmission 3 (M3)
reg hold01 i.pro##c.epiinput i.pro##c.teminput i.afsenderfemale c.afsenderalder /*
*/ c.afsenderideo01 c.afsenderedu01 i.female c.age c.ideo01 c.edu01 if runde ==3 & epikond!=. & temkond!=., robust
margins, dydx(pro) at(c.epiinput =(0.25) c.teminput= (0.08))

** generating the marginal effects illustrated in Figure 2, panel b
*** Transmission 2 (M2)
reg hold01 i.pro##c.epiinput i.pro##c.teminput i.afsenderfemale c.afsenderalder /*
*/ c.afsenderideo01 c.afsenderedu01 i.female c.age c.ideo01 c.edu01 if runde ==2 & epikond!=. & temkond!=., robust
margins, dydx(pro) at(c.teminput =(0.25) c.epiinput= (0.08))
*** Transmission 3 (M3)
reg hold01 i.pro##c.epiinput i.pro##c.teminput i.afsenderfemale c.afsenderalder /*
*/ c.afsenderideo01 c.afsenderedu01 i.female c.age c.ideo01 c.edu01 if runde ==3 & epikond!=. & temkond!=., robust
margins, dydx(pro) at(c.teminput =(0.25) c.epiinput= (0.08))

/* to generate Figure 2, panels a-b, we copy the marginal effects generated above to excel along 
with their 95 pct confidence intervals. In excel we graph the effects. 
To generate the graph in excel we also add from the supplemental experimental study 
for test 1 the marginal effect of the episodic and thematic frame in test 1, see footnote 23 in the main text */

* Using stemmed dictionaries (Table A15)

eststo clear
eststo: reg hold01 i.pro##c.epiinput_stemmed i.pro##c.teminput_stemmed i.afsenderfemale c.afsenderalder /*
*/ c.afsenderideo01 c.afsenderedu01 i.female c.age c.ideo01 c.edu01 if runde >1 & epikond!=. & temkond!=., robust
eststo: reg hold01 i.pro##c.epiinput_stemmed i.pro##c.teminput_stemmed i.afsenderfemale c.afsenderalder /*
*/ c.afsenderideo01 c.afsenderedu01 i.female c.age c.ideo01 c.edu01 if runde ==2 & epikond!=. & temkond!=., robust
eststo: reg hold01 i.pro##c.epiinput_stemmed i.pro##c.teminput_stemmed i.i.afsenderfemale c.afsenderalder /*
*/ c.afsenderideo01 c.afsenderedu01 i.female c.age c.ideo01 c.edu01 if runde ==3 & epikond!=. & temkond!=., robust
eststo: reg hold01 i.pro##c.epiinput_stemmed i.pro##c.teminput_stemmed i.female c.age c.ideo01 c.edu01 /*
*/ c.nfa01 c.nfc01 c.afsenderhold01 afsenderfemale afsenderalder afsenderedu01 /*
*/ afsenderideo01 afsendernfa01 afsendernfc01 if runde >1 & epikond!=. & temkond!=., robust
eststo: reg hold01 i.pro##c.epiinput_stemmed i.pro##c.teminput_stemmed i.female c.age c.ideo01 c.edu01 /*
*/ c.nfa01 c.nfc01 c.afsenderhold01 afsenderfemale afsenderalder afsenderedu01  /*
*/ afsenderideo01 afsendernfa01 afsendernfc01 if runde ==2 & epikond!=. & temkond!=., robust
eststo: reg hold01 i.pro##c.epiinput_stemmed i.pro##c.teminput_stemmed i.female c.age c.ideo01 c.edu01 /*
*/ c.nfa01 c.nfc01 c.afsenderhold01 afsenderfemale afsenderalder afsenderedu01 /*
*/ afsenderideo01 afsendernfa01 afsendernfc01 if runde ==3 & epikond!=. & temkond!=., robust
esttab, b(%5.2f) se(%5.2f), using tableA15.rtf, replace onecell star(* 0.05 ** 0.01 *** 0.001) wide constant ar2
eststo clear

*************************************************************
* Analyses for Test 3
************************************************************** 
 
/* Analyses for Table 2 in the main text and Online Appendix A7.1. 
Effect of sender's education on the amount of transmitted information */
* M1
eststo: reg epikond c.edu01##ib(1).runde i.female c.age c.ideo01 c.nfa01 c.nfc01 hold01, robust
* M2
eststo: reg temkond c.edu01##ib(1).runde i.female c.age c.ideo01 c.nfa01 c.nfc01 hold01, robust
esttab, b(%5.2f) se(%5.2f), using table2.rtf, replace onecell star(* 0.05 ** 0.01 *** 0.001) wide constant ar2
eststo clear

* F-test  for the moderating effect of transmission round in Table 2, M1 (result reported in the main text above Table 2)
reg epikond c.edu01#ib(1).runde c.edu01 ib(1).runde i.female c.age c.ideo01 c.nfa01 c.nfc01 hold01, robust
testparm c.edu01#ib(1).runde
* F-test  for the moderating effect of transmission round in Table 2, M2 (result reported in the main text above Table 2)
reg temkond c.edu01#ib(1).runde c.edu01 ib(1).runde i.female c.age c.ideo01 c.nfa01 c.nfc01 hold01, robust
testparm c.edu01#ib(1).runde


* Analyses for Table 3 in the main text and Online Appendix A7.1. Effect of sender's education on the impact of received episodic information on the impact of the issue frame on opinion 
** Transmissions 2-3 (M1)
eststo: reg hold01 i.pro##c.epiinput##c.afsenderedu i.pro##c.teminput##c.afsenderedu i.female c.age c.ideo01 c.edu01  c.nfa01 c.nfc01 c.afsenderhold01 afsenderfemale afsenderalder  afsenderideo01 afsendernfa01 afsendernfc01 if runde > 1 & epikond!=. & temkond!=., robust
** Transmission 2 (M2)
eststo: reg hold01 i.pro##c.epiinput##c.afsenderedu i.pro##c.teminput##c.afsenderedu i.female c.age c.ideo01 c.edu01  c.nfa01 c.nfc01 c.afsenderhold01 afsenderfemale afsenderalder  afsenderideo01 afsendernfa01 afsendernfc01 if runde ==2 & epikond!=. & temkond!=., robust
** Transmission 3 (M3)
eststo: reg hold01 i.pro##c.epiinput##c.afsenderedu i.pro##c.teminput##c.afsenderedu i.female c.age c.ideo01 c.edu01  c.nfa01 c.nfc01 c.afsenderhold01 afsenderfemale afsenderalder  afsenderideo01 afsendernfa01 afsendernfc01 if runde ==3 & epikond!=. & temkond!=., robust
esttab, b(%5.2f) se(%5.2f), using table3.rtf, replace onecell star(* 0.05 ** 0.01 *** 0.001) wide constant ar2
eststo clear

* Using stemmed dictionaries (Table A21)

eststo clear
eststo: reg epikond_stemmed c.edu01##ib(1).runde i.female c.age c.ideo01 c.nfa01 c.nfc01 hold01, robust
eststo: reg temkond_stemmed c.edu01##ib(1).runde i.female c.age c.ideo01 c.nfa01 c.nfc01 hold01, robust
esttab, b(%5.2f) se(%5.2f), using tableA21.rtf, replace onecell star(* 0.05 ** 0.01 *** 0.001) wide constant ar2
eststo clear

* Using stemmed dictionaries (Table A22)

eststo clear
eststo: reg hold01 i.pro##c.epiinput_stemmed##c.afsenderedu i.pro##c.teminput_stemmed##c.afsenderedu i.female c.age c.ideo01 c.edu01  c.nfa01 c.nfc01 c.afsenderhold01 afsenderfemale afsenderalder  afsenderideo01 afsendernfa01 afsendernfc01 if runde > 1 & epikond!=. & temkond!=., robust
eststo: reg hold01 i.pro##c.epiinput_stemmed##c.afsenderedu i.pro##c.teminput_stemmed##c.afsenderedu i.female c.age c.ideo01 c.edu01  c.nfa01 c.nfc01 c.afsenderhold01 afsenderfemale afsenderalder  afsenderideo01 afsendernfa01 afsendernfc01 if runde ==2 & epikond!=. & temkond!=., robust
eststo: reg hold01 i.pro##c.epiinput_stemmed##c.afsenderedu i.pro##c.teminput_stemmed##c.afsenderedu i.female c.age c.ideo01 c.edu01  c.nfa01 c.nfc01 c.afsenderhold01 afsenderfemale afsenderalder  afsenderideo01 afsendernfa01 afsendernfc01 if runde ==3 & epikond!=. & temkond!=., robust
esttab, b(%5.2f) se(%5.2f), using tableA22.rtf, replace onecell star(* 0.05 ** 0.01 *** 0.001) wide constant ar2
eststo clear
