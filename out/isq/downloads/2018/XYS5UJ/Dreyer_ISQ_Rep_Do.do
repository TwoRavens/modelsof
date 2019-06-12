

* Model 1 *

logit mid iss_accum cap_rat maj_power alliance democ contig spline_1 spline_2 spline_3 spline_4, cluster(rivdyad)

prtab iss_accum

prchange iss_accum


* Model 2 *

logit mid rap_iss_accum grad_iss_accum cap_rat maj_power alliance democ contig spline_1 spline_2 spline_3 spline_4, cluster(rivdyad)


* Model 3 *

logit mid only_iden only_spat only_ideo spat_pos pos_ideo spat_iden spat_ideo spat_pos_ideo spat_pos_iden cap_rat maj_power alliance democ contig spline_1 spline_2 spline_3 spline_4 if spat_iden_ideo == 0 & iden_ideo == 0 & pos_iden == 0 & pos_iden_ideo == 0, cluster(rivdyad)

prtab only_spat
prtab only_iden
prtab only_ideo
prtab spat_pos
prtab spat_iden
prtab spat_ideo
prtab pos_ideo
prtab spat_pos_iden
prtab spat_pos_ideo

prchange only_spat only_iden only_ideo spat_pos spat_iden spat_ideo pos_ideo spat_pos_iden spat_pos_ideo


* Model 4 *

logit war iss_accum cap_rat maj_power alliance democ contig spline_1 spline_2 spline_3 spline_4, cluster(rivdyad)


* Model 5 *

logit war rap_iss_accum grad_iss_accum cap_rat maj_power alliance democ contig spline_1 spline_2 spline_3 spline_4, cluster(rivdyad)


* Model 6 *

logit war only_pos only_spat only_ideo spat_pos pos_ideo spat_iden spat_ideo spat_pos_ideo spat_pos_iden cap_rat maj_power alliance democ contig spline_1 spline_2 spline_3 spline_4 if spat_iden_ideo == 0 & iden_ideo == 0 & pos_iden == 0 & pos_iden_ideo == 0, cluster(rivdyad)
