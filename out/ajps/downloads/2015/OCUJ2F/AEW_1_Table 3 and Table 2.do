/* Table 3 */
use AEW_The Company You Keep.dta, clear

/* The "tsset" command sets the panel (parties "cmpcode") and time (elections ("electnum") for the dataset.
"dparty_all" is the dependent variable which is the change in the focal party's perceived position on European integration at the time of the current European Parliamentary election 
compared to the previous election. 
"lparty_all" is the variable in Table 3: [Party j's perceived position (t-1) */

tsset cmpcode electnum
gen dparty_all = d.party_all
gen lparty_all = l.party_all

/* For Columns 2 and 3, rescaling the Euromanifesto data so that it fits on 1-10 scale, using the Equation in footnote 9 of the article, and then creating
the "empchnew" variable which corresponds to the [Party j's shift (t) - EMP codings] variable in the text.  
Generating shift in Chapel Hill Expert Survey "dches" variable, which corresponds to the [Party j's shift (t) - Chapel Hill experts] variable in the text.   */

replace pro_anti_EU = (.045*(pro_anti_EU))+5.5
replace empchnew = d.pro_anti_EU
gen dches = d.interpolated


/* generating the PM perceived position shift "pmposition_ch_all" called [PM party's position shift (t)] in the text and putting this observation in for all parties in the country election year */
bysort index: gen d_pmposition_all1 = dparty_all if pm==1
by index: egen pmposition_ch_all = max (d_pmposition_all1)

/* interaction with "ingovt", which corresponds to the [Party j is in government (t)] in the text, creating the variable
[PM party's perceived shift (t) x Party j is in government] */

gen ingovtxpmposition_ch_all = ingovt*pmposition_ch_all

/* Table 3, Models 1-3 */
regress dparty_all lparty_all pmposition_ch_all ingovt ingovtxpmposition_ch_all if pm!=1 & empchnew!=. & d_position_interp!=., cluster(cmpcode)
regress dparty_all lparty_all pmposition_ch_all ingovt ingovtxpmposition_ch_all empchnew if pm!=1 & empchnew!=. & d_position_interp!=., cluster(cmpcode)
regress dparty_all lparty_all pmposition_ch_all ingovt ingovtxpmposition_ch_all dches if pm!=1 & empchnew!=. & d_position_interp!=., cluster(cmpcode)

/* Table 2, Descriptive statistics */
gen abs_dparty_all = abs(dparty_all)
sum dparty_all ingovt if e(sample)
sum dparty_all if e(sample) & ingovt==1
sum dparty_all if e(sample) & ingovt==0
sum lparty_all if e(sample)
sum dparty_all if e(sample) & pm==1
sum ingovt if e(sample)

/* Table 2, Descriptive Statistics: absolute values */

sum abs_dparty_all if e(sample)
sum abs_dparty_all if e(sample) & ingovt==1
sum abs_dparty_all if e(sample) & ingovt==0

/* Table 2, Descriptive Statistics, absolute values, for the PM parties */

sum dparty_all abs_dparty_all if empchnew!=. & d_position_interp!=. & pm ==1

/* STATISTICS REPORTED IN THE TEXT  */

/* Correlation between EES (dparty_all), EMP (empchnew), and CHES (dches) */

pwcorr dparty_all empchnew dches if empchnew!=. & d_position_interp!=. , sig

/* Correlation between citizen perceptions of shifts in PM and Jr partners' EU positions */
 pwcorr pmposition_ch_all dparty_all if ingovt ==1 & pm!=1& empchnew!=. & d_position_interp!=., sig

/* Correlation for EMP estimates, generating the PM perceived position shift, and putting this observation in for all parties in the country election year */
bysort index: gen EMP_d_pmposition_all1 = empchnew if pm==1
by index: egen EMP_pmposition_ch_all = max (EMP_d_pmposition_all1)
pwcorr EMP_pmposition_ch_all empchnew if ingovt ==1 & pm!=1& empchnew!=. & d_position_interp!=., sig

/* Correlation for CHES estimates, generating the PM perceived position shift, and putting this observation in for all parties in the country election year */
bysort index: gen CHES_d_pmposition_all1 = dches if pm==1
by index: egen CHES_pmposition_ch_all = max (CHES_d_pmposition_all1)
pwcorr CHES_pmposition_ch_all dches if ingovt ==1 & pm!=1& empchnew!=. & d_position_interp!=., sig

/* Conditional Parameter estimates for the effect of PM shift on Jr. Partner shift */
regress dparty_all lparty_all c.pmposition_ch_all##ingovt if pm!=1 & empchnew!=. & d_position_interp!=., cluster(cmpcode)
margins , dydx(pmposition_ch_all) at(ingovt=(0 1)) vsquish
