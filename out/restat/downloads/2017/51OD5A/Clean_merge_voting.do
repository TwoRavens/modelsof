 ** import and clean voting data and file to match electoral divisions to SA1 census regions, merge with census data
 set more off
 *************
 *******************
 * Election results - polling place

clear
insheet using "OrigData/VotingData/HouseStateFirstPrefsByPollingPlaceDownload-17496-VIC.csv", comma

drop v1 

drop if _n==1

foreach var of varlist v*  {
	local x = `var'[1]
	local y = strtoname(abbrev("`x'",32))
	rename `var' `y' 
	}
	
drop if _n==1

rename PollingPlaceID PPId

destring PPId, replace
sort PPId


destring Ordinary, replace
	
by PPId, sort: gen CumVotes_PP= sum(Ordinary) 
by PPId, sort: egen TotalVotes_PP= max(CumVotes)
drop  CumVotes_PP 
	
	
foreach var in GRN NP LP ALP {
	by PPId, sort: gen PP`var' = OrdinaryVotes/TotalVotes if PartyAb =="`var'" 
	by PPId, sort: egen P_polling`var'  =min(PP`var')
	drop PP`var'
	}



	
rename DivisionNm electoral_division
save OrigData/VotingData/Voting2013.dta, replace

collapse (first) PollingPlace P_pollingGRN P_pollingNP P_pollingLP P_pollingALP DivisionID ///
electoral_division (sum) OrdinaryVotes , by(PPId)

** create above median green vote weighted by number of votes 
expand OrdinaryVotes, gen(expanded)

egen mediangreen_state=median(P_pollingGRN)
gen green_state= (P_pollingGRN>mediangreen_state)

keep if expanded ==0


label variable P_pollingGRN "percentage primary vote Greens party at polling booth"
label variable P_pollingNP "percentage primary vote National party at polling booth"
label variable P_pollingLP "percentage primary vote Liberal party at polling booth"
label variable P_pollingALP "percentage primary vote Labor party at polling booth"



save OrigData/VotingData/Voting2013_PollingPlace.dta, replace

** division level results
use OrigData/VotingData/Voting2013.dta, clear

collapse (sum) OrdinaryVotes (first) Elected electoral_division, by(DivisionID PartyAb)
	
by DivisionID, sort: gen CumVotes= sum(Ordinary) 
by DivisionID, sort: egen TotalVotes= max(CumVotes)
drop  CumVotes 
	
foreach var in GRN NP LP ALP {
	by DivisionID, sort: gen `var' = OrdinaryVotes/TotalVotes if PartyAb =="`var'" 
	by DivisionID, sort: egen P`var'  =min(`var')
	drop `var'
	}
	
by DivisionID, sort: gen member=  PartyAb if Elected =="Y"	
	
sort DivisionID member
	
collapse (first) PGRN PNP PLP PALP electoral_division (last) member, by(DivisionID)

**liberal and national party  
egen PLNP = rowtotal(PNP -PLP)

label variable PGRN "percentage primary vote Greens party"
label variable PNP "percentage primary vote National party"
label variable PLP "percentage primary vote Liberal party"
label variable PALP "percentage primary vote Labor party"


save OrigData/VotingData/Voting2013_Division.dta, replace
	
	*****
	 *file to match Electoral Divisions to SA1
 
clear

insheet using OrigData/Census2011/SA1/ElectoralDivisions_SA1.csv, comma

drop v1

drop if _n<=3

rename v2 SA1 
drop v41
gen electoral_division=" "	

foreach var of varlist v*  {
	replace `var' =  substr(`var',1,length(`var')-5) if _n==1  
	local x = `var'[1]
	local y = strtoname(abbrev("`x'",32))
	rename `var' `y' 
	replace electoral_division = "`x'" if `y' ~="0" 
	}
	
drop if _n<=2
drop if _n >=13339

replace electoral_division = "McEwen" if electoral_division =="Mcewen"
replace electoral_division = "McMillan" if electoral_division =="Mcmillan"

keep SA1 elect

destring SA1, replace
sort SA1	
save OrigData/Census2011/SA1/ElectoralDivisions_SA1.dta, replace
 
