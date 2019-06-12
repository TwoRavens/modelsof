
*************************************************************************;
*  File-Name: 	edit_variables.do						*;
*  Purpose: 	Create and edit variables for analyses.		 *;			 *;
*  Used in: 	Leaders.dta					*;
*************************************************************************;

set more off

*TIME SETTING

#delimit ;
stset endobs, id(leadid) fail(fail==1) origin(eindate) 
enter(time mdy(1,1,1960)) scale(365.25);
#delimit cr


*************************************************************************;
***	MAIN VARIABLES
*************************************************************************;

*BIT SIGN
gen log_num_bit_sign = .
replace log_num_bit_sign = ln(bit_sign + 1)

*Create "bit_lead_..."
*indicator variable =1 if a Leader has signed at least one
*BIT so far in her tenure

sort idacr startobs

cap drop bit_lead_sign
gen bit_lead_sign =.
#delimit ;
replace bit_lead_sign = 1 if ((bit_sign > 0) 
							& (bit_sign != .));
							
replace bit_lead_sign = 1 if ((bit_lead_sign[_n-1] == 1) 
							& (bit_sign[_n-1] != .)
							& (leadid == leadid[_n-1])) ;
replace bit_lead_sign = 0 if bit_lead_sign == . ;							
#delimit cr



*BIT FORCE
gen log_num_bit_force = .
replace log_num_bit_force = ln(bit_force + 1)

gen bit_lead_force =.
#delimit ;
replace bit_lead_force = 1 if ((bit_force > 0) 
							& (bit_force != .));
							
replace bit_lead_force = 1 if ((bit_lead_force[_n-1] == 1) 
							& (bit_lead_force[_n-1] != .)
							& (leadid == leadid[_n-1])) ;
replace bit_lead_force = 0 if bit_lead_force == . ;							
#delimit cr


**NEW VARIABLES

*BITs SIGN NUMBER LEADER UP TO YEAR t

/* A count measure (BITsignnumber) of the number of BITs that go into 
operation between the time a given leaders takes office and year t */
*Label
*Number of BITs the Currently Leader has Signed on or Before Year t
#delimit ;
gen bit_sign_leader = . ;
replace bit_sign_leader = bit_sign ;
replace bit_sign_leader = bit_sign_leader[_n] + bit_sign_leader[_n-1]
 if leadid[_n] == leadid[_n-1] ;
gen logbit_sign_leader = log(bit_sign_leader + 1) ;
#delimit cr

*USING WEIGHTED BITS
#delimit ;
gen bit_sign_leader_w = . ;
cap replace bit_sign_leader_w = bit_sign_weighted ;
cap replace bit_sign_leader_w = bit_sign_leader_w[_n] + bit_sign_leader_w[_n-1]
 if leadid[_n] == leadid[_n-1] ;
cap gen logbit_sign_leader_w = log(bit_sign_leader_w + 1) ;
#delimit cr

*FORCE
#delimit ;
gen bit_force_leader = . ;
replace bit_force_leader = bit_force ;
replace bit_force_leader = bit_force_leader[_n] + bit_force_leader[_n-1]
 if leadid[_n] == leadid[_n-1] ;
gen logbit_force_leader = log(bit_force_leader + 1) ;
#delimit cr


*COUNTRY BIT SIGN UNTIL THE PREVIOUS YEAR
sort idacr startobs

gen bit_sign_country = .
replace bit_sign_country = bit_sign
replace bit_sign_country = bit_sign_country[_n] + bit_sign_country[_n-1] if idacr[_n] == idacr[_n-1] 
gen lagbit_sign_country = bit_sign_country - bit_sign
gen loglagbit_sign_country = log(lagbit_sign_country + 1)

gen bit_force_country = .
replace bit_force_country = bit_force
replace bit_force_country = bit_force_country[_n] + bit_force_country[_n-1] if idacr[_n] == idacr[_n-1] 
gen lagbit_force_country = bit_force_country - bit_force
gen loglagbit_forcecountry = log(lagbit_force_country + 1)

*COUNTRY BIT SIGN UNTIL THE PREVIOUS LEADER
gen bit_sign_country_prevl = .
replace bit_sign_country_prevl = bit_sign_country - bit_sign_leader
gen logbit_sign_country_prevl = log(bit_sign_country_prevl + 1)

gen bit_force_country_prevl = .
replace bit_force_country_prevl = bit_force_country - bit_force_leader
gen logbit_force_country_prevl = log(bit_force_country_prevl + 1)


*************************************************************************;
*INTERACTIONS WITH DEMOCRACY
*************************************************************************;

gen bitabs_sign_dem = bit_sign * polity2
gen bitabs_force_dem = bit_force * polity2

gen bit_sign_dem = log_num_bit_sign * polity2
gen bit_force_dem = log_num_bit_force * polity2


*************************************************************************;
* PTAs
*************************************************************************;

*PTA NUMBER LEADER UP TO YEAR t
sort idacr startobs

#delimit ;
cap drop ptanoinv_leader ;
gen ptanoinv_leader = . ;
replace ptanoinv_leader = ptanoinv ;
replace ptanoinv_leader = ptanoinv_leader[_n] + ptanoinv_leader[_n-1]
 if leadid[_n] == leadid[_n-1] ;
cap drop logptanoinv_leader;
gen logptanoinv_leader = log(ptanoinv_leader + 1) ;
#delimit cr


*************************************************************************;
* UNESCO
*************************************************************************;
replace unesco = 0 if unesco == .
replace unesco = 0 if fail == 1

sort idacr startobs

#delimit ;
gen unesco_leader = . ;
replace unesco_leader = unesco ;
replace unesco_leader = unesco_leader[_n] + unesco_leader[_n-1]
 if leadid[_n] == leadid[_n-1] ;
gen logunesco_leader = log(unesco_leader + 1) ;
#delimit cr

#delimit ;
gen unesco_country = . ;
replace unesco_country = unesco ;
replace unesco_country = unesco_country[_n] + unesco_country[_n-1]
 if idacr[_n] == idacr[_n-1] ;
gen logunesco_country = log(unesco_country + 1) ;
#delimit cr



*************************************************************************;
* LABELS
*************************************************************************;

label variable bit_force "BITs in force"
label variable bit_sign "BITs signed"

label variable log_num_bit_force "BITs in force (Ln)"
label variable log_num_bit_sign "BITs signed (Ln)"

label variable polity2 "Polity2"

label variable bitabs_sign_dem  "BITs signed $\times$ Polity2"
label variable bitabs_force_dem "BITs in force $\times$ Polity2"

label variable bit_sign_dem  "BITs signed (Ln) $\times$ Polity2"
label variable bit_force_dem "BITs in force (Ln) $\times$ Polity2"

label variable bit_force_leader "BITs in force (leader tenure)"
label variable bit_sign_leader "BITs signed (leader tenure)"

label variable logbit_force_leader "BITs in force (leader tenure) (Ln)"
label variable logbit_sign_leader "BITs signed (leader tenure) (Ln)"

label variable tradewdi "Trade (\% of GDP)"
label variable loggdppcwdi "GDPpc (Ln)"
label variable logpopwdi "Population (Ln)"
label variable gdpgrowthwdi "Growth (\% of GDP)" 
label variable logoilgas "Oil and Gas Prod. (Ln)"
label variable loggdpwdi "GDP (Ln)"
label variable logaid "Foreign Aid (Ln)"

label variable loglagbit_sign_country "BITs signed (country) (Ln)"
label variable logbit_sign_country_prevl "BITs signed (country, $l-1$) (Ln)"
label variable logptanoinv_leader "PTAs signed (leader tenure)"

*************************************************************************;


