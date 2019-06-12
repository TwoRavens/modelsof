** --------------------------------------- ** 
* Imports PWT
* Source: http://www.rug.nl/research/ggdc/data/pwt/pwt-9.0
** --------------------------------------- ** 

clear 

use "$datadir/Data/PWT/pwt90.dta", clear

rename countrycode ctyc
rename pl_gdpo pl_gdp

*Create GDP per capita (millions of 2011 $/millions people)
gen gdp_const_ppp = rgdpna/pop
gen gdp_curr_ppp = cgdpo/pop
	
*We want to use rkna for growth (see PWT paper above)
gen cap_pc = ck/pop
la var cap_pc "Capital stock/population"

*Form average labor share variables

bysort ctyc: egen labsh_mean = mean(labsh)
keep ctyc year pl_gdp gdp_curr_ppp gdp_const_ppp labsh* cap_pc pop

save "$datadir/Data/PWT/pwt_data.dta", replace

*Conclusion of file.
