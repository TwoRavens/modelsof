********************************************************************************************************************************************
********************************************************************************************************************************************
*
* Replication File: Economic Responsiveness and the Political Conditioning of the Electoral Cycle
*
* Sergi Pardos-Prado (sergi.pardos@merton.ox.ac.uk) Merton College - University of Oxford
* Iñaki Sagarzazu (inaki.sagarzazu@ttu.edu) Texas Tech University
*
********************************************************************************************************************************************
********************************************************************************************************************************************


******************************** APPENDIX
********************************************************************************************************************************************

cd "~/Dropbox/PardosSagarzazu/SECOND PAPER - Economy Attention/JOP Submission/Replication/final files"
*use "C:\Users\Sergi\Dropbox\PardosSagarzazu\SECOND PAPER - Economy Attention\new data in wide format.dta", clear

log using "PargosSagarzazu_JOP_Appendix.smcl", replace
use "PardosSagarzazu_JOP.dta", clear


sort timereal
tsset timereal

***************************************************************************************************
*FIGURE 1: Auto-correlation and Partial auto-correlation graphs
***************************************************************************************************


ac gov_saliency, scheme(lean2) ytitle("Autocorrelation of Gov't Attention")
graph export AC_govt.pdf, as(pdf) replace
pac gov_saliency, scheme(lean2) ytitle("Partial-autocorrelation of Gov't Attention")
graph export PAC_govt.pdf, as(pdf) replace
ac opp_mainparty, scheme(lean2) ytitle("Autocorrelation of Oppo Attention")
graph export AC_oppo.pdf, as(pdf) replace
pac opp_mainparty, scheme(lean2) ytitle("Partial-autocorrelation of Oppo Attention")
graph export PAC_oppo.pdf, as(pdf) replace

***************************************************************************************************
*TABLE 4: Robustness checks Table 2
***************************************************************************************************



dfuller gov_saliency 
dfuller opp_mainparty 
dfuller mip_imputed
dfuller gdp_growth
dfuller unemp
dfuller media
dfuller econcurrent_agr


***************************************************************************************************
*TABLE 5: Robustness checks Table 2
***************************************************************************************************



quietly: reg gov_saliency  l.gov_saliency unemp l.unemp gdp_growth l.gdp_growth mip_imputed  l.mip_imputed  econcurrent_agr l.econcurrent_agr ///
opp_mainparty l.opp_mainparty media l.media timereal

 
estat dwatson
estat durbinalt, robust   
estat hettest   

capture drop resid
predict resid, r
wntestq resid 


quietly: reg opp_mainparty  l.opp_mainparty  unemp l.unemp gdp_growth l.gdp_growth mip_imputed  l.mip_imputed econcurrent_agr l.econcurrent_agr ///
gov_saliency l.gov_saliency media l.media timereal

estat dwatson
estat durbinalt, robust   
estat hettest   

capture drop resid
predict resid, r
wntestq resid 



***************************************************************************************************
*TABLE 6: Robustness checks Table 3
***************************************************************************************************


quietly: reg gov_saliency   l.opp_mainparty l.elecycle l.oppmain_cycle l.gov_saliency opp_mainparty unemp l.unemp gdp_growth l.gdp_growth  ///
mip_imputed l.mip_imputed econcurrent_agr l.econcurrent_agr  media l.media timereal  
 

estat dwatson
estat durbinalt, robust   
estat hettest   

capture drop resid
predict resid, r
wntestq resid 

quietly: reg gov_saliency l.mip_imputed l.elecycle l.mipimput_cycle l.gov_saliency mip_imputed opp_mainparty l.opp_mainparty unemp l.unemp gdp_growth l.gdp_growth  ///
econcurrent_agr l.econcurrent_agr  media l.media timereal

estat dwatson
estat durbinalt, robust   
estat hettest   

capture drop resid
predict resid, r
wntestq resid 

quietly: reg opp_mainparty  l.gov_saliency l.elecycle l.gov_cycle gov_saliency l.opp_mainparty unemp l.unemp gdp_growth l.gdp_growth  ///
mip_imputed l.mip_imputed econcurrent_agr l.econcurrent_agr  media l.media timereal  
 

estat dwatson
estat durbinalt, robust   
estat hettest   

capture drop resid
predict resid, r
wntestq resid 


quietly: reg opp_mainparty l.mip_imputed l.elecycle l.mipimput_cycle l.gov_saliency gov_saliency mip_imputed  l.opp_mainparty unemp l.unemp gdp_growth l.gdp_growth  ///
econcurrent_agr l.econcurrent_agr  media l.media timereal


estat dwatson
estat durbinalt, robust   
estat hettest   

capture drop resid
predict resid, r
wntestq resid 

***************************************************************************************************
*TABLE 7: Summary statistics
***************************************************************************************************

sum gov_saliency opp_mainparty elecycle unemp gdp_growth  mip_imputed econcurrent_agr  ///
  media  timereal if timereal!=. & gdp_growth!=. & media!=.
  
estpost tabstat gov_saliency opp_mainparty elecycle unemp gdp_growth  mip_imputed    econcurrent_agr  ///
  media  timereal if timereal!=. & gdp_growth!=. & media!=. , listwise statistics(n mean sd min max) columns(statistics) 

esttab, cell("count mean sd min max") nomtitle nonumber tex 

***************************************************************************************************
*TABLE 8: ADL models predicting media economic attention, citizens economic perceptions, and MIP
***************************************************************************************************


quietly: reg media l.media unemp l.unemp gdp_growth l.gdp_growth gov_saliency l.gov_saliency opp_mainparty l.opp_mainparty  ///
l.mip_imputed  mip_imputed econcurrent_agr l.econcurrent_agr timereal

est store direct_media


quietly: reg d.econcurrent_agr media l.media d.unemp  gdp_growth l.gdp_growth gov_saliency l.gov_saliency opp_mainparty l.opp_mainparty  ///
l.mip_imputed  mip_imputed   timereal

est store direct_econcurrent

quietly: reg mip_imputed l.mip_imputed gov_saliency l.gov_saliency unemp l.unemp gdp_growth l.gdp_growth econcurrent_agr l.econcurrent_agr ///
opp_mainparty l.opp_mainparty media l.media timereal

est store direct_mip

 estout direct_media direct_econcurrent direct_mip, cells(b(star fmt(4)) se(par fmt(3)))   ///
   legend label varlabels(_cons constant) starlevels(* 0.1 ** 0.05 *** 0.01)               ///
   stats(N F r2 ll bic, fmt(3 0 3) label(N F R-sqr LogLik BIC)) style(tex)

  
***************************************************************************************************
*TABLE 9: ADL models predicting government and opposition economic attention with first
* differences for unemployment and economic perceptions
***************************************************************************************************


quietly: reg gov_saliency  l.gov_saliency d.unemp gdp_growth l.gdp_growth mip_imputed  l.mip_imputed  d.econcurrent_agr ///
opp_mainparty l.opp_mainparty media l.media timereal

est store fd1


quietly: reg opp_mainparty  l.opp_mainparty  d.unemp gdp_growth l.gdp_growth mip_imputed  l.mip_imputed d.econcurrent_agr ///
gov_saliency l.gov_saliency media l.media timereal

est store fd2


 estout fd1 fd2, cells(b(star fmt(4)) se(par fmt(3)))   ///
   legend label varlabels(_cons constant) starlevels(* 0.1 ** 0.05 *** 0.01)               ///
   stats(N F r2 ll bic, fmt(3 0 3) label(N F R-sqr LogLik BIC)) style(tex)


***************************************************************************************************
*TABLE 10: ADL models predicting government economic attention with first differences for
* unemployment and economic perceptions
***************************************************************************************************



quietly: reg gov_saliency   l.opp_mainparty l.elecycle l.oppmain_cycle l.gov_saliency opp_mainparty d.unemp gdp_growth l.gdp_growth  ///
mip_imputed l.mip_imputed d.econcurrent_agr  media l.media timereal  
 
est store fd3


quietly: reg gov_saliency l.mip_imputed l.elecycle l.mipimput_cycle l.gov_saliency mip_imputed opp_mainparty l.opp_mainparty d.unemp gdp_growth l.gdp_growth  ///
d.econcurrent_agr  media l.media timereal


est store fd4


quietly: reg opp_mainparty  l.gov_saliency l.elecycle l.gov_cycle gov_saliency l.opp_mainparty d.unemp gdp_growth l.gdp_growth  ///
mip_imputed l.mip_imputed d.econcurrent_agr  media l.media timereal  
 
est store fd5


quietly: reg opp_mainparty l.mip_imputed l.elecycle l.mipimput_cycle l.gov_saliency gov_saliency mip_imputed  l.opp_mainparty d.unemp gdp_growth l.gdp_growth  ///
d.econcurrent_agr  media l.media timereal


est store fd6



 estout fd3 fd4 fd5 fd6 , cells(b(star fmt(4)) se(par fmt(3)))   ///
   legend label varlabels(_cons constant) starlevels(* 0.1 ** 0.05 *** 0.01)               ///
   stats(N F r2 ll bic, fmt(3 0 3) label(N F R-sqr LogLik BIC)) style(tex)


   
***************************************************************************************************
*TABLE 11: ADL models predicting government economic attention with electoral cycle,
* macro-economy, and media interactions
***************************************************************************************************

quietly: reg gov_saliency   l.gdp_growth l.elecycle l.growth_cycle l.gov_saliency opp_mainparty l.opp_mainparty unemp l.unemp gdp_growth   ///
mip_imputed l.mip_imputed econcurrent_agr l.econcurrent_agr  media l.media timereal
 
est store gov_cycle3

quietly: reg gov_saliency   l.unemp l.elecycle l.unemp_cycle unemp l.gov_saliency l.opp_mainparty opp_mainparty gdp_growth l.gdp_growth ///
mip_imputed l.mip_imputed l.econcurrent_agr econcurrent_agr l.media media timereal

est store gov_cycle4

quietly: reg gov_saliency   l.cpi_b2006 l.elecycle l.infl_cycle cpi_b2006 l.opp_mainparty opp_mainparty l.gov_saliency l.unemp unemp ///
mip_imputed l.mip_imputed l.econcurrent_agr econcurrent_agr l.media media timereal


est store gov_cycle5

quietly: reg gov_saliency   l.econcurrent_agr l.elecycle l.econcur_cycle econcurrent_agr l.opp_mainparty opp_mainparty l.gov_saliency ///
l.unemp unemp gdp_growth l.gdp_growth mip_imputed l.mip_imputed l.media media timereal

est store gov_cycle6

quietly: reg gov_saliency   l.media l.elecycle l.media_cycle media l.gov_saliency l.opp_mainparty  opp_mainparty l.unemp unemp ///
gdp_growth l.gdp_growth mip_imputed l.mip_imputed l.econcurrent_agr econcurrent_agr timereal


est store gov_cycle7


estout gov_cycle3 gov_cycle4 gov_cycle5 gov_cycle6 gov_cycle7, cells(b(star fmt(4)) se(par fmt(3)))   ///
   legend label varlabels(_cons constant) starlevels(* 0.1 ** 0.05 *** 0.01)               ///
   stats(N F r2 ll bic, fmt(3 0 3) label(N F R-sqr LogLik BIC)) style(tex)

***************************************************************************************************
*TABLE 12: ADL models predicting opposition economic attention with electoral cycle,
* macro-economy, and media interactions
***************************************************************************************************


quietly: reg opp_mainparty  l.gdp_growth l.elecycle l.growth_cycle gdp_growth gov_saliency l.gov_saliency l.opp_mainparty unemp l.unemp    ///
mip_imputed l.mip_imputed econcurrent_agr l.econcurrent_agr  media l.media timereal  
 
est store opp_cycle3


quietly: reg opp_mainparty  l.unemp l.elecycle l.unemp_cycle  gov_saliency l.gov_saliency l.opp_mainparty unemp gdp_growth l.gdp_growth   ///
mip_imputed l.mip_imputed econcurrent_agr l.econcurrent_agr  media l.media timereal  
 
est store opp_cycle4

quietly: reg opp_mainparty   l.cpi_b2006 l.elecycle l.infl_cycle cpi_b2006 l.opp_mainparty l.gov_saliency gov_saliency l.unemp unemp ///
mip_imputed l.mip_imputed l.econcurrent_agr econcurrent_agr l.media media timereal

est store opp_cycle5

quietly: reg opp_mainparty   l.econcurrent_agr l.elecycle l.econcur_cycle econcurrent_agr l.opp_mainparty  l.gov_saliency gov_saliency ///
l.unemp unemp gdp_growth l.gdp_growth mip_imputed l.mip_imputed l.media media timereal

est store opp_cycle6

quietly: reg opp_mainparty   l.media l.elecycle l.media_cycle media gov_saliency l.gov_saliency l.opp_mainparty  l.unemp unemp ///
gdp_growth l.gdp_growth mip_imputed l.mip_imputed l.econcurrent_agr econcurrent_agr timereal

est store opp_cycle7

estout opp_cycle3 opp_cycle4 opp_cycle5 opp_cycle6 opp_cycle7, cells(b(star fmt(4)) se(par fmt(3)))   ///
   legend label varlabels(_cons constant) starlevels(* 0.1 ** 0.05 *** 0.01)               ///
   stats(N F r2 ll bic, fmt(3 0 3) label(N F R-sqr LogLik BIC)) style(tex)
   
   
***************************************************************************************************
*TABLE 13: Replication of Table 2 with inflation and excluding GDP growth
***************************************************************************************************


quietly: reg gov_saliency  l.gov_saliency unemp l.unemp  mip_imputed  l.mip_imputed  econcurrent_agr l.econcurrent_agr ///
opp_mainparty l.opp_mainparty media l.media timereal cpi_b2006 l.cpi_b2006

est store e1


quietly: reg opp_mainparty  l.opp_mainparty  unemp l.unemp mip_imputed  l.mip_imputed econcurrent_agr l.econcurrent_agr ///
gov_saliency l.gov_saliency media l.media timereal cpi_b2006 l.cpi_b2006

est store e2


estout e1 e2, cells(b(star fmt(4)) se(par fmt(3)))   ///
   legend label varlabels(_cons constant) starlevels(* 0.1 ** 0.05 *** 0.01)               ///
   stats(N F r2 ll bic, fmt(3 0 3) label(N F R-sqr LogLik BIC)) style(tex)
   
   
***************************************************************************************************
*TABLE 14: Replication of Table 3 with inflation and excluding GDP growth
***************************************************************************************************



quietly: reg gov_saliency   l.opp_mainparty l.elecycle l.oppmain_cycle l.gov_saliency opp_mainparty unemp l.unemp   ///
mip_imputed l.mip_imputed econcurrent_agr l.econcurrent_agr  media l.media timereal cpi_b2006 l.cpi_b2006

est store e3

 
quietly: reg gov_saliency l.mip_imputed l.elecycle l.mipimput_cycle l.gov_saliency mip_imputed opp_mainparty l.opp_mainparty unemp l.unemp  ///
econcurrent_agr l.econcurrent_agr  media l.media timereal cpi_b2006 l.cpi_b2006

est store e4

quietly: reg opp_mainparty  l.gov_saliency l.elecycle l.gov_cycle gov_saliency l.opp_mainparty unemp l.unemp   ///
mip_imputed l.mip_imputed econcurrent_agr l.econcurrent_agr  media l.media timereal cpi_b2006 l.cpi_b2006 
 
est store e5

quietly: reg opp_mainparty l.mip_imputed l.elecycle l.mipimput_cycle l.gov_saliency gov_saliency mip_imputed  l.opp_mainparty unemp l.unemp   ///
econcurrent_agr l.econcurrent_agr  media l.media timereal cpi_b2006 l.cpi_b2006

est store e6


estout e3 e4 e5 e6, cells(b(star fmt(4)) se(par fmt(3)))   ///
   legend label varlabels(_cons constant) starlevels(* 0.1 ** 0.05 *** 0.01)               ///
   stats(N F r2 ll bic, fmt(3 0 3) label(N F R-sqr LogLik BIC)) style(tex)
   

***************************************************************************************************
*TABLE 15: Replication of models from Table 2 without LDV or time trend
***************************************************************************************************

quietly: reg gov_saliency  unemp l.unemp gdp_growth l.gdp_growth mip_imputed  l.mip_imputed  econcurrent_agr l.econcurrent_agr ///
opp_mainparty l.opp_mainparty media l.media

est store t1

quietly: reg opp_mainparty   unemp l.unemp gdp_growth l.gdp_growth mip_imputed  l.mip_imputed econcurrent_agr l.econcurrent_agr ///
gov_saliency l.gov_saliency media l.media 

est store t2

estout t1 t2 , cells(b(star fmt(4)) se(par fmt(3)))   ///
   legend label varlabels(_cons constant) starlevels(* 0.1 ** 0.05 *** 0.01)               ///
   stats(N F r2 ll bic, fmt(3 0 3) label(N F R-sqr LogLik BIC)) style(tex)


***************************************************************************************************
*TABLE 16: Replication of models from Table 3 without LDV or time trend
***************************************************************************************************


quietly: reg gov_saliency   l.opp_mainparty l.elecycle l.oppmain_cycle opp_mainparty unemp l.unemp gdp_growth l.gdp_growth  ///
mip_imputed l.mip_imputed econcurrent_agr l.econcurrent_agr  media l.media 

est store t3

quietly: reg gov_saliency l.mip_imputed l.elecycle l.mipimput_cycle mip_imputed opp_mainparty l.opp_mainparty unemp l.unemp gdp_growth l.gdp_growth  ///
econcurrent_agr l.econcurrent_agr  media l.media 

est store t4

quietly: reg opp_mainparty  l.gov_saliency l.elecycle l.gov_cycle gov_saliency  unemp l.unemp gdp_growth l.gdp_growth  ///
mip_imputed l.mip_imputed econcurrent_agr l.econcurrent_agr  media l.media   
 
est store t5

quietly: reg opp_mainparty l.mip_imputed l.elecycle l.mipimput_cycle l.gov_saliency gov_saliency mip_imputed   unemp l.unemp gdp_growth l.gdp_growth  ///
econcurrent_agr l.econcurrent_agr  media l.media 

est store t6

estout t3 t4 t5 t6 , cells(b(star fmt(4)) se(par fmt(3)))   ///
   legend label varlabels(_cons constant) starlevels(* 0.1 ** 0.05 *** 0.01)               ///
   stats(N F r2 ll bic, fmt(3 0 3) label(N F R-sqr LogLik BIC)) style(tex)
   
***************************************************************************************************
*TABLE 17: Replication of models from Table 2 with legislature fixed effects
***************************************************************************************************


gen legislatura1=legislatura==6
gen legislatura2=legislatura==7
gen legislatura3=legislatura==8
gen legislatura4=legislatura==9


quietly: reg gov_saliency  l.gov_saliency unemp l.unemp gdp_growth l.gdp_growth mip_imputed  l.mip_imputed  econcurrent_agr l.econcurrent_agr ///
opp_mainparty l.opp_mainparty media l.media timereal legislatura2 legislatura3 legislatura4

est store legisl1

quietly: reg opp_mainparty  l.opp_mainparty  unemp l.unemp gdp_growth l.gdp_growth mip_imputed  l.mip_imputed econcurrent_agr l.econcurrent_agr ///
gov_saliency l.gov_saliency media l.media timereal legislatura2 legislatura3 legislatura4

est store legisl2

estout legisl1 legisl2 , cells(b(star fmt(4)) se(par fmt(3)))   ///
   legend label varlabels(_cons constant) starlevels(* 0.1 ** 0.05 *** 0.01)               ///
   stats(N F r2 ll bic, fmt(3 0 3) label(N F R-sqr LogLik BIC)) style(tex)

***************************************************************************************************
*TABLE 18: Replication of models from Table 3 with legislature fixed effects
***************************************************************************************************


quietly: reg gov_saliency   l.opp_mainparty l.elecycle l.oppmain_cycle l.gov_saliency opp_mainparty unemp l.unemp gdp_growth l.gdp_growth  ///
mip_imputed l.mip_imputed econcurrent_agr l.econcurrent_agr  media l.media timereal legislatura2 legislatura3 legislatura4  


est store legisl3
 
quietly: reg gov_saliency l.mip_imputed l.elecycle l.mipimput_cycle l.gov_saliency mip_imputed opp_mainparty l.opp_mainparty unemp l.unemp gdp_growth l.gdp_growth  ///
econcurrent_agr l.econcurrent_agr  media l.media timereal legislatura2 legislatura3 legislatura4

est store legisl4


quietly: reg opp_mainparty  l.gov_saliency l.elecycle l.gov_cycle gov_saliency  unemp l.unemp gdp_growth l.gdp_growth  ///
mip_imputed l.mip_imputed econcurrent_agr l.econcurrent_agr  media l.media  l.opp_mainparty timereal legislatura2 legislatura3 legislatura4
 
est store legisl5


quietly: reg opp_mainparty l.mip_imputed l.elecycle l.mipimput_cycle l.gov_saliency gov_saliency mip_imputed   unemp l.unemp gdp_growth l.gdp_growth  ///
econcurrent_agr l.econcurrent_agr  media l.media l.opp_mainparty timereal legislatura2 legislatura3 legislatura4 


est store legisl6


estout legisl3 legisl4 legisl5 legisl6 , cells(b(star fmt(4)) se(par fmt(3)))   ///
   legend label varlabels(_cons constant) starlevels(* 0.1 ** 0.05 *** 0.01)               ///
   stats(N F r2 ll bic, fmt(3 0 3) label(N F R-sqr LogLik BIC)) style(tex)


***************************************************************************************************
*TABLE 19: Replication of models from Table 2 with total attention to economy
***************************************************************************************************



quietly: reg gov_saliency  l.gov_saliency unemp l.unemp gdp_growth l.gdp_growth mip_imputed  l.mip_imputed  econcurrent_agr l.econcurrent_agr ///
opp_mainparty l.opp_mainparty media l.media timereal total l.total

est store total1


quietly: reg opp_mainparty  l.opp_mainparty  unemp l.unemp gdp_growth l.gdp_growth mip_imputed  l.mip_imputed econcurrent_agr l.econcurrent_agr ///
gov_saliency l.gov_saliency media l.media timereal total l.total

est store total2

estout total1 total2 , cells(b(star fmt(4)) se(par fmt(3)))   ///
   legend label varlabels(_cons constant) starlevels(* 0.1 ** 0.05 *** 0.01)               ///
   stats(N F r2 ll bic, fmt(3 0 3) label(N F R-sqr LogLik BIC)) style(tex)


***************************************************************************************************
*TABLE 20: Replication of models from Table 3 with total attention to economy
***************************************************************************************************


quietly: reg gov_saliency l.opp_mainparty l.elecycle l.oppmain_cycle l.gov_saliency opp_mainparty unemp l.unemp gdp_growth l.gdp_growth  ///
mip_imputed l.mip_imputed econcurrent_agr l.econcurrent_agr  media l.media timereal total l.total 

est store total3

 
quietly: reg gov_saliency l.mip_imputed l.elecycle l.mipimput_cycle l.gov_saliency mip_imputed opp_mainparty l.opp_mainparty unemp l.unemp gdp_growth l.gdp_growth  ///
econcurrent_agr l.econcurrent_agr  media l.media timereal total l.total

est store total4


quietly: reg opp_mainparty l.gov_saliency l.elecycle l.oppmain_cycle gov_saliency l.opp_mainparty unemp l.unemp gdp_growth l.gdp_growth  ///
mip_imputed l.mip_imputed econcurrent_agr l.econcurrent_agr  media l.media timereal total l.total 

est store total5

 
quietly: reg opp_mainparty l.mip_imputed l.elecycle l.mipimput_cycle l.opp_mainparty mip_imputed gov_saliency l.gov_saliency unemp l.unemp gdp_growth l.gdp_growth  ///
econcurrent_agr l.econcurrent_agr  media l.media timereal total l.total

est store total6


estout total3 total4 total5 total6 , cells(b(star fmt(4)) se(par fmt(3)))   ///
   legend label varlabels(_cons constant) starlevels(* 0.1 ** 0.05 *** 0.01)               ///
   stats(N F r2 ll bic, fmt(3 0 3) label(N F R-sqr LogLik BIC)) style(tex)


***************************************************************************************************
*TABLE 21: Replication of models from Table 3 with contemporaneous cycle
***************************************************************************************************


gen opp_mainparty_lag = l.opp_mainparty
gen mipimputed_lag=l.mip_imputed
gen gov_saliency_lag=l.gov_saliency

quietly: reg gov_saliency   l.opp_mainparty l.gov_saliency opp_mainparty unemp l.unemp gdp_growth l.gdp_growth  ///
mip_imputed l.mip_imputed econcurrent_agr l.econcurrent_agr  media l.media timereal c.opp_mainparty_lag##c.elecycle

est store cont3

 
quietly: reg gov_saliency  l.opp_mainparty l.gov_saliency opp_mainparty unemp l.unemp gdp_growth l.gdp_growth  ///
mip_imputed l.mip_imputed econcurrent_agr l.econcurrent_agr  media l.media timereal  c.mipimputed_lag##c.elecycle

est store cont4



quietly: reg opp_mainparty   l.mip_imputed  l.gov_saliency gov_saliency mip_imputed  l.opp_mainparty unemp l.unemp gdp_growth l.gdp_growth  ///
econcurrent_agr l.econcurrent_agr  media l.media timereal c.gov_saliency_lag##c.elecycle

est store cont5


quietly: reg opp_mainparty  l.mip_imputed  l.gov_saliency gov_saliency mip_imputed  l.opp_mainparty unemp l.unemp gdp_growth l.gdp_growth  ///
econcurrent_agr l.econcurrent_agr  media l.media timereal c.mipimputed_lag##c.elecycle


est store cont6



estout cont3 cont4 cont5 cont6 , cells(b(star fmt(4)) se(par fmt(3)))   ///
   legend label varlabels(_cons constant) starlevels(* 0.1 ** 0.05 *** 0.01)               ///
   stats(N F r2 ll bic, fmt(3 0 3) label(N F R-sqr LogLik BIC)) style(tex)

****************************************************** Non-Parametric Models




sort timereal
tsset timereal

***************************************************************************************************
*FIGURE 2: Kernel locally weighted regressions (1996-2000)
***************************************************************************************************


lpoly gov_saliency elecycle if legislatura==6, kernel(epanechnikov) ci legend(off) graphregion(color(white)) xline(16) ///
title(VI Legislature: 1996-2000, size(small)) xtitle(Electoral cycle, size(small)) ytitle(Government attention) 

graph export npm1.pdf, as(pdf) replace

lpoly opp_mainparty elecycle if legislatura==6, kernel(epanechnikov) ci legend(off) graphregion(color(white)) xline(16) ///
title(VI Legislature: 1996-2000, size(small)) xtitle(Electoral cycle, size(small)) ytitle(Opposition attention) 

graph export npm2.pdf, as(pdf) replace

***************************************************************************************************
*FIGURE 3: Kernel locally weighted regressions (2000-2004)
***************************************************************************************************


lpoly gov_saliency elecycle if legislatura==7, kernel(epanechnikov) ci legend(off) graphregion(color(white)) xline(17) ///
title(VII Legislature: 2000-2004, size(small)) xtitle(Electoral cycle, size(small)) ytitle(Government attention) 

graph export npm3.pdf, as(pdf) replace

lpoly opp_mainparty elecycle if legislatura==7, kernel(epanechnikov) ci legend(off) graphregion(color(white)) xline(17) ///
title(VII Legislature: 2000-2004, size(small)) xtitle(Electoral cycle, size(small)) ytitle(Opposition attention) 

graph export npm4.pdf, as(pdf) replace

lpoly mipnational_agr elecycle if legislatura==7, kernel(epanechnikov) ci legend(off) graphregion(color(white)) xline(17) ///
title(VII Legislature: 2000-2004, size(small)) xtitle(Electoral cycle, size(small)) ytitle(Public opinion attention) 

graph export npm5.pdf, as(pdf) replace

***************************************************************************************************
*FIGURE 4: Kernel locally weighted regressions (2004-2008)
***************************************************************************************************

lpoly gov_saliency elecycle if legislatura==8, kernel(epanechnikov) ci legend(off) graphregion(color(white)) xline(17) ///
title(VIII Legislature: 2004-2008, size(small)) xtitle(Electoral cycle, size(small)) ytitle(Government attention) 

graph export npm6.pdf, as(pdf) replace

lpoly opp_mainparty elecycle if legislatura==8, kernel(epanechnikov) ci legend(off) graphregion(color(white)) xline(17) ///
title(VIII Legislature: 2004-2008, size(small)) xtitle(Electoral cycle, size(small)) ytitle(Opposition attention) 

graph export npm7.pdf, as(pdf) replace

lpoly mipnational_agr elecycle if legislatura==8, kernel(epanechnikov) ci legend(off) graphregion(color(white)) xline(17) ///
title(VIII Legislature: 2004-2008, size(small)) xtitle(Electoral cycle, size(small)) ytitle(Public opinion attention) 

graph export npm8.pdf, as(pdf) replace

***************************************************************************************************
*FIGURE 5: Kernel locally weighted regressions (2008-2011)
***************************************************************************************************


lpoly gov_saliency elecycle if legislatura==9, kernel(epanechnikov) ci legend(off) graphregion(color(white)) xline(7) ///
title(IX Legislature: 2008-2011, size(small)) xtitle(Electoral cycle, size(small)) ytitle(Government atention) 

graph export npm9.pdf, as(pdf) replace

lpoly opp_mainparty elecycle if legislatura==9, kernel(epanechnikov) ci legend(off) graphregion(color(white)) xline(7) ///
title(IX Legislature: 2008-2011, size(small)) xtitle(Electoral cycle, size(small)) ytitle(Opposition atention) 

graph export npm10.pdf, as(pdf) replace

lpoly mipnational_agr elecycle if legislatura==9, kernel(epanechnikov) ci legend(off) graphregion(color(white)) xline(7) ///
title(IX Legislature: 2008-2011, size(small)) xtitle(Electoral cycle, size(small)) ytitle(Public opinion atention) 

graph export npm11.pdf, as(pdf) replace

log close
