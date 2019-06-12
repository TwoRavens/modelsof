/*--------------------------------------------------------------

Household balance sheets in France and USA
----------------------------------------------------------------*/ 

clear all
set more off

*======================= Path settings =============================================

cd "${main_dir}"


include paths


*======================= Import data ==============================================

* Housing is net of mortgage debt

* 1/ France xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
import excel using "${rore}/src/raw_data/excel/hh_bal_sheets/Fracnce_wealthcomposition.xlsx", clear

drop if _n>73
drop if _n<29

keep A-M
destring A-M, replace

ren A year
gen total = C + F + H + K + L + M
gen housing = C*100/total
gen bus_assets = F*100/total
gen equities = H*100/total
gen equities_public = I*100/total
gen equities_private = J*100/total
gen bonds = K*100/total
gen deposits = L*100/total
gen life_ins = M*100/total
gen hous_debt = E*100/total
gen fin_assets = G*100/total

gen iso = "FRA"

drop B-M

save "${rore}/bld/data_out/hh_balance_sheets.dta", replace

* 2/ USA xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
import excel using "${rore}/src/raw_data/excel/hh_bal_sheets/us_portfolio_shares.xlsx", ///
	cellrange(A6:J26) firstrow clear
	
destring other_nonfin housing bus_assets equities liquid_and_bonds other_fin ///
	nonhous_debt hous_debt debt_over_assets, replace

* Subtract housing debt
gen hous_debt_new = hous_debt*debt_over_assets/100
gen total_new = 100-hous_debt_new
replace housing = housing - hous_debt_new

* All assets as share of net wealth
local toscale other_nonfin housing bus_assets equities liquid_and_bonds other_fin
foreach s of local toscale	{
	replace `s' =`s'*100/total_new
}
	
gen total_check = other_nonfin + housing + bus_assets + equities + liquid_and_bonds + other_fin

gen iso = "USA"

merge 1:1 iso year using "${rore}/bld/data_out/hh_balance_sheets.dta", nogen
sort iso year
order iso year

*======================= Series ==============================================

local toformat housing hous_debt bus_assets fin_assets equities equities_public ///
	equities_private bonds deposits life_ins liquid_and_bonds

foreach s of local toformat	{
	format `s' %12.1f
}


* Share of total variables - extra vars
gen share1 = housing
gen share2 = housing + equities
gen share3 = housing + equities + bonds + deposits if iso == "FRA"
replace share3 = housing + equities + liquid_and_bonds if iso=="USA"
gen share4 = share3 + bus_assets
gen share5 = 100

label var share1 "Housing"
label var share2 "Equities"
label var share3 "Bonds & Deposits"
label var share4 "Business assets"
label var share5 "Other"

* Legend font size
local size large
local size2 medsmall
local size3 large
local size4 medium


*======================= Graph ==============================================

local isos FRA USA
local xscales ""1970(10)2010" "1950(10)2010""
local titles ""France" "USA""
local ni : word count `isos'

forvalues i = 1/`ni'	{

	local is : word `i' of `isos'
	local xsc : word `i' of `xscales'
	local t : word `i' of `titles'
	twoway 	(area share5 year, color(gs7)) ///
		(area share4 year, color(khaki)) ///
		(area share3 year) ///
		(area share2 year, color(dkgreen)) ///
		(area share1 year, color(dknavy)) ///
		if iso=="`is'", scheme(s1color) ///
		xlabel(`xsc', labsize(`size')) xtitle("") ///
		ylabel(0(20)100, labsize(`size')) ytitle("Per cent", size(`size')) ///
		plotregion(margin(zero)) ///
		legend(order(5 4 3 2 1) size(`size2') rows(2)) ///
		title("`t'", size(`size')) ///
		name(`is')
	graph close
}	


grc1leg FRA USA, legendfrom(FRA) cols(2) name(shares) ycommon scheme(s1color)
graph display shares, xsize(20) ysize(11)
graph export "${rore}/bld/graphs/wealth_shares/hh_balance_sheets.pdf", replace
graph export "${qje_figures}/Figure_A05.pdf", replace

graph close


