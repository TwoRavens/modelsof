*-----------------------------------------------------------------------------------------------------------------------------*
* This do file constructs the exposure to crises shock used in Berman and Couttenier (2014), based Reihnard and Rogoff data   *
* This version: nov. 29, 2013																								  *
*-----------------------------------------------------------------------------------------------------------------------------*
*
cd "$Data"
*
***********************************
* A - COMPUTES EXPOSURE TO CRISES *
***********************************
*
/* crisis data*/
use crises\crises_rr2011, clear
rename iso3 iso_d
sort iso_d year
rename banking_crisis banking_crisis_2
save crises\crises, replace
*
use trade_data\dots\dots1948_2009, clear
replace iso_o = "COD" if iso_o=="ZAR"
replace iso_d = "COD" if iso_d=="ZAR"
*
sort iso_d year
merge iso_d year using crises\crises, nokeep
tab _merge
drop _merge
drop if year < 1980 | year > 2006
rename flow trade
replace trade = 0  if trade == .
*
rename banking_crisis_2 crisis
*
egen group=group(iso_o iso_d)
tsset group year
*
/* trade shares */
bys group : egen sum_trade_ij = sum(trade) 
bys iso_o : egen sum_trade_i  = sum(trade)
g share_trade  				  = sum_trade_ij/sum_trade_i
g exposure_crisis			  = crisis*share_trade
rename iso_o iso3
collapse (sum) exposure_crisis, by(iso3 year)
sort iso3 year
*
erase crises/crises.dta
cd "$Output_data"
save exposure_crisis_all, replace

*
/* Assign crises to Prio-grid cells */
use GRID_PERCENTAGE, clear
keep gid percentage iso3
collapse (sum) percentage, by(gid iso3)
*
sort gid iso3
expand 27
sort gid iso3
g year =.
bys gid iso3: gen count=_n
replace year = 1980 if count == 1
replace year = 1981 if year[_n-1] == 1980
replace year = 1982 if year[_n-1] == 1981
replace year = 1983 if year[_n-1] == 1982
replace year = 1984 if year[_n-1] == 1983
replace year = 1985 if year[_n-1] == 1984
replace year = 1986 if year[_n-1] == 1985
replace year = 1987 if year[_n-1] == 1986
replace year = 1988 if year[_n-1] == 1987
replace year = 1989 if year[_n-1] == 1988
replace year = 1990 if year[_n-1] == 1989
replace year = 1991 if year[_n-1] == 1990
replace year = 1992 if year[_n-1] == 1991
replace year = 1993 if year[_n-1] == 1992
replace year = 1994 if year[_n-1] == 1993
replace year = 1995 if year[_n-1] == 1994
replace year = 1996 if year[_n-1] == 1995
replace year = 1997 if year[_n-1] == 1996
replace year = 1998 if year[_n-1] == 1997
replace year = 1999 if year[_n-1] == 1998
replace year = 2000 if year[_n-1] == 1999
replace year = 2001 if year[_n-1] == 2000
replace year = 2002 if year[_n-1] == 2001
replace year = 2003 if year[_n-1] == 2002
replace year = 2004 if year[_n-1] == 2003
replace year = 2005 if year[_n-1] == 2004
replace year = 2006 if year[_n-1] == 2005
drop count
compress
sort iso3 year
merge iso3 year using exposure_crisis_all, nokeep
tab _merge
drop _merge
*
replace exposure_crisis = exposure_crisis*percentage
collapse (sum) exposure_crisis, by(gid year)
sort gid year
save exposure_crisis_gid, replace
