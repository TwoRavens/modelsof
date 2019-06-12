// Do File for Figures 2, 4-6
// Brian B. Crisher & Mark Souva
// Dept. of Politicaly Science, Florida State University
// bcrisher@fsu.edu msouva@fsu.edu
// "Power At Sea: A Naval Power Dataset, 1865-2011"
// International Interactions

// NOTE: Figures 1 and 3 created in R. See separate R code file 
// for replication.

*****************************
* Figure 2
*****************************

twoway (line tonn_prop year if cowcode == 200 & year >= 1870) ///
	(line tonn_prop year if cowcode == 2 & year >= 1870), ///
	xline(1941)
// manually edit in Stata graph editor

*****************************
* Figure 4
*****************************

// Heatmap
// manually edit in Stata graph editor
// Individual numbers added using Inkscape
* main correlation matrix
matrix accum R = irst milex milper pec tpop upop cinc tonn_prop totton if tonn_prop > 0, nocons dev
matrix R = corr(R)

* graph 
plotmatrix, m(R) s(0(0.10)1) c(gs7) l nodiag

*****************************
* Figure 5
*****************************

twoway (line tonn_prop year if cowcode == 2 & year >= 1946 & year <= 1991) ///
	(line tonn_prop year if cowcode == 365 & year >= 1946 & year <= 1991)
// manually edit in Stata graph editor

*****************************
* Figure 6
*****************************

twoway (line tonn_prop year if cowcode == 750 & year >= 1980) ///
	(line tonn_prop year if cowcode == 710 & year >= 1980) ///
	(line tonn_prop year if cowcode == 740 & year >= 1980) ///
	(line tonn_prop year if cowcode == 200 & year >= 1980) 
// manually edit in Stata graph editor



	