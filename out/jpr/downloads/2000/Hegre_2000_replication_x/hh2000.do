version 5.0
log using hh2000, replace
/* Stata Do-file which allows the replication of the results in                */
/* Haavard Hegre:                                                              */
/* Development and the Liberal Peace: What Does it Take to be a Trading State? */
/* Journal of Peace Research vol. 37, no. 1, January 2000                      */ 
set memory 120000
use hh2000.dta
stset stop status [fweight=weight], t0(start)

/* Model Ia */
stcox gmm two_demo two_auto missing_ contigui alliance onemajor twomajor ln_size_ tip past_war if  gdpcapmi~=., nohr robust

/* Model Ib */
stcox gmm  gdpcapmi two_demo two_auto missing_ contigui alliance onemajor twomajor ln_size_ tip past_war if  gdpcapmi~=., nohr robust

/* Model Ic */
stcox gmm gdpcapmi  gmmwlt two_demo two_auto missing_ contigui alliance onemajor twomajor ln_size_ tip past_war if  gdpcapmi~=., nohr robust

/* Model IIa */
stcox lnsali two_demo two_auto missing_ contigui alliance onemajor twomajor lncap tip past_war if  eccapmin~=., nohr robust

/* Model IIb */
stcox lnsali eccapmin two_demo two_auto missing_ contigui alliance onemajor twomajor lncap tip past_war if  eccapmin~=., nohr robust

/* Model IIc */
stcox lnsali  eccapmin  salienco two_demo two_auto missing_ contigui alliance onemajor twomajor lncap tip past_war if  eccapmin~=., nohr robust

/* Model III */
stcox gmm  gdpcapmi  gmmwlt two_demo two_auto missing_  demowlt autowlt misswlt contigui alliance onemajor twomajor ln_size_ tip past_war if  gdpcapmi~=., nohr robust

log close
