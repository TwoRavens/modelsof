eststo clear
eststo: reg tradescaleN female col2I col4I gradI incomeV3 unionBV2 age repIV4 demIV4 minorityB unempB  [pw=weight2]
eststo: reg tradescaleN female col2I col4I gradI incomeV3 unionBV2 age repIV4 demIV4 minorityB unempB ln_xorient06oV2 ln_iorient06oV2 a_wage_o  [pw=weight2]
eststo: reg tradescaleN female col2I col4I gradI incomeV3 unionBV2 age repIV4 demIV4 minorityB unempB ln_xorient06oV2 ln_iorient06oV2 a_wage_o z_procompN  [pw=weight2]
eststo: reg tradescaleN female col2I col4I gradI incomeV3 unionBV2 age repIV4 demIV4 minorityB unempB ln_xorient06oV2 ln_iorient06oV2 a_wage_o reloN [pw=weight2]
eststo: reg tradescaleN female col2I col4I gradI incomeV3 unionBV2 age repIV4 demIV4 minorityB unempB ln_xorient06oV2 ln_iorient06oV2 a_wage_o z_isolationN [pw=weight2]
eststo: reg tradescaleN female col2I col4I gradI incomeV3 unionBV2 age repIV4 demIV4 minorityB unempB ln_xorient06oV2 ln_iorient06oV2 a_wage_o tookeconB [pw=weight2]

esttab using Table1_032212.rtf, title(Explaining Gender Differences in Trade Attitudes) replace label nodepvar nonumber not b(%9.3f) se (%9.3f) r2(%9.3f) ar2(%9.3f) starlevels(# .10 * .05 ** .01 *** .001)

eststo clear
eststo: reg tradescaleN female col2I col4I gradI incomeV3 unionBV2 age repIV4 demIV4 minorityB unempB ln_xorient06oV2 ln_iorient06oV2 a_wage_o econgoodB [pw=weight2]
eststo: reg tradescaleN female col2I col4I gradI incomeV3 unionBV2 age repIV4 demIV4 minorityB unempB ln_xorient06oV2 ln_iorient06oV2 a_wage_o tookeconB z_procompN reloN econgoodB [pw=weight2]
eststo: reg tradescaleN female col2I col4I gradI incomeV3 unionBV2 age repIV4 demIV4 minorityB unempB ln_xorient06oV2 ln_iorient06oV2 a_wage_o tookeconB z_procompN reloN z_isolationN[pw=weight2]
eststo: reg tradescaleN female col2I col4I gradI incomeV3 unionBV2 age repIV4 demIV4 minorityB unempB ln_xorient06oV2 ln_iorient06oV2 a_wage_o tookeconB z_procompN reloN z_isolationN econgoodB[pw=weight2]

esttab using Table2_032212.rtf, title(Explaining Gender Differences in Trade Attitudes) replace label nodepvar nonumber not b(%9.3f) se (%9.3f) r2(%9.3f) ar2(%9.3f) starlevels(# .10 * .05 ** .01 *** .001)

eststo clear
eststo: reg z_marketconN female col2I col4I gradI incomeV3 unionBV2 age repIV4 demIV4 minorityB unempB [pw=weight2]
eststo: reg z_marketconN female col2I col4I gradI incomeV3 unionBV2 age repIV4 demIV4 minorityB unempB ln_xorient06oV2 ln_iorient06oV2 a_wage_o [pw=weight2]
eststo: reg z_marketconN female col2I col4I gradI incomeV3 unionBV2 age repIV4 demIV4 minorityB unempB ln_xorient06oV2 ln_iorient06oV2 a_wage_o z_procompN reloN z_isolationN [pw=weight2]

esttab using MarketCon.rtf, title(Explaining Gender Differences in Belief in Free Markets) replace label nodepvar nonumber not b(%9.3f) se (%9.3f) r2(%9.3f) ar2(%9.3f) starlevels(# .10 * .05 ** .01 *** .001)  
