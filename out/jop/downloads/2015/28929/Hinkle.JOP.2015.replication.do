***************************
***  Replicattion File  ***
***  for Hinkle (2015)  ***
*** Journal of Politics ***
***   Stata/MP 13.1     ***
***   January 8, 2015   ***
***************************

* Change directory to location where data files are stored
cd "~/Downloads/JOP.Replication/"

*** CITATION ANALYSIS ***
use "Hinkle.JOP.2015.replication.citation.data.dta", clear


** MATCHED DATA ** 
probit any_cite au_dist in_cir bind_au_dist sim_percentile cited_elite_au cited_dissent cited_per_curiam cited_en_banc cited_vitality cited_tot_trt cited_tot_cites  cited_prec_age cited_prec_age2 ln_cited_word_count cited_pr_quoted ln_citing_word_count ln_bind_choice_set citing_caseload [iweight = _weight],  robust cluster(citing_caseID)

** FULL DATA **
probit any_cite au_dist in_cir bind_au_dist sim_percentile cited_elite_au cited_dissent cited_per_curiam cited_en_banc cited_vitality cited_tot_trt cited_tot_cites  cited_prec_age cited_prec_age2 ln_cited_word_count cited_pr_quoted ln_citing_word_count ln_bind_choice_set citing_caseload,  robust cluster(citing_caseID)

* Code to reproduce plots in Figure 2
kdensity _pscore if in_cir == 1 , recast(line) note("") legend( label(1 "Binding Precedents") label(2 "Persuasive Precedents"))  xtitle(Propensity Score) graphregion(fcolor(white) ifcolor(none)) title(Citation Analysis - Full Data) plotregion(lcolor(black) ifcolor(none)) lcolor(black) lwidth(medthick) lpattern(solid)  addplot(kdensity _pscore if in_cir == 0 , recast(line) lcolor(gray) lwidth(medthick) lpattern(dash) )
kdensity _pscore if in_cir == 1  & _weight != . , recast(line) note("") legend( label(1 "Binding Precedents") label(2 "Persuasive Precedents"))  xtitle(Propensity Score) graphregion(fcolor(white) ifcolor(none)) title(Citation Analysis - Matched Data) plotregion(lcolor(black) ifcolor(none)) lcolor(black) lwidth(medthick) lpattern(solid)  addplot(kdensity _pscore if in_cir == 0 & _weight != . , recast(line) lcolor(gray) lwidth(medthick) lpattern(dash) )



*** TREATMENT ANALYIS ***
use "Hinkle.JOP.2015.replication.treatment.data.dta", clear

** MATCHED DATA ** 
mprobit dv3 au_dist in_cir bind_au_dist sim_percentile cited_elite_au cited_dissent cited_per_curiam cited_en_banc cited_vitality cited_tot_trt cited_tot_cites  cited_prec_age cited_prec_age2 ln_cited_word_count cited_pr_quoted ln_citing_word_count [fweight = _weight], baseoutcome(2)   robust cluster(citing_caseID)

* FULL DATA
mprobit dv3 au_dist in_cir bind_au_dist sim_percentile cited_elite_au cited_dissent cited_per_curiam cited_en_banc cited_vitality cited_tot_trt cited_tot_cites  cited_prec_age cited_prec_age2 ln_cited_word_count cited_pr_quoted ln_citing_word_count, baseoutcome(2)   robust cluster(citing_caseID)

* Code to reproduce plots in Figure 2
kdensity _pscore if in_cir == 1, recast(line) note("") legend( label(1 "Binding Precedents") label(2 "Persuasive Precedents"))  xtitle(Propensity Score) graphregion(fcolor(white) ifcolor(none)) title(Treatment Analysis - Full Data) plotregion(lcolor(black) ifcolor(none)) lcolor(black) lwidth(medthick) lpattern(solid)  addplot(kdensity _pscore if in_cir == 0, recast(line) lcolor(gray) lwidth(medthick) lpattern(dash) )
kdensity _pscore if in_cir == 1 & _weight != ., recast(line) note("") legend( label(1 "Binding Precedents") label(2 "Persuasive Precedents"))  xtitle(Propensity Score) graphregion(fcolor(white) ifcolor(none)) title(Treatment Analysis - Matched Data) plotregion(lcolor(black) ifcolor(none)) lcolor(black) lwidth(medthick) lpattern(solid)  addplot(kdensity _pscore if in_cir == 0 & _weight != ., recast(line) lcolor(gray) lwidth(medthick) lpattern(dash) )





*** ROBUSTNESS CHECKS mentioned in footnotes ***

** Citation Analysis (Matched Data) **
use "Hinkle.JOP.2015.replication.citation.data.dta", clear

* Top 35% of Data
probit any_cite au_dist in_cir bind_au_dist sim_percentile cited_elite_au cited_dissent cited_per_curiam cited_en_banc cited_vitality cited_tot_trt cited_tot_cites  cited_prec_age cited_prec_age2 ln_cited_word_count cited_pr_quoted ln_citing_word_count ln_bind_choice_set citing_caseload if sim_percentile > 64  [iweight = _weight],  robust cluster(citing_caseID)

*Top 25% of Data
probit any_cite au_dist in_cir bind_au_dist sim_percentile cited_elite_au cited_dissent cited_per_curiam cited_en_banc cited_vitality cited_tot_trt cited_tot_cites  cited_prec_age cited_prec_age2 ln_cited_word_count cited_pr_quoted ln_citing_word_count ln_bind_choice_set citing_caseload if sim_percentile > 74  [iweight = _weight],  robust cluster(citing_caseID)

* Top 10% of Data
probit any_cite au_dist in_cir bind_au_dist sim_percentile cited_elite_au cited_dissent cited_per_curiam cited_en_banc cited_vitality cited_tot_trt cited_tot_cites  cited_prec_age cited_prec_age2 ln_cited_word_count cited_pr_quoted ln_citing_word_count ln_bind_choice_set citing_caseload if sim_percentile > 89 [iweight = _weight],  robust cluster(citing_caseID)


*  Heckman model
gen dv3b = dv3 - 2
heckman dv3b au_dist in_cir bind_au_dist sim_percentile cited_elite_au cited_dissent cited_per_curiam cited_en_banc cited_vitality cited_tot_trt cited_tot_cites  cited_prec_age cited_prec_age2 ln_cited_word_count cited_pr_quoted ln_citing_word_count if _weight == 1,  sel(au_dist in_cir bind_au_dist sim_percentile cited_elite_au cited_dissent cited_per_curiam cited_en_banc cited_vitality cited_tot_trt cited_tot_cites  cited_prec_age cited_prec_age2 ln_cited_word_count cited_pr_quoted ln_citing_word_count ln_bind_choice_set citing_caseload)  robust cluster(citing_caseID)


* Alternative measure of Ideological Distance using panel median instead of panel author
probit any_cite med_dist in_cir bind_med_dist sim_percentile cited_elite_au cited_dissent cited_per_curiam cited_en_banc cited_vitality cited_tot_trt cited_tot_cites  cited_prec_age cited_prec_age2 ln_cited_word_count cited_pr_quoted ln_citing_word_count ln_bind_choice_set citing_caseload [iweight = _weight],  robust cluster(citing_caseID)



* Multinomial logit with citation too
mlogit dv4 au_dist in_cir bind_au_dist sim_percentile cited_elite_au cited_dissent cited_per_curiam cited_en_banc cited_vitality cited_tot_trt cited_tot_cites  cited_prec_age cited_prec_age2 ln_cited_word_count cited_pr_quoted ln_citing_word_count [iweight = _weight], baseoutcome(2)   robust cluster(citing_caseID)




** Treatment Analysis **
use "Hinkle.JOP.2015.replication.treatment.data.dta", clear


* med - med
mprobit dv3 med_dist in_cir bind_med_dist sim_percentile cited_elite_au cited_dissent cited_per_curiam cited_en_banc cited_vitality cited_tot_trt cited_tot_cites  cited_prec_age cited_prec_age2 ln_cited_word_count cited_pr_quoted ln_citing_word_count [fweight = _weight], baseoutcome(2)   robust cluster(citing_caseID)




