log using restat_tables, text replace
set more 1
set matsize 800

* read the data
use cereal_restat

* Table 1 
summ price addv


* gen IVs
qui gen qavgpo = p_SF if city==7
qui replace qavgpo = p_BS if city==56

qui gen ivdif = qavgpo - qavgp
qui summ qavgp
qui gen t1 = r(sd)
qui summ qavgpo
qui gen t2 = r(sd)
qui gen ivdif1 = t1/(t1 + t2)*qavgpo - t2/(t1 + t2)*qavgp
qui drop t1 t2


global regvars="addv bd1-bd25 dd2-dd20 sfdum";
qui reg y $regvars
qui predict nety, resid 
qui reg price $regvars
qui predict netp, resid 
qui reg p_SF $regvars
qui predict netp_sf, resid 
qui reg p_BS $regvars
qui predict netp_bs, resid 
qui reg qavgp $regvars
qui predict qavg, resid 

qui reg p_rSF $regvars
qui predict netp_rsf, resid 
qui reg p_rNE $regvars
qui predict netp_rne, resid 

qui gen qavgo = netp_sf if city==7
qui replace qavgo = netp_bs if city==56

qui gen ivdiff = qavgo - qavg

corr y price p_*, c
corr nety netp ivdiff qavg qavgo, c
corr nety netp ivdiff qavg qavgo
qui egen sx = sd(price)


* Table 2
* column 1
reg y price $regvars

* column 2
ivreg y (price=qavgp) $regvars
reg price qavgp $regvars
test qavgp

* column 3
ivreg y (price=qavgpo qavgp) $regvars
reg price qavgp qavgpo $regvars
test qavgp qavgpo

* column 4
ivreg y (price=ivdif)$regvars
reg price ivdif $regvars
test ivdif

* column 5
qui egen sz = sd(ivdif)
qui gen divdif = sx*ivdif - sz*price
ivreg y (price=divdif) $regvars
reg price divdif $regvars
test divdif

log close
