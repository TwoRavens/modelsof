******************************************
*** Attacks Ads - Ken Miller *************
*** 2. 2010 Campaign Totals **************
******************************************

clear
set more off
set scheme lean1

use "/Volumes/External/Datasets/CMAG/CMAG 2010/2010HouseSen1.dta"

* Volume by Actor
*Unweighted
tab grouptype if genelect==1 & house==1
tab grouptype if genelect==1 & senate==1
*Weighted
tab grouptype if genelect==1 & house==1 [aweight=audience]
tab grouptype if genelect==1 & senate==1 [aweight=audience]


* Attack Advertising Totals 
keep if genelect==1
collapse (sum) genelect negativity audience weighted_neg, by (campaign grouptype)
save "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/APR Counts/tone10.dta"
keep if grouptype==1
drop grouptype
rename genelect cancount
rename negativity canneg
rename audience canaud
rename weighted_neg canwgtneg
save "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/APR Counts/can10.dta"
clear

use "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/APR Counts/tone10.dta"
keep if grouptype==2
drop grouptype
rename genelect parcount
rename negativity parneg
rename audience paraud
rename weighted_neg parwgtneg
save "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/APR Counts/par10.dta"
clear

use "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/APR Counts/tone10.dta"
keep if grouptype==3
drop grouptype
rename genelect pagcount
rename negativity pagneg
rename audience pagaud
rename weighted_neg pagwgtneg
save "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/APR Counts/pag10.dta"
clear

use "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/APR Counts/tone10.dta"
keep if grouptype==4
drop grouptype
rename genelect ibgcount
rename negativity ibgneg
rename audience ibgaug
rename weighted_neg ibgwgtneg
save "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/APR Counts/ibg10.dta"
clear

use "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/APR Counts/tone10.dta"
keep if grouptype==5
drop grouptype
rename genelect scgcount
rename negativity scgneg
rename audience scgaud
rename weighted_neg scgwgtneg
save "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/APR Counts/scg10.dta"
clear

use "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/APR Counts/can10.dta"
append using "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/APR Counts/par10.dta"
append using "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/APR Counts/pag10.dta"
append using "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/APR Counts/ibg10.dta"
append using "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/APR Counts/scg10.dta"
collapse (sum) can* par* pag* ibg* scg*, by (campaign)
save "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/APR Counts/attack10.dta"
erase "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/APR Counts/can10.dta"
erase "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/APR Counts/par10.dta"
erase "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/APR Counts/pag10.dta"
erase "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/APR Counts/ibg10.dta"
erase "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/APR Counts/scg10.dta"
