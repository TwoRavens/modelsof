use ../Data/Individual.dta, clear

replace age=age/100
replace age_sqr=age^2

foreach j in patience risktaking posrecip negrecip altruism trust{
reg `j' gender math age age_sqr i.ison,  cluster(ison)
reg `j' gender math age age_sqr i.id_region,  cluster(ison)
}




