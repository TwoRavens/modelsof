*
* models.do
* Fits comparison model (Figure 7)
* Factor scores FE and factor scores RE models


use "data.dta"

// reshape back to wide form
reshape wide y, j(item) i(id)

// save factor scores
factor y1 y2 y3, ml fac(1)
predict fscore

// country fixed effects, robust se
xi: reg fscore complfs inc lrpos pemploy unemploy selfemploy noemploy union informed age female  i.cntryn, robust
est sto fs_regfe

// country random effects
xtreg fscore complfs inc lrpos pemploy unemploy selfemploy noemploy union informed age female, i(cntryn)
est sto fs_regre

// table of results
estout fs_regfe,cells(b se)
estout fs_regre,cells(b se)


// ==> coefficients put in Figures/figure7_data.csv for plot


