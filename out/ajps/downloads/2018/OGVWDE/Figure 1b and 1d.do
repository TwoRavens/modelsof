clear
use "Other Data/opensecrets.dta", clear

gen d_share = d_donations / (d_donations + r_donations)

// Figure 1d
line d_donations year, xtitle("Year") ///
	title("Total Contributions to Democrats from All Those" ///
		"Working for Tech Companies, by Year") ytitle("$ Millions") ///
		caption("Source: Opensecrets") scheme(s1color)
gr export "figures/amount_to_dems_opensecrets.pdf", replace

// Figure 1b
twoway (line d_share year), xtitle("Year") ///
	title("Share of Contributions Going to Democrats from All Those" ///
		"Working for Tech Companies, by Year") ///
		ytitle("Share") yline(.5) caption("Source: Opensecrets") scheme(s1color)
gr export "figures/share_to_dems_opensecrets.pdf", replace
