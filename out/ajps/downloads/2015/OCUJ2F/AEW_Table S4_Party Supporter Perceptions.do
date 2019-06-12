/* Table 3 Column 1 */
tsset cmpcode electnum
gen dparty_sup = d.party_sup
gen lparty_sup = l.party_sup
/* generating shift in Chapel Hill experts variable, and rescaling the shift in EMP codings variable (so that it fits on 1-10 scale)  */
gen dches = d.interpolated
replace pro_anti_EU = (.045*(pro_anti_EU))+5.5
replace empchnew = d.pro_anti_EU
/* generating the PM perceived position shift, and putting this observation in for all parties in the country election year */
bysort index: gen d_pmposition_sup1 = dparty_sup if pm==1
by index: egen pmposition_ch_sup = max (d_pmposition_sup1)
/* Generating the PM perceived position from the previous election, and inputting this position for all parties in the country election year */
bysort index: gen pmposition_sup = lparty_sup if pm ==1
by index: egen pmposition_sup_t1 = max(pmposition_sup)
/* interactions with 'ingovt' */
gen ingovtxpmposition_ch_sup = ingovt*pmposition_ch_sup
gen ingovtxpmposition_sup_t1 = ingovt*pmposition_sup_t1

/* 56 observations, and goes with Table 3 models, first model below is Table S4 Model 1 (Table S4 Model 2 estimates are from Table 3 Model 1 in the article) */

regress dparty_sup lparty_sup pmposition_ch_sup ingovt ingovtxpmposition_ch_sup if pm!=1 & empchnew!=. & d_position_interp!=., cluster(cmpcode)

