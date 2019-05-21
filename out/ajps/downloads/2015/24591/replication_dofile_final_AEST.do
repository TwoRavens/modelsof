** Main Tables in the Main Text**

* Table 2 column 1
reg party_ch_all_voters_t emp_ch1_10 if toofew!=1 & interpolated_expert_ch1_10!=., cluster(cmpcode)

* Table 2 column 2
reg party_ch_all_voters_t interpolated_expert_ch1_10 if toofew!=1 & emp_ch1_10!=., cluster(cmpcode)

* Table 2 column 3
reg party_ch_all_voters_t emp_ch1_10 interpolated_expert_ch1_10 if toofew!=1, cluster(cmpcode)

* Table 3 column 1
reg party_ch_supporters_t emp_ch1_10 interpolated_expert_ch1_10 if toofew!=1, cluster(cmpcode)

* Table 3 column 2
reg party_others_ch  emp_ch1_10 interpolated_expert_ch1_10 if toofew!=1, cluster(cmpcode)

* Table 3 column 3
reg party_ind_ch emp_ch1_10 interpolated_expert_ch1_10 if toofew!=1, cluster(cmpcode)

* Table 4
reg self_supp_ch_t self_supp_ch_t1 emp_ch1_10 emp_ch2_10 interpolated_expert_ch1_10 interpolated_expert_ch2_10 if toofew!=1, cluster(cmpcode)


* Table 1 summary measures 
sum interpolated_expert_ch1_10 abs_interp_expert_ch emp_ch1_10 abs_epmch party_ch_all_voters_t abs_party_all_ch if toofew!=1 & emp_ch1_10!=. & interpolated_expert_ch1_10!=. & party_ch_all_voters_t!=.


****** Additional Models for the Supporting Information Document *****

* TABLE A2: Including Small Parties
reg party_ch_all_voters_t emp_ch1_10 if interpolated_expert_ch1_10!=., cluster(cmpcode)
reg party_ch_all_voters_t interpolated_expert_ch1_10 if emp_ch1_10!=., cluster(cmpcode)
reg party_ch_all_voters_t emp_ch1_10 interpolated_expert_ch1_10, cluster(cmpcode)

* Outlier tests
hist emp_ch1_10 if party_ch_all_voters_t!=. & interpolated_expert_ch1_10!=. & toofew!=1, xtitle("Euromanifesto Shift")
hist interpolated_expert_ch1_10 if party_ch_all_voters_t!=. & emp_ch1_10!=. & toofew!=1, xtitle("Expert Shift")

* TABLE A3.1
reg party_ch_all_voters_t emp_ch1_10 if toofew!=1 & interpolated_expert_ch1_10!=. & emp_ch1<29, cluster(cmpcode)
reg party_ch_all_voters_t interpolated_expert_ch1_10 if toofew!=1 & emp_ch1_10!=.& emp_ch1<29, cluster(cmpcode)
reg party_ch_all_voters_t emp_ch1_10 interpolated_expert_ch1_10 if toofew!=1& emp_ch1<29, cluster(cmpcode)
* TABLE A3.2
reg party_ch_all_voters_t emp_ch1_10 if toofew!=1 & interpolated_expert_ch1_10!=. & emp_ch1 <29 & emp_ch1>-23, cluster(cmpcode)
reg party_ch_all_voters_t interpolated_expert_ch1_10 if toofew!=1 & emp_ch1_10!=.& emp_ch1 <29 & emp_ch1>-23, cluster(cmpcode)
reg party_ch_all_voters_t emp_ch1_10 interpolated_expert_ch1_10 if toofew!=1& emp_ch1 <29 & emp_ch1>-23, cluster(cmpcode)

* TABLE A4.1
reg party_ch_all_voters_t emp_ch1_10 if toofew!=1 & interpolated_expert_ch1_10!=. & interpolated_expert_ch1<1.26, cluster(cmpcode)
reg party_ch_all_voters_t interpolated_expert_ch1_10 if toofew!=1 & emp_ch1_10!=.& interpolated_expert_ch1 <1.26, cluster(cmpcode)
reg party_ch_all_voters_t emp_ch1_10 interpolated_expert_ch1_10 if toofew!=1& interpolated_expert_ch1 <1.26, cluster(cmpcode)
* TABLE A4.2
reg party_ch_all_voters_t emp_ch1_10 if toofew!=1 & interpolated_expert_ch1_10!=. & interpolated_expert_ch1 <1.26 & interpolated_expert_ch1_10>-1.25, cluster(cmpcode)
reg party_ch_all_voters_t interpolated_expert_ch1_10 if toofew!=1 & emp_ch1_10!=.& interpolated_expert_ch1 <1.26 & interpolated_expert_ch1_10>-1.25, cluster(cmpcode)
reg party_ch_all_voters_t emp_ch1_10 interpolated_expert_ch1_10 if toofew!=1& interpolated_expert_ch1 <1.26 & interpolated_expert_ch1_10>-1.25, cluster(cmpcode)

* TABLE A5: country fixed effects
reg party_ch_all_voters_t emp_ch1_10 i.ccode if toofew!=1 & interpolated_expert_ch1_10!=., cluster(cmpcode)
reg party_ch_all_voters_t interpolated_expert_ch1_10 i.ccode if toofew!=1 & emp_ch1_10!=., cluster(cmpcode)
reg party_ch_all_voters_t emp_ch1_10 interpolated_expert_ch1_10 i.ccode if toofew!=1, cluster(cmpcode)

* TABLE A6: Effects of Errors
eivreg party_ch_all_voters_t emp_ch1_10 interpolated_expert_ch1_10 if toofew!=1, r(emp_ch1_10 .9 interpolated_expert_ch1_10 .9)
eivreg party_ch_all_voters_t emp_ch1_10 interpolated_expert_ch1_10 if toofew!=1, r(emp_ch1_10 .8 interpolated_expert_ch1_10 .8)
eivreg party_ch_all_voters_t emp_ch1_10 interpolated_expert_ch1_10 if toofew!=1, r(emp_ch1_10 .7 interpolated_expert_ch1_10 .7)
eivreg party_ch_all_voters_t emp_ch1_10 interpolated_expert_ch1_10 if toofew!=1, r(emp_ch1_10 .6 interpolated_expert_ch1_10 .6)

* TABLE A7 WILL COME LATER IGNORE IT FOR NOW 
* Partisan Sorting with EB data


* TABLE A8: ERM Models

reg party_ch_all_voters_t  party_all_t1 emp_ch1_10 emp_posit_t1_10 interpolated_expert_ch1_10 interpolated_expert_t1_10 if toofew!=1, cluster(cmpcode)
reg party_ch_supporters_t party_supp_t1 emp_ch1_10 emp_posit_t1_10 interpolated_expert_ch1_10 interpolated_expert_t1_10 if toofew!=1, cluster(cmpcode)
reg party_others_ch party_oth_t1 emp_ch1_10 emp_posit_t1_10 interpolated_expert_ch1_10 interpolated_expert_t1_10 if toofew!=1, cluster(cmpcode)
reg party_ind_ch party_ind_t1 emp_ch1_10 emp_posit_t1_10 interpolated_expert_ch1_10 interpolated_expert_t1_10 if toofew!=1, cluster(cmpcode)
reg self_supp_ch_t self_supp_t1 emp_ch1_10 emp_posit_t1_10 interpolated_expert_ch1_10 interpolated_expert_t1_10 if toofew!=1, cluster(cmpcode)


* TABLE A9: 
* govt vs. opp parties
reg party_ch_all_voters_t emp_ch1_10 interpolated_expert_ch1_10 ingovt if toofew!=1, cluster(cmpcode)
gen ingovt_emp_ch1_10=ingovt*emp_ch1_10
gen ingovt_dpositinterp=ingovt* interpolated_expert_ch1_10
reg party_ch_all_voters_t emp_ch1_10 interpolated_expert_ch1_10 ingovt ingovt_emp_ch1_10 ingovt_dpositinterp if toofew!=1, cluster(cmpcode)
* party_size
reg party_ch_all_voters_t emp_ch1_10 interpolated_expert_ch1_10 vote if toofew!=1, cluster(cmpcode)
gen vote_emp_ch1_10= vote*emp_ch1_10
gen vote_dpositinterp= vote* interpolated_expert_ch1_10
reg party_ch_all_voters_t emp_ch1_10 interpolated_expert_ch1_10 vote vote_emp_ch1_10 vote_dpositinterp if toofew!=1, cluster(cmpcode)


* TABLE A10:
* greens
reg party_ch_all_voters_t emp_ch1_10 interpolated_expert_ch1_10 greens if toofew!=1, cluster(cmpcode)
gen greens_emp_ch1_10=greens*emp_ch1_10
gen greens_dpositinterp=greens* interpolated_expert_ch1_10
reg party_ch_all_voters_t emp_ch1_10 interpolated_expert_ch1_10 greens greens_emp_ch1_10 greens_dpositinterp if toofew!=1, cluster(cmpcode)
* anti-EU: using anti-eu which coded 1 if interpolated expert position and t1 are lower than 4.0000001 
reg party_ch_all_voters_t emp_ch1_10 interpolated_expert_ch1_10 anti_eu if toofew!=1, cluster(cmpcode)
gen anti_eu_emp_ch1_10= anti_eu*emp_ch1_10
gen anti_eu_dpositinterp= anti_eu* interpolated_expert_ch1_10
reg party_ch_all_voters_t emp_ch1_10 interpolated_expert_ch1_10 anti_eu anti_eu_emp_ch1_10 anti_eu_dpositinterp if toofew!=1, cluster(cmpcode)

* TABLE A11:
** extremism **
* 1. extremism of expert eu positions
reg party_ch_all_voters_t emp_ch1_10 interpolated_expert_ch1_10 extremism_expert if toofew!=1, cluster(cmpcode)
gen extremism_expert_emp_ch1_10= extremism_expert*emp_ch1_10
gen extremism_expert_dpositinterp= extremism_expert* interpolated_expert_ch1_10
reg party_ch_all_voters_t emp_ch1_10 interpolated_expert_ch1_10 extremism_expert extremism_expert_emp_ch1_10 extremism_expert_dpositinterp if toofew!=1, cluster(cmpcode)
* 2. extremism on the l-r scale of the cmp
reg party_ch_all_voters_t emp_ch1_10 interpolated_expert_ch1_10 extremism_cmp_lr if toofew!=1, cluster(cmpcode)
gen extremism_cmplr_emp_ch1_10= extremism_cmp_lr*emp_ch1_10
gen extremism_cmplr_dpositinterp= extremism_cmp_lr* interpolated_expert_ch1_10
reg party_ch_all_voters_t emp_ch1_10 interpolated_expert_ch1_10 extremism_cmp_lr extremism_cmplr_emp_ch1_10 extremism_cmplr_dpositinterp if toofew!=1, cluster(cmpcode)


* TABLE A12: Table 4 main model without LDV and with levels
reg self_supp_ch_t emp_ch1_10 emp_ch2_10 interpolated_expert_ch1_10 interpolated_expert_ch2_10 if toofew!=1, cluster(cmpcode)
reg self_sup self_supp_t1 emp_posit_t_10 emp_posit_t1_10 interpolated_expert_10 interpolated_expert_t1_10 if toofew!=1, cluster(cmpcode)


* TABLE A13 WILL COME LATER. SKIP IT FOR NOW

* TABLE A14: Analyses based on Parties' National Election Manifestos
reg party_ch_all_voters_t cmp_eu_ratio_ch1 interpolated_expert_ch1_10 if toofew!=1, cluster(cmpcode)
reg party_ch_supporters_t cmp_eu_ratio_ch1 interpolated_expert_ch1_10 if toofew!=1, cluster(cmpcode)
reg party_others_ch  cmp_eu_ratio_ch1 interpolated_expert_ch1_10 if toofew!=1, cluster(cmpcode)
reg party_ind_ch cmp_eu_ratio_ch1 interpolated_expert_ch1_10 if toofew!=1, cluster(cmpcode)
reg self_supp_ch_t self_supp_ch_t1 cmp_eu_ratio_ch1 cmp_eu_ratio_ch2 interpolated_expert_ch1_10 interpolated_expert_ch2_10 if toofew!=1, cluster(cmpcode)


**** generating the z-score transformations*****
bysort ccode: egen mean_emp_eu=mean(emp_posit_t)
bysort ccode: egen stdev_emp_eu=sd(emp_posit_t)
bysort ccode: egen mean_emp_eu_t1=mean(emp_posit_t1)
bysort ccode: egen stdev_emp_eu_t1=sd(emp_posit_t1)
bysort ccode: egen mean_emp_eu_t2=mean(emp_posit_t2)
bysort ccode: egen stdev_emp_eu_t2=sd(emp_posit_t2)

bysort ccode: egen mean_partyall=mean(party_all)
bysort ccode: egen stdev_partyall=sd(party_all)
bysort ccode: egen mean_partyall_t1=mean(party_all_t1)
bysort ccode: egen stdev_partyall_t1=sd(party_all_t1)

bysort ccode: egen mean_expert_int=mean(interpolated_expert)
bysort ccode: egen stdev_expert_int=sd(interpolated_expert)
bysort ccode: egen mean_expertint_t1=mean(interpolated_expert_t1)
bysort ccode: egen stdev_expertint_t1=sd(interpolated_expert_t1)
bysort ccode: egen mean_expertint_t2=mean(interpolated_expert_t2)
bysort ccode: egen stdev_expertint_t2=sd(interpolated_expert_t2)

bysort ccode: egen mean_partysupp=mean(party_sup)
bysort ccode: egen stdev_partysupp=sd(party_sup)
bysort ccode: egen mean_partysupp_t1=mean(party_supp_t1)
bysort ccode: egen stdev_partysupp_t1=sd(party_supp_t1)
bysort ccode: egen mean_partyoth=mean(party_oth)
bysort ccode: egen stdev_partyoth=sd(party_oth)
bysort ccode: egen mean_partyoth_t1=mean(party_oth_t1)
bysort ccode: egen stdev_partyoth_t1=sd(party_oth_t1)
bysort ccode: egen mean_partyind=mean(party_ind)
bysort ccode: egen stdev_partyind=sd(party_ind)
bysort ccode: egen mean_partyind_t1=mean(party_ind_t1)
bysort ccode: egen stdev_partyind_t1=sd(party_ind_t1)

bysort ccode: egen mean_selfsupp=mean(self_sup)
bysort ccode: egen stdev_selfsupp=sd(self_sup)
bysort ccode: egen mean_selfsupp_t1=mean(self_supp_t1)
bysort ccode: egen stdev_selfsupp_t1=sd(self_supp_t1)
bysort ccode: egen mean_selfsupp_t2=mean(self_supp_t2)
bysort ccode: egen stdev_selfsupp_t2=sd(self_supp_t2)

gen sd_emp_eu=(emp_posit_t-mean_emp_eu)/stdev_emp_eu
gen sd_emp_eu_t1=(emp_posit_t1-mean_emp_eu_t1)/stdev_emp_eu_t1
gen sd_emp_eu_t2=(emp_posit_t2-mean_emp_eu_t2)/stdev_emp_eu_t2
gen sd_partyall=(party_all-mean_partyall)/stdev_partyall
gen sd_partyall_t1=(party_all_t1-mean_partyall_t1)/stdev_partyall_t1
gen sd_expert=(interpolated_expert-mean_expert_int)/stdev_expert_int
gen sd_expert_t1=(interpolated_expert_t1-mean_expertint_t1)/stdev_expertint_t1
gen sd_expert_t2=(interpolated_expert_t2-mean_expertint_t2)/stdev_expertint_t2
gen sd_partysupp=(party_sup-mean_partysupp)/stdev_partysupp
gen sd_partysupp_t1=(party_supp_t1-mean_partysupp_t1)/stdev_partysupp_t1
gen sd_partyoth=(party_oth-mean_partyoth)/stdev_partyoth
gen sd_partyoth_t1=(party_oth_t1-mean_partyoth_t1)/stdev_partyoth_t1
gen sd_partyind=(party_ind-mean_partyind)/stdev_partyind
gen sd_partyind_t1=(party_ind_t1-mean_partyind_t1)/stdev_partyind_t1
gen sd_selfsupp=(self_sup-mean_selfsupp)/stdev_selfsupp
gen sd_selfsupp_t1=(self_supp_t1-mean_selfsupp_t1)/stdev_selfsupp_t1
gen sd_selfsupp_t2=(self_supp_t2-mean_selfsupp_t2)/stdev_selfsupp_t2
gen sd_emp_eu_ch1_n= sd_emp_eu-sd_emp_eu_t1
gen sd_emp_eu_ch2_n= sd_emp_eu_t1-sd_emp_eu_t2
gen sd_expert_ch1_n= sd_expert-sd_expert_t1
gen sd_expert_ch2_n= sd_expert_t1-sd_expert_t2
gen sd_partyall_ch1_n= sd_partyall-sd_partyall_t1
gen sd_partysupp_ch1_n= sd_partysupp-sd_partysupp_t1
gen sd_partyoth_ch1_n= sd_partyoth-sd_partyoth_t1
gen sd_partyind_ch1_n= sd_partyind-sd_partyind_t1
gen sd_selfsupp_ch1_n= sd_selfsupp-sd_selfsupp_t1
gen sd_selfsupp_ch2_n= sd_selfsupp_t1-sd_selfsupp_t2

* TABLE A15
* Analyses based on the z-transformed variables
reg sd_partyall_ch1_n sd_emp_eu_ch1_n sd_expert_ch1_n if toofew!=1, cluster(cmpcode)
reg sd_partysupp_ch1_n sd_emp_eu_ch1_n sd_expert_ch1_n if toofew!=1, cluster(cmpcode)
reg sd_partyoth_ch1_n  sd_emp_eu_ch1_n sd_expert_ch1_n if toofew!=1, cluster(cmpcode)
reg sd_partyind_ch1_n sd_emp_eu_ch1_n sd_expert_ch1_n if toofew!=1, cluster(cmpcode)
reg sd_selfsupp_ch1_n sd_selfsupp_ch2 sd_emp_eu_ch1 sd_emp_eu_ch2 sd_expert_ch1 sd_expert_ch2 if toofew!=1, cluster(cmpcode)



