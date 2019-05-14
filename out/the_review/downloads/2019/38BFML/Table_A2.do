use "Ideology_Trump.dta", clear

*regression for average treatment by party
*republicans
areg Support contrump libtrump gopleader race_white if republican == 1 & (contrump == 1 | libtrump ==1  | gopleader == 1 | self == 1), absorb(Question) cluster(Question) 
areg Support contrump libtrump gopleader race_white if republican == 1 & (contrump == 1 | libtrump ==1  | gopleader == 1 | self == 1), absorb(Question) cluster(caseid) 

*democrats
areg Support contrump libtrump gopleader race_white if democrat == 1 & (contrump == 1 | libtrump ==1  | gopleader == 1 | self == 1), absorb(Question) cluster(Question) 
areg Support contrump libtrump gopleader race_white if democrat == 1 & (contrump == 1 | libtrump ==1  | gopleader == 1 | self == 1), absorb(Question) cluster(caseid) 

*independents
areg Support contrump libtrump gopleader race_white if democrat == 0 & republican == 0 & (contrump == 1 | libtrump ==1  | gopleader == 1 | self == 1), absorb(Question) cluster(Question) 
areg Support contrump libtrump gopleader race_white if democrat == 0 & republican == 0 & (contrump == 1 | libtrump ==1  | gopleader == 1 | self == 1), absorb(Question) cluster(caseid) 
























