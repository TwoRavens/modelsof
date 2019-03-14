******************************************
*** Attacks Ads - Ken Miller *************
*** 3. 2010 Weekly Panels ****************
******************************************


clear
set more off
set scheme lean1

use "/Volumes/External/Datasets/CMAG/CMAG 2010/2010HouseSen1.dta"

gen week = week(airdate)

* Attack Advertising Totals 
keep if genelect==1
collapse (sum) genelect negativity audience weighted_neg, by (campaign grouptype week)
save "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/Time/tone10.dta"
keep if grouptype==1
drop grouptype
rename genelect cancount
rename negativity canneg
rename audience canaud
rename weighted_neg canwgtneg
save "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/Time/can10.dta"
clear

use "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/Time/tone10.dta"
keep if grouptype==2
drop grouptype
rename genelect parcount
rename negativity parneg
rename audience paraud
rename weighted_neg parwgtneg
save "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/Time/par10.dta"
clear

use "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/Time/tone10.dta"
keep if grouptype==3
drop grouptype
rename genelect pagcount
rename negativity pagneg
rename audience pagaud
rename weighted_neg pagwgtneg
save "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/Time/pag10.dta"
clear

use "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/Time/tone10.dta"
keep if grouptype==4
drop grouptype
rename genelect ibgcount
rename negativity ibgneg
rename audience ibgaug
rename weighted_neg ibgwgtneg
save "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/Time/ibg10.dta"
clear

use "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/Time/tone10.dta"
keep if grouptype==5
drop grouptype
rename genelect scgcount
rename negativity scgneg
rename audience scgaud
rename weighted_neg scgwgtneg
save "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/Time/scg10.dta"
clear

use "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/Time/can10.dta"
append using "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/Time/par10.dta"
append using "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/Time/pag10.dta"
append using "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/Time/ibg10.dta"
append using "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/Time/scg10.dta"
collapse (sum) can* par* pag* ibg* scg*, by (campaign week)
save "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/Time/attack10.dta"
erase "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/Time/can10.dta"
erase "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/Time/par10.dta"
erase "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/Time/pag10.dta"
erase "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/Time/ibg10.dta"
erase "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/Time/scg10.dta"
