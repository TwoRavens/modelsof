
Citation: Urdal, Henrik & Chi Primus Che. (2013) 'War and Gender Inequalities in Health: The Impact of Armed Conflict on Fertility and Maternal Mortality'. International Interactions 39(forthcoming): xx-xx.


xtset ssno year


* TFR
xtreg tfr td75 td80 td85 td90 td95 td00 td05 totpopln lnbdeadbest1_5 lneiconf_5, fe
xtreg tfr td75 td80 td85 td90 td95 td00 td05 imrln ln_rgdpchpenn urbanisation totpopln lnbdeadbest1_5 lneiconf_5, fe
xtreg tfr td75 td80 td85 td90 td95 td00 td05 imrln urbanisation totpopln gdppcinv gdppcinv_bdeaths bdeaths_c lneiconf_5, fe
xtreg tfr td75 td80 td85 td90 td95 td00 td05 imrln ln_rgdpchpenn urbanisation totpopln pct_f_secplus_20_24  lnbdeadbest1_5 lneiconf_5, fe


disp "R2 =" 1 - e(rss)/e(tss)
disp "adj R2 =" 1 -(e(rss)/e(df_r))/(e(tss)/(e(N) -1))


* MMR
xtreg mmr_ln td95 td00 td05 totpopln lnbdeadbest1_5 lneiconf_5, fe
xtreg mmr_ln td95 td00 td05 ln_rgdpchpenn urbanisation totpopln lnbdeadbest1_5 lneiconf_5, fe
xtreg mmr_ln td95 td00 td05 urbanisation totpopln gdppcinv gdppcinv_bdeaths bdeaths_c lneiconf_5, fe
xtreg mmr_ln td95 td00 ln_rgdpchpenn urbanisation totpopln hiv_est_rev_lag lnbdeadbest1_5 lneiconf_5, fe


* descriptive stats
sum tfr mmr mmr_ln imrln ln_rgdpchpenn urbanisation totpopln pct_f_secplus_20_24 hiv_est_rev lnbdeadbest1_5 lneiconf_5 

pwcorr tfr mmr mmr_ln imrln ln_rgdpchpenn urbanisation totpopln pct_f_secplus_20_24 hiv_est_rev lnbdeadbest1_5 lneiconf_5 
pwcorr imrln ln_rgdpchpenn urbanisation pct_f_secplus_20_24 



** ADDITIONAL TESTS

*ADDITIONAL TESTS USING BINARY CONFLICT VAR
* TFR: ALL CONFLICTS
xtreg tfr td75 td80 td85 td90 td95 td00 td05 td08 totpopln conflict_5yrper_lag if year>=1970, fe
xtreg tfr td75 td80 td85 td90 td95 td00 td05 td08 imrln ln_rgdpchpenn urbanisation totpopln conflict_5yrper_lag if year>=1970, fe
* TFR: WARS ONLY
xtreg tfr td75 td80 td85 td90 td95 td00 td05 td08 totpopln war_5yrper_lag if year>=1970, fe
xtreg tfr td75 td80 td85 td90 td95 td00 td05 td08 imrln ln_rgdpchpenn urbanisation totpopln war_5yrper_lag if year>=1970, fe
* MMR: ALL CONFLICTS
xtreg mmr_ln td95 td00 td05 totpopln conflict_5yrper_lag if year>=1970, fe
xtreg mmr_ln td95 td00 td05 ln_rgdpchpenn urbanisation totpopln conflict_5yrper_lag if year>=1970, fe
xtreg mmr_ln td95 td00 td05 ln_rgdpchpenn urbanisation totpopln hiv_est_rev_lag conflict_5yrper_lag if year>=1970, fe
* MMR: WARS ONLY
xtreg mmr_ln td95 td00 td05 totpopln war_5yrper_lag if year>=1970, fe
xtreg mmr_ln td95 td00 td05 ln_rgdpchpenn urbanisation totpopln war_5yrper_lag if year>=1970, fe
xtreg mmr_ln td95 td00 td05 ln_rgdpchpenn urbanisation hiv_est_rev_lag totpopln war_5yrper_lag if year>=1970, fe

* Alternative specifications of the battledeaths models:
xtreg mmr_ln td95 td00 td05 ln_rgdpchpenn urbanisation totpopln hiv_est_rev_lag pct_f_secplus_20_24 lnbdeadbest1_5 lneiconf_5, fe


* MODELS USING A BINARY NEIGHBORING CONFLICT MEASURE
gen neighcon_5_new=1 if lneiconf_5>0
replace neighcon_5_new=0 if lneiconf_5==0
replace neighcon_5_new=. if lneiconf_5==. 

* TFR
xtreg tfr td75 td80 td85 td90 td95 td00 td05 totpopln lnbdeadbest1_5 neighcon_5_new, fe
xtreg tfr td75 td80 td85 td90 td95 td00 td05 imrln ln_rgdpchpenn urbanisation totpopln lnbdeadbest1_5 neighcon_5_new, fe
xtreg tfr td75 td80 td85 td90 td95 td00 td05 imrln urbanisation totpopln gdppcinv gdppcinv_bdeaths bdeaths_c neighcon_5_new, fe
xtreg tfr td75 td80 td85 td90 td95 td00 td05 imrln ln_rgdpchpenn urbanisation totpopln pct_f_secplus_20_24  lnbdeadbest1_5 neighcon_5_new, fe

* MMR
xtreg mmr_ln td95 td00 td05 totpopln lnbdeadbest1_5 neighcon_5_new, fe
xtreg mmr_ln td95 td00 td05 ln_rgdpchpenn urbanisation totpopln lnbdeadbest1_5 neighcon_5_new, fe
xtreg mmr_ln td95 td00 td05 urbanisation totpopln gdppcinv gdppcinv_bdeaths bdeaths_c neighcon_5_new, fe
xtreg mmr_ln td95 td00 ln_rgdpchpenn urbanisation totpopln hiv_est_rev_lag lnbdeadbest1_5 neighcon_5_new, fe

