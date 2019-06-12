log using "replicate.txt", text replace

***** EX1

use "/Users/Sky/Desktop/ex1"

*** Variables

gen costly = .
replace costly = 0 if sent_x == 1
replace costly = 1 if sent_y == 1

gen confront = .
replace confront = 0 if stay == 1
replace confront = 1 if stay == 2 
replace stay = 1 if confront == 0
replace stay = 0 if confront == 1 

gen costlythreat = .
replace costlythreat = 0 if threat == 1
replace costlythreat = 1 if threat == 2 

gen credible = .
replace credible = 6 if cred1 == 1
replace credible = 5 if cred1 == 2
replace credible = 4 if cred3 == 1
replace credible = 3 if cred3 == 3
replace credible = 2 if cred3 == 2
replace credible = 1 if cred2 == 2
replace credible = 0 if cred2 == 1

gen risk0 = risk_1 + risk_2 + risk_3 + risk_4 + risk_5 + risk_6 + risk_7 
gen risk = risk0 - 7

preserve 

*** Q1

gen true = .
replace true = 0 if signaler == 2
replace true = 1 if signaler == 1
tab costlythreat true

prtest costlythreat, by(true) 
logit costlythreat true, robust
logit costlythreat true risk, robust

*** Q2

keep if (signaler == 3 | signaler == 4)
tab stay costly

prtest stay, by(costly)
logit stay costly, robust
logit stay costly risk, robust
ttest credible, by(costly)
ologit credible costly, robust
ologit credible costly risk, robust

clear all

***** EX2

use "/Users/Sky/Desktop/ex2"

*** Q1 

prtest threat, by(truer)
prtest threat if state == 1, by(truer) 
prtest threat if period == 12, by(truer) 
tab threat truer 
logit threat truer, cluster(player)
logit threat truer risk, cluster(player)
xi: logit threat truer i.period i.session, cluster(player)
xi: logit threat truer risk i.period i.session, cluster(player)

*** Q2

prtest stay, by(threat) 
prtest stay if period == 12, by(threat)
tab stay threat 
logit stay threat, cluster(player)
logit stay threat risk, cluster(player)
xi: logit stay threat i.period i.session, cluster(player)
xi: logit stay threat risk i.period i.session, cluster(player)

ttest credible, by(threat) 
ttest credible if period == 12, by(threat) 

clear all

***** EX3

use "/Users/Sky/Desktop/ex3"

*** Note: Scenarios K1-K2 (Costly vs. Not Costly), K7-K10 (2x2 Factorial Experiment) 

gen costly1 = .
replace costly1 = 1 if k1 == 1
replace costly1 = 0 if k2 == 1

gen costly2 = . 
replace costly2 = 1 if (k7a == 1 | k7b == 1 | k9a == 1 | k9b == 1)  
replace costly2 = 0 if (k8a == 1 | k8b == 1 | k10a == 1 | k10b == 1) 

gen costim = . 
replace costim = 1 if (k7a == 1 | k7b == 1 | k8a == 1 | k8b == 1)  
replace costim = 0 if (k9a == 1 | k9b == 1 | k10a == 1 | k10b == 1)  

prtest cred, by(costly1) 
ttest credible, by(costly1)

prtest cred if costim==1, by(costly2)
ttest credible if costim==1, by(costly2)

prtest cred if costim==0, by(costly2)
ttest credible if costim==0, by(costly2)

prtest cred if costly2==0, by(costim)
prtest cred if costly2==1, by(costim)

ttest credible if costly2==0, by(costim)
ttest credible if costly2==1, by(costim)

prtest cred, by(costim)
ttest credible, by(costim)

log close 