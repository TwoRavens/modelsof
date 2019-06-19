

set more off

* cleans concentration data

forvalues j = 1998(1)2008 {
	
	use "clean_`j'.dta", clear

	* drops total rows and extra spaces from xls files
	drop if locid==""
	drop if carrier=="Airport Total"
	drop if carrier==""
	drop if enplane==.
	
	* checks if data was read in incorrectly for airports with one carrier (ruben error)
	bysort locid: egen airport_enplane=total(enplane)
	gen temp=0
	replace temp=1 if airport_enplane<enplane
	bysort locid: egen ruben_flag=max(temp)
	drop temp
	su ruben_flag
		
	* calculates carrier shares at each airport
	gen pct_enplane=enplane/airport_enplane
	
	* calculates airport share of all traffic
	sort locid
	gen temp=0
	replace temp=1 if locid~=locid[_n-1]
	egen tot_airport_enplane=total(temp*airport_enplane)
	gen pct_airport_enplane=airport_enplane/tot_airport_enplane
	drop temp
	
	* generates share of top 2 carriers at each airport (and each seperately)
	gen temp=1
	gsort locid -pct_enplane
	by locid: gen carrier_rank=sum(temp)
	gen top2_ind=0
	replace top2_ind=1 if (carrier_rank==1 | carrier_rank==2)
	
	
	by locid: egen pct_airport_enplane_top2=total(pct_enplane*top2_ind)
	
	gen temp1=0
	replace temp1=pct_enplane if (carrier_rank==1)
	bysort locid: egen rank1_share=total(temp1)
	
	gen temp2=0
	replace temp2=pct_enplane if (carrier_rank==2)
	bysort locid: egen rank2_share=total(temp2)		
	
	drop temp top2_ind temp1 temp2
	
	* calculates herfindahl index
	gen temp=pct_enplane^2
	bysort locid: egen herfindahl=total(temp)
	drop temp

	* generates a year variable need to drop empty observations and those for the airport total
	gen year=`j'+2
	gen faadata_year=`j'
	
	* fixes some observations that are mistakes due to missing 2001 FAA data or typos (2003 in terms of treatment)
	replace pct_airport_enplane=0.00249 if (locid=="BHM" & year==2003)
	replace pct_airport_enplane=0.00249 if (locid=="BOI" & year==2003)
	replace pct_airport_enplane=0.00003588 if (locid=="BQK" & year==2002)
	* NEED TO MAKE A NOTE THAT DCA ONLY QUALIFIED IN ONE YEAR, DID FILE COMPETITION PLAN
	replace pct_airport_enplane_top2=0.501 if (locid=="DCA" & year==2002)
	* NEED TO MAKE A NOTE THAT SDF ONLY QUALIFIED IN ONE YEAR AND MAY OR MAY NOT OF IMPLEMENTED PLAN
	replace pct_airport_enplane=0.00228344 if (locid=="GUM" & year==2003)
	replace pct_airport_enplane=0.00193767 if (locid=="LIH" & year==2003)
		
	* generates hub classification of airport
	gen hub=""
	replace hub="L" if pct_airport_enplane>=.01
	replace hub="M" if (pct_airport_enplane<.01 & pct_airport_enplane>=.0025)
	replace hub="S" if (pct_airport_enplane<.0025 & pct_airport_enplane>=.0005)
	replace hub="N" if pct_airport_enplane<.0005
	
	* generates treatment indicator
	gen treat=0
	replace treat=1 if (pct_airport_enplane>=.0025 & pct_airport_enplane_top2>=.50)
	
	* drops variables we do not need and repetitive observations
	drop pct_enplane carrier_rank enplane carrier city state airportname 
	sort locid 
	drop if locid==locid[_n-1]
	
	* sorts and saves the data
	rename locid airport
	gsort -pct_airport_enplane 
	save "D:\research\connan\compplan\data\faa_carrier-airport\top2_`j'.dta", replace

}


use "top2_1998.dta", clear
erase "top2_1998.dta"
forvalues j = 1999(1)2008 {
	
	append using "top2_`j'.dta"
	erase "top2_`j'.dta"

}


* generates a rank of airports by year
gen temp=1
gsort year -pct_airport_enplane 
by year: gen airportyear_rank=sum(temp)
drop temp

* gets rid of strange airports in ohio with identifiers with 4 letters
gen temp=length(airport)
drop if temp==4
drop temp


* fills in space for years where it is missing
sort airport year
fillin airport year
drop _fillin


* calculates variable to indicate if airport had to file during entire window
bysort airport: egen max_treat=max(treat)
bysort airport: egen min_treat=min(treat)
bysort airport: egen totyr_treat=total(treat)
sort airport year
by airport: gen cumyr_treat=sum(treat)

gen temp=0
replace temp=1 if (min_treat~=max_treat)
bysort airport: egen part_cover=max(temp)
drop temp

gen full_cover=0
replace full_cover=1 if (part_cover==0 & max_treat==1)

gen either_cover=0
replace either_cover=1 if (full_cover==1 | part_cover==1)

drop max_treat min_treat 

 
* sorts and saves data
su ruben_flag
drop ruben_flag faadata_year 
compress
gsort airport year  
save "top2_all.dta", replace

