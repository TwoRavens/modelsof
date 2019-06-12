/* This do file performs core analysis for 
Bauerle Danzman, Oatley, and Winecoff. Specifically,
it generates Tables 1 and 2 and Figures 6-14. */

clear
set mem 100m
set more off
*cd "\\Client\H$\Dropbox\Capital_Flows_Paper\ISQ R&R\Data and Analysis"


use isqrr12012.dta, clear

** Appendix A
** Figure 1 (see wkw)
** Table 1: US Capital Account and Bonanzas
regress adjregionbonanzaratio us_fa i.iso3n 
predict regionbonanzausfa_ratio_res,res
qnorm regionbonanzausfa_ratio_res
egen stdregionbonanzausfa_ratio_res=std(regionbonanzausfa_ratio_res)
regress adjregionbonanzaratio us_world_fa i.iso3n 
predict regionbonanzauswfa_ratio_res,res
qnorm regionbonanzauswfa_ratio_res
egen stdregionbonanzauswfa_ratio_res=std(regionbonanzauswfa_ratio_res)
xtlogit bonanza l.bonanza stdusfa stdregionbonanzausfa_ratio_res stdgdp_gr ///
stdgdp_pc stddeposits stdvintagedebt stdinflate democracy stdkaopen stdmonetary stdxrate, re /* Model 5 */
estimates store m32a, title(US Local RE)
xtlogit bonanza l.bonanza stdusfa stdregionbonanzausfa_ratio_res stdgdp_gr ///
stdgdp_pc stddeposits stdvintagedebt stdinflate democracy stdkaopen stdmonetary stdxrate, fe /* Model 6 */
estimates store m32b, title(US Local FE)
xtlogit bonanza l.bonanza stduswfa stdregionbonanzauswfa_ratio_res stdgdp_gr ///
stdgdp_pc stddeposits stdvintagedebt stdinflate democracy stdkaopen stdmonetary stdxrate, re /* Model 5 */
estimates store m32c, title(US/World Local RE)
xtlogit bonanza l.bonanza stduswfa stdregionbonanzauswfa_ratio_res stdgdp_gr ///
stdgdp_pc stddeposits stdvintagedebt stdinflate democracy stdkaopen stdmonetary stdxrate, fe /* Model 6 */
estimates store m32d, title(US/World Local FE)
estout m32a m32b m32c m32d, cells(b(star fmt(%9.3f)) p(par fmt(%9.2f))) stats(aic bic N) style(tex) varlabels(_cons \_cons)
** Table 2: US Capital Account and Bank Crises
reg bonanza lbonanza stdusfa stdregionbonanzausfa_ratio_res i.iso3n
predict bonus_hat, res
qnorm bonus_hat
gen lbonus_hat=l.bonus_hat
reg bonanza lbonanza stduswfa stdregionbonanzauswfa_ratio_res i.iso3n
predict bonusw_hat, res
qnorm bonusw_hat
gen lbonusw_hat=l.bonusw_hat
regress adjregioncrisisratio stdusfa i.iso3n 
predict regioncrisis_resusfa, res
qnorm regioncrisis_resusfa
egen stdregioncrisis_resusfa=std(regioncrisis_resusfa)
regress adjregioncrisisratio stduswfa i.iso3n 
predict regioncrisis_resuswfa, res
qnorm regioncrisis_resuswfa
egen stdregioncrisis_resuswfa=std(regioncrisis_resuswfa)
xtlogit bankcrisis lbonus_hat stdusfa stdregioncrisis_resusfa stdgdp_gr ///
stdgdp_pc stddeposits stdvintagedebt stdinflate democracy stdkaopen stdmonetary stdxrate, re /* Model 11 */
estimates store m32e, title(US Local RE)
xtlogit bankcrisis lbonus_hat stdusfa stdregioncrisis_resusfa stdgdp_gr ///
stdgdp_pc stddeposits stdvintagedebt stdinflate democracy stdkaopen stdmonetary stdxrate, fe /* Model 12 */
estimates store m32f, title(US Local RE)
xtlogit bankcrisis lbonusw_hat stduswfa stdregioncrisis_resuswfa stdgdp_gr ///
stdgdp_pc stddeposits stdvintagedebt stdinflate democracy stdkaopen stdmonetary stdxrate, re /* Model 11 */
estimates store m32g, title(US Local RE)
xtlogit bankcrisis lbonusw_hat stduswfa stdregioncrisis_resuswfa stdgdp_gr ///
stdgdp_pc stddeposits stdvintagedebt stdinflate democracy stdkaopen stdmonetary stdxrate, fe /* Model 12 */
estimates store m32h, title(US Local RE)
estout m32e m32f m32g m32h, cells(b(star fmt(%9.3f)) p(par fmt(%9.2f))) stats(aic bic N) style(tex) varlabels(_cons \_cons)
** Figure 2 (seewkw)
** Figure 3: (wkw)
** Figure 4: (wkw)
** Table 3: CA Gini and Bonanzas (Robust to Models 1-6)
xtlogit bonanza l.bonanza stdcagini10, re /* Model 1 */
xtlogit bonanza l.bonanza stdcagini10, fe /* Model 2 */
xtlogit bonanza l.bonanza stdcagini10 stdregionbonanza_ratio_res, re /* Model 3 */
xtlogit bonanza l.bonanza stdcagini10 stdregionbonanza_ratio_res, fe /* Model 4 */
xtlogit bonanza l.bonanza stdcagini10 stdregionbonanzaca_ratio_res stdgdp_gr ///
stdgdp_pc stddeposits stdvintagedebt stdinflate democracy stdkaopen stdmonetary stdxrate, re /* Model 5 */
xtlogit bonanza l.bonanza stdcagini10 stdregionbonanzaca_ratio_res stdgdp_gr ///
stdgdp_pc stddeposits stdvintagedebt stdinflate democracy stdkaopen stdmonetary stdxrate, fe /* Model 6 */
** Table 4: CA Gini and Crises (Robust to Models 7-12)
xtlogit bankcrisis lbon3_hat stdcagini10, re /* Model 7 */
xtlogit bankcrisis lbon3_hat stdcagini10, fe /* Model 8 */
xtlogit bankcrisis lbon3_hat stdcagini10 stdregioncrisis_res_ca, re /* Model 9 */
xtlogit bankcrisis lbonk_hat stdcagini10 stdregioncrisis_res_ca, fe /* Model 10 */
*** Model 11&12: Crisis - CA Gini plus regional and local effects
xtlogit bankcrisis lbon3_hat stdcagini10 stdregioncrisis_res_ca stdgdp_gr ///
stdgdp_pc stddeposits stdvintagedebt stdinflate democracy stdkaopen stdmonetary stdxrate, re /* Model 11 */
xtlogit bankcrisis lbon3_hat stdcagini10 stdregioncrisis_res_ca stdgdp_gr ///
stdgdp_pc stddeposits stdvintagedebt stdinflate democracy stdkaopen stdmonetary stdxrate, fe /* Model 12 */

** Appendix B
xtset iso3n year
** poisson 
xtpoisson adjregionbonanzaratio fa_gini_10, fe
predict yhat_adjregionbonanzaratio
gen res_regionbonanzaratio=adjregionbonanzaratio-yhat_adjregionbonanzaratio
qnorm res_regionbonanzaratio
** random effects cross sectional time series
xtreg adjregionbonanzaratio fa_gini_10, re
predict regbon_hat_ratio_re
gen regbon_ratio_re_res=adjregionbonanzaratio-regbon_hat_ratio_re
qnorm regbon_ratio_re_res
** standard regression with country fixed effects
regress adjregionbonanzaratio fa_gini_10 i.iso3n 
predict regionbonanzaka_ratio_res,res
qnorm regionbonanzaka_ratio_res
** standard regression with region fixed effects
regress adjregionbonanzaratio ka_gini_10 i.region 
predict regionbonanza_ratio_res,res
qnorm regionbonanza_ratio_re
** standard regression with country fixed effects is the best
egen stdregionbonanzaka_ratio_res=std(regionbonanzaka_ratio_res)
** With CA Gini for CA Models
reg adjregionbonanzaratio ca_gini_10 i.iso3n
predict regbon_ratio_fe_res, res
qnorm regbon_ratio_fe_res
egen stdres_regionbonanza_fe=std(regbon_ratio_fe_res)

** Appendix C 
** Table 5 
xtlogit bonanza l.bonanza stdkagini10 stdworldi, re
estimates store m5a, title(RE)
xtlogit bonanza l.bonanza stdkagini10 stdworldi, fe
estimates store m5b, title(FE)
xtprobit bonanza l.bonanza stdkagini10 stdworldi
estimates store m5c, title(Probit)
xtlogit bonanza l.bonanza stdkagini10 stdworldi i.region
estimates store m5d, title(Region FE)
estout m5*, cells(b(star fmt(%9.3f)) p(par fmt(%9.2f))) stats(aic bic N) style(tex) varlabels(_cons \_cons)
*** Table 6
xtlogit bonanza l.bonanza stdkagini10 stdglobalim, re
estimates store m6a, title(RE)
xtlogit bonanza l.bonanza stdkagini10 stdglobalim, fe
estimates store m6b, title(FE)
xtprobit bonanza l.bonanza stdkagini10 stdglobalim
estimates store m6c, title(Probit)
xtlogit bonanza l.bonanza stdkagini10 stdglobalim i.region
estimates store m6d, title(Region FE)
estout m6*, cells(b(star fmt(%9.3f)) p(par fmt(%9.2f))) stats(aic bic N) style(tex) varlabels(_cons \_cons)
*** Figure 6
logit bonanza lbonanza c.stdkagini10##c.stdworldi
margins, dydx(stdworldi) at(stdkagini10=(-1.45(.25)2.55)) vsquish
marginsplot, ysize(4.5) xsize(6.5) scheme(s2mono)
marginsplot, scheme(s2mono)
margins, dydx(stdkagini10) at(stdworldi=(-1.25(.25)2.25)) vsquish
marginsplot, scheme(s2mono)
** Table 7
xtlogit bonanza lbonanza c.stdkagini10##c.stdworldi stdregionbonanzaka_ratio_res stdgdp_gr ///
stdgdp_pc stddeposits stdvintagedebt stdinflate democracy stdkaopen stdmonetary stdxrate ///
stdglobalim
estimates store mm12a, title (RE)
xtlogit bonanza lbonanza c.stdkagini10##c.stdworldi stdregionbonanzaka_ratio_res stdgdp_gr ///
stdgdp_pc stddeposits stdvintagedebt stdinflate democracy stdkaopen stdmonetary stdxrate ///
stdglobalim, fe
estimates store mm12b, title (FE)
estout mm12*, cells(b(star fmt(%9.3f)) p(par fmt(%9.2f))) stats(aic bic N) style(tex) varlabels(_cons \_cons)
** Table 8
xtlogit bankcrisis lbonk3_hat stdkagini10 stdworldi, re
estimates store m19a, title(RE)
xtlogit bankcrisis lbonk3_hat stdkagini10 stdworldi, fe
estimates store m19b, title(FE)
xtprobit bankcrisis lbonk3_hat stdkagini10 stdworldi
estimates store m19c, title(Probit)
xtlogit bankcrisis lbonk3_hat stdkagini10 stdworldi i.region
estimates store m19d, title(Region FE)
firthlogit bankcrisis lbonk3_hat stdkagini10 stdworldi
estimates store m19e, title(Rare Events)
estout m19*, cells(b(star fmt(%9.3f)) p(par fmt(%9.2f))) stats(aic bic N) style(tex) varlabels(_cons \_cons)
** Table 9 
xtlogit bankcrisis lbonk3_hat stdkagini10 stdglobalim, re
estimates store m20a, title(RE)
xtlogit bankcrisis lbonk3_hat stdkagini10 stdglobalim, fe
estimates store m20b, title(FE)
xtprobit bankcrisis lbonk3_hat stdkagini10 stdglobalim
estimates store m20c, title(Probit)
xtlogit bankcrisis lbonk3_hat stdkagini10 stdglobalim i.region
estimates store m20d, title(Region FE)
firthlogit bankcrisis lbonk3_hat stdkagini10 stdglobalim
estimates store m20e, title(Rare Events)
estout m20*, cells(b(star fmt(%9.3f)) p(par fmt(%9.2f))) stats(aic bic N) style(tex) varlabels(_cons \_cons)
*** Table 10
*** Due to power issues, can only run RE and not local models
xtlogit bonanza l.bonanza stdkagini10 if year>1998, re /* Model 1 */
estimates store m33a, title(Model1)
xtlogit bonanza l.bonanza stdkagini10 stdregionbonanzaka_ratio_res if year>1998, re /* Model 3 */
estimates store m33b, title(Model3)
xtlogit bankcrisis lbonk3_hat stdkagini10 if year>1998, re /* Model 7 */
estimates store m33c, title(Model7)
xtlogit bankcrisis lbonk3_hat stdkagini10 stdregioncrisis_res_ka if year>1998, re /* Model 9 */
estimates store m33d, title(Model9)
estout m33a m33b m33c m33d, cells(b(star fmt(%9.3f)) p(par fmt(%9.2f))) stats(aic bic N) style(tex) varlabels(_cons \_cons)


** Appendix D
** Table 11
xtlogit bonanza l.bonanza stdkagini10, pa corr(ar1)
estimates store m1a, title(AR 1)
xtlogit bonanza l.bonanza stdkagini10, pa corr(ar2)
estimates store m1b, title(AR 2)
xtprobit bonanza l.bonanza stdkagini10
estimates store m1c, title(Probit)
xtlogit bonanza l.bonanza stdkagini10 i.region
estimates store m1d, title(Region FE)
estout m1a m1b m1c m1d, cells(b(star fmt(%9.3f)) p(par fmt(%9.2f))) stats(aic bic N) style(tex) varlabels(_cons \_cons)
** Table 12
xtlogit bonanza l.bonanza stdcagini10, re
estimates store m2a, title(CAGINI)
xtlogit bonanza l.bonanza stdcagini20, re
estimates store m2b, title(CAGINI20)
xtlogit bonanza l.bonanza stdkagini20, re
estimates store m2c, title(KAGINI20)
xtlogit bonanza l.bonanza stdcagini10, fe
estimates store m2d, title(CAGINI FE)
xtlogit bonanza l.bonanza stdcagini20, fe
estimates store m2e, title(CAGINI20 FE)
xtlogit bonanza l.bonanza stdkagini20, fe
estimates store m2f, title(KAGINI20 FE)
estout m2*, cells(b(star fmt(%9.3f)) p(par fmt(%9.2f))) stats(aic bic N) style(tex) varlabels(_cons \_cons)
** Table 13 
xtprobit bonanza l.bonanza stdcagini10
estimates store m3a, title(CAGINI PROBIT)
xtprobit bonanza l.bonanza stdcagini20
estimates store m3b, title(CAGINI20 PROBIT)
xtprobit bonanza l.bonanza stdkagini20
estimates store m3c, title(KAGINI20 PROBIT)
xtlogit bonanza l.bonanza stdcagini10 i.region
estimates store m3d, title(CAGINI REGION FE)
xtlogit bonanza l.bonanza stdcagini20 i.region
estimates store m3e, title(CAGINI20 REGION FE)
xtlogit bonanza l.bonanza stdkagini20 i.region
estimates store m3f, title(KAGINI20 REGION FE)
estout m3*, cells(b(star fmt(%9.3f)) p(par fmt(%9.2f))) stats(aic bic N) style(tex) varlabels(_cons \_cons)
** Table 14
xtlogit bonanza l.bonanza stdcagini10, pa corr(ar1)
estimates store m4a, title(CA10 AR 1)
xtlogit bonanza l.bonanza stdcagini20, pa corr(ar1)
estimates store m4b, title(CA20 AR 1)
xtlogit bonanza l.bonanza stdkagini20, pa corr(ar1)
estimates store m4c, title(KA20 AR 1)
xtlogit bonanza l.bonanza stdcagini10, pa corr(ar2)
estimates store m4d, title(CA10 AR 2)
xtlogit bonanza l.bonanza stdcagini20, pa corr(ar2)
estimates store m4e, title(CA20 AR 2)
xtlogit bonanza l.bonanza stdkagini20, pa corr(ar2)
estimates store m4f, title(KA20 AR 2)
estout m4a m4b m4c m4d m4e m4f, cells(b(star fmt(%9.3f)) p(par fmt(%9.2f))) stats(aic bic N) style(tex) varlabels(_cons \_cons)
** Table 15
xtlogit bonanza l.bonanza stdkagini10 stdregionbonanzaka_ratio_res, pa corr(ar1)
estimates store m7a, title(AR1)
xtlogit bonanza l.bonanza stdkagini10 stdregionbonanzaka_ratio_res, pa corr(ar2)
estimates store m7b, title(AR2)
xtprobit bonanza l.bonanza stdkagini10 stdregionbonanzaka_ratio_res
estimates store m7c, title(Probit)
xtlogit bonanza l.bonanza stdkagini10 stdregionbonanzaka_ratio_res i.region
estimates store m7d, title(Region FE)
estout m7*, cells(b(star fmt(%9.3f)) p(par fmt(%9.2f))) stats(aic bic N) style(tex) varlabels(_cons \_cons)
** Table 16
xtlogit bonanza l.bonanza stdcagini10 stdres_regionbonanza_fe, re
estimates store m8a, title(CAGINI)
xtlogit bonanza l.bonanza stdcagini20 stdres_regionbonanza_fe, re
estimates store m8b, title(CAGINI20)
xtlogit bonanza l.bonanza stdkagini20 stdres_regionbonanza_fe, re
estimates store m8c, title(KAGINI20)
xtlogit bonanza l.bonanza stdcagini10 stdres_regionbonanza_fe, fe
estimates store m8d, title(CAGINI FE)
xtlogit bonanza l.bonanza stdcagini20 stdres_regionbonanza_fe, fe
estimates store m8e, title(CAGINI20 FE)
xtlogit bonanza l.bonanza stdkagini20 stdres_regionbonanza_fe, fe
estimates store m8f, title(KAGINI20 FE)
estout m8*, cells(b(star fmt(%9.3f)) p(par fmt(%9.2f))) stats(aic bic N) style(tex) varlabels(_cons \_cons)
** Table 17
xtlogit bonanza l.bonanza stdcagini10 stdres_regionbonanza_fe, pa corr(ar1)
estimates store m9a, title(CA10 AR 1)
xtlogit bonanza l.bonanza stdcagini20 stdres_regionbonanza_fe, pa corr(ar1)
estimates store m9b, title(CA20 AR 1)
xtlogit bonanza l.bonanza stdkagini20 stdres_regionbonanza_fe, pa corr(ar1)
estimates store m9c, title(KA20 AR 1)
xtlogit bonanza l.bonanza stdcagini10 stdres_regionbonanza_fe, pa corr(ar2)
estimates store m9d, title(CA10 AR 2)
xtlogit bonanza l.bonanza stdcagini20 stdres_regionbonanza_fe, pa corr(ar2)
estimates store m9e, title(CA20 AR 2)
xtlogit bonanza l.bonanza stdkagini20 stdres_regionbonanza_fe, pa corr(ar2)
estimates store m9f, title(KA20 AR 2)
estout m9*, cells(b(star fmt(%9.3f)) p(par fmt(%9.2f))) stats(aic bic N) style(tex) varlabels(_cons \_cons)
** Table 18
xtlogit bonanza l.bonanza stdkagini10 stdregionbonanzaka_ratio_res stdgdp_gr ///
stdgdp_pc stddeposits stdvintagedebt stdinflate democracy stdkaopen stdmonetary stdxrate, pa corr(ar1)
estimates store m10a, title(AR1)
xtlogit bonanza l.bonanza stdkagini10 stdregionbonanzaka_ratio_res stdgdp_gr ///
stdgdp_pc stddeposits stdvintagedebt stdinflate democracy stdkaopen stdmonetary stdxrate, pa corr(ar2)
estimates store m10b, title(AR2)
xtprobit bonanza l.bonanza stdkagini10 stdregionbonanzaka_ratio_res stdgdp_gr ///
stdgdp_pc stddeposits stdvintagedebt stdinflate democracy stdkaopen stdmonetary stdxrate
estimates store m10c, title(Probit)
xtlogit bonanza l.bonanza stdkagini10 stdregionbonanzaka_ratio_res stdgdp_gr ///
stdgdp_pc stddeposits stdvintagedebt stdinflate democracy stdkaopen stdmonetary stdxrate i.region
estimates store m10d, title(Region FE)
estout m10*, cells(b(star fmt(%9.3f)) p(par fmt(%9.2f))) stats(aic bic N) style(tex) varlabels(_cons \_cons)
** Table 19 
xtlogit bonanza l.bonanza stdcagini10 stdres_regionbonanza_fe stdgdp_gr ///
stdgdp_pc stddeposits stdvintagedebt stdinflate democracy stdkaopen stdmonetary stdxrate, re
estimates store m11a, title(CAGINI)
xtlogit bonanza l.bonanza stdcagini20 stdres_regionbonanza_fe stdgdp_gr ///
stdgdp_pc stddeposits stdvintagedebt stdinflate democracy stdkaopen stdmonetary stdxrate, re
estimates store m11b, title(CAGINI20)
xtlogit bonanza l.bonanza stdkagini20 stdres_regionbonanza_fe stdgdp_gr ///
stdgdp_pc stddeposits stdvintagedebt stdinflate democracy stdkaopen stdmonetary stdxrate, re
estimates store m11c, title(KAGINI20)
xtlogit bonanza l.bonanza stdcagini10 stdres_regionbonanza_fe stdgdp_gr ///
stdgdp_pc stddeposits stdvintagedebt stdinflate democracy stdkaopen stdmonetary stdxrate, fe
estimates store m11d, title(CAGINI FE)
xtlogit bonanza l.bonanza stdcagini20 stdres_regionbonanza_fe stdgdp_gr ///
stdgdp_pc stddeposits stdvintagedebt stdinflate democracy stdkaopen stdmonetary stdxrate, fe
estimates store m11e, title(CAGINI20 FE)
xtlogit bonanza l.bonanza stdkagini20 stdres_regionbonanza_fe stdgdp_gr ///
stdgdp_pc stddeposits stdvintagedebt stdinflate democracy stdkaopen stdmonetary stdxrate, fe
estimates store m11f, title(KAGINI20 FE)
estout m11*, cells(b(star fmt(%9.3f)) p(par fmt(%9.2f))) stats(aic bic N) style(tex) varlabels(_cons \_cons)
** Table 20
xtlogit bonanza l.bonanza stdcagini10 stdres_regionbonanza_fe stdgdp_gr ///
stdgdp_pc stddeposits stdvintagedebt stdinflate democracy stdkaopen stdmonetary stdxrate, pa corr(ar1)
estimates store m12a, title(CA10 AR 1)
xtlogit bonanza l.bonanza stdcagini20 stdres_regionbonanza_fe stdgdp_gr ///
stdgdp_pc stddeposits stdvintagedebt stdinflate democracy stdkaopen stdmonetary stdxrate, pa corr(ar1)
estimates store m12b, title(CA20 AR 1)
xtlogit bonanza l.bonanza stdkagini20 stdres_regionbonanza_fe stdgdp_gr ///
stdgdp_pc stddeposits stdvintagedebt stdinflate democracy stdkaopen stdmonetary stdxrate, pa corr(ar1)
estimates store m12c, title(KA20 AR 1)
xtlogit bonanza l.bonanza stdcagini10 stdres_regionbonanza_fe stdgdp_gr ///
stdgdp_pc stddeposits stdvintagedebt stdinflate democracy stdkaopen stdmonetary stdxrate, pa corr(ar2)
estimates store m12d, title(CA10 AR 2)
xtlogit bonanza l.bonanza stdcagini20 stdres_regionbonanza_fe stdgdp_gr ///
stdgdp_pc stddeposits stdvintagedebt stdinflate democracy stdkaopen stdmonetary stdxrate, pa corr(ar2)
estimates store m12e, title(CA20 AR 2)
xtlogit bonanza l.bonanza stdkagini20 stdres_regionbonanza_fe stdgdp_gr ///
stdgdp_pc stddeposits stdvintagedebt stdinflate democracy stdkaopen stdmonetary stdxrate, pa corr(ar2)
estimates store m12f, title(KA20 AR 2)
estout m12*, cells(b(star fmt(%9.3f)) p(par fmt(%9.2f))) stats(aic bic N) style(tex) varlabels(_cons \_cons)
** Abiad and ICRG Models
egen stdfinreform = std(finreform)
xtlogit bonanza l.bonanza stdkagini10 stdregionbonanzaka_ratio_res stdgdp_gr ///
stdgdp_pc stddeposits stdvintagedebt stdinflate democracy stdkaopen stdmonetary ///
stdxrate stdfinreform , re 
estimates store m13a, title(FIN REFORM)
xtlogit bonanza l.bonanza stdkagini10 stdregionbonanzaka_ratio_res stdgdp_gr ///
stdgdp_pc stddeposits stdvintagedebt stdinflate democracy stdkaopen stdmonetary ///
stdxrate stdfinreform, fe 
estimates store m13b, title(FIN REFORM FE)
xtlogit bonanza l.bonanza stdkagini10 stdregionbonanzaka_ratio_res stdgdp_gr ///
stdgdp_pc stddeposits stdgovtdebt stdinflate democracy stdkaopen stdmonetary stdxrate transparency, re
estimates store m13c, title(Transparency)
xtlogit bonanza l.bonanza stdkagini10 stdregionbonanzaka_ratio_res stdgdp_gr ///
stdgdp_pc stddeposits stdgovtdebt stdinflate democracy stdkaopen stdmonetary stdxrate transparency, fe
estimates store m13d, title(Transparency FE)
xtlogit bonanza l.bonanza stdkagini10 stdregionbonanzaka_ratio_res stdgdp_gr ///
stdgdp_pc stddeposits stdgovtdebt stdinflate democracy stdkaopen stdmonetary stdxrate investprofile, re
estimates store m13e, title(Investprofile)
xtlogit bonanza l.bonanza stdkagini10 stdregionbonanzaka_ratio_res stdgdp_gr ///
stdgdp_pc stddeposits stdgovtdebt stdinflate democracy stdkaopen stdmonetary stdxrate investprofile, fe
xtlogit bonanza l.bonanza stdkagini10 stdregionbonanzaka_ratio_res stdgdp_gr ///
stdgdp_pc stddeposits stdgovtdebt stdinflate democracy stdkaopen stdmonetary stdxrate burqual, re 
estimates store m13f, title(Bur Qual)
xtlogit bonanza l.bonanza stdkagini10 stdregionbonanzaka_ratio_res stdgdp_gr ///
stdgdp_pc stddeposits stdgovtdebt stdinflate democracy stdkaopen stdmonetary stdxrate burqual, fe 
estimates store m13g, title(Bur Qual FE)
xtlogit bonanza l.bonanza stdkagini10 stdregionbonanzaka_ratio_res stdgdp_gr ///
stdgdp_pc stddeposits stdgovtdebt stdinflate democracy stdkaopen stdmonetary stdxrate laworder, re 
estimates store m13h, title(Law Order)
xtlogit bonanza l.bonanza stdkagini10 stdregionbonanzaka_ratio_res stdgdp_gr ///
stdgdp_pc stddeposits stdgovtdebt stdinflate democracy stdkaopen stdmonetary stdxrate laworder, fe 
xtlogit bonanza l.bonanza stdkagini10 stdregionbonanzaka_ratio_res stdgdp_gr ///
stdgdp_pc stddeposits stdgovtdebt stdinflate democracy stdkaopen stdmonetary stdxrate govstab
estimates store m13i, title(Gov Stab)
xtlogit bonanza l.bonanza stdkagini10 stdregionbonanzaka_ratio_res stdgdp_gr ///
stdgdp_pc stddeposits stdgovtdebt stdinflate democracy stdkaopen stdmonetary stdxrate corruption_icrg 
estimates store m13j, title(Corruption)
xtlogit bonanza l.bonanza stdkagini10 stdregionbonanzaka_ratio_res stdgdp_gr ///
stdgdp_pc stddeposits stdgovtdebt stdinflate democracy stdkaopen stdmonetary stdxrate icrg_index 
estimates store m13k, title(icrg index)
** Table 21 
estout m13a m13b m13k m13e m13h m13i m13j, cells(b(star fmt(%9.3f)) p(par fmt(%9.2f))) stats(aic bic N) style(tex) varlabels(_cons \_cons)
** Tabel 22 
estout m13c m13d m13f m13g, cells(b(star fmt(%9.3f)) p(par fmt(%9.2f))) stats(aic bic N) style(tex) varlabels(_cons \_cons)
** Table 23 
xtlogit bankcrisis lbonk3_hat stdkagini10, pa corr(ar1)
estimates store m14a, title(AR 1)
xtlogit bankcrisis lbonk3_ha stdkagini10, pa corr(ar2)
estimates store m14b, title(AR 2)
xtprobit bankcrisis lbonk3_ha stdkagini10
estimates store m14c, title(Probit)
xtlogit bankcrisis lbonk3_ha stdkagini10 i.region
estimates store m14d, title(Region FE)
firthlogit bankcrisis lbonk3_ha stdkagini10
estimates store m14e, title (RARE)
estout m14a m14b m14c m14d m14e, cells(b(star fmt(%9.3f)) p(par fmt(%9.2f))) stats(aic bic N) style(tex) varlabels(_cons \_cons)
** Table 24 
xtlogit bankcrisis lbon3_hat stdcagini10, re
estimates store m15a, title(CAGINI)
xtlogit bankcrisis lbon3_hat stdcagini20, re
estimates store m15b, title(CAGINI20)
xtlogit bankcrisis lbonk3_hat stdkagini20, re
estimates store m15c, title(KAGINI20)
xtlogit bankcrisis lbon3_hat stdcagini10, fe
estimates store m15d, title(CAGINI FE)
xtlogit bankcrisis lbon3_hat stdcagini20, fe
estimates store m15e, title(CAGINI20 FE)
xtlogit bankcrisis lbonk3_hat stdkagini20, fe
estimates store m15f, title(KAGINI20 FE)
estout m15*, cells(b(star fmt(%9.3f)) p(par fmt(%9.2f))) stats(aic bic N) style(tex) varlabels(_cons \_cons)
** Table 25 
xtprobit bankcrisis lbon3_hat stdcagini10
estimates store m16a, title(CAGINI PROBIT)
xtprobit bankcrisis lbon3_hat stdcagini20
estimates store m16b, title(CAGINI20 PROBIT)
xtprobit bankcrisis lbonk3_hat stdkagini10
estimates store m16c, title(KAGINI20 PROBIT)
xtlogit bankcrisis lbon3_hat stdcagini10 i.region
estimates store m16d, title(CAGINI REGION FE)
xtlogit bankcrisis lbon3_hat stdcagini20 i.region
estimates store m16e, title(CAGINI20 REGION FE)
xtlogit bankcrisis lbonk3_hat  stdkagini20 i.region
estimates store m16f, title(KAGINI20 REGION FE)
estout m16*, cells(b(star fmt(%9.3f)) p(par fmt(%9.2f))) stats(aic bic N) style(tex) varlabels(_cons \_cons)
** Table 26 
xtlogit bankcrisis lbon3_hat stdcagini10, pa corr(ar1)
estimates store m17a, title(CA10 AR 1)
xtlogit bankcrisis lbon3_hat stdcagini20, pa corr(ar1)
estimates store m17b, title(CA20 AR 1)
xtlogit bankcrisis lbonk3_hat stdkagini20, pa corr(ar1)
estimates store m17c, title(KA20 AR 1)
xtlogit bankcrisis lbon3_hat stdcagini10, pa corr(ar2)
estimates store m17d, title(CA10 AR 2)
xtlogit bankcrisis lbon3_hat stdcagini20, pa corr(ar2)
estimates store m17e, title(CA20 AR 2)
xtlogit bankcrisis lbonk3_hat stdkagini20, pa corr(ar2)
estimates store m17f, title(KA20 AR 2)
estout m17*, cells(b(star fmt(%9.3f)) p(par fmt(%9.2f))) stats(aic bic N) style(tex) varlabels(_cons \_cons)
** Table 27
firthlogit bankcrisis lbon3_hat stdcagini10
estimates store m18a, title(CA firth)
firthlogit bankcrisis lbon3_hat stdcagini20
estimates store m18b, title(CA20 firth)
firthlogit bankcrisis lbonk3_hat stdkagini20
estimates store m18c, title(KA20 firth)
estout m18*, cells(b(star fmt(%9.3f)) p(par fmt(%9.2f))) stats(aic bic N) style(tex) varlabels(_cons \_cons)
** Table 28 
xtlogit bankcrisis lbonk3_hat stdkagini10 stdregioncrisis_res_ka, pa corr(ar1)
estimates store m21a, title(AR1)
xtlogit bankcrisis lbonk3_hat stdkagini10 stdregioncrisis_res_ka, pa corr(ar2)
estimates store m21b, title(AR2)
xtprobit bankcrisis lbonk3_hat stdkagini10 stdregioncrisis_res_ka
estimates store m21c, title(Probit)
xtlogit bankcrisis lbonk3_hat stdkagini10 stdregioncrisis_res_ka i.region
estimates store m21d, title(Region FE)
firthlogit bankcrisis lbonk3_hat stdkagini10 stdregioncrisis_res_ka
estimates store m21e, title(RARE)
estout m21*, cells(b(star fmt(%9.3f)) p(par fmt(%9.2f))) stats(aic bic N) style(tex) varlabels(_cons \_cons)
** Table 29 
xtlogit bankcrisis lbon3_hat stdcagini10 stdregioncrisis_res, re
estimates store m22a, title(CAGINI)
xtlogit bankcrisis lbon3_hat stdcagini20 stdregioncrisis_res, re
estimates store m22b, title(CAGINI20)
xtlogit bankcrisis lbonk3_hat stdkagini20 stdregioncrisis_res_ka, re
estimates store m22c, title(KAGINI20)
xtlogit bankcrisis lbon3_hat stdcagini10 stdregioncrisis_res, fe
estimates store m22d, title(CAGINI FE)
xtlogit bankcrisis lbon3_hat stdcagini20 stdregioncrisis_res, fe
estimates store m22e, title(CAGINI20 FE)
xtlogit bankcrisis lbonk3_hat stdkagini20 stdregioncrisis_res_ka, fe
estimates store m22f, title(KAGINI20 FE)
estout m22*, cells(b(star fmt(%9.3f)) p(par fmt(%9.2f))) stats(aic bic N) style(tex) varlabels(_cons \_cons)
** Table 30 
xtlogit bankcrisis lbon3_hat stdcagini10 stdregioncrisis_res, pa corr(ar1)
estimates store m23a, title(CA10 AR 1)
xtlogit bankcrisis lbon3_hat stdcagini20 stdregioncrisis_res, pa corr(ar1)
estimates store m23b, title(CA20 AR 1)
xtlogit bankcrisis lbonk3_hat stdkagini20 stdregioncrisis_res_ka, pa corr(ar1)
estimates store m23c, title(KA20 AR 1)
xtlogit bankcrisis lbon3_hat stdcagini10 stdregioncrisis_res, pa corr(ar2)
estimates store m23d, title(CA10 AR 2)
xtlogit bankcrisis lbon3_hat stdcagini20 stdregioncrisis_res, pa corr(ar2)
estimates store m23e, title(CA20 AR 2)
xtlogit bankcrisis lbonk3_hat stdkagini20 stdregioncrisis_res_ka, pa corr(ar2)
estimates store m23f, title(KA20 AR 2)
estout m23*, cells(b(star fmt(%9.3f)) p(par fmt(%9.2f))) stats(aic bic N) style(tex) varlabels(_cons \_cons)
** Table 31
xtprobit bankcrisis lbon3_hat stdcagini10 stdregioncrisis_res
estimates store m24a, title(CA10 Probit)
xtprobit bankcrisis lbon3_hat stdcagini20 stdregioncrisis_res
estimates store m24b, title(CA20 Probit)
xtprobit bankcrisis lbonk3_hat stdkagini20 stdregioncrisis_res_ka
estimates store m24c, title(KA10 Probit)
firthlogit bankcrisis lbon3_hat stdcagini10 stdregioncrisis_res
estimates store m24d, title(CA10 Rare)
firthlogit bankcrisis lbon3_hat stdcagini20 stdregioncrisis_res
estimates store m24e, title(CA20 Rare)
firthlogit bankcrisis lbonk3_hat stdkagini20 stdregioncrisis_res_ka
estimates store m24f, title(KA20 Rare)
estout m24*, cells(b(star fmt(%9.3f)) p(par fmt(%9.2f))) stats(aic bic N) style(tex) varlabels(_cons \_cons)
** Table 32
xtlogit bankcrisis lbonk3_hat stdkagini10 stdregioncrisis_res_ka stdgdp_gr ///
stdgdp_pc stddeposits stdvintagedebt stdinflate democracy stdkaopen stdmonetary stdxrate, pa corr(ar1)
estimates store m25a, title(AR1)
xtlogit bankcrisis lbonk3_hat stdkagini10 stdregioncrisis_res_ka stdgdp_gr ///
stdgdp_pc stddeposits stdvintagedebt stdinflate democracy stdkaopen stdmonetary stdxrate, pa corr(ar2)
estimates store m25b, title(AR2)
xtprobit bankcrisis lbonk3_hat stdkagini10 stdregioncrisis_res_ka stdgdp_gr ///
stdgdp_pc stddeposits stdvintagedebt stdinflate democracy stdkaopen stdmonetary stdxrate
estimates store m25c, title(Probit)
xtlogit bankcrisis lbonk3_hat stdkagini10 stdregioncrisis_res_ka stdgdp_gr ///
stdgdp_pc stddeposits stdvintagedebt stdinflate democracy stdkaopen stdmonetary stdxrate i.region
estimates store m25d, title(Region FE)
firthlogit bankcrisis lbonk3_hat stdkagini10 stdregioncrisis_res_ka stdgdp_gr ///
stdgdp_pc stddeposits stdvintagedebt stdinflate democracy stdkaopen stdmonetary stdxrate
estimates store m25e, title(Rare)
estout m25*, cells(b(star fmt(%9.3f)) p(par fmt(%9.2f))) stats(aic bic N) style(tex) varlabels(_cons \_cons)
** Table 33
xtlogit bankcrisis lbon3_hat stdcagini10 stdregioncrisis_res stdgdp_gr ///
stdgdp_pc stddeposits stdvintagedebt stdinflate democracy stdkaopen stdmonetary stdxrate, re
estimates store m26a, title(CAGINI)
xtlogit bankcrisis lbon3_hat stdcagini20 stdregioncrisis_res stdgdp_gr ///
stdgdp_pc stddeposits stdvintagedebt stdinflate democracy stdkaopen stdmonetary stdxrate, re
estimates store m26b, title(CAGINI20)
xtlogit bankcrisis lbonk3_hat stdkagini20 stdregioncrisis_res_ka stdgdp_gr ///
stdgdp_pc stddeposits stdvintagedebt stdinflate democracy stdkaopen stdmonetary stdxrate, re
estimates store m26c, title(KAGINI20)
xtlogit bankcrisis lbon3_hat stdcagini10 stdregioncrisis_res stdgdp_gr ///
stdgdp_pc stddeposits stdvintagedebt stdinflate democracy stdkaopen stdmonetary stdxrate, fe
estimates store m26d, title(CAGINI FE)
xtlogit bankcrisis lbon3_hat stdcagini20 stdregioncrisis_res stdgdp_gr ///
stdgdp_pc stddeposits stdvintagedebt stdinflate democracy stdkaopen stdmonetary stdxrate, fe
estimates store m26e, title(CAGINI20 FE)
xtlogit bankcrisis lbonk3_hat stdkagini20 stdregioncrisis_res_ka stdgdp_gr ///
stdgdp_pc stddeposits stdvintagedebt stdinflate democracy stdkaopen stdmonetary stdxrate, fe
estimates store m26f, title(KAGINI20 FE)
estout m26*, cells(b(star fmt(%9.3f)) p(par fmt(%9.2f))) stats(aic bic N) style(tex) varlabels(_cons \_cons)
** Table 34 
xtlogit bankcrisis lbon3_hat stdcagini10 stdregioncrisis_res stdgdp_gr ///
stdgdp_pc stddeposits stdvintagedebt stdinflate democracy stdkaopen stdmonetary stdxrate, pa corr(ar1)
estimates store m27a, title(CA10 AR 1)
xtlogit bankcrisis lbon3_hat stdcagini20 stdregioncrisis_res stdgdp_gr ///
stdgdp_pc stddeposits stdvintagedebt stdinflate democracy stdkaopen stdmonetary stdxrate, pa corr(ar1)
estimates store m27b, title(CA20 AR 1)
xtlogit bankcrisis lbonk3_hat stdkagini20 stdregioncrisis_res_ka stdgdp_gr ///
stdgdp_pc stddeposits stdvintagedebt stdinflate democracy stdkaopen stdmonetary stdxrate, pa corr(ar1)
estimates store m27c, title(KA20 AR 1)
xtlogit bankcrisis lbon3_hat stdcagini10 stdregioncrisis_res stdgdp_gr ///
stdgdp_pc stddeposits stdvintagedebt stdinflate democracy stdkaopen stdmonetary stdxrate, pa corr(ar2)
estimates store m27d, title(CA10 AR 2)
xtlogit bankcrisis lbon3_hat stdcagini20 stdregioncrisis_res stdgdp_gr ///
stdgdp_pc stddeposits stdvintagedebt stdinflate democracy stdkaopen stdmonetary stdxrate, pa corr(ar2)
estimates store m27e, title(CA20 AR 2)
xtlogit bankcrisis lbonk3_hat stdkagini20 stdregioncrisis_res_ka stdgdp_gr ///
stdgdp_pc stddeposits stdvintagedebt stdinflate democracy stdkaopen stdmonetary stdxrate, pa corr(ar2)
estimates store m27f, title(KA20 AR 2)
estout m27*, cells(b(star fmt(%9.3f)) p(par fmt(%9.2f))) stats(aic bic N) style(tex) varlabels(_cons \_cons)
**Table 35
xtprobit bankcrisis lbon3_hat stdcagini10 stdregioncrisis_res stdgdp_gr ///
stdgdp_pc stddeposits stdvintagedebt stdinflate democracy stdkaopen stdmonetary stdxrate 
estimates store m28a, title(CA10 Probit)
xtprobit bankcrisis lbon3_hat stdcagini20 stdregioncrisis_res stdgdp_gr ///
stdgdp_pc stddeposits stdvintagedebt stdinflate democracy stdkaopen stdmonetary stdxrate
estimates store m28b, title(CA20 Probit)
xtprobit bankcrisis lbonk3_hat stdkagini20 stdregioncrisis_res_ka stdgdp_gr ///
stdgdp_pc stddeposits stdvintagedebt stdinflate democracy stdkaopen stdmonetary stdxrate
estimates store m28c, title(KA20 Probit)
firthlogit bankcrisis lbon3_hat stdcagini10 stdregioncrisis_res stdgdp_gr ///
stdgdp_pc stddeposits stdvintagedebt stdinflate democracy stdkaopen stdmonetary stdxrate 
estimates store m28d, title(CA10 Rare)
firthlogit bankcrisis lbon3_hat stdcagini20 stdregioncrisis_res stdgdp_gr ///
stdgdp_pc stddeposits stdvintagedebt stdinflate democracy stdkaopen stdmonetary stdxrate
estimates store m28e, title(CA20 Rare)
firthlogit bankcrisis lbonk3_hat stdkagini20 stdregioncrisis_res_ka stdgdp_gr ///
stdgdp_pc stddeposits stdvintagedebt stdinflate democracy stdkaopen stdmonetary stdxrate
estimates store m28f, title(KA20 Rare)
estout m28*, cells(b(star fmt(%9.3f)) p(par fmt(%9.2f))) stats(aic bic N) style(tex) varlabels(_cons \_cons)
*** Robustness - Abiad and ICRG
xtlogit bankcrisis lbonk3_hat stdkagini10 stdregioncrisis_res_ka stdgdp_gr stdgdp_pc ///
stddeposits stdvintagedebt stdinflate democracy stdkaopen stdmonetary stdxrate stdfinreform, re 
estimates store m29a, title(Finreform)
xtlogit bankcrisis lbonk3_hat stdkagini10 stdregioncrisis_res_ka stdgdp_gr stdgdp_pc ///
stddeposits stdvintagedebt stdinflate democracy stdkaopen stdmonetary stdxrate stdfinreform, fe 
estimates store m29b, title(Finreform FE)
xtlogit bankcrisis lbonk3_hat stdkagini10 stdregioncrisis_res_ka stdgdp_gr transparency, re
estimates store m29c, title(Transparency)
xtlogit bankcrisis lbonk3_hat stdkagini10 stdregioncrisis_res_ka stdgdp_gr ///
stdgdp_pc stddeposits stdvintagedebt stdinflate democracy stdkaopen stdmonetary stdxrate transparency, fe
estimates store m29d, title(Transparency FE)
xtlogit bankcrisis lbonk3_hat stdkagini10 stdregioncrisis_res_ka stdgdp_gr ///
stdgdp_pc stddeposits stdvintagedebt stdinflate democracy stdkaopen stdmonetary stdxrate investprofile, re
estimates store m29e, title(Investment Profile)
xtlogit bankcrisis lbonk3_hat stdkagini10 stdregioncrisis_res_ka stdgdp_gr ///
stdgdp_pc stddeposits stdvintagedebt stdinflate democracy stdkaopen stdmonetary stdxrate investprofile, fe
xtlogit bankcrisis lbonk3_hat stdkagini10 stdregioncrisis_res_ka stdgdp_gr ///
stdgdp_pc stddeposits stdvintagedebt stdinflate democracy stdkaopen stdmonetary stdxrate burqual, re 
estimates store m29f, title(Bur Qual)
xtlogit bankcrisis lbonk3_hat stdkagini10 stdregioncrisis_res_ka stdgdp_gr ///
stdgdp_pc stddeposits stdvintagedebt stdinflate democracy stdkaopen stdmonetary stdxrate burqual, fe 
xtlogit bankcrisis lbonk3_hat stdkagini10 stdregioncrisis_res_ka stdgdp_gr ///
stdgdp_pc stddeposits stdvintagedebt stdinflate democracy stdkaopen stdmonetary stdxrate laworder, re 
estimates store m29e, title(Law Order)
xtlogit bankcrisis lbonk3_hat stdkagini10 stdregioncrisis_res_ka stdgdp_gr ///
stdgdp_pc stddeposits stdvintagedebt stdinflate democracy stdkaopen stdmonetary stdxrate laworder, fe 
xtlogit bankcrisis lbonk3_hat stdkagini10 stdregioncrisis_res_ka stdgdp_gr ///
stdgdp_pc stddeposits stdvintagedebt stdinflate democracy stdkaopen stdmonetary stdxrate govstab
estimates store m29f, title(Gov Stab)
xtlogit bankcrisis lbonk3_hat stdkagini10 stdregioncrisis_res_ka stdgdp_gr ///
stdgdp_pc stddeposits stdvintagedebt stdinflate democracy stdkaopen stdmonetary stdxrate corruption_icrg 
estimates store m29g, title(Corrupt)
xtlogit bankcrisis lbonk3_hat stdkagini10 stdregioncrisis_res_ka stdgdp_gr ///
stdgdp_pc stddeposits stdvintagedebt stdinflate democracy stdkaopen stdmonetary stdxrate icrg_index 
estimates store m29h, title(ICRG Index)
** Table 36
estout m29a m29b m29e m29f, cells(b(star fmt(%9.3f)) p(par fmt(%9.2f))) stats(aic bic N) style(tex) varlabels(_cons \_cons)
** Table 37 
estout m29c m29d m29g m29h, cells(b(star fmt(%9.3f)) p(par fmt(%9.2f))) stats(aic bic N) style(tex) varlabels(_cons \_cons)
** Table 38: Global Models, Gross Flows
xtlogit surges l.surges stdkagini10, re 
estimates store m30a, title(Surges)
xtlogit stops l.stops stdkagini10, re 
estimates store m30b, title(Stops)
xtlogit flight l.flight stdkagini10, re 
estimates store m30c, title(Flight)
xtlogit retrench l.retrench stdkagini10, re 
estimates store m30d, title(Retrench)
estout m30a m30b m30c m30d, cells(b(star fmt(%9.3f)) p(par fmt(%9.2f))) stats(aic bic N) style(tex) varlabels(_cons \_cons)
** Table 39: Global and Regional Models, Gross Flows
*First have to generate regional surge/stop/flight/retrench residuals
/* determine number of obs for each region/year grouping */
by region year, sort: gen surgesgroupvals=_N if surges!=.
/* create count of all surges in a region for a given year */
by region year, sort: egen regionsurges=total(surges)
/* drop values for observations for which there
is no information on surges */
replace regionsurges=. if surges==.
/*adjust down so that not counting surge in own economy */
gen adjregionsurges=regionsurges-surges
/* divide by number of countries in grouping for that given year to scale */
gen adjregionsurgesratio=adjregionsurges/surgesgroupvals
/* regress global variables on region surges and extract residuals */
** standard regression with country fixed effects
regress adjregionsurgesratio fa_gini_10 i.iso3n 
predict regionsurge_ratio_res,res
qnorm regionsurge_ratio_res

/* stops */
by region year, sort: gen stopgroupvals=_N if stops!=.
by region year, sort: egen regionstops=total(stops)
replace regionstops=. if stops==.
gen adjregionstops=regionstops-stops
gen adjregionstopsratio=adjregionstops/stopgroupvals
regress adjregionstopsratio fa_gini_10 i.iso3n 
predict regionstops_ratio_res,res
qnorm regionstops_ratio_res

/* flight */
by region year, sort: gen flightgroupvals=_N if flight!=.
by region year, sort: egen regionflight=total(flight)
replace regionflight=. if flight==.
gen adjregionflight=regionflight-flight
gen adjregionflightratio=adjregionflight/flightgroupvals
regress adjregionflightratio fa_gini_10 i.iso3n 
predict regionflight_ratio_res,res
qnorm regionflight_ratio_res

/* retrench */
by region year, sort: gen retrenchgroupvals=_N if retrench!=.
by region year, sort: egen regionretrench=total(retrench)
replace regionretrench=. if retrench==.
gen adjregionretrench=regionretrench-retrench
gen adjregionretrenchratio=adjregionretrench/retrenchgroupvals
regress adjregionretrenchratio fa_gini_10 i.iso3n 
predict regionretrench_ratio_res,res
qnorm regionretrench_ratio_res

/* Now, estimate the models */
xtlogit surges l.surges stdkagini10 regionsurge_ratio_res, re 
estimates store m30e, title(Surges)
xtlogit stops l.stops stdkagini10 regionstops_ratio_res, re 
estimates store m30f, title(Stops)
xtlogit flight l.flight stdkagini10 regionflight_ratio_res, re 
estimates store m30g, title(Flight)
xtlogit retrench l.retrench stdkagini10 regionretrench_ratio_res, re 
estimates store m30h, title(Retrench)

*** Table 39
estout m30e m30f m30g m30h, cells(b(star fmt(%9.3f)) p(par fmt(%9.2f))) stats(aic bic N) style(tex) varlabels(_cons \_cons)

/* Local Models */
xtlogit surges l.surges stdkagini10 regionsurge_ratio_res stdgdp_gr ///
stdgdp_pc stddeposits stdvintagedebt stdinflate democracy stdkaopen stdmonetary stdxrate, re 
estimates store m30i, title(Surges)
xtlogit stops l.stops stdkagini10 regionstops_ratio_res stdgdp_gr ///
stdgdp_pc stddeposits stdvintagedebt stdinflate democracy stdkaopen stdmonetary stdxrate, re 
estimates store m30j, title(Stops)
xtlogit flight l.flight stdkagini10 regionflight_ratio_res stdgdp_gr ///
stdgdp_pc stddeposits stdvintagedebt stdinflate democracy stdkaopen stdmonetary stdxrate, re 
estimates store m30k, title(Flight)
xtlogit retrench l.retrench stdkagini10 regionretrench_ratio_res stdgdp_gr ///
stdgdp_pc stddeposits stdvintagedebt stdinflate democracy stdkaopen stdmonetary stdxrate, re 
estimates store m30l, title(Retrench)

** Table 40
estout m30i m30j m30k m30l, cells(b(star fmt(%9.3f)) p(par fmt(%9.2f))) stats(aic bic N) style(tex) varlabels(_cons \_cons)

** Table 41: Currency Crisis Robustness
xtlogit currency_crisis lbonk3_hat stdkagini10, re 
estimates store m31a, title(Crisis_World)
/*Model 9 and 11*/
*First have to generate regional currency_crisis residuals
/* determine number of obs for each region/year grouping */
by region year, sort: gen currencygroupvals=_N if currency_crisis!=.
/* create count of all currency_crisis in a region for a given year */
by region year, sort: egen regioncurrency_crisis=total(currency_crisis)
/* drop values for observations for which there
is no information on currency_crisis */
replace regioncurrency_crisis=. if currency_crisis==.
/*adjust down so that not counting currency_crisis in own economy */
gen adjregioncurrency_crisis=regioncurrency_crisis-currency_crisis
/* divide by number of countries in grouping for that given year to scale */
gen adjregioncurrencyratio=adjregioncurrency_crisis/currencygroupvals
/* regress global variables on region currency_crisis and extract residuals */
** standard regression with country fixed effects
regress adjregioncurrencyratio fa_gini_10 i.iso3n 
predict regioncurrency_ratio_res,res
qnorm regioncurrency_ratio_res
/* Now, estimate the models */
xtlogit currency_crisis lbonk3_hat stdkagini10 regioncurrency_ratio_res, re 
estimates store m31b, title(Crisis_Region)
xtlogit currency_crisis lbonk3_hat stdkagini10 regioncurrency_ratio_res stdgdp_gr ///
stdgdp_pc stddeposits stdvintagedebt stdinflate democracy stdkaopen stdmonetary stdxrate, re 
estimates store m31c, title(Crisis_Local)
estout m31a m31b m31c, cells(b(star fmt(%9.3f)) p(par fmt(%9.2f))) stats(aic bic N) style(tex) varlabels(_cons \_cons)


