gen log_secours_incendies=log( secours_incendies)
gen log_secours_inondations= log(secours_inondations)
gen log_secours_grele = log(secours_grele)
gen log_secours_gelee = log(secours_gelee)
gen log_secours_bestiaux=log(secours_bestiaux)

gen log_degrevements_incendies=log(degrevements_incendies)
gen log_degrevements_inondations= log(degrevements_inondations)
gen log_degrevements_grele = log(degrevements_grele)
gen log_degrevements_gelee = log(degrevements_gelee)
gen log_degrevements_bestiaux = log(degrevements_bestiaux)

replace log_secours_incendies=0 if log_secours_incendies==.
replace log_secours_inondations=0 if log_secours_inondations==.
replace log_secours_grele=0 if  log_secours_grele==. 
replace log_secours_gelee=0 if log_secours_gelee==. 
replace log_secours_bestiaux=0 if log_secours_bestiaux==.

replace log_degrevements_incendies=0 if log_degrevements_incendies==.
replace log_degrevements_inondations=0 if log_degrevements_inondations==.
replace log_degrevements_grele=0 if log_degrevements_grele==. 
replace log_degrevements_gelee=0 if log_degrevements_gelee ==.
replace log_degrevements_bestiaux=0 if log_degrevements_bestiaux==.


gen log_degrevements=log_degrevements_incendies+log_degrevements_inondations+log_degrevements_grele+log_degrevements_gelee
gen log_secours=log_secours_incendies+log_secours_inondations+log_secours_grele+log_secours_gelee

gen log_aid =log_secours

*gen log_aid=log_secours+log_degrevements


