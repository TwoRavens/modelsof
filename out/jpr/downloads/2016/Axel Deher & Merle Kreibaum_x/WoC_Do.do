****************************************************************************
* Replication Material of "Weapon of Choice" by Dreher and Kreibaum (2016) *
****************************************************************************

cd ""
use "WoC_Data.dta", clear

expand 3
sort orgid year
egen mode=fill(0 1 2 0 1 2)
gen chosen_terr=1 if mode==strat_terror
gen chosen_vio=1 if mode==strat_vio
replace chosen_ter=0 if chosen_ter==. & strat_terr!=.
replace chosen_vio=0 if chosen_vio==. & strat_vio!=.

egen group=group(orgid year)

tab mode, gen(mode)
eq mode0: mode1
eq mode1: mode2
eq mode2: mode3

tab mergec, gen(country)


* REPLICATE TABLE I: Reduced form and full models without interaction effects

* Reduced form

gllamm mode ln_oil_group_lag ln_oil_nat_lag, ///
	expand(group chosen_ter m) i(orgid) lin(mlogit) family(binom) basecategory(0) eqs(mode1 mode2) nrf(2) nip(12) adapt eform cluster(orgid)

* Add group level indicators

gllamm mode ln_oil_group_lag ln_oil_nat_lag goal1_lag goal2_lag econgoal_l cultgoal_l forstsup_lag relextrem_lag viorepression_lag negotiations_lag socservice_lag, ///
	expand(group chosen_ter m) i(orgid) lin(mlogit) family(binom) basecategory(0) eqs(mode1 mode2) nrf(2) nip(12) adapt eform cluster(orgid)

* Full model with FH

gllamm mode ln_oil_group_lag ln_oil_nat_lag goal1_lag econgoal_l cultgoal_l forstsup_lag relextrem_lag viorepression_lag negotiations_lag goal2_lag socservice_lag ///
	ln_GDP_lag ln_pop_lag fh_dem_lag elf_lag, ///
	expand(group chosen_ter m) i(orgid) lin(mlogit) family(binom) basecategory(0) eqs(mode1 mode2) nrf(2) nip(12) adapt eform cluster(orgid)

* Save estimates of odds ratios as starting point for models with interaction terms

mat a=e(b)

* Test for equality of odds ratios in the full model

test _b[c1:ln_oil_group_lag] = _b[c2:ln_oil_group_lag] 
test _b[c1:ln_oil_nat_lag] = _b[c2:ln_oil_nat_lag] 
test _b[c1:goal1_lag] = _b[c2:goal1_lag] 
test _b[c1:econgoal_lag] = _b[c2:econgoal_lag] 
test _b[c1:cultgoal_lag] = _b[c2:cultgoal_lag] 
test _b[c1:forstsup_lag] = _b[c2:forstsup_lag] 
test _b[c1:relextrem_lag] = _b[c2:relextrem_lag] 
test _b[c1:viorepression_lag] = _b[c2:viorepression_lag] 
test _b[c1:negotiations_lag] = _b[c2:negotiations_lag] 
test _b[c1:goal2_lag] = _b[c2:goal2_lag] 
test _b[c1:socservice_lag] = _b[c2:socservice_lag] 
test _b[c1:ln_GDP_lag] = _b[c2:ln_GDP_lag] 
test _b[c1:ln_pop_lag] = _b[c2:ln_pop_lag] 
test _b[c1:fh_dem_lag] = _b[c2:fh_dem_lag] 
test _b[c1:elf_lag] = _b[c2:elf_lag]


	
* REPLICATE TABLE II: Political participation

* Political discrimination

gen inter_poldis= ln_oil_group_lag*poldis_lag

gllamm mode ln_oil_group_lag ln_oil_nat_lag poldis_lag inter_poldis goal1_lag econgoal_l cultgoal_l forstsup_lag relextrem_lag viorepression_lag negotiations_lag goal2_lag socservice_lag ///
	ln_GDP_lag ln_pop_lag fh_dem_lag elf_lag, ///
	expand(group chosen_ter m) i(orgid) lin(mlogit) family(binom) basecategory(0) eqs(mode1 mode2) nrf(2) nip(12) adapt eform cluster(orgid) from(a) skip

test _b[c1:inter_poldis] = _b[c2:inter_poldis]

* Power sharing

gen inter_power= ln_oil_group_lag*eprpowersharing_lag

gllamm mode ln_oil_group_lag ln_oil_nat_lag inter_power eprpowersharing_lag goal1_lag econgoal_l cultgoal_l forstsup_lag relextrem_lag viorepression_lag negotiations_lag goal2_lag socservice_lag ///
	ln_GDP_lag ln_pop_lag fh_dem_lag elf_lag, ///
	expand(group chosen_ter m) i(orgid) lin(mlogit) family(binom) basecategory(0) eqs(mode1 mode2) nrf(2) nip(12) adapt eform cluster(orgid) from(a) skip

test _b[c1:inter_power] = _b[c2:inter_power]



* REPLICATE TABLE III: Autonomy and economic discrimination

* Regional autonomy

gen inter_auto= ln_oil_group_lag*eprautonomy_lag

gllamm mode ln_oil_group_lag ln_oil_nat_lag inter_auto eprautonomy_lag goal1_lag econgoal_l cultgoal_l forstsup_lag relextrem_lag viorepression_lag negotiations_lag goal2_lag socservice_lag ///
	ln_GDP_lag ln_pop_lag fh_dem_lag elf_lag, ///
	expand(group chosen_ter m) i(orgid) lin(mlogit) family(binom) basecategory(0) eqs(mode1 mode2) nrf(2) nip(12) adapt eform cluster(orgid) from(a) skip

test _b[c1:inter_auto] = _b[c2:inter_auto]

* Economic discrimination

gen inter_ecdis= ln_oil_group_lag*ecdis_lag

gllamm mode ln_oil_group_lag ln_oil_nat_lag ecdis_lag inter_ecdis goal1_lag econgoal_l cultgoal_l forstsup_lag relextrem_lag viorepression_lag negotiations_lag goal2_lag socservice_lag ///
	ln_GDP_lag ln_pop_lag fh_dem_lag elf_lag, ///
	expand(group chosen_ter m) i(orgid) lin(mlogit) family(binom) basecategory(0) eqs(mode1 mode2) nrf(2) nip(12) adapt eform cluster(orgid) from(a) skip

test _b[c1:inter_ecdis] = _b[c2:inter_ecdis]



* REPLICATE TABLE IV: Support by foreign state

gen inter_forstsup= ln_oil_group_lag*forstsup_lag

gllamm mode ln_oil_group_lag ln_oil_nat_lag inter_forstsup goal1_lag econgoal_l cultgoal_l forstsup_lag relextrem_lag viorepression_lag negotiations_lag goal2_lag socservice_lag ///
	ln_GDP_lag ln_pop_lag fh_dem_lag elf_lag, ///
	expand(group chosen_ter m) i(orgid) lin(mlogit) family(binom) basecategory(0) eqs(mode1 mode2) nrf(2) nip(12) adapt eform cluster(orgid) from(a) skip

test _b[c1:inter_forstsup] = _b[c2:inter_forstsup]



**************************************
* Replication of the online appendix *
**************************************

* REPLICATE APPENDIX D: Alternative oil measure

gllamm mode oil_gas_fields ln_oil_nat_lag goal1_lag econgoal_l cultgoal_l forstsup_lag relextrem_lag viorepression_lag negotiations_lag goal2_lag socservice_lag ///
	ln_GDP_lag ln_pop_lag fh_dem_lag elf_lag, ///
	expand(group chosen_ter m) i(orgid) lin(mlogit) family(binom) basecategory(0) eqs(mode1 mode2) nrf(2) nip(12) adapt eform cluster(orgid)
	
test _b[c1:oil_gas_fields] = _b[c2:oil_gas_fields] 
test _b[c1:ln_oil_nat_lag] = _b[c2:ln_oil_nat_lag] 
test _b[c1:goal1_lag] = _b[c2:goal1_lag] 
test _b[c1:econgoal_lag] = _b[c2:econgoal_lag] 
test _b[c1:cultgoal_lag] = _b[c2:cultgoal_lag] 
test _b[c1:forstsup_lag] = _b[c2:forstsup_lag] 
test _b[c1:relextrem_lag] = _b[c2:relextrem_lag] 
test _b[c1:viorepression_lag] = _b[c2:viorepression_lag]
test _b[c1:negotiations_lag] = _b[c2:negotiations_lag] 
test _b[c1:goal2_lag] = _b[c2:goal2_lag] 
test _b[c1:socservice_lag] = _b[c2:socservice_lag]  
test _b[c1:ln_GDP_lag] = _b[c2:ln_GDP_lag] 
test _b[c1:ln_pop_lag] = _b[c2:ln_pop_lag] 
test _b[c1:fh_dem_lag] = _b[c2:fh_dem_lag] 
test _b[c1:elf_lag] = _b[c2:elf_lag] 
	
mat b=e(b)


* Political discrimination

gen inter_poldis2= oil_gas_fields*poldis_lag

gllamm mode oil_gas_fields ln_oil_nat_lag poldis_lag inter_poldis2 goal1_lag econgoal_l cultgoal_l forstsup_lag relextrem_lag viorepression_lag negotiations_lag goal2_lag socservice_lag ///
	ln_GDP_lag ln_pop_lag fh_dem_lag elf_lag, ///
	expand(group chosen_ter m) i(orgid) lin(mlogit) family(binom) basecategory(0) eqs(mode1 mode2) nrf(2) nip(12) adapt eform cluster(orgid) from(b) skip

test _b[c1:inter_poldis2] = _b[c2:inter_poldis2]


* Power sharing

gen inter_power2= oil_gas_fields*eprpowersharing_lag

gllamm mode oil_gas_fields ln_oil_nat_lag inter_power2 eprpowersharing_lag goal1_lag econgoal_l cultgoal_l forstsup_lag relextrem_lag viorepression_lag negotiations_lag goal2_lag socservice_lag ///
	ln_GDP_lag ln_pop_lag fh_dem_lag elf_lag, ///
	expand(group chosen_ter m) i(orgid) lin(mlogit) family(binom) basecategory(0) eqs(mode1 mode2) nrf(2) nip(12) adapt eform cluster(orgid) from(b) skip

test _b[c1:inter_power2] = _b[c2:inter_power2]


* Regional autonomy

gen inter_auto2= oil_gas_fields*eprautonomy_lag

gllamm mode oil_gas_fields ln_oil_nat_lag inter_auto2 eprautonomy_lag goal1_lag econgoal_l cultgoal_l forstsup_lag relextrem_lag viorepression_lag negotiations_lag goal2_lag socservice_lag ///
	ln_GDP_lag ln_pop_lag fh_dem_lag elf_lag, ///
	expand(group chosen_ter m) i(orgid) lin(mlogit) family(binom) basecategory(0) eqs(mode1 mode2) nrf(2) nip(12) adapt eform cluster(orgid) from(b) skip

test _b[c1:inter_auto2] = _b[c2:inter_auto2]


* Economic discrimination

gen inter_ecdis2= oil_gas_fields*ecdis_lag

gllamm mode oil_gas_fields ln_oil_nat_lag ecdis_lag inter_ecdis2 goal1_lag econgoal_l cultgoal_l forstsup_lag relextrem_lag viorepression_lag negotiations_lag goal2_lag socservice_lag ///
	ln_GDP_lag ln_pop_lag fh_dem_lag elf_lag, ///
	expand(group chosen_ter m) i(orgid) lin(mlogit) family(binom) basecategory(0) eqs(mode1 mode2) nrf(2) nip(12) adapt eform cluster(orgid) from(b) skip

test _b[c1:inter_ecdis2] = _b[c2:inter_ecdis2]


* Foreign state support

gen inter_forstsup2= oil_gas_fields*forstsup_lag

gllamm mode oil_gas_fields ln_oil_nat_lag inter_forstsup2 goal1_lag econgoal_l cultgoal_l forstsup_lag relextrem_lag viorepression_lag negotiations_lag goal2_lag socservice_lag ///
	ln_GDP_lag ln_pop_lag fh_dem_lag elf_lag, ///
	expand(group chosen_ter m) i(orgid) lin(mlogit) family(binom) basecategory(0) eqs(mode1 mode2) nrf(2) nip(12) adapt eform cluster(orgid) from(b) skip

test _b[c1:inter_forstsup2] = _b[c2:inter_forstsup2]



* REPLICATE APPENDIX E: Alternative specifications/ covariates

* Cluster at country level

preserve

replace mergec="West Bank/Gaza" if ((orgid>6660300 & orgid<6660308) | orgid==6660312) & year<1994
encode mergec, gen(countryno)

gllamm mode ln_oil_group_lag ln_oil_nat_lag goal1_lag econgoal_l cultgoal_l forstsup_lag relextrem_lag viorepression_lag negotiations_lag goal2_lag socservice_lag ///
	ln_GDP_lag ln_pop_lag fh_dem_lag elf_lag, ///
	expand(group chosen_ter m) i(orgid) lin(mlogit) family(binom) basecategory(0) eqs(mode1 mode2) nrf(2) nip(12) adapt eform cluster(countryno) from(a) skip

restore



* Polity Instead of FH

preserve
keep if mergec!="West Bank/Gaza"

gllamm mode ln_oil_group_lag ln_oil_nat_lag goal1_lag econgoal_l cultgoal_l forstsup_lag relextrem_lag viorepression_lag negotiations_lag goal2_lag socservice_lag ///
	ln_GDP_lag ln_pop_lag polity2_lag elf_lag, ///
	expand(group chosen_ter m) i(orgid) lin(mlogit) family(binom) basecategory(0) eqs(mode1 mode2) nrf(2) nip(12) adapt eform cluster(orgid) from(a) skip

restore



* Polarisation instead of fractionalisation

set more off

gllamm mode ln_oil_group_lag ln_oil_nat_lag goal1_lag econgoal_l cultgoal_l forstsup_lag relextrem_lag viorepression_lag negotiations_lag goal2_lag socservice_lag ///
	ln_GDP_lag ln_pop_lag fh_dem_lag ETHPOL, ///
	expand(group chosen_ter m) i(orgid) lin(mlogit) family(binom) basecategory(0) eqs(mode1 mode2) nrf(2) nip(12) adapt eform cluster(orgid) from(a) skip
	