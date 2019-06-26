*************************************************************
*															*
*      Tables 8 and A1, Walsh, Conrad, Whitaker & Hudak   	*
*    Funding Rebellion: The Rebel Contraband Dataset        *
*                        Stata 13                           *
*															*
*************************************************************
*Note: The two versions of model 2 are reported in Table 8 in the main paper; the remainining models are reported in Table A1 in the appendix

use "Replication data - Tables 8 and A1.dta"


*Model 1*
*SSW original model*
nbreg rebbest support war loot lngov tc fightmod laglnpop democ duration lagreb2010, nolog cluster(dyad)
gen sample = e(sample)
*SSW original model substituting Rebel Contraband measure for loot*
nbreg rebbest support war rc_loot lngov tc fightmod laglnpop democ duration lagreb2010 if sample == 1, nolog cluster(dyad)
drop sample

*Model 2 (these results are reported as table 8 in the main manuscript)*
*SSW original model*
nbreg rebbest support democ_supdum war loot lngov tc fightmod laglnpop democ duration lagreb2010, nolog cluster(dyad)
gen sample = e(sample)
*SSW original model substituting Rebel Contraband measure for loot*
nbreg rebbest support democ_supdum war rc_loot lngov tc fightmod laglnpop democ duration lagreb2010 if sample == 1, nolog cluster(dyad)
drop sample

*Model 3*
*SSW original model*
nbreg rebbest support perc_dem war loot lngov tc fightmod laglnpop democ duration lagreb2010, nolog cluster(dyad)
gen sample = e(sample)
*SSW original model substituting Rebel Contraband measure for loot*
nbreg rebbest support perc_dem war rc_loot lngov tc fightmod laglnpop democ duration lagreb2010 if sample == 1, nolog cluster(dyad)
drop sample

*Model 4*
*SSW original model*
nbreg rebbest num_supp war loot lngov tc fightmod laglnpop democ duration lagreb2010, nolog cluster(dyad)
gen sample = e(sample)
*SSW original model substituting Rebel Contraband measure for loot*
nbreg rebbest num_supp war rc_loot lngov tc fightmod laglnpop democ duration lagreb2010 if sample == 1, nolog cluster(dyad)
drop sample

*Model 5*
*SSW original model*
nbreg rebbest num_supp perc_dem war loot lngov tc fightmod laglnpop democ duration lagreb2010, nolog cluster(dyad)
gen sample = e(sample)
*SSW original model substituting Rebel Contraband measure for loot*
nbreg rebbest num_supp perc_dem war rc_loot lngov tc fightmod laglnpop democ duration lagreb2010 if sample == 1, nolog cluster(dyad)
drop sample

*Model 6*
*SSW original model*
nbreg rebbest c.perc_dem  c.num_sup c.perc_dem#c.num_sup war loot lngov tc fightmod laglnpop democ duration lagreb2010, nolog cluster(dyad)
gen sample = e(sample)
*SSW original model substituting Rebel Contraband measure for loot*
nbreg rebbest c.perc_dem  c.num_sup c.perc_dem#c.num_sup war rc_loot lngov tc fightmod laglnpop democ duration lagreb2010 if sample == 1, nolog cluster(dyad)
drop sample

exit
