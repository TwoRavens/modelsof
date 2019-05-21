 ***2006 CCES data
**** we first extract the 2006 variables 
use "CCES_2006_common.dta", clear
rename v1000 ID
gen weights = v1001
gen turnout2 = 1 if vote06turn==3
replace turnout2=0 if turnout2==.
rename v1003 Cong_dis
destring Cong_dis, replace
rename v1004 fips_code
gen female = 1 if v2004 ==2
replace female = 0 if v2004 ==1
gen white =1 if v2005 ==1
replace white =0 if v2005 >1
rename v2018 education
gen married = 1 if v2019 ==1
replace married =0 if v2019>1
gen age = 2006-v2020
gen income = v2032
gen unemployed = 1 if 2030 ==3
replace unemployed = 1 if v2030 ==4
replace unemployed=1 if v2030 ==3
replace unemployed = 0 if unemployed ==.
gen low_interest =1 if v2042==3
replace low_interest =1 if v2042==2
replace low_interest =0 if low_interest ==.
gen economy_good =1 if v2135 ==1
replace economy_good =1 if v2135==2
replace economy_good =0 if economy_good==.
rename v3003 pres_approve
gen strong_party =1 if v3007==1
replace strong_party= 1 if v3007==7
replace strong_party =0 if strong_party ==.
gen mistake_iraq = 1 if v3010 ==1
replace mistake_iraq =0 if mistake_iraq ==.
rename v3007 party_id
rename v3005 party_id3
gen year=2006
gen grouping=1
gen stateid=int(fips_code/1000)
keep ID stateid weights Cong_dis education pres_approve turnout2 fips_code female white married age unemployed income low_interest economy_good strong_party mistake_iraq party_id party_id3 year grouping
save "2006 CCES replication small.dta", replace

***2008 CCES data
*** we now extract the 2008 variables
use "CCES_2008_common.dta", clear
rename V100 ID
gen weights = V201
gen turnout2= 1 if CC403 ==5
replace turnout=0 if turnout2==.
rename V250 Cong_dis
destring Cong_dis, replace
gen fips = V251
destring fips, replace
gen str3 z = string(V269,"%03.0f")
egen fips_code =concat( V251 z )
destring fips_code, replace
gen female = 1 if V208==2
replace female = 0 if V208 ==1
gen white =1 if V211 ==1
replace white =0 if V211 >1
rename V213 education
gen married = 1 if V214 ==1
replace married =0 if V214>1
gen age = 2008-V207
gen unemployed =1 if V209 ==3
replace unemployed= 1 if V209 ==4
replace unemployed = 0 if unemployed ==.
gen income = V246
gen low_interest =1 if V244==2
replace low_interest=1 if V244==3
replace low_interest=1 if V244==4
replace low_interest =0 if V244==1

gen economy_good =1 if CC302 <4
replace economy_good =0 if economy_good==.
rename CC335bush pres_approve
gen strong_party =1 if CC307a==1
replace strong_party= 1 if CC307a ==7
replace strong_party =0 if strong_party ==.
gen mistake_iraq = 1 if CC304 ==1
replace mistake_iraq =0 if mistake_iraq ==.
replace mistake_iraq = . if CC304 ==8
rename CC307a party_id
rename CC307 party_id3
gen year =2008
gen grouping=2
gen stateid = V251
destring stateid, replace
keep ID stateid weights Cong_dis education pres_approve turnout2 fips_code female white married age unemployed income low_interest economy_good strong_party mistake_iraq party_id party_id3 year grouping
save "2008 cces replication small.dta", replace

****2010 CCES data
*** we now extract the 2010 variables
use "cces_2010_common_validated.dta", clear
rename V100 ID
gen weights = V101
gen turnout2= 1 if CC401 ==5
replace turnout=0 if turnout2==.
rename V250 Cong_dis
gen fips_code = V277
destring fips_code, replace
gen female = 1 if V208==2
replace female = 0 if V208 ==1
gen white =1 if V211 ==1
replace white =0 if V211 >1
rename V213 education
gen married = 1 if V214 ==1
replace married =0 if V214>1
gen age = 2010-V207
gen unemployed =1 if V209 ==3
replace unemployed= 1 if V209 ==4
replace unemployed = 0 if unemployed ==.
gen income = V246
gen low_interest =1 if V244==2
replace low_interest =1 if V244 ==3
replace low_interest =1 if V244 ==4
replace low_interest =0 if low_interest==.

gen economy_good =1 if CC302 ==1
replace economy_good =1 if CC302==2
replace economy_good =0 if economy_good==.
rename CC308a pres_approve
gen strong_party =1 if V212d==1
replace strong_party= 1 if V212d ==7
replace strong_party =0 if strong_party ==.
gen mistake_iraq = 1 if CC305 ==1
replace mistake_iraq =0 if mistake_iraq ==.
replace mistake_iraq =. if mistake_iraq ==8
rename V212d party_id
rename V212a party_id3
gen year =2010
gen grouping=3
gen stateid=substr(V277, 1,2)
destring stateid, replace
keep ID stateid weights Cong_dis education pres_approve turnout2 fips_code female white married age unemployed income low_interest economy_good strong_party mistake_iraq party_id party_id3 year grouping
save "2010 CCES replication small.dta", replace


****2012 CCES data
*** we now extract the 2012 variables
use "commoncontent2012.dta", clear
rename V101 ID
gen weights = V103
gen turnout2= 1 if CC401 ==5
replace turnout=0 if turnout2==.
rename cdid Cong_dis
destring Cong_dis, replace
gen fips_code = countyfips
destring fips_code, replace
gen female = 1 if gender==2
replace female = 0 if gender ==1
gen white =1 if race==1
replace white =0 if race >1
rename educ education
gen married = 1 if marstat ==1
replace married =0 if marstat>1
gen age = 2012-birthyr
gen unemployed =1 if employ ==3
replace unemployed= 1 if employ==4
replace unemployed = 0 if unemployed ==.
gen income = faminc
gen low_interest =1 if newsint>1
replace low_interest =0 if low_interest==.

gen economy_good =1 if CC302 ==1
replace economy_good =1 if CC302==2
replace economy_good =0 if economy_good==.
rename CC308a pres_approve
replace pres_approve=. if pres_approve==5
gen strong_party =1 if pid7
replace strong_party= 1 if pid7 ==7
replace strong_party =0 if strong_party ==.
gen mistake_iraq = 1 if CC305 ==1
replace mistake_iraq =0 if mistake_iraq ==.
replace mistake_iraq =. if mistake_iraq ==8
rename pid7 party_id
rename pid3 party_id3
gen year =2012
gen grouping=4
gen stateid=substr(countyfips, 1,2)
destring stateid, replace
keep ID stateid weights Cong_dis education pres_approve turnout2 fips_code female white married age unemployed income low_interest economy_good strong_party mistake_iraq party_id party_id3 year grouping
save "2012 CCES replication small.dta", replace
append using "2010 cces replication small.dta"
append using "2008 cces replication small.dta"

append using "2006 CCES replication small.dta"
save "cces06081012 election.dta", replace