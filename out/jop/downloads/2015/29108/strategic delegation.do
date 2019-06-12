****triplots
**black and white
triplot  jt_prop st_prop nt_prop, sep(fouryr)  la(nolabels) y bltext("Proportion National") ttext("Proportion Joint") brtext("Proportion State") rtext(" ") btext(" ") ltext(" " ) legend(order(4 "Nixon/Ford, 1973-76"  5 "Carter, 1977-80" 6 "Reagan, 1981-84" 7 "Reagan, 1985-88" 8 "HW Bush, 1989-92" 9 "Clinton, 1993-96" 10 "Clinton, 1997-2000" 11 "W Bush, 2001-04" 12 "W Bush, 2005-08")) scheme(s1mono)

***color
triplot  jt_prop st_prop nt_prop, sep(fouryr)  la(nolabels) y bltext("Proportion National") ttext("Proportion Joint") brtext("Proportion State") rtext(" ") btext(" ") ltext(" " ) legend(order(4 "Nixon/Ford, 1973-76"  5 "Carter, 1977-80" 6 "Reagan, 1981-84" 7 "Reagan, 1985-88" 8 "HW Bush, 1989-92" 9 "Clinton, 1993-96" 10 "Clinton, 1997-2000" 11 "W Bush, 2001-04" 12 "W Bush, 2005-08")) scheme(scheme_lean2)
**Table 1
glm decentralize2 c.state3##c.nat3 cong_gub_t1 cong_prez_t1 tot_prov100 civ_welfdum c.cong4_strev_propgrow_1_pivcond2##c.def_pergdp constit2 if tot_ntstjt>0, cluster(yr) family(binomial tot_ntstjt ) link(logit)
glm decentralize2 c.state3##c.nat3 cong_gub_t1 cong_prez_t1 tot_prov100 civ_welfdum c.cong4_strev_propgrow_1_pivcond2##c.def_pergdp constit2 c.nat_par_bal##c.ecwt_stparbal pet_pol_eddev  if tot_ntstjt>0, cluster(yr) family(binomial tot_ntstjt ) link(logit)
glm decentralize2 tot_prov100 civ_welfdum c.cong4_strev_propgrow_1_pivcond2##c.def_pergdp constit2 c.nat_par_bal##c.ecwt_stparbal pet_pol_eddev  if tot_ntstjt>0, cluster(yr) family(binomial tot_ntstjt ) link(logit)
glm decentralize2 i.cat_over cong_prez_t1 hr_gub_t1 sen_gub_t1 tot_prov100 civ_welfdum c.cong4_strev_propgrow_1_pivcond2##c.def_pergdp constit2 if tot_ntstjt>0, cluster(yr) family(binomial tot_ntstjt ) link(logit)
