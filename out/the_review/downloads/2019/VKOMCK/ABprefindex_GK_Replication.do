*GENERAL INFO
	* Project: Political Competition and Public Goods Provision
	* Created by: Jessica Gottlieb
	* Date created: July 2018
* DO FILE INFO
	* This file creates the preference fractionalization index using geo-coded AB data from Mali rounds 2-4

* HOUSEKEEPING
	clear
	set more off

*********************************************************************

***Import geo-coded data from R2-4 that was joined with commune names
use "afrobarometer_with_communes", clear

*Drop R1 (no priority var) and R5/6, too late
drop if round<2 | round>4

***Generate simplified categories of all priorities

generate aEconPov=.
generate aAgFood=.
generate aEd=.
generate aHealth=.
generate aWater=.
generate aSecurity=.
generate aInfrastructure=.
generate aPolitics=.
generate aElectricity=.

foreach i in 1 2 3{
*Round 2
replace aEconPov=1 if (priority`i'==1 | priority`i'==2 | priority`i'==3 | priority`i'==7 | priority`i'==8 | priority`i'==26 | priority`i'==28 | priority`i'==32) & round==2
replace aAgFood=1 if (priority`i'==4 | priority`i'==5 | priority`i'==25 | priority`i'==29) & round==2
replace aEd=1 if priority`i'==9 & round==2
replace aHealth=1 if (priority`i'==10 | priority`i'==11) & round==2
replace aWater=1 if (priority`i'==13) & round==2
replace aSecurity=1 if (priority`i'==12 | priority`i'==23 | priority`i'==24 | priority`i'==31) & round==2
replace aInfrastructure=1 if (priority`i'==15 | priority`i'==16 | priority`i'==27) & round==2
replace aPolitics=1 if priority`i'>=17 & priority`i'<=22 & round==2
replace aElectricity=1 if priority`i'==30 & round==2

*Round 3
replace aEconPov=1 if (priority`i'==1 | priority`i'==2 | priority`i'==3 | priority`i'==4 | priority`i'==5 | priority`i'==6 | priority`i'==18) & round==3
replace aAgFood=1 if (priority`i'==7 | priority`i'==8 | priority`i'==9 | priority`i'==10) & round==3
replace aEd=1 if priority`i'==14 & round==3
replace aHealth=1 if (priority`i'==20 | priority`i'==21 | priority`i'==22) & round==3
replace aWater=1 if (priority`i'==17) & round==3
replace aSecurity=1 if (priority`i'==23 | priority`i'==30 | priority`i'==31) & round==3
replace aInfrastructure=1 if (priority`i'==11 | priority`i'==12 | priority`i'==13 | priority`i'==15) & round==3
replace aPolitics=1 if priority`i'>=24 & priority`i'<=29 & round==3
replace aElectricity=1 if priority`i'==16 & round==3

*Round 4
replace aEconPov=1 if (priority`i'==1 | priority`i'==2 | priority`i'==3 | priority`i'==4 | priority`i'==5 | priority`i'==6 | priority`i'==18) & round==4
replace aAgFood=1 if (priority`i'==7 | priority`i'==8 | priority`i'==9 | priority`i'==10 | priority`i'==32) & round==4
replace aEd=1 if priority`i'==14 & round==4
replace aHealth=1 if (priority`i'==20 | priority`i'==21 | priority`i'==22) & round==4
replace aWater=1 if (priority`i'==17) & round==4
replace aSecurity=1 if (priority`i'==23 | priority`i'==30 | priority`i'==31) & round==4
replace aInfrastructure=1 if (priority`i'==11 | priority`i'==12 | priority`i'==13 | priority`i'==15) & round==4
replace aPolitics=1 if priority`i'>=24 & priority`i'<=29 & round==4
replace aElectricity=1 if priority`i'==16 & round==4
}

collapse (sum) EconPov-Electricity aEconPov-aElectricity, by(Commune_name-commune)

egen total=rowtotal(EconPov-Electricity)
egen total1=rowtotal(aEconPov-aElectricity)

foreach var of varlist EconPov-Electricity{
generate s`var'=(`var'/total)^2
}

foreach var of varlist aEconPov-aElectricity{
generate s`var'=(`var'/total1)^2
}

egen prefindex1=rowtotal(sEconPov-sElectricity)
replace prefindex1=1-prefindex1

egen prefindexall=rowtotal(saEconPov-saElectricity)
replace prefindexall=1-prefindexall

keep Commune_name Region_name Cercle_name commune prefindex1 prefindexall total
sort commune
save "..\Data\Afrobarometer\prefindex", replace
