***************************************************
* Project: Two-Dimensional Trade Salience Project *
* Title:   Analysis                               *
***************************************************


clear all
cd 
use "Winter2013_working.dta"


********************************************************
* Difference in Means DV = PROPOSED POLICY (vote_sal2) *
********************************************************
* 1) Means for each conditions
mean vote_sal2 if cond1 == 1
mean vote_sal2 if cond2 == 1
mean vote_sal2 if cond3 == 1
mean vote_sal2 if cond4 == 1
  // Politically sophisticated means
mean vote_sal2_soph if cond1 == 1
mean vote_sal2_soph if cond2 == 1
mean vote_sal2_soph if cond3 == 1
mean vote_sal2_soph if cond4 == 1


* 2) T-TESTs for pairwise comparisons *
ttest vote_sal2, by(pair1)  // cond 1 & 2   -  Difference in welfare (HIGH simplicity CONSTANT)
ttest vote_sal2, by(pair2)  // cond 1 & 3   -  Difference in simplicity (Low welfare CONSTANT)
ttest vote_sal2, by(pair3)  // cond 1 & 4   -  Difference in simplicity & welfare
ttest vote_sal2, by(pair4)  // cond 2 & 3   -  Difference in simplicity & welfare
ttest vote_sal2, by(pair5)  // cond 2 & 4   -  Difference in simplicity (High welfare CONSTANT)
ttest vote_sal2, by(pair6)  // cond 3 & 4   -  Difference in welfare (LOW simplicity CONSTANT)
  // Politically sophisticated means
ttest vote_sal2_soph, by(pair1)  // cond 1 & 2   -  Difference in welfare (HIGH simplicity CONSTANT)
ttest vote_sal2_soph, by(pair2)  // cond 1 & 3   -  Difference in simplicity (Low welfare CONSTANT)
ttest vote_sal2_soph, by(pair3)  // cond 1 & 4   -  Difference in simplicity & welfare
ttest vote_sal2_soph, by(pair4)  // cond 2 & 3   -  Difference in simplicity & welfare
ttest vote_sal2_soph, by(pair5)  // cond 2 & 4   -  Difference in simplicity (High welfare CONSTANT)
ttest vote_sal2_soph, by(pair6)  // cond 3 & 4   -  Difference in welfare (LOW simplicity CONSTANT)
  // Less politically sophisticated means
ttest vote_sal2_non, by(pair1)  // cond 1 & 2   -  Difference in welfare (HIGH simplicity CONSTANT)
ttest vote_sal2_non, by(pair2)  // cond 1 & 3   -  Difference in simplicity (Low welfare CONSTANT)
ttest vote_sal2_non, by(pair3)  // cond 1 & 4   -  Difference in simplicity & welfare
ttest vote_sal2_non, by(pair4)  // cond 2 & 3   -  Difference in simplicity & welfare
ttest vote_sal2_non, by(pair5)  // cond 2 & 4   -  Difference in simplicity (High welfare CONSTANT)
ttest vote_sal2_non, by(pair6)  // cond 3 & 4   -  Difference in welfare (LOW simplicity CONSTANT)


* 3) Difference of means graphs - Rep proposed the policy (all respondents)
// The Effect of Simplicity (Low Welfare constant)
graph bar (mean) vote_sal2, over(pair2, relabel(1 "Low Complexity" 2 "High Complexity")) blabel(bar) /*
*/ bar(1, fcolor(gs7)) bargap(1) ytitle(Mean Electoral Salience) ytitle(, size(meds)) ylabel(0(.2)1, nogrid) /*
*/ title(The Effect of Complexity, size(medlarge) color(black)) caption(Conditions, /*
*/ size(med) position(6)) subtitle(Low welfare held constant) note("*One-tailed test: t(108)=4.17, p<.01") /*
*/ scheme(s2color8) graphregion(fcolor(white))
// The Effect of Welfare (cond3 vs. cond4)
graph bar (mean) vote_sal2, over(pair6, relabel(1 "Low Welfare" 2 "High Welfare")) /*
*/ blabel(bar) bar(1, fcolor(gs7)) bargap(1) ytitle(Mean Electoral Salience) ytitle(, size(meds)) ylabel(0(.2)1, nogrid) /*
*/ title(The Effect of Welfare, size(medlarge) color(black)) caption(Conditions, /*
*/ size(med) position(6)) subtitle(High complexity held constant) note("*One-tailed test: t(112)=1.92, p<.05") /*
*/ scheme(s2color8) graphregion(fcolor(white))
// The Effect of Welfare & Complexity (cond2 vs. cond3)
graph bar (mean) vote_sal2, over(pair4, relabel(1 "High Welfare/Low Complexity" 2 "Low Welfare/High Complexity")) /*
*/ blabel(bar) bar(1, fcolor(gs7)) bargap(1) ytitle(Mean Electoral Salience) ytitle(, size(meds)) ylabel(0(.2)1, nogrid) /*
*/ title(The Effect of Welfare & Complexity, size(medlarge) color(black)) caption(Conditions, /*
*/ size(med) position(6)) subtitle(Interactive effects) note("*One-tailed test: t(106)=2.91, p<.01") /*
*/ scheme(s2color8) graphregion(fcolor(white))




*********************************************************
* Difference in Means DV = Policy Effects (effects_sal) *
*********************************************************
* 1) Means of each group
mean effects_sal if cond1 == 1
mean effects_sal if cond2 == 1
mean effects_sal if cond3 == 1
mean effects_sal if cond4 == 1
  // Politically sophisticated
mean effects_sal_soph if cond1 == 1
mean effects_sal_soph if cond2 == 1
mean effects_sal_soph if cond3 == 1
mean effects_sal_soph if cond4 == 1


* 2(a) T-TESTs for pairwise comparisons *
ttest effects_sal, by(pair1)  // cond 1 & 2   -  Difference in welfare (HIGH simplicity CONSTANT)
ttest effects_sal, by(pair2)  // cond 1 & 3   -  Difference in simplicity (Low welfare CONSTANT)
ttest effects_sal, by(pair3)  // cond 1 & 4   -  Difference in simplicity & welfare
ttest effects_sal, by(pair4)  // cond 2 & 3   -  Difference in simplicity & welfare
ttest effects_sal, by(pair5)  // cond 2 & 4   -  Difference in simplicity (High welfare CONSTANT)
ttest effects_sal, by(pair6)  // cond 3 & 4   -  Difference in welfare (LOW simplicity CONSTANT)
* 2(b) T-TESTs for Sophisticated *
ttest effects_sal_soph, by(pair1)  // cond 1 & 2   -  Difference in welfare (HIGH simplicity CONSTANT)
ttest effects_sal_soph, by(pair2)  // cond 1 & 3   -  Difference in simplicity (Low welfare CONSTANT)
ttest effects_sal_soph, by(pair3)  // cond 1 & 4   -  Difference in simplicity & welfare
ttest effects_sal_soph, by(pair4)  // cond 2 & 3   -  Difference in simplicity & welfare
ttest effects_sal_soph, by(pair5)  // cond 2 & 4   -  Difference in simplicity (High welfare CONSTANT)
ttest effects_sal_soph, by(pair6)  // cond 3 & 4   -  Difference in welfare (LOW simplicity CONSTANT)
* 2(c) T-TESTs for Less Sophisticated *
ttest effects_sal_non, by(pair1)  // cond 1 & 2   -  Difference in welfare (HIGH simplicity CONSTANT)
ttest effects_sal_non, by(pair2)  // cond 1 & 3   -  Difference in simplicity (Low welfare CONSTANT)
ttest effects_sal_non, by(pair3)  // cond 1 & 4   -  Difference in simplicity & welfare
ttest effects_sal_non, by(pair4)  // cond 2 & 3   -  Difference in simplicity & welfare
ttest effects_sal_non, by(pair5)  // cond 2 & 4   -  Difference in simplicity (High welfare CONSTANT)
ttest effects_sal_non, by(pair6)  // cond 3 & 4   -  Difference in welfare (LOW simplicity CONSTANT)
