*---------------------------------------------FLAG_REPEAT_BUYERS.DO-----------------------------------------
*This script is intended to identify repeat buyers and owners of multiple properties.
*Run this script from merge_AA_tax_roll_MLS_data.do.

*Sebastien Bradley 12/13/13

sort ownername1 pid year

*Standardize owner names
gen owner = trim(upper(ownername1))
replace owner = subinstr(owner,".","",.)
replace owner = subinstr(owner,",","",.)

replace owner = word(owner,1)+" "+word(owner,2) if !regexm(owner, "^[0-9]")		/*Numerical names refer to property managers whose name includes an address*/
replace owner = "107 CO" if regexm(owner, "107 CO")
replace owner = "1250 N MAIN LLC" if owner=="12550 N MAIN LLC"

sort owner pid year
count if owner==owner[_n-1] & pid~=pid[_n-1]
count if owner==owner[_n-1] & pid~=pid[_n-1] & ownerstreetaddress==ownerstreetaddress[_n-1]
local matchown "owner==owner[_n-1] & word(ownerstreetaddress,1)==word(ownerstreetaddress[_n-1],1) & word(ownerstreetaddress,2)==word(ownerstreetaddress[_n-1],2)"
local or_matchown "ownername1==ownername1[_n-1]"
count if `matchown' & pid~=pid[_n-1]
count if (`matchown' | `or_matchown') & pid~=pid[_n-1]

order pid year owner owner*, first

*Count number of properties ever held by the same owner
gen tmp = (((`matchown' | `or_matchown') & pid~=pid[_n-1]) | owner~=owner[_n-1])
by owner: egen N_ever_owned = total(tmp)

*Count number of properties simultaneously attributed to the same owner
sort year owner pid
replace tmp = ((year==year[_n-1] & (`matchown' | `or_matchown') & pid~=pid[_n-1]) | owner~=owner[_n-1])
by year owner: egen N_owned = total(tmp)

sort owner year pid
tab N_ever_owned if owner~=owner[_n-1]
tab N_owned year if year~=year[_n-1]
tab N_owned year if year~=year[_n-1] & N_ever_owned>1


*Separately distinguish movers and investors.
*Movers are associated with different properties over time but only own a single property at once.  Investors own multiple properties simultaneously.
*Once matched to sales, it will be important to distinguish possible first purchase from subsequent purchase (i.e. "movers" are not necessarily
*sophisticated the first time around).
sort owner year pid
by owner: egen max_N_owned = max(N_owned)
gen I_mover = (max_N_owned==1 & N_ever_owned>1)
tab I_mover if owner~=owner[_n-1]
gen I_investor = (max_N_owned>1)
tab I_investor if owner~=owner[_n-1]

*Flag year that owner becomes a "mover" or investor.
sort owner pid year
by owner pid: egen tmp_min_yr = min(year)
by owner pid: egen tmp_max_yr = max(year)
by owner: egen tmp_minmax_pid_yr = min(tmp_max_yr)
gen I_moved = (year>tmp_minmax_pid_yr)
tab I_moved if owner~=owner[_n-1]

gen tmp_invest_yr = year if N_owned>1
by owner: egen tmp_min_invest_yr = min(tmp_invest_yr)
gen I_invested = (year>=tmp_min_invest_yr)
tab I_invested if owner~=owner[_n-1]

drop *tmp*

/**/
