* Mattias Agerberg
* Code for "The Curse of Knowledge: Education, Corruption, and Politics", Political Behavior 2018


set type double
set more off
use PB_dataset2.dta, clear


// Variables
gen ln_gdpc = ln(wdi_gdppcpppcon)
label var ln_gdpc "Log GDP/capita"
egen income_raw = rowmax(AT_RINC AU_RINC BE_RINC CH_RINC CL_RINC CZ_RINC DE_RINC DK_RINC ES_RINC FI_RINC FR_RINC GB_RINC GE_RINC HR_RINC HU_RINC IL_RINC IN_RINC IS_RINC JP_RINC KR_RINC LT_RINC NL_RINC NO_RINC PH_RINC PL_RINC RU_RINC SE_RINC SI_RINC SK_RINC TR_RINC TW_RINC US_RINC VE_RINC ZA_RINC)
*Install "egenmore" package
egen income_3cat=xtile(income_raw), n(3) by(V4)


// Indices
foreach var in V41 V42 V62 V50 V43_rev V44 V47_rev V25_rev {
egen Z`var' = std(`var')
}

*Table 1
factor ZV41 ZV42 ZV62 ZV50 ZV43_rev ZV44 ZV47_rev ZV25_rev  if(base_sample==1), pcf
rotate
alpha ZV41 ZV42 ZV62 ZV50 if(base_sample==1), item
alpha ZV43_rev ZV47_rev ZV44 ZV25_rev if(base_sample==1), item

gen selfregarding_att = ZV43_rev + ZV47_rev + ZV44 + ZV25_rev
egen Zselfregarding_att = std(selfregarding_att)
label var Zselfregarding_att "Self-regarding attitudes"

gen institutional_att = ZV41 + ZV42 + ZV62 + ZV50
egen Zinstitutional_att = std(institutional_att)
label var Zinstitutional_att "Institutional attitudes"

gen noninst_part = V17_01 + V18_01 + V19_01 + V20_01 + V22_01 + V23_01 + V24_01
label var noninst_part "Non-institutionalized participation"
alpha V17_01 V18_01 V19_01 V20_01 V22_01 V23_01 V24_01 if(base_sample==1), item


// Political attitudes, Results 

* Self-regarding, Table 2
reg Zselfregarding_att i.V61 c.EDUCYRS i.income_3cat AGE age_sq i.SEX i.URBRURAL i.married i.incumbent_voter i.V4  if(base_sample==1), vce(cluster V4)
reg Zselfregarding_att i.V61##c.EDUCYRS i.income_3cat AGE age_sq i.SEX i.URBRURAL i.married i.incumbent_voter i.V4  if(base_sample==1), vce(cluster V4)
mixed Zselfregarding_att c.vdem_pubcorr c.EDUCYRS i.income_3cat AGE age_sq i.SEX i.URBRURAL i.married i.incumbent_voter ln_gdpc vdem_polyarchy gol_enpp1 i.gol_est if(base_sample==1)  || V4: EDUCYRS, cov(unstr) vce(cluster V4)
mixed Zselfregarding_att c.vdem_pubcorr##c.EDUCYRS i.income_3cat AGE age_sq i.SEX i.URBRURAL i.married i.incumbent_voter ln_gdpc vdem_polyarchy gol_enpp1 i.gol_est if(base_sample==1)  || V4: EDUCYRS, cov(unstr) vce(cluster V4)

*Institutional, Table 2
reg Zinstitutional_att i.V61 c.EDUCYRS i.income_3cat AGE age_sq i.SEX i.URBRURAL i.married i.incumbent_voter i.V4  if(base_sample==1), vce(cluster V4)
reg Zinstitutional_att i.V61##c.EDUCYRS i.income_3cat AGE age_sq i.SEX i.URBRURAL i.married i.incumbent_voter i.V4  if(base_sample==1), vce(cluster V4)
mixed Zinstitutional_att c.vdem_pubcorr c.EDUCYRS i.income_3cat AGE age_sq i.SEX i.URBRURAL i.married i.incumbent_voter ln_gdpc vdem_polyarchy gol_enpp1 i.gol_est if(base_sample==1)  || V4: EDUCYRS, cov(unstr) vce(cluster V4)
mixed Zinstitutional_att c.vdem_pubcorr##c.EDUCYRS i.income_3cat AGE age_sq i.SEX i.URBRURAL i.married i.incumbent_voter ln_gdpc vdem_polyarchy gol_enpp1 i.gol_est if(base_sample==1)  || V4: EDUCYRS, cov(unstr) vce(cluster V4)


// Political participation, Results

* Voting, Table 3
logit VOTE i.V61 c.EDUCYRS i.income_3cat AGE age_sq i.SEX i.URBRURAL i.married i.V4  if(base_sample==1), vce(cluster V4)
logit VOTE i.V61##c.EDUCYRS i.income_3cat AGE age_sq i.SEX i.URBRURAL i.married i.V4 if(base_sample==1), vce(cluster V4)
melogit VOTE c.vdem_pubcorr c.EDUCYRS i.income_3cat AGE age_sq i.SEX i.URBRURAL i.married  ln_gdpc vdem_polyarchy  gol_enpp1 i.gol_est i.compulsory if(base_sample==1)  || V4: EDUCYRS, cov(unstr)
melogit VOTE c.vdem_pubcorr##c.EDUCYRS i.income_3cat AGE age_sq i.SEX i.URBRURAL i.married ln_gdpc vdem_polyarchy  gol_enpp1 i.gol_est i.compulsory if(base_sample==1)  || V4: EDUCYRS, cov(unstr) diff

* NIPP, Table 3
poisson noninst_part i.V61 c.EDUCYRS i.income_3cat AGE age_sq i.SEX i.URBRURAL i.married i.incumbent_voter i.V4 if(base_sample==1), vce(cluster V4)
poisson noninst_part i.V61##c.EDUCYRS i.income_3cat AGE age_sq i.SEX i.URBRURAL i.married i.incumbent_voter i.V4 if(base_sample==1), vce(cluster V4)
meqrpoisson noninst_part c.vdem_pubcorr c.EDUCYRS i.income_3cat AGE age_sq i.SEX i.URBRURAL i.married i.incumbent_voter ln_gdpc vdem_polyarchy  gol_enpp1 i.gol_est if(base_sample==1) || V4: EDUCYRS, cov(unstr)
meqrpoisson noninst_part c.vdem_pubcorr##c.EDUCYRS i.income_3cat AGE age_sq i.SEX i.URBRURAL i.married i.incumbent_voter ln_gdpc vdem_polyarchy  gol_enpp1 i.gol_est if(base_sample==1) || V4: EDUCYRS, cov(unstr) 

* All estimates in the paper were rounded to two decimals
* Graphs generated using: 
* margins, dydx(EDUCYRS) at(V61==(1(1)5)) atmeans 
* margins, dydx(EDUCYRS) at(vdem_pubcorr==(0(1)6)) atmeans
* marginsplot
* Editing was done in the graph editor


// Appendix & Supplementary

* Internal efficacy 1
ologit V43_rev i.V61##c.EDUCYRS i.income_3cat AGE age_sq i.SEX i.URBRURAL i.married  i.incumbent_voter i.V4  if(base_sample==1), vce(cluster V4)
meologit V43_rev c.vdem_pubcorr##c.EDUCYRS i.income_3cat AGE age_sq i.SEX i.URBRURAL i.married  i.incumbent_voter ln_gdpc vdem_polyarchy gol_enpp1 i.gol_est if(base_sample==1) || V4: EDUCYRS, cov(unstr) vce(cluster V4) diff

* Internal efficacy 2
ologit V44 i.V61##c.EDUCYRS i.income_3cat AGE age_sq i.SEX i.URBRURAL i.married i.incumbent_voter i.V4 if(base_sample==1), vce(cluster V4)
meologit V44 c.vdem_pubcorr##c.EDUCYRS i.income_3cat AGE age_sq i.SEX i.URBRURAL i.married i.incumbent_voter  ln_gdpc vdem_polyarchy  gol_enpp1 i.gol_est if(base_sample==1)  || V4: EDUCYRS, cov(unstr) vce(cluster V4) diff

* Political interest
ologit V47_rev i.V61##c.EDUCYRS i.income_3cat AGE age_sq i.SEX i.URBRURAL i.married i.incumbent_voter i.V4 if(base_sample==1), vce(cluster V4)
meologit V47_rev c.vdem_pubcorr##c.EDUCYRS i.income_3cat AGE age_sq i.SEX i.URBRURAL i.married i.incumbent_voter ln_gdpc vdem_polyarchy gol_enpp1 i.gol_est if(base_sample==1) || V4: EDUCYRS, vce(cluster V4) cov(unstr)  diff

* Media
ologit V25_rev i.V61##c.EDUCYRS i.income_3cat AGE age_sq i.SEX i.URBRURAL i.married  i.incumbent_voter i.V4  if(base_sample==1), vce(cluster V4)
meologit  V25_rev c.vdem_pubcorr##c.EDUCYRS i.income_3cat AGE age_sq i.SEX i.URBRURAL i.married i.incumbent_voter ln_gdpc vdem_polyarchy gol_enpp1 i.gol_est if(base_sample==1)  || V4: EDUCYRS, cov(unstr) vce(cluster V4) diff intmethod(mc)

* External efficacy 1
ologit V41 i.V61##c.EDUCYRS i.income_3cat AGE age_sq i.SEX i.URBRURAL i.married  i.incumbent_voter i.V4  if(base_sample==1), vce(cluster V4)
meologit V41 c.vdem_pubcorr##c.EDUCYRS i.income_3cat AGE age_sq i.SEX i.URBRURAL i.married i.incumbent_voter  ln_gdpc vdem_polyarchy gol_enpp1 i.gol_est if(base_sample==1)  || V4: EDUCYRS, cov(unstr) vce(cluster V4) diff intmethod(mc)

* External efficacy 2
ologit V42 i.V61##c.EDUCYRS i.income_3cat AGE age_sq i.SEX i.URBRURAL i.married  i.incumbent_voter i.V4  if(base_sample==1), vce(cluster V4)
meologit V42 c.vdem_pubcorr##c.EDUCYRS i.income_3cat AGE age_sq i.SEX i.URBRURAL i.married i.incumbent_voter  ln_gdpc vdem_polyarchy gol_enpp1 i.gol_est if(base_sample==1)  || V4: EDUCYRS, cov(unstr) vce(cluster V4) diff intmethod(mc)

* Satisfaction with democracy
reg V62 i.V61##c.EDUCYRS i.income_3cat AGE age_sq i.SEX i.URBRURAL i.married i.incumbent_voter i.V4  if(base_sample==1), vce(cluster V4)
mixed V62 c.vdem_pubcorr##c.EDUCYRS i.income_3cat AGE age_sq i.SEX i.URBRURAL i.married i.incumbent_voter ln_gdpc vdem_polyarchy gol_enpp1 i.gol_est if(base_sample==1) || V4: EDUCYRS, cov(unstr)  vce(cluster V4)

* Personal profit (politicians)
ologit V50 i.V61##c.EDUCYRS i.income_3cat AGE age_sq i.SEX i.URBRURAL i.married i.incumbent_voter i.V4 if(base_sample==1), vce(cluster V4)
meologit V50 c.vdem_pubcorr##c.EDUCYRS i.income_3cat AGE age_sq i.SEX i.URBRURAL i.married i.incumbent_voter  ln_gdpc vdem_polyarchy  gol_enpp1 i.gol_est if(base_sample==1)  || V4: EDUCYRS, cov(unstr) vce(cluster V4) diff intmethod(mc)


* CPI
mixed Zselfregarding_att c.ti_cpi_rev##c.EDUCYRS i.income_3cat AGE age_sq i.SEX i.URBRURAL i.married i.incumbent_voter ln_gdpc vdem_polyarchy gol_enpp1 i.gol_est if(base_sample==1)   || V4: EDUCYRS, cov(unstr) vce(cluster V4)
mixed Zinstitutional_att c.ti_cpi_rev##c.EDUCYRS i.income_3cat AGE age_sq i.SEX i.URBRURAL i.married i.incumbent_voter ln_gdpc vdem_polyarchy gol_enpp1 i.gol_est if(base_sample==1)   || V4: EDUCYRS, cov(unstr) vce(cluster V4)
melogit VOTE c.ti_cpi_rev##c.EDUCYRS i.income_3cat AGE age_sq i.SEX i.URBRURAL i.married   ln_gdpc vdem_polyarchy gol_enpp1 i.gol_est i.compulsory if(base_sample==1)   || V4: EDUCYRS, cov(unstr) vce(cluster V4)
meqrpoisson noninst_part c.ti_cpi_rev##c.EDUCYRS i.income_3cat AGE age_sq i.SEX i.URBRURAL i.married i.incumbent_voter ln_gdpc vdem_polyarchy gol_enpp1 i.gol_est if(base_sample==1)  || V4: EDUCYRS, cov(unstr) 


* All observations
reg Zselfregarding_att i.V61##c.EDUCYRS i.income_3cat AGE age_sq i.SEX i.URBRURAL i.married i.incumbent_voter i.V4 , vce(cluster V4)
mixed Zselfregarding_att c.vdem_pubcorr##c.EDUCYRS i.income_3cat AGE age_sq i.SEX i.URBRURAL i.married i.incumbent_voter ln_gdpc vdem_polyarchy gol_enpp1 i.gol_est  || V4: EDUCYRS, cov(unstr) vce(cluster V4)
reg Zinstitutional_att i.V61##c.EDUCYRS i.income_3cat AGE age_sq i.SEX i.URBRURAL i.married i.incumbent_voter i.V4 , vce(cluster V4)
mixed Zinstitutional_att c.vdem_pubcorr##c.EDUCYRS i.income_3cat AGE age_sq i.SEX i.URBRURAL i.married i.incumbent_voter ln_gdpc vdem_polyarchy gol_enpp1 i.gol_est   || V4: EDUCYRS, cov(unstr) vce(cluster V4)
logit VOTE i.V61##c.EDUCYRS i.income_3cat AGE age_sq i.SEX i.URBRURAL i.married i.V4, vce(cluster V4)
melogit VOTE c.vdem_pubcorr##c.EDUCYRS i.income_3cat AGE age_sq i.SEX i.URBRURAL i.married   ln_gdpc vdem_polyarchy gol_enpp1 i.gol_est i.compulsory   || V4: EDUCYRS, cov(unstr)
poisson noninst_part i.V61##c.EDUCYRS i.income_3cat AGE age_sq i.SEX i.URBRURAL i.married i.incumbent_voter i.V4 , vce(cluster V4)
meqrpoisson noninst_part c.vdem_pubcorr##c.EDUCYRS i.income_3cat AGE age_sq i.SEX i.URBRURAL i.married i.incumbent_voter ln_gdpc vdem_polyarchy  gol_enpp1 i.gol_est  || V4: EDUCYRS, cov(unstr) diff  lap


* Negative binomial
nbreg noninst_part i.V61##c.EDUCYRS i.income_3cat AGE age_sq i.SEX i.URBRURAL i.married i.incumbent_voter i.V4 if(base_sample==1), vce(cluster V4)
menbreg noninst_part c.vdem_pubcorr##c.EDUCYRS i.income_3cat AGE age_sq i.SEX i.URBRURAL i.married i.incumbent_voter ln_gdpc vdem_polyarchy  gol_enpp1 i.gol_est if(base_sample==1)   || V4: EDUCYRS, cov(unstr) diff


* Relative edu
egen AGE_dec = xtile(AGE), by(V4) p(10(10)90)
egen edu_dec_mean = mean(EDUCYRS), by(AGE_dec)
gen relative_edu if(EDUCYRS<30) = EDUCYRS/edu_dec_mean
egen Zrelative_edu = std(relative_edu)
label var Zrelative_edu "Relative education"

reg Zselfregarding_att i.V61##c.Zrelative_edu i.income_3cat AGE age_sq i.SEX i.URBRURAL i.married i.incumbent_voter i.V4  if(base_sample==1), vce(cluster V4)
mixed Zselfregarding_att c.vdem_pubcorr##c.Zrelative_edu i.income_3cat AGE age_sq i.SEX i.URBRURAL i.married i.incumbent_voter ln_gdpc vdem_polyarchy gol_enpp1 i.gol_est if(base_sample==1)  || V4: Zrelative_edu, cov(unstr) vce(cluster V4)
reg Zinstitutional_att i.V61##c.Zrelative_edu i.income_3cat AGE age_sq i.SEX i.URBRURAL i.married i.incumbent_voter i.V4  if(base_sample==1), vce(cluster V4)
mixed Zinstitutional_att c.vdem_pubcorr##c.Zrelative_edu i.income_3cat AGE age_sq i.SEX i.URBRURAL i.married i.incumbent_voter ln_gdpc vdem_polyarchy gol_enpp1 i.gol_est if(base_sample==1)  || V4: Zrelative_edu, cov(unstr) vce(cluster V4)
logit VOTE i.V61##c.Zrelative_edu i.income_3cat AGE age_sq i.SEX i.URBRURAL i.married i.V4 if(base_sample==1), vce(cluster V4)
melogit VOTE c.vdem_pubcorr##c.Zrelative_edu i.income_3cat AGE age_sq i.SEX i.URBRURAL i.married   ln_gdpc vdem_polyarchy  gol_enpp1 i.gol_est i.compulsory if(base_sample==1)  || V4: Zrelative_edu, cov(unstr)
poisson noninst_part i.V61##c.Zrelative_edu i.income_3cat AGE age_sq i.SEX i.URBRURAL i.married i.incumbent_voter i.V4 if(base_sample==1), vce(cluster V4)
meqrpoisson noninst_part c.vdem_pubcorr##c.Zrelative_edu i.income_3cat AGE age_sq i.SEX i.URBRURAL i.married i.incumbent_voter ln_gdpc vdem_polyarchy gol_enpp1 i.gol_est if(base_sample==1) || V4: Zrelative_edu, cov(unstr) diff


* Controlling for inequality
mixed Zselfregarding_att c.vdem_pubcorr##c.EDUCYRS i.income_3cat AGE age_sq i.SEX i.URBRURAL i.married i.incumbent_voter ln_gdpc vdem_polyarchy gol_enpp1 i.gol_est wdi_gini if(base_sample==1)  || V4: EDUCYRS, cov(unstr) vce(cluster V4)
mixed Zinstitutional_att c.vdem_pubcorr##c.EDUCYRS i.income_3cat AGE age_sq i.SEX i.URBRURAL i.married i.incumbent_voter ln_gdpc vdem_polyarchy gol_enpp1 i.gol_est wdi_gini if(base_sample==1)  || V4: EDUCYRS, cov(unstr) vce(cluster V4)
xtmelogit VOTE c.vdem_pubcorr##c.EDUCYRS i.income_3cat AGE age_sq i.SEX i.URBRURAL i.married ln_gdpc vdem_polyarchy  gol_enpp1 i.gol_est i.compulsory wdi_gini if(base_sample==1)  || V4: EDUCYRS, cov(unstr) diff
meqrpoisson noninst_part c.vdem_pubcorr##c.EDUCYRS i.income_3cat AGE age_sq i.SEX i.URBRURAL i.married i.incumbent_voter ln_gdpc vdem_polyarchy gol_enpp1 i.gol_est wdi_gini if(base_sample==1) || V4: EDUCYRS, cov(unstr) diff
