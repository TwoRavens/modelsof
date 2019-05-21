** Issue Voting as a Constrained Choice Problem - Moral and Zhirnov (2017)
** Replication File (Appendix A)

clear all
* cd "/Users/mmoral/Dropbox/SUNY Binghamton PhD/Miscellaneous/-Issue Voting as a Constrained Choice Problem/AJPS Final/Replication/Analyses Code"
* cd "/home/andrei/Desktop/replication materials"

** Table A1: Policy Positions of Political Parties: Norway (1989)
use "NSD1989 v1.dta", clear

gen fchoice=100*choice
tabstat pos1 pos2 pos3 pos4 pos5 pos6 pos7 fchoice, by(party) nototal save
*ssc install tabstatmat

tabstatmat temp
matrix rownames temp=:Labour :Liberal :Center ":Christian People's" :Conservative ":Socialist Left" :Progress
matrix colnames temp="Left-right" Agriculture Environment Immigration Healthcare Alcohol Crime "Vote Share"
putexcel set "TableA1.xlsx", replace
putexcel A1=matrix(temp'), names nformat(number_d2)
putexcel clear
