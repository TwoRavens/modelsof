use "F:\Data\PeaceScience2012\attacks.dta"

set more off

****Replication for Table 2***

nbreg attks ln_totalt_1 rivalXtot rivalryt_1 ln_gdpt_1 ln_pop milregimet_1 democt_1 civwar post911 coldwar res_tot, cl(ccode)

nbreg attks_nonus ln_totalt_1 rivalXtot rivalryt_1 ln_gdpt_1 ln_pop milregimet_1 democt_1 civwar post911 coldwar res_tot, cl(ccode)

nbreg attks_us ln_totalt_1 rivalXtot rivalryt_1 ln_gdpt_1 ln_pop milregimet_1 democt_1 civwar post911 coldwar res_tot, cl(ccode)




