clear all

set memory 100m
set matsize 800
set more off

/* program to turn table 90 deg */
cap program drop tr_table
program define tr_table
  eststo clear
  local rnames : rownames C
  local models : coleq C
  local models : list uniq models
  local i 0
  foreach name of local rnames {
    local ++i
    local j 0
    capture matrix drop b
    capture matrix drop se
    foreach model of local models {
      local ++j
      matrix tmp = C[`i', 2*`j'-1]
      if tmp[1,1]<. {
        matrix colnames tmp = `model'
        matrix b = nullmat(b), tmp
        matrix tmp[1,1] = C[`i', 2*`j']
        matrix se = nullmat(se), tmp
      }
    }
    ereturn post b
    quietly estadd matrix se
    eststo `name'
  }
end

/* local vars for questions and variables */
tempfile nrva
local questions q13_1_no_shocks q13_1_insecurity q13_1_grew_opium q13_1_reduce_agricultural q13_1_theft /* questions of interest */
local host cas_dc_pos                   /* hostile */
local nonh cas_nh_dc_pos                /* non-hostile */
local stderr cluster(cl)                /* standard errors */

/* Read in and merge data: NRVA 2005 and OPS_quantities */
use ${oftm}/../data/NRVA2005/NRVA2005, clear
foreach v of varlist `questions' {
  replace `v' = 0 if mi(`v')
}
collapse (mean) `questions' [fweight=hhweight], by(dc_id)
sort dc_id
save `nrva'

use OPS_quantities, clear
sort dc_id year
merge dc_id using `nrva' /* will not uniquely identify, since OPS_quantities is a panel */
sort dist_32_id year
drop _m

gen cl = 10000 * prov_32_id + year

/* NRVA 2005  */
label var q13_1_no_shocks "No shocks experienced"
label var q13_1_insecurity "Insecurity / violence"
label var q13_1_grew_opium "Stopped producing opium this season"
label var q13_1_reduce_agricultural "Reduced agricultural water quality / quantity"
label var q13_1_theft "Theft and/or violence"
label var cas_dc_pos "Hostile casualties, district"
label var cas_nh_dc_pos "Non-hostile casualties, district" 

eststo clear
cap mat drop C
foreach v of varlist `questions' {
  /* replace `v' = 0 if mi(`v') */
  qui eststo `v': reg `v' `host' `nonh' if year == 2004 | year == 2005, `stderr'
  local vn: var lab `v'
  local varnames `varnames' "`vn'"
}
qui esttab , se nostar
matrix C = r(coefs)
tr_table

esttab using tables_figs/nrva.tex, replace noobs nomtitle label booktabs starl(* .1 ** .05 *** .01) nonotes nonumbers se posthead(" & \multicolumn{2}{c}{Casualties} & Constant \\ " " \cmidrule(lr){2-3} " " & Hostile & Non-hostile &  \\" "\midrule")
