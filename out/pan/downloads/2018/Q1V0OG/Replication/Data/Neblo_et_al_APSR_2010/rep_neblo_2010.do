



use "/Users/jonathanmummolo/Dropbox/Interaction Paper/Data/Included/_to_do/Neblo_et_al_APSR_2010/APSRreplication/APSRTable1Replication.dta"

regress willing treatcong2 treathour2 treatint treattop treatinc  gender2 age_ct  conflict_ct needcog_ct sunshine_ct efficacy_ct pidcoll_ct empfull white stealth2_ct needjud_ct educ_ct income_ct interest_ct chur_ct gentrust_ct intxcon conxste 


generate sample = e(sample)

drop if sample!=1

saveold rep_neblo_2010, replace
