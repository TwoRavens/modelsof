Armed conflict incidence

Models with population size

logit incidenc demcentr demsqcen cen_prx1 gdp_cen pop_cen ef_cen oil pgr_cen warz asia mena ssafr lat contigoc peac_cen spl1_cen spl2_cen spl3_cen, cl(ccode)

outreg using table1.rtf , nolabel 3aster replace


logit incidenc demcentr demsqcen cen_prx1 gdp_cen pop_cen ef_cen oil denscen warz asia mena ssafr lat contigoc peac_cen spl1_cen spl2_cen spl3_cen, cl(ccode)


outreg using table1.rtf , nolabel 3aster append


logit incidenc demcentr demsqcen   cen_prx1 gdp_cen pop_cen ef_cen oil middlela highland warz asia mena ssafr lat contigoc peac_cen spl1_cen spl2_cen spl3_cen, cl(ccode)


outreg using table1.rtf , nolabel 3aster append


logit incidenc demcentr demsqcen   cen_prx1 gdp_cen pop_cen ef_cen oil descen warz asia mena ssafr lat contigoc peac_cen spl1_cen spl2_cen spl3_cen, cl(ccode)


outreg using table1.rtf , nolabel 3aster append


logit incidenc demcentr demsqcen   cen_prx1 gdp_cen pop_cen ef_cen oil drought1 warz asia mena ssafr lat contigoc peac_cen spl1_cen spl2_cen spl3_cen, cl(ccode)


outreg using table1.rtf , nolabel 3aster append


logit incidenc demcentr demsqcen   cen_prx1 gdp_cen pop_cen ef_cen oil wat_rev warz asia mena ssafr lat contigoc peac_cen spl1_cen spl2_cen spl3_cen, cl(ccode)


outreg using table1.rtf , nolabel 3aster append



Models without population size

logit incidenc demcentr demsqcen   cen_prx1 gdp_cen  ef_cen oil pgr_cen warz asia mena ssafr lat contigoc peac_cen spl1_cen spl2_cen spl3_cen, cl(ccode)


outreg using table1.rtf , nolabel 3aster replace


logit incidenc demcentr demsqcen   cen_prx1 gdp_cen  ef_cen oil denscen warz asia mena ssafr lat contigoc peac_cen spl1_cen spl2_cen spl3_cen, cl(ccode)


outreg using table1.rtf , nolabel 3aster append



logit incidenc demcentr demsqcen   cen_prx1 gdp_cen  ef_cen oil middlela highland warz asia mena ssafr lat contigoc peac_cen spl1_cen spl2_cen spl3_cen, cl(ccode)

outreg using table1.rtf , nolabel 3aster append



logit incidenc demcentr demsqcen   cen_prx1 gdp_cen  ef_cen oil drought1 warz asia mena ssafr lat contigoc peac_cen spl1_cen spl2_cen spl3_cen, cl(ccode)

outreg using table1.rtf , nolabel 3aster append


logit incidenc demcentr demsqcen   cen_prx1 gdp_cen  ef_cen oil wat_rev warz asia mena ssafr lat contigoc peac_cen spl1_cen spl2_cen spl3_cen, cl(ccode)


outreg using table1.rtf , nolabel 3aster append




Armed conflict onset

Models with population size

***Before analyzing:

tsset ccode year

***Model 5, Table III

logit onset demcentr demsqcen   cen_prx1 gdp_cen pop_cen ef_cen oil pgr_cen confinci contigoc peac_cen, cl(ccode)

outreg using table1.rtf , nolabel 3aster replace

***Model 6, Table III

logit onset demcentr demsqcen   cen_prx1 gdp_cen pop_cen ef_cen oil denscen confinci contigoc peac_cen, cl(ccode)

outreg using table1.rtf , nolabel 3aster append

***Model 7, Table III

logit onset demcentr demsqcen cen_prx1 gdp_cen pop_cen ef_cen oil middlela highland confinci contigoc peac_cen, cl(ccode)

outreg using table1.rtf , nolabel 3aster append

***Model 8, Table III

logit onset demcentr demsqcen cen_prx1 gdp_cen pop_cen ef_cen oil drought1 confinci contigoc peac_cen, cl(ccode)

outreg using table1.rtf , nolabel 3aster append

***Model 9, Table III

logit onset demcentr demsqcen   cen_prx1 gdp_cen pop_cen ef_cen oil wat_rev confinci contigoc peac_cen, cl(ccode)

outreg using table1.rtf , nolabel 3aster append





Models minus population size

logit onset demcentr demsqcen   cen_prx1 gdp_cen  ef_cen oil pgr_cen confinci contigoc peac_cen, cl(ccode)

outreg using table1.rtf , nolabel 3aster replace


logit onset demcentr demsqcen   cen_prx1 gdp_cen  ef_cen oil denscen confinci contigoc peac_cen, cl(ccode)

outreg using table1.rtf , nolabel 3aster append



logit onset demcentr demsqcen   cen_prx1 gdp_cen  ef_cen oil middlela highland confinci contigoc peac_cen, cl(ccode)

outreg using table1.rtf , nolabel 3aster append



logit onset demcentr demsqcen   cen_prx1 gdp_cen  ef_cen oil drought1 confinci contigoc peac_cen, cl(ccode)

outreg using table1.rtf , nolabel 3aster append


logit onset demcentr demsqcen   cen_prx1 gdp_cen  ef_cen oil wat_rev confinci contigoc peac_cen, cl(ccode)

outreg using table1.rtf , nolabel 3aster append



ESTIMATED PROBABILITIES (cluster function cannot be used, but does only affect standard errors, not substantive impact)

estsimp logit onset demcentr demsqcen   cen_prx1 gdp_cen pop_cen ef_cen oil middlela highland confinci contigoc peac_cen


setx mean


setx middlela 0 highlan 0 oil 0 confinc 0 contigoc 0
