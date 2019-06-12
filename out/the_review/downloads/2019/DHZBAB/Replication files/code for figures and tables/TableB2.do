use ILPAdataset, clear

* declarations filed 1911-1923
keep if year_dec>1910&year_dec<1924

tabstat yrsinusd age_decl waitdp lAMIc lAMId, statistics(mean sd N) columns(stats)
