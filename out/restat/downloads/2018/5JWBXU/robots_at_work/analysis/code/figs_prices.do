* robots: graphs of prices

u "..\input\robots_prices_06", clear
		
	drop if country=="All"
	
	foreach var in price_robots price_robots_qadj {
		
		bys year: egen `var'Mean = mean(`var')
	}
		
	reshape wide price_robots price_robots_qadj, i(year) j(country) string
	
	foreach country in Mean US FRA GER ITA SWE UK {
		
		la var price_robots`country' "`country'"
		la var price_robots_qadj`country' "`country'"
		
		local price_robots "`price_robots' price_robots`country'"
		local price_robots_qadj "`price_robots_qadj' price_robots_qadj`country'"
	}
	
	la var year "Year"
	
	local graphopt "scheme(s2mono) graphregion(color(white)) ysc(r(0 100))"
	local graphopt "`graphopt' lpattern(solid dash dash dash dash dash dash)"
	local graphopt "`graphopt' lwidth(thick medium medium medium medium medium medium)"
	local graphopt "`graphopt' msymbol(i d s t X + oh)"
	
	twoway connected `price_robots' year, `graphopt' ytitle("Unit price of robots")
	graph export "$outpath/prices.pdf", replace

	twoway connected `price_robots_qadj' year, `graphopt' ytitle("Unit price of robots, quality-adjusted")
	graph export "$outpath/prices_qadj.pdf", replace
	