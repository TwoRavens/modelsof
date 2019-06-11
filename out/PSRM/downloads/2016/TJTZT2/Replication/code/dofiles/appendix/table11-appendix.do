*********************************************************
*Replication material for 
*Arndt Leininger, Lukas Rudolph, Steffen Zittlau (2016): 
*"How to increase turnout in low-salience elections? Quasi-experimental evidence on the effect of concurrent second-order elections on political participation."
*Forthcoming in Political Science Research and Methods
*********************************************************

*********
**The following code reproduces Appendix Table 11 
*********


/* install estout-package by Ben Jann in Version st0085_2 (Stata Journal 14-2) via "findit st0085_2".
		st0085_2 from http://www.stata-journal.com/software/sj14-2
		SJ14-2 st0085_2. Update: Making regression... / Update: Making regression
		tables from stored / estimates / by Ben Jann, University of Bern */


use "datasets/federal_geogr_disc.dta", clear

eststo clear 

***Appendix Table 11
eststo: teffects nnmatch (to_diffbtw longitude latitude) (csoe) if (ns_nrw_bgem2==1 | ns_hes_bgem2 == 1)  & year==2014,  vce(robust) 
eststo: teffects nnmatch (to_diffbtw longitude latitude) (csoe) if (ns_nrw_bgem2==1 | ns_hes_bgem2 == 1)  & year==2009,  vce(robust) 

esttab using "output/table11-appendix.tex", se replace star( * 0.05 ** 0.01) label stats(N) ///
mtitles( "DiD EP2014 - GE2013" "DiD EP2009 - GE2009") ///
postfoot("\hline\hline" "\end{tabular}" "}"  /// 
"\\ \footnotesize{Note: The table reports Average Treatment Effects (Model 1) and placebo estimates (Model 2) for municipalities along the state border of Lower Saxony (partly municipality-level mayoral elections) with North-Rhine Westphalia (municipality level local elections) and Hessia (partly municipality-level mayoral elections) following nearest neighbour matching of treated and control units on community centroid latitude and longitude with one match per observation (robust standard errors in parentheses). * (**) indicates p < 0.05 (0.01)} ") 
