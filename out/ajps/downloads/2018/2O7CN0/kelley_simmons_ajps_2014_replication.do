*Replication data for "Politics by Number: Indicators as Social Pressure in International Relations" 
*Judith Kelley and Beth Simmons
*Last Revised: February 27, 2014

**********************************************************************
****TABLE 1*****

*Load .dta file - set this to your local path to the .dta replication
use "kelley_simmons_ajps_2014_replication.dta", clear

*Identify data as time series cross section
sort cowcode year
tsset cowcode year, yearly

** Drop pre-1991 observations
drop if year<1991

*transform ht data to deal with missing values
replace ht_incidence_origin = 0 if ht_incidence_origin==. & (ht_incidence_transit!=. | ht_incidence_destination!=.)
replace ht_incidence_transit = 0 if ht_incidence_transit ==. & (ht_incidence_origin!=. | ht_incidence_destination!=.)
replace ht_incidence_destination = 0 if ht_incidence_destination ==. & (ht_incidence_origin!=. | ht_incidence_transit!=.)
*generate alternative missing information variable that does not use the incidence data
drop mcorrupt mfh_pr mdata6 mdata7 mdata3 mdata8 magree3un 	
gen mfh_pr = fh_pr ==.
gen mdata8 = data8 ==.
gen mdata7 = data7 ==.
gen mdata6 = data6 ==.
gen mdata3 = data3 ==.
gen magree3un= agree3un==.
gen mcorrupt=corrupt==.
gen missinfo82= mfh_pr+ mdata6+ mdata7+ mdata3+ mdata8+ mcorrupt+ magree3
gen missinfo82_1=missinfo82[_n-1]
gen missinfo82_2=missinfo82[_n-2]

*generating variables to help me drop countries that are always 1 or always 3
gen tierX=tier
replace tierX=. if tierX>3

egen meantierX = mean(tierX), by(cowcode)

gen always1=1 if meantierX==1
gen always3=1 if meantierX==3

recode fullwaiver 1=1 *=0
gen fullwaiver1=fullwaiver[_n-1]
gen notier=tier
recode notier 555=1 *=0
gen notier1=notier[_n-1]

gen inreport1=1 if notier1==0
replace inreport1=0 if notier1==1

** Lag covariates
gen logpop=log(data9)
gen logpop_1=(logpop[_n-1])
gen missinfo8_1=missinfo8[_n-1]
gen missinfo8_2=missinfo8[_n-2]
gen fh_cl1=fh_cl[_n-1]
gen ratproto2000_1=ratproto2000[_n-1]

*CRIMINALIZATION: Corrected regional density
gen crim1= adjbicrimlevel
recode crim1 0=0 1/2=1
gen crim1_plus1= crim1[_n+1]
gen crim1_minus1= crim1[_n-1]
gen nocrimyrs=crim1_plus1
recode nocrimyrs 1=0 0=1
*generate the regional density (incorrectly including the ith country)
egen regcrim=mean(crim1), by (subregion year)
*how many states in each subregion?
gen column1=1
egen num_states_in_subreg=count(column1), by (subregion year)
*how many states in a given subregion/year have criminalized?
gen num_crim_1 = num_states_in_subreg * regcrim
*now create the correct regional density var
gen corrected_regcrim = .
*if ith observation hasn't criminalized, then density = number of those with obligations / number of states excluding the ith
replace corrected_regcrim = num_crim_1/( num_states_in_subreg-1) if crim1==0
*if ith observation has criminalized ht, then density = number of those criminalizing excluding the ith / number of states excluding the ith
replace corrected_regcrim = (num_crim_1-1)/( num_states_in_subreg-1) if crim1==1
gen corrected_regcrim100=corrected_regcrim*100
gen corrected_regcrim1_1=corrected_regcrim[_n-1]
gen corrected_regcrim1_2=corrected_regcrim[_n-2]
drop column1
drop num_crim_1

*making the hazard recodes
 
 *create new variable for years before "failing" (entering report)
 gen yr2fail2=tier_date - year

*create variable for whether the country has ever moved to ratify ("endstate_inreport"):
egen endstate_inreport=mean(notier), by (name)
recode endstate_inreport .001/1=1
 
 *create variable for years since it is possible to be in report ( post 2000)
 gen yrfromj2=year - 2000
 
 *create a variable for whether country was included in report in the given year
 gen fail=0 if yr2fail2 >=1
 replace fail=1 if yr2fail2==0
 replace fail=2 if endstate_inreport==0
 recode fail 2=0
 
 *dropping cases in which yr2fail2<0 and yrfromj2<0 in order to confine dataset to those within the spell
 sort yr2fail2
 drop if yr2fail2<0
 *tabulate country
 drop if yrfromj2<0
 *tabulate country
 sort name year
 
 *setting up for survival analysis
 
 *first, dropping cases with missing values on yrfromj2
 drop if yrfromj2==.
 
 *now dealing with cases for which yrfromj2=0 - STATA can't handle zero so we recode to .01
replace yrfromj2=.01 if yrfromj2==0
 
*creating the survival variables 
stset yrfromj2 fail, id(name)
sort name year

*CREATING TABLE 1
stcox  logpop_1   missinfo8_1 if year>2000, robust
outreg2 using "kelley_simmons_table1", stnum(replace coef=exp(coef), replace se=coef*se) cti(odds ratio) bdec(3) addstat(Log Pseudo-likelihood, e(ll), subjects, e(N_sub), failures, e(N_fail)) word see
stcox  logpop_1  missinfo8_1 ngos_ave fh_cl1   corrected_regcrim1_1 ratproto2000_1 if year>2000, robust
outreg2 using "kelley_simmons_table1", stnum(replace coef=exp(coef), replace se=coef*se) cti(odds ratio) bdec(3) addstat(Log Pseudo-likelihood, e(ll), subjects, e(N_sub), failures, e(N_fail)) word see
stcox  logpop_1  missinfo8_1 ngos_ave fh_cl1 corrected_regcrim1_1 ratproto2000_1 ht_incidence_origin ht_incidence_transit ht_incidence_destination if year>2000, robust
outreg2 using "kelley_simmons_table1", stnum(replace coef=exp(coef), replace se=coef*se) cti(odds ratio) bdec(3) addstat(Log Pseudo-likelihood, e(ll), subjects, e(N_sub), failures, e(N_fail)) word see

***********************************************
*****TABLE 2**********

*Load .dta file - set this to your local path to the .dta replication
use "kelley_simmons_ajps_2014_replication.dta", clear

*Identify data as time series cross section
sort cowcode year
tsset cowcode year, yearly

** Drop pre-1991 observations
drop if year<1991

* Lag covariates
gen fh_cl1=fh_cl[_n-1]
gen rule_of_law_1=rule_of_law[_n-1]
gen corruption_1 = corruption[_n-1]
gen logpop=log(data9)
gen loggdp_1=log(data2[_n-1])
gen ratproto2000_1=ratproto2000[_n-1]

* Generate US pressure variable
gen  uspressure= tier
recode uspressure 555=0 666=0 1=0 2=0 2.5=1 3=1 .=0 
gen uspressure_1= uspressure[_n-1]

* Economic assistance variable
gen econasstP=econasst
replace econasstP=econasst * 1000000
replace econasstP=1 if econasstP==0
replace econasstP=1 if econasstP==.
summ econasstP
gen logeconasstP=log(econasstP)
gen logeconasstP_1=logeconasstP[_n-1]
summ logeconasstP_1

*CREATING TABLE 2
logit uspressure fh_cl1 logeconasstP_1 loggdp_1 logpop ratproto2000_1  ngos_ave corruption_1, or 
outreg2 using "kelley_simmons_table2", stnum(replace coef=exp(coef), replace se=coef*se) cti(odds ratio) bdec(3) word see
logit uspressure fh_cl1 logeconasstP_1 loggdp_1 logpop ratproto2000_1  ngos_ave rule_of_law_1, or 
outreg2 using "kelley_simmons_table2", stnum(replace coef=exp(coef), replace se=coef*se) cti(odds ratio) bdec(3) word see

**************************************************
******TABLE 3/TABLE 4*************

*Load .dta file - set this to your local path to the .dta replication
use "kelley_simmons_ajps_2014_replication.dta", clear

*Identify data as time series cross section
sort cowcode year
tsset cowcode year, yearly

** Drop pre-1991 observations
drop if year<1991

*transform ht data to deal with missing values
replace ht_incidence_origin = 0 if ht_incidence_origin==. & (ht_incidence_transit!=. | ht_incidence_destination!=.)
replace ht_incidence_transit = 0 if ht_incidence_transit ==. & (ht_incidence_origin!=. | ht_incidence_destination!=.)
replace ht_incidence_destination = 0 if ht_incidence_destination ==. & (ht_incidence_origin!=. | ht_incidence_transit!=.)

*generating variables to help me drop countries that are always 1 or always 3
gen tierX=tier
replace tierX=. if tierX>3

egen meantierX = mean(tierX), by(cowcode)

gen always1=1 if meantierX==1
gen always3=1 if meantierX==3

recode fullwaiver 1=1 *=0
gen fullwaiver1=fullwaiver[_n-1]

* Generating an average aid variable
bysort name year: generate econasst0=econasst
replace econasst0=0 if econasst==.

sort name year
bysort name: egen totalaidave=mean(econasst0) if year>2000 & year<2011

* generating extra variables to differentiate not in report and special cases
gen notinreport=tier
recode notinreport 555=1 *=0
gen notinreport1= notinreport[_n-1]
gen special=tier
recode special 666=1 *=0
gen special1=special[_n-1]
*
gen dostier=tier
gen dostier1=dostier[_n-1]
gen notier=tier
recode notier 555=1 666=1 *=0
gen notier1=notier[_n-1]
recode tier 555=0 666=0 .=0
gen tier1=tier[_n-1]
gen tier1_1=tier1 
recode tier1_1 1=1 *=0
gen tier1_2=tier1
recode tier1_2 2=1 *=0
gen tier1_25=tier1
recode tier1_25 2.5=1 *=0
gen tier1_3=tier1
recode tier1_3 3=1 *=0
gen waivers1_tier1_3 =tier1_3 *fullwaiver1
gen econasst1=econasst[_n-1]
recode econasst1 0=.001 .=.001
gen logeconasst1=log(econasst1)
gen loggdppercap_1=log(data4[_n-1])
gen loggdppercap_2=log(data4[_n-2])

gen chtier=tier-tier1
gen chtier1=chtier[_n-1]
gen improve_tier=chtier
gen worsen_tier=chtier
recode improve_tier 0=0 -3/-.001=1 .001/3=0
recode worsen_tier 0=0 .001/3=1 -3/-.001=0
gen  improve_tier1= improve_tier[_n-1]
gen worsen_tier1=  worsen_tier[_n-1]
gen new_watch1=new_watch[_n-1]
recode  new_watch1 1=1 *=0
gen new_watch2=new_watch[_n-2]
recode  new_watch2 1=1 *=0
gen new_watch3=new_watch[_n-3]
recode  new_watch3 1=1 *=0


gen women1=women_par[_n-1]
gen fh_cl1=fh_cl[_n-1]
gen protection_1=protection[_n-1]
gen corruption_1 = corruption[_n-1]
gen logpop=log(data9)
gen logpop_1=logpop[_n-1]
gen loggdp_1=log(data2[_n-1])
gen missinfo8_1=missinfo8[_n-1]
gen missinfo8_2=missinfo8[_n-2]
gen ratproto2000_1=ratproto2000[_n-1]

gen crim1= adjbicrimlevel
recode crim1 0=0 1/2=1
gen crim1_plus1= crim1[_n+1]
gen crim1_minus1= crim1[_n-1]
gen nocrimyrs=crim1_plus1
recode nocrimyrs 1=0 0=1

*CRIMINALIZATION: Corrected regional density
*generate the regional density (incorrectly including the ith country)
egen regcrim=mean(crim1), by (subregion year)
*how many states in each subregion?
gen column1=1
egen num_states_in_subreg=count(column1), by (subregion year)
*how many states in a given subregion/year have criminalized?
gen num_crim_1 = num_states_in_subreg * regcrim
*now create the correct regional density var
gen corrected_regcrim = .
*if ith observation hasn't criminalized, then density = number of those with obligations / number of states excluding the ith
replace corrected_regcrim = num_crim_1/( num_states_in_subreg-1) if crim1==0
*if ith observation has criminalized ht, then density = number of those criminalizing excluding the ith / number of states excluding the ith
replace corrected_regcrim = (num_crim_1-1)/( num_states_in_subreg-1) if crim1==1
gen corrected_regcrim100=corrected_regcrim*100
gen corrected_regcrim1_1=corrected_regcrim[_n-1]
gen corrected_regcrim1_2=corrected_regcrim[_n-2]
drop column1
drop num_crim_1

**economic assistance
gen econasstP=econasst
replace econasstP=econasst * 1000000
replace econasstP=1 if econasstP==0
replace econasstP=1 if econasstP==.
summ econasstP
gen logeconasstP=log(econasstP)
gen logeconasstP_1=logeconasstP[_n-1]
summ logeconasstP_1

**aid as share of gdp
gen econasstPgdp=econasstP/data2
gen econasstPgdp_1=econasstPgdp[_n-1]
gen logeconasstPgdp=log(econasstPgdp)
gen logeconasstPgdp_1=logeconasstPgdp[_n-1]

*making the hazard recodes
 
 *create new variable for years before "failing" (criminalizing HT)
 gen yr2fail2=crim1date - year

*create variable for whether the country has ever moved to ratify ("endstate1"):
egen endstate1=mean(crim1), by (name)
recode endstate1 .001/1=1
 
 *create variable for years since it is possible to criminalize (independent country and post 1966)
 gen yrfromj2=year - 1991
 
 *create a variable for whether country ratified in the given year
 gen fail=0 if yr2fail2 >=1
 replace fail=1 if yr2fail2==0
 replace fail=2 if endstate1==0
 recode fail 2=0
 
 *dropping cases in which yr2fail2<0 and yrfromj2<0 in order to confine dataset to those within the spell
 sort yr2fail2
 drop if yr2fail2<0
 *tabulate country
 drop if yrfromj2<0
 *tabulate country
 sort name year
 
 *setting up for survival analysis
 
 *first, dropping cases with missing values on yrfromj2
 drop if yrfromj2==.
 
 *now dealing with cases for which yrfromj2=0 - STATA can't handle zero so we recode to .01
replace yrfromj2=.01 if yrfromj2==0
 
*creating the survival variables 
stset yrfromj2 fail, id(name)

*GENERATING VARIOUS INTERACTION TERMS
gen inreport1=1 if notier1==0
replace inreport1=0 if notier1==1

*interaction with log of aid
gen test00=inreport1*logeconasstP_1

*Interaction with aid as share of gdp (multiplied by 1000 to make coefficient more standard)
gen  econasstPgdp_1_1000=econasstPgdp_1*1000
gen test_gdp_1_1000=econasstPgdp_1_1000*inreport1

sort name year

set more off

****GENERATE TABLE 3*****
*MODEL 3.1
stcox  inreport1  women1  fh_cl1 corrected_regcrim1_1 ratproto2000_1 missinfo8_2 ht_incidence_origin ht_incidence_transit ht_incidence_destination if year>1999, robust
estat phtest, log detail
outreg2 using "kelley_simmons_table3", stnum(replace coef=exp(coef), replace se=coef*se) cti(odds ratio) bdec(3) addstat(Log Pseudo-likelihood, e(ll), subjects, e(N_sub), failures, e(N_fail)) word see
*MODEL 3.2
stcox  inreport1  women1  fh_cl1 corrected_regcrim1_1 ratproto2000_1 missinfo8_2 logpop_1 ngos_ave  loggdppercap_1 corruption_1 if year>1999, robust
estat phtest, log detail
outreg2 using "kelley_simmons_table3", stnum(replace coef=exp(coef), replace se=coef*se) cti(odds ratio) bdec(3) addstat(Log Pseudo-likelihood, e(ll), subjects, e(N_sub), failures, e(N_fail)) word see
*MODEL 3.3
stcox  inreport1 women1  fh_cl1 corrected_regcrim1_1 ratproto2000_1 missinfo8_2 logeconasstP_1 if year>1999, robust
estat phtest, log detail
outreg2 using "kelley_simmons_table3", stnum(replace coef=exp(coef), replace se=coef*se) cti(odds ratio) bdec(3) addstat(Log Pseudo-likelihood, e(ll), subjects, e(N_sub), failures, e(N_fail)) word see
*MODEL 3.4
stcox  inreport1 women1  fh_cl1 corrected_regcrim1_1 ratproto2000_1 missinfo8_2 logeconasstP_1 test00 if year>1999, robust
estat phtest, log detail
outreg2 using "kelley_simmons_table3", stnum(replace coef=exp(coef), replace se=coef*se) cti(odds ratio) bdec(3) addstat(Log Pseudo-likelihood, e(ll), subjects, e(N_sub), failures, e(N_fail)) word see
*MODEL 3.5
stcox  inreport1 women1  fh_cl1 corrected_regcrim1_1 ratproto2000_1 missinfo8_2 econasstPgdp_1_1000 test_gdp_1_1000 if year>1999, robust
outreg2 using "kelley_simmons_table3", stnum(replace coef=exp(coef), replace se=coef*se) cti(odds ratio) bdec(3) addstat(Log Pseudo-likelihood, e(ll), subjects, e(N_sub), failures, e(N_fail)) word see


****GENERATE TABLE 4*****
*MODEL 4.1
stcox  tier1_1 tier1_2 tier1_25 tier1_3  women1  fh_cl1 corrected_regcrim1_1 ratproto2000_1 missinfo8_2 ht_incidence_origin ht_incidence_transit ht_incidence_destination if year>1999, robust
estat phtest, log detail
outreg2 using "kelley_simmons_table4", stnum(replace coef=exp(coef), replace se=coef*se) cti(odds ratio) bdec(3) addstat(Log Pseudo-likelihood, e(ll), subjects, e(N_sub), failures, e(N_fail)) word see
*MODEL 4.2
stcox  tier1_1 tier1_2 tier1_25 tier1_3  women1  fh_cl1 corrected_regcrim1_1 ratproto2000_1 missinfo8_2 logpop_1 ngos_ave logeconasstP_1 loggdppercap_1 corruption_1 if year>1999, robust
estat phtest, log detail
outreg2 using "kelley_simmons_table4", stnum(replace coef=exp(coef), replace se=coef*se) cti(odds ratio) bdec(3) addstat(Log Pseudo-likelihood, e(ll), subjects, e(N_sub), failures, e(N_fail)) word see
*MODEL 4.3
stcox  tier1_1 tier1_2 tier1_25 tier1_3  women1  fh_cl1 corrected_regcrim1_1 ratproto2000_1 missinfo8_2 if year>1999, robust
estat phtest, log detail
outreg2 using "kelley_simmons_table4", stnum(replace coef=exp(coef), replace se=coef*se) cti(odds ratio) bdec(3) addstat(Log Pseudo-likelihood, e(ll), subjects, e(N_sub), failures, e(N_fail)) word see
*MODEL 4.4
stcox  inreport1 new_watch3 new_watch2 new_watch1  women1  fh_cl1 corrected_regcrim1_1 ratproto2000_1 missinfo8_2  if year>1999, robust
estat phtest, log detail
outreg2 using "kelley_simmons_table4", stnum(replace coef=exp(coef), replace se=coef*se) cti(odds ratio) bdec(3) addstat(Log Pseudo-likelihood, e(ll), subjects, e(N_sub), failures, e(N_fail)) word see

***************************************************************************8
