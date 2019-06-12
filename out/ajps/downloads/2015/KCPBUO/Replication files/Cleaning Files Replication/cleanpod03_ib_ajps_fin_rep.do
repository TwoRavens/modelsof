
log using "cleanpod03_ib_ajps_fin_rep.log", replace

****************************************************************************************
* cleanpod03_ib_ajps_fin_rep.do
* 
* This do-file prepares the 2002 dataset for analysis for
* Institutional Basis of Order paper. Replication.
* Yuhki Tajima
* 
* Updated: 19 Sept 2012
****************************************************************************************

**************************************
* MERGE PODES 2003 DATASETS INTO ONE *
**************************************

use podes03d1sort

merge 1:1 villageid using podes03a1sort
ren _merge _merge_pd03DA
label var _merge_pd03DA "_merge: podes03d1sort + podes03a1sort" 

sort villageid
merge 1:1 villageid using podes03b1sort
ren _merge _merge_pd03DAB
label var _merge_pd03DAB "_merge: podes03d1sort + podes03a1sort + podes03b1sort"

*************************************
* PREPARE IDENTIFIERS FOR CROSSWALK *
*************************************

gen kecid03=prop*100000+kab*1000+kec
gen kabid03=prop*100+kab

ren villageid id2003
ren prop proppd03

gen double id2002=prop2002*100000000+kab2002*1000000+kec2002*1000+desa2002
sort id2002

***************************************************
* MERGE IN THE ID NUMBERS FOR 2000 FROM CROSSWALK *
***************************************************

merge m:1 id2002 using cross9802d, keepusing(id2000 nm2000)
rename _merge _merge_cross
sort id2000

***********************************************
* MERGE IN THE CENSUS DATA ON 2000 ID NUMBERS *
***********************************************

merge m:m id2000 using censclean-id 
rename _merge _merge_census
ren prop propcen
ren proppd03 prop

********************************
** GENERATE DEPENDENT VARIABLE *
********************************

**********
* HORIZ2 *
********** 
**Generate a variable for horizontal conflict which is 1 if in the previous year the most common type of conflict is described as 
**1) Intergroup fighting ('perkelahian antar kelompok warga') or 4) Inter-ethnic fighting ('Perkelahian antar suku')

gen horiz2=0 if b17r1703==2
replace horiz2=1 if b17r1704a==1 | b17r1704a==4
replace horiz2=0 if b17r1704a==2|b17r1704a==3|b17r1704a==5
label var horiz2 "Communal Violence in Village Last 12 Months"

*************************************************
* GENERATE VARIABLES FOR HOW CONFLICTS RESOLVED *
*************************************************

************
* COMM_RES *
************
** Conflict resolved by community **
g comm_res=0 if  b17r1704e!=.
replace comm_res=1 if b17r1704e==1
label var comm_res "Conflict Resolved by Community"

**************
* VILAPP_RES *
**************
** Conflict resolved by village apparatus **
g vilapp_res=0 if b17r1704e!=.
replace vilapp_res=1 if b17r1704e==2
label var vilapp_res "Conflict resolved by village apparatus"

**************
* NON_SF_RES *
**************
** Conflict resolved by non-security force actors (community or village apparatus) **
g non_sf_res=0 if b17r1704e!=.
replace non_sf_res=1 if comm_res==1 | vilapp_res==1
label var non_sf_res "Conflict resolved by non-security force actors (community or village apparatus)"

********************************************************************
* GENERATE VARIABLE FOR TOTAL COMMUNITY SECURITY GUARDS IN VILLAGE *
********************************************************************
g tot_hansip= b17r1709
label var tot_hansip "Total Community Security Guards in Village"

***********************************
** GENERATE INDEPENDENT VARIABLES *
***********************************

**************
**DISTPOSPOL**
**************
**If there is no police post, b17r1708b3 is the distance between the closest police post and the village
gen distpospol=b17r1708b3
label var distpospol "Distance to Nearest Police Post"

***********
* DISTKEC *
***********

g distkec=b3r313
drop if distkec>100
label var distkec "Distance to Subdistrict Office"

***************************
**VILLAGEPOP / LOGVILLPOP**
***************************
**Generate village population
gen villagepop = b4r402a+b4r402b
label var villagepop "Village Population (Podes)"

gen logvillpop=ln(villagepop)
label var logvillpop "Log of Village Population (Podes)"


***************************
**DENSITYVIL / LOGDENSVIL**
***************************
**Generate population density
gen densityvil = villagepop/b12r1201
label var densityvil "Population Density of Village"

gen logdensvil = ln(densityvil)
label var logdensvil "Log of Population Density of Village"

************
**NUMHHVIL**
************
**Number of households in a village
gen numhhvil=b4r402c
label var numhhvil "Number of HH in Village"

***********
**NUMHHSD**
***********
**Number of households in a sub-district

sort kecid03
egen numhhsd=sum(numhhvil), by(kecid03)
label var numhhsd "Number of HH in Sub-District"

**********
**NUMHHD**
**********
**Number of households in a district

sort kabid03
egen numhhd=sum(numhhvil), by(kabid03)
label var numhhsd "Number of HH in District"


****************
* NUMPOORHHVIL *
****************
gen numpoorhhvil = b4r403a1
label var numpoorhhvil "Number of Poor HH in Village"

gen numksvil=b7r705
label var numksvil "Number of HH with Health Card in Village"

gen povrateksvil=numksvil/numhhvil
label var povrateksvil "Poverty Rate (Health Card) in Village"

gen numsmvil=b7r704a
label var numsmvil "Number of HH with Poverty Certificate"

gen povratesmvil=numsmvil/numhhvil
label var povratesmvil "Poverty Rate (Poverty Certificate) in Village"

**************
* POVRATEVIL *
**************
gen povratevil=numpoorhhvil/numhhvil
label var povratevil "Poverty Rate in Village"

***************
**NUMPOORHHSD**
***************
sort kecid03
egen numpoorhhsd=sum(numpoorhhvil), by(kecid03)
label var numpoorhhsd "Number of Poor HH in Sub-District"

********************************
**NUMKARTUSEHSD & NUMSURMISKSD**
********************************
sort kecid03
egen numkssd=sum(numksvil), by(kecid03)
egen numsmsd=sum(numsmvil), by(kecid03)
label var numkssd "Number of HH with Health Card in Sub-District"
label var numsmsd "Number of HH with Poverty Certificate in Sub-District"

*************
**POVRATESD**
*************
gen povratesd=numpoorhhsd/numhhsd
label var povratesd "Poverty Rate of Sub-District"

gen povratekssd=numkssd/numhhsd
label var povratekssd "Poverty Rate (Health Card) of Sub-District"

gen povratesmsd=numsmsd/numhhsd
label var povratesmsd "Poverty Rate (Poverty Certificate) of Sub-District"


***********
**FGTVILSD**
***********
gen fgtvilsd=povratevil/povratesd
label var fgtvilsd "Relative Poverty (Village Poverty/Sub-District Poverty)"

gen fgtksvilsd=povrateksvil/povratekssd
label var fgtksvilsd "Relative Poverty (Health Card) (Village Poverty/Sub-District Poverty)"
gen fgtsmvilsd=povratesmvil/povratesmsd
label var fgtsmvilsd "Relative Poverty (Poverty Certificate) (Village Poverty/Sub-District Poverty)"
**************
**NUMPOORHHD**
**************
sort kabid03
egen numpoorhhd=sum(numpoorhhvil), by(kabid03)
egen numksd=sum(numksvil), by(kabid03)
egen numsmd=sum(numsmvil), by(kabid03)
label var numpoorhhd "Number of Poor HH in District"
label var numksd "Number of HH w/ Health Card in District"
label var numsmd "Number of HH w/ Poverty Certificate in District"

************
**POVRATED**
************
gen povrated=numpoorhhd/numhhd
gen povrateksd=numksd/numhhd
gen povratesmd=numsmd/numhhd
label var povrated "Poverty Rate of District"
label var povrateksd "Poverty Rate (Health Card) of District"
label var povratesmd "Poverty Rate (Poverty Certificate) of District"

***********
**FGTVILD**
***********
gen fgtvild=povratevil/povrated
gen fgtksvild=povrateksvil/povrateksd
gen fgtsmvild=povratesmvil/povratesmd
label var fgtvild "Relative Poverty (Village Poverty/District Poverty)"
label var fgtksvild "Relative Poverty (Health Card) (Village Poverty/District Poverty)"
label var fgtsmvild "Relative Poverty (Poverty Certificate) (Village Poverty/District Poverty)"

**********
**NATDIS**
**********
gen natdis=1 if (b5r514a2==1 | b5r514b2==1 |b5r514c2==1) 
replace natdis=0 if (b5r514a2==2 & b5r514b2==2 & b5r514c2==2) 
label var natdis "Natural Disaster in last 3 years"

**********
**FARMING**
**********
gen farming=b4r407a==1 
replace farming=. if b4r407a==.
label var farming "Farming as Main Source of Income in Village"

**********
**NATRES**
**********
gen natres=b4r407a==2 
replace natres=. if b4r407a==.
label var natres "Mining or Excavation as Main Source of Income in Village"

gen natres_sd=0
sort kecid natres
by kecid: replace natres_sd=1 if natres[_N]==1

gen natres_d=0
sort kabid natres
by kabid: replace natres_d=1 if natres[_N]==1

**************
**INDUSTRIAL**
**************
gen industrial=b4r407a==3 
replace industrial=. if b4r407a==.
label var industrial "Industrial Processing as Main Source of Income in Village"

***********
**TRADING**
***********
gen trading=b4r407a==4 
replace trading=. if b4r407a==.
label var trading "Trading as Main Source of Income in Village"

************
**ALTITUDE**
************
gen altitude=b3r310
drop if altitude>3000
label var altitude "Altitude of Village in Meters"

***********
**OFF_JAVA**
***********

gen off_java=(prop<30 | prop>39)
replace off_java=. if prop==.
label var off_java "Village is outside of Java"

***********
**NON_JAVA**
***********

gen non_java=(prop<30 | prop==32 | prop>35)
replace non_java=. if prop==.
label var non_java "Village is outside of main Javanese provinces"


************
**JAVANESE**
************
gen javanese=(b8r810=="0327" |b8r810=="327")
replace javanese=. if b8r810==""
label var javanese "Majority of Village is Javanese"

*********************
**JAVANESE_OFF_JAVA**
*********************
gen javanese_off_java=(off_java==1 & javanese==1)
replace javanese_off_java=. if off_java==. | javanese==.
label var javanese_off_java "Majority of Village is Javanese and Province Outside Java"

*********************
**JAVANESE_NON_JAVA**
*********************
gen javanese_non_java=(non_java==1 & javanese==1)
replace javanese_non_java=. if non_java==. | javanese==.
label var javanese_non_java "Majority of Village is Javanese and Province Outside Main Java Provinces"

*********
**ISLAM**
*********
gen islam=b8r807==1
replace islam=. if b8r807==.
label var islam "Majority of Village is Muslim"


*********
**SDPOP**
*********
egen sdpop=sum(villagepop), by(kecid03)
label var sdpop "Population of Sub-District (Podes)"

********
**DPOP**
********
egen dpop=sum(villagepop), by(kabid03)
label var dpop "Population of District (Podes)"

**************
**NUMPLWORSH**
**************
gen numplworsh=b8r801a+b8r801b+b8r801c+b8r801d+b8r801e+b8r801f+b8r801g
label var numplworsh "Number of Places of Worship"

****************
**NPWPERPERSON**
****************
gen npwperperson=numplworsh/villagepop
label var npwperperson "Number of Places of Worship Per Capita"

************
**NPWPERHH**
************
gen npwperhh=numplworsh/numhhvil
label var npwperhh "Number of Places of Worship Per Household"

*********
**URBAN**
*********
gen urban=1 if drh==1
replace urban=0 if drh==2
label var urban "Urban Location"
*************
**56--BPD**
*************
gen bpd=1 if b3r304==1
replace bpd=0 if b3r304==2
label var bpd "Presence of BPD Village Councils"

***********
* PARTIES *
***********

g partya=b17r1701a
g partyb=b17r1701b
g partyc=b17r1701c

*********************
* VOTING FOR GOLKAR *
*********************

gen golkar1=1 if b17r1701a=="11"
replace golkar1=0 if golkar1==.
gen golkarany3=1 if b17r1701a=="11" | b17r1701b=="11" |b17r1701c=="11" 
replace golkarany3=0 if golkarany3==.
label var golkar1 "Golkar #1 Party"
label var golkarany3 "Golkar Top 3 Party"

********************
* VOTING FOR PDI-P *
********************

gen pdip1=1 if b17r1701a=="33"
replace pdip1=0 if pdip1==.
gen pdipany3=1 if b17r1701a=="33" | b17r1701b=="33" |b17r1701c=="33" 
replace pdipany3=0 if pdipany3==.
label var pdip1 "PDIP #1 Party"
label var pdipany3 "PDIP Top 3 Party"

**********************
**NUMPUSKES / PUSKES**
**********************
**Number/presence of puskesmas in village
gen numpuskes = b7r701d2
gen puskes = 1 if numpuskes>=1
replace puskes = 0 if numpuskes==0
label var numpuskes "Number of Health Stations"
label var puskes "Health Station Present in Village"
*************
**DISPUSKES**
*************
**Distance to closest puskesmas if no puskesmas in village
gen dispuskes = b7r701d3
label var dispuskes "Distance to Nearest Health Station"

**********************
**NUMPKHELP / PKHELP**
**********************
**Number/presence of puskesmas help stations in village
gen numpkhelp = b7r701e2
gen pkhelp = 1 if numpkhelp>=1
replace pkhelp = 0 if numpkhelp==0
label var numpkhelp "Number of Satellite Health Stations"
label var pkhelp "Helper Satellite Station Present"

*************
**DISPKHELP**
*************
**Distance to closest puskesmas help station if no puskesmas help station in village
gen dispkhelp = b7r701e3

gen closedispk=min(dispuskes, dispkhelp)
label var dispkhelp "Distance to Nearest Helper Health Station"
label var closedispk "Distance to Nearest Helper or Regular Health Station"

*********************************
* TERRAIN AND INTERACTIVE TERMS *
*********************************
g flat=1 if b3r308a==1
replace flat=1 if b3r308b==1 |b3r308b==3
replace flat=0 if b3r308b==2
gen hilly=!flat
label var flat "Flat Terrain"
label var hilly "Hilly Terrain"

gen dppfl=distpospol*flat
gen dpkfl=dispuskes*flat
gen dpkhfl=dispkhelp*flat

*******************************
* DISTRICT AND VILLAGE SPLITS *
*******************************
* Generate variable for split villages
bysort id2000: g split_vil03=(_N>1)
label var split_vil03 "Village split"


* Generate variable for split districts
g split_kab03=0 if kabid03!=.
levelsof kabid if kabid!=kabid03, local(splitkabid03)
foreach kabnum of numlist `splitkabid03' {
	replace split_kab03=1 if kabid==`kabnum'
}
label var split_kab03 "District split"

label var kecid03 "Subdistrict identifier 2003"
label var kabid03 "District idenifier 2003"
label var prop "Province identifier 2003"

label var covyredvil "Village Inequality Coeff of Variation Years of Education Men Ages 24-33"
label var ethfractvil "Ethnic Fractionalization (Village)"
label var wgcovegvil "Weighted Group Coeff of Variation for Ethnic Groups (Village)"
label var relfractvil "Religious Fractionalization (Village)"
label var wgcovrgvil "Weighted Group Coeff of Variation for Religious Groups (Village)"

label var ethfractsd "Ethnic Fractionalization (Subdistrict)"
label var wgcovegsd "Weighted Group Coeff of Variation for Ethnic Groups (Subdistrict)"
label var relfractsd "Religious Fractionalization (Subdistrict)"
label var wgcovrgsd "Weighted Group Coeff of Variation for Religious Groups (Subdistrict)"
label var ethclustsd "Ethnic Clustering (Subdistrict)"
label var relclustsd "Religious Clustering (Subdistrict)"

label var ethfractd "Ethnic Fractionalization (District)"
label var wgcovegd "Weighted Group Coeff of Variation for Ethnic Groups (District)"
label var relfractd "Religious Fractionalization (District)"
label var wgcovrgd "Weighted Group Coeff of Variation for Religious Groups (District)"
label var ethclustvd "Ethnic Clustering (District)"
label var relclustvd "Religious Clustering (District)"


*For replication file
keep id2000 id2003 kecid03 kabid03 prop horiz2 non_sf_res tot_hansip distkec distpospol logvillpop logdensvil povrateksvil fgtksvild natdis natres altitude javanese_off_java islam npwperhh urban golkar1 pdip1 dispuskes dispkhelp flat dppfl dpkfl dpkhfl split_vil03 split_kab03  ethfractvil ethfractsd ethfractd relfractvil relfractsd relfractd ethclustsd ethclustvd relclustsd relclustvd wgcovegvil wgcovegsd wgcovegd wgcovrgvil wgcovrgsd wgcovrgd covyredvil

save podes03census_ajps_fin_rep, replace

log close

