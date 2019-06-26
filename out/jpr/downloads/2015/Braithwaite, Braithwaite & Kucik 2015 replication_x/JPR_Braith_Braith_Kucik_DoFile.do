**This do-file produces materials and results reported in "The conditioning effect of protest history on the emulation of nonviolent conflict"**
**Authors: Alex Braithwaite, Jessica Maves Braithwaite, and Jeffrey Kucik
**May 8, 2015

**Baseline model used to establish estimation sample for remaining models:
probit nvonset Lgower_nonviolence_all proportion_5 Lgower_nv_all_proportion5 Lviolence_NAVCO anyelect neigh_democ wr_mir wr_mor wr_spr wr_spmr l1lgdppc lpop ageeh post nvpeaceyrs nvpeaceyrs2 nvpeaceyrs3 if democracy==0, nolog vce(cluster ccode)

** To produce Table I: Summary statistics for estimation sample:
sutex2 nvonset Lgower_nonviolence_all Lgower_nonviolence_progress Lgower_nonviolence_success proportion_5 Lviolence_NAVCO anyelect neigh_democ wr_mir wr_mor wr_pr wr_spr wr_sppr wr_spmr wr_spmpr wr_mpr l1lgdppc lpop ageeh post nvpeaceyrs nvpeaceyrs2 nvpeaceyrs3 if democracy==0 & e(sample)==1, min

** To produce estimates reported in Table II: The contagion of nonviolent conflict (all cases), 1946-2006
*** Model 1: 
probit nvonset Lgower_nonviolence_all Lviolence_NAVCO anyelect neigh_democ wr_mir wr_mor wr_spr wr_spmr l1lgdppc lpop ageeh post nvpeaceyrs nvpeaceyrs2 nvpeaceyrs3 if democracy==0 & e(sample)==1, nolog vce(cluster ccode)
estat ic
margins, at(Lgower_nonviolence_all = .0) 
* @ the min value
margins, at(Lgower_nonviolence_all = .04) 
* @ the mean value
margins, at(Lgower_nonviolence_all = .143) 
* @ the max value

*** Model 2: 
probit nvonset Lgower_nonviolence_all proportion_5 Lviolence_NAVCO anyelect neigh_democ wr_mir wr_mor wr_spr wr_spmr l1lgdppc lpop ageeh post nvpeaceyrs nvpeaceyrs2 nvpeaceyrs3 if democracy==0 & e(sample)==1, nolog vce(cluster ccode)
estat ic

*** Model 3: 
probit nvonset Lgower_nonviolence_all proportion_5 Lgower_nv_all_proportion5 Lviolence_NAVCO anyelect neigh_democ wr_mir wr_mor wr_spr wr_spmr l1lgdppc lpop ageeh post nvpeaceyrs nvpeaceyrs2 nvpeaceyrs3 if democracy==0 & e(sample)==1, nolog vce(cluster ccode)
estat ic

*** Figure 1. Please note that the figure was edited manually in Stata to look a little prettier than the basic .gph
grinter Lgower_nonviolence_all, inter(Lgower_nv_all_proportion5) const02(proportion_5) eq(nvonset) kdensity yline(0) nomeantext 

** To produce estimates reported in Table III: The contagion of nonviolent conflict (progress and success), 1946-2006
*** Model 4: 
probit nvonset Lgower_nonviolence_progress Lviolence_NAVCO anyelect neigh_democ wr_mir wr_mor wr_spr wr_spmr l1lgdppc lpop ageeh post nvpeaceyrs nvpeaceyrs2 nvpeaceyrs3 if democracy==0 & e(sample)==1, nolog vce(cluster ccode)
estat ic
margins, at(Lgower_nonviolence_progress = .0) 
* @ the min value
margins, at(Lgower_nonviolence_progress = .023) 
* @ the mean value
margins, at(Lgower_nonviolence_progress = .103) 
* @ the max value

*** Model 5: 
probit nvonset Lgower_nonviolence_progress proportion_5 Lviolence_NAVCO anyelect neigh_democ wr_mir wr_mor wr_spr wr_spmr l1lgdppc lpop ageeh post nvpeaceyrs nvpeaceyrs2 nvpeaceyrs3 if democracy==0 & e(sample)==1, nolog vce(cluster ccode)
estat ic

*** Model 6: 
probit nvonset Lgower_nonviolence_progress proportion_5 Lgower_nv_progress_proportion5 Lviolence_NAVCO anyelect neigh_democ wr_mir wr_mor wr_spr wr_spmr l1lgdppc lpop ageeh post nvpeaceyrs nvpeaceyrs2 nvpeaceyrs3 if democracy==0 & e(sample)==1, nolog vce(cluster ccode)
estat ic

*** Figure 2. Please note that the figure was edited manually in Stata to look a little prettier than the basic .gph
grinter Lgower_nonviolence_progress, inter(Lgower_nv_progress_proportion5) const02(proportion_5) eq(nvonset) kdensity yline(0) nomeantext

*** Model 7: 
probit nvonset Lgower_nonviolence_success Lviolence_NAVCO anyelect neigh_democ wr_mir wr_mor wr_spr wr_spmr l1lgdppc lpop ageeh post nvpeaceyrs nvpeaceyrs2 nvpeaceyrs3 if democracy==0 & e(sample)==1, nolog vce(cluster ccode)
estat ic
margins, at(Lgower_nonviolence_success = .0) 
* @ the min value
margins, at(Lgower_nonviolence_success = .007) 
* @ the mean value
margins, at(Lgower_nonviolence_success = .054) 
* @ the max value

*** Model 8: 
probit nvonset Lgower_nonviolence_success proportion_5 Lviolence_NAVCO anyelect neigh_democ wr_mir wr_mor wr_spr wr_spmr l1lgdppc lpop ageeh post nvpeaceyrs nvpeaceyrs2 nvpeaceyrs3 if democracy==0 & e(sample)==1, nolog vce(cluster ccode)
estat ic

*** Model 9: 
probit nvonset Lgower_nonviolence_success proportion_5 Lgower_nv_success_proportion5 Lviolence_NAVCO anyelect neigh_democ wr_mir wr_mor wr_spr wr_spmr l1lgdppc lpop ageeh post nvpeaceyrs nvpeaceyrs2 nvpeaceyrs3 if democracy==0 & e(sample)==1, nolog vce(cluster ccode)
estat ic

*** Figure 3. Please note that the figure was edited manually in Stata to look a little prettier than the basic .gph
grinter Lgower_nonviolence_success, inter(Lgower_nv_success_proportion5) const02(proportion_5) eq(nvonset) kdensity yline(0) nomeantext

***To produce estimates reported in Table 1 of the online appendix that accompanies the article:

** Model 10:
probit nvonset Lneighall_nv_autocs proportion_5 Lneighall_nv_autocs_proportion5 Lviolence_NAVCO anyelect neigh_democ wr_mir wr_mor wr_spr wr_spmr l1lgdppc lpop ageeh post nvpeaceyrs nvpeaceyrs2 nvpeaceyrs3 if democracy==0 & e(sample)==1, nolog vce(cluster ccode)

*** Figure 3. Please note that the figure was edited manually in Stata to look a little prettier than the basic .gph
grinter Lneighall_nv_autocs, inter(Lneighall_nv_autocs_proportion5) const02(proportion_5) eq(nvonset) kdensity yline(0) nomeantext 

** Model 11: 
probit nvonset Lgower_nonviolence_all proportion_5 Lgower_nv_all_proportion5 Lviolence_NAVCO anyelect neigh_democ wr_mir wr_mor wr_spr wr_spmr l1lgdppc lpop ageeh post Llatentmean nvpeaceyrs nvpeaceyrs2 nvpeaceyrs3 if democracy==0 & e(sample)==1, nolog vce(cluster ccode)

** Model 12: 
probit nvonset Lgower_nonviolence_all proportion_5 Lgower_nv_all_proportion5 Lviolence_NAVCO anyelect neigh_democ wr_mir wr_mor wr_spr wr_spmr l1lgdppc lpop ageeh post llegis nvpeaceyrs nvpeaceyrs2 nvpeaceyrs3 if democracy==0 & e(sample)==1, nolog vce(cluster ccode)

** Model 13: 
probit nvonset Lgower_nonviolence_all proportion_5 Lgower_nv_all_proportion5 Lviolence_NAVCO anyelect neigh_democ wr_mir wr_mor wr_spr wr_spmr l1lgdppc lpop ageeh post Lchange_polity2 nvpeaceyrs nvpeaceyrs2 nvpeaceyrs3 if democracy==0 & e(sample)==1, nolog vce(cluster ccode)


**THE END. Correspondence: abraith@arizona.edu
