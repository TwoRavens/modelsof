** This do file replicates the results from Table I in "Trading for Security: Military Alliances and Economic Agreements" **

use "(insert full path\Trading for Security Table I.dta"

sort dyad year
tsset dyad year

** Woolridge test for serial correlation **

xtserial trade GDP_1 GDP_2 POP_1 POP_2 Distance Border Similarity JointDemocracy MIDlag NLallies Lallies Hegemony

** 1885-1938 sample **

xtpcse trade GDP_1 GDP_2 POP_1 POP_2 Distance Border Similarity JointDemocracy MIDlag NLallies Lallies Hegemony, corr(ar1) pairwise np1
logdummy NLallies Lallies
test Lallies=NLallies

clear

** 1885-1913 sample **

use "(insert full path\Trading for Security Table I.dta"

drop if year>1913

xtpcse trade GDP_1 GDP_2 POP_1 POP_2 Distance Border Similarity JointDemocracy MIDlag Lallies NLallies, corr(ar1) pairwise np1
logdummy NLallies

clear

** 1920-1938 sample **

use "(insert full path\Trading for Security Table I.dta"

drop if year<1920

xtpcse trade GDP_1 GDP_2 POP_1 POP_2 Distance Border Similarity JointDemocracy MIDlag NLallies Lallies, corr(ar1) pairwise np1
logdummy NLallies Lallies
test Lallies=NLallies

clear


