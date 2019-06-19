clear
capture log close
set more off
set mem 500m


****

use data_pt_pop_1891, clear

*** Fix manchester and salford
replace loc="manchester" if loc=="salford"
count
collapse (sum) pop, by(loc year)
count

sort loc

merge loc using data_town_cotton_shr_1851

tab _merge
keep if _merge==3
drop _merge

gen shr_tex=shr_cot +shr_wool +shr_other_tex
gen ln_pop=ln(pop)

**** In differences
keep if year<1881


** Reshape
reshape wide pop ln_pop, i(loc) j(year)


** Generate growth variables
gen gr_41_51=ln_pop1851-ln_pop1841
gen gr_51_61=ln_pop1861-ln_pop1851
gen gr_61_71=ln_pop1871-ln_pop1861
gen chg_gr=gr_61_71-gr_51_61

** RHS var
gen cotton10=0
replace cotton10=1 if shr_cot>.1



teffects psmatch (chg_gr) (cotton10 pop1861 gr_41_51 gr_51_61), atet nneighbor(3) vce(robust) gen(matches)
est store NN3

outsheet loc match* using results_appendix_NN3_matches.csv, comma names replace
drop match*



teffects psmatch (chg_gr) (cotton10 pop1861 gr_41_51 gr_51_61 shr_tex), atet nneighbor(3) vce(robust) gen(matches)
est store NNT3

outsheet loc match* using results_appendix_NNT3_matches.csv, comma names replace
drop match*

outreg2 [NN3 NNT3] using results_appendix_table_6_1891, tex replace see label  drop(_I*)


*************** Now for data to 1901 ****************
clear

****

use data_pt_pop_1901, clear

*** Fix manchester and salford
replace loc="manchester" if loc=="salford"
count
collapse (sum) pop, by(loc year)
count

sort loc

merge loc using data_town_cotton_shr_1851

tab _merge
keep if _merge==3
drop _merge

gen shr_tex=shr_cot +shr_wool +shr_other_tex
gen ln_pop=ln(pop)

**** In differences
keep if year<1881


** Reshape
reshape wide pop ln_pop, i(loc) j(year)


** Generate growth variables
gen gr_51_61=ln_pop1861-ln_pop1851
gen gr_61_71=ln_pop1871-ln_pop1861
gen chg_gr=gr_61_71-gr_51_61

** RHS var
gen cotton10=0
replace cotton10=1 if shr_cot>.1



teffects psmatch (chg_gr) (cotton10 pop1861 gr_51_61), atet nneighbor(3) vce(robust) gen(matches)
est store NN3

outsheet loc match* using results_appendix_NN3_matches_1901.csv, comma names replace
drop match*



teffects psmatch (chg_gr) (cotton10 pop1861 gr_51_61 shr_tex), atet nneighbor(3) vce(robust) gen(matches)
est store NNT3

outsheet loc match* using results_appendix_NNT3_matches_1901.csv, comma names replace
drop match*

outreg2 [NN3 NNT3] using results_appendix_table_8_1901, tex replace see label  drop(_I*)


****

