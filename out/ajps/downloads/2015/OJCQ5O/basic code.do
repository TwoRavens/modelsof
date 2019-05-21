****************************************************************************
**		File name: 	basic code 
**		Authors: 	Liran Harsgor, Orit Kedar, Raz Sheinerman
**		Date: 		Final version: June 8 2015
**		Purpose: 	Prepare the raw data file for other codes and uses:
**					1. Add variable lables
**					2. Add district code
**					3. Calculate vote/seat shares
**					4. Creates various dummy variables
**		Input:		PDL_21C.dta
**		Ouput: 		PDL_21C_ready.dta	                                                                 
*****************************************************************************

use "PDL_21C.dta"
capture log using "data21c.log", replace

* user-written command, used below
ssc install sencode

*** 1. Add variable labels
label var country_c "country 3 digits code"
label var country "country name"
label var party_c "party 5 digits code (first 3 digits same as country_c)" 
label var party "party name"
label var district "district name"
label var dm "district magnitude"
label var votes "recent election results – votes"
label var seats "recent election results – seats"
label var rvd "regitered voters by district"
label var par_ide "BL party ideology: 1 left, 20 right" /* Benoit and Laver's scale */ 
label var par_ide_ch "CH party ideology by CH: 0 left, 10 right" /* Chapel Hill scale*/ 

* recode missing data of seats to zero
recode seats (.=0)

*** 2. Switzerland and Luxemburg standartization of votes
gen votes_orgnl=votes
replace votes=votes/dm if country_c==110 | country_c==115

*** 3. Add district code
** output:  district_c = 9###*** (for example 910401)
*			9   = indicated a district code (to distinguish district_c from party_c)
*			### = country code
*			*** = distirct serial number. Districts are sorted by country, then DM, 
*			then alphabetically. 
 
 sort country_c dm district
 
 * a. Generate the first four digits of district_c plus place holders for the last 
 * three digits (9+counry_c+000)
 gen district_cc = 9100000
 replace district_cc =9103000 if country_c==103   	/*Denmark*/
 replace district_cc =9104000 if country_c==104   	/*Finland*/
 replace district_cc =9108000 if country_c==108		/*Ireland*/
 replace district_cc =9111000 if country_c==111		/*Norway*/
 replace district_cc =9112000 if country_c==112		/*Portugal*/
 replace district_cc =9113000 if country_c==113		/*Spain*/
 replace district_cc =9114000 if country_c==114		/*Sweden*/
 replace district_cc =9115000 if country_c==115		/*Switzerland*/
 replace district_cc =9102000 if country_c==102		/*Belgium*/
 replace district_cc =9106000 if country_c==106		/*Greece*/
 replace district_cc =9107000 if country_c==107		/*Iceland*/
 replace district_cc =9109000 if country_c==109		/*Italy*/
 replace district_cc =9110000 if country_c==110		/*Luxemburg*/
 replace district_cc =9123000 if country_c==123		/*UK*/
 replace district_cc =9105000 if country_c==105		/*Germany*/
 replace district_cc =9117000 if country_c==117		/*Canada*/
 replace district_cc =9119000 if country_c==119		/*Israel*/
 replace district_cc =9120000 if country_c==120		/*Malta*/
 replace district_cc =9121000 if country_c==121		/*Netherlands*/
 replace district_cc =9132000 if country_c==132		/*New zealand 93*/
 replace district_cc =9142000 if country_c==142		/*New zealand 96*/
 
* b. Transform each unique district name into a three-digits numeric code, sorted 
* by dm and then alphabetically in each country. Do so by generating a variable, 
* dis_cc# which equals 1 though D in each country and a MV for all other countries. 
* Output: dis_cc## (##=country_c without the first "1")
* To do this, use "sencode": transfers a string varibale into a numeric 
* variable (similar to encode) according to present order of the data
* (rather than alphabetically as in encode).

sencode district if country_c==103, generate (dis_cc3)
sencode district if country_c==104, generate (dis_cc4)
sencode district if country_c==108, generate (dis_cc8)
sencode district if country_c==111, generate (dis_cc11)
sencode district if country_c==112, generate (dis_cc12)
sencode district if country_c==113, generate (dis_cc13)
sencode district if country_c==114, generate (dis_cc14)
sencode district if country_c==115, generate (dis_cc15)
sencode district if country_c==102, generate (dis_cc2)
sencode district if country_c==106, generate (dis_cc6)
sencode district if country_c==107, generate (dis_cc7)
sencode district if country_c==109, generate (dis_cc9)
sencode district if country_c==110, generate (dis_cc10)
sencode district if country_c==123, generate (dis_cc23)
sencode district if country_c==105, generate (dis_cc5)
sencode district if country_c==117, generate (dis_cc17)
sencode district if country_c==119, generate (dis_cc19)
sencode district if country_c==120, generate (dis_cc20)
sencode district if country_c==121, generate (dis_cc21)
sencode district if country_c==132, generate (dis_cc32)
sencode district if country_c==142, generate (dis_cc42)

* c. Replace missing values by zeros (similar to "recode (.=0)")
mvencode dis_cc3, mv(0)
mvencode dis_cc4, mv(0)
mvencode dis_cc8, mv(0)
mvencode dis_cc11, mv(0)
mvencode dis_cc12, mv(0)
mvencode dis_cc13, mv(0)
mvencode dis_cc14, mv(0)
mvencode dis_cc15, mv(0)
mvencode dis_cc2, mv(0)
mvencode dis_cc6, mv(0)
mvencode dis_cc7, mv(0)
mvencode dis_cc9, mv(0)
mvencode dis_cc10, mv(0)
mvencode dis_cc23, mv(0)
mvencode dis_cc5, mv(0)
mvencode dis_cc17, mv(0)
mvencode dis_cc19, mv(0)
mvencode dis_cc20, mv(0)
mvencode dis_cc21, mv(0)
mvencode dis_cc32, mv(0)
mvencode dis_cc42, mv(0)

* d. Create final district_c variable: district_cc+dis_cc## (equals zero for all 
* other countries) 
gen district_c= district_cc + dis_cc3 + dis_cc4 +dis_cc8 +dis_cc11 +dis_cc12 ///
	+ dis_cc13 +dis_cc14 +dis_cc15 ///
	+ dis_cc2 + dis_cc6 + dis_cc7 + dis_cc9 + dis_cc10 ///
	+ dis_cc5 + dis_cc17 + dis_cc19 + dis_cc20 + dis_cc21 + dis_cc23 ///
	+ dis_cc42 + dis_cc32

drop  district_cc dis_cc3 dis_cc4 dis_cc8 dis_cc11 dis_cc12 dis_cc13 dis_cc14 ///
	dis_cc15 dis_cc2  dis_cc6  dis_cc7  dis_cc9 dis_cc10 dis_cc5  dis_cc17 ///
	dis_cc19 dis_cc20 dis_cc21 dis_cc23 dis_cc42 dis_cc32

label var district_c "district 7 digits code"

*** 4. Calculate district and party level vote-share or total and seat-share or total	

* Calculate total votes per district
egen tvd=total(votes), by (district_c)
label var tvd "total votes in district"

* Calculate district vote-share: the votes a party got in a district out 
* of total votes in that district
gen dvs= votes/tvd
label var dvs "district vote share" 

* Calculate country-level total seats
egen tsc=total (seats), by (country_c)
label var tsc "total seats by country"

* calculate country-level total votes
egen tvc=total (votes), by (country_c)
label var tvc "total votes by country"

*** 5. Create a tagging variable for parties districts, and countries

* creates a variable which equals 1 once per party or per district or per country.
* This is necessery in order to later work with variables that are calculated per 
* party or per district or per country rather than at a lower level of aggreghation. 

egen party_unique=tag(party_c)
egen district_unique=tag(district_c)
egen country_unique=tag(country_c)


*** 6. generate dummy variables for various electoral systemsL DMS, districted PR 
* 		and national PR
gen ctry_smd= 1 if country_c==123 | country_c==117 | country_c==132  /*(Canada, UK, NZ 93)*/
mvencode ctry_smd, mv(0)
label var ctry_smd "Canada, UK, NZ 93"

gen ctry_sdpr= 1 if country_c==105 | country_c==119 | country_c==121 | country_c==142 
mvencode ctry_sdpr, mv(0) /*Germany, Israel, Netherlands, New Zealand 96)*/
label var ctry_sdpr "Germany, Israel, Netherlands, New Zealand 96"
gen ctry_dpr= 1 if ctry_sdpr!=1 & ctry_smd!=1 /* 14 districted PR systems*/
mvencode ctry_dpr, mv(0)
label var ctry_dpr "districted PR systems"

***** save new data file ***********
save "PDL_21C_ready.dta", replace

log close
