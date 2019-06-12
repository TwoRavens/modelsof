
***********************
*** MAIN TEXT *********
***********************

********
** US **
********
use BJPOLS_Data_US.dta, clear
sort year majortopic
xtset majortopic year

***********
* TABLE 1 *
***********

*SOTU
xtpcse speechshare_ i.pelectioncycle rank_gov_lcompetence_ mipshare_int_, correlation(psar1)
outreg using Tab1, se bdec(3) sigsymb(#,*,**,***) starlevels(15 10 5 1) ctitle("", Model 1) replace

xtpcse speechshare_ i.pelectioncycle rank_gov_lcompetence_ mipshare_int_ mip_rankcomp_ gov_vote vot_rankcomp_, correlation(psar1)
outreg using Tab1, se bdec(3) sigsymb(#,*,**,***) starlevels(15 10 5 1) ctitle("", Model 2) merge

xtpcse speechshare_ i.pelectioncycle rank_gov_lcompetence_ mipshare_int_ mip_rankcomp_ gov_vote vot_rankcomp_ divided mip_div_ rankcomp_div_ mip_rankcomp_div_, correlation(psar1)
outreg using Tab1, se bdec(3) sigsymb(#,*,**,***) starlevels(15 10 5 1) ctitle("", Model 3) merge

xtpcse speechshare_ rank_gov_lcompetence_ mipshare_int_ mip_rankcomp_ gov_vote vot_rankcomp_ divided mip_div_ rankcomp_div_ mip_rankcomp_div_, correlation(psar1)
outreg using Tab1, se bdec(3) sigsymb(#,*,**,***) starlevels(15 10 5 1) ctitle("", Model 4) merge

***********
* TABLE 2 *
***********

*LAWS
xtpcse milawsshare_ i.electioncycle rank_cong_lcompetence_ mipshare_int_, correlation(psar1)
outreg using Tab2, se bdec(3) sigsymb(#,*,**,***) starlevels(15 10 5 1) ctitle("", Model 1) replace

xtpcse milawsshare_ i.electioncycle rank_cong_lcompetence_ mipshare_int_ mip_congrankcomp_ cong_gov_vote vot_congrankcomp_, correlation(psar1)
outreg using Tab2, se bdec(3) sigsymb(#,*,**,***) starlevels(15 10 5 1) ctitle("", Model 2) merge

xtpcse milawsshare_ i.electioncycle rank_cong_lcompetence_ mipshare_int_ mip_congrankcomp_ cong_gov_vote vot_congrankcomp_ divided mip_div_ congrankcomp_div_ mip_congrankcomp_div_, correlation(psar1)
outreg using Tab2, se bdec(3) sigsymb(#,*,**,***) starlevels(15 10 5 1) ctitle("", Model 3) merge

xtpcse milawsshare_ rank_cong_lcompetence_ mipshare_int_ mip_congrankcomp_ cong_gov_vote vot_congrankcomp_ divided mip_div_ congrankcomp_div_ mip_congrankcomp_div_, correlation(psar1)
outreg using Tab2, se bdec(3) sigsymb(#,*,**,***) starlevels(15 10 5 1) ctitle("", Model 4) merge

********
** UK **
********
use BJPOLS_Data_UK.dta, clear
sort year majortopic
xtset majortopic year

***********
* TABLE 3 *
***********

*ACTS
xtpcse lawsshare_ i.electioncycle rank_gov_lcompetence_ mipshare_int_, correlation(psar1)
outreg using Tab3, se bdec(3) sigsymb(#,*,**,***) starlevels(15 10 5 1) ctitle("", Model 1) replace

xtpcse lawsshare_ i.electioncycle rank_gov_lcompetence_ mipshare_int_ mip_rankcomp_ gov_vote vot_rankcomp_, correlation(psar1)
outreg using Tab3, se bdec(3) sigsymb(#,*,**,***) starlevels(15 10 5 1) ctitle("", Model 2) merge

xtpcse lawsshare_ rank_gov_lcompetence_ mipshare_int_ mip_rankcomp_ gov_vote vot_rankcomp_, correlation(psar1)
outreg using Tab3, se bdec(3) sigsymb(#,*,**,***) starlevels(15 10 5 1) ctitle("", Model 3) merge

***********
* TABLE 4 *
***********
use BJPOLS_Data_UK_Pooled.dta, clear
sort year newmajortopic
xtset newmajortopic year

*POOLED
xtpcse agendashare_ i.electioncycle rank_gov_lcompetence_ mipshare_int_, correlation(psar1)
outreg using Tab4, se bdec(3) sigsymb(#,*,**,***) starlevels(15 10 5 1) ctitle("", Model 1) replace

xtpcse agendashare_ i.electioncycle rank_gov_lcompetence_ mipshare_int_ mip_rankcomp_ gov_vote vot_rankcomp_, correlation(psar1)
outreg using Tab4, se bdec(3) sigsymb(#,*,**,***) starlevels(15 10 5 1) ctitle("", Model 2) merge

xtpcse agendashare_ rank_gov_lcompetence_ mipshare_int_ mip_rankcomp_ gov_vote vot_rankcomp_, correlation(psar1)
outreg using Tab4, se bdec(3) sigsymb(#,*,**,***) starlevels(15 10 5 1) ctitle("", Model 3) merge

