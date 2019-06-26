

*stset year, failure(mzcowwar) id(dyadid) origin(enter==1) exit(time .)

*Table 1: coxtable.

*Model 1: full data, just RISc
stcox RISc_min I, cl(dyadid) nohr

*Model 2: full data, full model 
stcox RISc_min I contigdum majmaj minmin smldmat S, cl(dyadid) nohr

*Model 3: PRDs data, full model
stcox RISc_min I contigdum majmaj minmin smldmat S, cl(dyadid) nohr, if pol_rel==1

