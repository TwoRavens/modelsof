clear all
set more off

/* this file documents business cycle properties 
   for the skill bias variables  */

* save ourdata_030512_X12.dta and hprescott8.ado in the same directory as this do-file and set the path
* run hprescott8 once before running this file
cd "..."
 
use ourdata_030512_X12, clear
* note that these data are seasonally adjusted

rename sp_hw_priv_gxedu5xexp4 wp_base
rename sp_ew_priv_hlcm wp_naive
rename rele_hw_priv_gxedu5xexp4 emp_base
rename rele_ew_priv_hlcm emp_naive
rename rels_ew_labf_hlcm supply_base


drop sp* rels*

foreach VAR of varlist wp_* emp_* supply_* {
		hprescott8 `VAR', stub(trend) smooth(1600)
	}
foreach VAR of varlist output hours productivity iprice {
		hprescott8 `VAR', stub(trend) smooth(1600)
	}

drop trend_wp_base_t_1 trend_wp_naive_t_1 trend_emp_base_t_1 trend_emp_naive_t_1 trend_supply_base_t_1
drop trend_output_t_1 trend_hours_t_1 trend_productivity_t_1 trend_iprice_t_1
sum trend_*

pwcorr trend_output* trend_wp_base* trend_emp_base* trend_wp_naive* trend_emp_naive* trend_supply* , sig
pwcorr trend_hours* trend_wp_base* trend_emp_base* trend_wp_naive* trend_emp_naive* trend_supply* , sig
pwcorr trend_productivity* trend_wp_base* trend_emp_base* trend_wp_naive* trend_emp_naive* trend_supply* , sig
pwcorr trend_iprice* trend_wp_base* trend_emp_base* trend_wp_naive* trend_emp_naive* trend_supply* , sig

