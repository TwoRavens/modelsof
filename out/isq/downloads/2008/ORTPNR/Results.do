set mem 200m
use "MattesISQ.dta"

**********************************Results for Table 1*******************************************
***for conflict:
stset duration, id(claimid) failure(censormid)
set matsize 800
stcox chrelcap civilwar chdemaut costinc uncertred valueterr, efron nohr shared(claim) 

***for renegotiation:
stset duration, id(claimid) failure(censorreneg)
stcox chrelcap civilwar chdemaut costinc uncertred valueterr, efron nohr shared(claim) 
stcox chrelcap civilwar chdemaut costinc uncertred valueterr, efron nohr robust cluster(claim)

************************************Results for Table 2*****************************************
***for conflict:
stset duration, id(claimid) failure(censormid)
set matsize 800
stcox changexcostinc changexuncertred change costinc uncertred valueterr, efron nohr shared(claim) 

***for renegotiation
stset duration, id(claimid) failure(censorreneg)
stcox changexcostinc changexuncertred change costinc uncertred valueterr , robust efron nohr cluster (claim) 


********************Descriptives for Uncertainty-reducing Provisions****************************
*exclude renegotiation between Poland and Russia in 1951 because chdemaut is missing in analyzed data- only case that couldn't be resolved. 
tab prevwar censorreneg if claimid~=float(264.2)
tab prevwar censormid
tab uncertred if censorreneg==1 & claimid~=float(264.2)
tab uncertred if censormid==1
tab prevwar uncertred if censorreneg==1 & claimid~=float(264.2)
list cbm1 cbm2 if prevwar==0 & censorreneg==1 & uncertred==1
list cbm3 observer if prevwar==1 & censorreneg==1 & claimid~=float(264.2)
tab cbm3 if censormid==1
tab observer if censormid==1

***********************************Additional Tests*********************************************
***Werner's measure of changes in relative capabilities (Table 1; fn.20)
stset duration, id(claimid) failure(censormid)
stcox chrelcapW civilwar chdemaut costinc uncertred valueterr, efron nohr shared(claim) 
stset duration, id(claimid) failure(censorreneg)
stcox chrelcapW civilwar chdemaut costinc uncertred valueterr, efron nohr shared(claim) 

***Functional form of changes in relative capabilities from SQ (Table 1; fn.11)
stset duration, id(claimid) failure(censormid)
stcox chrelcap civilwar chdemaut costinc uncertred valueterr, exactm nohr mgale(mg)
ksm mg chrelcap , lowess bw(.10) 
drop mg
stcox chrelcaplog civilwar chdemaut costinc uncertred valueterr, efron nohr shared(claim) 
stset duration, id(claimid) failure(censorreneg)
stcox chrelcap civilwar chdemaut costinc uncertred valueterr, exactm nohr mgale(mg)
ksm mg chrelcap , lowess bw(.10) 
drop mg
stcox chrelcaplog civilwar chdemaut costinc uncertred valueterr, efron nohr shared(claim) 

***different thresholds for changes in relative capabilities (Table 2)
*for conflict
stset duration, id(claimid) failure(censormid)
set matsize 800
stcox change10xcostinc change10xuncertred change costinc uncertred valueterr, efron nohr shared(claim) 
stcox change20xcostinc change20xuncertred change costinc uncertred valueterr, efron nohr shared(claim) 
stcox change40xcostinc change40xuncertred change costinc uncertred valueterr, efron nohr shared(claim) 
stcox change50xcostinc change50xuncertred change costinc uncertred valueterr, efron nohr shared(claim) 
*for renegotiation
stset duration, id(claimid) failure(censorreneg)
stcox change10xcostinc change10xuncertred change costinc uncertred valueterr , robust efron nohr cluster (claim) 
stcox change20xcostinc change20xuncertred change costinc uncertred valueterr , robust efron nohr cluster (claim) 
stcox change40xcostinc change40xuncertred change costinc uncertred valueterr , robust efron nohr cluster (claim) 
stcox change50xcostinc change50xuncertred change costinc uncertred valueterr , robust efron nohr cluster (claim) 

***test of nonproportional hazards assumption
*for conflict (Table 1)
stset duration, id(claimid) failure(censormid)
set matsize 800
stcox chrelcap civilwar chdemaut costinc uncertred valueterr, efron nohr shared(claim)schoenfeld(sch*) scaledsch(sca*)
stphtest, detail
drop sch* sca*
stcox chrelcap civilwar chdemaut costinc costincxtime uncertred valueterr, efron nohr shared(claim)schoenfeld(sch*) scaledsch(sca*)
stphtest, detail
drop sch* sca*

*for renegotiation (Table 1)
stset duration, id(claimid) failure(censorreneg)
stcox chrelcap civilwar chdemaut costinc uncertred valueterr, efron nohr shared(claim) schoenfeld(sch*) scaledsch(sca*)
stphtest, detail
drop sch* sca*

*for conflict (Table 2)
stset duration, id(claimid) failure(censormid)
set matsize 800
stcox changexcostinc changexuncertred change costinc uncertred valueterr, efron nohr shared(claim) schoenfeld(sch*) scaledsch(sca*)
stphtest, detail
drop sch* sca*
stcox changexcostinc changexuncertred change costinc uncertred valueterr valueterrxtime, efron nohr shared(claim) schoenfeld(sch*) scaledsch(sca*)
stphtest, detail
drop sch* sca*

*for renegotiation (table 2)
stset duration, id(claimid) failure(censorreneg)
stcox changexcostinc changexuncertred change costinc uncertred valueterr , robust efron nohr cluster (claim) schoenfeld(sch*) scaledsch(sca*)
stphtest, detail
drop sch* sca*

***Tacit Interactions (fn.23)
stset duration, id(claimid) failure(censormid)
stcox changexcostinc changexuncertred costincxuncertred chcostincxuncertred change costinc uncertred valueterr , efron nohr shared(claim) 
stset duration, id(claimid) failure(censorreneg)
stcox changexcostinc changexuncertred costincxuncertred chcostincxuncertred change costinc uncertred valueterr , robust efron nohr cluster (claim) schoenfeld(sch*) scaledsch(sca*)


***********************************Test for Endogeneity (fn.19)***********************************
collapse (max) claim costinc uncertred censorreneg censormid numprevclaimmid, by(claimid)
logit costinc numprevclaimmid, robust cluster (claim)
logit uncertred numprevclaimmid, robust cluster (claim)



