/* This do file performs core analysis for 
Bauerle Danzman, Oatley, and Winecoff. Specifically,
it generates Tables 1 and 2 and Figures 6-14. */

clear
set mem 100m
set more off
*cd "\\Client\H$\Dropbox\Capital_Flows_Paper\ISQ R&R\Data and Analysis"


use isqrr12012.dta, clear
**************************************************
**** BONANZA MODELS	******************************
**************************************************
estat ic
tab countryname if e(sample)==1

xtset iso3n year


**************************************************
*** Generate Regional Bonanza Residual ***********
**************************************************
*** Code and qnorm plots in Appendix B
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

** drop unnecessary variables
drop yhat_adjregionbonanzaratio res_regionbonanzaratio regbon_hat_ratio_re regbon_ratio_re_res
drop regionbonanzaka_ratio_res  regionbonanzaka_ratio_res regionbonanza_ratio_res 
drop regbon_ratio_fe_res 

***************
*** Table 1 ***
***************
*** Model 1 & 2: Bonanza - CA Gini
xtlogit bonanza l.bonanza stdkagini10, re /* Model 1 */
estat ic
xtlogit bonanza l.bonanza stdkagini10, fe /* Model 2 */
estat ic
*** Model 3&4: Bonanza - CA Gini plus regional effects
xtlogit bonanza l.bonanza stdkagini10 stdregionbonanzaka_ratio_res, re /* Model 3 */
estat ic
xtlogit bonanza l.bonanza stdkagini10 stdregionbonanzaka_ratio_res, fe /* Model 4 */
estat ic
*** Model 5&6: Bonanza - CA Gini plus regional effects and local effects
xtlogit bonanza l.bonanza stdkagini10 stdregionbonanzaka_ratio_res stdgdp_gr ///
stdgdp_pc stddeposits stdvintagedebt stdinflate democracy stdkaopen stdmonetary stdxrate, re /* Model 5 */
estat ic
xtlogit bonanza l.bonanza stdkagini10 stdregionbonanzaka_ratio_res stdgdp_gr ///
stdgdp_pc stddeposits stdvintagedebt stdinflate democracy stdkaopen stdmonetary stdxrate, fe /* Model 6 */
estat ic 

*********************************
**** Predicted Probabilities ****
*********************************
** Figure 6
logit bonanza i.lbonanza stdkagini10 stdregionbonanzaka_ratio_res stdgdp_gr ///
stdgdp_pc stddeposits stdvintagedebt stdinflate democracy stdkaopen stdmonetary stdxrate
margins, at(stdkagini10=(-2.5(.1)1.5)) atmeans vsquish
marginsplot, scheme(s2mono)
** Substantive Effects on pg. 26
margins, at(stdkagini10 = 0) atmeans
margins, at(stdkagini10 = 1) atmeans
margins, at(stdkagini10 = -1) atmeans
** Figure 7
margins lbonanza, at(stdkagini10=(-2.5(.2)1.5)) atmeans vsquish
marginsplot, by(lbonanza) scheme (s2mono)
** Substantive Effects on pg. 27
margins, at(stdkagini10 = 0 lbonanza=1) atmeans
margins, at(stdkagini10 = 1 lbonanza=1) atmeans
margins, at(stdkagini10 = -1 lbonanza=1) atmeans

** Figure 8
margins lbonanza, at(stdregionbonanzaka_ratio_res=(-2.6(.3)5.3)) atmeans vsquish
marginsplot, by(lbonanza)scheme(s2mono)
** Substantive Effects on pg. 27
margins, at(stdregionbonanzaka_ratio_res = 0) atmeans
margins, at(stdregionbonanzaka_ratio_res = 1) atmeans
margins, at(stdregionbonanzaka_ratio_res = 0 lbonanza=1) atmeans
margins, at(stdregionbonanzaka_ratio_res = 1 lbonanza=1) atmeans
** Figure 9
margins, at(stdgdp_pc=(-2.4(.5)2.15)) atmeans
marginsplot, scheme (s2mono)

**************************************************
**** BANK CRISIS MODELS	**************************
**************************************************

**************************************************
*** Generate Lagged Bonanza Residual *************
**************************************************
/* Next, extract residuals from bonanza to create a measure of the incidence
of bonanza unexplained by KA GINI */
**** spare model (keeps as many observations as possible)
gen lbonanza=l.bonanza
logit bonanza lbonanza stdkagini10 stdregionbonanzaka_ratio_res
predict bon_hat
gen bon_res=bonanza-bon_hat
qnorm bon_res
logit bonanza lbonanza stdkagini10
predict bon2_hat
gen bon2_res=bonanza-bon2_hat
qnorm bon2_res
** standard regression with country fixed effects
reg bonanza lbonanza stdkagini10 stdregionbonanzaka_ratio_res i.iso3n
predict bonk3_hat, res
qnorm bonk3_hat
** standard regression with country fixed effects CAGINI
reg bonanza lbonanza stdcagini10 stdres_regionbonanza_fe i.iso3n
predict bon3_hat, res
qnorm bon3_hat
gen lbonk3_hat=l.bonk3_hat
gen lbon3_hat=l.bon3_hat
drop bon_hat bon_res bon2_hat bon2_res bonk3_hat bon3_hat 
** full model
reg bonanza lbonanza stdkagini10 stdregionbonanzaka_ratio_res stdgdp_gr ///
stdgdp_pc stddeposits stdvintagedebt stdinflate democracy stdkaopen stdmonetary stdxrate i.iso3n
predict bonk4_hat, res
qnorm bonk4_hat
gen lbonk4_hat=l.bonk4_hat
drop bonk4_hat 

**************************************************
*** Generate Regional Crisis Residual ***********
**************************************************
** poisson 
xtpoisson adjregioncrisisratio stdkagini10, fe
predict regioncrisis_hat
gen res_regioncrisis_poisson=adjregioncrisisratio-regioncrisis_hat
qnorm res_regioncrisis_poisson
** random effects cross sectional time series
xtreg adjregioncrisisratio stdkagini10, re
predict regioncrisis_hat2
gen res_regioncrisis_re=adjregioncrisisratio-regioncrisis_hat2
qnorm res_regioncrisis_re
** standard regression with country fixed effects
**** This is the best one.
regress adjregioncrisisratio stdkagini10 i.iso3n 
predict regioncrisis_hat4_ka
gen res_regioncrisis_fe2_ka=adjregioncrisisratio-regioncrisis_hat4_ka
qnorm res_regioncrisis_fe2_ka
** standard regression
regress adjregioncrisisratio stdkagini10
predict regioncrisis_hat5
gen res_regioncrisis_2=adjregioncrisisratio-regioncrisis_hat5
qnorm res_regioncrisis_2
drop regioncrisis_hat res_regioncrisis_poisson regioncrisis_hat2 res_regioncrisis_re ///
regioncrisis_hat5 res_regioncrisis_2
** CAGINI standard regression with country fixed effects
regress adjregioncrisisratio stdcagini10 i.iso3n 
predict regioncrisis_hat4
gen res_regioncrisis_fe2=adjregioncrisisratio-regioncrisis_hat4
qnorm res_regioncrisis_fe2
egen stdregioncrisis_res=std(res_regioncrisis_fe2)
egen stdregioncrisis_res_ka=std(res_regioncrisis_fe2_ka)

***************
*** Table 2 ***
***************
*** Model 7&8: Crisis - Global
xtlogit bankcrisis lbonk3_hat stdkagini10, re /* Model 7 */
estat ic
xtlogit bankcrisis lbonk3_hat stdkagini10, fe /* Model 8 */
estat ic
*** Models 9&10: Crisis - CA Gini plus regional effects
xtlogit bankcrisis lbonk3_hat stdkagini10 stdregioncrisis_res_ka, re /* Model 9 */
estat ic
xtlogit bankcrisis lbonk3_hat stdkagini10 stdregioncrisis_res_ka, fe /* Model 10 */
estat ic
*** Model 11&12: Crisis - CA Gini plus regional and local effects
xtlogit bankcrisis lbonk3_hat stdkagini10 stdregioncrisis_res_ka stdgdp_gr ///
stdgdp_pc stddeposits stdvintagedebt stdinflate democracy stdkaopen stdmonetary stdxrate, re /* Model 11 */
estat ic
xtlogit bankcrisis lbonk3_hat stdkagini10 stdregioncrisis_res_ka stdgdp_gr ///
stdgdp_pc stddeposits stdvintagedebt stdinflate democracy stdkaopen stdmonetary stdxrate, fe /* Model 12 */
estat ic

*********************************
**** Predicted Probabilities ****
*********************************
** Figure 10
logit bankcrisis lbonk3_hat stdkagini10 stdregioncrisis_res_ka stdgdp_gr ///
stdgdp_pc stddeposits stdvintagedebt stdinflate democracy stdkaopen stdmonetary stdxrate
margins, at(stdkagini10=(-2.5(.2)1.5)) atmeans vsquish
marginsplot, scheme(s2mono)
** Substantive effects (pg. 30)
margins, at(stdkagini10 = 0) atmeans 
margins, at(stdkagini10 = 1) atmeans
margins, at(stdkagini10 = -1) atmeans
margins if lbonanza==1, at(stdkagini10 = 0) atmeans 
margins if lbonanza==1, at(stdkagini10 = 1) atmeans
margins if lbonanza==1, at(stdkagini10 = -1) atmeans
** Figure 11
margins, at(stdregioncrisis_res_ka=(-1.26(1)5.3)) atmeans vsquish
marginsplot, scheme(s2mono)
** Substantive effects (pg. 31)
margins, at(stdregioncrisis_res_ka = 0) atmeans 
margins, at(stdregioncrisis_res_ka = 1) atmeans
margins, at(stdregioncrisis_res_ka = -1) atmeans
** Figure 12
margins, at(stdgdp_gr=(-2.4(.2)2.2)) atmeans vsquish
marginsplot, scheme(s2mono)


*** Comparative ROC plots
logit bonanza l.bonanza stdkagini10 i.year  /* Model 1 */
lroc, nograph
predict Global_Model, xb
logit bonanza l.bonanza stdkagini10 stdregionbonanzaka_ratio_res i.year /* Model 3 */
lroc, nograph
predict Plus_Regional, xb
logit bonanza l.bonanza stdkagini10 stdregionbonanzaka_ratio_res stdgdp_gr ///
stdgdp_pc stddeposits stdvintagedebt stdinflate democracy stdkaopen stdmonetary stdxrate i.year /* Model 5 */
lroc, nograph
predict Plus_Local, xb

** Figure 13
roccomp bonanza Global_Model Plus_Regional Plus_Local, graph summary 

logit bankcrisis lbonk3_ha stdkagini10 i.year /* Model 7 */
lroc, nograph
predict xb4, xb
logit bankcrisis lbonk3_hat stdkagini10 stdregioncrisis_res_ka i.year /* Model 9 */
lroc, nograph
predict xb5, xb
logit bankcrisis lbonk3_hat stdkagini10 stdregioncrisis_res_ka stdgdp_gr ///
stdgdp_pc stddeposits stdvintagedebt stdinflate democracy stdkaopen stdmonetary stdxrate i.year /* Model 11 */
lroc, nograph
predict xb6, xb

** Figure 14
roccomp bonanza xb4 xb5 xb6, graph summary
