* Runs all programs in order for LA Finance Paper

* Paths
do x:\ReStat-Programs-Data\Programs\make_data\paths.do
************* Make Data Set ***************************************************************

*** LA_allvars.dta is made by LAdata_finance.do programs

*** LAdata_finance.do
* Makes working dataset
* Calls several other programs
do ${DO}/make_data/LAdata_finance.do
***

***  LA graphs.do
* creates Figure 1-5
do ${DO}/finance/LAgraphs.do
***

*** LAFracBlCoeff
* Creates Figures 6-8 -- trends in coefficients
do ${DO}/finance/LAFracBlCoeffs.do
***

*** LAChangRegs
* Regressions with changes on LHS
* Table 2
* Table 3
* Table 4
* Table 5
do ${DO}/finance/LAChangeRegs.do
***

*** LAmfpregs.do
* REgressions for minimum foundation program
* Appendix Table
do ${DO}/finance/LAmfpregs.do
***

*** LAchangeregs_pre
* Placebo regressions for pre-program changes
* Table 6
do ${DO}/finance/LAchangeregs_pre.do
***

*** LATable1-summstats
* Summary statistics for Table 1
* Table 1
do ${DO}/finance/LATable1-summstats.do
***

*** LACoeffTests
* tests the equality of coefficient on fraction black over time
do ${DO}/finance/LACoeffTests.do
***


