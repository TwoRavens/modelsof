*-----------------------------------------------------------------------------------------------------------------------------*
* This do file constructs the agricultural commodities shock used in Berman and Couttenier (2014), based on FAO-GAEZ data     *
* This version: dec. 2, 2013
*-----------------------------------------------------------------------------------------------------------------------------*
*
****************************************
* A - NETTOYAGE DATA GAEZ + ADD SHOCKS *
****************************************
	
use "$Data\GAEZ\gaez_grid.dta", clear
/*
The five categories and their corresponding yields are: 
(i) very suitable land (80–100 percent),
(ii) suitable land (60–80 percent), 
(iii) moderately suitable land (40–60 percent), 
(iv)marginally suitable land(20–40 percent), 
and (v) unsuitable land(0–20 percent).
*/
replace mean       = mean / 100
rename mean gaez_score
gen suitable40     = 1 if gaez_score>39
replace suitable40 = 0 if suitable40 == .
gen suitable60     = 1 if gaez_score>59
replace suitable60 = 0 if suitable60 == .
gen suitable80     = 1 if gaez_score>79
replace suitable80 = 0 if suitable80 == .

expand 28
sort gid product hs gaez_score
g year =.
bys gid product hs : gen count=_n
replace year = 1980 if count==1
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
replace year = 2007 if year[_n-1] == 2006
drop count
*
save "$Data\GAEZ\temp", replace
*
***********************************************************
* C - MERGE WITH WORLD DEMAND FOR HS COMMODITY AND FINISH *
***********************************************************
*
use "$Data\GAEZ\temp", clear
rename hs hs4
sort hs4 year
merge hs4 year using "$trade\comtrade_hs4_world", nokeep
drop if year<1989
tab _merge
drop _merge
g shock_gaez80 = suitable80*trade
g shock_gaez60 = suitable60*trade
g shock_gaez40 = suitable40*trade
*
collapse (sum) shock_gaez40, by(gid year)
replace shock_gaez40 = . if shock_gaez40 == 0 
*
label var shock_gaez40  "World demand weighted by hs spec., Suitability 40(Gaez)"
sort gid year
*
save "$Output_data\GAEZ_ALL_AFRICA", replace
*
erase "$Data\GAEZ\temp.dta"


