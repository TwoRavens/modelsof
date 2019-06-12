** set up working environment
set more off

* cd ""

clear


********************************************************************************
** Read and prepare data

insheet using "graphs-tables/cabinet-lm.csv", clear  // read data from R generated ParlGov data
// set scale to -5 to 5 intervall
replace mean_elec = mean_elec - 5
replace mean_parl = mean_parl - 5
replace mean_cab = mean_cab - 5


// keep only countries used in paper -- remove Central/Eastern Europe and Malta
keep if region != 4

label define proportional 0 "Maj." 1 "PR"

capture generate japan = 0
replace japan = 1 if country_name_short=="JPN"

capture generate stv = 0
replace stv = 1 if country_name_short=="MLT" | country_name_short=="IRL"


********************************************************************************
** Models paper -- initial submission

// create zero centred means
capture drop parl_0 cab_0
generate parl_0 = mean_parl - mean_elec
generate cab_0 = mean_cab - mean_parl
generate cab_elec_0 = mean_cab - mean_elec

generate pr_parl_0 = proportional * parl_0

// Fixed effects settings
capture drop country_id_pr
generate country_id_pr = (country_id * 10000) + proportional
xtset country_id_pr


** Main models -- robust standard errors

reg cab_0 left_enp right_enp parl_0 proportional  if japan==0, vce(cluster country_id_pr)
estimates store t3_fu
reg cab_0 left_enp right_enp proportional  if japan==0, vce(cluster country_id_pr)
estimates store t3_fu_nop

// split models -- robust standard errors
reg cab_0 left_enp right_enp parl_0  if proportional==0 & japan==0, vce(cluster country_id_pr)
estimates store t3_maj
reg cab_0 left_enp right_enp parl_0  if proportional==1, vce(cluster country_id_pr)
estimates store t3_pr

// create output table
estimates table t3_fu t3_fu_nop t3_maj t3_pr, b(%7.2f) se(%7.2f) p(%7.2f) stats(N r2_a)
* esttab t3_fu t3_fu_nop t3_maj t3_pr using graphs-tables/models.rtf, b(2) se(2) r2 replace star(* 0.10 ** 0.05 *** 0.01)



** Main models -- case selection (sub-sample)
capture generate swiss = 0
replace swiss = 1 if country_name_short=="CHE"

reg cab_0 left_enp right_enp parl_0 proportional, vce(cluster country_id_pr)
estimates store with_jpn
reg cab_0 left_enp right_enp parl_0 proportional  if japan==0 & stv==0 & swiss==0, vce(cluster country_id_pr)
estimates store t3_stv_che

// split models
reg cab_0 left_enp right_enp parl_0  if proportional==0, vce(cluster country_id_pr)
estimates store maj_with_jpn
reg cab_0 left_enp right_enp parl_0  if proportional==1 & stv==0 & swiss==0, vce(cluster country_id_pr)
estimates store pr_stv_che

// create output table -- case selection (sub-sample) -- Table A3
estimates table with_jpn t3_stv_che maj_with_jpn pr_stv_che, b(%7.2f) se(%7.2f) p(%7.2f) stats(N r2_a)
esttab with_jpn t3_stv_che maj_with_jpn pr_stv_che using graphs-tables/table-a3-subset.rtf, b(2) se(2) r2 replace star(* 0.10 ** 0.05 *** 0.01)



** Main models -- fixed effects

xtreg cab_0 left_enp right_enp parl_0  if japan==0, fe vce(cluster country_id_pr)
estimates store t3_fu_fe
xtreg cab_0 left_enp right_enp parl_0  if japan==0 & stv==0 & swiss==0, fe vce(cluster country_id_pr)
estimates store stv_che
xtreg cab_0 left_enp right_enp  if japan==0, fe vce(cluster country_id_pr)
estimates store fu_nop

// split models 
xtreg cab_0 left_enp right_enp parl_0  if proportional==0 & japan==0, fe vce(cluster country_id_pr)
estimates store maj
xtreg cab_0 left_enp right_enp parl_0  if proportional==1, fe vce(cluster country_id_pr)
estimates store pr

// create output table -- fixed effects -- Table A4
estimates table t3_fu_fe fu_nop maj pr stv_che, b(%7.2f) se(%7.2f) p(%7.2f) stats(N r2_a)
esttab t3_fu_fe fu_nop maj pr stv_che using graphs-tables/table-a4-fe.rtf, b(2) se(2) r2 replace star(* 0.10 ** 0.05 *** 0.01)


** Main models -- random effects

xtreg cab_0 left_enp right_enp parl_0 proportional  if japan==0, re vce(cluster country_id_pr)
estimates store fu
xtreg cab_0 left_enp right_enp parl_0 proportional  if japan==0 & stv==0 & swiss==0, vce(cluster country_id_pr)
estimates store stv_che
xtreg cab_0 left_enp right_enp proportional  if japan==0, re vce(cluster country_id_pr)
estimates store fu_nop

// split models 
xtreg cab_0 left_enp right_enp parl_0  if proportional==0 & japan==0, re vce(cluster country_id_pr)
estimates store maj
xtreg cab_0 left_enp right_enp parl_0  if proportional==1, re vce(cluster country_id_pr)
estimates store pr

// create output table -- random effects
estimates table fu fu_nop maj pr stv_che, b(%7.2f) se(%7.2f) p(%7.2f) stats(N r2_a)
* esttab fu fu_nop maj pr stv_che using graphs-tables/models-re.rtf, b(2) se(2) r2 replace star(* 0.10 ** 0.05 *** 0.01)


** Main models -- CMP data

// zero centred means
capture drop cmp_parl_0 cmp_cab_0
generate cmp_parl_0 = cmp_mean_parl - cmp_mean_elec
generate cmp_cab_0 = cmp_mean_cab - cmp_mean_parl

reg cmp_cab_0 cmp_left_enp cmp_right_enp cmp_parl_0 proportional  if japan==0, vce(cluster country_id_pr)
estimates store fu_cmp
reg cmp_cab_0 cmp_left_enp cmp_right_enp cmp_parl_0 proportional  if japan==0 & stv==0 & swiss==0, vce(cluster country_id_pr)
estimates store stv_che
reg cmp_cab_0 cmp_left_enp cmp_right_enp proportional  if japan==0, vce(cluster country_id_pr)
estimates store nop

// split models 
reg cmp_cab_0 cmp_left_enp cmp_right_enp cmp_parl_0  if japan==0 & proportional==0, vce(cluster country_id_pr)
estimates store maj
reg cmp_cab_0 cmp_left_enp cmp_right_enp cmp_parl_0  if proportional==1, vce(cluster country_id_pr)
estimates store pr

// create output table -- CMP data -- Table A5
estimates table fu_cmp nop maj pr stv_che, b(%7.2f) se(%7.2f) p(%7.2f) stats(N r2_a)
esttab fu_cmp nop maj pr stv_che using graphs-tables/table-a5-cmp.rtf, b(2) se(2) r2 replace star(* 0.10 ** 0.05 *** 0.01)


// create Table 4 paper
estimates table t3_fu t3_fu_nop t3_maj t3_pr t3_stv_che t3_fu_fe, b(%7.2f) se(%7.2f) p(%7.2f) stats(N r2_a)
esttab t3_fu t3_fu_nop t3_maj t3_pr t3_stv_che t3_fu_fe using graphs-tables/table-4-models.rtf, b(2) se(2) r2 replace star(* 0.10 ** 0.05 *** 0.01)


********************************************************************************
*** Additional models -- revisions of paper

capture generate country_id_pr = (country_id * 10000) + proportional

* create running index
capture generate start = date(start_date, "YMD")
format start %td
sort country_name_short start
capture by country_name_short: generate running_no = _n
* running index for elections
capture generate election_no = date(election_date, "YMD")
format election_no %td
sort country_name_short election_no start
capture generate doublette = 0
replace doublette = 1 if election_no == election_no[_n-1]
capture generate election_no1 = election_no if doublette == 0
replace election_no1 = election_no1[_n - 1] if election_no1 >=.

* dropping Japan and cabinet formation during parliamentary term
drop if doublette == 1
drop if country_name_short == "JPN"


** the most simple model
regress mean_elec proportional, vce(cluster country_id_pr)
estimates store m1
regress cmp_mean_elec proportional, vce(cluster country_id_pr)
estimates store m2
regress mean_parl mean_elec proportional, vce(cluster country_id_pr)
estimates store m3
regress cmp_mean_parl cmp_mean_elec proportional, vce(cluster country_id_pr)
estimates store m4
regress mean_elec proportional election_no1, vce(cluster country_id_pr)
estimates store m5
regress mean_parl mean_elec proportional election_no1, vce(cluster country_id_pr)
estimates store m6

estimates table m1 m2 m3 m4, b(%7.2f) se(%7.2f) p(%7.2f) stats(N r2_a)
esttab m1 m2 m3 m4 using graphs-tables/table-2.rtf, b(2) se(2) r2 replace star(* 0.10 ** 0.05 *** 0.01)


* simultaneous equation model (mit ENP; first Parlgov, then CMP)
* reg3 (mean_elec proportional) (mean_parl mean_elec) if country_name_short != "JPN" & doublette != 1
reg3 (mean_parl mean_elec proportional) (mean_cab mean_parl proportional left_enp right_enp) if country_name_short != "JPN" & doublette != 1
estimates store m1
esttab m1 using graphs-tables/table-a2-sem.rtf, b(2) se(2) r2 replace star(* 0.10 ** 0.05 *** 0.01)


