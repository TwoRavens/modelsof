**********************************************************************
**********************************************************************
**Leaders, Tenure, and the Politics of Sovereign Credit by P. Shea and J. Solis
**Replication file for the appendix of this article (Stata v15)

**(Results for main results in separate file (II_leader_main.do))
*****************************************************************
**



cd "C:\Users\Shea\Dropbox\Assassination\Work\Data\Analysis"

use "leadexp_082317.dta", clear
set more off
xtset ccode year 

********************************************************************************************
*****B - Summary Stats. 

sutex avg_sp iirating ratio2 lnten democracy2 growth gdp_pc lngdp ///
if year >=1980, minmax labels

sutex ratio2 lnten lngdp pdgdp lngdppc  ///
if year <=2006, minmax labels


********************************************************************************************
*****C - Leader Tenure and Credit Volatility


use "leadexp_082317.dta", clear
set more off
xtset ccode year

*fill in gaps in time-series data and gaps in panel data with
*new observations containing missing values
tsfill

*Generating moving averages and variance
**ssc install mvsumm
mvsumm avg_sp if year>=1980, stat(mean) win(5) gen(movesp2) end force
mvsumm avg_sp if year>=1980, stat(sd) win(5) gen(sdsp2) end force
mvsumm avg_sp if year>=1980, stat(iqr) win(5) gen(sdsp21) end force


mvsumm iirating if year>=1980, stat(mean) win(5) gen(moveii2) end force
mvsumm iirating if year>=1980, stat(sd) win(5) gen(sdii2) end force
mvsumm iirating if year>=1980, stat(iqr) win(5) gen(sdii21) end force


mvsumm ratio2 if year>=1980, stat(mean) win(5) gen(moverat2) end force
mvsumm ratio2 if year>=1980, stat(sd) win(5) gen(sdratio22) end force
mvsumm ratio2 if year>=1980, stat(iqr) win(5) gen(sdratio221) end force

  
lab var  sdsp2  "S\&P Volatility"  
lab var  sdii2 "\emph{II} Volatility"  
lab var  sdratio22  "Bond Yield Volatility"  
lab var hh1  "Sectoral concentration"
lab var nv_srv_tetc_zs "Service Sector"
lab var lnpop2 "Population"  
 
  
 gen sdratio222 = sdratio22*(1/moverat2)
 gen sdii22 = sdii2*(1/moveii2)
 gen sdsp22 = sdsp2*(1/movesp2)


reg3  (F.avg_sp lnten democracy2   growth gdp_pc lngdp avg_sp sdsp2 i.ccode) ///
(F.sdsp2 lnten democracy2   growth gdp_pc lngdp hh1 nv_srv_tetc_zs lnpop2 L4.avg_sp )
estimates store m1

reg3  (F.iirating lnten democracy2   growth gdp_pc lngdp iirating sdii2 i.ccode) ///
(F.sdii2 lnten democracy2   growth gdp_pc lngdp hh1 nv_srv_tetc_zs lnpop2 L4.iirating )
estimates store m2

reg3  (F.ratio2  lnten democracy2   growth gdp_pc lngdp ratio2 sdratio22   i.ccode) ///
 (F.sdratio22 lnten democracy2   growth gdp_pc lngdp hh1 nv_srv_tetc_zs lnpop2 L4.ratio2) if year>=1980
 estimates store m3

  
estout m1 m2 m3, unstack cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) ///
eqlab("/lnsig2u" "ln($\sigma^2_u$)", none) ///
starlevels( * 0.05  ) ///
stats( rmse r2 chi2 N, fmt(%9.3f %9.3f %9.1f  %9.0f) labels("RMSE" "R-Squared" "$\chi^2$" "N"))  style(tex) ///
legend label collabels(none)  varlabels(_cons Constant) order(lnten  democracy2   growth gdp_pc lngdp  hh1 nv_srv_tetc_zs lnpop2 ) drop(*.ccode) ///
mlabels ("Model 1"  ) ///
title("")

  
 **IQR models (mentioned in Footnote 1 in appendix)
 reg3  (F.avg_sp lnten democracy2   growth gdp_pc lngdp avg_sp sdsp21 i.ccode) ///
(F.sdsp21 lnten democracy2   growth gdp_pc lngdp hh1 nv_srv_tetc_zs lnpop2 L4.avg_sp )
reg3  (F.iirating lnten democracy2   growth gdp_pc lngdp iirating sdii21 i.ccode) ///
(F.sdii21 lnten democracy2   growth gdp_pc lngdp hh1 nv_srv_tetc_zs lnpop2 L4.iirating )
reg3  (F.ratio2  lnten democracy2   growth gdp_pc lngdp sdratio221 ratio2  i.ccode) ///
 (F.sdratio221 lnten democracy2   growth gdp_pc lngdp hh1 nv_srv_tetc_zs lnpop2 L4.ratio2) if year>=1980
 
 

 **Relative ST Dev (mentioned in Footnote 1 in appendix)
 reg3  (F.avg_sp lnten democracy2   growth gdp_pc lngdp avg_sp sdsp22 i.ccode) ///
(F.sdsp22 lnten democracy2   growth gdp_pc lngdp hh1 nv_srv_tetc_zs lnpop2 L4.avg_sp )
reg3  (F.iirating lnten democracy2   growth gdp_pc lngdp iirating sdii22 i.ccode) ///
(F.sdii22 lnten democracy2   growth gdp_pc lngdp hh1 nv_srv_tetc_zs lnpop2 L4.iirating )
reg3  (F.ratio2  lnten democracy2   growth gdp_pc lngdp ratio2 sdratio222   i.ccode) ///
 (F.sdratio222 lnten democracy2   growth gdp_pc lngdp hh1 nv_srv_tetc_zs lnpop2 L4.ratio2) if year>=1980


**variation among ratings (mentioned in Footnote 1 in appendix)
xtset ccode year
reg3  (F.mean_rating lnten democracy2   growth gdp_pc lngdp mean_rating sd_rating i.ccode) ///
(F.sd_rating lnten democracy2   growth gdp_pc lngdp hh1 nv_srv_tetc_zs lnpop2 )

** Hetregress (mentioned in Footnote 2 in appendix)
xtset ccode year
hetregress F.avg_sp lnten democracy2   growth gdp_pc lngdp avg_sp  i.ccode, het(lnten) twostep
hetregress F.iirating lnten democracy2   growth gdp_pc lngdp iirating  i.ccode, het(lnten) twostep
hetregress F.ratio2 lnten democracy2   growth gdp_pc lngdp ratio2  i.ccode if year>=1980, het(lnten)  twostep




********************************************************************************************
***** Section D Robustness Checks

*D1 - ECM 

use "leadexp_082317.dta", clear
set more off

xtset ccode year 


gen liirating = l.iirating 
gen lavg_sp = l.avg_sp
gen llnten = l.lnten

gen lratio2  = l.ratio2 

xtreg D.iirating  liirating llnten d.lnten d.democracy2  d.growth d.gdp_pc d.lngdp  ///
 l.democracy2  l.growth l.gdp_pc l.lngdp yr_* ,fe
estimates store ec1

*Deriving LRM
nlcom abs(_b[llnten])/abs(_b[ liirating]) 




xtreg D.avg_sp  lavg_sp llnten d.lnten d.democracy2  d.growth d.gdp_pc d.lngdp  ///
 l.democracy2  l.growth l.gdp_pc l.lngdp yr_* ,fe
estimates store ec2

*Deriving LRM
nlcom abs(_b[llnten])/abs(_b[lavg_sp]) 






xtreg D.ratio2  lratio2 llnten d.lnten d.democracy2  d.pdgdp d.lngdppc d.lngdp2  ///
 l.democracy2  l.pdgdp l.lngdppc l.lngdp2 yr_* , fe
 estimates store ec3

 *Deriving LRM
nlcom _b[llnten]/_b[lratio2] 



lab var liirating "Investor Rating"
lab var gdp_pc "GDP per cap"
lab var growth "Growth"
lab var lavg_sp "S\&P Rating" 
lab var lratio2 "Bond Yield" 


lab var llnten "Leader Tenure"

estout ec2 ec1 ec3   , cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) ///
	eqlab("/lnsig2u" "ln($\sigma^2_u$)", none) ///
	starlevels( * 0.1 ** 0.05 *** 0.01 ) ///
stats( r2 aic N N_g, fmt(%9.2f %9.0f) labels("R-Squared" "AIC" "N" "Countries"))  style(tex) ///
legend label collabels(none) rename(D.lngdp2  D.lngdp D.pdgdp D.growth D.lngdppc D.gdp_pc L.lngdp2  L.lngdp L.pdgdp L.growth L.lngdppc L.gdp_pc ) ///
 varlabels(_cons Constant) order() drop( yr_*) ///
mlabels ("Model 1"  ) ///
title("")



********************************************************************************************
*****D2 - Selection Models



use "leadexp_082317.dta", clear
set more off


xtset ccode year 


set more off

probit spdata  lnten democracy2    growth gdp_pc lngdp  regiondata_by syrs s2 s3
estimates store s1
capture drop p1
predict p1, xb

*Deriving mills inverse

gen mills1 = exp(-.5*p1^2)/(sqrt(2*_pi)*normprob(p1))

xtreg F.avg_sp lnten democracy2  growth gdp_pc lngdp  avg_sp yr_* mills1  if year>=1980, fe
estimates store o1


probit bonded  lnten democracy2    growth gdp_pc lngdp  regiondata_by byrs b2 b3
estimates store s2
predict p2, xb

*Deriving mills inverse

gen mills2 = exp(-.5*p2^2)/(sqrt(2*_pi)*normprob(p2))

xtreg  F.ratio2 lnten democracy2  growth gdp_pc lngdp  ratio2 yr_* mills2, fe
estimates store o2

   estout o1 s1 o2 s2, cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) ///
	starlevels( * 0.05  )  ///
stats(N , fmt(%9.0f ) labels("N"))  style(tex) ///
legend label collabels(none) rename( regiondata_by  regiondata_sp )  varlabels(_cons Constant) order(lnten avg_sp ratio2) drop(yr_* mills* s2 s3 b2 b3 ) 


********************************************************************************************
*****D3 -  Additional Controls

use "leadexp_082317.dta", clear
set more off

xtset ccode year 

xtreg F1.ratio2 lnten democracy2 rdefault  growth gdp_pc lngdp  ratio2 yr_* if year>=1980,fe
estimates store ec1

xtreg F1.avg_sp lnten democracy2 rdefault  growth gdp_pc lngdp  avg_sp yr_*,fe
estimates store ec2

xtreg F1.iirating lnten democracy2  rdefault  growth gdp_pc lngdp  iirating yr_*,fe
estimates store ec3


xtreg F1.ratio2 lnten democracy2 currencycrisisbi  growth gdp_pc lngdp  ratio2 yr_* if year>=1980,fe
estimates store ec12

xtreg F1.avg_sp lnten democracy2 currencycrisisbi  growth gdp_pc lngdp  avg_sp yr_*,fe
estimates store ec22


xtreg F1.iirating lnten democracy2  currencycrisisbi  growth gdp_pc lngdp  iirating yr_*,fe
estimates store ec32


xtreg F1.ratio2 lnten democracy2 inflation  growth gdp_pc lngdp  ratio2 yr_* if year>=1980,fe
estimates store ec13


xtreg F1.avg_sp lnten democracy2 inflation  growth gdp_pc lngdp  avg_sp yr_*,fe
estimates store ec23
 
xtreg F1.iirating lnten democracy2  inflation  growth gdp_pc lngdp  iirating yr_*,fe
estimates store ec33

estout ec2 ec3 ec1 ec22 ec32 ec12 ec23 ec33 ec13, cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) ///
	eqlab("/lnsig2u" "ln($\sigma^2_u$)", none) ///
	starlevels( * 0.1 ** 0.05 *** 0.01 ) ///
stats( r2 aic N N_g, fmt(%9.2f %9.0f) labels("R-Squared" "AIC" "N" "Countries"))  style(tex) ///
legend label collabels(none) rename(lngdp2  lngdp pdgdp growth lngdppc gdp_pc )  varlabels(_cons Constant) keep( lnten rdefault currencycrisisbi inflation) ///
mlabels ("Model 1"  ) ///
title("")



xtreg F1.ratio2 lnten democracy2 i_debtGDP  growth gdp_pc lngdp  ratio2 yr_* if year>=1980,fe
estimates store ec14


xtreg F1.avg_sp lnten democracy2 i_debtGDP growth gdp_pc lngdp  avg_sp yr_*,fe
estimates store ec24


xtreg F1.iirating lnten democracy2  i_debtGDP growth gdp_pc lngdp  iirating yr_*,fe
estimates store ec34


xtreg F1.ratio2 lnten democracy2 conflict  growth gdp_pc lngdp  ratio2 yr_* if year>=1980,fe
estimates store ec15


xtreg F1.avg_sp lnten democracy2 conflict  growth gdp_pc lngdp  avg_sp yr_*,fe
estimates store ec25


xtreg F1.iirating lnten democracy2  conflict growth gdp_pc lngdp  iirating yr_*,fe
estimates store ec35

xtreg F1.ratio2 lnten democracy2 oilrents growth gdp_pc lngdp  ratio2 yr_* if year>=1980,fe
estimates store ec16

xtset ccode year 
xtreg F1.avg_sp lnten democracy2 oilrents growth gdp_pc lngdp  avg_sp yr_*,fe
estimates store ec26


xtreg F1.iirating lnten democracy2  oilrents growth gdp_pc lngdp  iirating yr_*,fe
estimates store ec36


estout ec24 ec34 ec14 ec25 ec35 ec15 ec26 ec36 ec16, cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) ///
	eqlab("/lnsig2u" "ln($\sigma^2_u$)", none) ///
	starlevels( * 0.1 ** 0.05 *** 0.01) ///
stats( r2 aic N N_g, fmt(%9.2f %9.0f) labels("R-Squared" "AIC" "N" "Countries"))  style(tex) ///
legend label collabels(none) rename(lngdp2  lngdp pdgdp growth lngdppc gdp_pc )  varlabels(_cons Constant) keep( lnten i_debtGDP  conflict oilrents) ///
mlabels ( ) ///
title("")

xtset ccode year 
set more off
xtreg F1.ratio2 lnten democracy2 financialmarketsdepthindexfd_fmd  growth gdp_pc lngdp  ratio2 yr_* if year>=1980,fe
estimates store ec14


xtreg F1.avg_sp lnten democracy2 financialmarketsdepthindexfd_fmd growth gdp_pc lngdp  avg_sp yr_*,fe
estimates store ec24


xtreg F1.iirating lnten democracy2  financialmarketsdepthindexfd_fmd growth gdp_pc lngdp  iirating yr_*,fe
estimates store ec34


xtreg F1.ratio2 lnten democracy2 fs_ast_doms_gd_zs growth gdp_pc lngdp  ratio2 yr_* if year>=1980,fe
estimates store ec15


xtreg F1.avg_sp lnten democracy2 fs_ast_doms_gd_zs growth gdp_pc lngdp  avg_sp yr_*,fe
estimates store ec25


xtreg F1.iirating lnten democracy2  fs_ast_doms_gd_zs growth gdp_pc lngdp  iirating yr_*,fe
estimates store ec35

xtreg F1.ratio2 lnten democracy2   bcbd growth gdp_pc lngdp  ratio2 yr_* if year>=1980,fe
estimates store ec16

xtset ccode year 
xtreg F1.avg_sp lnten democracy2  bcbd growth gdp_pc lngdp  avg_sp yr_*,fe
estimates store ec26

xtset ccode year 
xtreg F1.iirating lnten democracy2    bcbd growth gdp_pc lngdp  iirating yr_*,fe
estimates store ec36



estout ec24 ec34 ec14 ec25 ec35 ec15 ec26 ec36 ec16, cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) ///
	eqlab("/lnsig2u" "ln($\sigma^2_u$)", none) ///
	starlevels( * 0.1 ** 0.05 *** 0.01) ///
stats( r2 aic N N_g, fmt(%9.2f %9.0f) labels("R-Squared" "AIC" "N" "Countries"))  style(tex) ///
legend label collabels(none) rename(lngdp2  lngdp pdgdp growth lngdppc gdp_pc )  varlabels(_cons Constant) ///
keep(lnten financialmarketsdepthindexfd_fmd fs_ast_doms_gd_zs  bcbd ) ///
mlabels ( ) ///
title("")


set more off
xtreg F1.iirating lnten democracy2 rdefault currencycrisisbi inflation i_debtGDP conflict oilrents ///
 financialmarketsdepthindexfd_fmd fs_ast_doms_gd_zs   bcbd  growth gdp_pc lngdp  iirating yr_*,fe
 estimates store a1
 
xtreg F1.avg_sp lnten democracy2 rdefault currencycrisisbi inflation i_debtGDP conflict oilrents ///
 financialmarketsdepthindexfd_fmd fs_ast_doms_gd_zs   bcbd  growth gdp_pc lngdp  avg_sp yr_*,fe
estimates store a2

xtreg F1.ratio2 lnten democracy2 rdefault currencycrisisbi inflation i_debtGDP conflict  oilrents ///
 financialmarketsdepthindexfd_fmd fs_ast_doms_gd_zs bcbd growth gdp_pc lngdp  ratio2 yr_* if year>=1980,fe
estimates store a3

lab var bcbd "Bank credit ratio"

estout  a2 a1 a3, cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) ///
	eqlab("/lnsig2u" "ln($\sigma^2_u$)", none) ///
	starlevels( * 0.1 ** 0.05 *** 0.01) ///
stats( r2 aic N N_g, fmt(%9.2f %9.0f) labels("R-Squared" "AIC" "N" "Countries"))  style(tex) ///
legend label collabels(none) rename(lngdp2  lngdp pdgdp growth lngdppc gdp_pc )  varlabels(_cons Constant) drop(yr_*)  ///
mlabels ( ) ///
order(lnten democracy2 rdefault currencycrisisbi inflation i_debtGDP conflict  oilrents ///
 financialmarketsdepthindexfd_fmd fs_ast_doms_gd_zs   bcbd  growth gdp_pc lngdp) ///
title("")



****************************************************************************************
*** D4 Previous Experience
************************************
use "leadexp_082317.dta", clear
set more off

xtset ccode year 



xtreg F1.ratio2 lnten max_econ econx  democracy2 pdgdp lngdppc lngdp2  ratio2 yr_* ,fe
estimates store m3 

xtreg F1.avg_sp lnten max_econ econx  democracy2   growth gdp_pc lngdp  avg_sp yr_*,fe
estimates store m1

xtreg F1.iirating lnten max_econ econx  democracy2  growth gdp_pc lngdp  iirating yr_*,fe
estimates store m2 


xtreg F1.ratio2 lnten max_edu2 edux  democracy2   pdgdp lngdppc lngdp2 ratio2 yr_* ,fe
estimates store m31 
xtreg F1.avg_sp lnten  max_edu2 edux  democracy2   growth gdp_pc lngdp  avg_sp yr_*,fe
estimates store m11 
xtreg F1.iirating lnten max_edu2 edux  democracy2  growth gdp_pc lngdp  iirating yr_*,fe
estimates store m21 

xtreg F1.ratio2 lnten mean_exp expx2  democracy2   pdgdp lngdppc lngdp2   ratio2 yr_* ,fe
estimates store m32 
xtreg F1.avg_sp lnten  mean_exp expx2  democracy2   growth gdp_pc lngdp  avg_sp yr_*,fe
estimates store m12
xtreg F1.iirating lnten mean_exp expx2  democracy2  growth gdp_pc lngdp  iirating yr_*,fe
estimates store m22 

xtreg F1.ratio2 lnten expall expallx democracy2   pdgdp lngdppc lngdp2   ratio2 yr_* ,fe
estimates store m33 
xtreg F1.avg_sp lnten  expall expallx  democracy2   growth gdp_pc lngdp  avg_sp yr_*,fe
estimates store m13 
xtreg F1.iirating lnten expall expallx  democracy2  growth gdp_pc lngdp  iirating yr_*,fe
estimates store m23 


 
estout m1 m2 m3 m11 m21 m31 m12 m22 m32, cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) ///
	eqlab("/lnsig2u" "ln($\sigma^2_u$)", none) ///
	starlevels( * 0.1 ) ///
stats( r2 aic N N_g, fmt(%9.2f %9.0f) labels("R-Squared" "AIC" "N" "Countries"))  style(tex) ///
legend label collabels(none) rename(lngdp2  lngdp pdgdp growth lngdppc gdp_pc )  varlabels(_cons Constant) order(lnten ) drop( democracy2 avg_sp iirating ratio2 growth gdp_pc lngdp  yr_*) ///
mlabels ("Model 1"  ) ///
title("")


****************************************************************************************
***D5 Default and Tenure
************************************
use "leadexp_082317.dta", clear
set more off

xtset ccode year 


probit F.rdefault lnten democracy2 ukus lnidebt growth gdp_pc lngdp  dyrs d2 d3 , cluster(ccode)
estimates store m1

probit F.rdefault lnten   democracy2 ukus lnidebt pdgdp  lngdppc lngdp2 dyrs d2 d3 , cluster(ccode)
estimates store m2

probit F.ext_onset lnten democracy2 ukus lnidebt growth gdp_pc lngdp ddyrs dd2 dd3 , cluster(ccode)
estimates store m3

probit F.ext_onset lnten   democracy2 ukus lnidebt pdgdp lngdppc lngdp2 ddyrs dd2 dd3 , cluster(ccode)
estimates store m4

estout m1  m3 m2 m4, cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) ///
	eqlab("/lnsig2u" "ln($\sigma^2_u$)", none) ///
	starlevels( * 0.1 ) ///
stats( ll aic N , fmt(%9.2f %9.0f) labels("Log Likelihood" "AIC" "N" ))  style(tex) ///
legend label collabels(none) rename(lngdp2  lngdp pdgdp growth lngdppc gdp_pc )  varlabels(_cons Constant) order(lnten democracy2 ) drop( d2 d3 dd3 dd2) 


replace ext_onset = . if ext_onset==1 & l.ext_all==1

gen ten_def2 = lnten*ext_onset

lab var ext_onset "Default Onset"

lab var ten_def2 "Tenure*Default Onset"


xtreg F1.ratio2 lnten democracy2 ext_onset ten_def2 dyrs growth gdp_pc lngdp   ratio2  if year>=1980,fe
estimates store ec11

xtreg F1.avg_sp lnten democracy2 ext_onset ten_def2 dyrs growth gdp_pc lngdp   avg_sp  ,fe
estimates store ec21

xtreg F1.iirating lnten democracy2  ext_onset ten_def2 dyrs growth gdp_pc lngdp  iirating  ,fe
estimates store ec31

estout ec21 ec31 ec11, cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) ///
	eqlab("/lnsig2u" "ln($\sigma^2_u$)", none) ///
	starlevels( * 0.05) ///
stats( ll aic N , fmt(%9.2f %9.0f) labels("Log Likelihood" "AIC" "N" ))  style(tex) ///
legend label collabels(none) rename(lngdp2  lngdp pdgdp growth lngdppc gdp_pc )  varlabels(_cons Constant) order(lnten ext_onset ten_def2 ) 


****************************************************************************************
***D6. Omitting LDV
************************************
use "leadexp_082317.dta", clear
set more off

xtset ccode year 

xtset ccode year 
xtreg F1.avg_sp lnten democracy2   growth gdp_pc lngdp  yr_*,fe
estimates store ec2

xtset ccode year 
xtreg F1.iirating lnten democracy2  growth gdp_pc lngdp   yr_*,fe
estimates store ec3

xtreg F1.ratio2 lnten democracy2   growth gdp_pc lngdp  yr_* if year>=1980,fe
estimates store ec1

xtreg F1.ratio2 lnten democracy2  pdgdp lngdppc lngdp2   yr_* if year<1980,fe
estimates store ec12

xtreg F1.ratio2 lnten democracy2  pdgdp lngdppc lngdp2  yr_*,fe
estimates store ec13

estout ec2 ec3 ec1 ec12 ec13 , cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) ///
	eqlab("/lnsig2u" "ln($\sigma^2_u$)", none) ///
	starlevels( * 0.05  ) ///
stats( r2 aic N N_g, fmt(%9.2f %9.0f) labels("R-Squared" "AIC" "N" "Countries"))  style(tex) ///
legend label collabels(none) rename(lngdp2  lngdp pdgdp growth lngdppc gdp_pc )  varlabels(_cons Constant) order(lnten) drop( yr_*) ///
mlabels ("Model 1"  ) ///
title("")



****************************************************************************************
***D7. Multiple imputation
************************************

use "leadexp_082317.dta", clear
set more off
xtset ccode year 

drop democracy2

sum avg_sp iirating ratio2 if year>=1980 & year<=2012
sum avg_sp iirating ratio2 if year>=1980 & year<=2012 &lnten!=. 
sum avg_sp iirating ratio2 if year>=1980 & year<=2012 &lnten!=. & polity2!=. 
sum avg_sp iirating ratio2 if year>=1980 & year<=2012 &lnten!=. & growth!=. 
sum avg_sp iirating ratio2 if year>=1980 & year<=2012 &lnten!=. & gdp_pc!=. 
sum avg_sp iirating ratio2 if year>=1980 & year<=2012 &lnten!=. & lngdp!=. 

gen by_mi = 1 if ratio2!=. & year>=1980 & year<=2012 &lnten!=.
gen sp_mi = 1 if avg_sp!=. & year>=1980 & year<=2012 &lnten!=.
gen ii_mi = 1 if iirating!=. & year>=1980 & year<=2012 &lnten!=.


mi set mlong

mi xtset ccode year

mi misstable patterns avg_sp iirating ratio2 lnten polity2 growth gdp_pc lngdp if year>=1980 & year<=2012 &lnten!=. 
mi misstable patterns lnten polity2 growth gdp_pc lngdp regiondata_by   syrs  if year>=1980 & year<=2012 &lnten!=. 

mi register regular avg_sp iirating ratio2 lnten yr_* regiondata_sp  spdata syrs s2 s3 bonded  regiondata_by byrs b2 b3
mi register imputed polity2 growth gdp_pc lngdp 
mi stset, clear 



mi impute mvn polity2  growth gdp_pc lngdp  = lnten   ///
 if year>=1980 & year<=2012 &lnten!=.  , add(10) rseed(123456) 

mi xeq 0 1 10: summarize polity2  growth gdp_pc lngdp
 
mi passive: gen democracy2 = 1 if polity2!=.
mi passive: replace democracy2 = 0 if polity2<6


mi estimate, post: xtreg F1.ratio2 lnten democracy2 growth gdp_pc lngdp  ratio2 yr_*  if year>=1980, fe
estimates store m3

mi estimate, post: xtreg F1.avg_sp lnten democracy2 growth gdp_pc lngdp  avg_sp yr_*  if year>=1980, fe
estimates store m1
mi estimate, post: xtreg F1.iirating lnten democracy2 growth gdp_pc lngdp iirating yr_*  if year>=1980, fe
estimates store m2


estout m1 m2 m3 , cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) ///
	eqlab("/lnsig2u" "ln($\sigma^2_u$)", none) ///
	starlevels( * 0.05  ) ///
stats(  N N_g, fmt( %9.0f) labels( "N" "Countries"))  style(tex) ///
legend label collabels(none) ///
 varlabels(_cons Constant democracy2 Democracy) order(lnten lnten democracy2 growth gdp_pc lngdp avg_sp iirating ratio2) drop( yr_*) ///
mlabels ("Model 1"  ) ///
title("")

**Selection models
mi estimate, post saving(spsel.ster, replace): probit F.spdata  lnten democracy2  growth gdp_pc lngdp  regiondata_sp   syrs s2 s3 if year>=1980
   mi predict p2 using "spsel.ster", xb
estimates store m1a
mi passive: gen mills2 = exp(-.5*p2^2)/(sqrt(2*_pi)*normprob(p2))



mi estimate, post: xtreg F1.avg_sp lnten democracy2 growth gdp_pc lngdp  avg_sp yr_* mills2 if year>=1980, fe
estimates store m1b

mi estimate, post saving(bysel.ster, replace): probit F.bonded  lnten democracy2  growth gdp_pc lngdp  regiondata_by   byrs b2 b3 
   mi predict p3 using "bysel.ster", xb
estimates store m2a
mi passive: gen mills1 = exp(-.5*p3^2)/(sqrt(2*_pi)*normprob(p3))

mi estimate, post: xtreg F1.ratio2  lnten democracy2 growth gdp_pc lngdp ratio2  yr_* mills1, fe
estimates store m2b


estout m1a  m1b m2a m2b , cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) ///
	eqlab("/lnsig2u" "ln($\sigma^2_u$)", none) ///
	starlevels( * 0.05  ) ///
stats(  N N_g, fmt( %9.0f) labels( "N" "Countries"))  style(tex) ///
legend label collabels(none)   varlabels(_cons Constant) order(lnten avg_sp ratio2) drop(yr_* mills* s2 s3 b2 b3 ) ///
mlabels () ///
title("")



*********Including Oil Rents





use "leadexp_082317.dta", clear
set more off
xtset ccode year 

drop democracy2


mi set mlong

mi xtset ccode year

mi register regular avg_sp iirating ratio2 lnten yr_* regiondata_sp  spdata syrs s2 s3 bonded  regiondata_by byrs b2 b3
mi register imputed polity2 growth gdp_pc lngdp oilrents
mi stset, clear 



mi impute mvn polity2  growth gdp_pc lngdp oilrents  = lnten   ///
 if year>=1980 & year<=2012 &lnten!=.  , add(10) rseed(123456) 

mi xeq 0 1 10: summarize polity2  growth gdp_pc lngdp oilrents
 
mi passive: gen democracy2 = 1 if polity2!=.
mi passive: replace democracy2 = 0 if polity2<6


mi xtset ccode year

mi estimate, post: xtreg F1.ratio2 lnten oilrents democracy2 growth gdp_pc lngdp  ratio2 yr_*  if year>=1980, fe
estimates store m3

mi estimate, post: xtreg F1.avg_sp lnten oilrents democracy2 growth gdp_pc lngdp  avg_sp yr_*  if year>=1980, fe
estimates store m1
mi estimate, post: xtreg F1.iirating lnten oilrents democracy2 growth gdp_pc lngdp iirating yr_*  if year>=1980, fe
estimates store m2


estout m1 m2 m3 , cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) ///
	eqlab("/lnsig2u" "ln($\sigma^2_u$)", none) ///
	starlevels( * 0.05  ) ///
stats(  N N_g, fmt( %9.0f) labels( "N" "Countries"))  style(tex) ///
legend label collabels(none) ///
 varlabels(_cons Constant democracy2 Democracy) order(lnten oilrents democracy2 growth gdp_pc lngdp avg_sp iirating ratio2) drop( yr_*) ///
mlabels ("Model 1"  ) ///
title("")

**Selection model with oil rents (not reported in appendix)


mi estimate, post saving(spsel.ster, replace): probit F.spdata  lnten oilrents democracy2  growth gdp_pc lngdp  regiondata_sp   syrs s2 s3 if year>=1980
   mi predict p2 using "spsel.ster", xb
estimates store m1a
mi passive: gen mills2 = exp(-.5*p2^2)/(sqrt(2*_pi)*normprob(p2))



mi estimate, post: xtreg F1.avg_sp lnten oilrents democracy2 growth gdp_pc lngdp  avg_sp yr_* mills2 if year>=1980, fe
estimates store m1b

mi estimate, post saving(bysel.ster, replace): probit F.bonded  lnten  oilrents democracy2  growth gdp_pc lngdp  regiondata_by   byrs b2 b3 
   mi predict p3 using "bysel.ster", xb
estimates store m2a
mi passive: gen mills1 = exp(-.5*p3^2)/(sqrt(2*_pi)*normprob(p3))

mi estimate, post: xtreg F1.ratio2  lnten oilrents democracy2 growth gdp_pc lngdp ratio2  yr_* mills1, fe
estimates store m2b


estout m1a  m1b m2a m2b , cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) ///
	eqlab("/lnsig2u" "ln($\sigma^2_u$)", none) ///
	starlevels( * 0.05  ) ///
stats(  N N_g, fmt( %9.0f) labels( "N" "Countries"))  style(tex) ///
legend label collabels(none)  varlabels(_cons Constant) order(lnten avg_sp ratio2) drop(yr_* mills* s2 s3 b2 b3 ) ///
mlabels () ///
title("")







****Alternative imputation models (mentioned, but not reported in appendix). 

use "leadexp_082317.dta", clear
set more off
xtset ccode year 



mi set mlong

mi xtset ccode year

mi misstable patterns avg_sp iirating ratio2 lnten democracy2 growth gdp_pc lngdp if year>=1980 & year<=2012 &lnten!=. 
mi misstable patterns lnten democracy2 growth gdp_pc lngdp regiondata_by   syrs  if year>=1980 & year<=2012 &lnten!=. 

mi register passive avg_sp iirating ratio2 lnten yr_* regiondata_sp  spdata syrs s2 s3 bonded  regiondata_by byrs b2 b3
mi register imputed democracy2 growth gdp_pc lngdp 
mi stset, clear 
mi impute mvn  democracy2 growth gdp_pc lngdp  = lnten year regiondata_sp  spdata syrs s2 s3 bonded  regiondata_by byrs b2 b3 ///
 if year>=1980 & year<=2012 &lnten!=.  , add(10) rseed(123456)


mi xtset ccode year

mi estimate, post: xtreg F1.ratio2 lnten democracy2 growth gdp_pc lngdp  ratio2 yr_*  if year>=1980, fe
estimates store m3

mi estimate, post: xtreg F1.avg_sp lnten democracy2 growth gdp_pc lngdp  avg_sp yr_*  if year>=1980, fe
estimates store m1
mi estimate, post: xtreg F1.iirating lnten democracy2 growth gdp_pc lngdp iirating yr_*  if year>=1980, fe
estimates store m2


estout m1 m2 m3 , cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) ///
	eqlab("/lnsig2u" "ln($\sigma^2_u$)", none) ///
	starlevels( * 0.05  ) ///
stats(  N N_g, fmt( %9.0f) labels( "N" "Countries"))  style(tex) ///
legend label collabels(none)  ///
 varlabels(_cons Constant) order(lnten lnten democracy2 growth gdp_pc lngdp avg_sp iirating ratio2) drop( yr_*) ///
mlabels ("Model 1"  ) ///
title("")


mi estimate, post saving(spsel.ster, replace): probit F.spdata  lnten democracy2  growth gdp_pc lngdp  regiondata_sp   syrs s2 s3 if year>=1980
   mi predict p2 using "spsel.ster", xb
estimates store m1a
mi passive: gen mills2 = exp(-.5*p2^2)/(sqrt(2*_pi)*normprob(p2))



mi estimate, post: xtreg F1.avg_sp lnten democracy2 growth gdp_pc lngdp  avg_sp yr_* mills2 if year>=1980, fe
estimates store m1b

mi estimate, post saving(bysel.ster, replace): probit F.bonded  lnten democracy2  growth gdp_pc lngdp  regiondata_by   byrs b2 b3 if year>=1980
   mi predict p3 using "bysel.ster", xb
estimates store m2a
mi passive: gen mills1 = exp(-.5*p3^2)/(sqrt(2*_pi)*normprob(p3))

mi estimate, post: xtreg F1.ratio2  lnten democracy2 growth gdp_pc lngdp ratio2  yr_* mills1 if year>=1980, fe
estimates store m2b


estout m1a  m1b m2a m2b , cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) ///
	eqlab("/lnsig2u" "ln($\sigma^2_u$)", none) ///
	starlevels( * 0.05  ) ///
stats(  N N_g, fmt( %9.0f) labels( "N" "Countries"))  style(tex) ///
legend label collabels(none)  ///
 varlabels(_cons Constant) order(lnten lnten democracy2 growth gdp_pc lngdp avg_sp iirating ratio2) drop( yr_*) ///
mlabels ("Model 1"  ) ///
title("")




******************************************************************************************
***D8. Temporal Analysis
******************************************************************************************
******************************************************************************************


*Leads of Tenure (Placebo Tests)

use "leadexp_082317.dta", clear
set more off

xtset ccode year 

xtreg F1.avg_sp F2.lnten democracy2   growth gdp_pc lngdp avg_sp   yr_*,fe
estimates store ec2

xtset ccode year 
xtreg F1.iirating F2.lnten democracy2  growth gdp_pc lngdp iirating  yr_*,fe
estimates store ec3

xtreg F1.ratio2 F2.lnten democracy2   growth gdp_pc lngdp ratio2  yr_* if year>=1980,fe
estimates store ec1

xtreg F1.avg_sp F3.lnten democracy2   growth gdp_pc lngdp avg_sp   yr_*,fe
estimates store ec21

xtset ccode year 
xtreg F1.iirating F3.lnten democracy2  growth gdp_pc lngdp iirating  yr_*,fe
estimates store ec31

xtreg F1.ratio2 F3.lnten democracy2   growth gdp_pc lngdp ratio2  yr_* if year>=1980,fe
estimates store ec11

xtreg F1.avg_sp F4.lnten democracy2   growth gdp_pc lngdp avg_sp   yr_*,fe
estimates store ec22

xtset ccode year 
xtreg F1.iirating F4.lnten democracy2  growth gdp_pc lngdp iirating  yr_*,fe
estimates store ec32

xtreg F1.ratio2 F4.lnten democracy2   growth gdp_pc lngdp ratio2  yr_* if year>=1980,fe
estimates store ec12


estout ec2 ec3 ec1 ec21 ec31 ec11 ec22 ec32 ec12, cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) ///
	eqlab("/lnsig2u" "ln($\sigma^2_u$)", none) ///
	starlevels( * 0.05  ) ///
stats( r2 aic N N_g, fmt(%9.2f %9.0f) labels("R-Squared" "AIC" "N" "Countries"))  style(tex) ///
legend label collabels(none)   varlabels(_cons Constant) order(F2.lnten F3.lnten F4.lnten) drop( yr_*) ///
mlabels ("Model 1"  ) ///
title("")


**Granger Analysis

use "leadexp_082317.dta", clear
set more off
xtset ccode year 

**Using F-test to jointly guage joint signficance of lag structures

*S&P granger causes tenure?
xtreg lnten  l(1).lnten l(1).avg_sp, fe
testparm l(1).avg_sp
xtreg lnten  l(1/2).lnten l(1/2).avg_sp, fe
testparm l(1/2).avg_sp
xtreg lnten  l(1/3).lnten l(1/3).avg_sp, fe
testparm l(1/3).avg_sp
xtreg lnten  l(1/4).lnten l(1/4).avg_sp, fe
testparm l(1/4).avg_sp
xtreg lnten  l(1/5).lnten l(1/5).avg_sp, fe
testparm l(1/5).avg_sp


*tenure granger causes S&P ?
xtreg avg_sp  l(1).avg_sp  l(1).lnten, fe
testparm l(1).lnten
xtreg avg_sp  l(1/2).avg_sp  l(1/2).lnten, fe
testparm l(1/2).lnten
xtreg avg_sp  l(1/3).avg_sp  l(1/3).lnten, fe
testparm l(1/3).lnten
xtreg avg_sp  l(1/4).avg_sp  l(1/4).lnten, fe
testparm l(1/4).lnten
xtreg avg_sp  l(1/5).avg_sp  l(1/5).lnten, fe
testparm l(1/5).lnten



*II ratings granger causes tenure?
xtreg lnten  l(1).lnten l(1).iirating, fe
testparm l(1).iirating
xtreg lnten  l(1/2).lnten l(1/2).iirating, fe
testparm l(1/2).iirating
xtreg lnten  l(1/3).lnten l(1/3).iirating, fe
testparm l(1/3).iirating
xtreg lnten  l(1/4).lnten l(1/4).iirating, fe
testparm l(1/4).iirating
xtreg lnten  l(1/5).lnten l(1/5).iirating, fe
testparm l(1/5).iirating


*tenure granger causes II ratings ?
xtreg iirating  l(1).iirating  l(1).lnten, fe
testparm l(1).lnten
xtreg iirating  l(1/2).iirating  l(1/2).lnten, fe
testparm l(1/2).lnten
xtreg iirating  l(1/3).iirating  l(1/3).lnten, fe
testparm l(1/3).lnten
xtreg iirating  l(1/4).iirating  l(1/4).lnten, fe
testparm l(1/4).lnten
xtreg iirating  l(1/5).iirating  l(1/5).lnten, fe
testparm l(1/5).lnten


*bond yields granger causes tenure?
xtreg lnten  l(1).lnten l(1).ratio2, fe
testparm l(1).ratio2
xtreg lnten  l(1/2).lnten l(1/2).ratio2, fe
testparm l(1/2).ratio2
xtreg lnten  l(1/3).lnten l(1/3).ratio2, fe
testparm l(1/3).ratio2
xtreg lnten  l(1/4).lnten l(1/4).ratio2, fe
testparm l(1/4).ratio2
xtreg lnten  l(1/5).lnten l(1/5).ratio2, fe
testparm l(1/5).ratio2


*tenure granger causes bond yields ?
xtreg ratio2  l(1).ratio2  l(1).lnten, fe
testparm l(1).lnten
xtreg ratio2  l(1/2).ratio2  l(1/2).lnten, fe
testparm l(1/2).lnten
xtreg ratio2  l(1/3).ratio2  l(1/3).lnten, fe
testparm l(1/3).lnten
xtreg ratio2  l(1/4).ratio2  l(1/4).lnten, fe
testparm l(1/4).lnten
xtreg ratio2  l(1/5).ratio2  l(1/5).lnten, fe
testparm l(1/5).lnten


********************************************************************************************
****D9. Substantive effects of Table 1 in the article (standardizing coefficients)

use "leadexp_082317.dta", clear
set more off

xtset ccode year 

**Gelman's divide by 2 SD's standardization method

sum lnten if year>=1980
gen sd_lnten = lnten/(2*r(sd))
sum growth if year>=1980
gen sd_growth = growth/(2*r(sd))
sum gdp_pc if year>=1980
gen sd_gdp_pc = gdp_pc/(2*r(sd))
sum lngdp if year>=1980
gen sd_lngdp = lngdp/(2*r(sd))


xtset ccode year 
xtreg F1.avg_sp sd_lnten democracy2 sd_growth sd_gdp_pc sd_lngdp avg_sp yr_*,fe
estimates store ec2
xtreg F1.iirating sd_lnten democracy2 sd_growth sd_gdp_pc sd_lngdp iirating yr_*,fe
estimates store ec3
xtreg F1.ratio2 sd_lnten democracy2 sd_growth sd_gdp_pc sd_lngdp ratio2 yr_* if year>=1980,fe
estimates store ec1



lab var sd_lnten "Leader Tenure"
lab var sd_growth "Growth"
lab var sd_gdp_pc "GDP per cap"
lab var sd_lngdp "GDP"


estout ec2 ec3 ec1, cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) ///
	eqlab("/lnsig2u" "ln($\sigma^2_u$)", none) ///
	starlevels( * 0.05  ) ///
stats( r2 aic N N_g, fmt(%9.2f %9.0f) labels("R-Squared" "AIC" "N" "Countries"))  style(tex) ///
legend label collabels(none)  varlabels(_cons Constant) order(sd_lnten) drop( yr_*) ///
mlabels ("Model 1"  ) ///
title("")


**Additional substantive interpretation of coefficients
use "leadexp_082317.dta", clear
set more off

capture drop b2 b3


xtset ccode year 


gen gdp2 = exp(lngdp)

xtreg F1.avg_sp lnten polity2 growth gdp_pc lngdp  avg_sp ,fe

xtsum tenure if e(sample)
scalar diff1 = r(mean) * r(sd_w)
scalar diff2 = r(mean) * r(sd_b)

nlcom _b[lnten]*ln(diff1)
nlcom _b[lnten]*ln(diff2)

xtsum polity2 if e(sample)
scalar diff1 = r(mean) + r(sd_w)
scalar diff2 = r(mean) + r(sd_b)

nlcom _b[polity2]*diff1
nlcom _b[polity2]*diff2


xtsum growth if e(sample)
scalar diff1 = r(mean) + r(sd_w)
scalar diff2= r(mean) + r(sd_b)

nlcom _b[growth]*diff1
nlcom _b[growth]*diff2

xtsum gdp_pc if e(sample)
scalar diff1 = r(mean) + r(sd_w)
scalar diff2 = r(mean) + r(sd_b)

nlcom _b[ gdp_pc]*diff1
nlcom _b[ gdp_pc]*diff2

xtsum gdp2 if e(sample) 
scalar diff1 = r(mean) * r(sd_w)
scalar diff2 = r(mean) * r(sd_b)

nlcom _b[lngdp ]*ln(diff1)
nlcom _b[lngdp] *ln(diff2)


xtreg F1.iirating lnten polity2 growth gdp_pc lngdp  iirating yr_*,fe
xtsum tenure if e(sample)
scalar diff1 = r(mean) * r(sd_w)
scalar diff2 = r(mean) * r(sd_b)

nlcom _b[lnten]*ln(diff1)
nlcom _b[lnten]*ln(diff2)

xtsum polity2 if e(sample)
scalar diff1 = r(mean) + r(sd_w)
scalar diff2 = r(mean) + r(sd_b)

nlcom _b[polity2]*diff1
nlcom _b[polity2]*diff2


xtsum growth if e(sample)
scalar diff1 = r(mean) + r(sd_w)
scalar diff2= r(mean) + r(sd_b)

nlcom _b[growth]*diff1
nlcom _b[growth]*diff2

xtsum gdp_pc if e(sample)
scalar diff1 = r(mean) + r(sd_w)
scalar diff2 = r(mean) + r(sd_b)

nlcom _b[ gdp_pc]*diff1
nlcom _b[ gdp_pc]*diff2

xtsum gdp2 if e(sample) 
scalar diff1 = r(mean) * r(sd_w)
scalar diff2 = r(mean) * r(sd_b)

nlcom _b[lngdp ]*ln(diff1)
nlcom _b[lngdp] *ln(diff2)

****
xtreg F1.ratio2 lnten polity2 growth gdp_pc lngdp  ratio2 yr_* if year>=1980,fe
xtsum tenure if e(sample)
scalar diff1 = r(mean) * r(sd_w)
scalar diff2 = r(mean) * r(sd_b)

nlcom _b[lnten]*ln(diff1)
nlcom _b[lnten]*ln(diff2)

xtsum polity2 if e(sample)
scalar diff1 = r(mean) + r(sd_w)
scalar diff2 = r(mean) + r(sd_b)

nlcom _b[polity2]*diff1
nlcom _b[polity2]*diff2


xtsum growth if e(sample)
scalar diff1 = r(mean) + r(sd_w)
scalar diff2= r(mean) + r(sd_b)

nlcom _b[growth]*diff1
nlcom _b[growth]*diff2

xtsum gdp_pc if e(sample)
scalar diff1 = r(mean) + r(sd_w)
scalar diff2 = r(mean) + r(sd_b)

nlcom _b[ gdp_pc]*diff1
nlcom _b[ gdp_pc]*diff2

xtsum gdp2 if e(sample) 
scalar diff1 = r(mean) * r(sd_w)
scalar diff2 = r(mean) * r(sd_b)

nlcom _b[lngdp ]*ln(diff1)
nlcom _b[lngdp] *ln(diff2)



*********************************************************
**D.10 Government Quality

use "leadexp_082317.dta", clear
set more off

xtset ccode year 




xtreg F1.avg_sp lnten democracy2    icrg_qog growth gdp_pc lngdp  avg_sp yr_*,fe
estimates store m1



xtreg F1.iirating lnten democracy2   icrg_qog growth gdp_pc lngdp  iirating yr_*,fe
estimates store m2

xtreg F1.ratio2 lnten democracy2   icrg_qog growth gdp_pc lngdp  ratio2 yr_* if year>=1980,fe
estimates store m3



xtreg F1.avg_sp lnten democracy2   kun_ecoabs growth gdp_pc lngdp  avg_sp yr_*,fe
estimates store m11

xtreg F1.iirating lnten democracy2   kun_ecoabs growth gdp_pc lngdp  iirating yr_*,fe
estimates store m21

xtreg F1.ratio2 lnten democracy2   kun_ecoabs growth gdp_pc lngdp  ratio2 yr_* if year>=1980,fe
estimates store m31


xtreg F1.avg_sp lnten democracy2  lvaw_garriga growth gdp_pc lngdp  avg_sp yr_*,fe
estimates store m12

xtreg F1.iirating lnten democracy2   lvaw_garriga growth gdp_pc lngdp  iirating yr_*,fe
estimates store m22

xtreg F1.ratio2 lnten democracy2  lvaw_garriga growth gdp_pc lngdp  ratio2 yr_* if year>=1980,fe
estimates store m32

xtreg F1.avg_sp lnten democracy2 icrg_qog kun_ecoabs  lvaw_garriga growth gdp_pc lngdp  avg_sp yr_*,fe
estimates store m13

xtreg F1.iirating lnten democracy2  icrg_qog kun_ecoabs  lvaw_garriga growth gdp_pc lngdp  iirating yr_*,fe
estimates store m23

xtreg F1.ratio2 lnten democracy2 icrg_qog kun_ecoabs  lvaw_garriga growth gdp_pc lngdp  ratio2 yr_* if year>=1980,fe
estimates store m33

lab var icrg_qog "Bureau. Quality"
lab var kun_ecoabs "Econ. Instit. Quality"


estout m1 m2 m3  m11 m21 m31  m12 m22 m32  , cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) ///
	eqlab("/lnsig2u" "ln($\sigma^2_u$)", none) ///
	starlevels( * 0.1 ** 0.05 *** 0.01 ) ///
stats( r2 aic N N_g, fmt(%9.2f %9.0f) labels("R-Squared" "AIC" "N" "Countries"))  style(tex) ///
legend label collabels(none)  varlabels(_cons Constant) keep( lnten  icrg_qog kun_ecoabs lvaw_garriga) ///
mlabels ("Model 1"  ) ///
title("")

 
 
 estout  m13 m23 m33 , cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) ///
	eqlab("/lnsig2u" "ln($\sigma^2_u$)", none) ///
	starlevels( * 0.1 ** 0.05 *** 0.01 ) ///
stats( r2 aic N N_g, fmt(%9.2f %9.0f) labels("R-Squared" "AIC" "N" "Countries"))  style(tex) ///
legend label collabels(none)   varlabels(_cons Constant) order( lnten  icrg_qog kun_ecoabs lvaw_garriga) ///
mlabels ("Model 1"  ) drop(yr_*) ///
title("")




*********************************************************
**D11. Alternative treatments of se's

use "leadexp_082317.dta", clear
set more off


xtreg avg_sp l.avg_sp , i(ccode) sa 
xtreg iirating l.iirating  , i(ccode) sa 
xtreg ratio2 l.ratio2  , i(ccode) sa 
**Rho is each model indicate ICC



xtset ccode year 
xtreg F1.avg_sp lnten democracy2   growth gdp_pc lngdp  avg_sp ,fe
gen spsample = e(sample)

by ccode: egen spsample2 = total(spsample)


xtreg F1.iirating lnten democracy2  growth gdp_pc lngdp  iirating ,fe
gen iisample = e(sample)

by ccode: egen iisample2 = total(iisample)

xtreg F1.ratio2 lnten democracy2   growth gdp_pc lngdp  ratio2  if year>=1980,fe
gen bysample = e(sample)

by ccode: egen bysample2 = total(bysample)



xtset ccode year 
  *xtpcse F1.avg_sp lnten democracy2   growth gdp_pc lngdp avg_sp yr_* if year>=1980 
 * xtpcse F1.avg_sp lnten democracy2   growth gdp_pc lngdp avg_sp yr_* if year>=1980 & spsample2>=5
  xtpcse F1.avg_sp lnten democracy2   growth gdp_pc lngdp avg_sp yr_* if year>=1980 & spsample2>=10
estimates store ec2

  *xtpcse F1.iirating lnten democracy2  growth gdp_pc lngdp iirating yr_* if year>=1980 & iisample2>=10
  xtpcse F1.iirating lnten democracy2  growth gdp_pc lngdp iirating yr_* if year>=1980 & iisample2>=15
estimates store ec3

  *xtpcse F1.ratio2 lnten democracy2   growth gdp_pc lngdp ratio2 yr_* if year>=1980 & bysample2>=10
  *xtpcse F1.ratio2 lnten democracy2   growth gdp_pc lngdp ratio2 yr_* if year>=1980 & bysample2>=15
  xtpcse F1.ratio2 lnten democracy2   growth gdp_pc lngdp ratio2 yr_* if year>=1980 & bysample2>=20
estimates store ec1


estout ec2 ec3 ec1 , cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) ///
	eqlab("/lnsig2u" "ln($\sigma^2_u$)", none) ///
	starlevels( * 0.05  ) ///
stats( r2 aic N N_g, fmt(%9.2f %9.0f) labels("R-Squared" "AIC" "N" "Countries"))  style(tex) ///
legend label collabels(none)   varlabels(_cons Constant) order() drop(yr_* ) ///
mlabels ("Model 1"  ) ///
title("")

**Fsp = F.sp, Fii = F.iirating, Fby = F.ratio2

bootstrap,  strata(ccode) reps(50) seed(946216) ///
 :xtreg Fsp lnten democracy2   growth gdp_pc lngdp  avg_sp yr_* if year>=1980 , fe 
 estimates store ec2
 bootstrap,  strata(ccode) reps(50) seed(946216) ///
 :xtreg Fii lnten democracy2   growth gdp_pc lngdp  iirating yr_* if year>=1980 , fe 
estimates store ec3
bootstrap,  strata(ccode) reps(50) seed(946216) ///
 :xtreg Fby  lnten democracy2   growth gdp_pc lngdp  ratio2 yr_* if year>=1980 , fe 
estimates store ec1


estout ec2 ec3 ec1 , cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) ///
	eqlab("/lnsig2u" "ln($\sigma^2_u$)", none) ///
	starlevels( * 0.05  ) ///
stats( r2 aic N N_g, fmt(%9.2f %9.0f) labels("R-Squared" "AIC" "N" "Countries"))  style(tex) ///
legend label collabels(none)   varlabels(_cons Constant) order() drop( yr_*) ///
mlabels ("Model 1"  ) ///
title("")


****************************************************************************************
***Section E Democracy and Tenure
************************************


**E1***********ALT Measures 
use "leadexp_082317.dta", clear
set more off

xtset ccode year 


xtreg F1.ratio2 lnten  polity2 growth gdp_pc lngdp  ratio2 yr_* if year>=1980,fe
estimates store m3 
xtreg F1.avg_sp lnten  polity2  growth gdp_pc lngdp  avg_sp yr_* ,fe
estimates store m1
xtreg F1.iirating lnten  polity2 growth gdp_pc lngdp  iirating yr_*,fe
estimates store m2 

xtreg F1.ratio2 lnten  v2x_polyarchy growth gdp_pc lngdp  ratio2 yr_* if year>=1980,fe
estimates store m31 
xtreg F1.avg_sp lnten  v2x_polyarchy  growth gdp_pc lngdp  avg_sp yr_*,fe
estimates store m11
xtreg F1.iirating lnten  v2x_polyarchy growth gdp_pc lngdp  iirating yr_*,fe
estimates store m21

xtreg F1.ratio2 lnten  v2x_libdem growth gdp_pc lngdp ratio2 yr_* if year>=1980,fe
estimates store m32 
xtreg F1.avg_sp lnten  v2x_libdem  growth gdp_pc lngdp  avg_sp yr_*,fe
estimates store m12
xtreg F1.iirating lnten  v2x_libdem growth gdp_pc lngdp  iirating yr_*,fe
estimates store m22



xtreg F1.ratio2 lnten  lji growth gdp_pc lngdp  ratio2 yr_* if year>=1980,fe
estimates store m33 
xtreg F1.avg_sp lnten  lji growth gdp_pc lngdp  avg_sp yr_*,fe
estimates store m13
xtreg F1.iirating lnten  lji growth gdp_pc lngdp  iirating yr_*,fe
estimates store m23


estout m1 m2 m3 m11 m21 m31 m12 m22 m32 m13 m23 m33, cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) ///
	eqlab("/lnsig2u" "ln($\sigma^2_u$)", none) ///
	starlevels( * 0.05 ) ///
stats( r2 aic N N_g, fmt(%9.2f %9.0f) labels("R-Squared" "AIC" "N" "Countries"))  style(tex) ///
legend label collabels(none)   varlabels(_cons Constant) order(lnten polity2 v2x_polyarchy v2x_libdem lji) drop(  yr_*) 

**E2***Interactions 
use "leadexp_082317.dta", clear
set more off

xtset ccode year 

xtreg F1.ratio2 lnten dem_ten  democracy2 growth gdp_pc lngdp  ratio2 yr_* if year>=1980,fe
estimates store m3 
xtreg F1.avg_sp lnten dem_ten democracy2   growth gdp_pc lngdp  avg_sp yr_*,fe
estimates store m1
xtreg F1.iirating lnten dem_ten  democracy2  growth gdp_pc lngdp  iirating yr_*,fe
estimates store m2 



xtreg F1.ratio2 lnten dem_ten2  polity2 growth gdp_pc lngdp ratio2 yr_* if year>=1980,fe
estimates store m31 
xtreg F1.avg_sp lnten dem_ten2 polity2  growth gdp_pc lngdp  avg_sp yr_*,fe
estimates store m11
xtreg F1.iirating lnten dem_ten2  polity2 growth gdp_pc lngdp  iirating yr_*,fe
estimates store m21 

estout m1 m2 m3 m11 m21 m31, cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) ///
	eqlab("/lnsig2u" "ln($\sigma^2_u$)", none) ///
	starlevels( * 0.1 ) ///
stats( r2 aic N N_g, fmt(%9.2f %9.0f) labels("R-Squared" "AIC" "N" "Countries"))  style(tex) ///
legend label collabels(none)  ///
 varlabels(_cons Constant) order(lnten democracy2 dem_ten polity2 dem_ten2 ) drop(  yr_*) 

/* Other interactions that also produce mixed results

use "leadexp_082317.dta", clear
set more off

xtset ccode year 
capture drop dem_ten 
gen dem_ten = v2x_polyarchy*lnten

xtreg F1.avg_sp lnten dem_ten v2x_polyarchy    growth gdp_pc lngdp  avg_sp yr_*,fe
xtreg F1.iirating lnten dem_ten  v2x_polyarchy   growth gdp_pc lngdp  iirating yr_*,fe
xtreg F1.ratio2 lnten dem_ten  v2x_polyarchy growth gdp_pc lngdp   ratio2 yr_* if year>=1980,fe

capture drop dem_ten2 
gen dem_ten2 = v2x_libdem*lnten

xtreg F1.avg_sp lnten dem_ten2 v2x_libdem  growth gdp_pc lngdp  avg_sp yr_*,fe
xtreg F1.iirating lnten dem_ten2  v2x_libdem growth gdp_pc lngdp  iirating yr_*,fe
xtreg F1.ratio2 lnten dem_ten2  v2x_libdem growth gdp_pc lngdp   ratio2 yr_* if year>=1980,fe


capture drop dem_ten2 
gen dem_ten2 = lji*lnten

xtreg F1.avg_sp lnten dem_ten2 lji  growth gdp_pc lngdp  avg_sp yr_*,fe
xtreg F1.iirating lnten dem_ten2  lji growth gdp_pc lngdp  iirating yr_*,fe
xtreg F1.ratio2 lnten dem_ten2  lji growth gdp_pc lngdp   ratio2 yr_* if year>=1980,fe

*/


*E3*Elections and other confounder Within democracies
use "leadexp_082317.dta", clear
set more off

xtset ccode year 

xtreg F1.ratio2 lnten  elec2 growth gdp_pc lngdp  ratio2 yr_* if democracy2==1 &  year>=1980,fe
estimates store m3 
xtreg F1.avg_sp lnten   elec2  growth gdp_pc lngdp  avg_sp yr_* if democracy2==1 ,fe
estimates store m1
xtreg F1.iirating lnten  elec2 growth gdp_pc lngdp  iirating yr_* if democracy2==1,fe
estimates store m2 

xtreg F1.ratio2 lnten numvote growth gdp_pc lngdp  ratio2 yr_* if democracy2==1 &  year>=1980,fe
estimates store m31 
xtreg F1.avg_sp lnten  numvote  growth gdp_pc lngdp  avg_sp yr_* if democracy2==1 ,fe
estimates store m11
xtreg F1.iirating lnten numvote growth gdp_pc lngdp  iirating yr_* if democracy2==1,fe
estimates store m21

xtreg F1.ratio2 lnten oppvote  growth gdp_pc lngdp  ratio2 yr_* if democracy2==1 &  year>=1980,fe
estimates store m32 
xtreg F1.avg_sp lnten  oppvote   growth gdp_pc lngdp  avg_sp yr_* if democracy2==1 ,fe
estimates store m12
xtreg F1.iirating lnten oppvote  growth gdp_pc lngdp  iirating yr_* if democracy2==1,fe
estimates store m22

estout m1 m2 m3 m11 m21 m31 m12 m22 m32 , cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) ///
	eqlab("/lnsig2u" "ln($\sigma^2_u$)", none) ///
	starlevels( * 0.05 ) ///
stats( r2 N N_g, fmt(%9.2f %9.0f) labels("R-Squared" "N" "Countries"))  style(tex) ///
legend label collabels(none)   ///
varlabels(_cons Constant) order(lnten elec2 numvote oppvote ) drop( _cons growth gdp_pc lngdp avg_sp ratio2  iirating  yr_*) 

use "leadexp_082317.dta", clear
set more off

xtset ccode year

xtreg F1.ratio2 lnten allhouse growth gdp_pc lngdp  ratio2 yr_* if democracy2==1 &  year>=1980,fe
estimates store m3 
xtreg F1.avg_sp lnten  allhouse  growth gdp_pc lngdp  avg_sp yr_* if democracy2==1 ,fe
estimates store m1
xtreg F1.iirating lnten allhouse growth gdp_pc lngdp  iirating yr_* if democracy2==1,fe
estimates store m2

xtreg F1.ratio2 lnten parl growth gdp_pc lngdp  ratio2 yr_* if democracy2==1 &  year>=1980,fe
estimates store m31 
xtreg F1.avg_sp lnten parl  growth gdp_pc lngdp  avg_sp yr_* if democracy2==1 ,fe
estimates store m11
xtreg F1.iirating lnten parl  growth gdp_pc lngdp  iirating yr_* if democracy2==1,fe
estimates store m21


xtreg F1.ratio2 lnten pr growth gdp_pc lngdp  ratio2 yr_* if democracy2==1 &  year>=1980,fe
estimates store m32 
xtreg F1.avg_sp lnten pr  growth gdp_pc lngdp  avg_sp yr_* if democracy2==1 ,fe
estimates store m12
xtreg F1.iirating lnten pr  growth gdp_pc lngdp  iirating yr_* if democracy2==1,fe
estimates store m22


estout m1 m2 m3 m11 m21 m31 m12 m22 m32 , cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) ///
	eqlab("/lnsig2u" "ln($\sigma^2_u$)", none) ///
	starlevels( * 0.05 ) ///
stats( r2  N N_g, fmt(%9.2f %9.0f) labels("R-Squared" "N" "Countries"))  style(tex) ///
legend label collabels(none)   ///
varlabels(_cons Constant) order(lnten allhouse  parl pr  )  drop( _cons growth gdp_pc lngdp avg_sp ratio2  iirating  yr_*)  

use "leadexp_082317.dta", clear
set more off

xtset ccode year

xtreg F1.ratio2 lnten left growth gdp_pc lngdp  ratio2 yr_* if democracy2==1 &  year>=1980,fe
estimates store m3 
xtreg F1.avg_sp lnten left  growth gdp_pc lngdp  avg_sp yr_* if democracy2==1 ,fe
estimates store m1
xtreg F1.iirating lnten left  growth gdp_pc lngdp  iirating yr_* if democracy2==1,fe
estimates store m2

xtreg F1.ratio2 lnten frac growth gdp_pc lngdp  ratio2 yr_* if democracy2==1 &  year>=1980,fe
estimates store m31 
xtreg F1.avg_sp lnten frac  growth gdp_pc lngdp  avg_sp yr_* if democracy2==1 ,fe
estimates store m11
xtreg F1.iirating lnten frac growth gdp_pc lngdp  iirating yr_* if democracy2==1,fe
estimates store m21

xtreg F1.ratio2 lnten checks growth gdp_pc lngdp  ratio2 yr_* if democracy2==1 &  year>=1980,fe
estimates store m32 
xtreg F1.avg_sp lnten checks  growth gdp_pc lngdp  avg_sp yr_* if democracy2==1 ,fe
estimates store m12
xtreg F1.iirating lnten checks growth gdp_pc lngdp  iirating yr_* if democracy2==1,fe
estimates store m22

estout m1 m2 m3 m11 m21 m31 m12 m22 m32 , cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) ///
	eqlab("/lnsig2u" "ln($\sigma^2_u$)", none) ///
	starlevels( * 0.05 ) ///
stats( r2 N N_g, fmt(%9.2f %9.0f) labels("R-Squared"  "N" "Countries"))  style(tex) ///
legend label collabels(none) ///
 varlabels(_cons Constant) order(lnten left frac checks ) drop( _cons growth gdp_pc lngdp avg_sp ratio2  iirating  yr_*) 

use "leadexp_082317.dta", clear
set more off

xtset ccode year


 xtreg F1.ratio2 lnten elec2 numvote oppvote allhouse parl pr left frac  checks growth gdp_pc lngdp  ratio2 yr_* if democracy2==1 &  year>=1980,fe
estimates store m32 
xtreg F1.avg_sp lnten elec2 numvote oppvote allhouse parl pr left frac  checks  growth gdp_pc lngdp  avg_sp yr_* if democracy2==1 ,fe
estimates store m12
xtreg F1.iirating lnten elec2 numvote oppvote allhouse parl pr left frac  checks growth gdp_pc lngdp  iirating yr_* if democracy2==1,fe
estimates store m22
 
 
 estout  m12 m22 m32 , cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) ///
	eqlab("/lnsig2u" "ln($\sigma^2_u$)", none) ///
	starlevels( * 0.1 ** 0.05 *** 0.01) ///
stats( r2 N N_g, fmt(%9.2f %9.0f) labels("R-Squared"  "N" "Countries"))  style(tex) ///
legend label collabels(none)  ///
 varlabels(_cons Constant) order(lnten elec2 numvote oppvote allhouse parl pr left frac  checks growth gdp_pc lngdp) drop(   yr_*) 

 
 
*********************************************************************************************8
***F.***Assassination Analysis 


use "leadexp_082317.dta", clear
set more off
xtset ccode year


*Creating lags and lead before merging assassination data
gen lratio2 = l.ratio2
gen dratio2 = d.ratio2
gen fratio2 = f.ratio2
gen llnten = l.lnten 


merge 1:m ccode year using "assassin_all_100116.dta"
drop if _m==2
drop _m


tab success
tab success if ratio2!=.

***Table F26 Balance Statistics

ksmirnov llnten , by(success)
ksmirnov polity2, by(success)
ksmirnov lngdp, by(success)
ksmirnov pdgdp, by(success)
ksmirnov lngdppc, by(success)
ksmirnov lratio2, by(success)
ksmirnov lndebt, by(success)
ksmirnov lyield2, by(success)

ranksum llnten , by(success)
ranksum polity2, by(success)
ranksum lngdp, by(success)
ranksum pdgdp, by(success)
ranksum lngdppc, by(success)
ranksum lratio2, by(success)
ranksum lndebt, by(success)
ranksum lyield2, by(success)

ttest llnten , by(success)
ttest  polity2, by(success)
ttest lngdp, by(success)
ttest  pdgdp, by(success)
ttest  lngdppc, by(success)
ttest  lratio2, by(success)
ttest  lndebt, by(success)
ttest lyield2, by(success)


replace attempt = 0 if attempt==. & year>=1875
sort ccode year
by ccode: egen tot_ass = total(attempt)

gen anyattempt = 0 if tot_ass==0 & year>=1875
replace anyattempt = 1 if attempt==1 & year>=1875



ksmirnov llnten , by(anyattempt)
ksmirnov polity2, by(anyattempt)
ksmirnov lngdp, by(anyattempt)
ksmirnov pdgdp, by(anyattempt)
ksmirnov lngdppc, by(anyattempt)
ksmirnov lndebt, by(anyattempt)
ksmirnov lratio2, by(anyattempt)
ksmirnov lyield2, by(anyattempt)

ranksum llnten , by(anyattempt)
ranksum democracy2, by(anyattempt)
ranksum lngdp, by(anyattempt)
ranksum pdgdp, by(anyattempt)
ranksum lngdppc, by(anyattempt)
ranksum lndebt, by(anyattempt)
ranksum lratio2, by(anyattempt)
ranksum lyield2, by(anyattempt)

ttest llnten , by(anyattempt)
ttest  polity2 , by(anyattempt)
ttest lngdp , by(anyattempt)
ttest  pdgdp , by(anyattempt)
ttest  lngdppc , by(anyattempt)
ttest  lndebt , by(anyattempt)
ttest  lratio2 , by(anyattempt)
ttest  lyield2, by(anyattempt)


***Figure F2



set more off
levels year, loca(yr)

gen prop_suc = . 
gen prop_att = . 

foreach y in `yr' {
sum success if success==1  & year==`y'
local n1 = r(N)
replace prop_suc = `n1' if year==`y' 

sum attempt if attempt==1 & year==`y'
local n1 = r(N)
replace prop_att  = `n1' if year==`y'
}

# delimit ;
graph twoway bar prop_att year if year>=1875 & year<=2013, blcolor(gs10) bfcolor(gs10)
	  ||	 bar prop_suc year if year>=1875 & year<=2013, blcolor(navy) bfcolor(navy)	
	  ||  , 
xlabel(1875(25)2005) 
legend(on cols(3))
ytitle("Number of Cases", size(3.5))
xtitle("Year", size(3.5));

#delimit cr

gr_edit legend.plotregion1.label[1].text = {}
gr_edit legend.plotregion1.label[1].text.Arrpush Attempts
// label[2] edits

gr_edit legend.plotregion1.label[2].text = {}
gr_edit legend.plotregion1.label[2].text.Arrpush Success
// label[3] edits

// label[1] edits

gr_edit style.editstyle boxstyle(shadestyle(color(white))) editcopy
gr_edit style.editstyle boxstyle(linestyle(color(white))) editcopy
// Graph color






************
**Figure F3


lab var success "Assassination Success"

label define success 1 "Success" 0 "Failure"



gen boxplot = 1 if success ==1
replace boxplot=2 if success==0
replace boxplot=3 if tot_ass==0

label define boxplot 1 "Success" 2 "Failure" 3 "No Assassinations" 



graph box lyield2 , over(boxplot) noout label

gr_edit scaleaxis.title.text = {}
gr_edit scaleaxis.title.text.Arrpush Nominal Bond Yield

gr_edit style.editstyle boxstyle(shadestyle(color(white))) editcopy 
gr_edit style.editstyle boxstyle(linestyle(color(white))) editcopy
gr_edit note.draw_view.setstyle, style(no)
gr_edit note.fill_if_undrawn.setstyle, style(no)
// note edits

gr_edit grpaxis.major.num_rule_ticks = 0
gr_edit grpaxis.edit_tick 1 12.963 `"Success"', tickset(major)
// grpaxis edits

gr_edit grpaxis.major.num_rule_ticks = 0
gr_edit grpaxis.edit_tick 2 50 `"Failure"', tickset(major)
// grpaxis edits

gr_edit grpaxis.major.num_rule_ticks = 0
gr_edit grpaxis.edit_tick 3 87.037 `"No Attempts"', tickset(major)





graph box lratio2 , over(boxplot) noout label

gr_edit scaleaxis.title.text = {}
gr_edit scaleaxis.title.text.Arrpush Bond Yield Ratio

gr_edit style.editstyle boxstyle(shadestyle(color(white))) editcopy 
gr_edit style.editstyle boxstyle(linestyle(color(white))) editcopy
gr_edit note.draw_view.setstyle, style(no)
gr_edit note.fill_if_undrawn.setstyle, style(no)
// note edits

gr_edit grpaxis.major.num_rule_ticks = 0
gr_edit grpaxis.edit_tick 1 12.963 `"Success"', tickset(major)
// grpaxis edits

gr_edit grpaxis.major.num_rule_ticks = 0
gr_edit grpaxis.edit_tick 2 50 `"Failure"', tickset(major)
// grpaxis edits

gr_edit grpaxis.major.num_rule_ticks = 0
gr_edit grpaxis.edit_tick 3 87.037 `"No Attempts"', tickset(major)



******************************************
**Table F27 (code also  in II_leader_main.do)




use "leadexp_082317.dta", clear
set more off
xtset ccode year



merge 1:m ccode year using "assassin_all_100116.dta"
drop if _m==2
drop _m


**Because of multiple leaders in some years, we need to fix tenure measure for 3 leaders in the assassination sample

*Mean centering Tenure for interpretation convenience
sum lnten
gen lnten2 = lnten - r(mean) 


*Prep for Model 2 (selection model)
replace attempt = 0 if attempt==. 


*Creating time splines (see https://www.prio.org/Data/Stata-Tools/ for btscs package). 
btscs attempt year ccode, g(ayrs)
gen a2 = ayrs*ayrs
gen a3 = ayrs*ayrs*ayrs

*First stage (reported in appendix)
probit attempt lnten2 democracy2 lngdp2 pdgdp lngdppc ayrs a2 a3
estimates store sel

lab var lnten2 "Tenure"
lab var a2 "Time since last attempt$^2$"
lab var a3 "Time since last attempt$^3$"


estout sel, cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) ///
	eqlab("/lnsig2u" "ln($\sigma^2_u$)", none) ///
	starlevels( * 0.05  ) ///
stats( ll aic N, fmt(%9.2f %9.0f) labels("Log-Like" "AIC" "N"))  style(tex) ///
legend label collabels(none) varlabels(_cons Constant) order(lnten2 ) drop() ///
mlabels ("Model 1"  ) ///
title("") 




















