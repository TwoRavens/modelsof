
/////////////////
// 2000-2003
use "output/monthly_panel_00_04.dta", clear // from panel_2000_04.do in MSAlevelcleaning
rename total_loanvol hmda_total_loanvol
rename refi_HI_loanvol hmda_refi_loanvol
rename count_refi_HI hmda_count_refi

replace hmda_refi_loanvol = hmda_refi_loanvol/10^6 // bn
replace hmda_total_loanvol = hmda_total_loanvol/10^6

xtset msa datem

preserve
	sum s30.ur_msa if datem==m(2003m6) [aw=pop2000], det

	g       x = 1 if s30.ur_msa < r(p25)     &datem==m(2003m6)
	replace x = 4 if s30.ur_msa > r(p75)     &datem==m(2003m6) & s30.ur_msa <.
	
	egen group = max(x), by(msa)
	tab group if datem==m(2003m6)
	tab group if datem==m(2003m6) [aw=pop2000]
	tabstat pop2000 if datem==m(2003m6), by(group) stat(sum)
	
	collapse   (sum) hmda_refi_loanvol hmda_total_loanvol hmda_count_refi have_mort_2000 , by(datem group)
	
	g hmda_refiprop = hmda_count_refi / have_mort_2000 * 100
	
	twoway (line hmda_refiprop datem if group==1) (line hmda_refiprop datem if group==4, lpattern(dash)) if datem>=m(2000m12)&datem<=m(2003m6), xlabel(#9, angle(45) nogrid) xtitle("") ytitle("Refinance propensity, in %") ///
	 legend(order(1 "Lowest Unempl. Quartile" 2 "Highest Unempl. Quartile") symx(7)) name(g_refiprop_0103, replace)
	
restore


////////////////////////////////////////////////////////////////////////////////////
// compare to 2007-9

use "output/master.dta", clear

format datem %tm
xtset msa datem

replace hmda_refi_loanvol = hmda_refi_loanvol/10^6 // bn
replace hmda_total_loanvol = hmda_total_loanvol/10^6

preserve
	sum s23.ur_msa if datem==m(2009m10) [aw=pop2008], det

	g       x = 1 if s23.ur_msa < r(p25)     &datem==m(2009m10)
	replace x = 4 if s23.ur_msa > r(p75)     &datem==m(2009m10) & s23.ur_msa <.
	
	egen group = max(x), by(msa)
	tab group if datem==m(2009m10)
	tab group if datem==m(2009m10) [aw=pop2008]
	
	collapse (sum) hmda_refi_loanvol hmda_total_loanvol hmda_count_refi mortgage_2008 , by(datem group)
	
	g hmda_refiprop = hmda_count_refi / mortgage_2008 * 100
	
	twoway (line hmda_refiprop datem if group==1) (line hmda_refiprop datem if group==4, lpattern(dash)) if datem>=m(2007m11)&datem<=m(2009m10), xlabel(#9, angle(45) nogrid) xtitle("") ytitle("Refinance propensity, in %") ///
	 legend(order(1 "Lowest Unempl. Quartile" 2 "Highest Unempl. Quartile") symx(7)) name(g_refiprop_0709, replace) tline(2008m11)
restore

