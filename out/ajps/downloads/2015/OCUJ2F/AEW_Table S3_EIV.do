/* Table 3 Column 1 */
tsset cmpcode electnum
gen dparty_all = d.party_all
gen lparty_all = l.party_all
/* generating Euroshift and CHES shift variables */
gen dches = d.interpolated
/* generating the PM perceived position shift, and putting this observation in for all parties in the country election year */
bysort index: gen d_pmposition_all1 = dparty_all if pm==1
by index: egen pmposition_ch_all = max (d_pmposition_all1)
/* Generating the PM perceived position from the previous election, and inputting this position for all parties in the country election year */
bysort index: gen pmposition_all = lparty_all if pm ==1
by index: egen pmposition_all_t1 = max(pmposition_all)
/* interactions with 'ingovt' */
gen ingovtxpmposition_ch_all = ingovt*pmposition_ch_all
gen ingovtxpmposition_all_t1 = ingovt*pmposition_all_t1



/* 56 observations */

eivreg dparty_all lparty_all pmposition_ch_all ingovt ingovtxpmposition_ch_all if pm!=1 & empchnew!=. & d_position_interp!=., r (lparty_all .9 pmposition_ch_all .9 ingovt 1 ingovtxpmposition_ch_all .9)

eivreg dparty_all lparty_all pmposition_ch_all ingovt ingovtxpmposition_ch_all if pm!=1 & empchnew!=. & d_position_interp!=., r (lparty_all .8 pmposition_ch_all .8 ingovt 1 ingovtxpmposition_ch_all .8)

eivreg dparty_all lparty_all pmposition_ch_all ingovt ingovtxpmposition_ch_all if pm!=1 & empchnew!=. & d_position_interp!=., r (lparty_all .7 pmposition_ch_all .7 ingovt 1 ingovtxpmposition_ch_all .7)


