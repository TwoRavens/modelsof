clear all

*set working directory
use "ambition_yougov_replicationdata_clean.dta"


************
* Figure 1 *
************

*barriers to office
ologit barrierdoor empfant-empdist pidext educ i.inc4miss male black hisp otherrace age married full_employ if oversample==2
est store door
ologit barriernegcamp empfant-empdist pidext educ i.inc4miss male black hisp otherrace age married full_employ if oversample==2
est store negcamp
ologit barriertarget empfant-empdist pidext educ i.inc4miss male black hisp otherrace age married full_employ if oversample==2
est store target
ologit barrierdebate empfant-empdist pidext educ i.inc4miss male black hisp otherrace age married full_employ if oversample==2
est store debate
ologit barrierprivate empfant-empdist pidext educ i.inc4miss male black hisp otherrace age married full_employ if oversample==2
est store private
estout door negcamp target debate private, cells(b(star fmt(2)) se) stats(N r2)

ologit barrierpolicy empfant-empdist pidext educ i.inc4miss male black hisp otherrace age married full_employ if oversample==2
est store policy
ologit barrierconstit empfant-empdist pidext educ i.inc4miss male black hisp otherrace age married full_employ if oversample==2
est store constit
ologit barrierstatus empfant-empdist pidext educ i.inc4miss male black hisp otherrace age married full_employ if oversample==2
est store status
ologit barrierargue empfant-empdist pidext educ i.inc4miss male black hisp otherrace age married full_employ if oversample==2
est store argue
ologit barrierbargain empfant-empdist pidext educ i.inc4miss male black hisp otherrace age married full_employ if oversample==2
est store bargain
estout policy constit status argue bargain, cells(b(star fmt(2)) se) stats(N r2)


***********
* Table 2 *
***********

*expressive ambition
nbreg considersum empfant-empdist pidext educ i.inc4miss male black hisp otherrace age married full_employ if oversample==2
est store consider
logit run empfant-empdist pidext educ i.inc4miss male black hisp otherrace age married full_employ
est store run
logit held empfant-empdist pidext educ i.inc4miss male black hisp otherrace age married full_employ
est store held
estout consider run held, cells(b(star fmt(2)) se)  stats(N r2) 

*expressive ambition - big five robustness check
nbreg considersum empfant-empdist pidext educ i.inc4miss male black hisp otherrace age married full_employ bf* if oversample==2
est store considerbf
logit run empfant-empdist pidext educ i.inc4miss male black hisp otherrace age married full_employ bf*
est store runbf
logit held empfant-empdist pidext educ i.inc4miss male black hisp otherrace age married full_employ bf*
est store heldbf
estout consider considerbf run runbf held heldbf, cells(b(star fmt(2)) se)  stats(N r2) 



