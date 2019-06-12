
clear
set more off

use "American Dream.dta"


/* =============================================================================*/
/* PREPARE DATA */
/* =============================================================================*/

*rename feeling thermometers for groups / figures
rename feelings_1 feeldem
rename feelings_2 feelrep
rename feelings_3 feelclinton
rename feelings_4 feeltrump

*initial 7-point party ID
gen pid = .
replace pid = 1 if pid_dem == 1
replace pid = 2 if pid_dem == 2
replace pid = 3 if pid_lean == 1
replace pid = 4 if pid_lean == 3
replace pid = 5 if pid_lean == 2
replace pid = 6 if pid_rep == 2
replace pid = 7 if pid_rep == 1

*political discussion
replace poldiscussion = poldiscussion - 1

*political efficacy
egen polefficacy = rowmean(polefficacy1 polefficacy2)

*pid strength
recode pid (1=3) (2=2) (3=2) (4=0) (5=1) (6=2) (7=3), gen(pidstrength)

*party bridging
egen demrep = rowmean(friends_dem friends_rep)
egen demindep = rowmean(friends_dem friends_indep)
egen repindep = rowmean(friends_rep friends_indep)
gen partybridging = .
replace partybridging = demrep if pid == 4
replace partybridging = demindep if pid > 4
replace partybridging = repindep if pid < 4
gen partybridging2 = .
replace partybridging2 = friends_dem if pid > 4
replace partybridging2 = friends_rep if pid < 4

*party bonding
gen partybonding = .
replace partybonding = friends_dem if pid < 4
replace partybonding = friends_rep if pid > 4
replace partybonding = friends_indep if pid == 4

label define relationships 1 "1 (None)" 2 "2 (Just a few)" 3 "3 (Some)" 4 "4 (A lot)"
label values partybonding relationships
label values partybridging relationships
label values partybridging2 relationships

*feeling inparty and outparty
gen feelinparty = .
replace feelinparty = feeldem if pid < 4
replace feelinparty = feelrep if pid > 4
gen feeloutparty = .
replace feeloutparty = feeldem if pid > 4
replace feeloutparty = feelrep if pid < 4
gen feelinggap = feelinparty - feeloutparty

*feeling candidate inparty and outparty
gen candidateinparty = .
replace candidateinparty = feelclinton if pid < 4
replace candidateinparty = feeltrump if pid > 4
gen candidateoutparty = .
replace candidateoutparty = feelclinton if pid > 4
replace candidateoutparty = feeltrump if pid < 4
gen candidategap = candidateinparty - candidateoutparty

*dummy for party
gen repdummy = .
replace repdummy = 0 if pid < 4
replace repdummy = 1 if pid > 4

*partisan traits ====================================
egen meanpos_dem = rowmean(traits_dem_1 traits_dem_2)
egen meanneg_dem = rowmean(traits_dem_3 traits_dem_4)
egen meanpos_rep = rowmean(traits_rep_1 traits_rep_2)
egen meanneg_rep = rowmean(traits_rep_3 traits_rep_4)
gen nettraits_dem = meanpos_dem - meanneg_dem
gen nettraits_rep = meanpos_rep - meanneg_rep

gen nettraits_outparty = .
replace nettraits_outparty = nettraits_dem if pid > 4
replace nettraits_outparty = nettraits_rep if pid < 4

gen meanpos_outparty = .
replace meanpos_outparty = meanpos_dem if pid > 4
replace meanpos_outparty = meanpos_rep if pid < 4

gen meanneg_outparty = .
replace meanneg_outparty = meanneg_dem if pid > 4
replace meanneg_outparty = meanneg_rep if pid < 4
