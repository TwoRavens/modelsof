/* Table 4 */
/* "dself_sup_t" is the dependent variable, which is the change in the mean position of the focal party's supporters on European integration at the time of the current EU
election compared to the previous EU election, based on European Election Study (EES) respondents' self-placements. 

"lself_sup" corresponds to the [Party j's supporters' position (t-1)] variable in the text.
"dparty_all" corresponds to the [Party j's perceived shift (t)] variable in the text.  */
tsset cmpcode electnum
gen dself_sup_t = d.self_sup
gen lself_sup = l.self_sup
gen dparty_all = d.party_all
gen lparty_all = l.party_all

/* generating the PM perceived position shift "pmposition_ch_all" called [PM party's position shift (t)] in the text and putting this observation in for all parties in the country election year */
bysort index: gen d_pmposition_all1 = dparty_all if pm==1
by index: egen pmposition_ch_all = max (d_pmposition_all1)

/* interaction with "ingovt", which corresponds to the [Party j is in government (t)] in the text, creating the variable
[PM party's perceived shift (t) x Party j is in government] */

gen ingovtxpmposition_ch_all = ingovt*pmposition_ch_all

/*  Table 4 Column 1 */
regress dself_sup_t lself_sup dparty_all pmposition_ch_all ingovt ingovtxpmposition_ch_all if pm!=1 & empchnew!=. & d_position_interp!=., cluster(cmpcode)
