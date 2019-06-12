******
*Penn World Tables
*
*From these data we want to use the gdp (real and nominal) and population
*variables in order to form GDPPC. We'll also make use of the capital share
*and labor share values for the model and for rescaling, respectively.
*
*Source: http://www.rug.nl/research/ggdc/data/pwt/pwt-9.0
******

clear 



**********************************************************
*Prepare PWT data
*
*Price levels, PPP gdp variables, population levels, and capital levels
*
*Check http://cid.econ.ucdavis.edu/Papers/Feenstra_Inklaar_Timmer_AER.pdf
*and see Table 1 for proper use
**********************************************************
use "$datadir/Data/PWT/pwt90.dta", clear

rename countrycode ctyc
rename pl_gdpo pl_gdp

*Create GDP per capita (millions of 2011 $/millions people)
gen gdp_const_ppp = rgdpna/pop
gen gdp_curr_ppp = cgdpo/pop
	*There has been some discussion of this point. The rgdpna and cgdpo variables
	*are identical for 2011, i.e. rgdpna is still the ppp-based measure, rather
	*than market-based. For our purposes, we will use cgdpo for the 2011 level,
	*and rgdpna for the growth rates. We'll have to use WDI data to get the
	*actual market-based GDP.

	
*We want to use rkna for growth (see PWT paper above)
*The ck variable should be used for single-year comparisons. These values are the same as rkna in 2011.
gen cap_pc = ck/pop
gen cap_pc_for_growth = rkna/pop

la var cap_pc "Capital stock/population"

*Form average labor share variables
*1996 and forward
bysort ctyc: egen labsh_mean96 = mean(labsh) if year >= 1996

*All data
bysort ctyc: egen labsh_mean = mean(labsh)

keep ctyc year pl_gdp gdp_curr_ppp gdp_const_ppp labsh* cap_pc cap_pc_for_growth pop ctfp

save "$datadir/Data/PWT/pwt_data.dta", replace

*Conclusion of file.
