**** This file generates all tables and notes found in the Appendices for Study 2.

use "Study2_clean.dta", clear


*** Generate Table C1 (Demographic Table): 

***** Summary of Demographics
su age female income white rel trump college immR wallR2 uacR hawkeyeR legalR immig_index econ_threa2 cultl_thre2_v2 outgroupr ingroupr victimr concernR problemR percent_1 percent_2 if rep == 1
su age female income white rel trump college immR wallR2 uacR hawkeyeR legalR immig_index econ_threa2 cultl_thre2_v2 outgroupr ingroupr victimr concernR problemR percent_1 percent_2 if rep == 0

***** Summary Stats of DVs by Party
orth_out immR wallR2 uacR hawkeyeR legalR immig_index econ_threa2 cultl_thre2 outgroupr ingroupr victimr using imm.tex, by(rep) se pcompare count latex replace


*** Generate Table C2 (Balance): 
orth_out ageR female incomeR white rel trump college using balance_dem.tex if rep == 1, by(treat) se pcompare test latex replace
orth_out ageR female incomeR white rel trump college using balance_rep.tex if rep == 0, by(treat) se pcompare test latex replace


************ Generate data for note on K-Smirnov test

** Ksmirnov
ksmirnov immig_index, by(rep)
/*
 0:                  0.0000    1.000
 1:                 -0.6056    0.000
 Combined K-S:       0.6056    0.000
 P-Value < 0.000
*/
ksmirnov concernR, by(rep)
/*
 0:                  0.0040    0.993
 1:                 -0.0266    0.724
 Combined K-S:       0.0266    0.997
 P-Value = 0.997
*/


*** Generate Table D1 (Human Trafficking Attitudes): 
eststo  : reg problemR treat22 treat23 treat24 trump if rep == 1, robust
eststo  : reg problemR treat22 treat23 treat24 ageR female incomeR white rel trump college if rep == 1, robust
eststo  : reg concernR treat22 treat23 treat24 trump if rep == 1, robust
eststo  : reg concernR treat22 treat23 treat24 ageR female incomeR white rel trump college if rep == 1, robust

eststo  : reg problemR treat22 treat23 treat24 trump if rep == 0, robust
eststo  : reg problemR treat22 treat23 treat24 ageR female incomeR white rel trump college if rep == 0, robust
eststo  : reg concernR treat22 treat23 treat24 trump if rep == 0, robust
eststo  : reg concernR treat22 treat23 treat24 ageR female incomeR white rel trump college if rep == 0, robust
esttab using ht.tex, ar2 b(3) se(3) starlevels(* 0.1 ** .05 *** .01) label replace
eststo clear



*** Generate Table D2 (Immigration Attitudes for Republicans): 
eststo  : reg immR treat22 treat23 treat24 trump if rep == 1, robust
eststo  : reg immR treat22 treat23 treat24 ageR female incomeR white rel trump college if rep == 1, robust
eststo  : reg wallR2 treat22 treat23 treat24 trump if rep == 1, robust
eststo  : reg wallR2 treat22 treat23 treat24 ageR female incomeR white rel trump college if rep == 1, robust
eststo  : reg uacR treat22 treat23 treat24 trump if rep == 1, robust
eststo  : reg uacR treat22 treat23 treat24 ageR female incomeR white rel trump college if rep == 1, robust
eststo  : reg hawkeyeR treat22 treat23 treat24 trump if rep == 1, robust
eststo  : reg hawkeyeR treat22 treat23 treat24 ageR female incomeR white rel trump college if rep == 1, robust
eststo  : reg legalR treat22 treat23 treat24 trump if rep == 1, robust
eststo  : reg legalR treat22 treat23 treat24 ageR female incomeR white rel trump college if rep == 1, robust
eststo  : reg immig_index treat22 treat23 treat24 trump if rep == 1, robust
eststo  : reg immig_index treat22 treat23 treat24 ageR female incomeR white rel trump college if rep == 1, robust
esttab using immigration_rep.tex, ar2 b(3) se(3) starlevels(* 0.1 ** .05 *** .01) label replace
eststo clear


* Generate Table D3 (Immigration Attitudes for Democrats): 
eststo  : reg immR treat22 treat23 treat24 trump if rep == 0, robust
eststo  : reg immR treat22 treat23 treat24 ageR female incomeR white rel trump college if rep == 0, robust
eststo  : reg wallR2 treat22 treat23 treat24 trump if rep == 0, robust
eststo  : reg wallR2 treat22 treat23 treat24 ageR female incomeR white rel trump college if rep == 0, robust
eststo  : reg uacR treat22 treat23 treat24 trump if rep == 0, robust
eststo  : reg uacR treat22 treat23 treat24 ageR female incomeR white rel trump college if rep == 0, robust
eststo  : reg hawkeyeR treat22 treat23 treat24 trump if rep == 0, robust
eststo  : reg hawkeyeR treat22 treat23 treat24 ageR female incomeR white rel trump college if rep == 0, robust
eststo  : reg legalR treat22 treat23 treat24 trump if rep == 0, robust
eststo  : reg legalR treat22 treat23 treat24 ageR female incomeR white rel trump college if rep == 0, robust
eststo  : reg immig_index treat22 treat23 treat24 trump if rep == 0, robust
eststo  : reg immig_index treat22 treat23 treat24 ageR female incomeR white rel trump college if rep == 0, robust
esttab using immigration_dem.tex, ar2 b(3) se(3) starlevels(* 0.1 ** .05 *** .01) label replace
eststo clear

*** Generate Table D4 (Support for Immigration by Party): 
gen treat22_rep = treat22*rep
gen treat23_rep = treat23*rep
gen treat24_rep = treat24*rep

set more off
eststo  : reg immig_index treat22 treat23 treat24 rep treat22_rep treat23_rep treat24_rep trump, robust
eststo  : reg immig_index treat22 treat23 treat24 rep treat22_rep treat23_rep treat24_rep trump female incomeR white rel college, robust
esttab using did.tex, ar2 b(3) se(3) starlevels(* 0.1 ** .05 *** .01) label replace
eststo clear


*** Generate Table D5 (Threat Attitudes by Party)

eststo  : reg econ_threa2 treat22 treat23 treat24 trump if rep == 1, robust
eststo  : reg econ_threa2 treat22 treat23 treat24 ageR female incomeR white rel trump college if rep == 1, robust
eststo  : reg cultl_thre2_v2 treat22 treat23 treat24 trump if rep == 1, robust
eststo  : reg cultl_thre2_v2 treat22 treat23 treat24 ageR female incomeR white rel trump college if rep == 1, robust
eststo  : reg econ_threa2 treat22 treat23 treat24 trump if rep == 0, robust
eststo  : reg econ_threa2 treat22 treat23 treat24 ageR female incomeR white rel trump college if rep == 0, robust
eststo  : reg cultl_thre2_v2 treat22 treat23 treat24 trump if rep == 0, robust
eststo  : reg cultl_thre2_v2 treat22 treat23 treat24 ageR female incomeR white rel trump college if rep == 0, robust
esttab using threat.tex, ar2 b(3) se(3) starlevels(* 0.1 ** .05 *** .01) label replace
eststo clear


*** Generate Table D6 (Ingroup-Centric Beliefs by Party)
eststo  : reg outgroupr treat22 treat23 treat24 trump if rep == 1, robust
eststo  : reg outgroupr treat22 treat23 treat24 ageR female incomeR white rel trump college if rep == 1, robust
eststo  : reg ingroupr treat22 treat23 treat24 trump if rep == 1, robust
eststo  : reg ingroupr treat22 treat23 treat24 ageR female incomeR white rel trump college if rep == 1, robust
eststo  : reg victimr treat22 treat23 treat24 trump if rep == 1, robust
eststo  : reg victimr treat22 treat23 treat24 ageR female incomeR white rel trump college if rep == 1, robust
eststo  : reg outgroupr treat22 treat23 treat24 trump if rep == 0, robust
eststo  : reg outgroupr treat22 treat23 treat24 ageR female incomeR white rel trump college if rep == 0, robust
eststo  : reg ingroupr treat22 treat23 treat24 trump if rep == 0, robust
eststo  : reg ingroupr treat22 treat23 treat24 ageR female incomeR white rel trump college if rep == 0, robust
eststo  : reg victimr treat22 treat23 treat24 trump if rep == 0, robust
eststo  : reg victimr treat22 treat23 treat24 ageR female incomeR white rel trump college if rep == 0, robust
esttab using gic.tex, ar2 b(3) se(3) starlevels(* 0.1 ** .05 *** .01) label replace
eststo clear


*** Generate Table D7 (Potential Mediators) 
eststo  : reg immig_index treat22 treat23 treat24 trump if rep == 1, robust
eststo  : reg outgroupr treat22 treat23 treat24 trump if rep == 1, robust
eststo  : reg immig_index treat22 treat23 treat24 trump outgroupr if rep == 1, robust
eststo  : reg ingroupr treat22 treat23 treat24 trump if rep == 1, robust
eststo  : reg immig_index treat22 treat23 treat24 trump ingroupr if rep == 1, robust
eststo  : reg victimr treat22 treat23 treat24 trump if rep == 1, robust
eststo  : reg immig_index treat22 treat23 treat24 trump victimr if rep == 1, robust
eststo  : reg econ_threa2 treat22 treat23 treat24 trump if rep == 1, robust
eststo  : reg immig_index treat22 treat23 treat24 trump econ_threa2 if rep == 1, robust
esttab using mediation_rep.tex, ar2 b(3) se(3) starlevels(* 0.1 ** .05 *** .01) label replace
eststo clear


*** Mediation Checks (mentioned in text) 
gen outgroupr2 = outgroupr if rep == 1
gen ingroupr2 = ingroupr if rep == 1
gen victimr2 = victimr if rep == 1
gen econ_threa22 = econ_threa2 if rep == 1
medeff (regress outgroupr2 treat22 treat23 treat24 trump) (regress immig_index treat22 treat23 treat24 outgroupr2 trump), mediate(outgroupr2) treat(treat22) sims(1000) seed(1)
medeff (regress ingroupr2  treat22 treat23 treat24 trump) (regress immig_index treat22 treat23 treat24 ingroupr2 trump), mediate(ingroupr2) treat(treat22) sims(1000) seed(1)
medeff (regress victimr2  treat22 treat23 treat24 trump) (regress immig_index treat22 treat23 treat24 victimr2 trump), mediate(victimr2) treat(treat22) sims(1000) seed(1)
medeff (regress econ_threa22 treat22 treat23 treat24 trump) (regress immig_index treat22 treat23 treat24 econ_threa22 trump), mediate(econ_threa22) treat(treat22) sims(1000) seed(1)


*** Generate Table D8 (Victim/Asylum Seekers)
set more off
eststo  : reg percent_1 treat22 treat23 treat24 trump if rep == 1, robust
eststo  : reg percent_1 treat22 treat23 treat24 trump female incomeR white rel college if rep == 1, robust
eststo  : reg percent_2 treat22 treat23 treat24 trump if rep == 1, robust
eststo  : reg percent_2 treat22 treat23 treat24 trump female incomeR white rel college if rep == 1, robust
eststo  : reg percent_1 treat22 treat23 treat24 trump if rep == 0, robust
eststo  : reg percent_1 treat22 treat23 treat24 trump female incomeR white rel college if rep == 0, robust
eststo  : reg percent_2 treat22 treat23 treat24 trump if rep == 0, robust
eststo  : reg percent_2 treat22 treat23 treat24 trump female incomeR white rel college if rep == 0, robust
esttab using victimcount.tex, ar2 b(3) se(3) starlevels(* 0.1 ** .05 *** .01) label replace
eststo clear


*** Generate Table D9 (Support for Immigration by Education)
gen treat22_college = treat22*college
gen treat23_college = treat23*college
gen treat24_college = treat24*college

set more off
eststo  : reg immig_index treat22 treat23 treat24 college treat22_college treat23_college treat24_college trump if rep == 1, robust
eststo  : reg immig_index treat22 treat23 treat24 college treat22_college treat23_college treat24_college trump female incomeR white rel college if rep == 1, robust
eststo  : reg immig_index treat22 treat23 treat24 college treat22_college treat23_college treat24_college trump if rep == 0, robust
eststo  : reg immig_index treat22 treat23 treat24 college treat22_college treat23_college treat24_college trump female incomeR white rel college if rep == 0, robust
esttab using college_moderator.tex, ar2 b(3) se(3) starlevels(* 0.1 ** .05 *** .01) label replace
eststo clear



