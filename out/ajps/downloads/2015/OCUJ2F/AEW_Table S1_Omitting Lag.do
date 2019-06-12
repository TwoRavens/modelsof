/* Table 3 Column 1, Omitting Lag */
tsset cmpcode electnum
gen dparty_all = d.party_all
gen lparty_all = l.party_all
gen abs_dparty_all = abs(dparty_all)
/* generating shift in Chapel Hill experts variable, and rescaling the shift in EMP codings variable (so that it fits on 1-10 scale)  */
gen dches = d.interpolated
replace pro_anti_EU = (.045*(pro_anti_EU))+5.5
replace empchnew = d.pro_anti_EU
/* generating the PM perceived position shift, and putting this observation in for all parties in the country election year */
bysort index: gen d_pmposition_all1 = dparty_all if pm==1
by index: egen pmposition_ch_all = max (d_pmposition_all1)
/* Generating the PM perceived position from the previous election, and inputting this position for all parties in the country election year */
bysort index: gen pmposition_all = lparty_all if pm ==1
by index: egen pmposition_all_t1 = max(pmposition_all)
/* interactions with 'ingovt' */
gen ingovtxpmposition_ch_all = ingovt*pmposition_ch_all
gen ingovtxpmposition_all_t1 = ingovt*pmposition_all_t1


regress dparty_all pmposition_ch_all ingovt ingovtxpmposition_ch_all if pm!=1 & empchnew!=. & d_position_interp!=., cluster(cmpcode)

regress dparty_all pmposition_ch_all ingovt ingovtxpmposition_ch_all empchnew if pm!=1 & empchnew!=. & d_position_interp!=., cluster(cmpcode)

regress dparty_all pmposition_ch_all ingovt ingovtxpmposition_ch_all dches if pm!=1 & empchnew!=. & d_position_interp!=., cluster(cmpcode)
