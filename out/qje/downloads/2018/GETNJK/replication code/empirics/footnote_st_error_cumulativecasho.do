
/* "Regressing  MSA-level  cash-out  amounts  on  group  dummies  interacted  with  a  post-QE  dummy  (with  standard  errors
clustered by MSA) we get an estimate of this cumulative difference of $7.95 billion with a standard error of $3.11 billion." */

use output/master.dta, clear // from master_merge.do

renvars cash_out_amt*, subst(cash_out_amt casho_amt)

xtset msa datem
format datem %tm

drop ed_a age_21_30 // base categories
g mort_if_own = mort_own / home_own

g cltv_p50 = CLTV_p50/100
g eq_med = 1 - cltv_p50
sum eq_med if datem==m(2008m11) [aw=pop2008]

foreach x of varlist casho_amt casho_amt_n*  {
replace `x' = `x' / 10^6 * housing_bal_fullccp / l_bal_incl_efx_out
}


local cutoff = 25  
local z = 100-`cutoff'
sum cltv_p50 if datem==m(2008m11) [aw=pop2008], det
g       x = 1 if cltv_p50 < r(p`cutoff')&datem==m(2008m11) // group 1 = most equity
replace x = 4 if cltv_p50 > r(p`z')     &datem==m(2008m11) & cltv_p50<.

egen group = max(x), by(msa)
tab group if datem==m(2008m11)
tab group if datem==m(2008m11) [aw=pop2008]
replace group=99 if group==.

tabstat eq_med if datem==m(2008m11) [aw=pop2008], by(group)

///////////////////////////////////////////////////////////////////////

tabstat casho_amt if datem>=m(2009m1)&datem<=m(2009m6), by(group) stat(sum)
tabstat casho_amt if datem>=m(2009m1)&datem<=m(2009m12), by(group) stat(sum)

drop if datem<m(2008m1)|datem>m(2009m12)

reg casho_amt b4.group##b587.datem if inlist(group,1,4)

cap drop post
g post=datem>=m(2008m12)


reg casho_amt b4.group##1.post if inlist(group,1,4), clu(msa)
lincom 89*13*1.group#1.post // 89 MSAs in group 4






