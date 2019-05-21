
log using "cleanpod0503_ajps_fin_rep.log", replace

*****************************************************************
* cleanpod0503_ajps_fin_rep.do     							    *
* 								                	            *
* This do-file prepares the 2005-6 dataset for analysis for       *
* Institutional Basis of Order paper, combining with 2002 data  *
* Updated: 21 Sept 2012											*
*****************************************************************

clear 

***************
* SORT ID2000 *
***************

use podes03census_ajps_fin_rep
sort id2000
save podes03census_ajps_fin_rep, replace

clear
**************************************
* MERGE PODES 2006 DATASETS INTO ONE *
**************************************

use podes05asort

merge 1:1 villageid using podes05bsort
ren _merge _merge_pd05AB
label var _merge_pd05AB "_merge: podes05asort + podes05bsort"

sort villageid
merge 1:1 villageid using podes05csort
ren _merge _merge_pd05ABC
label var _merge_pd05ABC "_merge: podes05asort + podes05bsort + podes05csort"

*************************************
* PREPARE IDENTIFIERS FOR CROSSWALK *
*************************************

rename villageid id2005
gen proppd05=r101b 
gen kecid05=r101b*100000+r102b*1000+r103b
gen kabid05=r101b*100+r102b

gen double id2004=r101a*100000000+r102a*1000000+r103a*1000+r104a

* Adjust for recoded province of Riau from 21 to 20 (Riau's code changed in 2004)
replace id2004=2000000000+r102a*1000000+r103a*1000+r104a if r101a==21
sort id2004

***************************************************
* MERGE IN THE ID NUMBERS FOR 2000 FROM CROSSWALK *
***************************************************
merge m:m id2004 using cross0004, keepusing(id2000 nm2000)
ren _merge _merge_cross05
label var _merge_cross05 "_merge: podes05abc + cross0004"
sort id2000

***********************************************
* MERGE IN THE CENSUS DATA ON 2000 ID NUMBERS *
***********************************************
merge m:1 id2000 using censclean-id
rename _merge _merge_census05
label var _merge_census05 "_merge: podes05abc + cross0004 + censclean-id"
ren prop propcen
ren proppd05 prop
sort id2000

merge m:m id2000 using podes03census_ajps_fin_rep, keepusing(id2003 kabid03 horiz2 tot_hansip non_sf_res distkec distpospol dispuskes dispkhelp dppfl dpkfl dpkhfl logvillpop logdensvil urban flat povrateksvil fgtksvild covyredvil npwperhh natdis golkar1 pdip1 islam javanese_off_java natres altitude split_kab03 split_vil03)
ren _merge _merge_pds0305
label var _merge_pds0305 "_merge: podes05abc + podes03census"

*******************************************
** Dependent Variable Generation Section **
*******************************************

************
**--HORIZ2**
************ 
**Generate a variable for horizontal conflict which is 1 if in the previous year the most common type of conflict is described as 
**1) Intergroup fighting ('perkelahian antar kelompok warga') or 4) Inter-ethnic fighting ('Perkelahian antar suku')

gen horiz2_05=0 if r1202a==2
replace horiz2_05=1 if r1203a==1 | r1203a==4
replace horiz2_05=0 if r1203a==2 | r1203a==3
label var horiz2_05 "Communal Violence in Last 12 Months (2005)"

* Generate variables for how conflicts resolved *

************
* COMM_RES *
************
* Conflict resolved by community
g comm_res_05=0 if r1203d!=.
replace comm_res_05=1 if r1203d==1
label var comm_res_05 "Conflict Resolved by Community (2005)"

**************
* VILAPP_RES *
**************
* Conflict resolved by village apparatus
g vilapp_res_05=0 if r1203d!=.
replace vilapp_res_05=1 if r1203d==2
label var vilapp_res_05 "Conflict resolved by village apparatus (2005)"
**************
* NON_SF_RES *
**************
* Conflict resolved by non-security force actors (community or village apparatus)
g non_sf_res_05=0 if r1203d!=.
replace non_sf_res_05=1 if comm_res_05==1 | vilapp_res_05==1
label var non_sf_res_05 "Conflict resolved by non-security force actors (community or village apparatus) (2005)"


********************************************************************
* GENERATE VARIABLE FOR TOTAL COMMUNITY SECURITY GUARDS IN VILLAGE *
********************************************************************
g tot_hansip_05= r1208
label var tot_hansip_05 "Total Community Security Guards in Village (2005)"


*********************************************
** Independent Variable Generation Section **
*********************************************

***********
* DISTKEC *
***********

g distkec_05=r902ak21
drop if distkec_05>100
label var distkec_05 "Distance to Subdistrict Office (2005"

************
**--POSPOL**
************
**Generate a dummy for if a police post is found in the village (1 if there is a police post, 0 otherwise)  
gen pospol_05=1 if r1207bk2==1
replace pospol_05=0 if r1207bk2==2
label var pospol_05 "Police Post in Village"

**************
**DISTPOSPOL**
**************
**r1207b3 is the distance between the closest police post and the village
gen distpospol_05=r1207bk31
replace distpospol_05=0 if pospol_05==1
label var distpospol_05 "Distance to Nearest Police Post (2005)"


*****************************
**  VILLAGEPOP / LOGVILLPOP**
*****************************
**Generate village population
gen villagepop_05 = r401a+r401b
label var villagepop_05 "Village Population (Podes)"
gen logvillpop_05=ln(villagepop_05)
label var logvillpop_05 "Log of Village Population (Podes)"

**************************
**DENSITYVIL/ LOGDENSVIL**
**************************
**Generate population density
gen densityvil_05 = villagepop_05/r10011
label var densityvil_05 "Population Density of Village"
gen logdensvil_05 = ln(densityvil_05)
label var logdensvil_05 "Log of Population Density of Village"

************
**NUMHHVIL**
************
**Number of households in a village
gen numhhvil_05=r401c
label var numhhvil_05 "Number of HH in Village"

***********
**NUMHHSD**
***********
**Number of households in a sub-district

sort kecid05
egen numhhsd_05=sum(numhhvil_05), by(kecid05)
label var numhhsd_05 "Number of HH in Sub-District"

**********
**NUMHHD**
**********
**Number of households in a district

sort kabid05
egen numhhd_05=sum(numhhvil_05), by(kabid05)
label var numhhsd_05 "Number of HH in District"

****************
**NUMPOORHHVIL**
****************
**There is no question in PODES 2005 that is the equivalent of Jumlah Keluarga 
**Prasejahtera I.  Instead, there is one with the number of families that 
**received kartu peserta program jaminan kesehatan masyarakat miskin and 
**also surat miskin  

gen numksvil_05=r605
label var numksvil_05 "Number of HH with Health Card in Village"

gen povrateksvil_05=numksvil_05/numhhvil_05
label var povrateksvil_05 "Poverty Rate (Health Card) in Village"

gen numsmvil_05=r606
label var numsmvil_05 "Number of HH with Poverty Certificate"

gen povratesmvil_05=numsmvil_05/numhhvil_05
label var povratesmvil_05 "Poverty Rate (Poverty Certificate) in Village"

********************************
**NUMKARTUSEHSD & NUMSURMISKSD**
********************************
sort kecid05
egen numkssd_05=sum(numksvil_05), by(kecid05)
egen numsmsd_05=sum(numsmvil_05), by(kecid05)
label var numkssd_05 "Number of HH with Health Card in Sub-District"
label var numsmsd_05 "Number of HH with Poverty Certificate in Sub-District"

*************
**POVRATESD**
*************

gen povratekssd_05=numkssd_05/numhhsd_05
label var povratekssd_05 "Poverty Rate (Health Card) of Sub-District"

gen povratesmsd_05=numsmsd_05/numhhsd_05
label var povratesmsd_05 "Poverty Rate (Poverty Certificate) of Sub-District"

************
**FGTVILSD**
************
gen fgtksvilsd_05=povrateksvil_05/povratekssd_05
label var fgtksvilsd_05 "Relative Poverty (Health Card) (Village Poverty/Sub-District Poverty)"

gen fgtsmvilsd_05=povratesmvil_05/povratesmsd_05
label var fgtsmvilsd_05 "Relative Poverty (Poverty Certificate) (Village Poverty/Sub-District Poverty)"

**************
**NUMPOORHHD**
**************
sort kabid05
egen numksd_05=sum(numksvil_05), by(kabid05)
egen numsmd_05=sum(numsmvil_05), by(kabid05)
label var numksd_05 "Number of HH w/ Health Card in District"
label var numsmd_05 "Number of HH w/ Poverty Certificate in District"

************
**POVRATED**
************
gen povrateksd_05=numksd_05/numhhd_05
gen povratesmd_05=numsmd_05/numhhd_05
label var povrateksd_05 "Poverty Rate (Health Card) of District"
label var povratesmd_05 "Poverty Rate (Poverty Certificate) of District"

***********
**FGTVILD**
***********
gen fgtksvild_05=povrateksvil_05/povrateksd_05
gen fgtsmvild_05=povratesmvil_05/povratesmd_05
label var fgtksvild_05 "Relative Poverty (Health Card) (Village Poverty/District Poverty)"
label var fgtsmvild_05 "Relative Poverty (Poverty Certificate) (Village Poverty/District Poverty)"

**********
**NATDIS**
**********
gen natdis_05=1 if (r513a==1 | r513b==3 | r513c==5 | r513d==7 | r513e==1) 
replace natdis_05=0 if (r513a==2 & r513b==4 & r513c==6 & r513d==8 & r513e==2)
label var natdis_05 "Natural Disaster in last 3 years"

************************************
*ADDED FOR REVISIONS BEGINNING HERE*
************************************

**********
**FARMING**
**********
gen farming_05=r402==1 
replace farming_05=. if r402==.
label var farming_05 "Farming as Main Source of Income in Village"

**********
**NATRES**
**********
gen natres_05=r402==2 
replace natres_05=. if r402==.
label var natres_05 "Mining or Excavation as Main Source of Income in Village"

**************
**INDUSTRIAL**
**************
gen industrial_05=r402==3 
replace industrial_05=. if r402==.
label var industrial_05 "Industrial Processing as Main Source of Income in Village"

***********
**TRADING**
***********
gen trading_05=r402==4 
replace trading_05=. if r402==.
label var trading_05 "Trading as Main Source of Income in Village"

******************************************************
**ALTITUDE NOT IN PODES05; USE ALTITUDE FROM PODES03**
******************************************************

***********
**OFF_JAVA**
***********

gen off_java_05=(r101b<30 | r101b>39)
replace off_java_05=. if r101b==.
label var off_java_05 "Village is outside of Java"

***********
**NON_JAVA**
***********

gen non_java_05=(r101b<30 | r101b==32 | r101b>35)
replace non_java_05=. if r101b==.
label var non_java_05 "Village is outside of main Javanese provinces"


************
**JAVANESE**
************
gen javanese_05=r711==327
replace javanese_05=. if r711==.
label var javanese_05 "Majority of Village is Javanese"

*********************
**JAVANESE_OFF_JAVA**
*********************
gen javanese_off_java_05=(off_java_05==1 & javanese_05==1)
replace javanese_off_java_05=. if off_java_05==. | javanese_05==.
label var javanese_off_java_05 "Majority of Village is Javanese and Province Outside Java"

*********************
**JAVANESE_NON_JAVA**
*********************
gen javanese_non_java_05=(non_java_05==1 & javanese_05==1)
replace javanese_non_java_05=. if non_java_05==. | javanese_05==.
label var javanese_non_java_05 "Majority of Village is Javanese and Province Outside Main Java Provinces"

*********
**ISLAM**
*********
gen islam_05=r701==1
replace islam_05=. if r701==.
label var islam_05 "Majority of Village is Muslim"

************************************
*ADDED FOR REVISIONS ENDING HERE*
************************************



*********
**SDPOP**
*********
egen sdpop_05=sum(villagepop_05), by(kecid05)
label var sdpop_05 "Population of Sub-District (Podes)"

**************
**NUMPLWORSH**
**************
gen numplworsh_05=r703a+r703b+r703c+r703d+r703e+r703f
label var numplworsh_05 "Number of Places of Worship"

****************
**NPWPERPERSON**
****************
gen npwperperson_05=numplworsh_05/villagepop_05
label var npwperperson_05 "Number of Places of Worship Per Capita"

***************
**NPWPERPERHH**
****************
gen npwperhh_05=numplworsh_05/numhhvil_05
label var npwperhh_05 "Number of Places of Worship Per Household"

*******
**BPD**
*******
gen bpd_05=1 if r302==1
replace bpd_05=0 if r302==2
label var bpd_05 "Presence of BPD Village Councils"

*********
**URBAN**
*********
gen urban_05=1 if r105b==1
replace urban_05=0 if r105b==2
label var urban_05 "Urban Location (2005)"

*********************
* VOTING FOR GOLKAR *
*********************

g golkar1_05=1 if r12011k2==20
replace golkar1_05=0 if golkar1_05==.
label var golkar1_05 "Golkar #1 Party (2005)"

********************
* VOTING FOR PDI-P *
********************

g pdip1_05=1 if r12011k2==18
replace pdip1_05=0 if pdip1_05==.
label var pdip1_05 "PDIP #1 Party (2005)"


g golk1_to_no=(golkar1==1 & golkar1_05==0)
g pdip1_to_no=(pdip1==1 & pdip1_05==0)

label var golk1_to_no "Golkar #1 Party in 2003 to Not in 2005"
label var pdip1_to_no "PDIP #1 Party in 2003 to Not in 2005"
****************************************************
**HEALTH INSTRUMENTAL VARIABLES GENERATION SECTION**
****************************************************

**********************
**NUMPUSKES / PUSKES**
**********************
**Number/presence of puskesmas in village
gen numpuskes_05 = r603dk2
gen puskes_05 = 1 if numpuskes_05>=1
replace puskes_05 = 0 if numpuskes_05==0
label var numpuskes_05 "Number of Health Stations"
label var puskes_05 "Health Station Present in Village"

*************
**DISPUSKES**
*************
**Distance to closest puskesmas if no puskesmas in village
gen dispuskes_05 = r603dk31
replace dispuskes_05=0 if r603dk2>=1
label var dispuskes_05 "Distance to Nearest Health Station"

**********************
**NUMPKHELP / PKHELP**
**********************
**Number/presence of puskesmas help stations in village
gen numpkhelp_05 = r603ek2
gen pkhelp_05 = 1 if numpkhelp_05>=1
replace pkhelp_05 = 0 if numpkhelp_05==0
label var numpkhelp_05 "Number of Satellite Health Stations"
label var pkhelp_05 "Helper Satellite Station Present"

*************
**DISPKHELP**
*************
**Distance to closest puskesmas help station if no puskesmas help station in village
gen dispkhelp_05 = r603ek31
replace dispkhelp_05=0 if r603ek2>=1
gen closedispk_05=min(dispuskes_05, dispkhelp_05)
label var dispkhelp_05 "Distance to Nearest Satellite Health Station"
label var closedispk_05 "Distance to Nearest Satellite or Regular Health Station"

*********************************
* TERRAIN AND INTERACTIVE TERMS *
*********************************


g flat_05=1 if r304a==1
replace flat_05=1 if r304b==1 | r304b==3
replace flat_05=0 if r304b==2
g hilly_05=!flat_05
label var flat "Flat Terrain"
label var hilly "Hilly Terrain"

g dpkfl_05=dispuskes_05*flat
g dpkhfl_05=dispkhelp_05*flat
g dppfl_05=distpospol_05*flat


**********************
* CHANGE IN DISTANCE *
**********************

g diff_dpp=distpospol_05-distpospol
g diff_dppfl=diff_dpp*flat_05
label var diff_dpp "Difference in Distance to Police Post 2003 to 2005"
label var diff_dppfl "Difference in Distance to Police Post Interacted with Flat 2003 to 2005"

*******************************
* DISTRICT AND VILLAGE SPLITS *
*******************************
* Generate variable for split villages
bysort id2003: g split_vil05=(_N>1)
label var split_vil05 "Village split"

* Generate variable for split districts
g split_kab05=0 if kabid05!=.
levelsof kabid03 if kabid03!=kabid05, local(splitkabid05)
foreach kabnum of numlist `splitkabid05' {
	replace split_kab05=1 if kabid03==`kabnum'
}
label var split_kab05 "District split"


keep id2000 id2003 kabid03 kecid05 kabid05 prop horiz2 non_sf_res tot_hansip distkec distpospol logvillpop logdensvil povrateksvil fgtksvild natdis natres altitude javanese_off_java islam npwperhh urban golkar1 pdip1 dispuskes dispkhelp flat dppfl dpkfl dpkhfl split_vil03 split_kab03  ethfractvil ethfractsd ethfractd relfractvil relfractsd relfractd ethclustsd ethclustvd relclustsd relclustvd wgcovegvil wgcovegsd wgcovegd wgcovrgvil wgcovrgsd wgcovrgd covyredvil natres_05 logvillpop_05 logdensvil_05 urban_05 flat_05 povrateksvil_05 fgtksvild_05 npwperhh_05 natdis_05 javanese_off_java_05 islam_05 split_vil05 split_kab05 golkar1_05 pdip1_05 golk1_to_no pdip1_to_no horiz2_05 comm_res_05 vilapp_res_05 non_sf_res_05 tot_hansip_05 distkec_05 pospol_05 distpospol_05 diff_dpp diff_dppfl



save podes0503census_ajps_fin_rep, replace

log close

