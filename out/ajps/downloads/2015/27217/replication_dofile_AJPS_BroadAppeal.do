*** REPLICATION DO-FILE ***
*** Paper: Everything to Everyone ***
*** Author: Zeynep Somer-Topcu ***
*** Date: August 28, 2014 ***


*** AGGREGATE ANALYSES ***

use "aggregate_replication_data_AJPS_BroadAppeal.dta", replace

** Table 2 ***

areg votech1 disagreement_ch1 move_to_mean_absch1 lastgovt gdp_pc_growth lastgovtxgdppcgrowth single_issue votech2, absorb(party) cluster(index)
areg votech1 disagreement_ch1 move_to_mean_absch1 lastgovt gdp_pc_growth lastgovtxgdppcgrowth votech2 if single_issue==0, absorb(party) cluster(index)

**** models to report in the supplementary****

** Table S1 **
* descriptive statistics
sum votech1 votech2 disagreement disagreement_ch1 lastgovt gdp_pc_growth lastgovtxgdppcgrowth move_to_mean_absch1 single_issue if votech1!=. & votech2!=. & votet1!=. & disagreement_ch1!=. & lastgovt!=. & gdp_pc_growth!=. & lastgovtxgdppcgrowth!=. & move_to_mean_absch1!=. & single_issue!=.

** Table S2 **
* do party level factors affect disagreement?
reg disagreement_ch1 disagreement_ch2 lastgovt single_issue absdist_mean vote if votech1!=. & votech2!=. & disagreement_ch1!=. & move_to_mean_absch1!=., cluster(index)

** Table S3 **
* do individual-level factors affect disagreement?
areg votech1 votech2 disagreement_intch1 lastgovt gdp_pc_growth lastgovtxgdppcgrowth move_to_mean_absch1 single_issue, absorb(party) cluster(index)
areg votech1 votech2 disagreement_notintch1 lastgovt gdp_pc_growth lastgovtxgdppcgrowth move_to_mean_absch1 single_issue, absorb(party) cluster(index)

** Table S4**
* extremeness
areg votech1 votech2 disagreement_ch1 lastgovt gdp_pc_growth lastgovtxgdppcgrowth move_to_mean_absch1 absdist_mean single_issue, absorb(party) cluster(index)

* moderation to median
areg votech1 votech2 disagreement_ch1 lastgovt move_to_median_absch1 gdp_pc_growth lastgovtxgdppcgrowth single_issue, absorb(party) cluster(index)

* longest government
areg votech1 votech2 disagreement_ch1 longest gdp_pc_growth longestxgdppcgrowth move_to_mean_absch1 single_issue, absorb(party) cluster(index)

* party supporters
areg votech1 disagreement_suppch1 move_to_mean_absch1 lastgovt gdp_pc_growth lastgovtxgdppcgrowth single_issue votech2, absorb(party) cluster(index)

** Table S5**
* no lagged
areg votech1 disagreement_ch1 lastgovt gdp_pc_growth lastgovtxgdppcgrowth move_to_mean_absch1 single_issue, absorb(party) cluster(index)

* tobit
tobit votech1 disagreement_ch1 move_to_mean_absch1 lastgovt gdp_pc_growth lastgovtxgdppcgrowth votech2 single_issue i.party, cluster(index) ll(-100) ul(100)

* logged
areg loggedvotech1 loggedvotech2 disagreement_ch1 lastgovt gdp_pc_growth lastgovtxgdppcgrowth move_to_mean_absch1 single_issue, absorb(party) cluster(index)

* no outlier
areg votech1 votech2 disagreement_ch1 lastgovt gdp_pc_growth lastgovtxgdppcgrowth move_to_mean_absch1 single_issue if disagreement<0.689, absorb(party) cluster(index)


*** Table S6 ***
* dropping one country at a time
* Ccode is coded following CMP data codebook: 11 for Swede, 12 for Norway, 13 for Denmark, 14 for Finland, 15 for Iceland, 22 for Netherlands, 33 for Spain, 35 for Portugal, and 41 for Germany
areg votech1 votech2 disagreement_ch1 lastgovt gdp_pc_growth lastgovtxgdppcgrowth move_to_mean_absch1 single_issue if ccode!=11, absorb(party) cluster(index)
areg votech1 votech2 disagreement_ch1 lastgovt gdp_pc_growth lastgovtxgdppcgrowth move_to_mean_absch1 single_issue if ccode!=12, absorb(party) cluster(index)
areg votech1 votech2 disagreement_ch1 lastgovt gdp_pc_growth lastgovtxgdppcgrowth move_to_mean_absch1 single_issue if ccode!=13, absorb(party) cluster(index)
areg votech1 votech2 disagreement_ch1 lastgovt gdp_pc_growth lastgovtxgdppcgrowth move_to_mean_absch1 single_issue if ccode!=14, absorb(party) cluster(index)
areg votech1 votech2 disagreement_ch1 lastgovt gdp_pc_growth lastgovtxgdppcgrowth move_to_mean_absch1 single_issue if ccode!=15, absorb(party) cluster(index)
areg votech1 votech2 disagreement_ch1 lastgovt gdp_pc_growth lastgovtxgdppcgrowth move_to_mean_absch1 single_issue if ccode!=22, absorb(party) cluster(index)
areg votech1 votech2 disagreement_ch1 lastgovt gdp_pc_growth lastgovtxgdppcgrowth move_to_mean_absch1 single_issue if ccode!=33, absorb(party) cluster(index)
areg votech1 votech2 disagreement_ch1 lastgovt gdp_pc_growth lastgovtxgdppcgrowth move_to_mean_absch1 single_issue if ccode!=35, absorb(party) cluster(index)
areg votech1 votech2 disagreement_ch1 lastgovt gdp_pc_growth lastgovtxgdppcgrowth move_to_mean_absch1 single_issue if ccode!=41, absorb(party) cluster(index)


** INDIVIDUAL-LEVEL ANALYSES **

use "indiv_level_replication_data_AJPS_BroadAppeal", replace

xtmixed abs_dist_perceived disagreement abs_dist_expert absdist_expxdisagr education pidinclindep single_issue lastgovt vote i.index, ||partycode_cmp: ||party_year:, var
est store main1
generate MV=((_n-1)/10)
replace  MV=. if _n>51
matrix b=e(b) 
matrix V=e(V)
scalar b1=b[1,1] 
scalar b2=b[1,2]
scalar b3=b[1,3]
scalar varb1=V[1,1]
scalar varb2=V[2,2] 
scalar varb3=V[3,3]
scalar covb1b3=V[1,3] 
scalar covb2b3=V[2,3]
gen conb=b1+b3*MV if _n<52
gen conse=sqrt(varb1+varb3*(MV^2)+2*covb1b3*MV) if _n<52
gen a=2.58*conse
gen upper=conb+a
gen lower=conb-a
graph twoway line conb MV, clwidth(medium) clcolor(blue) clcolor(black) || line upper MV, clpattern(dash) clwidth(thin) clcolor(black) || line lower MV, clpattern(dash) clwidth(thin) clcolor(black)||, xlabel(0 (1) 5, labsize(2.5)) ylabel(-4 (1) 1,   labsize(2.5)) yline(0, lcolor(black)) yscale(noline) xscale(noline) ytitle("Marginal Effect of Perceived Disagreement", size(3)) legend(off) scheme(s2mono) graphregion(fcolor(white)) xtitle("Actual Distance to the Party") name(me, replace)
graph save main
drop MV-lower

xtmixed abs_dist_perceived disagreement abs_dist_expert absdist_expxdisagr education pidinclindep lastgovt vote i.index if single_issue==0, ||partycode_cmp: ||party_year:, var

xtmixed abs_dist_perceived disagreement abs_dist_expert absdist_expxdisagr education single_issue lastgovt vote i.index if pidinclindep==0, ||partycode_cmp: ||party_year:, var


**** models to report in the supplementary****

** Table S7 **
* Direct Effects
xtmixed abs_dist_perceived disagreement abs_dist_expert education pidinclindep single_issue lastgovt vote i.index, ||partycode_cmp: ||party_year:, var

* political knowledge
xtmixed abs_dist_perceived disagreement abs_dist_expert absdist_expxdisagr education pidinclindep single_issue lastgovt vote polkno i.index, ||partycode_cmp: ||party_year:, var

* using chapel hill experts in place of cses experts
*gen abs_dist_chexpert= abs(extrapolated-selfideo)
gen absdist_chexpxdisagr= disagreement*abs_dist_chexpert
xtmixed abs_dist_perceived disagreement abs_dist_chexpert absdist_chexpxdisagr education pidinclindep single_issue lastgovt vote i.index, ||partycode_cmp: ||party_year:, var

* with country fixed effects
xtmixed abs_dist_perceived disagreement abs_dist_expert absdist_expxdisagr education pidinclindep single_issue lastgovt vote i.ccode, ||partycode_cmp: ||party_year:, var
