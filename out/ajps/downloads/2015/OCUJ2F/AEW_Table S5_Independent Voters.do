/* Table S5 */
tsset cmpcode electnum
gen dself_sup_t = d.self_sup
gen lself_sup = l.self_sup
gen dparty_all = d.party_all
gen lparty_all = l.party_all
gen dparty_ind = d.party_ind

/* Generating the PM perceived position based on all voters from the previous election, and inputting this position for all parties in the country election year */
bysort index: gen pmposition_all = lparty_all if pm ==1
by index: egen pmposition_all_t1 = max(pmposition_all)
/* generating the PM perceived position shift based on all voters, and putting this observation in for all parties in the country election year */
bysort index: gen d_pmposition_all1 = dparty_all if pm==1
by index: egen pmposition_ch_all = max (d_pmposition_all1)

/* VARIABLES BASED ON INDEPENDENT VOTERS */
bysort index: gen d_pmposition_ind1 = dparty_ind if pm==1
by index: egen pmposition_ch_ind = max (d_pmposition_ind1)
gen ingovtxpmposition_ch_ind = ingovt*pmposition_ch_ind

/* interactions with 'ingovt' */
gen ingovtxpmposition_ch_all = ingovt*pmposition_ch_all
gen ingovtxpmposition_all_t1 = ingovt*pmposition_all_t1

/* Regressions based on perceptions of party position of INDEPENDENT voters */
regress dself_sup_t lself_sup dparty_ind pmposition_ch_ind ingovt ingovtxpmposition_ch_ind if pm!=1 & empchnew!=. & d_position_interp!=., cluster(cmpcode)
