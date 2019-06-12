



global demog "female age shia education logincome baseline_risk bornlocally reporting_important  policesolve courtsolve"

use vr_af_master, clear

*Samples: 1: No multiple switching,  2: No negative utility in q2, 3: No dominance violations b/w 1 and 2*
capture drop insample
gen insample = 0
replace insample = 1 if mswitchA != 1 & mswitchB != 1 & q1!=. &q2!=.
replace insample = 2 if mswitchA != 1 & mswitchB != 1 & q1!=. &q2!=. & Qhigh>=0
replace insample = 3 if mswitchA != 1 & mswitchB != 1 & q1!=. &q2!=. & Qhigh>=0 & q2>=q1

*Expand by 2 

expand 2
bysort M1: gen obscount = _n
gen qlow = q1
replace qlow = Qlow if obscount==2
gen qhigh = q1high
replace qhigh = Qhigh if obscount ==2
gen midq = (qlow +qhigh)/2
gen certainty = 0
replace certainty = 1 if obscount == 1

*My code
quietly tab province, gen(PROVINCE)
quietly tab pc, gen(PC)

*Change xi i. code to dummies to speed execution later

*Table 4 - All okay

intreg qlow qhigh pf PROVINCE2-PROVINCE12 if insample >=2 & certainty==0, cluster(pc)
intreg qlow qhigh pf $demog PROVINCE2-PROVINCE12 if insample >=2 & certainty==0, cluster(pc)
intreg qlow qhigh pf PROVINCE2-PROVINCE12 if insample >=2 & certainty==1, cluster(pc)
intreg qlow qhigh pf $demog PROVINCE2-PROVINCE12 if insample >=2 & certainty==1, cluster(pc)
intreg upremiumlow upremiumhigh pf PROVINCE2-PROVINCE12 if insample >=2 & certainty==0, cluster(pc)
intreg upremiumlow upremiumhigh pf $demog PROVINCE2-PROVINCE12 if insample >=2 & certainty==0, cluster(pc)
intreg qlow qhigh pf pf_kineticdummy1k_one kineticdummy1k_one PROVINCE2-PROVINCE12 if insample >=2 & certainty==0, cluster(pc)
intreg qlow qhigh pf pf_kineticdummy1k_one kineticdummy1k_one $demog PROVINCE2-PROVINCE12 if insample >=2 & certainty==0, cluster(pc)
intreg qlow qhigh pf pf_kineticdummy1k_one kineticdummy1k_one PROVINCE2-PROVINCE12 if insample >=2 & certainty==1, cluster(pc)
intreg qlow qhigh pf pf_kineticdummy1k_one kineticdummy1k_one $demog PROVINCE2-PROVINCE12 if insample >=2 & certainty==1, cluster(pc)
intreg upremiumlow upremiumhigh pf pf_kineticdummy1k_one kineticdummy1k_one PROVINCE2-PROVINCE12 if insample >=2 & certainty==0, cluster(pc)
intreg upremiumlow upremiumhigh pf pf_kineticdummy1k_one kineticdummy1k_one $demog PROVINCE2-PROVINCE12 if insample >=2 & certainty==0, cluster(pc)

*Table 5 - All okay

intreg qlow qhigh pf PC2-PC287 if insample >=2 & certainty==0
intreg qlow qhigh pf $demog PC2-PC287 if insample >=2 & certainty==0
intreg qlow qhigh pf PC2-PC287 if insample >=2 & certainty==1
intreg qlow qhigh pf $demog PC2-PC287 if insample >=2 & certainty==1
intreg upremiumlow upremiumhigh pf PC2-PC287 if insample >=2 & certainty==0
intreg upremiumlow upremiumhigh pf $demog PC2-PC287 if insample >=2 & certainty==0
intreg qlow qhigh pf pf_kineticdummy1k_one PC2-PC287 if insample >=2 & certainty==0
intreg qlow qhigh pf pf_kineticdummy1k_one $demog PC2-PC287 if insample >=2 & certainty==0
intreg qlow qhigh pf pf_kineticdummy1k_one PC2-PC287 if insample >=2 & certainty==1
intreg qlow qhigh pf pf_kineticdummy1k_one $demog PC2-PC287 if insample >=2 & certainty==1
intreg upremiumlow upremiumhigh pf pf_kineticdummy1k_one PC2-PC287 if insample >=2 & certainty==0
intreg upremiumlow upremiumhigh pf  pf_kineticdummy1k_one $demog PC2-PC287 if insample >=2 & certainty==0

*Table 7 - All okay

global newdemog "female shia age education logincome baseline_risk"
gen pf_reporting_important = pf*reporting_important
gen pf_policesolve = pf*policesolve
gen pf_courtsolve = pf*courtsolve
gen pf_bornlocally = pf*bornlocally 

intreg upremiumlow upremiumhigh pf pf_kineticdummy1k_one pf_reporting_important kineticdummy1k_one reporting_important PROVINCE2-PROVINCE12 if insample >=2 & certainty==0, cluster(pc)
intreg upremiumlow upremiumhigh pf pf_kineticdummy1k_one pf_reporting_important kineticdummy1k_one reporting_important $newdemog PROVINCE2-PROVINCE12 if insample >=2 & certainty==0, cluster(pc)
intreg upremiumlow upremiumhigh pf pf_kineticdummy1k_one pf_policesolve kineticdummy1k_one policesolve PROVINCE2-PROVINCE12 if insample >=2 & certainty==0, cluster(pc)
intreg upremiumlow upremiumhigh pf pf_kineticdummy1k_one pf_policesolve kineticdummy1k_one policesolve  $newdemog PROVINCE2-PROVINCE12 if insample >=2 & certainty==0, cluster(pc)
intreg upremiumlow upremiumhigh pf pf_kineticdummy1k_one pf_courtsolve kineticdummy1k_one courtsolve PROVINCE2-PROVINCE12 if insample >=2 & certainty==0, cluster(pc)
intreg upremiumlow upremiumhigh pf  pf_kineticdummy1k_one pf_courtsolve kineticdummy1k_one courtsolve $newdemog PROVINCE2-PROVINCE12 if insample >=2 & certainty==0, cluster(pc)
intreg upremiumlow upremiumhigh pf pf_kineticdummy1k_one pf_bornlocally kineticdummy1k_one bornlocally  PROVINCE2-PROVINCE12 if insample >=2 & certainty==0, cluster(pc)
intreg upremiumlow upremiumhigh pf pf_kineticdummy1k_one pf_bornlocally kineticdummy1k_one bornlocally $newdemog PROVINCE2-PROVINCE12 if insample >=2 & certainty==0, cluster(pc)

save DatCILS, replace

