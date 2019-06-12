**CLEAN AND MERGE FARBER ELECTIONS DATA (1961-2009)

**start with Farber elections from fy2000-fy2009
set more off
clear
insheet using "C:\Users\ODMXK1\Documents\Research\unions_offshoring\data\union elections\union elections data\fy2000_2009.csv", comma
*rename variables to match fy1991-fy1999 codebook names
ren officeid regionalofficenumber
ren casetype typeofcase
split casenumber, parse(-)
ren casenumber3 docketnumber
drop casenumber1 casenumber2
ren casename employer
ren electionresult outcome
ren electiondate electionhelddate
gen election_date_num = date(electionhelddate, "MDY")
split electionhelddate, p(/)
ren electionhelddate3 year_electionheld
ren electionhelddate1 month_electionheld
ren electionhelddate2 day_electionheld
destring year_electionheld month_electionheld day_electionheld, replace
ren votesfor votes_for
ren votesagainst votes_against
destring votes*, ignore(",") replace
ren disposition methodofdisposition
ren electiontype electionid
ren electionmode mailballots
ren naics industry
ren bargunit unit
ren numeligemployees numbereligiblevoters
destring numbereligiblevoters, ignore(",") replace
ren noofchallenges challengedballots
ren typeofcase type
destring docketnumber, replace
destring challengedballots, replace
replace methodofdisposition="3" if methodofdisposition=="Certification of Representative"
replace methodofdisposition="4" if methodofdisposition=="Certification of Results"
destring methodofdisposition, replace

save "C:\Users\ODMXK1\Documents\Research\unions_offshoring\data\union elections\union elections data\cleaned_elections_fy2000_2009.dta", replace

**clean Farber elections data from fy1991-fy1999
clear
insheet using "C:\Users\ODMXK1\Documents\Research\unions_offshoring\data\union elections\union elections data\fy1991_1999.csv", comma 
*clean up dates data: date petition filed and electionhelddate
replace datefiled = "491" if datefiled=="401"
replace datefiled = "391" if datefiled=="319"
replace datefiled = "296" if datefiled=="269"
gen yearfiled = substr(datefiled,-2,.)
gen onenine = 19
egen yearfile = concat(onenine yearfiled)
gen monthfiled = "10" if length(datefiled)==2
replace monthfiled = "11" if substr(datefiled,1,1)=="-"
replace monthfiled = "12" if substr(datefiled,1,1)=="&"
replace monthfiled = substr(datefiled,1,1) if monthfiled==""
gen fulldatefiled = string(v38)
gen dayofmonthfiled = substr(fulldatefiled,-4,2)
gen yearelectionheld = substr(electionhelddate,-2,.)
egen year_electionheld = concat(onenine yearelectionheld)
gen monthelectionheld = "10" if length(electionhelddate)==2
replace monthelectionheld = "11" if substr(electionhelddate,1,1)=="-"
replace monthelectionheld = "11" if substr(electionhelddate,1,1)=="X"
replace monthelectionheld = "12" if substr(electionhelddate,1,1)=="&"
replace monthelectionheld = substr(electionhelddate,1,1) if monthelectionheld==""
ren monthelectionheld month_electionheld
gen fullelectiondate = string(v49)
gen day_electionheld = substr(fullelectiondate,-2,2)
destring month_electionheld day_electionheld year_electionheld, force replace
gen election_date_num = mdy(month_electionheld, day_electionheld, year_electionheld)
ren validvotesforunion votes_for
ren votesagainstunion votes_against
ren city employercity
ren state employerstate
ren streetaddress employeraddress1
*correct state abbreviations
replace employerstate = "AL" if employerstate=="ALA"
replace employerstate = "AK" if employerstate=="ALK"
replace employerstate = "AZ" if employerstate=="ARI"
replace employerstate = "AR" if employerstate=="ARK"
replace employerstate = "CA" if employerstate=="CAL"
replace employerstate = "CO" if employerstate=="COL"
replace employerstate = "CT" if employerstate=="CON"
replace employerstate = "DE" if employerstate=="DEL"
replace employerstate = "DC" if employerstate=="D C"
replace employerstate = "FL" if employerstate=="FLA"
replace employerstate = "HI" if employerstate=="HAW"
replace employerstate = "ID" if employerstate=="IDO"
replace employerstate = "IL" if employerstate=="ILL"
replace employerstate = "IN" if employerstate=="IND"
replace employerstate = "IA" if employerstate=="IOW"
replace employerstate = "KS" if employerstate=="KAN"
replace employerstate = "MA" if employerstate=="MAS"
replace employerstate = "MI" if employerstate=="MIC"
replace employerstate = "MN" if employerstate=="MIN"
replace employerstate = "MS" if employerstate=="MIS"
replace employerstate = "MT" if employerstate=="MON"
replace employerstate = "NE" if employerstate=="NEB"
replace employerstate = "NV" if employerstate=="NEV"
replace employerstate = "NH" if employerstate=="N H"
replace employerstate = "NJ" if employerstate=="N J"
replace employerstate = "NM" if employerstate=="N M"
replace employerstate = "NY" if employerstate=="N Y"
replace employerstate = "NC" if employerstate=="N C"
replace employerstate = "ND" if employerstate=="N D"
replace employerstate = "OH" if employerstate=="OHI"
replace employerstate = "OK" if employerstate=="OKL"
replace employerstate = "OR" if employerstate=="ORE"
replace employerstate = "RI" if employerstate=="R I"
replace employerstate = "SC" if employerstate=="S C"
replace employerstate = "SD" if employerstate=="S D"
replace employerstate = "TN" if employerstate=="TEN"
replace employerstate = "TX" if employerstate=="TEX"
replace employerstate = "UT" if employerstate=="UTA"
replace employerstate = "VT" if employerstate=="VER"
replace employerstate = "WA" if employerstate=="WAS"
replace employerstate = "WV" if employerstate=="WVA"
replace employerstate = "WI" if employerstate=="WIS"
replace employerstate = "WY" if employerstate=="WYO"
replace employerstate = "PR" if employerstate=="P R"
destring challengedballots, ignore("--") replace
ren casenumber casenumber_

*vote variables
*union votes for: 'votes_for'
*union votes against: 'votes_against'
*vote count: 'validvotescount'
*number eligible voterrs: 'numbereligiblevoters'

save "C:\Users\ODMXK1\Documents\Research\unions_offshoring\data\union elections\union elections data\cleaned_elections_fy1991_1999.dta", replace

**Clean Farber elections data from fy1961-fy1990
clear
use "C:\Users\ODMXK1\Documents\Research\unions_offshoring\data\union elections\union elections data\nlrbv3.dta"
ren eligible_employees numbereligiblevoters
gen type = substr(case_no, 4, 2)
ren year year_electionheld
ren month month_electionheld
ren city employercity
*match up states across dbs
ren state employerstate
replace employerstate = "HI" if employerstate=="51"
replace employerstate = "AL" if employerstate =="1"
sort employerstate
replace employerstate = "AZ" if employerstate=="2"
replace employerstate = "AR" if employerstate=="3"
replace employerstate = "CA" if employerstate=="4"
replace employerstate = "CO" if employerstate=="5"
replace employerstate = "CT" if employerstate=="6"
replace employerstate = "DE" if employerstate=="7"
replace employerstate = "DC" if employerstate=="8"
replace employerstate = "FL" if employerstate=="9"
replace employerstate = "GA" if employerstate=="10"
replace employerstate = "ID" if employerstate=="11"
replace employerstate = "IL" if employerstate=="12"
replace employerstate = "IN" if employerstate=="13"
replace employerstate = "IA" if employerstate=="14"
replace employerstate = "KS" if employerstate=="15"
replace employerstate = "KY" if employerstate=="16"
replace employerstate = "LA" if employerstate=="17"
replace employerstate = "ME" if employerstate=="18"
replace employerstate = "MD" if employerstate=="19"
replace employerstate = "MA" if employerstate=="20"
replace employerstate = "MI" if employerstate=="21"
replace employerstate = "MN" if employerstate=="22"
replace employerstate = "MS" if employerstate=="23"
replace employerstate = "MO" if employerstate=="24"
replace employerstate = "MT" if employerstate=="25"
replace employerstate = "NE" if employerstate=="26"
replace employerstate = "NV" if employerstate=="27"
replace employerstate = "NH" if employerstate=="28"
replace employerstate = "NJ" if employerstate=="29"
replace employerstate = "NM" if employerstate=="30"
replace employerstate = "NY" if employerstate=="31"
replace employerstate = "NC" if employerstate=="32"
replace employerstate = "ND" if employerstate=="33"
replace employerstate = "OH" if employerstate=="34"
replace employerstate = "OK" if employerstate=="35"
replace employerstate = "OR" if employerstate=="36"
replace employerstate = "PA" if employerstate=="37"
replace employerstate = "RI" if employerstate=="38"
replace employerstate = "SC" if employerstate=="39"
replace employerstate = "SD" if employerstate=="40"
replace employerstate = "TN" if employerstate=="41"
replace employerstate = "TX" if employerstate=="42"
replace employerstate = "UT" if employerstate=="43"
replace employerstate = "VT" if employerstate=="44"
replace employerstate = "VA" if employerstate=="45"
replace employerstate = "WA" if employerstate=="46"
replace employerstate = "WV" if employerstate=="47"
replace employerstate = "WI" if employerstate=="48"
replace employerstate = "WY" if employerstate=="49"
replace employerstate = "AK" if employerstate=="50"
replace employerstate = "PR" if employerstate=="52"
*fix state abbreviations
replace employerstate = "AL" if employerstate=="A L A"
replace employerstate = "AL" if employerstate=="ALA"
replace employerstate = "AK" if employerstate=="ALK"
replace employerstate = "AZ" if employerstate=="ARI"
replace employerstate = "AR" if employerstate=="A R K"
replace employerstate = "AR" if employerstate=="ARK"
replace employerstate = "CA" if employerstate=="C A L"
replace employerstate = "CA" if employerstate=="C AL"
replace employerstate = "CA" if employerstate=="CAL"
replace employerstate = "CO" if employerstate=="C O L"
replace employerstate = "CO" if employerstate=="COL"
replace employerstate = "CT" if employerstate=="CON"
replace employerstate = "DE" if employerstate=="DEL"
replace employerstate = "DC" if employerstate=="D  C"
replace employerstate = "DC" if employerstate=="D C"
replace employerstate = "FL" if employerstate=="F L A"
replace employerstate = "FL" if employerstate=="F LA"
replace employerstate = "FL" if employerstate=="FLA."
replace employerstate = "FL" if employerstate=="FLA"
replace employerstate = "GA" if employerstate=="GA'"
replace employerstate = "GA" if employerstate=="G A"
replace employerstate = "HI" if employerstate=="H A W"
replace employerstate = "HI" if employerstate=="HAW"
replace employerstate = "ID" if employerstate=="I DO"
replace employerstate = "ID" if employerstate=="IDA"
replace employerstate = "ID" if employerstate=="IDO"
replace employerstate = "IL" if employerstate=="I LL"
replace employerstate = "IL" if employerstate=="ILL."
replace employerstate = "IL" if employerstate=="ILL"
replace employerstate = "IN" if employerstate=="IND"
replace employerstate = "IA" if employerstate=="I A"
replace employerstate = "IA" if employerstate=="I O W"
replace employerstate = "IA" if employerstate=="IOW"
replace employerstate = "KS" if employerstate=="K A N"
replace employerstate = "KS" if employerstate=="KAN"
replace employerstate = "KY" if employerstate=="KEN"
replace employerstate = "KY" if employerstate=="K Y"
replace employerstate = "LA" if employerstate=="L A"
replace employerstate = "MA" if employerstate=="M A S"
replace employerstate = "MA" if employerstate=="MAS"
replace employerstate = "MD" if employerstate=="M D"
replace employerstate = "MI" if employerstate=="M I C"
replace employerstate = "MI" if employerstate=="M IC"
replace employerstate = "MI" if employerstate=="MIC"
replace employerstate = "MN" if employerstate=="M N"
replace employerstate = "MN" if employerstate=="M I N"
replace employerstate = "MN" if employerstate=="M IN"
replace employerstate = "MN" if employerstate=="MIN"
replace employerstate = "MS" if employerstate=="M S"
replace employerstate = "MS" if employerstate=="MISS"
replace employerstate = "MS" if employerstate=="MIS"
replace employerstate = "MO" if employerstate=="M O"
replace employerstate = "MT" if employerstate=="MON"
replace employerstate = "NE" if employerstate=="NEB"
replace employerstate = "NV" if employerstate=="N V"
replace employerstate = "NV" if employerstate=="NEW"
replace employerstate = "NV" if employerstate=="`NEV"
replace employerstate = "NV" if employerstate=="NEV"
replace employerstate = "NH" if employerstate=="N  H"
replace employerstate = "NH" if employerstate=="N H"
replace employerstate = "NJ" if employerstate=="N  J"
replace employerstate = "NJ" if employerstate=="N O"
replace employerstate = "NJ" if employerstate=="N J"
replace employerstate = "NM" if employerstate=="N  M"
replace employerstate = "NM" if employerstate=="N M"
replace employerstate = "NY" if employerstate=="N   Y"
replace employerstate = "NY" if employerstate=="N  Y"
replace employerstate = "NY" if employerstate=="N Y"
replace employerstate = "NC" if employerstate=="N  C"
replace employerstate = "NC" if employerstate=="N C"
replace employerstate = "ND" if employerstate=="N D"
replace employerstate = "OH" if employerstate=="OH I"
replace employerstate = "OH" if employerstate=="O HI"
replace employerstate = "OH" if employerstate=="OHI"
replace employerstate = "OK" if employerstate=="OKL"
replace employerstate = "OR" if employerstate=="ORG"
replace employerstate = "OR" if employerstate=="ORE"
replace employerstate = "PA" if employerstate=="P A"
replace employerstate = "RI" if employerstate=="R  I"
replace employerstate = "RI" if employerstate=="R I"
replace employerstate = "SC" if employerstate=="S  C"
replace employerstate = "SC" if employerstate=="S C"
replace employerstate = "SD" if employerstate=="S  D"
replace employerstate = "SD" if employerstate=="S D"
replace employerstate = "TN" if employerstate=="T E N"
replace employerstate = "TN" if employerstate=="T EN"
replace employerstate = "TN" if employerstate=="TEN"
replace employerstate = "TX" if employerstate=="T E X"
replace employerstate = "TX" if employerstate=="TEX"
replace employerstate = "UT" if employerstate=="UTA"
replace employerstate = "VA" if employerstate=="V A"
replace employerstate = "VT" if employerstate=="V T"
replace employerstate = "VT" if employerstate=="VER"
replace employerstate = "WA" if employerstate=="W A S"
replace employerstate = "WA" if employerstate=="W AS"
replace employerstate = "WA" if employerstate=="WAS"
replace employerstate = "WV" if employerstate=="W V A"
replace employerstate = "WV" if employerstate=="W VA"
replace employerstate = "WV" if employerstate=="WVA"
replace employerstate = "WI" if employerstate=="W I S"
replace employerstate = "WI" if employerstate=="WIS"
replace employerstate = "WY" if employerstate=="WYO"
replace employerstate = "PR" if employerstate=="P  R"
replace employerstate = "PR" if employerstate=="P R"
*
gen outcome = "WON" if votes_for>votes_against
replace outcome = "LOST" if votes_for<=votes_against
ren case_no casenumber

save "C:\Users\ODMXK1\Documents\Research\unions_offshoring\data\union elections\union elections data\cleaned_elections_nlrbv3.dta", replace

***NOW MERGE ALL DATASETS STARTING WITH nlrbv3 TO CREATE 1961-2009 DATASET
clear 
use "C:\Users\ODMXK1\Documents\Research\unions_offshoring\data\union elections\union elections data\cleaned_elections_nlrbv3.dta"
append using "C:\Users\ODMXK1\Documents\Research\unions_offshoring\data\union elections\union elections data\cleaned_elections_fy1991_1999.dta", generate(ds_num)
append using "C:\Users\ODMXK1\Documents\Research\unions_offshoring\data\union elections\union elections data\cleaned_elections_fy2000_2009.dta"
duplicates drop employer employercity employerstate votes_for votes_against  year_electionheld month_electionheld, force
replace month_electionheld = 7 if year_electionheld==1910
replace month_electionheld = 5 if year_electionheld==1959
replace year_electionheld=1991 if year_electionheld==1909|year_electionheld==1929|year_electionheld==1910
replace year_electionheld=1992 if year_electionheld==1959
sort year_electionheld
replace outcome="WON" if outcome=="WIN"
gen number_of_votes = votes_for+votes_against
save "C:\Users\ODMXK1\Documents\Research\unions_offshoring\data\union elections\union elections data\merged_elections_1961_2009.dta", replace
tab outcome if year_electionheld>=1980 &type=="RC"
tab outcome if year_electionheld>=1980 &type=="RC"&number_of_votes>=20
**TABULATIONS APPEAR TO BE VERY CLOSE TO THOSE OF FRANDSEN(2014)
