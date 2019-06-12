set more off
xtset ccode1 time

***Main Analyses***

*Table 1
xtreg casualties1_med wr_spr wr_mir lncapshare1 lnpop lnmil dem2 ally contig cwinit duration lnen if regime==1, re

*Table 2
logit casualties_dummy wr_spr wr_mir lncapshare1 lnpop lnmil dem2 ally contig cwinit duration lnen if regime==1
logit highcas wr_spr wr_mir lncapshare1 lnpop lnmil dem2 ally contig cwinit duration lnen if regime==1

*Table 3
heckman casualties1_med wr_spr wr_mir lncapshare1 lnpop lnmil dem2 ally contig duration lnen if regime==1, select(wr_spr wr_mir newregime_1 cap_1 cap_2 initshare dependlow  majmaj minmaj majmin dem2 contigdum logdist s_wt_glo s_lead_1 s_lead_2 cwpceyrs) twostep


***Sensitivity Analyses***

*Table A1
summ casualties1_med wr_pr wr_spr wr_mir bossstrong bossjlw_1 machinejlw_1 juntajlw_1 strongmanjlw_1  lncapshare1 lnpop lnmil dem2 ally contig cwinit duration lnen

*Table A2
xtreg casualties1_min wr_spr wr_mir lncapshare1 lnpop lnmil dem2 ally contig cwinit duration lnen if regime==1, re
xtreg casualties1_max wr_spr wr_mir lncapshare1 lnpop lnmil dem2 ally contig cwinit duration lnen if regime==1, re

*TABLE A3
xtreg cas_rate wr_spr wr_mir lncapshare1 lnpop lnmil dem2 ally contig cwinit duration lnen if regime==1, re
xtreg cas_percapita wr_spr wr_mir lncapshare1 lnmil dem2 ally contig cwinit duration lnen if regime==1, re

*Table A4
heckman casualties1_med wr_spr wr_mir lncapshare1 lnpop lnmil dem2 ally contig duration lnen if regime==1, select(wr_spr wr_mir newregime_1 cap_1 cap_2 initshare dependlow  majmaj minmaj majmin dem2 contigdum logdist s_wt_glo s_lead_1 s_lead_2 cwpceyrs) twostep

*Table A5
reg casualties1_med wr_spr wr_mir lncapshare1 lnpop lnmil dem2 ally contig cwinit duration lnen if regime==1
estat vif

*Table A6
xtreg lead_cas wr_spr wr_mir lncapshare1 lnpop lnmil dem2 ally contig cwinit duration lnen if regime==1, re

*Table A7
xtreg casualties1_med bossstrong lncapshare1 lnpop lnmil dem2 ally contig cwinit duration lnen if laislater==1, re
xtreg casualties1_med strongmanjlw_1 machinejlw_1 juntajlw_1 lncapshare1 lnpop lnmil dem2 ally contig cwinit duration lnen if laislater==1, re

*Table A8
logit casualties_dummy bossstrong lncapshare1 lnpop lnmil dem2 ally contig cwinit duration lnen if laislater==1
logit casualties_dummy strongmanjlw_1 machinejlw_1 juntajlw_1 lncapshare1 lnpop lnmil dem2 ally contig cwinit duration lnen if laislater==1

logit highcas bossstrong lncapshare1 lnpop lnmil dem2 ally contig cwinit duration lnen if laislater==1
logit highcas strongmanjlw_1 machinejlw_1 juntajlw_1 lncapshare1 lnpop lnmil dem2 ally contig cwinit duration lnen if laislater==1

*Table A9
xtreg cas_rate bossstrong lncapshare1 lnpop lnmil dem2 ally contig cwinit duration lnen if laislater==1, re
xtreg cas_percapita bossstrong lncapshare1 lnmil dem2 ally contig cwinit duration lnen if laislater==1, re

xtreg cas_rate strongmanjlw_1 machinejlw_1 juntajlw_1 lncapshare1 lnpop lnmil dem2 ally contig cwinit duration lnen if laislater==1, re
xtreg cas_percapita strongmanjlw_1 machinejlw_1 juntajlw_1 lncapshare1 lnmil dem2 ally contig cwinit duration lnen if laislater==1, re

*Table A10
heckman casualties1_med bossstrong lncapshare1 lnpop lnmil dem2 ally contig duration lnen if laislater==1, select(bossstrong newregime_1 cap_1 cap_2 initshare dependlow  majmaj minmaj majmin dem2 contigdum logdist s_wt_glo s_lead_1 s_lead_2 cwpceyrs) twostep
heckman casualties1_med strongmanjlw_1 machinejlw_1 juntajlw_1  lncapshare1 lnpop lnmil dem2 ally contig duration lnen if laislater==1, select(strongmanjlw_1 machinejlw_1 juntajlw_1  newregime_1 cap_1 cap_2 initshare dependlow  majmaj minmaj majmin dem2 contigdum logdist s_wt_glo s_lead_1 s_lead_2 cwpceyrs) twostep

*Table A11
xtreg lead_cas bossstrong lncapshare1 lnpop lnmil dem2 ally contig cwinit duration lnen if laislater==1, re
xtreg lead_cas strongmanjlw_1 machinejlw_1 juntajlw_1 lncapshare1 lnpop lnmil dem2 ally contig cwinit duration lnen if laislater==1, re

*Table A12
xtreg casualties1_med iaep_d lncapshare1 lnpop lnmil dem2 ally contig cwinit duration lnen if autocracy==1, re

*Table A13
xtreg casualties1_med wr_spr wr_mir wr_mor wr_spmr wr_sppr wr_mpr wr_spmpr lncapshare1 lnpop lnmil dem2 ally contig cwinit duration lnen, re vce(robust)

*Table A14
xtreg casualties1_med bdm_w lncapshare1 lnpop lnmil dem2 ally contig cwinit duration lnen if regime==1, re
xtreg casualties1_med bdm_w_s lncapshare1 lnpop lnmil dem2 ally contig cwinit duration lnen if regime==1, re

*Table A15

*Physical Integrity Rights Index: ciri_physint
xtreg casualties1_med ciri_physint lncapshare1 lnpop lnmil dem2 ally contig cwinit duration lnen if autocracy==1, re 
xtreg casualties1_med ciri_physint wr_spr wr_mir lncapshare1 lnpop lnmil dem2 ally contig cwinit duration lnen if regime==1, re 

*The number of veto players (Tsebelis 2002): dpi_checks
xtreg casualties1_med dpi_checks lncapshare1 lnpop lnmil dem2 ally contig cwinit duration lnen if autocracy==1, re 
xtreg casualties1_med dpi_checks wr_spr wr_mir lncapshare1 lnpop lnmil dem2 ally contig cwinit duration lnen if regime==1, re 

*Political constraints (Henisz 2010): h_polcon5
xtreg casualties1_med h_polcon5 lncapshare1 lnpop lnmil dem2 ally contig cwinit duration lnen if autocracy==1, re 
xtreg casualties1_med h_polcon5 wr_spr wr_mir lncapshare1 lnpop lnmil dem2 ally contig cwinit duration lnen if regime==1, re 

*Table A16

*Competitiveness: dpi_eipc
xtreg casualties1_med dpi_eipc lncapshare1 lnpop lnmil dem2 ally contig cwinit duration lnen if autocracy==1, re 
xtreg casualties1_med dpi_eipc wr_spr wr_mir lncapshare1 lnpop lnmil dem2 ally contig cwinit duration lnen if regime==1, re 

*Contestation (Coppedge et al. 2008): cam_contest 
xtreg casualties1_med cam_contest lncapshare1 lnpop lnmil dem2 ally contig cwinit duration lnen if autocracy==1, re 
xtreg casualties1_med cam_contest wr_spr wr_mir lncapshare1 lnpop lnmil dem2 ally contig cwinit duration lnen if regime==1, re 

*Inclusiveness (Coppedge et al. 2008): cam_inclusive 
xtreg casualties1_med cam_inclusive lncapshare1 lnpop lnmil dem2 ally contig cwinit duration lnen if autocracy==1, re 
xtreg casualties1_med cam_inclusive wr_spr wr_mir lncapshare1 lnpop lnmil dem2 ally contig cwinit duration lnen if regime==1, re 

*Table A17
xtreg casualties1_med wr_spr wr_mir recruit cwpceyrs  goal2 recip outcomedum  lncapshare1 lnpop lnmil dem2 ally contig cwinit duration lnen if regime==1, re
xtreg casualties1_med bossstrong recruit cwpceyrs  goal2 recip outcomedum  lncapshare1 lnpop lnmil dem2 ally contig cwinit duration lnen if laislater==1, re
xtreg casualties1_med strongmanjlw_1 machinejlw_1 juntajlw_1 recruit cwpceyrs  goal2 recip outcomedum lncapshare1 lnpop lnmil dem2 ally contig cwinit duration lnen if laislater==1, re

*Table A18
xtpcse casualties1_med wr_spr wr_mir lncapshare1 lnpop lnmil dem2 ally contig cwinit duration lnen if regime==1, pairwise corr(ar1) rhotype(tscorr)
xtpcse casualties1_med bossstrong lncapshare1 lnpop lnmil dem2 ally contig cwinit duration lnen if laislater==1, pairwise corr(ar1) rhotype(tscorr)
xtpcse casualties1_med strongmanjlw_1 machinejlw_1 juntajlw_1 lncapshare1 lnpop lnmil dem2 ally contig cwinit duration lnen if laislater==1, pairwise corr(ar1) rhotype(tscorr)
