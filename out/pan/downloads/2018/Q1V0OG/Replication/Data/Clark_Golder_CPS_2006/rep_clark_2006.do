clear
set mem 10m
set matsize 150

global path = "/Users/jhainmueller/Dropbox/"
cd "$path/interaction paper/Data/IncludedCleanedToShare/Clark_Golder_CPS_2006/"

use "Legislative_new.dta"

label var country  "countryname"
label var newdem "first election as new democracy"
label var countrynumber "countrynumber"
label var year "year"
label var regime "regime as of 31 December of given year 0=democracy 1=dictatorship"
label var regime_leg "regime type at time of legislative election 0 = democracy 1=dictatorship"
label var legelec "legislative election"
label var preselec "presidential election"
label var eighties "election in 1980s closest to 1985"
label var old "elections in countries that did not transition to democracy in 1990s"
label var nineties "elections in 1990s closest to 1995"
label var proximity1 "proximity - continuous"
label var proximity2 "proximity - dichotomous"
label var enpp "parliamentary parties - uncorrected"
label var enpp1 "parliamentary parties - corrected"
label var enep "electoral parties - uncorrected"
label var enep1 "electoral parties - corrected"
label var enpres "effective number of presidential candidates"
label var seats "assembly size"
label var districts "number of electoral districts"
label var avemag "average district magnitude"
label var medmag "median district magnitude"
label var upperseats "number of uppertier seats"
label var uppertier "percentage of uppertier seats"
label var eneg "effective number of ethnic groups  fearon"

describe

drop if countrynumber==163
drop if countrynumber==165
drop if countrynumber==197
drop if countrynumber==189
drop if countrynumber==146
drop if countrynumber==198
drop if countrynumber==167
drop if countrynumber==70 & year==1958
drop if countrynumber==70 & year==1960
drop if countrynumber==70 & year==1962
drop if countrynumber==70 & year==1964
drop if countrynumber==70 & year==1966
drop if countrynumber==70 & year==1968
drop if countrynumber==70 & year==1970
drop if countrynumber==12 & year==1963

sum

generate logmag=ln(avemag)
generate uppertier_eneg = uppertier*eneg
generate logmag_eneg = logmag*eneg
generate proximity1_enpres = proximity1*enpres


drop if countrynumber==67
drop if countrynumber==76
drop if countrynumber==59 & year==1957
drop if countrynumber==59 & year==1971
drop if countrynumber==59 & year==1985
drop if countrynumber==59 & year==1989
drop if countrynumber==59 & year==1993
drop if countrynumber==57 & year==1990
drop if countrynumber==54 & year==1966
drop if countrynumber==54 & year==1970
drop if countrynumber==54 & year==1974
drop if countrynumber==54 & year==1986
drop if enep_others>15 & enep_others<100



drop if countrynumber==132
drop if countrynumber==29
drop if countrynumber==87 & year==1988
drop if countrynumber==87 & year==1992
drop if countrynumber==87 & year==1996
drop if countrynumber==116 & year==1987
drop if countrynumber==116 & year==1996

                


//Table 2 model 4 - 1990s established democracies - basis for 3rd panel in Figure 1?
regress enep1  eneg logmag uppertier enpres proximity1 logmag_eneg uppertier_eneg proximity1_enpres if nineties==1 & old==1

keep if e(sample)==1
saveold "rep_clark_2006a.dta", replace

clear

//Table 2 model 6 - 1946-2000 established democracies - might be first panel in Figure 1 and also Figure 2

set mem 10m
set matsize 150

use "Legislative_new.dta"

label var country  "countryname"
label var newdem "first election as new democracy"
label var countrynumber "countrynumber"
label var year "year"
label var regime "regime as of 31 December of given year 0=democracy 1=dictatorship"
label var regime_leg "regime type at time of legislative election 0 = democracy 1=dictatorship"
label var legelec "legislative election"
label var preselec "presidential election"
label var eighties "election in 1980s closest to 1985"
label var old "elections in countries that did not transition to democracy in 1990s"
label var nineties "elections in 1990s closest to 1995"
label var proximity1 "proximity - continuous"
label var proximity2 "proximity - dichotomous"
label var enpp "parliamentary parties - uncorrected"
label var enpp1 "parliamentary parties - corrected"
label var enep "electoral parties - uncorrected"
label var enep1 "electoral parties - corrected"
label var enpres "effective number of presidential candidates"
label var seats "assembly size"
label var districts "number of electoral districts"
label var avemag "average district magnitude"
label var medmag "median district magnitude"
label var upperseats "number of uppertier seats"
label var uppertier "percentage of uppertier seats"
label var eneg "effective number of ethnic groups  fearon"

describe

drop if countrynumber==163
drop if countrynumber==165
drop if countrynumber==197
drop if countrynumber==189
drop if countrynumber==146
drop if countrynumber==198
drop if countrynumber==167
drop if countrynumber==70 & year==1958
drop if countrynumber==70 & year==1960
drop if countrynumber==70 & year==1962
drop if countrynumber==70 & year==1964
drop if countrynumber==70 & year==1966
drop if countrynumber==70 & year==1968
drop if countrynumber==70 & year==1970
drop if countrynumber==12 & year==1963

sum

generate logmag=ln(avemag)
generate uppertier_eneg = uppertier*eneg
generate logmag_eneg = logmag*eneg
generate proximity1_enpres = proximity1*enpres


drop if countrynumber==67
drop if countrynumber==76
drop if countrynumber==59 & year==1957
drop if countrynumber==59 & year==1971
drop if countrynumber==59 & year==1985
drop if countrynumber==59 & year==1989
drop if countrynumber==59 & year==1993
drop if countrynumber==57 & year==1990
drop if countrynumber==54 & year==1966
drop if countrynumber==54 & year==1970
drop if countrynumber==54 & year==1974
drop if countrynumber==54 & year==1986
drop if enep_others>15 & enep_others<100



drop if countrynumber==132
drop if countrynumber==29
drop if countrynumber==87 & year==1988
drop if countrynumber==87 & year==1992
drop if countrynumber==87 & year==1996
drop if countrynumber==116 & year==1987
drop if countrynumber==116 & year==1996

                


regress enep1  eneg logmag uppertier enpres proximity1 logmag_eneg uppertier_eneg proximity1_enpres if old==1, robust cluster(country)

keep if e(sample)==1
saveold "rep_clark_2006b.dta", replace



// generate model for Figure 1 panel 2 using cox data set

clear

set mem 10m

use "Coxappend.dta", clear


replace upper=upper*100


generate enpv_upper = enpv*upper

generate eneth_upper=eneth*upper

generate uppereneth=upper*eneth

regress enpv lnml upper enpres  proximit proxpres eneth lmleneth uppereneth if drop==0


keep if e(sample)==1
saveold "rep_clark_2006c.dta", replace

