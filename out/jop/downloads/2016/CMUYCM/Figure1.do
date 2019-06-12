clear
cd map\shapefiles
shp2dta using kommuner_1918, database(Norwaydb) coordinates(Norwaycord) genid(id) replace

use Norwaydb

destring KNR, replace
destring FNR, replace
gen knr=KOMMNR
gen knavn=KNAVN
gen fnr=FNR
drop FNR KNR KOMMNR KNAVN

sort knr

merge knr using "../../dta/Districts1918"
*** those with merge==1 are municipalities with mulitple districts
*** those with merge==2 are within municipality districts /* SHOULD be dropped for map */
drop if _merge==2
replace districtname=knavn if _merge==1
replace valgkrets=knr if _merge==1  /* THIS IS NOT ACCURATE SINCE THERE ARE MULTIPLE DISTRICTS WITHIN MUNICIP */

replace districtname="Trondheim / Levanger" if knr==1601| knr==1701
replace valgkrets=1601 if knr==1701

*********************************************************
*********************************************************
*********************************************************

/* SIMPLE MAP OF NORWAY */

gen zz=1

spmap zz using Norwaycord, id(id) legend(pos(5))  title("", pos(11)) fcolor(gray*0.25) clmethod(unique) legenda(off)  
graph save ..\Norway.gph, replace
graph export ..\Norway.eps, replace
graph export ..\Norway.tif, replace


*********************************************************
*********************************************************
*********************************************************

/* MAP OF EACH COUNTY */

*foreach i in 1 2 4 5 6 7 8 9 10 11 12 14 15 16 17 18 19 20{
*spmap valgkrets if fnr==`i' using Norwaycord, id(id) legend(pos(5) size(2))  title("", pos(11)) clmethod(unique) leglabel(districtname)
*graph export ..\Norway_county`i'.tif, replace
*}

*********************************************************
*********************************************************
*********************************************************

/* PR_district */

g PR_district = 0
replace PR_district =1 if knr<200
replace PR_district =2 if knr>200 & knr<300
replace PR_district =3 if knr==301
replace PR_district =4 if knr>400 & knr<500
replace PR_district =5 if knr>500 & knr<600
replace PR_district =6 if knr>600 & knr<700
replace PR_district =7 if knr>700 & knr<800
replace PR_district =8 if knr>800 & knr<900
replace PR_district =9 if knr>900 & knr<1000
replace PR_district =10 if knr>1000 & knr<1100
replace PR_district =11 if knr>1100 & knr<1200
replace PR_district =12 if knr>1200 & knr<1300
replace PR_district =13 if knr>1300 & knr<1400
replace PR_district =14 if knr>1400 & knr<1500
replace PR_district =15 if knr>1500 & knr<1600
replace PR_district =16 if knr>1600 & knr<1700
replace PR_district =17 if knr>1700 & knr<1800
replace PR_district =18 if knr>1800 & knr<1900
replace PR_district =19 if knr>1900 & knr<2000
replace PR_district =20 if knr>2000 


*** KJOPSTEDER

/* 4 REP */
replace PR_district=21 if knr==101  /* fredrikshald */  
replace PR_district=21 if knr==102  /* sarpsborg */
replace PR_district=21 if knr==103  /* fredrikstad */
replace PR_district=21 if knr==104  /* moss */
replace PR_district=21 if knr==203  /* drøbak */
/* 7 REP */
replace PR_district=22 if knr==301  /* oslo  */  
/* 3 REP */
replace PR_district=23 if knr==401  /* hamar */   
replace PR_district=23 if knr==402  /* kongsvinger */
replace PR_district=23 if knr==501  /* lillehammer */
replace PR_district=23 if knr==502  /* gjøvik */
/* 3 REP */
replace PR_district=24 if knr==602 /* drammen */
replace PR_district=24 if knr==604  /* kongsberg */
replace PR_district=24 if knr==601  /* hønefoss */
/* 4 REP */
replace PR_district=25 if knr==703  /* horten */
replace PR_district=25 if knr==705  /* tønsberg */
replace PR_district=25 if knr==706  /* sandefjord */
replace PR_district=25 if knr==707  /* larvik */
replace PR_district=25 if knr==702  /* holmestrand */
/* 5 REP */
replace PR_district=26 if knr==807  /* notodden */
replace PR_district=26 if knr==806  /* skien */
replace PR_district=26 if knr==805  /* porsgrund */
replace PR_district=26 if knr==804  /* brevik */
replace PR_district=26 if knr==801  /* kragerø */
replace PR_district=26 if knr==901  /* risør */
replace PR_district=26 if knr==903  /* arendal */
replace PR_district=26 if knr==904  /* grimstad */
/* 7 REP */
replace PR_district=27 if knr==1001 /* kristiansand */
replace PR_district=27 if knr==1002 /* mandal */
replace PR_district=27 if knr==1004 /* flekkefjord */
replace PR_district=27 if knr==1103 /* stavanger */
replace PR_district=27 if knr==1106 /* haugesund */
/* 5 REP */
replace PR_district=28 if knr==1301 /* bergen */
/* 3 REP */
replace PR_district=29 if knr==1502 /* molde */
replace PR_district=29 if knr==1501 /* ålesund */
replace PR_district=29 if knr==1503 /* kristiansund */
/* 5 REP */
replace PR_district=30 if knr==1601 /* trondheim */
replace PR_district=30 if knr==1701 /* levanger */
/* 4 REP */
replace PR_district=31 if knr==1804 /* bodoe */
replace PR_district=31 if knr==1805 /* narvik */
replace PR_district=31 if knr==1902 /* tromsoe */
replace PR_district=31 if knr==2002 /* vardoe */
replace PR_district=31 if knr==2003 /* vadsoe */
replace PR_district=31 if knr==2001 /* hammerfest */

spmap valgkrets using Norwaycord, id(id) legenda(off) title("", pos(11)) split clmethod(unique) fcolor(blue brown cranberry ebblue gray*0.5 dkgreen dknavy dkorange emerald forest_green gold gray green khaki lavender lime ltblue sand maroon olive_teal dkorange brown cranberry ebblue gray*0.5 dkgreen dknavy dkorange emerald forest_green gold gray green khaki lavender lime ltblue sand maroon olive_teal dkorange brown cranberry ebblue gray*0.5 dkgreen dknavy dkorange emerald forest_green gold gray green khaki lavender lime ltblue sand maroon olive_teal dkorange brown cranberry ebblue gray*0.5 dkgreen dknavy dkorange emerald forest_green gold gray green khaki lavender lime ltblue sand maroon olive_teal dkorange brown cranberry ebblue gray*0.5 dkgreen dknavy dkorange emerald forest_green gold gray green khaki lavender lime ltblue sand maroon olive_teal dkorange brown cranberry ebblue gray*0.5 dkgreen dknavy dkorange emerald forest_green gold gray green khaki lavender lime ltblue sand maroon olive_teal dkorange brown cranberry ebblue gray*0.5 dkgreen dknavy dkorange emerald forest_green gold gray green khaki lavender lime ltblue sand maroon olive_teal dkorange brown cranberry ebblue gray*0.5 dkgreen dknavy dkorange emerald forest_green gold gray green khaki lavender lime ltblue sand maroon olive_teal dkorange brown cranberry ebblue gray*0.5 dkgreen dknavy dkorange emerald forest_green gold gray green khaki lavender lime ltblue sand maroon olive_teal dkorange brown cranberry ebblue gray*0.5 dkgreen dknavy dkorange emerald forest_green gold gray green khaki lavender lime ltblue sand maroon olive_teal)
graph save ..\SMDmap.gph, replace
graph export ..\SMDmap.eps, replace
graph export ..\SMDmap.tif, replace

spmap PR_district using Norwaycord, id(id) legenda(off) title("", pos(11)) split clmethod(unique) fcolor(blue brown cranberry ebblue gray*0.5 dkgreen dknavy dkorange emerald forest_green gold gray green khaki lavender sand ltblue maroon blue brown cranberry ebblue gray*0.5 dkgreen dknavy dkorange emerald forest_green gold gray green khaki lavender sand ltblue maroon)
graph save ..\PRMap.gph, replace
graph export ..\PRMap.eps, replace
graph export ..\PRMap.tif, replace

cd ..\..\
