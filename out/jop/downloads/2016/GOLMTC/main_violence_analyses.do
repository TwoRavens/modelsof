cd "C:\Users\Daniel de Kadt\Dropbox (Personal)\Projects\SA_cohort_effects\replication"

use "C:\Users\Daniel de Kadt\Dropbox (Personal)\Projects\SA_cohort_effects\replication\violence_data.dta", clear

eststo clear
eststo: quietly areg turnout violence if year==1999, absorb(cat_b) cluster(cat_b)
eststo: quietly areg turnout violence if year==2004, absorb(cat_b) cluster(cat_b)
eststo: quietly areg turnout violence if year==2009, absorb(cat_b) cluster(cat_b)
	esttab using "violence.tex", se r2 label title(Violence in 1994 and Future Turnout \label{spatial_turnout}) addnote("Standard errors clustered by municipality in parentheses") keep(violence) star(+ 0.10 * 0.05 ** 0.01 *** 0.001) replace
	eststo clear
