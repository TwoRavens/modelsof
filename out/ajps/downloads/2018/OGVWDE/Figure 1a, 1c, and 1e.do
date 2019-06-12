
use "Other Data/f400_wtech.dta", clear

// Figure 1a
preserve
keep if in400
tabstat tech, by(year)
collapse tech, by(year)
line tech year, xtitle("Year") ///
	title("Share of Forbes 400 Who Are in Tech Industry, by Year") ///
	ytitle("Share") caption("Source: Bonica and Rosenthal (2015)") scheme(s1color) // ysc(r(0))
gr export "figures/share_f400_in_tech.pdf", replace
restore

// Figure 1e
keep if tech

collapse (sum) tot_amount_dem (sum) tot_amount_rep, by(year)

gen d_donations_share = tot_amount_dem / (tot_amount_dem + tot_amount_rep)

gen tot_amount_dem_millions = tot_amount_dem / 1000000

line tot_amount_dem_millions year, xtitle("Year") ///
	title("Total Contributions to Democrats from Those" ///
	"In Tech and Ever in Forbes 400, by Year") ytitle("$ Millions") ///
	 caption("Source: Bonica and Rosenthal (2015)")  scheme(s1color)
gr export "figures/amount_to_dems.pdf", replace

// Figure 1c
twoway (line d_donations_share year), xtitle("Year") ///
	title("Share of Contributions Going to Democrats from" ///
	"Those In Tech and Ever in Forbes 400, by Year") ytitle("Share") yline(.5) ///
	 caption("Source: Bonica and Rosenthal (2015)")  scheme(s1color)
gr export "figures/share_to_dems.pdf", replace
