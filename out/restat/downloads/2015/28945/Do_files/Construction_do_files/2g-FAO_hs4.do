*-----------------------------------------------------------------------------------------------------------------------------*
* This do file constructs the agricultural commodities at the HS4 level (Table A.29)										  *
* This version: sept. 18, 2014
*-----------------------------------------------------------------------------------------------------------------------------*

cd "$fao\Agromaps"

***************************
* A - APPEND ALL FAO DATA *
***************************
*
foreach country in AGO BDI BEN	BFA	BWA	CAF	CIV CMR	COD	COG	CPV	DJI	DZA EGY ERI	ETH	GHA	GIN	GMB	GNB	KEN	LBR	LSO	MAR MDG	MLI	MOZ	MRT	MUS	MWI	NAM	NER	NGA	RWA	SDN	SEN	SLE	SOM	STP	SWZ	TCD	TGO	TUN TZA	UGA	ZAF	ZMB	ZWE{
unzipfile `country'.zip, replace
clear
insheet using `country'_all_data.csv
save `country', replace
erase `country'_all_data.csv
}
use AGO, clear
foreach country in BDI	BEN	BFA	BWA	CAF	CIV CMR	COD	COG	CPV	DJI	DZA EGY ERI	ETH	GHA	GIN	GMB	GNB	KEN	LBR	LSO	MAR MDG	MLI	MOZ	MRT	MUS	MWI	NAM	NER	NGA	RWA	SDN	SEN	SLE	SOM	STP	SWZ	TCD	TGO	TUN TZA	UGA	ZAF	ZMB	ZWE{
append using `country'
}
foreach country in AGO BDI	BEN	BFA	BWA	CAF	CIV CMR	COD	COG	CPV	DJI	DZA EGY ERI	ETH	GHA	GIN	GMB	GNB	KEN	LBR	LSO	MAR MDG	MLI	MOZ	MRT	MUS	MWI	NAM	NER	NGA	RWA	SDN	SEN	SLE	SOM	STP	SWZ	TCD	TGO	TUN TZA	UGA	ZAF	ZMB	ZWE{
erase `country'.dta
}
*
cd "$fao"
*
sort area_code item_name year
drop if year == "Most recent"
*
/* keep administrative level == 1  */
keep if admin_level == 1
*
/* product codes */
sort item_name
merge item_name using hs, nokeep
tab _merge
tab item_name if _merge == 1
drop _merge
*
destring hs, replace force
*
/* take average production */
destring year, replace force
collapse (mean) yield production aerea_harvested (max) max_year = year (min) min_year = year (mean) mean_year = year, by(country_code area_code area_name admin_level hs)
*
/* balance dataset (all product for each region) */
sort country_code area_code area_name admin_level hs
save temp, replace
*
g test = 1 
collapse (sum) test, by(country_code area_code area_name admin_level)
drop test
*
expand 52
sort country_code area_code area_name admin_level
g hs = .
label var hs "HS4 product classification"
bys country_code area_code area_name admin_level: gen count = _n
*
replace hs = 	701		if count == 1	
replace hs = 	702		if hs[_n-1] ==	701
replace hs = 	703		if hs[_n-1] ==	702
replace hs = 	704		if hs[_n-1] ==	703
replace hs = 	705		if hs[_n-1] ==	704
replace hs = 	706		if hs[_n-1] ==	705
replace hs = 	707		if hs[_n-1] ==	706
replace hs = 	709		if hs[_n-1] ==	707
replace hs = 	710		if hs[_n-1] ==	709
replace hs = 	711		if hs[_n-1] ==	710
replace hs = 	713		if hs[_n-1] ==	711
replace hs = 	714		if hs[_n-1] ==	713
replace hs = 	801		if hs[_n-1] ==	714
replace hs = 	802		if hs[_n-1] ==	801
replace hs = 	803		if hs[_n-1] ==	802
replace hs = 	804		if hs[_n-1] ==	803
replace hs = 	805		if hs[_n-1] ==	804
replace hs = 	806		if hs[_n-1] ==	805
replace hs = 	807		if hs[_n-1] ==	806
replace hs = 	808		if hs[_n-1] ==	807
replace hs = 	809		if hs[_n-1] ==	808
replace hs = 	810		if hs[_n-1] ==	809
replace hs = 	901		if hs[_n-1] ==	810
replace hs = 	902		if hs[_n-1] ==	901
replace hs = 	904		if hs[_n-1] ==	902
replace hs = 	905		if hs[_n-1] ==	904
replace hs = 	907		if hs[_n-1] ==	905
replace hs = 	910		if hs[_n-1] ==	907
replace hs = 	1001	if hs[_n-1] ==	910
replace hs = 	1003	if hs[_n-1] ==	1001
replace hs = 	1004	if hs[_n-1] ==	1003
replace hs = 	1005	if hs[_n-1] ==	1004
replace hs = 	1006	if hs[_n-1] ==	1005
replace hs = 	1007	if hs[_n-1] ==	1006
replace hs = 	1008	if hs[_n-1] ==	1007
replace hs = 	1106	if hs[_n-1] ==	1008
replace hs = 	1201	if hs[_n-1] ==	1106
replace hs = 	1202	if hs[_n-1] ==	1201
replace hs = 	1204	if hs[_n-1] ==	1202
replace hs = 	1206	if hs[_n-1] ==	1204
replace hs = 	1207	if hs[_n-1] ==	1206
replace hs = 	1212	if hs[_n-1] ==	1207
replace hs = 	1511	if hs[_n-1] ==	1212
replace hs = 	1512	if hs[_n-1] ==	1511
replace hs = 	1514	if hs[_n-1] ==	1512
replace hs = 	1801	if hs[_n-1] ==	1514
replace hs = 	1904	if hs[_n-1] ==	1801
replace hs = 	2401	if hs[_n-1] ==	1904
replace hs = 	4001	if hs[_n-1] ==	2401
replace hs = 	5303	if hs[_n-1] ==	4001
replace hs = 	5304	if hs[_n-1] ==	5303
replace hs = 	5305	if hs[_n-1] ==	5304
*
drop count
*
sort country_code area_code area_name admin_level hs
merge country_code area_code area_name admin_level hs using temp, nokeep
tab _merge
*
replace production      = 0 if production == . & aerea_harvested == . & yield == .
replace aerea_harvested = 0 if production == 0 & aerea_harvested == . & yield == .
replace yield           = 0 if production == 0 & aerea_harvested == 0 & yield == .
*
drop _merge
*
sort country_code area_code area_name admin_level hs
save FAO_ALL_AFRICA, replace
erase temp.dta
*
************************************************
* B -MERGE WITH UNIT VALUES AND COMPUTE SHARES *
************************************************
*
use FAO_ALL_AFRICA, clear
*
sort hs
merge hs using "$trade\unit_values", nokeep
tab _merge
drop _merge
*
sort country_code area_code area_name admin_level hs
egen fao_region = group(country_code area_code area_name admin_level)
*
replace production                   = production*uv
bys fao_region: egen production_tot  = sum(production)
g share_prod						 = production/production_tot
*
drop production* uv*
sort country_code area_code area_name admin_level hs 
save temp, replace
*
******************************
* C - BALANCE DATA FOR PANEL *
******************************
*
keep country_code area_code area_name admin_level hs
sort country_code area_code area_name admin_level hs
g test=1
collapse (mean) test, by(country_code area_code area_name admin_level hs)
*
expand 28
sort country_code area_code area_name admin_level hs
g year =.
bys country_code area_code area_name admin_level hs: gen count = _n
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
compress
sort country_code area_code area_name admin_level hs
merge country_code area_code area_name admin_level hs using temp, nokeep
tab _merge
drop _merge
sort country_code area_code area_name admin_level hs year
save temp, replace
*
************************************************
* D - MERGE WITH WORLD DEMAND FOR HS COMMODITY *
************************************************
*
use temp, clear
rename hs hs4
sort hs4 year
merge hs4 year using "$trade\comtrade_hs4_world", nokeep
drop if year < 1989
tab  _merge
drop _merge
*
/* substract countries' own imports*/
rename country_code iso3
*
g shock_fao = share_prod*trade
*
collapse (sum) trade, by(hs4 year)
tsset hs4 year
tab year, gen(yeard)
g ltrade = log(trade)

qui: tab hs4, g(Ihs_)
	gen trendyear = year-1992 
*
forvalues i=1/52 {
	gen Itrendhs_`i' = Ihs_`i'*trendyear
	label var Itrendhs_`i' "Trade specific to hs4 product `x'"
}
g dtrade=d.ltrade
sort hs4 year
label var trade  "World imports HS4 product"
label var dtrade "delta log World imports HS4 product"
label var ltrade "log World imports HS4 product"
label var year 	 "year"
*
cd "$Output_data"
save FAO_hs4, replace
cd "$fao"
erase temp.dta
