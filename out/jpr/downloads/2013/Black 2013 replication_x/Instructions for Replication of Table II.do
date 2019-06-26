**************************************
*Replication of Table II*
**************************************

** For the three right-hand columns, refer to the "full" and "country-year" versions of my substate conflict contagion dataset (both in Microsoft Excel format). Filter by year and contiguity as needed to replicate numerators and demoninators. Columns 2-4 (from the left) are replicated below. **

** Buhaug and Gleditsch (2008) -- using, from their replication files, hb_ksg_replication.dta **

** Demoninator **

count if ncivwar == 1

** Numerator **

count if ncivwar == 1 &  allons3 == 1

** Forsberg (2008) -- using, from my article's set of replication files, REVISED_2 Replication of Forsberg 2008.dta **

** Denominator **

count if beconset == 0 | beconset == 1

** Numerator **

count if beconset == 1

** Braithwaite (2010) -- using, from his replication files, Braith_statecap_JPR.dta **

** Denominator **

count if ncivwar == 1 & year>=1960

** Numerator **

count if ncivwar == 1 & year>=1960 & allons3 == 1

** Beardsley (2011) -- using, from his replication files, diffusion-replication_data-modified_prevpko_beardsley11.dta **

** Denominator -- note that the | (or) connector is used rather than the & (and) connector, because a state may be adjacent to multiple states in intrastate conflict (one or more with a PKO, one or more without a PKO) **

count if intrab_pkob_any == 1 | intrab_nopkob_any == 1

** Numerator **

sum onsetintraa if intrab_pkob_any == 1 | intrab_nopkob_any == 1

** Multiply Obs (37473) by Mean (0.0066181) to get 248 onset observations **



