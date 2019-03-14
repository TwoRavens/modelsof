******************************************
*** Attacks Ads - Ken Miller *************
*** 5. 2012 House Campaign Totals ********
******************************************

clear 
set more off

use "/Volumes/External/Datasets/CMAG/CMAG 2012/2012house2.dta"

* Attack Advertising Totals 
keep if genelect==1
collapse (sum) genelect negativity audience weighted_neg, by (campaign grouptype)
save "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/APR Counts/housetone12.dta"
keep if grouptype==1
drop grouptype
rename genelect cancount
rename negativity canneg
rename audience canaud
rename weighted_neg canwgtneg
save "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/APR Counts/housecan12.dta"
clear

use "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/APR Counts/housetone12.dta"
keep if grouptype==2
drop grouptype
rename genelect parcount
rename negativity parneg
rename audience paraud
rename weighted_neg parwgtneg
save "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/APR Counts/housepar12.dta"
clear

use "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/APR Counts/housetone12.dta"
keep if grouptype==3
drop grouptype
rename genelect pagcount
rename negativity pagneg
rename audience pagaud
rename weighted_neg pagwgtneg
save "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/APR Counts/housepag12.dta"
clear

use "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/APR Counts/housetone12.dta"
keep if grouptype==4
drop grouptype
rename genelect ibgcount
rename negativity ibgneg
rename audience ibgaug
rename weighted_neg ibgwgtneg
save "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/APR Counts/houseibg12.dta"
clear

use "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/APR Counts/housetone12.dta"
keep if grouptype==5
drop grouptype
rename genelect scgcount
rename negativity scgneg
rename audience scgaud
rename weighted_neg scgwgtneg
save "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/APR Counts/housescg12.dta"
clear

use "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/APR Counts/housecan12.dta"
append using "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/APR Counts/housepar12.dta"
append using "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/APR Counts/housepag12.dta"
append using "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/APR Counts/houseibg12.dta"
append using "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/APR Counts/housescg12.dta"
collapse (sum) can* par* pag* ibg* scg*, by (campaign)
save "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/APR Counts/houseattack12.dta"
erase "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/APR Counts/housecan12.dta"
erase "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/APR Counts/housepar12.dta"
erase "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/APR Counts/housepag12.dta"
erase "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/APR Counts/houseibg12.dta"
erase "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/APR Counts/housescg12.dta"
