

	******************************************************************
	**
	**
	**		NAME:		Francisco Garfias
	**		DATE: 		November 28, 2017
	**		PROYJECT: 	Elite Competition and State Capacity 
	**					Development: Theory and Evidence from 
	**					Post-Revolutionary Mexico
	**
	**		DETAILS: 	This code prepares Figure 1: Land 
	**					Redistribution in Mexico (1916-1960)
	**					
	**					
	** 
	**
	**				
	**		Version: 	Stata MP 12.1
	**
	******************************************************************
	
	



		

			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* Prepare land redistribution data
*-------------------------------------------------------------------------------

local datadir $data
use "`datadir'SandersonData.dta", clear

* Identify redistribution events
keep if resolution==1 | resolution==2 | resolution==3 | resolution==4
gen reparto=1 if positive==1
replace reparto=0 if positive==0
gen land_reform_event=1
gen repartoriego=(reparto*riego>0)

* Aggregate to year
egen sum_riego=sum(riego) if repartoriego==1, by(year)
replace sum_riego=sum_riego/1000
sort year
collapse (mean) sum_riego (sum) repartoriego, by(year)

* Label variables
label var repartoriego "Land Redistribution Events (some irrigated land)"
label var sum_riego "Surface Area Redistributed (some irrigated land, Sq. Km)"
local note `"Source: Sanderson (1984). Irrigated land. Dates correspond to"'
local note `"`note' the official date of redistribution; usually lag actual"'
local note `"`note' redistribution date by a couple of years."'







			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* Figure 1: Land Redistribution in Mexico (1916-1960)
*-------------------------------------------------------------------------------


#delimit;
twoway (line repartoriego year) (line sum_riego year, lpattern(dash)) 
	if year<=1960, 
	xline(1930 1940, lpattern(dot)) 
	ylabel(, labsize(3) nogrid) xlabel(1915(5)1960, labsize(3.5) nogrid) 
	scheme(s2mono) graphregion(fcolor(white) lcolor(white) margin(medsmall))
	title("") xtitle("Year", size(3)) 
	ytitle("") xsca(titlegap(2) lcolor(white)) ysca(titlegap(2) lcolor(white)) 
	ysize(1) xsize(2.2) legend(order(1 2) region(lcolor(white) margin(zero)) 
	size(3.5) symxsize(*.5) col(1) pos(1) ring(0))
	note(`note', size(2.5));
local figuresdir $figures;
graph export "`figuresdir'1_Figure1.pdf", replace;
#delimit cr


