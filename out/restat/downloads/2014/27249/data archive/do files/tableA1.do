
set more off

log using "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\regression results\tableA1.log", replace


use "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata dataset\dataset avec sinistres cont ind2 rain deviation monthly.dta", clear


replace septembre=0 if septembre==.



gen x=janvier+fevrier+mars+avril+juin+juillet+aout+septembre
gen logx=log(x)
tsset id year
 

drop if id==20

*** ALL TAXES
 
gen tax=logboisson_revenue_indirect_tax_+logper_capita_tax


sum logp_urbanpop

egen my=mean(logp_urbanpop)

* Areas More Rural Than The Average

correlate tax x if logp_urbanpop<my

* Areas More Urban Than The Average

correlate tax x if logp_urbanpop>my


*For the Record
correlate tax x

**********************************************
*** DIRECT TAXES

* Areas More Rural Than The Average

correlate logper_capita_tax x if logp_urbanpop<my

* Areas More Urban Than The Average

correlate logper_capita_tax x if logp_urbanpop>my


*For the Record
correlate logper_capita_tax  x
*************************************************
**** INDIRECT TAXES

* Areas More Rural Than The Average

correlate logboisson_revenue_indirect_tax_ x if logp_urbanpop<my

* Areas More Urban Than The Average

correlate logboisson_revenue_indirect_tax_ x if logp_urbanpop>my


*For the Record
correlate logboisson_revenue_indirect_tax_ x





*********************************************************

*************************************

** LOG RAINFALL

* Areas More Rural Than The Average

correlate tax logx if logp_urbanpop<my

* Areas More Urban Than The Average

correlate tax logx if logp_urbanpop>my


*For the Record
correlate tax logx

**********************************************
*** DIRECT TAXES

* Areas More Rural Than The Average

correlate logper_capita_tax logx if logp_urbanpop<my

* Areas More Urban Than The Average

correlate logper_capita_tax logx if logp_urbanpop>my


*For the Record
correlate logper_capita_tax  logx
*************************************************
**** INDIRECT TAXES

* Areas More Rural Than The Average

correlate logboisson_revenue_indirect_tax_ logx if logp_urbanpop<my

* Areas More Urban Than The Average

correlate logboisson_revenue_indirect_tax_ logx if logp_urbanpop>my


*For the Record
correlate logboisson_revenue_indirect_tax_ logx

********************************************************************************


** LOG RAINFALL
drop my 

sum p_urbanpop
egen my=mean(p_urbanpop)


* Areas More Rural Than The Average

correlate tax logx if p_urbanpop<my

* Areas More Urban Than The Average

correlate tax logx if p_urbanpop>my


*For the Record
correlate tax logx

**********************************************
*** DIRECT TAXES

* Areas More Rural Than The Average

correlate logper_capita_tax logx if p_urbanpop<my

* Areas More Urban Than The Average

correlate logper_capita_tax logx if p_urbanpop>my


*For the Record
correlate logper_capita_tax  logx
*************************************************
**** INDIRECT TAXES

* Areas More Rural Than The Average

correlate logboisson_revenue_indirect_tax_ logx if p_urbanpop<my

* Areas More Urban Than The Average

correlate logboisson_revenue_indirect_tax_ logx if p_urbanpop>my


*For the Record
correlate logboisson_revenue_indirect_tax_ logx





log close
