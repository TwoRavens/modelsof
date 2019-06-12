

	******************************************************************
	**
	**
	**		NAME:		Francisco Garfias
	**		DATE: 		November 28, 2017
	**		PROYJECT: 	Elite Competition and State Capacity 
	**					Development: Theory and Evidence from 
	**					Post-Revolutionary Mexico
	**
	**		DETAILS: 	This code prepares Figure 3: Bureaucrats, 
	**					Land Redistribution, and Commodity 
	**					Potential (1930-40)
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
* Prepare data
*-------------------------------------------------------------------------------


local datadir $data
use "`datadir'DPanel_Mun1940.dta", clear
tsset cve_geoest year







			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* Figure 3 Panel a - Bureaucrats
*-------------------------------------------------------------------------------

* Nadaraya-Watson regression
qui lpoly Dapper1000 Dwmean_shockma10 if hac1930==1, gen(x1 s1) ci se(se1)

* 95% Confience intervals
gen ul1 = s1 + 1.95*se1
gen ll1 = s1 - 1.95*se1
label var s1 "With haciendas"
local bw1=round(`r(bwidth)',.001)

#delimit;
twoway (line ul1 ll1 s1 x1, lcolor(blue blue blue) 
	lpattern(dot dot solid) clcolor(black black black)) if x1<0.05,
	ylabel(, labsize(2.5) nogrid ) xlabel(-.4(.1)-.05, labsize(2.5) nogrid) 
	scheme(s2mono) graphregion(fcolor(white) lcolor(white) margin(zero))
	legend(off)  title("") xtitle("Commodity potential (% change, 1930-40)", 
		size(4)) ysize(1) xsize(1)
	xsca(titlegap(2) lcolor(white)) ysca(titlegap(2) lcolor(white)) 
	ytitle("Change in Bureaucrats, 1930-40", size(3.8))
	caption("Bandwidth=0`bw1'.", size(2.5));
graph export "figures/3_Figure3_a.pdf", replace;
#delimit cr
drop x1-ll1
	
	



		

			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* Figure 3 Panel b - Land Redistribution
*-------------------------------------------------------------------------------


* Nadaraya-Watson regression
qui lpoly Drepartoriego Dwmean_shockma10 									///
	if hac1930==1 & Dapper1000!=., gen(x1 s1) ci se(se1)

* 95% Confience intervals
gen ul1 = s1 + 1.95*se1
gen ll1 = s1 - 1.95*se1
label var s1 "With haciendas"
local bw1=round(`r(bwidth)',.01)

#delimit;
twoway (line ul1 ll1 s1 x1, lcolor(blue blue blue) 
	lpattern(dot dot dash) clcolor(black black black))
	(line ul1 ll1 s1 x1, lcolor(blue blue blue) 
	lpattern(dot dot solid) clcolor(black black black)) if x1<0.05,
	ylabel(, labsize(2.5) nogrid) xlabel(-.4(.1)-.05, labsize(2.5) nogrid) 
	scheme(s2mono) graphregion(fcolor(white) lcolor(white) margin(zero))
	legend(off) title("") xtitle("Commodity potential (% change, 1930-40)", 
		size(4)) ysize(1) xsize(1)
	xsca(titlegap(2) lcolor(white)) ysca(titlegap(2) lcolor(white)) 
	ytitle("Change in land grants, 1930-40", size(3.8))
	caption("Bandwidth=0`bw1'.", size(2.5));
local figuresdir $figures;
graph export "`figuresdir'3_Figure3_b.pdf", replace;
#delimit cr
drop x1-ll1

