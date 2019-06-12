* reading robots prices into Stata
* based on the 2006 World Robotics report

import excel using "..\input\IFR\robots_prices_06.xlsx", clear first sheet("Indices")
sa "..\output\robots_prices_06", replace		
