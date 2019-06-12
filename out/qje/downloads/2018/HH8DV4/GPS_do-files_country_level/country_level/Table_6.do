use ../Data/Country.dta, clear

foreach i in patience risktaking posrecip negrecip altruism trust{
pwcorr `i' geo_conditions abslat ASIPost1500Ex_aa CSIPost1500Ex_aa bio_conditions, sig
}

foreach i in patience risktaking posrecip negrecip altruism trust{
pwcorr `i' mean_prediction nopndrop_wals_w reli_b_prot_2000 hofstede_idv family_ties_pca, sig
}
