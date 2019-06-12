* REPLICATION DATA FOR GUDRUN ØSTBY, RAGNHILD NORDÅS & JAN KETIL RØD 
* REGIONAL INEQUALITIES AND CIVIL CONFLICT IN SUB-SAHARAN AFRICA 
* INTERNATIONAL STUDIES QUARTERLY

* SYNTAX FOR ANALYSES REPORTED IN ONLINE APPENDIX

set more off


****** Appendix C: Models with Restricted Sample

*generating filters (filter=year of survey + consecutive years; filter2=consecutive years only)

gen surv_yr=.
replace surv_yr=	1995	 if gwno==	432
replace surv_yr=	1992	 if gwno==	433
replace surv_yr=	1996	 if gwno==	434
replace surv_yr=	1992	 if gwno==	436
replace surv_yr=	1994	 if gwno==	437
replace surv_yr=	1999	 if gwno==	438
replace surv_yr=	1992	 if gwno==	439
replace surv_yr=	1986	 if gwno==	450
replace surv_yr=	1993	 if gwno==	452
replace surv_yr=	1998	 if gwno==	461
replace surv_yr=	1998	 if gwno==	471
replace surv_yr=	1990	 if gwno==	475
replace surv_yr=	1994	 if gwno==	482
replace surv_yr=	1996	 if gwno==	483
replace surv_yr=	2000	 if gwno==  500
replace surv_yr=	1998	 if gwno==	501
replace surv_yr=	1999	 if gwno==	510
replace surv_yr=	1992	 if gwno==	530
replace surv_yr=	1999	 if gwno==	552
replace surv_yr=	2000	 if gwno==	553
replace surv_yr=	2000	 if gwno==	565
replace surv_yr=	1997	 if gwno==	580

gen filter=1
replace filter=0 if year<surv_yr
gen filter2=1
replace filter2=0 if year<surv_yr
replace filter2=0 if year==surv_yr

*Re-analysing models with filter



*** TABLE C1, restricted sample
* Model C1
logit onset_use lag_ln_dist2cic lag_ln_dist2cinc intbnd pop_use_ln ethdiff dia_sec peton_use ///
  peaceyrs _spline* if filter==1, robust cl(gwno)

* Model C2 
logit onset_use lag_ln_dist2cic lag_ln_dist2cinc intbnd pop_use_ln ethdiff dia_sec peton_use  ///
  peaceyrs _spline* asset if filter==1, robust cl(gwno)

* Model C3 
logit onset_use lag_ln_dist2cic lag_ln_dist2cinc intbnd pop_use_ln ethdiff dia_sec peton_use ///
  peaceyrs _spline* education if filter==1, robust cl(gwno) 



*** TABLE C2, restricted sample 
* Model C4
logit onset_use lag_ln_dist2cic lag_ln_dist2cinc intbnd pop_use_ln ethdiff dia_sec peton_use ///
  peaceyrs _spline* rdrgas if filter==1, robust cl(gwno)

* Model C5 
logit onset_use lag_ln_dist2cic lag_ln_dist2cinc intbnd pop_use_ln ethdiff dia_sec peton_use ///
  peaceyrs _spline* rdrged if filter==1, robust cl(gwno)

* Model C6 
logit onset_use lag_ln_dist2cic lag_ln_dist2cinc intbnd pop_use_ln ethdiff dia_sec peton_use ///
  peaceyrs _spline* rdrgas_c rdrgas2_c if filter==1, robust cl(gwno)

* Model C7 
logit onset_use lag_ln_dist2cic lag_ln_dist2cinc intbnd pop_use_ln ethdiff dia_sec peton_use ///
  peaceyrs _spline* rdrged_c rdrged2_c if filter==1, robust cl(gwno) 



*** TABLE C3, restricted sample
* Model C8
logit onset_use lag_ln_dist2cic lag_ln_dist2cinc intbnd pop_use_ln ethdiff dia_sec peton_use ///
  peaceyrs _spline* asset_gini if filter==1, robust cl(gwno) 

* Model C9
logit onset_use lag_ln_dist2cic lag_ln_dist2cinc intbnd pop_use_ln ethdiff dia_sec peton_use ///
  peaceyrs _spline* education_gini if filter==1, robust cl(gwno)

* Model C10 
logit onset_use lag_ln_dist2cic lag_ln_dist2cinc intbnd pop_use_ln ethdiff dia_sec peton_use ///
  peaceyrs _spline* elf_reg if filter==1, robust cl(gwno) 

* Model C11
logit onset_use lag_ln_dist2cic lag_ln_dist2cinc intbnd pop_use_ln ethdiff dia_sec peton_use ///
  peaceyrs _spline* education_gini asset_gini elf_reg if filter==1, robust cl(gwno) 



*** TABLE C4, restricted sample
* Model C12
logit onset_use lag_ln_dist2cic lag_ln_dist2cinc intbnd pop_use_ln ethdiff ///
  peaceyrs _spline* dia_sec rdrgas_c rdrgas_dia if filter==1, robust cl(gwno)

* Model C13
logit onset_use lag_ln_dist2cic lag_ln_dist2cinc intbnd pop_use_ln ethdiff ///
  peaceyrs _spline* peton_use  rdrgas_c rdrgas_pet if filter==1, robust cl(gwno)

* Model C4
logit onset_use lag_ln_dist2cic lag_ln_dist2cinc intbnd pop_use_ln ethdiff ///
  peaceyrs _spline* nr_c  rdrgas_c rdrgas_nr if filter==1, robust cl(gwno) 






****** Appendix D: Random effects

xtset fid_1



*** TABLE D1, random effects
* Model D1
xtlogit onset_use lag_ln_dist2cic lag_ln_dist2cinc intbnd pop_use_ln ethdiff dia_sec peton_use ///
  peaceyrs _spline*, i(fid_1) re 

* Model D2
xtlogit onset_use lag_ln_dist2cic lag_ln_dist2cinc intbnd pop_use_ln ethdiff dia_sec peton_use  ///
  peaceyrs _spline* asset, i(fid_1) re 

* Model D3
xtlogit onset_use lag_ln_dist2cic lag_ln_dist2cinc intbnd pop_use_ln ethdiff dia_sec peton_use ///
  peaceyrs _spline* education, i(fid_1) re 



*** TABLE D2, random effects
* Model D4
xtlogit onset_use lag_ln_dist2cic lag_ln_dist2cinc intbnd pop_use_ln ethdiff dia_sec peton_use ///
  peaceyrs _spline* rdrgas, i(fid_1) re 

* Model D5
xtlogit onset_use lag_ln_dist2cic lag_ln_dist2cinc intbnd pop_use_ln ethdiff dia_sec peton_use ///
  peaceyrs _spline* rdrged, i(fid_1) re 

* Model D6
xtlogit onset_use lag_ln_dist2cic lag_ln_dist2cinc intbnd pop_use_ln ethdiff dia_sec peton_use ///
  peaceyrs _spline* rdrgas_c rdrgas2_c, i(fid_1) re 

* Model D7
xtlogit onset_use lag_ln_dist2cinc lag_ln_dist2cic intbnd pop_use_ln ethdiff dia_sec peton_use ///
  peaceyrs _spline* rdrged_c rdrged2_c, i(fid_1) re 



*** TABLE D3, random effects
* Model D8
xtlogit onset_use lag_ln_dist2cic lag_ln_dist2cinc intbnd pop_use_ln ethdiff dia_sec peton_use ///
  peaceyrs _spline* asset_gini, i(fid_1) re 

* Model D9
xtlogit onset_use lag_ln_dist2cic lag_ln_dist2cinc intbnd pop_use_ln ethdiff dia_sec peton_use ///
  peaceyrs _spline* education_gini, i(fid_1) re 

* Model D10
xtlogit onset_use lag_ln_dist2cic lag_ln_dist2cinc intbnd pop_use_ln ethdiff dia_sec peton_use ///
  peaceyrs _spline* elf_reg, i(fid_1) re

* Model D11
xtlogit onset_use lag_ln_dist2cic lag_ln_dist2cinc intbnd pop_use_ln ethdiff dia_sec peton_use ///
  peaceyrs _spline* education_gini asset_gini elf_reg, i(fid_1) re 



*** TABLE D4, random effects
* Model D12
xtlogit onset_use lag_ln_dist2cic lag_ln_dist2cinc intbnd pop_use_ln ethdiff ///
  peaceyrs _spline* dia_sec rdrgas_c rdrgas_dia, i(fid_1) re

* Model D13
xtlogit onset_use lag_ln_dist2cic lag_ln_dist2cinc intbnd pop_use_ln ethdiff ///
  peaceyrs _spline* peton_use  rdrgas_c rdrgas_pet, i(fid_1) re

* Model D14
xtlogit onset_use lag_ln_dist2cic lag_ln_dist2cinc intbnd pop_use_ln ethdiff ///
  peaceyrs _spline* nr_c  rdrgas_c rdrgas_nr, i(fid_1) re 





****** Appendix E: Adding Country-Level Controls

*** TABLE E1, Adding country level controls
* Model E1
logit onset_use lag_ln_dist2cic lag_ln_dist2cinc intbnd pop_use_ln ethdiff dia_sec peton_use ///
  peaceyrs _spline* ln_lag_gdppc  lag_growth lag_polity2 lag_polity2_sq ln_pop_ssno , robust cl(gwno)

* Model E2
logit onset_use lag_ln_dist2cic lag_ln_dist2cinc intbnd pop_use_ln ethdiff dia_sec peton_use  ///
  peaceyrs _spline* ln_lag_gdppc  lag_growth lag_polity2 lag_polity2_sq ln_pop_ssno asset, robust cl(gwno)

* Model E3
logit onset_use lag_ln_dist2cic lag_ln_dist2cinc intbnd pop_use_ln ethdiff dia_sec peton_use ///
  peaceyrs _spline* ln_lag_gdppc  lag_growth lag_polity2 lag_polity2_sq ln_pop_ssno education, robust cl(gwno)



*** TABLE E2, Adding country level controls
* Model E4
logit onset_use lag_ln_dist2cic lag_ln_dist2cinc intbnd pop_use_ln ethdiff dia_sec peton_use ///
  peaceyrs _spline* ln_lag_gdppc  lag_growth lag_polity2 lag_polity2_sq ln_pop_ssno rdrgas, robust cl(gwno)

* Model E5
logit onset_use lag_ln_dist2cic lag_ln_dist2cinc intbnd pop_use_ln ethdiff dia_sec peton_use ///
  peaceyrs _spline* ln_lag_gdppc  lag_growth lag_polity2 lag_polity2_sq ln_pop_ssno rdrged, robust cl(gwno)

* Model E6
logit onset_use lag_ln_dist2cic lag_ln_dist2cinc intbnd pop_use_ln ethdiff dia_sec peton_use ///
  peaceyrs _spline* ln_lag_gdppc  lag_growth lag_polity2 lag_polity2_sq ln_pop_ssno rdrgas_c rdrgas2_c, robust cl(gwno)

* Model E7
logit onset_use lag_ln_dist2cic lag_ln_dist2cinc  intbnd pop_use_ln ethdiff dia_sec peton_use  ///
  peaceyrs _spline* ln_lag_gdppc  lag_growth lag_polity2 lag_polity2_sq ln_pop_ssno rdrged_c rdrged2_c, robust cl(gwno)



*** TABLE E3, Adding country level controls
* Model E8
logit onset_use lag_ln_dist2cic lag_ln_dist2cinc intbnd pop_use_ln ethdiff dia_sec peton_use ///
  peaceyrs _spline* ln_lag_gdppc  lag_growth lag_polity2 lag_polity2_sq ln_pop_ssno asset_gini, robust cl(gwno)

* Model E9
logit onset_use lag_ln_dist2cic lag_ln_dist2cinc intbnd pop_use_ln ethdiff dia_sec peton_use ///
  peaceyrs _spline* ln_lag_gdppc  lag_growth lag_polity2 lag_polity2_sq ln_pop_ssno education_gini, robust cl(gwno)

* Model E10
logit onset_use lag_ln_dist2cic lag_ln_dist2cinc intbnd pop_use_ln ethdiff dia_sec peton_use ///
  peaceyrs _spline* ln_lag_gdppc  lag_growth lag_polity2 lag_polity2_sq ln_pop_ssno elf_reg, robust cl(gwno)

* Model E11
logit onset_use lag_ln_dist2cic lag_ln_dist2cinc intbnd pop_use_ln ethdiff dia_sec peton_use ///
  peaceyrs _spline* ln_lag_gdppc  lag_growth lag_polity2 lag_polity2_sq ln_pop_ssno education_gini asset_gini elf_reg , robust cl(gwno)




*** TABLE E4, Adding country level controls
* Model E12
logit onset_use lag_ln_dist2cic lag_ln_dist2cinc intbnd pop_use_ln ethdiff ///
  peaceyrs _spline* ln_lag_gdppc  lag_growth lag_polity2 lag_polity2_sq ln_pop_ssno dia_sec rdrgas_c rdrgas_dia, robust cl(gwno)

* Model E13
logit onset_use lag_ln_dist2cic lag_ln_dist2cinc intbnd pop_use_ln ethdiff ///
  peaceyrs _spline* ln_lag_gdppc  lag_growth lag_polity2 lag_polity2_sq ln_pop_ssno peton_use  rdrgas_c rdrgas_pet, robust cl(gwno)

* Model E14
logit onset_use lag_ln_dist2cic lag_ln_dist2cinc intbnd pop_use_ln ethdiff ///
  peaceyrs _spline* ln_lag_gdppc  lag_growth lag_polity2 lag_polity2_sq ln_pop_ssno nr_c  rdrgas_c rdrgas_nr, robust cl(gwno)





****** Appendix F: Full model

*** TABLE F1, Full Model
*Model F1
logit onset_use lag_ln_dist2cic lag_ln_dist2cinc intbnd pop_use_ln ethdiff ///
  peaceyrs _spline* education  nr_c  rdrgas_c rdrgas2_c rdrgas_nr asset_gini education_gini, robust cl(gwno) 






