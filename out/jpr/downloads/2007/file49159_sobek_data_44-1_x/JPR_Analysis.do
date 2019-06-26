clear
set mem 250m
use "C:\Documents and Settings\David Sobek\My Documents\Work Folder\Rally_Podesta\JPR_data2.dta", clear


log using "C:\Documents and Settings\David Sobek\My Documents\Work Folder\Rally_Podesta\JPR_analysis.log", replace


set matsize 250

sort dyadid year
iis dyadid
tis year

************************************
*This examines the entire data set *
************************************

xtprobit War_init regime_a demlow  linten_a  intensity_a linten_b intensity_b regimech_a lregch_a  regimech_b lregch_b caprat pwin prefsim contig peaceyears _spline1 _spline2 _spline3, nolog


*********************************************************************
*This examines the data by republican score of the challenger**
*********************************************************************
sort republic_a dyadid year

by republic_a: xtprobit War_init regime_b linten_a  intensity_a linten_b intensity_b   regimech_a lregch_a  regimech_b lregch_b caprat pwin prefsim contig peaceyears _spline1 _spline2 _spline3, nolog

*********************************************************************
*Below is a set of additional analyses that limit the number     **
*of IVs.  This hopefully gives a better view of the effect of the   **
*more important causal variables.                                              **
*********************************************************************
by republic_a: xtprobit War_init regime_b linten_a lregch_a  lregch_b caprat pwin prefsim contig peaceyears _spline1 _spline2 _spline3, nolog
by republic_a: xtprobit War_init linten_a lregch_a  lregch_b caprat pwin prefsim contig peaceyears _spline1 _spline2 _spline3, nolog
by republic_a: xtprobit War_init linten_a lregch_a  lregch_b caprat pwin prefsim contig  y1352  peaceyears _spline1 _spline2 _spline3, nolog

******************************************************************************
**The following analyses were mentioned in the paper but not reported**
******************************************************************************
**The following tests to see if a dichotomous measure of unrest changes the results**
sort dyadid year
xtprobit War_init regime_a demlow  Dist_a  lagdist_a Dist_b  lagdist_b regimech_a lregch_a  regimech_b lregch_b caprat pwin prefsim contig peaceyears _spline1 _spline2 _spline3, nolog

sort republic_a dyadid year
by republic_a: xtprobit War_init regime_b Dist_a  lagdist_a Dist_b  lagdist_b  regimech_a lregch_a  regimech_b lregch_b caprat pwin prefsim contig peaceyears _spline1 _spline2 _spline3, nolog


**The following tests different thresholds for the dichotomous republican measure**
sort repub_a_2 dyadid year 
by repub_a_2: xtprobit War_init regime_b linten_a  intensity_a linten_b intensity_b   regimech_a lregch_a  regimech_b lregch_b caprat pwin prefsim contig peaceyears _spline1 _spline2 _spline3, nolog

sort repub_a_3 dyadid year 
by repub_a_3: xtprobit War_init regime_b linten_a  intensity_a linten_b intensity_b   regimech_a lregch_a  regimech_b lregch_b caprat pwin prefsim contig peaceyears _spline1 _spline2 _spline3, nolog

**The following tests to see if the results are sensitive to the exclusion of the regime change variables**
sort dyadid year
xtprobit War_init regime_a demlow  linten_a  intensity_a linten_b intensity_b caprat pwin prefsim contig peaceyears _spline1 _spline2 _spline3, nolog

sort republic_a dyadid year
by republic_a: xtprobit War_init regime_b linten_a  intensity_a linten_b intensity_b caprat pwin prefsim contig peaceyears _spline1 _spline2 _spline3, nolog

**The following tests to see if the results are sensitive to the lags in the regime change variables**
sort dyadid year
xtprobit War_init regime_a demlow  linten_a  intensity_a linten_b intensity_b regch_a_10 regch_b_10 caprat pwin prefsim contig peaceyears _spline1 _spline2 _spline3, nolog

sort republic_a dyadid year
by republic_a: xtprobit War_init regime_b linten_a  intensity_a linten_b intensity_b regch_a_10 regch_b_10 caprat pwin prefsim contig peaceyears _spline1 _spline2 _spline3, nolog

log close 
clear
