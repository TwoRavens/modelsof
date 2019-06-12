******************************************
*** Attacks Ads - Ken Miller *************
*** 6. 2012 House Weekly Panels **********
******************************************

clear 
set more off

use "/Volumes/External/Datasets/CMAG/CMAG 2012/2012house2.dta"

gen week = week(airdate)

* Attack Advertising Totals 
keep if genelect==1
collapse (sum) genelect negativity audience weighted_neg, by (campaign grouptype week)
save "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/Time/housetone12.dta"
keep if grouptype==1
drop grouptype
rename genelect cancount
rename negativity canneg
rename audience canaud
rename weighted_neg canwgtneg
save "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/Time/housecan12.dta"
clear

use "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/Time/housetone12.dta"
keep if grouptype==2
drop grouptype
rename genelect parcount
rename negativity parneg
rename audience paraud
rename weighted_neg parwgtneg
save "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/Time/housepar12.dta"
clear

use "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/Time/housetone12.dta"
keep if grouptype==3
drop grouptype
rename genelect pagcount
rename negativity pagneg
rename audience pagaud
rename weighted_neg pagwgtneg
save "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/Time/housepag12.dta"
clear

use "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/Time/housetone12.dta"
keep if grouptype==4
drop grouptype
rename genelect ibgcount
rename negativity ibgneg
rename audience ibgaug
rename weighted_neg ibgwgtneg
save "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/Time/houseibg12.dta"
clear

use "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/Time/housetone12.dta"
keep if grouptype==5
drop grouptype
rename genelect scgcount
rename negativity scgneg
rename audience scgaud
rename weighted_neg scgwgtneg
save "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/Time/housescg12.dta"
clear

use "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/Time/housecan12.dta"
append using "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/Time/housepar12.dta"
append using "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/Time/housepag12.dta"
append using "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/Time/houseibg12.dta"
append using "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/Time/housescg12.dta"
collapse (sum) can* par* pag* ibg* scg*, by (campaign week)
save "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/Time/houseattack12.dta"
erase "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/Time/housecan12.dta"
erase "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/Time/housepar12.dta"
erase "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/Time/housepag12.dta"
erase "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/Time/houseibg12.dta"
erase "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/Time/housescg12.dta"
