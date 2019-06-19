version 11
set more off
use OPS_quantities, clear
gen cl = 10000* prov_32_id + year
drop if year < 2005 | year > 2007

eststo clear
cap drop lq
char year[omit] 2006
gen lq = l.q
eststo: xi: reg eradication i.year cas_dc_pos, cluster(cl)
eststo: xi: reg eradication i.year*cas_dc_pos, cluster(cl)
test cas_dc_pos + _IyeaXcas_2007=0
eststo: xi: reg eradication i.year*cas_dc_pos i.year*lq, cluster(cl)
test cas_dc_pos + _IyeaXcas_2007=0
esttab using tables_figs/eradication.tex, replace booktabs nonotes ///
  starlevels(* 0.10 ** 0.05 *** 0.01) varlabels(_Iyear_2007 "2007" cas_dc_pos ///
  "Casualties, district" _IyeaXcas_2007 "Casualties * 2007" lq ///
  "Opium production, lagged" _IyeaXlq_2007 "Opium prod, lagged * 2007" _cons Constant) ///
  order(cas_dc_pos _IyeaXcas_2007 lq _IyeaXlq_2007) se nomtit ///
  stats(r2 N, fmt(3 0) labels("R$^2$" "N")) nodep drop(o.*)
