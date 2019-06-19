
*-----------------------------------------------------------------------------------------------------------------------------*
* This do file constructs the agricultural commodities shock used in Berman and Couttenier (2014), based on FAO agromaps data *
* This version uses weights computed at the beginning of the sample period - 1993 or earlier
* This version: nov. 11, 2013
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
keep if year<1994
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
tab _merge
drop _merge
*
/* substract countries' own imports*/
rename country_code iso3
sort iso3 hs4 year
merge iso3 hs4 year using "$trade\comtrade_hs4_all_m", nokeep
tab _merge
replace import_ikt = 0  if _merge == 1
replace trade      = trade - import_ikt
*
g shock_fao = share_prod*trade
*
collapse (sum) shock_fao, by(iso3 area_name area_code admin_level year)
replace shock_fao = . if shock_fao==0
*
label var shock_fao  "World demand weighted by hs spec."
rename area_name region
sort iso3 region year
*
save FAO_ALL_AFRICA, replace
*
erase temp.dta
*
**************************************
* E - ASSOCIATE FAO SHOCK WITH GRIDS *
**************************************
/*
foreach country in AGO BDI	BEN	BFA	BWA	CAF	CIV CMR	COD	COG	CPV	DJI	DZA EGY ERI	ETH	GHA	GIN	GMB	GNB	KEN	LBR	LSO	MAR MDG	MLI	MOZ	MRT	MUS	MWI	NAM	NER	NGA	RWA	SDN	SSD SEN	SLE	SOM	STP	SWZ	TCD	TGO	TUN TZA	UGA	ZAF	ZMB	ZWE{
unzipfile `country'_adm.zip, replace
}
foreach country in AGO BDI	BEN	BFA	BWA	CAF	CIV CMR	COD	COG	CPV	DJI	DZA EGY ERI	ETH	GHA	GIN	GMB	GNB	KEN	LBR	LSO	MAR MDG	MLI	MOZ	MRT	MUS	MWI	NAM	NER	NGA	RWA	SDN SSD	SEN	SLE	SOM	STP	SWZ	TCD	TGO	TUN TZA	UGA	ZAF	ZMB	ZWE{
erase `country'_adm0.csv
erase `country'_adm0.dbf
erase `country'_adm0.prj
erase `country'_adm0.shp
erase `country'_adm0.shx
}
*/
*-----------------------------------------------------------------------------------*
*** Construction of FAO_GID.csv using ArcGis (see read me for more information)    *
*-----------------------------------------------------------------------------------*

insheet using Intersection\FAO_GID.csv,clear
*
***************************************************************************************************************************************
** PATCH BEFORE MERGE **
*  4,474 & 336
*
* AGO *
replace name_1 = "Bie" if name_1   =="Bié"    &  iso=="AGO"
replace name_1 = "Huila" if name_1 =="Huíla"  &  iso=="AGO"
replace name_1 = "Uige" if name_1  =="Uíge"   &  iso=="AGO"
replace name_1 = "" if name_1      =="Bandundu"&  iso=="AGO"

* BDI *
* Small country
replace name_1 = "Bujumbura" if name_1 =="Bujumbura Mairie" & iso=="BDI"
replace name_1 = "Bujumbura" if name_1 =="Bujumbura Rural"  & iso=="BDI"
replace name_1 = "Muramviya" if name_1 =="Muramvya" 		& iso=="BDI"
replace name_1 = "Muramviya" if name_1 =="Mwaro" 			& iso=="BDI"

* BEN *
* No data
drop if iso=="BEN"

* BFA *
replace name_1 = "Centre-Nord" 	if name_1 =="Bam"		  & iso=="BFA"
replace name_1 = "Centre-Sud" 	if name_1 =="Bazéga"  	  & iso=="BFA"
replace name_1 = "Sud-Ouest" 	if name_1 =="Ioba" 		  & iso=="BFA"
replace name_1 = "Centre" 		if name_1 =="Kadiogo" 	  & iso=="BFA"
replace name_1 = "Centre-Est" 	if name_1 =="Kompienga"   & iso=="BFA"
replace name_1 = "Nord" 		if name_1 =="Loroum"      & iso=="BFA"
replace name_1 = "Centre-Ouest" if name_1 =="Nahouri"     & iso=="BFA"
replace name_1 = "Centre-Nord" 	if name_1 =="Namentenga"  & iso=="BFA"
replace name_1 = "Nord" 		if name_1 =="Passoré"    & iso=="BFA"
replace name_1 = "Sud-Ouest" 	if name_1 =="Poni"        & iso=="BFA"
replace name_1 = "Centre-Sud" 	if name_1 =="Zoundwéogo" & iso=="BFA"

replace name_1 = "Cascades" if name_1 =="Léraba" & iso=="BFA"
replace name_1 = "Cascades" if name_1 =="Komoé"  & iso=="BFA"

replace name_1 = "Hauts-Bassins" if name_1 =="Kénédougou" & iso=="BFA"
replace name_1 = "Hauts-Bassins" if name_1 =="Houet"	    & iso=="BFA"
replace name_1 = "Hauts-Bassins" if name_1 =="Tuy" 		    & iso=="BFA"

replace name_1 = "Sud-Ouest" if name_1 =="Pony"		  & iso=="BFA"
replace name_1 = "Sud-Ouest" if name_1 =="Bougouriba" & iso=="BFA"

replace name_1 = "Boucle du Mouhoun" if name_1 =="Banwa"     & iso=="BFA"
replace name_1 = "Boucle du Mouhoun" if name_1 =="Kossi"     & iso=="BFA"
replace name_1 = "Boucle du Mouhoun" if name_1 =="Sourou"    & iso=="BFA"
replace name_1 = "Boucle du Mouhoun" if name_1 =="Nayala"    & iso=="BFA"
replace name_1 = "Boucle du Mouhoun" if name_1 =="Mou Houn"  & iso=="BFA"
replace name_1 = "Boucle du Mouhoun" if name_1 =="Balé"     & iso=="BFA"

replace name_1 = "Centre-Ouest" if name_1 =="Sissili"     & iso=="BFA"
replace name_1 = "Centre-Ouest" if name_1 =="Sanguié"    & iso=="BFA"
replace name_1 = "Centre-Ouest" if name_1 =="Ziro" 		  & iso=="BFA"
replace name_1 = "Centre-Ouest" if name_1 =="Boulkiemdé" & iso=="BFA"

replace name_1 = "Nord" if name_1 =="Yatenga" & iso=="BFA"
replace name_1 = "Nord" if name_1 =="Zondoma" & iso=="BFA"

replace name_1 = "Plateau Central" if name_1 =="Kourwéogo" & iso=="BFA"
replace name_1 = "Plateau Central" if name_1 =="Oubritenga" & iso=="BFA"
replace name_1 = "Plateau Central" if name_1 =="Ganzourgou" & iso=="BFA"

replace name_1 = "Centre-Est" if name_1 =="Boulgou"      & iso=="BFA"
replace name_1 = "Centre-Est" if name_1 =="Koulpélogo"  & iso=="BFA"
replace name_1 = "Centre-Est" if name_1 =="Kouritenga"   & iso=="BFA"

replace name_1 = "Centre-Nord" if name_1 =="Sanmatenga"  & iso=="BFA"

replace name_1 = "Sahel" if name_1 =="Soum"     & iso=="BFA"
replace name_1 = "Sahel" if name_1 =="Oudalan"  & iso=="BFA"
replace name_1 = "Sahel" if name_1 =="Séno"    & iso=="BFA"
replace name_1 = "Sahel" if name_1 =="Yagha"    & iso=="BFA"

replace name_1 = "Est" if name_1 =="Gourma"     & iso=="BFA"
replace name_1 = "Est" if name_1 =="Komondjari" & iso=="BFA"
replace name_1 = "Est" if name_1 =="Gnagna"     & iso=="BFA"
replace name_1 = "Est" if name_1 =="Tapoa"      & iso=="BFA"

* BWA *
replace name_1 = "Central name_1"     if name_1 =="Central" 		& iso=="BWA"
replace name_1 = "Southern name_1"    if name_1 =="Southern" 		& iso=="BWA"
replace name_1 = "Western name_1"     if name_1 =="Kgalagadi"  		& iso=="BWA"
replace name_1 = "Western name_1"     if name_1 =="Ghanzi" 			& iso=="BWA"
replace name_1 = "Southern name_1"    if name_1 =="Southern"   		& iso=="BWA"
replace name_1 = "Gaborone name_1"    if name_1 =="Kweneng"    		& iso=="BWA"
replace name_1 = "Gaborone name_1" 	  if name_1 =="Kgatleng"   		& iso=="BWA"
replace name_1 = "Gaborone name_1" 	  if name_1 =="South-East" 		& iso=="BWA"
replace name_1 = "Central name_1" 	  if name_1 =="Central"     	& iso=="BWA"
replace name_1 = "Francistown name_1" if name_1 =="North-East"  	& iso=="BWA"
replace name_1 = "Maun name_1" 		  if name_1 =="North-West"      & iso=="BWA"

* CAF *
replace name_1 = "Bamingui-Bangora"   if name_1 =="Bamingui-Bangoran" & iso =="CAF"
replace name_1 = "Ombella-M'Poko" 	  if name_1 =="Bangui" 		      & iso =="CAF" // approximation
replace name_1 = "Mambere-Kadei" 	  if name_1 =="Mambéré-Kadéï" & iso =="CAF"
replace name_1 = "Nana-Gribingui"     if name_1 =="Nana-Grébizi" 	  & iso =="CAF"
replace name_1 = "Nana-Mambere"       if name_1 =="Nana-Mambéré"    & iso =="CAF"
replace name_1 = "Ombella-M'Poko"     if name_1 =="Ouham-Pendé" 	  & iso =="CAF"
replace name_1 = "Sangha" 		      if name_1 =="Sangha-Mbaéré"   & iso =="CAF"
replace name_1 = "Ombella-Mpoko"      if name_1 =="Ombella-M'Poko"    & iso =="CAF"

* CIV *
replace name_1 = "MARAHOUE"  		if name_1 =="Marahoué" 		 & iso =="CIV"
replace name_1 = "SAVANES" 			if name_1 =="Savanes" 			 & iso =="CIV"
replace name_1 = "SUD COMOE" 		if name_1 =="Sud-Comoé" 		 & iso =="CIV"
replace name_1 = "WORODOUGOU" 		if name_1 =="WORODOUGOU " 		 & iso =="CIV"
replace name_1 = "AGNEBY" 			if name_1 =="Agnéby" 			 & iso =="CIV"
replace name_1 = "BAFING" 			if name_1 =="Bafing" 			 & iso =="CIV"
replace name_1 = "BAS SASSANDRA" 	if name_1 =="Bas-Sassandra" 	 & iso =="CIV"
replace name_1 = "DENGUELE" 		if name_1 =="Denguélé" 		 & iso =="CIV"
replace name_1 = "FROMAGER" 		if name_1 =="Fromager" 			 & iso =="CIV"
replace name_1 = "HAUT SASSANDRA" 	if name_1 =="Haut-Sassandra" 	 & iso =="CIV"
replace name_1 = "LACS" 		    if name_1 =="Lacs" 				 &  iso =="CIV"
replace name_1 = "LAGUNES" 			if name_1 =="Lagunes" 			 & iso =="CIV"
replace name_1 = "MARAHOUE" 		if name_1 =="Marahoué " 		 & iso =="CIV"
replace name_1 = "MONTAGNES" 		if name_1 =="Dix-Huit Montagnes" & iso =="CIV"
replace name_1 = "MOYEN CAVALLY" 	if name_1 =="Moyen-Cavally" 	 & iso =="CIV"
replace name_1 = "MOYEN COMOE" 		if name_1 =="Moyen-Comoé" 	  	 & iso =="CIV"
replace name_1 = "N'ZI COMOE" 		if name_1 =="N'zi-Comoé" 		 & iso =="CIV"
replace name_1 = "SAVANES" 			if name_1 =="Savanes" 		 	 & iso =="CIV"
replace name_1 = "SUD BANDAMA" 		if name_1 =="Sud-Bandama" 		 & iso =="CIV"
replace name_1 = "SUD COMOE" 		if name_1 =="Sud-Comoé " 		 & iso =="CIV"
replace name_1 = "VAL DU BANDAMA" 	if name_1 =="Vallée du Bandama" & iso =="CIV"
replace name_1 = "WORODOUGOU " 		if name_1 =="Worodougou" 		 & iso =="CIV"
replace name_1 = "ZANZAN" 			if name_1 =="Zanzan" 			 & iso =="CIV"

* CMR *
replace name_1 = "Extreme-Nord"     if name_1 =="Extrême-Nord" & iso =="CMR"
replace name_1 = "Adamoua" 		    if name_1 =="Adamaoua"      & iso =="CMR"

* COD * 
replace name_1 = "Bas-Zaire"		 if name_1 =="Bas-Congo" 		  & iso == "COD"
replace name_1 = "Kasai-Occidental"  if name_1 =="Kasaï-Occidental"  & iso == "COD"
replace name_1 = "Kasai-Oriental" 	 if name_1 =="Kasaï-Oriental" 	  & iso == "COD"
replace name_1 = "Kinshasa" 		 if name_1 =="Kinshasa City" 	  & iso == "COD"
replace name_1 = "Equateur" 		 if name_1 =="Équateur" 		  & iso == "COD"
replace name_1 = "Haut-Zaire" 		 if name_1 =="Orientale" 		  & iso == "COD"
replace name_1 = "Shaba" 			 if name_1 =="Katanga" 			  & iso == "COD"

* COG * 
replace name_1 = "Cuvette" 			 if name_1 =="Cuvette-Ouest"  & iso == "COG"
replace name_1 = "Lekoumou" 		 if name_1 =="Lékoumou" 	  & iso == "COG"
replace name_1 = "Niari" 			 if name_1 =="Kouilou"        & iso == "COG" // approximation
replace name_1 = "Sangha" 			 if name_1 =="Likouala"       & iso == "COG" // approximation

*CPV *
replace name_1 = "Sao Tiago"   if name_1 =="Santa Cruz"  	 & iso == "CPV"
replace name_1 = "Sao Tiago"   if name_1 =="São Domingos"   & iso == "CPV"
replace name_1 = "Sao Tiago"   if name_1 =="Tarrafal"  		 & iso == "CPV"
replace name_1 = "Sao Tiago"   if name_1 =="Santa Catarina"  & iso == "CPV"
replace name_1 = "Fogo" 	   if name_1 =="Mosteiros"       & iso == "CPV"
replace name_1 = "Sao Tiago"   if name_1 =="Praia"  	     & iso == "CPV"
replace name_1 = "Fogo" 	   if name_1 =="São Filipe"     & iso == "CPV"
replace name_1 = "Sao Nicolau" if name_1 =="São Nicolau"    & iso == "CPV"
replace name_1 = "Sao Nicolau" if name_1 =="Sal"             & iso == "CPV" // approximation

* DJI *
* ok

* DZA *
replace name_1 = "Mostaghanem" 			if name_1 =="Mostaganem"		   & iso=="DZA"
replace name_1 = "Ain Dafla" 		    if name_1 =="Aïn Defla" 		   & iso=="DZA"
replace name_1 = "Ain Tamouchent" 		if name_1 =="Aïn Témouchent"     & iso=="DZA"
replace name_1 = "Borjbouarirej" 		if name_1 =="Bordj Bou Arréridj"  & iso=="DZA"
replace name_1 = "Boumerdes"			if name_1 =="Boumerdès"  		   & iso=="DZA"
replace name_1 = "Bejaia" 				if name_1 =="Béjaïa"  		   & iso=="DZA"
replace name_1 = "GhardaSa" 			if name_1 =="Ghardaïa"  		   & iso=="DZA"
replace name_1 = "Bechar" 				if name_1 =="Béchar"  			   & iso=="DZA"
replace name_1 = "Msila" 				if name_1 =="M'Sila" 			   & iso=="DZA"
replace name_1 = "Media" 				if name_1 =="Médéa" 			   & iso=="DZA"
replace name_1 = "Naama" 				if name_1 =="Naâma" 			   & iso=="DZA"
replace name_1 = "Oum El Bouaghi" 		if name_1 =="Oum el Bouaghi" 	   & iso=="DZA"
replace name_1 = "Saida" 				if name_1 =="Saïda" 			   & iso=="DZA"
replace name_1 = "Sidi-Bel-Abbes" 		if name_1 =="Sidi Bel Abbès"      & iso=="DZA"
replace name_1 = "Setif" 				if name_1 =="Sétif" 			   & iso=="DZA"
replace name_1 = "Tamanrasset" 			if name_1 =="Tamanghasset" 		   & iso=="DZA"
replace name_1 = "Tebessa" 				if name_1 =="Tébessa" 			   & iso=="DZA"
replace name_1 = "Tizi-ouzou"		    if name_1 =="Tizi Ouzou" 		   & iso=="DZA"
replace name_1 = "Tendouf" 				if name_1 =="Tindouf" 			   & iso=="DZA"

* EGY *
* Pas de donn�es FAO
drop if iso=="EGY"

* ERI *
replace name_1 = "S. Red-Sea" 	if name_1 =="Debubawi Keyih Bahri" & iso=="ERI"
replace name_1 = "Gash-Barka" 	if name_1 =="Gash Barka" 		   & iso=="ERI"
replace name_1 = "N. Red-Sea" 	if name_1 =="Debub" 			   & iso=="ERI"
replace name_1 = "Debub" 		if name_1 =="Maekel" 			   & iso=="ERI"
replace name_1 = "Anseba" 	    if name_1 =="Semenawi Keyih Bahri" & iso=="ERI"

* ETH *
replace name_1 = "Harari"     if name_1 =="Harari People"  							     & iso=="ETH"
replace name_1 = "Benshangul" if name_1 =="Benshangul-Gumaz"  						     & iso=="ETH"
replace name_1 = "Gambela"    if name_1 =="Gambela Peoples"   					         & iso=="ETH"
replace name_1 = "Oromiya"    if name_1 =="Oromia"   									 & iso=="ETH"
replace name_1 = "Southern"   if name_1 =="Southern Nations, Nationalities and Peoples"  & iso=="ETH"

* GHA *
replace name_1 = "Central"    if name_1 =="Central name_1"   & iso=="GHA"

* GIN *
replace name_1 = "Conakry"    if name_1 =="Conarky"        & iso=="GIN"
replace name_1 = "Boke"       if name_1 =="Boké"   	   & iso=="GIN"
replace name_1 = "Labe"       if name_1 =="Labé"   	   & iso=="GIN"
replace name_1 = "NZerekore"  if name_1 =="Nzérékoré"   & iso=="GIN"

* GMB *
* Pays trop petit - uniquement 2 r�gions au lieu de 6

* GNB *
replace name_1 = "Bafata" if name_1 =="Bafatá" & iso=="GNB"
replace name_1 = "Gabu"   if name_1 =="Gabú"   & iso=="GNB"

* KEN *
replace name_1 = "CENTRAL" 		if name_1 =="Central name_1" & iso=="KEN"
replace name_1 = "CENTRAL" 		if name_1 =="Central" 		 & iso=="KEN"
replace name_1 = "COAST" 		if name_1 =="Coast" 		 & iso=="KEN"
replace name_1 = "EASTERN" 		if name_1 =="Eastern" 		 & iso=="KEN"
replace name_1 = "N. EASTERN" 	if name_1 =="North-Eastern"  & iso=="KEN"
replace name_1 = "NYANZA" 		if name_1 =="Nyanza"	 	 & iso=="KEN"
replace name_1 = "RIFT VALLEY" 	if name_1 =="Rift Valley" 	 & iso=="KEN"
replace name_1 = "WESTERN" 		if name_1 =="Western" 		 & iso=="KEN"
replace name_1 = "NAIROBI" 		if name_1 =="Nairobi" 		 & iso=="KEN"

* LBR *
replace name_1 = "Grand Bassa" 		if name_1 =="Margibi" 	 & iso=="LBR"
replace name_1 = "Bomi Terr." 		if name_1 =="Bomi" 		 & iso=="LBR"
replace name_1 = "Lofa" 			if name_1 =="Gbapolu" 	 & iso=="LBR"
replace name_1 = "Grand Gedeh" 		if name_1 =="GrandGedeh" & iso=="LBR"
replace name_1 = "Grand Bassa" 		if name_1 =="GrandBassa" & iso=="LBR"
replace name_1 = "Kru Coast Terr."  if name_1 =="GrandKru"   & iso=="LBR"
replace name_1 = "Sinoe" 		    if name_1 =="River Cess" & iso=="LBR"
replace name_1 = "Maryland" 		if name_1 =="River Gee"  & iso=="LBR"

* LSO *
replace name_1 = "Quacha'S Nek" 	if name_1 =="Qacha's Nek"   & iso =="LSO"
replace name_1 = "Mohale'S Hoek" 	if name_1 =="Mohale's Hoek" & iso =="LSO"
replace name_1 = "Thaba Tseka" 		if name_1 =="Thaba-Tseka"   & iso =="LSO"

* MAR *
replace name_1 = "Centre" 		if name_1 =="Chaouia - Ouardigha" 					& iso =="MAR"
replace name_1 = "Centre" 		if name_1 =="Doukkala - Abda"  						& iso =="MAR"
replace name_1 = "Centre Nord" 	if name_1 =="Fès - Boulemane" 						& iso =="MAR"
replace name_1 = "Nord Ouest" 	if name_1 =="Gharb - Chrarda - Béni Hssen" 		& iso =="MAR"
replace name_1 = "Centre" 		if name_1 =="Grand Casablanca"  					& iso =="MAR"
replace name_1 = "Sud" 			if name_1 =="Guelmim - Es-Semara"  					& iso =="MAR"
replace name_1 = "Sud" 			if name_1 =="Laâyoune - Boujdour - Sakia El Hamra" & iso =="MAR"
replace name_1 = "Tensift" 		if name_1 =="Marrakech - Tensift - Al Haouz" 		& iso =="MAR"
replace name_1 = "Centre Sud" 	if name_1 =="Meknès - Tafilalet" 					& iso =="MAR"
replace name_1 = "Nord Ouest" 	if name_1 =="Rabat - Salé - Zemmour - Zaer" 		& iso =="MAR"
replace name_1 = "Sud" 			if name_1 =="Souss - Massa - Draâ" 				& iso =="MAR"
replace name_1 = "Centre" 		if name_1 =="Tadla - Azilal" 						& iso =="MAR"
replace name_1 = "Nord Ouest" 	if name_1 =="Tanger - Tétouan" 					& iso =="MAR"
replace name_1 = "Centre Nord"  if name_1 =="Taza - Al Hoceima - Taounate" 			& iso =="MAR"

* MDG *
* ok

* MLI *
replace name_1 = "Koulikoro"    if name_1 =="Bamako"   & iso=="MLI"
replace name_1 = "Segou" 		if name_1 =="Ségou"   & iso=="MLI"
replace name_1 = "Tombouctou"   if name_1 =="Timbuktu" & iso=="MLI"

* MOZ *
* ok

* MRT *
replace name_1 = "Inchiri"  if name_1 =="Dakhlet Nouadhibou" & iso=="MRT"
replace name_1 = "Trarza"   if name_1 =="Nouakchott" 		 & iso=="MRT"
* replace name_1 = "" if name_1 =="Tiris Zemmour" // no value for FAO Data set

* MWI *
* mieux si on prend administrative 2
replace name_1 = "Southern" if name_1 =="Balaka" 		& iso=="MWI"
replace name_1 = "Central"  if name_1 =="Dowa" 			& iso=="MWI"
replace name_1 = "Southern" if name_1 =="Mulanje"  		& iso=="MWI"
replace name_1 = "Southern" if name_1 =="Nsanje"  		& iso=="MWI"
replace name_1 = "Southern" if name_1 =="Blantyre" 		& iso=="MWI"
replace name_1 = "Southern" if name_1 =="Chikwawa" 		& iso=="MWI"
replace name_1 = "Southern" if name_1 =="Chiradzulu" 	& iso=="MWI"
replace name_1 = "Northern" if name_1 =="Chitipa" 		& iso=="MWI"
replace name_1 = "Central"  if name_1 =="Dedza" 		& iso=="MWI"
replace name_1 = "Northern" if name_1 =="Karonga" 		& iso=="MWI"
replace name_1 = "Central"  if name_1 =="Kasungu" 		& iso=="MWI"
replace name_1 = "Central"  if name_1 =="Lilongwe" 		& iso=="MWI"
replace name_1 = "Southern" if name_1 =="Machinga" 		& iso=="MWI"
replace name_1 = "Southern" if name_1 =="Mangochi" 		& iso=="MWI"
replace name_1 = "Central"  if name_1 =="Mchinji" 		& iso=="MWI"
replace name_1 = "Southern" if name_1 =="Mwanza" 		& iso=="MWI"
replace name_1 = "Northern" if name_1 =="Mzimba" 		& iso=="MWI"
replace name_1 = "Northern" if name_1 =="Nkhata Bay" 	& iso=="MWI"
replace name_1 = "Central"  if name_1 =="Nkhotakota" 	& iso=="MWI"
replace name_1 = "Southern" if name_1 =="Ntcheu" 		& iso=="MWI"
replace name_1 = "Central"  if name_1 =="Ntchisi" 		& iso=="MWI"
replace name_1 = "Southern" if name_1 =="Phalombe" 		& iso=="MWI"
replace name_1 = "Northern" if name_1 =="Rumphi" 		& iso=="MWI"
replace name_1 = "Central"  if name_1 =="Salima" 		& iso=="MWI"
replace name_1 = "Southern" if name_1 =="Thyolo" 		& iso=="MWI"
replace name_1 = "Southern" if name_1 =="Zomba" 		& iso=="MWI"

* NAM *
* replace name_1 = "" if name_1 =="Erongo"  // no information in FAO data
replace name_1   = "Okavango" if name_1 =="Kavango" & iso=="NAM"

* NER *
replace name_1 = "Tillabery" if name_1 =="Niamey"     & iso=="NER"
replace name_1 = "Tillabery" if name_1 =="Tillabéry" & iso=="NER"

* NGA *
replace name_1 = "FCT, Abuja" if name_1 =="Federal Capital Territory" & iso =="NGA"
replace name_1 = "Borno"      if name_1 =="Water body" // Approximation

* RWA *
replace name_1 = "Kibungo"      if name_1 =="Kibungu" & iso =="RWA"
replace name_1 = "Kigali-ngali" if name_1 =="Kigali"  & iso =="RWA"

* SDN *
replace name_1 = "Central"      if name_1 =="Blue Nile"      & iso =="SDN"
replace name_1 = "Eastern"      if name_1 =="Kassala"        & iso =="SDN"
*replace name_1 = "" if name_1 =="Khartoum" // no information in FAO. On lui attribue quoi comme r�gion?
* les trois suivants sont le Sud Soudan: attribution de la zone FAO la plus proche
*replace name_1 = "" if name_1 =="Equatoria" // rien
replace name_1 = "Darfur"       if name_1 =="Bahr el Ghazal" & iso =="SDN"
replace name_1 = "Kordufan"     if name_1 =="Upper Nile"     & iso =="SDN"

* SEN *
replace name_1 = "Saint Louis" if name_1 =="Matam"       & iso =="SEN"
replace name_1 = "Saint Louis" if name_1 =="Saint-Louis" & iso =="SEN"
replace name_1 = "Thies" 	   if name_1 =="Thiès"      & iso =="SEN"

* SLE *
replace name_1 = "Eastern" if name_1 =="EASTERN" & iso =="SLE"
replace name_1 = "Western" if name_1 =="WESTERN" & iso =="SLE"

* SOM  *
replace name_1 = "Gado" 	 if name_1 =="Gedo"  			 & iso =="SOM"
replace name_1 = "Hiiran" 	 if name_1 =="Hiiraan" 			 & iso =="SOM"
replace name_1 = "J. Dhexe"  if name_1 =="Jubbada Dhexe" 	 & iso =="SOM"
replace name_1 = "J. Hoose"  if name_1 =="Jubbada Hoose" 	 & iso =="SOM"
replace name_1 = "Sh. Dhexe" if name_1 =="Shabeellaha Dhexe" & iso =="SOM"
replace name_1 = "Sh. Hoose" if name_1 =="Shabeellaha Hoose" & iso =="SOM"
/*
* No information in FAO (east part of the country)
replace name_1 = "" if name_1 =="Awdal"
replace name_1 = "" if name_1 =="Bari"
replace name_1 = "" if name_1 =="Galguduud"
replace name_1 = "" if name_1 =="Mudug"
replace name_1 = "" if name_1 =="Nugaal"
replace name_1 = "" if name_1 =="Sanaag"
replace name_1 = "" if name_1 =="Sool"
replace name_1 = "" if name_1 =="Togdheer"
replace name_1 = "" if name_1 =="Woqooyi Galbeed"
*/

* STP *
replace name_1 = "Principe" if name_1 =="Príncipe" & iso =="STP"
replace name_1 = "Sao Tome" if name_1 =="Principe"  & iso =="STP"

* SWZ *
* ok

* TCD *
*replace name_1 = "" if name_1 =="Bet" // pas de donn�es FAO
replace name_1 = "Chari-Baguimi" 		if name_1 =="Chari-Baguirmi" 		& iso =="TCD"
replace name_1 = "Guera" 				if name_1 =="Guéra"  				& iso =="TCD"
replace name_1 = "Chari-Baguimi" 		if name_1 =="Hadjer-Lamis" 			& iso =="TCD"
replace name_1 = "Logone Oriental" 		if name_1 =="Mandoul" 				& iso =="TCD"
replace name_1 = "Mayo-Kebbi" 			if name_1 =="Mayo-Kebbi Est" 		& iso =="TCD"
replace name_1 = "Mayo-Kebbi" 			if name_1 =="Mayo-Kebbi Ouest" 		& iso =="TCD"
replace name_1 = "Ouaddai" 				if name_1 =="Ouaddaï" 				& iso =="TCD"
replace name_1 = "Tandjile" 			if name_1 =="Tandjilé" 			& iso =="TCD"
replace name_1 = "Chari-Baguimi" 		if name_1 =="Ville de N'Djamena" 	& iso =="TCD"
replace name_1 = "Biltine" 				if name_1 =="Wadi Fira" 			& iso =="TCD"
replace name_1 = "Bol" 					if name_1 =="Lac" 					& iso =="TCD"
replace name_1 = "Bol" 					if name_1 =="Hadjer-Lamis"  		& iso =="TCD"

* TGO *
replace name_1 = "Savanes" if name_1 =="SAVANES"  & iso =="TGO"

* TUN *
* pas fait car chiant
drop if iso == "TUN"
* TZA *
*replace name_1 = "" if name_1 =="Kaskazini-Pemba"// Island
*replace name_1 = "" if name_1 =="Kusini-Pemba" // Island
replace name_1  = "Arusha" if name_1 =="Manyara"
*replace name_1 = "" if name_1 =="Southern" // pas trouv�
*replace name_1 = "" if name_1 =="Zanzibar South and Central" // Island

* UGA *
replace name_1 = "Iganga"    if name_1 =="Bugiri" 		 & iso=="UGA"
replace name_1 = "Tororo"    if name_1 =="Busia" 		 & iso=="UGA"
replace name_1 = "Kabarole"  if name_1 =="Kamwenge" 	 & iso=="UGA"
replace name_1 = "Mukono"    if name_1 =="Kayunga" 		 & iso=="UGA"
replace name_1 = "Iganga"    if name_1 =="Mayuge" 		 & iso=="UGA"
replace name_1 = "Masaka"    if name_1 =="Sembabule" 	 & iso=="UGA"
replace name_1 = "Mpigi"     if name_1 =="Wakiso" 		 & iso=="UGA"
replace name_1 = "Arua"      if name_1 =="Yumbe" 		 & iso=="UGA"
replace name_1 = "Moyo"      if name_1 =="Adjumani" 	 & iso=="UGA"
replace name_1 = "Soroti"    if name_1 =="Kaberamaido" 	 & iso=="UGA"
replace name_1 = "Rukungiri" if name_1 =="Kanungu" 		 & iso=="UGA"
replace name_1 = "Soroti"    if name_1 =="Katakwi" 		 & iso=="UGA"
replace name_1 = "Kibaale"   if name_1 =="Kibale" 		 & iso=="UGA"
replace name_1 = "Kabarole"  if name_1 =="Kyenjojo" 	 & iso=="UGA"
replace name_1 = "Hoima"     if name_1 =="Lake Albert"   & iso=="UGA"
replace name_1 = "Moroto"    if name_1 =="Nakapiripirit" & iso=="UGA"
replace name_1 = "Luwero"    if name_1 =="Nakasongola"   & iso=="UGA"
replace name_1 = "Bushenyi"  if name_1 =="Ntungamo"      & iso=="UGA"
replace name_1 = "Kitgum"    if name_1 =="Pader"         & iso=="UGA"
replace name_1 = "Mbale"     if name_1 =="Sironko"       & iso=="UGA"

* ZAF *
replace name_1 = "Guateng" 				if name_1 =="Gauteng"  		     & iso=="ZAF"
replace name_1 = "Kwazulu/Natal" 		if name_1 =="KwaZulu-Natal"      & iso=="ZAF"
replace name_1 = "Northern Province" 	if name_1 =="Limpopo"  			 & iso=="ZAF"
replace name_1 = "Free State" 			if name_1 =="Orange Free State"  & iso=="ZAF"

* ZMB *
replace name_1 = "North Western" 	if name_1 =="North-Western"     & iso=="ZMB"
replace name_1 = "Southern" 		if name_1 =="Southern name_1"   & iso=="ZMB"

* ZWE*
replace name_1 = "Matabeleland North" if name_1 =="Bulawayo"   & iso=="ZWE" // approximation
replace name_1 = "Mashonaland West"   if name_1 =="Harare"     & iso=="ZWE" // approximation

/* collapse to get only unique cell/region/iso */ 
collapse (sum) area percentage, by(gid name_0 name_1 iso)
duplicates report gid name_1 iso

***************************************************************************************************************************************
** End Patch

/* some checks */
g test = 1
bys gid: egen count = sum(test)
bys gid: egen sum = sum(percentage)
sum sum, d
sum sum if iso == "GAB", d
*
/* allocate remaining percentage to coastal cells */
replace percentage = 100                if count == 1 & sum < 100
replace percentage = percentage*100/sum if sum < 100 & count > 1
drop sum 
bys gid: egen sum = sum(percentage)
sum sum, d
*
replace iso = "SDN" if iso == "SSD"
rename iso iso_fao
sort gid
save FAO_PRIO_GRID, replace
*
/* to check the name of country for each cells */ 
use gid_iso, clear
keep gid iso_1
sort gid
*
merge gid using FAO_PRIO_GRID
keep if _merge == 3 // les merges == 2 : toutes petites iles
drop _merge
*
gen t = 1 if iso_fao != iso_1 // 162 mismatchs
drop iso_fao
rename iso_1  iso3
rename name_1 region
rename name_0 country
gen region_ini = region
*
replace country ="Cote D'Ivoire" 					  if country =="Côte d'Ivoire"
replace country ="Congo (Democratic Republic of the)" if country =="Democratic Republic of the Congo"
replace country ="The Gambia" 						  if country =="Gambia"
replace iso     = "SDN" 							  if country =="South Sudan"
sort country
save FAO_PRIO_GRID, replace
*
* Add on: modif iso pour garder toutes les cellules (cellules se r�p�tent)
use gid_iso, clear
keep country_1 iso_1
rename country_1 country
rename iso_1 iso3_n
gen t = 1
collapse t, by(country iso3_n)
sort country
merge country using FAO_PRIO_GRID
drop if _merge == 1
drop _merge
replace iso3 = iso3_n if iso3!=iso3_n
replace iso3 = "SDN" if country =="South Sudan"
sort region
sort gid region iso3 
replace percentage = percentage / 100
save GRID_PERCENTAGE, replace
*
drop test
g test = 1
collapse (mean) test, by(gid iso3 region)
*
expand 28
sort gid iso3 region
g year =.
bys gid iso3 region: gen count=_n
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
sort gid region iso3 
drop test
merge gid region iso3 using GRID_PERCENTAGE, nokeep
tab _merge
drop _merge
compress
sort iso3 region
save FAO_PRIO_GRID, replace
*
use FAO_PRIO_GRID, replace
*
sort iso3 region year
merge iso3 region year using FAO_ALL_AFRICA
tab _merge if year>1989 & year<2008
*
keep if _merge == 3 // all is good
drop _merge
*
sort gid year
*
replace shock_fao = shock_fao*percentage/100
*
bys gid year: egen max_perc   = max(percentage)
egen region_group 			  = group(region iso3)
g temp 						  = region_group if max_perc == percentage
bys gid year: egen region_fao = max(region_group)
*
collapse (sum) shock_fao_w0=shock_fao, by(gid year region_fao)
*
label var shock_fao "World demand weighted by hs spec., weights before 1993"
*
drop region_fao
sort gid year
*
cd "$Output_data"
save FAO_PRIO_GRID_w0, replace
*
cd "$fao"
erase FAO_ALL_AFRICA.dta
erase FAO_PRIO_GRID.dta
erase GRID_PERCENTAGE.dta
cd "$Output_data"

