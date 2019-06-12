** Issue Voting as a Constrained Choice Problem - Moral and Zhirnov (2017)
** Replication File (Appendix B)

clear all
* cd "/Users/mmoral/Dropbox/SUNY Binghamton PhD/Miscellaneous/-Issue Voting as a Constrained Choice Problem/AJPS Final/Replication/Analyses Code"
* cd "/home/andrei/Desktop/replication materials"
  
** Table A2: Summary Statistics
use "NSD1989 v1.dta", clear

*ssc install sutex

order chprox* chdir* constvar*,sequential
lab var choice "Choice"
lab var chprox1 "Squared Distance (Left-Right)"
lab var chprox2 "Squared Distance (Agriculture)"
lab var chprox3 "Squared Distance (Environment)"
lab var chprox4 "Squared Distance (Immigration)"
lab var chprox5 "Squared Distance (Health Care)"
lab var chprox6 "Squared Distance (Prohibition)"
lab var chprox7 "Squared Distance (Crime)"
lab var chdir1 "Scalar Product (Left-Right)"
lab var chdir2 "Scalar Product (Agriculture)"
lab var chdir3 "Scalar Product (Environment)"
lab var chdir4 "Scalar Product (Immigration)"
lab var chdir5 "Scalar Product (Health Care)"
lab var chdir6 "Scalar Product (Prohibition)"
lab var chdir7 "Scalar Product (Crime)"
lab var constvar1 "Electoral Viability"
lab var constvar2 "Policy Extremity"
lab var constvar3 "Strong Affinity to Another Party"
sutex choice chprox* chdir* constvar*, labels minmax nobs file(TableA2.tex) replace
