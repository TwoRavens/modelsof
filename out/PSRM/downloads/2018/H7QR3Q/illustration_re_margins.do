///Code for FE in Rare Events - Cook, Hays, Franzese///
///08/01/2018

*Note this is used to generate the marginal effects estimates for the random effects model in the illustration

use FL_rep_old.dta
xtset ccode year

logit onset i.warl gdpenl lpopl1 lmtnest i.ncontig i.Oil i.nwstate i.instab polity2l ethfrac relfrac 
margins, dydx(*) 
xtlogit onset i.warl gdpenl lpopl1 lmtnest i.ncontig i.Oil i.nwstate i.instab polity2l ethfrac relfrac, re
margins, dydx(*) predict(pu0)  ///Values then input to lines 108 & 109 of PML_FE_illustration_PSRM.R  


***Online Appendix - Table 3***
xtsum warl gdpenl lpopl1 lmtnest ncontig Oil nwstate instab polity2l ethfrac relfrac 

