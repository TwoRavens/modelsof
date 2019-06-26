************************
**** MAIN ANALYSIS *****
************************

* Table 1 estimates the effect of inequality on civil war onset


**** Table 1: Effect of Inequality on Civil Wars

set more off

** PITF 

logit civpitf lcapshare lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation  lopen lethnic lpolity lpolitysq cold dec60 dec70 dec80 dec90 civpitfyears _spline1civpitf _spline2civpitf _spline3civpitf if year>=1960 & western==0, robust

logit civpitf lshare1 lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation  lopen lethnic lpolity lpolitysq cold dec60 dec70 dec80 dec90 civpitfyears _spline1civpitf _spline2civpitf _spline3civpitf if year>=1960  & western==0, robust

logit civpitf L.gini lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation  lopen lethnic lpolity lpolitysq cold dec60 dec70 dec80 dec90 civpitfyears _spline1civpitf _spline2civpitf _spline3civpitf if year>=1960 & western==0, robust

** PRIO

logit civprio lcapshare lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation  lopen lethnic lpolity lpolitysq cold dec60 dec70 dec80 dec90 peaceyearssmallprio _spline1smallprio _spline2smallprio _spline3smallprio if year>=1960 & western==0, robust

logit civprio lshare1 lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation  lopen lethnic lpolity lpolitysq cold dec60 dec70 dec80 dec90 peaceyearssmallprio _spline1smallprio _spline2smallprio _spline3smallprio if year>=1960 & western==0, robust

logit civprio L.gini lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation  lopen lethnic lpolity lpolitysq cold dec60 dec70 dec80 dec90 peaceyearssmallprio _spline1smallprio _spline2smallprio _spline3smallprio if year>=1960 & western==0, robust

	
**********************************************************************************

* Table 2 estimates the effect of inequality on coups


**** Table 2: Effect of Inequality on Coups

set more off

** Successful coups

logit success_pow lcapshare lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic lpolity lpolitysq cold dec60 dec70 dec80 dec90 succpowyears _spline1sucpow _spline2sucpow _spline3sucpow if year>=1960 & western==0, robust

logit success_pow lshare1 lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic lpolity lpolitysq cold dec60 dec70 dec80 dec90 succpowyears _spline1sucpow _spline2sucpow _spline3sucpow if year>=1960 & western==0, robust

logit success_pow L.gini lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic lpolity lpolitysq cold dec60 dec70 dec80 dec90 succpowyears _spline1sucpow _spline2sucpow _spline3sucpow if year>=1960 & western==0, robust

logit success_pow lcapshare lcapsharesq lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic lpolity lpolitysq cold dec60 dec70 dec80 dec90 succpowyears _spline1sucpow _spline2sucpow _spline3sucpow if year>=1960 & western==0, robust

logit success_pow lshare1 lshare1sq lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic lpolity lpolitysq cold dec60 dec70 dec80 dec90 succpowyears _spline1sucpow _spline2sucpow _spline3sucpow if year>=1960 & western==0, robust

logit success_pow L.gini L.ginisq lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic lpolity lpolitysq cold dec60 dec70 dec80 dec90 succpowyears _spline1sucpow _spline2sucpow _spline3sucpow if year>=1960 & western==0, robust

** All coups (including failed coups)

logit failed_pow lcapshare lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic lpolity lpolitysq cold dec60 dec70 dec80 dec90 succpowyears _spline1sucpow _spline2sucpow _spline3sucpow if year>=1960 & western==0, robust

logit failed_pow lshare1 lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic lpolity lpolitysq cold dec60 dec70 dec80 dec90 succpowyears _spline1sucpow _spline2sucpow _spline3sucpow if year>=1960 & western==0, robust

logit failed_pow L.gini lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic lpolity lpolitysq cold dec60 dec70 dec80 dec90 succpowyears _spline1sucpow _spline2sucpow _spline3sucpow if year>=1960 & western==0, robust

	

**********************************************************************************************

* Table 3 estimates the effect of inequality on coup-proofing


**** Table 3: Effect of Inequality on Coup-Proofing

set more off

reg effective_number lcapshare lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic lpolity lpolitysq  cold  dec70  dec90 succpowyears if ldempol ==0 & western==0, robust

reg effective_number lshare1 lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic lpolity lpolitysq  cold  dec70  dec90 succpowyears if ldempol ==0 & western==0, robust

reg effective_number L.gini lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic lpolity lpolitysq  cold  dec70  dec90 succpowyears if ldempol ==0 & western==0, robust

	

**********************************************************************************************

* Table 4 estimates the effect of coup-proofing on civil wars and coups
 

**** Table 4: Effect of Coup-Proofing on Coups and Civil Wars

set more off

** Civil wars (PITF)

logit civpitf L.effective_number lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic lpolity lpolitysq  cold  dec70  dec90 civpitfyears _spline1civpitf _spline2civpitf _spline3civpitf if year>=1960 & ldempol==0 & western==0, robust

** Civil wars (PRIO)

logit civprio L.effective_number  lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic lpolity lpolitysq  cold  dec70  dec90 peaceyearssmallprio _spline1smallprio _spline2smallprio _spline3smallprio if year>=1960 & ldempol==0 & western==0, robust

** Successful coups

logit success_pow L.effective_number lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic lpolity lpolitysq  cold  dec70  dec90 succpowyears _spline1sucpow _spline2sucpow _spline3sucpow if year>=1960 & ldempol==0 & western==0, robust

** All coups

logit failed_pow L.effective_number lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic lpolity lpolitysq  cold  dec70  dec90 succpowyears _spline1sucpow _spline2sucpow _spline3sucpow if year>=1960 & ldempol==0 & western==0, robust


**********************************************************************************************

**** Figure 1: Predicted Probabilities of Coups and Conflicts

sort cowcode year

set scheme s1mono

set more off

logit success_pow lcapshare lgdptreis lonegrowthtreis llnoil_gas_valuePOP_2009 regch3 lopen lethnic lpolity lpolitysq cold dec60 dec70 dec90 succpowyears _spline1sucpow _spline2sucpow _spline3sucpow if year>=1960 & western==0, robust


gen SameSample1 = e(sample)
tab SameSample1


logit success_pow lcapshare lgdptreis lonegrowthtreis llnoil_gas_valuePOP_2009 regch3 lopen lethnic lpolity lpolitysq cold dec60 dec70 dec90 succpowyears _spline1sucpow _spline2sucpow _spline3sucpow if year>=1960 & western==0, robust

qui sum lgdptreis if e(SameSample1)
local m_lgdptreis = r(mean) 
qui sum lonegrowthtreis if e(SameSample1)
local m_lonegrowthtreis = r(mean)
qui sum llnoil_gas_valuePOP_2009 if e(SameSample1)
local m_llnoil_gas_valuePOP_2009 = r(mean)
qui sum regch3 if e(SameSample1)
local m_regch3 = r(mean)
qui sum lopen if e(SameSample1)
local m_lopen = r(mean)
qui sum lethnic if e(SameSample1)
local m_lethnic = r(mean)
qui sum lpolity if e(SameSample1)
local m_lpolity = r(mean)
qui sum lpolitysq if e(SameSample1)
local m_lpolitysq = r(mean)
qui sum dec60 if e(SameSample1)
local m_dec60 = r(mean)
qui sum dec70 if e(SameSample1)
local m_dec70 = r(mean)
qui sum dec90 if e(SameSample1)
local m_dec90 = r(mean)
qui sum succpowyears if e(SameSample1)
local m_succpowyears = r(mean) 
qui sum _spline1sucpow if e(SameSample1)
local m__spline1sucpow = r(mean)
qui sum _spline2sucpow if e(SameSample1)
local m__spline2sucpow = r(mean)
qui sum _spline3sucpow if e(SameSample1)
local m__spline3sucpow = r(mean)


local xb1 _b[lcapshare]*lcapshare + _b[lgdptreis]*`m_lgdptreis' + _b[lonegrowthtreis]*`m_lonegrowthtreis' + _b[llnoil_gas_valuePOP_2009]*`m_llnoil_gas_valuePOP_2009' +_b[regch3]*`m_regch3' + _b[lopen]*`m_lopen' ///
+ _b[lethnic]*`m_lethnic'+ _b[lpolity]*`m_lpolity' +  _b[lpolitysq]*`m_lpolitysq'+ _b[cold]*1 +  _b[dec60]*1 + _b[dec70]*0 + _b[dec90]*0 + _b[succpowyears]*`m_succpowyears' /// 
	+ _b[_spline1sucpow]*`m__spline1sucpow' + _b[_spline2sucpow]*`m__spline2sucpow' + _b[_spline3sucpow]*`m__spline3sucpow' + _b[_cons]

predictnl prsuccess = exp(`xb1')/(1+exp(`xb1')), se(se1)

gen cihis = prsuccess + 1.96*se1
gen cilos = prsuccess - 1.96*se1

sort lcapshare

graph twoway line  prsuccess cihis cilos lcapshare, ylabel(0(.02) .1)  ytitle(Prob. successful coup) ///
	xtitle(Inequality) title() legend(off) clpattern(solid dash dash) clwidth(thick  medium) name(coup, replace) nodraw 


logit civpitf lcapshare lgdptreis lonegrowthtreis llnoil_gas_valuePOP_2009 regch3 mountains lpopulation  lopen lethnic lpolity lpolitysq cold dec60 dec70 dec90 civpitfyears _spline1civpitf _spline2civpitf _spline3civpitf if year>=1960 & western==0, robust

gen SameSample2 = e(sample)
tab SameSample2

logit civpitf lcapshare lgdptreis lonegrowthtreis llnoil_gas_valuePOP_2009 regch3 mountains lpopulation  lopen lethnic lpolity lpolitysq cold dec60 dec70 dec90 civpitfyears _spline1civpitf _spline2civpitf _spline3civpitf if year>=1960 & western==0, robust


qui sum lgdptreis if e(SameSample2)
local m_lgdptreis = r(mean) 
qui sum lonegrowthtreis if e(SameSample2)
local m_lonegrowthtreis = r(mean)
qui sum llnoil_gas_valuePOP_2009 if e(SameSample2)
local m_llnoil_gas_valuePOP_2009 = r(mean)
qui sum mountains if e(SameSample2)
local m_mountains = r(mean)
qui sum regch3 if e(SameSample2)
local m_regch3 = r(mean)
qui sum lpopulation if e(SameSample2)
local m_lpopulation = r(mean)
qui sum lopen if e(SameSample2)
local m_lopen = r(mean)
qui sum lethnic if e(SameSample2)
local m_lethnic = r(mean)
qui sum lpolity if e(SameSample2)
local m_lpolity = r(mean)
qui sum lpolitysq if e(SameSample2)
local m_lpolitysq = r(mean)
qui sum dec60 if e(SameSample2)
local m_dec60 = r(mean)
qui sum dec70 if e(SameSample2)
local m_dec70 = r(mean)
qui sum dec90 if e(SameSample2)
local m_dec90 = r(mean)
qui sum civpitfyears if e(SameSample2)
local m_civpitfyears = r(mean) 
qui sum _spline1civpitf if e(SameSample2)
local m__spline1civpitf = r(mean)
qui sum _spline2civpitf if e(SameSample2)
local m__spline2civpitf = r(mean)
qui sum _spline3civpitf if e(SameSample2)
local m__spline3civpitf = r(mean)


local xb1 _b[lcapshare]*lcapshare + _b[lgdptreis]*`m_lgdptreis' + _b[lonegrowthtreis]*`m_lonegrowthtreis' + _b[llnoil_gas_valuePOP_2009]*`m_llnoil_gas_valuePOP_2009' +_b[regch3]*`m_regch3' +_b[mountains]*`m_mountains'  ///
+ _b[lpopulation]*`m_lpopulation' + _b[lopen]*`m_lopen' + _b[lethnic]*`m_lethnic'+ _b[lpolity]*`m_lpolity' +  _b[lpolitysq]*`m_lpolitysq'+ _b[cold]*1 + _b[dec60]*1 + _b[dec70]*0+ _b[dec90]*0 ///
+ _b[civpitfyears]*`m_civpitfyears' + _b[_spline1civpitf]*`m__spline1civpitf' + _b[_spline2civpitf]*`m__spline2civpitf' + _b[_spline3civpitf]*`m__spline3civpitf' + _b[_cons]
	
predictnl prrevpitf = exp(`xb1')/(1+exp(`xb1')), se(se2)

gen cihip = prrevpitf + 1.96*se2
gen cilop = prrevpitf - 1.96*se2

sort lcapshare

graph twoway line  prrevpitf cihip cilop lcapshare, ylabel(0(.02) .1)  ytitle(Prob. civil war) ///
	xtitle(Inequality)  title() legend(off) clpattern(solid dash dash) clwidth(thick  medium) name(war, replace) nodraw 

graph combine coup war, cols(2) 
	
drop SameSample1 SameSample2 prsuccess prrevpitf cihis cilos cihip cilop se1 se2

sort cowcode year



***************************************************************************
***************************************************************************
***************************************************************************
***************************************************************************

**************************
**** ONLINE APPENDIX *****
**************************

* Table A1 calculates the correlation level between different measures of inequality and GDP per capita. 


**** Table A1: Correlation Between Inequality and GDP per capita (Excludes Western Countries)

* All regimes

corr lcapshare_orig lgdptreis if lgdptreis!=. & lonegrowthtreis!=. & L.lnoil_gas_valuePOP_2009!=. & regch3!=. & lopen!=. & lethnic!=. & lpolity!=. & western==0 & year>=1960 

corr lcapshare lgdptreis if lgdptreis!=. & lonegrowthtreis!=. & L.lnoil_gas_valuePOP_2009!=. & regch3!=. & lopen!=. & lethnic!=. & lpolity!=. & western==0 & year>=1960 

corr lshare1 lgdptreis if lgdptreis!=. & lonegrowthtreis!=. & L.lnoil_gas_valuePOP_2009!=. & regch3!=. & lopen!=. & lethnic!=. & lpolity!=. & western==0 & year>=1960 

corr lgini lgdptreis if lgdptreis!=. & lonegrowthtreis!=. & L.lnoil_gas_valuePOP_2009!=. & regch3!=. & lopen!=. & lethnic!=. & lpolity!=. & western==0 & year>=1960 



* Non-democracies

corr lcapshare_orig lgdptreis if lgdptreis!=. & lonegrowthtreis!=. & L.lnoil_gas_valuePOP_2009!=. & regch3!=. & lopen!=. & lethnic!=. & lpolity!=. & western==0 & year>=1960 & ldempol==0

corr lcapshare lgdptreis if lgdptreis!=. & lonegrowthtreis!=. & L.lnoil_gas_valuePOP_2009!=. & regch3!=. & lopen!=. & lethnic!=. & lpolity!=. & western==0 & year>=1960 & ldempol==0

corr lshare1 lgdptreis if lgdptreis!=. & lonegrowthtreis!=. & L.lnoil_gas_valuePOP_2009!=. & regch3!=. & lopen!=. & lethnic!=. & lpolity!=. & western==0 & year>=1960 & ldempol==0

corr lgini lgdptreis if lgdptreis!=. & lonegrowthtreis!=. & L.lnoil_gas_valuePOP_2009!=. & regch3!=. & lopen!=. & lethnic!=. & lpolity!=. & western==0 & year>=1960 & ldempol==0


***************************************************************************

**** Table A2: Summary Statistics

* Median

centile civpitf civprio revpitf success_pow failed_pow effective_number lcapshare lshare1 lgini lgdptreis lonegrowthtreis lnoil_gas_valuePOP_2009 regch3 lethnic lopen polity mountains lpopulation civpitfyears revpitfyears peaceyearssmallprio succpowyears strikes riots revolutions demonstrations conflictindex paramilitary logmilperpc lmilexgdp icrgpropind econfree lmilitary edu publichealth spend if lgdptreis!=. & lonegrowthtreis!=. & L.lnoil_gas_valuePOP_2009!=. & regch3!=. & lopen!=. & lethnic!=. & lpolity!=. & western==0 & year>=1960 

* Mean, St. Deviation, Min/Max

sum civpitf civprio revpitf success_pow failed_pow effective_number lcapshare lshare1 lgini lgdptreis lonegrowthtreis lnoil_gas_valuePOP_2009 regch3 lethnic lopen polity mountains lpopulation civpitfyears revpitfyears peaceyearssmallprio succpowyears strikes riots revolutions demonstrations conflictindex paramilitary logmilperpc lmilexgdp icrgpropind econfree lmilitary edu publichealth spend if lgdptreis!=. & lonegrowthtreis!=. & L.lnoil_gas_valuePOP_2009!=. & regch3!=. & lopen!=. & lethnic!=. & lpolity!=. & western==0 & year>=1960 

*St. Deviation within countries

xtsum civpitf civprio revpitf success_pow failed_pow effective_number lcapshare lshare1 lgini lgdptreis lonegrowthtreis lnoil_gas_valuePOP_2009 regch3 lethnic lopen polity mountains lpopulation civpitfyears revpitfyears peaceyearssmallprio succpowyears strikes riots revolutions demonstrations conflictindex paramilitary logmilperpc lmilexgdp icrgpropind econfree lmilitary edu publichealth spend if lgdptreis!=. & lonegrowthtreis!=. & L.lnoil_gas_valuePOP_2009!=. & regch3!=. & lopen!=. & lethnic!=. & lpolity!=. & western==0 & year>=1960 



***************************************************************************

**** Table A3: Data Sources


***************************************************************************

**** Table A4: Probability of Coups and Civil Wars at Different Inequality Levels

** Capital share 

* 1st Quartile

tab success_pow if lcapshare<62.7345 & lgdptreis!=. & lonegrowthtreis!=. & L.lnoil_gas_valuePOP_2009!=. & regch3!=. & lopen!=. & lethnic!=. & lpolity!=. & western==0 & year>=1960

tab failed_pow if lcapshare<62.7345 & lgdptreis!=. & lonegrowthtreis!=. & L.lnoil_gas_valuePOP_2009!=. & regch3!=. & lopen!=. & lethnic!=. & lpolity!=. & western==0 & year>=1960

tab civpitf if lcapshare<62.7345 & lgdptreis!=. & lonegrowthtreis!=. & L.lnoil_gas_valuePOP_2009!=. & regch3!=. & lopen!=. & lethnic!=. & lpolity!=. & western==0 & year>=1960

tab civprio if lcapshare<62.7345 & lgdptreis!=. & lonegrowthtreis!=. & L.lnoil_gas_valuePOP_2009!=. & regch3!=. & lopen!=. & lethnic!=. & lpolity!=. & western==0 & year>=1960

tab revpitf if lcapshare<62.7345 & lgdptreis!=. & lonegrowthtreis!=. & L.lnoil_gas_valuePOP_2009!=. & regch3!=. & lopen!=. & lethnic!=. & lpolity!=. & western==0 & year>=1960


* 2nd Quartile

tab success_pow if lcapshare>=62.7345 & lcapshare<66.62806 & lgdptreis!=. & lonegrowthtreis!=. & L.lnoil_gas_valuePOP_2009!=. & regch3!=. & lopen!=. & lethnic!=. & lpolity!=. & western==0 & year>=1960

tab failed_pow if lcapshare>=62.7345 & lcapshare<66.62806 & lgdptreis!=. & lonegrowthtreis!=. & L.lnoil_gas_valuePOP_2009!=. & regch3!=. & lopen!=. & lethnic!=. & lpolity!=. & western==0 & year>=1960

tab civpitf if lcapshare>=62.7345 & lcapshare<66.62806 & lgdptreis!=. & lonegrowthtreis!=. & L.lnoil_gas_valuePOP_2009!=. & regch3!=. & lopen!=. & lethnic!=. & lpolity!=. & western==0 & year>=1960

tab civprio if lcapshare>=62.7345 & lcapshare<66.62806 & lgdptreis!=. & lonegrowthtreis!=. & L.lnoil_gas_valuePOP_2009!=. & regch3!=. & lopen!=. & lethnic!=. & lpolity!=. & western==0 & year>=1960

tab revpitf if lcapshare>=62.7345 & lcapshare<66.62806 & lgdptreis!=. & lonegrowthtreis!=. & L.lnoil_gas_valuePOP_2009!=. & regch3!=. & lopen!=. & lethnic!=. & lpolity!=. & western==0 & year>=1960


* 3rd Quartile

tab success_pow if lcapshare>=66.62806 & lcapshare<75.82352 & lgdptreis!=. & lonegrowthtreis!=. & L.lnoil_gas_valuePOP_2009!=. & regch3!=. & lopen!=. & lethnic!=. & lpolity!=. & western==0 & year>=1960

tab failed_pow if lcapshare>=66.62806 & lcapshare<75.82352 & lgdptreis!=. & lonegrowthtreis!=. & L.lnoil_gas_valuePOP_2009!=. & regch3!=. & lopen!=. & lethnic!=. & lpolity!=. & western==0 & year>=1960

tab civpitf if lcapshare>=66.62806 & lcapshare<75.82352 & lgdptreis!=. & lonegrowthtreis!=. & L.lnoil_gas_valuePOP_2009!=. & regch3!=. & lopen!=. & lethnic!=. & lpolity!=. & western==0 & year>=1960

tab civprio if lcapshare>=66.62806 & lcapshare<75.82352 & lgdptreis!=. & lonegrowthtreis!=. & L.lnoil_gas_valuePOP_2009!=. & regch3!=. & lopen!=. & lethnic!=. & lpolity!=. & western==0 & year>=1960

tab revpitf if lcapshare>=66.62806 & lcapshare<75.82352 & lgdptreis!=. & lonegrowthtreis!=. & L.lnoil_gas_valuePOP_2009!=. & regch3!=. & lopen!=. & lethnic!=. & lpolity!=. & western==0 & year>=1960


* 4th Quartile

tab success_pow if lcapshare>=75.82352 & lgdptreis!=. & lonegrowthtreis!=. & L.lnoil_gas_valuePOP_2009!=. & regch3!=. & lopen!=. & lethnic!=. & lpolity!=. & western==0 & year>=1960

tab failed_pow if lcapshare>=75.82352 & lgdptreis!=. & lonegrowthtreis!=. & L.lnoil_gas_valuePOP_2009!=. & regch3!=. & lopen!=. & lethnic!=. & lpolity!=. & western==0 & year>=1960

tab civpitf if lcapshare>=75.82352 & lgdptreis!=. & lonegrowthtreis!=. & L.lnoil_gas_valuePOP_2009!=. & regch3!=. & lopen!=. & lethnic!=. & lpolity!=. & western==0 & year>=1960

tab civprio if lcapshare>=75.82352 & lgdptreis!=. & lonegrowthtreis!=. & L.lnoil_gas_valuePOP_2009!=. & regch3!=. & lopen!=. & lethnic!=. & lpolity!=. & western==0 & year>=1960

tab revpitf if lcapshare>=75.82352 & lgdptreis!=. & lonegrowthtreis!=. & L.lnoil_gas_valuePOP_2009!=. & regch3!=. & lopen!=. & lethnic!=. & lpolity!=. & western==0 & year>=1960




** Share top 1 percent 

* 1st Quartile

tab success_pow if lshare1<6.607916 & lgdptreis!=. & lonegrowthtreis!=. & L.lnoil_gas_valuePOP_2009!=. & regch3!=. & lopen!=. & lethnic!=. & lpolity!=. & western==0 & year>=1960

tab failed_pow if lshare1<6.607916 & lgdptreis!=. & lonegrowthtreis!=. & L.lnoil_gas_valuePOP_2009!=. & regch3!=. & lopen!=. & lethnic!=. & lpolity!=. & western==0 & year>=1960

tab civpitf if lshare1<6.607916 & lgdptreis!=. & lonegrowthtreis!=. & L.lnoil_gas_valuePOP_2009!=. & regch3!=. & lopen!=. & lethnic!=. & lpolity!=. & western==0 & year>=1960

tab civprio if lshare1<6.607916 & lgdptreis!=. & lonegrowthtreis!=. & L.lnoil_gas_valuePOP_2009!=. & regch3!=. & lopen!=. & lethnic!=. & lpolity!=. & western==0 & year>=1960

tab revpitf if lshare1<6.607916 & lgdptreis!=. & lonegrowthtreis!=. & L.lnoil_gas_valuePOP_2009!=. & regch3!=. & lopen!=. & lethnic!=. & lpolity!=. & western==0 & year>=1960


* 2nd Quartile

tab success_pow if lshare1>=6.607916 & lshare1<9.179699 & lgdptreis!=. & lonegrowthtreis!=. & L.lnoil_gas_valuePOP_2009!=. & regch3!=. & lopen!=. & lethnic!=. & lpolity!=. & western==0 & year>=1960

tab failed_pow if lshare1>=6.607916 & lshare1<9.179699 & lgdptreis!=. & lonegrowthtreis!=. & L.lnoil_gas_valuePOP_2009!=. & regch3!=. & lopen!=. & lethnic!=. & lpolity!=. & western==0 & year>=1960

tab civpitf if lshare1>=6.607916 & lshare1<9.179699 & lgdptreis!=. & lonegrowthtreis!=. & L.lnoil_gas_valuePOP_2009!=. & regch3!=. & lopen!=. & lethnic!=. & lpolity!=. & western==0 & year>=1960

tab civprio if lshare1>=6.607916 & lshare1<9.179699 & lgdptreis!=. & lonegrowthtreis!=. & L.lnoil_gas_valuePOP_2009!=. & regch3!=. & lopen!=. & lethnic!=. & lpolity!=. & western==0 & year>=1960

tab revpitf if lshare1>=6.607916 & lshare1<9.179699 & lgdptreis!=. & lonegrowthtreis!=. & L.lnoil_gas_valuePOP_2009!=. & regch3!=. & lopen!=. & lethnic!=. & lpolity!=. & western==0 & year>=1960


* 3rd Quartile

tab success_pow if lshare1>=9.179699 & lshare1<13.45456 & lgdptreis!=. & lonegrowthtreis!=. & L.lnoil_gas_valuePOP_2009!=. & regch3!=. & lopen!=. & lethnic!=. & lpolity!=. & western==0 & year>=1960

tab failed_pow if lshare1>=9.179699 & lshare1<13.45456 & lgdptreis!=. & lonegrowthtreis!=. & L.lnoil_gas_valuePOP_2009!=. & regch3!=. & lopen!=. & lethnic!=. & lpolity!=. & western==0 & year>=1960

tab civpitf if lshare1>=9.179699 & lshare1<13.45456 & lgdptreis!=. & lonegrowthtreis!=. & L.lnoil_gas_valuePOP_2009!=. & regch3!=. & lopen!=. & lethnic!=. & lpolity!=. & western==0 & year>=1960

tab civprio if lshare1>=9.179699 & lshare1<13.45456 & lgdptreis!=. & lonegrowthtreis!=. & L.lnoil_gas_valuePOP_2009!=. & regch3!=. & lopen!=. & lethnic!=. & lpolity!=. & western==0 & year>=1960

tab revpitf if lshare1>=9.179699 & lshare1<13.45456 & lgdptreis!=. & lonegrowthtreis!=. & L.lnoil_gas_valuePOP_2009!=. & regch3!=. & lopen!=. & lethnic!=. & lpolity!=. & western==0 & year>=1960


* 4th Quartile

tab success_pow if lshare1>=13.45456 & lgdptreis!=. & lonegrowthtreis!=. & L.lnoil_gas_valuePOP_2009!=. & regch3!=. & lopen!=. & lethnic!=. & lpolity!=. & western==0 & year>=1960

tab failed_pow if lshare1>=13.45456 & lgdptreis!=. & lonegrowthtreis!=. & L.lnoil_gas_valuePOP_2009!=. & regch3!=. & lopen!=. & lethnic!=. & lpolity!=. & western==0 & year>=1960

tab civpitf if lshare1>=13.45456 & lgdptreis!=. & lonegrowthtreis!=. & L.lnoil_gas_valuePOP_2009!=. & regch3!=. & lopen!=. & lethnic!=. & lpolity!=. & western==0 & year>=1960

tab civprio if lshare1>=13.45456 & lgdptreis!=. & lonegrowthtreis!=. & L.lnoil_gas_valuePOP_2009!=. & regch3!=. & lopen!=. & lethnic!=. & lpolity!=. & western==0 & year>=1960

tab revpitf if lshare1>=13.45456 & lgdptreis!=. & lonegrowthtreis!=. & L.lnoil_gas_valuePOP_2009!=. & regch3!=. & lopen!=. & lethnic!=. & lpolity!=. & western==0 & year>=1960



** Gini Coefficients

* 1st Quartile
 
tab success_pow if L.gini<35.30439 & lgdptreis!=. & lonegrowthtreis!=. & L.lnoil_gas_valuePOP_2009!=. & regch3!=. & lopen!=. & lethnic!=. & lpolity!=. & western==0 & year>=1960

tab failed_pow if L.gini<35.30439 & lgdptreis!=. & lonegrowthtreis!=. & L.lnoil_gas_valuePOP_2009!=. & regch3!=. & lopen!=. & lethnic!=. & lpolity!=. & western==0 & year>=1960

tab civpitf if L.gini<35.30439 & lgdptreis!=. & lonegrowthtreis!=. & L.lnoil_gas_valuePOP_2009!=. & regch3!=. & lopen!=. & lethnic!=. & lpolity!=. & western==0 & year>=1960

tab civprio if L.gini<35.30439 & lgdptreis!=. & lonegrowthtreis!=. & L.lnoil_gas_valuePOP_2009!=. & regch3!=. & lopen!=. & lethnic!=. & lpolity!=. & western==0 & year>=1960

tab revpitf if L.gini<35.30439 & lgdptreis!=. & lonegrowthtreis!=. & L.lnoil_gas_valuePOP_2009!=. & regch3!=. & lopen!=. & lethnic!=. & lpolity!=. & western==0 & year>=1960


* 2nd Quartile

tab success_pow if L.gini>=35.30439 & L.gini<41.56034 & lgdptreis!=. & lonegrowthtreis!=. & L.lnoil_gas_valuePOP_2009!=. & regch3!=. & lopen!=. & lethnic!=. & lpolity!=. & western==0 & year>=1960

tab failed_pow if L.gini>=35.30439 & L.gini<41.56034 & lgdptreis!=. & lonegrowthtreis!=. & L.lnoil_gas_valuePOP_2009!=. & regch3!=. & lopen!=. & lethnic!=. & lpolity!=. & western==0 & year>=1960

tab civpitf if L.gini>=35.30439 & L.gini<41.56034 & lgdptreis!=. & lonegrowthtreis!=. & L.lnoil_gas_valuePOP_2009!=. & regch3!=. & lopen!=. & lethnic!=. & lpolity!=. & western==0 & year>=1960

tab civprio if L.gini>=35.30439 & L.gini<41.56034 & lgdptreis!=. & lonegrowthtreis!=. & L.lnoil_gas_valuePOP_2009!=. & regch3!=. & lopen!=. & lethnic!=. & lpolity!=. & western==0 & year>=1960

tab revpitf if L.gini>=35.30439 & L.gini<41.56034 & lgdptreis!=. & lonegrowthtreis!=. & L.lnoil_gas_valuePOP_2009!=. & regch3!=. & lopen!=. & lethnic!=. & lpolity!=. & western==0 & year>=1960


* 3rd Quartile

tab success_pow if L.gini>=41.56034 & L.gini<48.48099 & lgdptreis!=. & lonegrowthtreis!=. & L.lnoil_gas_valuePOP_2009!=. & regch3!=. & lopen!=. & lethnic!=. & lpolity!=. & western==0 & year>=1960

tab failed_pow if L.gini>=41.56034 & L.gini<48.48099 & lgdptreis!=. & lonegrowthtreis!=. & L.lnoil_gas_valuePOP_2009!=. & regch3!=. & lopen!=. & lethnic!=. & lpolity!=. & western==0 & year>=1960

tab civpitf if L.gini>=41.56034 & L.gini<48.48099 & lgdptreis!=. & lonegrowthtreis!=. & L.lnoil_gas_valuePOP_2009!=. & regch3!=. & lopen!=. & lethnic!=. & lpolity!=. & western==0 & year>=1960

tab civprio if L.gini>=41.56034 & L.gini<48.48099 & lgdptreis!=. & lonegrowthtreis!=. & L.lnoil_gas_valuePOP_2009!=. & regch3!=. & lopen!=. & lethnic!=. & lpolity!=. & western==0 & year>=1960

tab revpitf if L.gini>=41.56034 & L.gini<48.48099 & lgdptreis!=. & lonegrowthtreis!=. & L.lnoil_gas_valuePOP_2009!=. & regch3!=. & lopen!=. & lethnic!=. & lpolity!=. & western==0 & year>=1960


* 4th Quartile

tab success_pow if L.gini>=48.48099 & lgdptreis!=. & lonegrowthtreis!=. & L.lnoil_gas_valuePOP_2009!=. & regch3!=. & lopen!=. & lethnic!=. & lpolity!=. & western==0 & year>=1960

tab failed_pow if L.gini>=48.48099 & lgdptreis!=. & lonegrowthtreis!=. & L.lnoil_gas_valuePOP_2009!=. & regch3!=. & lopen!=. & lethnic!=. & lpolity!=. & western==0 & year>=1960

tab civpitf if L.gini>=48.48099 & lgdptreis!=. & lonegrowthtreis!=. & L.lnoil_gas_valuePOP_2009!=. & regch3!=. & lopen!=. & lethnic!=. & lpolity!=. & western==0 & year>=1960

tab civprio if L.gini>=48.48099 & lgdptreis!=. & lonegrowthtreis!=. & L.lnoil_gas_valuePOP_2009!=. & regch3!=. & lopen!=. & lethnic!=. & lpolity!=. & western==0 & year>=1960

tab revpitf if L.gini>=48.48099 & lgdptreis!=. & lonegrowthtreis!=. & L.lnoil_gas_valuePOP_2009!=. & regch3!=. & lopen!=. & lethnic!=. & lpolity!=. & western==0 & year>=1960


******************************************************************************

* All models cover the same observations and use the same control variables to increase the comparability of the results.

**** Table A5: Effect of Inequality on Coups and Civil War Onsets -- Using the Same Control Variables and Samples

set more off

logit success_pow lcapshare lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic L.polity L.politysq dec60 dec70 dec90 cold civpitfyears _spline1civpitf _spline2civpitf _spline3civpitf if year>=1960 & success_pow!=. & civpitf!=. & western==0, robust

logit failed_pow lcapshare lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic L.polity L.politysq dec60 dec70 dec90 cold civpitfyears _spline1civpitf _spline2civpitf _spline3civpitf if year>=1960 & success_pow!=. & civpitf!=. & western==0, robust

logit civpitf lcapshare lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic L.polity L.politysq dec60 dec70 dec90 cold civpitfyears _spline1civpitf _spline2civpitf _spline3civpitf if year>=1960 & success_pow!=. & civpitf!=. & western==0, robust


******************************************************************************

* Estimates the effect of inequality on different forms of political instability. 

**** Table A6: Effect of Inequality on Political Instability

set more off

* Strikes

nbreg strikes L.strikes lcapshare lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lpopulation lethnic L.polity L.politysq cold dec60 dec70 dec90  if year>=1960  & western==0, robust

nbreg strikes L.strikes lshare1 lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lpopulation lethnic L.polity L.politysq cold dec60 dec70 dec90  if year>=1960  & western==0, robust

nbreg strikes L.strikes L.gini lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lpopulation lopen lethnic L.polity L.politysq cold dec60 dec70 dec90  if year>=1960  & western==0, robust

	
* Riots

nbreg riots L.riots lcapshare lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic lpopulation L.polity L.politysq cold dec60 dec70 dec90  if year>=1960  & western==0, robust

nbreg riots L.riots lshare1 lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic lpopulation L.polity L.politysq cold dec60 dec70 dec90  if year>=1960  & western==0, robust

nbreg riots L.riots L.gini lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lpopulation lopen lethnic L.polity L.politysq cold dec60 dec70 dec90  if year>=1960  & western==0, robust

	
* Revolutions

nbreg revolutions L.revolutions lcapshare lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lpopulation lethnic L.polity L.politysq cold dec60 dec70 dec90  if year>=1960  & western==0, robust

nbreg revolutions L.revolutions lshare1 lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lpopulation lopen lethnic L.polity L.politysq cold dec60 dec70 dec90  if year>=1960  & western==0, robust

nbreg revolutions L.revolutions L.gini lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 lpopulation regch3 lopen lethnic L.polity L.politysq cold dec60 dec70 dec90  if year>=1960  & western==0, robust

	
* Demonstrations

nbreg demonstrations L.demonstrations lcapshare lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lpopulation lethnic L.polity L.politysq cold dec60 dec70 dec90   if year>=1960  & western==0, robust

nbreg demonstrations L.demonstrations lshare1 lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lpopulation lopen lethnic L.polity L.politysq cold dec60 dec70 dec90  if year>=1960  & western==0, robust

nbreg demonstrations L.demonstrations L.gini lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 lpopulation regch3 lopen lethnic L.polity L.politysq cold dec60 dec70 dec90  if year>=1960  & western==0, robust

	
******************************************************************************

* The DV is the aggregate conflict index of Banks (2014).

**** Table A7: Effect of Inequality on the Conflict Index

set more off

reg conflictindex L.conflictindex lcapshare lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lpopulation lethnic L.polity L.politysq cold dec60 dec70 dec90  if year>=1960  & western==0, robust

reg conflictindex L.conflictindex lshare1 lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lpopulation lethnic L.polity L.politysq cold dec60 dec70 dec90  if year>=1960  & western==0, robust

reg conflictindex L.conflictindex L.gini lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lpopulation lopen lethnic L.polity L.politysq cold dec60 dec70 dec90  if year>=1960  & western==0, robust

	
******************************************************************************

* Table A8 performs a mediation analysis of the effect of inequality on civil war onsets. The mediating variable is coup-proofing. Model 1 runs an OLS regression predicting coup-proofing and model 2 a logit regression predicting civil wars.

**** Table A8: Mediation Analysis of the Effect of Inequality on Civil War Onsets

set more off

medeff (regress leffective_number lcapshare  lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic lpolity lpolitysq cold dec70   dec90 civpitfyears _spline1civpitf _spline2civpitf _spline3civpitf) (logit civpitf lcapshare leffective_number  lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic lpolity lpolitysq cold dec70   dec90 civpitfyears _spline1civpitf _spline2civpitf _spline3civpitf) if ldempol==0 & western==0, level(95) vce(robust) treat(lcapshare  0 1) mediate(leffective_number) sims(1000)

******************************************************************************

* Performs a mediation analysis of the effect of inequality on coups. The mediating variable is coup-proofing. Model 1 runs an OLS regression predicting coup-proofing and model 2 a logit regression predicting coups.

**** Table A9: Mediation Analysis of the Effect of Inequality on Coups

set more off

medeff (regress leffective_number  lcapshare lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic  lpolity lpolitysq cold dec80 dec90 succpowyears _spline1sucpow _spline2sucpow _spline3sucpow) (logit success_pow lcapshare leffective_number lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic  lpolity lpolitysq cold dec80 dec90 succpowyears _spline1sucpow _spline2sucpow _spline3sucpow) if ldempol==0 & western==0, level(95) vce(robust) treat(lcapshare 0 1) mediate(leffective_number) sims(1000)

******************************************************************************

* Redoes Table 3 using 'paramilitary' as a measure of coup-proofing. 

**** Table A10: Effect of Inequality on Coup-Proofing (Paramilitary)

set more off

reg paramilitary lcapshare lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic L.polity L.politysq cold dec60 dec70 dec90 succpowyears if ldempol ==0 , robust

reg paramilitary lshare1 lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic L.polity L.politysq cold dec60 dec70 dec90 succpowyears if ldempol ==0 , robust

reg paramilitary L.gini lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic L.polity L.politysq cold dec60 dec70  dec90 succpowyears if ldempol ==0 , robust

	
******************************************************************************

* Redoes Table 4 using 'paramilitary' as a measure of coup-proofing.

**** Table A11: Effect of Coup-Proofing on Civil War Onsets and Coups (Paramilitary)

set more off

logit civpitf L.paramilitary lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic L.polity L.politysq cold dec60 dec70  dec90 civpitfyears _spline1civpitf _spline2civpitf _spline3civpitf if year>=1960  & western==0 & ldempol==0 , robust

logit civprio L.paramilitary lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic L.polity L.politysq cold dec60 dec70  dec90 peaceyearssmallprio _spline1smallprio _spline2smallprio _spline3smallprio if year>=1960 & western==0 & ldempol==0 , robust

logit success_pow L.paramilitary lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic L.polity L.politysq cold dec60 dec70  dec90 succpowyears _spline1sucpow _spline2sucpow _spline3sucpow if year>=1960 & western==0 & ldempol==0 , robust

logit failed_pow L.paramilitary lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic L.polity L.politysq cold dec60 dec70  dec90 succpowyears _spline1sucpow _spline2sucpow _spline3sucpow if year>=1960 & western==0 & ldempol==0 , robust

	
******************************************************************************

* Redoes Table 4 while restricting the sample to observations for which 'paramilitary' is not missing.

**** Table A12: Effect of Coup-Proofing on Civil War Onsets and Coups (Restricted Sample)

set more off

logit civpitf L.effective_number lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic L.polity L.politysq cold dec60 dec70  dec90 civpitfyears _spline1civpitf _spline2civpitf _spline3civpitf if year>=1960 & ldempol==0 & western==0 & L.paramilitary!=., robust

logit civprio L.effective_number lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic L.polity L.politysq cold dec60 dec70  dec90 peaceyearssmallprio _spline1smallprio _spline2smallprio _spline3smallprio if year>=1960 & ldempol==0 & western==0 & L.paramilitary!=., robust

logit success_pow L.effective_number lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic L.polity L.politysq cold dec60 dec70  dec90 succpowyears _spline1sucpow _spline2sucpow _spline3sucpow if year>=1960 & ldempol==0 & western==0 & L.paramilitary!=., robust

logit failed_pow L.effective_number lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic L.polity L.politysq cold dec60 dec70  dec90 succpowyears _spline1sucpow _spline2sucpow _spline3sucpow if year>=1960 & ldempol==0 & western==0 & L.paramilitary!=., robust

	
******************************************************************************

* Redoes Table 1 with control variables for military personal and military expenditure.

**** Table A13: Effect of Inequality on Civil War Onsets (Military Personal & Military Expenditure)

set more off

logit civpitf lcapshare lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic lmilexgdp logmilperpc L.polity L.politysq cold dec60 dec70 dec90 civpitfyears _spline1civpitf _spline2civpitf _spline3civpitf if year>=1960 & western==0, robust

logit civpitf lshare1 lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic lmilexgdp logmilperpc L.polity L.politysq cold dec60 dec70 dec90 civpitfyears _spline1civpitf _spline2civpitf _spline3civpitf if year>=1960 & western==0, robust

logit civpitf L.gini lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic lmilexgdp logmilperpc L.polity L.politysq cold dec60 dec70 dec90 civpitfyears _spline1civpitf _spline2civpitf _spline3civpitf if year>=1960 & western==0, robust

logit civprio lcapshare lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic lmilexgdp logmilperpc L.polity L.politysq cold dec60 dec70 dec90 peaceyearssmallprio _spline1smallprio _spline2smallprio _spline3smallprio if year>=1960 & western==0, robust

logit civprio lshare1 lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic lmilexgdp logmilperpc L.polity L.politysq cold dec60 dec70 dec90 peaceyearssmallprio _spline1smallprio _spline2smallprio _spline3smallprio if year>=1960 & western==0, robust

logit civprio L.gini lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic lmilexgdp logmilperpc L.polity L.politysq cold dec60 dec70 dec90 peaceyearssmallprio _spline1smallprio _spline2smallprio _spline3smallprio if year>=1960 & western==0, robust

	
******************************************************************************

* Redoes Table 2 with control variables for military personal and military expenditure.

**** Table A14: Effect of Inequality on Coups (Military Personal & Military Expenditure)

set more off

logit success_pow lcapshare lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic  lmilexgdp logmilperpc L.polity L.politysq cold dec60 dec70 dec90 succpowyears _spline1sucpow _spline2sucpow _spline3sucpow if year>=1960 & western==0, robust

logit success_pow lshare1 lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic  lmilexgdp logmilperpc L.polity L.politysq cold dec60 dec70 dec90 succpowyears _spline1sucpow _spline2sucpow _spline3sucpow if year>=1960 & western==0, robust

logit success_pow L.gini lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic  lmilexgdp logmilperpc L.polity L.politysq cold dec60 dec70 dec90 succpowyears _spline1sucpow _spline2sucpow _spline3sucpow if year>=1960 & western==0, robust

logit success_pow lcapshare lcapsharesq lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic  lmilexgdp logmilperpc L.polity L.politysq cold dec60 dec70 dec90 succpowyears _spline1sucpow _spline2sucpow _spline3sucpow if year>=1960 & western==0, robust

logit success_pow lshare1 lshare1sq lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic  lmilexgdp logmilperpc L.polity L.politysq cold dec60 dec70 dec90 succpowyears _spline1sucpow _spline2sucpow _spline3sucpow if year>=1960 & western==0, robust

logit success_pow L.gini L.ginisq lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic  lmilexgdp logmilperpc L.polity L.politysq cold dec60 dec70 dec90 succpowyears _spline1sucpow _spline2sucpow _spline3sucpow if year>=1960 & western==0, robust

logit failed_pow lcapshare lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic  lmilexgdp logmilperpc L.polity L.politysq cold dec60 dec70 dec90 succpowyears _spline1sucpow _spline2sucpow _spline3sucpow if year>=1960 & western==0, robust

logit failed_pow lshare1 lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic  lmilexgdp logmilperpc L.polity L.politysq cold dec60 dec70 dec90 succpowyears _spline1sucpow _spline2sucpow _spline3sucpow if year>=1960 & western==0, robust

logit failed_pow L.gini lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic  lmilexgdp logmilperpc L.polity L.politysq cold dec60 dec70 dec90 succpowyears _spline1sucpow _spline2sucpow _spline3sucpow if year>=1960 & western==0, robust

	
******************************************************************************

* Redoes Table 3 with control variables for military personal and military expenditure.

**** Table A15: Effect of Inequality on Coup-Proofing (Military Personal & Military Expenditure)

set more off

reg effective_number lcapshare lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic lmilexgdp logmilperpc L.polity L.politysq cold dec60 dec70 dec90 succpowyears if ldempol ==0 & western==0, robust

reg effective_number lshare1 lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic lmilexgdp logmilperpc L.polity L.politysq cold dec60 dec70 dec90 succpowyears if ldempol ==0 & western==0, robust

reg effective_number L.gini lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic lmilexgdp logmilperpc L.polity L.politysq cold dec60 dec70  dec90 succpowyears if ldempol ==0 & western==0, robust

	
******************************************************************************

* Redoes Table 4 with control variables for military personal and military expenditure. 

**** Table A16: Effect of Coup-Proofing on Civil War Onsets and Coups (Military Personal & Military Expenditure)

set more off

logit civpitf L.effective_number lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic  lmilexgdp logmilperpc L.polity L.politysq cold dec60 dec70  dec90 civpitfyears _spline1civpitf _spline2civpitf _spline3civpitf if year>=1960 & ldempol==0 & western==0, robust

logit civprio L.effective_number lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic  lmilexgdp logmilperpc L.polity L.politysq cold dec60 dec70  dec90 peaceyearssmallprio _spline1smallprio _spline2smallprio _spline3smallprio if year>=1960 & ldempol==0 & western==0, robust

logit success_pow L.effective_number lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic  lmilexgdp logmilperpc L.polity L.politysq cold dec60 dec70  dec90 succpowyears _spline1sucpow _spline2sucpow _spline3sucpow if year>=1960 & ldempol==0 & western==0, robust

logit failed_pow L.effective_number lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic  lmilexgdp logmilperpc L.polity L.politysq cold dec60 dec70  dec90 succpowyears _spline1sucpow _spline2sucpow _spline3sucpow if year>=1960 & ldempol==0 & western==0, robust

	
******************************************************************************

* Redoes the main models with a control variable for government expenditure. 
* Model 1 redoes model 1 of Table 1; model 2 redoes model 19 of Table 4; model 3 redoes model 4 of Table 1; model 4 redoes model 20 of Table 4; model 5 redoes model 7 of Table 2; and model 6 redoes model 16 of Table 3.

**** Table A17: Effect of Inequality and Coup-Proofing on Civil War Onsets, Coups and Coup-Proofing (Government Expenditure)

set more off

logit civpitf lcapshare lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic L.spend L.polity L.politysq cold dec60 dec70 dec90 civpitfyears _spline1civpitf _spline2civpitf _spline3civpitf if year>=1960 & western==0, robust

logit civpitf L.effective_number lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic L.spend L.polity L.politysq cold dec60 dec70  dec90 civpitfyears _spline1civpitf _spline2civpitf _spline3civpitf if year>=1960 & ldempol==0 & western==0, robust
	
logit civprio lcapshare lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic L.spend L.polity L.politysq cold dec60 dec70 dec90 peaceyearssmallprio _spline1smallprio _spline2smallprio _spline3smallprio if year>=1960 & western==0, robust
	
logit civprio L.effective_number lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic L.spend L.polity L.politysq cold dec60 dec70  dec90 peaceyearssmallprio _spline1smallprio _spline2smallprio _spline3smallprio if year>=1960 & ldempol==0 & western==0, robust

logit success_pow lcapshare lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic L.spend L.polity L.politysq cold dec60 dec70 dec90 succpowyears _spline1sucpow _spline2sucpow _spline3sucpow if year>=1960 & western==0, robust

reg effective_number lcapshare lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic L.polity L.politysq L.spend cold dec60 dec70 dec90 succpowyears if ldempol ==0 & western==0, robust


*******************************************************************************************************

* Redoes the main models while restricting the sample to observations for which 'government expenditure' is not missing. 
* Model 1 redoes model 1 of Table 1; model 2 redoes model 19 of Table 4; model 3 redoes model 4 of Table 1; model 4 redoes model 20 of Table 4; model 5 redoes model 7 of Table 2; and model 6 redoes model 16 of Table 3.

**** Table A18: Effect of Inequality and Coup-Proofing on Civil War Onsets, Coups and Coup-Proofing (Restricted Sample)

set more off

logit civpitf lcapshare lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic L.polity L.politysq cold dec60 dec70 dec90 civpitfyears _spline1civpitf _spline2civpitf _spline3civpitf if year>=1960 & western==0 & L.spend!=., robust

logit civpitf L.effective_number lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic  L.polity L.politysq cold dec60 dec70  dec90 civpitfyears _spline1civpitf _spline2civpitf _spline3civpitf if year>=1960 & ldempol==0 & western==0 & L.spend!=., robust
	
logit civprio lcapshare lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic  L.polity L.politysq cold dec60 dec70 dec90 peaceyearssmallprio _spline1smallprio _spline2smallprio _spline3smallprio if year>=1960 & western==0 & L.spend!=., robust
	
logit civprio L.effective_number lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic  L.polity L.politysq cold dec60 dec70  dec90 peaceyearssmallprio _spline1smallprio _spline2smallprio _spline3smallprio if year>=1960 & ldempol==0 & western==0 & L.spend!=., robust

logit success_pow lcapshare lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic  L.polity L.politysq cold dec60 dec70 dec90 succpowyears _spline1sucpow _spline2sucpow _spline3sucpow if year>=1960 & western==0 & L.spend!=., robust

reg effective_number lcapshare lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic L.polity L.politysq  cold dec60 dec70 dec90 succpowyears if ldempol ==0 & western==0 & L.spend!=., robust

	
*******************************************************************************************************

* Redoes the main models with a control variable for public education spending. 
* Model 1 redoes model 1 of Table 1; model 2 redoes model 19 of Table 4; model 3 redoes model 4 of Table 1; model 4 redoes model 20 of Table 4; model 5 redoes model 7 of Table 2; and model 6 redoes model 16 of Table 3. 

**** Table A19: Effect of Inequality and Coup-Proofing on Civil War Onsets, Coups and Coup-Proofing (Public Education Spending)

set more off

logit civpitf lcapshare lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic L.edu L.polity L.politysq cold dec60 dec70 dec90 civpitfyears _spline1civpitf _spline2civpitf _spline3civpitf if year>=1960 & western==0, robust

logit civpitf L.effective_number lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic L.edu L.polity L.politysq cold dec60 dec70  dec90 civpitfyears _spline1civpitf _spline2civpitf _spline3civpitf if year>=1960 & ldempol==0 & western==0, robust
	
logit civprio lcapshare lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic L.edu L.polity L.politysq cold dec60 dec70 dec90 peaceyearssmallprio _spline1smallprio _spline2smallprio _spline3smallprio if year>=1960 & western==0, robust
	
logit civprio L.effective_number lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic L.edu L.polity L.politysq cold dec60 dec70  dec90 peaceyearssmallprio _spline1smallprio _spline2smallprio _spline3smallprio if year>=1960 & ldempol==0 & western==0, robust

logit success_pow lcapshare lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic L.edu L.polity L.politysq cold dec60 dec70 dec90 succpowyears _spline1sucpow _spline2sucpow _spline3sucpow if year>=1960 & western==0, robust

reg effective_number lcapshare lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic L.polity L.politysq L.edu cold dec60 dec70 dec90 succpowyears if ldempol ==0 & western==0, robust


*******************************************************************************************************

* Redoes the main models while restricting the sample to observations for which 'public education spending' is not missing. 
* Model 1 redoes model 1 of Table 1; model 2 redoes model 19 of Table 4; model 3 redoes model 4 of Table 1; model 4 redoes model 20 of Table 4; model 5 redoes model 7 of Table 2; and model 6 redoes model 16 of Table 3.

**** Table A20: Effect of Inequality and Coup-Proofing on Civil War Onsets, Coups and Coup-Proofing (Restricted Sample)

set more off

logit civpitf lcapshare lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic L.polity L.politysq cold dec60 dec70 dec90 civpitfyears _spline1civpitf _spline2civpitf _spline3civpitf if year>=1960 & western==0 &  L.edu!=., robust

logit civpitf L.effective_number lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic L.polity L.politysq cold dec60 dec70  dec90 civpitfyears _spline1civpitf _spline2civpitf _spline3civpitf if year>=1960 & ldempol==0 & western==0 &  L.edu!=., robust
	
logit civprio lcapshare lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic L.polity L.politysq cold dec60 dec70 dec90 peaceyearssmallprio _spline1smallprio _spline2smallprio _spline3smallprio if year>=1960 & western==0 &  L.edu!=., robust
	
logit civprio L.effective_number lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic L.polity L.politysq cold dec60 dec70  dec90 peaceyearssmallprio _spline1smallprio _spline2smallprio _spline3smallprio if year>=1960 & ldempol==0 & western==0 &  L.edu!=., robust

logit success_pow lcapshare lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic L.polity L.politysq cold dec60 dec70 dec90 succpowyears _spline1sucpow _spline2sucpow _spline3sucpow if year>=1960 & western==0 &  L.edu!=., robust

reg effective_number lcapshare lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic L.polity L.politysq cold dec60 dec70 dec90 succpowyears if ldempol ==0 & western==0 &  L.edu!=., robust


*******************************************************************************************************

* Redoes the main models with a control variable for public education spending. 
* Model 1 redoes model 1 of Table 1; model 2 redoes model 19 of Table 4; model 3 redoes model 4 of Table 1; model 4 redoes model 20 of Table 4; model 5 redoes model 7 of Table 2; and model 6 redoes model 16 of Table 3.

**** Table A21: Effect of Inequality and Coup-Proofing on Civil War Onsets, Coups and Coup-Proofing (Public Health Spending)

set more off

logit civpitf lcapshare lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic L.publichealth L.polity L.politysq cold dec60 dec70 dec90 civpitfyears _spline1civpitf _spline2civpitf _spline3civpitf if year>=1960 & western==0, robust

logit civpitf L.effective_number lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic L.publichealth L.polity L.politysq cold dec60 dec70  dec90 civpitfyears _spline1civpitf _spline2civpitf _spline3civpitf if year>=1960 & ldempol==0 & western==0, robust
	
logit civprio lcapshare lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic L.publichealth L.polity L.politysq cold dec60 dec70 dec90 peaceyearssmallprio _spline1smallprio _spline2smallprio _spline3smallprio if year>=1960 & western==0, robust
	
logit civprio L.effective_number lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic L.publichealth L.polity L.politysq cold dec60 dec70  dec90 peaceyearssmallprio _spline1smallprio _spline2smallprio _spline3smallprio if year>=1960 & ldempol==0 & western==0, robust

logit success_pow lcapshare lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic L.publichealth L.polity L.politysq cold dec60 dec70 dec90 succpowyears _spline1sucpow _spline2sucpow _spline3sucpow if year>=1960 & western==0, robust

reg effective_number lcapshare lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic L.polity L.politysq L.publichealth cold dec60 dec70 dec90 succpowyears if ldempol ==0 & western==0, robust


*******************************************************************************************************

* Redoes the main models while restricting the sample to observations for which 'public health spending' is not missing. 
* Model 1 redoes model 1 of Table 1; model 2 redoes model 19 of Table 4; model 3 redoes model 4 of Table 1; model 4 redoes model 20 of Table 4; model 5 redoes model 7 of Table 2; and model 6 redoes model 16 of Table 3.

**** Table A22: Effect of Inequality and Coup-Proofing on Civil War Onsets, Coups and Coup-Proofing (Restricted Sample)

set more off

logit civpitf lcapshare lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic L.polity L.politysq cold dec60 dec70 dec90 civpitfyears _spline1civpitf _spline2civpitf _spline3civpitf if year>=1960 & western==0 &  L.publichealth!=., robust

logit civpitf L.effective_number lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic L.polity L.politysq cold dec60 dec70  dec90 civpitfyears _spline1civpitf _spline2civpitf _spline3civpitf if year>=1960 & ldempol==0 & western==0 &  L.publichealth!=., robust
	
logit civprio lcapshare lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic L.polity L.politysq cold dec60 dec70 dec90 peaceyearssmallprio _spline1smallprio _spline2smallprio _spline3smallprio if year>=1960 & western==0 &  L.publichealth!=., robust
	
logit civprio L.effective_number lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic L.polity L.politysq cold dec60 dec70  dec90 peaceyearssmallprio _spline1smallprio _spline2smallprio _spline3smallprio if year>=1960 & ldempol==0 & western==0 &  L.publichealth!=., robust

logit success_pow lcapshare lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic L.polity L.politysq cold dec60 dec70 dec90 succpowyears _spline1sucpow _spline2sucpow _spline3sucpow if year>=1960 & western==0 &  L.publichealth!=., robust

reg effective_number lcapshare lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic L.polity L.politysq cold dec60 dec70 dec90 succpowyears if ldempol ==0 & western==0 &  L.publichealth!=., robust


*******************************************************************************************************

* Redoes the main models while controlling for International Country Risk Guide (ICRG). 
* Model 1 redoes model 1 of Table 1; model 2 redoes model 19 of Table 4; model 3 redoes model 4 of Table 1; model 4 redoes model 20 of Table 4; model 5 redoes model 7 of Table 2; and model 6 redoes model 16 of Table 3.

**** Table A23: Effect of Inequality and Coup-Proofing on Civil War Onsets, Coups and Coup-Proofing (ICRG)

set more off

logit civpitf lcapshare lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic L.icrgpropind cold dec60 dec70 dec90 civpitfyears _spline1civpitf _spline2civpitf _spline3civpitf if year>=1960 & western==0, robust

logit civpitf L.effective_number lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic L.icrgpropind cold dec60 dec70  dec90 civpitfyears _spline1civpitf _spline2civpitf _spline3civpitf if year>=1960 & ldempol==0 & western==0, robust
	
logit civprio lcapshare lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic L.icrgpropind cold dec60 dec70 dec90 peaceyearssmallprio _spline1smallprio _spline2smallprio _spline3smallprio if year>=1960 & western==0, robust
	
logit civprio L.effective_number lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic L.icrgpropind  cold dec60 dec70  dec90 peaceyearssmallprio _spline1smallprio _spline2smallprio _spline3smallprio if year>=1960 & ldempol==0 & western==0, robust

logit success_pow lcapshare lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic L.icrgpropind  cold dec60 dec70 dec90 succpowyears _spline1sucpow _spline2sucpow _spline3sucpow if year>=1960 & western==0, robust

reg effective_number lcapshare lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic  L.icrgpropind cold dec60 dec70 dec90 succpowyears if ldempol ==0 & western==0, robust


*******************************************************************************************************

* Redoes the main models while restricting the sample to observations for which 'International Country Risk Guide (ICRG)' is not missing. 
* Model 1 redoes model 1 of Table 1; model 2 redoes model 19 of Table 4; model 3 redoes model 4 of Table 1; model 4 redoes model 20 of Table 4; model 5 redoes model 7 of Table 2; and model 6 redoes model 16 of Table 3.

**** Table A24: Effect of Inequality and Coup-Proofing on Civil War Onsets, Coups and Coup-Proofing (Restricted Sample)

set more off

logit civpitf lcapshare lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic cold dec60 dec70 dec90 civpitfyears _spline1civpitf _spline2civpitf _spline3civpitf if year>=1960 & western==0 & L.icrgpropind!=., robust

logit civpitf L.effective_number lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic  cold dec60 dec70  dec90 civpitfyears _spline1civpitf _spline2civpitf _spline3civpitf if year>=1960 & ldempol==0 & western==0 & L.icrgpropind!=., robust
	
logit civprio lcapshare lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic  cold dec60 dec70 dec90 peaceyearssmallprio _spline1smallprio _spline2smallprio _spline3smallprio if year>=1960 & western==0 & L.icrgpropind!=., robust
	
logit civprio L.effective_number lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic  cold dec60 dec70  dec90 peaceyearssmallprio _spline1smallprio _spline2smallprio _spline3smallprio if year>=1960 & ldempol==0 & western==0 & L.icrgpropind!=., robust

logit success_pow lcapshare lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic  cold dec60 dec70 dec90 succpowyears _spline1sucpow _spline2sucpow _spline3sucpow if year>=1960 & western==0 & L.icrgpropind!=., robust

reg effective_number lcapshare lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic  cold dec60 dec70 dec90 succpowyears if ldempol ==0 & western==0 & L.icrgpropind!=., robust

	
*******************************************************************************************************

* Redoes the main models while controlling for the economic freedom index. 
* Model 1 redoes model 1 of Table 1; model 2 redoes model 19 of Table 4; model 3 redoes model 4 of Table 1; model 4 redoes model 20 of Table 4; model 5 redoes model 7 of Table 2; and model 6 redoes model 16 of Table 3.

**** Table A25: Effect of Inequality and Coup-Proofing on Civil War Onsets, Coups and Coup-Proofing (Economic Freedom)

set more off

logit civpitf lcapshare lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic L.econfree cold dec60 dec70 dec90 civpitfyears _spline1civpitf _spline2civpitf _spline3civpitf if year>=1960 & western==0, robust

logit civpitf L.effective_number lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic L.econfree  cold dec60 dec70  dec90 civpitfyears _spline1civpitf _spline2civpitf _spline3civpitf if year>=1960 & ldempol==0 & western==0, robust
	
logit civprio lcapshare lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic L.econfree  cold dec60 dec70 dec90 peaceyearssmallprio _spline1smallprio _spline2smallprio _spline3smallprio if year>=1960 & western==0, robust
	
logit civprio L.effective_number lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic L.econfree  cold dec60 dec70  dec90 peaceyearssmallprio _spline1smallprio _spline2smallprio _spline3smallprio if year>=1960 & ldempol==0 & western==0, robust

logit success_pow lcapshare lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic L.econfree  cold dec60 dec70 dec90 succpowyears _spline1sucpow _spline2sucpow _spline3sucpow if year>=1960 & western==0, robust

reg effective_number lcapshare lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic L.econfree cold dec60 dec70 dec90 succpowyears if ldempol ==0 & western==0, robust


*******************************************************************************************************

* Redoes the main models while restricting the sample to observations for which 'Economic Freedom' is not missing. 
* Model 1 redoes model 1 of Table 1; model 2 redoes model 19 of Table 4; model 3 redoes model 4 of Table 1; model 4 redoes model 20 of Table 4; model 5 redoes model 7 of Table 2; and model 6 redoes model 16 of Table 3.

**** Table A26: Effect of Inequality and Coup-Proofing on Civil War Onsets, Coups and Coup-Proofing (Restricted Sample)

set more off

logit civpitf lcapshare lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic cold dec60 dec70 dec90 civpitfyears _spline1civpitf _spline2civpitf _spline3civpitf if year>=1960 & western==0 &  L.econfree!=., robust

logit civpitf L.effective_number lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic cold dec60 dec70  dec90 civpitfyears _spline1civpitf _spline2civpitf _spline3civpitf if year>=1960 & ldempol==0 & western==0 &  L.econfree!=., robust
	
logit civprio lcapshare lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic cold dec60 dec70 dec90 peaceyearssmallprio _spline1smallprio _spline2smallprio _spline3smallprio if year>=1960 & western==0 &  L.econfree!=., robust
	
logit civprio L.effective_number lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic cold dec60 dec70  dec90 peaceyearssmallprio _spline1smallprio _spline2smallprio _spline3smallprio if year>=1960 & ldempol==0 & western==0 &  L.econfree!=., robust

logit success_pow lcapshare lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic cold dec60 dec70 dec90 succpowyears _spline1sucpow _spline2sucpow _spline3sucpow if year>=1960 & western==0 &  L.econfree!=., robust

reg effective_number lcapshare lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic cold dec60 dec70 dec90 succpowyears if ldempol ==0 & western==0 &  L.econfree!=., robust

	
*******************************************************************************************************

* Redoes Table 1 using class-based civil wars as defined by the Political Instability Task Force (PITF). 
* Class-based civil wars are those that are classified as 'revolutionary wars' (as opposed to 'ethnic wars') by the PITF. 
* These are defined as "episodes of violent conflict between governments and politically organized groups (political challengers) that seek to overthrow the central government, to replace its leaders, or to seize power in one region" 
* and ethnic wars as "episodes of violent conflict between governments and national, ethnic, religious, or other communal minorities (ethnic challengers) in which the challengers seek major changes in their status" (pp.5-6, Codebook).

**** Table A27: Effect of Inequality on Class-Based Civil Wars

set more off

logit revpitf lcapshare lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic L.polity L.politysq revpitfyears _spline1revpitf _spline2revpitf _spline3revpitf cold dec60 dec70 dec90 if year>=1960 & western==0, robust
  
logit revpitf lshare1 lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic L.polity L.politysq revpitfyears _spline1revpitf _spline2revpitf _spline3revpitf cold dec60 dec70 dec90 if year>=1960 & western==0, robust

logit revpitf L.gini lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic L.polity L.politysq revpitfyears _spline1revpitf _spline2revpitf _spline3revpitf cold dec60 dec70 dec90 if year>=1960 & western==0, robust


******************************************************************************

* Redoes all models reported in Tables 1-3 using the original capital shares of Ortega and Rodriguez (2006).

**** Table A28: Non-Imputed Capital Shares

set more off

logit civpitf lcapshare_orig lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic L.polity L.politysq cold dec60 dec70  dec90 civpitfyears _spline1civpitf _spline2civpitf _spline3civpitf if year>=1960 & western==0, robust

logit civprio lcapshare_orig lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic L.polity L.politysq cold dec60 dec70  dec90 peaceyearssmallprio _spline1smallprio _spline2smallprio _spline3smallprio if year>=1960 & western==0, robust

logit success_pow lcapshare_orig lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic L.polity L.politysq cold dec60 dec70  dec90  succpowyears _spline1sucpow _spline2sucpow _spline3sucpow if year>=1960 & western==0, robust

logit failed_pow lcapshare_orig lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic L.polity L.politysq cold dec60 dec70  dec90  succpowyears _spline1sucpow _spline2sucpow _spline3sucpow if year>=1960 & western==0, robust

reg effective_number lcapshare_orig lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic L.polity L.politysq  cold  dec70  dec90 succpowyears if ldempol ==0 & western==0, robust


******************************************************************************

* Redoes Table 1 with Western countries.

**** Table A29: Effect of Inequality on Civil War Onsets (Includes Western Countries)

set more off

logit civpitf lcapshare lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic L.polity L.politysq cold dec60 dec70 dec90 civpitfyears _spline1civpitf _spline2civpitf _spline3civpitf if year>=1960 , robust

logit civpitf lshare1 lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic L.polity L.politysq cold dec60 dec70  dec90 civpitfyears _spline1civpitf _spline2civpitf _spline3civpitf if year>=1960, robust

logit civpitf L.gini lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic L.polity L.politysq cold dec60 dec70  dec90 civpitfyears _spline1civpitf _spline2civpitf _spline3civpitf if year>=1960, robust

logit civprio lcapshare lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic L.polity L.politysq cold dec60 dec70 dec90 peaceyearssmallprio _spline1smallprio _spline2smallprio _spline3smallprio if year>=1960, robust
	
logit civprio lshare1 lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic L.polity L.politysq cold dec60 dec70 dec90 peaceyearssmallprio _spline1smallprio _spline2smallprio _spline3smallprio if year>=1960, robust

logit civprio L.gini lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic L.polity L.politysq cold dec60 dec70  dec90 peaceyearssmallprio _spline1smallprio _spline2smallprio _spline3smallprio if year>=1960, robust


******************************************************************************

* Redoes Table 2 with Western countries.

**** Table A30: Effect of Inequality on Coups (Includes Western Countries)

set more off

logit success_pow lcapshare lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic L.polity L.politysq cold dec60 dec70  dec90  succpowyears _spline1sucpow _spline2sucpow _spline3sucpow if year>=1960, robust

logit success_pow lshare1 lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic L.polity L.politysq cold dec60 dec70  dec90  succpowyears _spline1sucpow _spline2sucpow _spline3sucpow if year>=1960, robust

logit success_pow L.gini lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic L.polity L.politysq cold dec60 dec70  dec90  succpowyears _spline1sucpow _spline2sucpow _spline3sucpow if year>=1960, robust

logit success_pow lcapshare lcapsharesq lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic L.polity L.politysq  cold dec60 dec70  dec90  succpowyears _spline1sucpow _spline2sucpow _spline3sucpow if year>=1960 , robust

logit success_pow lshare1 lshare1sq lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic L.polity L.politysq cold dec60 dec70  dec90  succpowyears _spline1sucpow _spline2sucpow _spline3sucpow if year>=1960, robust

logit success_pow L.gini L.ginisq lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic L.polity L.politysq cold dec60 dec70  dec90  succpowyears _spline1sucpow _spline2sucpow _spline3sucpow if year>=1960, robust

logit failed_pow lcapshare lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic L.polity L.politysq cold dec60 dec70  dec90  succpowyears _spline1sucpow _spline2sucpow _spline3sucpow if year>=1960 , robust

logit failed_pow lshare1 lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic L.polity L.politysq cold dec60 dec70  dec90  succpowyears _spline1sucpow _spline2sucpow _spline3sucpow if year>=1960, robust

logit failed_pow L.gini lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic L.polity L.politysq cold dec60 dec70  dec90  succpowyears _spline1sucpow _spline2sucpow _spline3sucpow if year>=1960, robust


******************************************************************************

* Redoes Table 3 with Western countries.

**** Table A31: Effect of Inequality on Coup-Proofing (Includes Western Countries)

set more off

reg effective_number lcapshare lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic lpolity lpolitysq  cold  dec70  dec90 succpowyears if ldempol ==0, robust

reg effective_number lshare1 lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic lpolity lpolitysq  cold  dec70  dec90 succpowyears if ldempol ==0 , robust

reg effective_number L.gini lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic lpolity lpolitysq  cold  dec70  dec90 succpowyears if ldempol ==0, robust


******************************************************************************

* Redoes Table 4 with Western countries.

**** Table A32: Effect of Coup-Proofing on Civil War Onsets and Coups (Includes Western Countries)

set more off

logit civpitf L.effective_number lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic lpolity lpolitysq  cold  dec70  dec90 civpitfyears _spline1civpitf _spline2civpitf _spline3civpitf if year>=1960 & ldempol==0, robust

logit civprio L.effective_number  lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic lpolity lpolitysq  cold  dec70  dec90 peaceyearssmallprio _spline1smallprio _spline2smallprio _spline3smallprio if year>=1960 & ldempol==0, robust

logit success_pow L.effective_number lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic lpolity lpolitysq  cold  dec70  dec90 succpowyears _spline1sucpow _spline2sucpow _spline3sucpow if year>=1960 & ldempol==0, robust

logit failed_pow L.effective_number lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic lpolity lpolitysq  cold  dec70  dec90 succpowyears _spline1sucpow _spline2sucpow _spline3sucpow if year>=1960 & ldempol==0, robust

	
******************************************************************************

* Redoes Table 3 with democracies.

**** Table A33: Effect of Inequality on Coup-Proofing (Includes Democracies)

set more off

reg effective_number lcapshare lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic lpolity lpolitysq  cold  dec70  dec90 succpowyears if western==0, robust

reg effective_number lshare1 lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic lpolity lpolitysq  cold  dec70  dec90 succpowyears if western==0 , robust

reg effective_number L.gini lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic lpolity lpolitysq  cold  dec70  dec90 succpowyears  if western==0, robust
	
******************************************************************************

* Redoes Table 4 with democracies.

**** Table A34: Effect of Coup-Proofing on Civil War Onsets and Coups (Includes Democracies)

set more off

logit civpitf L.effective_number lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic lpolity lpolitysq  cold  dec70  dec90 civpitfyears _spline1civpitf _spline2civpitf _spline3civpitf if year>=1960 & western==0, robust

logit civprio L.effective_number  lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic lpolity lpolitysq  cold  dec70  dec90 peaceyearssmallprio _spline1smallprio _spline2smallprio _spline3smallprio if year>=1960 & western==0, robust

logit success_pow L.effective_number lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic lpolity lpolitysq  cold  dec70  dec90 succpowyears _spline1sucpow _spline2sucpow _spline3sucpow if year>=1960 & western==0, robust

logit failed_pow L.effective_number lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic lpolity lpolitysq  cold  dec70  dec90 succpowyears _spline1sucpow _spline2sucpow _spline3sucpow if year>=1960 & western==0, robust

	
******************************************************************************

* Boix (2008) argues that the effect of inequality on civil war is conditional on capital mobility. 
* This table redoes the main analysis presented in Table 1 of the main text, but conditioning for two measures of capital mobility: the agricultural share of GDP and financial openness.

**** Table A35: Effect of Inequality on Civil War Onsets --- Conditioning for Capital Mobility

set more off

** Agricultural

logit civpitf lcapshare lagrshare lcapshare_lagrshare lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic L.polity L.politysq cold dec60 dec70 dec90 civpitfyears _spline1civpitf _spline2civpitf _spline3civpitf if year>=1960 & western==0, robust
  
logit civpitf lshare1 lagrshare lshare1_lagrshare lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic L.polity L.politysq cold dec60 dec70 dec90 civpitfyears _spline1civpitf _spline2civpitf _spline3civpitf if year>=1960 & western==0, robust

logit civpitf L.gini lagrshare lgini_lagrshare lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic L.polity L.politysq cold dec60 dec70 dec90 civpitfyears _spline1civpitf _spline2civpitf _spline3civpitf if year>=1960 & western==0, robust


** Financial

logit civpitf lcapshare lcap lcapshare_lcap lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic L.polity L.politysq cold dec60 dec70 dec90 civpitfyears _spline1civpitf _spline2civpitf _spline3civpitf if year>=1960 & western==0, robust
 
logit civpitf lshare1 lcap lshare1_lcap lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic L.polity L.politysq cold dec60 dec70 dec90 civpitfyears _spline1civpitf _spline2civpitf _spline3civpitf if year>=1960 & western==0, robust

logit civpitf L.gini lcap lgini_lcap lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic L.polity L.politysq cold dec60 dec70 dec90 civpitfyears _spline1civpitf _spline2civpitf _spline3civpitf if year>=1960 & western==0, robust


******************************************************************************

* Boix (2003) argues that the effect of inequality on democratic breakdowns (which usually take the form of coups) is conditional on capital mobility. 
* This table redoes the main analysis presented in Table 2 of the main text, but conditioning for two measures of capital mobility: the agricultural share of GDP and financial openness.

**** Table A36: Effect of Inequality on Coups --- Conditioning for Capital Mobility

set more off

** Agricultural

logit success_pow lcapshare lagrshare lcapshare_lagrshare lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic L.polity L.politysq cold dec60 dec70 dec90 succpowyears _spline1sucpow _spline2sucpow _spline3sucpow if year>=1960 & western==0, robust

logit success_pow lshare1 lagrshare lshare1_lagrshare lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic L.polity L.politysq cold dec60 dec70 dec90 succpowyears _spline1sucpow _spline2sucpow _spline3sucpow if year>=1960 & western==0, robust

logit success_pow L.gini lagrshare lgini_lagrshare lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic L.polity L.politysq cold dec60 dec70 dec90 succpowyears _spline1sucpow _spline2sucpow _spline3sucpow if year>=1960 & western==0, robust

** Financial

logit success_pow lcapshare lcap lcapshare_lcap lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic L.polity L.politysq cold dec60 dec70 dec90 succpowyears _spline1sucpow _spline2sucpow _spline3sucpow if year>=1960 & western==0, robust

logit success_pow lshare1 lcap lshare1_lcap lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic L.polity L.politysq cold dec60 dec70 dec90 succpowyears _spline1sucpow _spline2sucpow _spline3sucpow if year>=1960 & western==0, robust

logit success_pow L.gini lcap lgini_lcap lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic L.polity L.politysq cold dec60 dec70 dec90 succpowyears _spline1sucpow _spline2sucpow _spline3sucpow if year>=1960 & western==0, robust

******************************************************************************

* Redoes Table 1 with only autocracies.

**** Table A37: Effect of Inequality on Civil War Onsets (Excludes Democracies)

set more off

logit civpitf lcapshare lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic L.polity L.politysq cold dec60 dec70 dec90 civpitfyears _spline1civpitf _spline2civpitf _spline3civpitf if year>=1960 & western==0 & ldempol==0, robust

logit civpitf lshare1 lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic L.polity L.politysq cold dec60 dec70  dec90 civpitfyears _spline1civpitf _spline2civpitf _spline3civpitf if year>=1960 & western==0 & ldempol==0, robust

logit civpitf L.gini lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic L.polity L.politysq cold dec60 dec70  dec90 civpitfyears _spline1civpitf _spline2civpitf _spline3civpitf if year>=1960 & western==0 & ldempol==0, robust

logit civprio lcapshare lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic L.polity L.politysq cold dec60 dec70 dec90 peaceyearssmallprio _spline1smallprio _spline2smallprio _spline3smallprio if year>=1960 & western==0 & ldempol==0, robust

logit civprio lshare1 lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic L.polity L.politysq cold dec60 dec70 dec90 peaceyearssmallprio _spline1smallprio _spline2smallprio _spline3smallprio if year>=1960 & western==0 & ldempol==0, robust

logit civprio L.gini lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic L.polity L.politysq cold dec60 dec70  dec90 peaceyearssmallprio _spline1smallprio _spline2smallprio _spline3smallprio if year>=1960 & western==0 & ldempol==0, robust


******************************************************************************

* Redoes Table 2 with only autocracies.

**** Table A38: Effect of Inequality on Coups (Excludes Democracies)

set more off

logit success_pow lcapshare lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic L.polity L.politysq cold dec60 dec70  dec90  succpowyears _spline1sucpow _spline2sucpow _spline3sucpow if year>=1960  & western==0 & ldempol==0, robust

logit success_pow lshare1 lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic L.polity L.politysq cold dec60 dec70  dec90  succpowyears _spline1sucpow _spline2sucpow _spline3sucpow if year>=1960 & western==0 & ldempol==0, robust

logit success_pow L.gini lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic L.polity L.politysq cold dec60 dec70  dec90  succpowyears _spline1sucpow _spline2sucpow _spline3sucpow if year>=1960 & western==0 & ldempol==0, robust

logit success_pow lcapshare lcapsharesq lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic L.polity L.politysq  cold dec60 dec70  dec90  succpowyears _spline1sucpow _spline2sucpow _spline3sucpow if year>=1960  & western==0 & ldempol==0, robust

logit success_pow lshare1 lshare1sq lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic L.polity L.politysq cold dec60 dec70  dec90  succpowyears _spline1sucpow _spline2sucpow _spline3sucpow if year>=1960 & western==0 & ldempol==0, robust

logit success_pow L.gini L.ginisq lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic L.polity L.politysq cold dec60 dec70  dec90  succpowyears _spline1sucpow _spline2sucpow _spline3sucpow if year>=1960 & western==0 & ldempol==0, robust

logit failed_pow lcapshare lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic L.polity L.politysq cold dec60 dec70  dec90  succpowyears _spline1sucpow _spline2sucpow _spline3sucpow if year>=1960  & western==0 & ldempol==0, robust

logit failed_pow lshare1 lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic L.polity L.politysq cold dec60 dec70  dec90  succpowyears _spline1sucpow _spline2sucpow _spline3sucpow if year>=1960 & western==0 & ldempol==0, robust

logit failed_pow L.gini lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic L.polity L.politysq cold dec60 dec70  dec90  succpowyears _spline1sucpow _spline2sucpow _spline3sucpow if year>=1960 & western==0 & ldempol==0, robust


******************************************************************************

* Redoes Table 1 with minimal controls.

**** Table A39: Effect of Inequality on Civil War Onsets (Minimal Control Variables)

set more off

logit civpitf lcapshare lgdptreis  if year>=1960 & western==0, robust

logit civpitf lshare1 lgdptreis  if year>=1960 & western==0, robust

logit civpitf L.gini lgdptreis  if year>=1960 & western==0, robust

logit civprio lcapshare lgdptreis  if year>=1960 & western==0, robust

logit civprio lshare1 lgdptreis  if year>=1960 & western==0, robust

logit civprio L.gini lgdptreis  if year>=1960 & western==0, robust


******************************************************************************

* Redoes Table 2 with minimal controls.

**** Table A40: Effect of Inequality on Coups (Minimal Control Variables)

set more off

logit success_pow lcapshare lgdptreis  if year>=1960 & western==0, robust

logit success_pow lshare1 lgdptreis  if year>=1960 & western==0, robust

logit success_pow L.gini lgdptreis  if year>=1960 & western==0, robust

logit success_pow lcapshare lcapsharesq lgdptreis  if year>=1960 & western==0, robust

logit success_pow lshare1 lshare1sq lgdptreis  if year>=1960 & western==0, robust

logit success_pow L.gini L.ginisq lgdptreis  if year>=1960 & western==0, robust

logit failed_pow lcapshare lgdptreis  if year>=1960 & western==0, robust

logit failed_pow lshare1 lgdptreis  if year>=1960 & western==0, robust

logit failed_pow L.gini lgdptreis  if year>=1960 & western==0, robust


******************************************************************************

* Redoes Table 3 with minimal controls.

**** Table A41: Effect of Inequality on Coup-Proofing (Minimal Control Variables)

set more off

reg effective_number lcapshare lgdptreis  if ldempol ==0 & western==0, robust

reg effective_number lshare1 lgdptreis  if ldempol ==0 & western==0, robust

reg effective_number L.gini lgdptreis  if ldempol ==0 & western==0, robust

	
******************************************************************************

* Redoes Table 4 with minimal controls.

**** Table A42: Effect of Coup-Proofing on Civil War Onsets and Coups (Minimal Control Variables)

set more off

logit civpitf L.effective_number lgdptreis   if year>=1960 & ldempol==0 & western==0, robust

logit civprio L.effective_number lgdptreis  if year>=1960 & ldempol==0 & western==0, robust

logit success_pow L.effective_number lgdptreis  if year>=1960 & ldempol==0 & western==0, robust

logit failed_pow L.effective_number lgdptreis  if year>=1960 & ldempol==0 & western==0, robust


******************************************************************************

* Redoes Table 1 with a control variable for military regimes (Banks 2014).

**** Table A43: Effect of Inequality on Civil War Onsets (Military Regimes)

set more off

logit civpitf lcapshare lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic lmilitary L.polity L.politysq cold dec60 dec70 dec90 civpitfyears _spline1civpitf _spline2civpitf _spline3civpitf if year>=1960 & western==0, robust

logit civpitf lshare1 lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic lmilitary L.polity L.politysq cold dec60 dec70 dec90 civpitfyears _spline1civpitf _spline2civpitf _spline3civpitf if year>=1960 & western==0, robust

logit civpitf L.gini lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic lmilitary L.polity L.politysq cold dec60 dec70 dec90 civpitfyears _spline1civpitf _spline2civpitf _spline3civpitf if year>=1960 & western==0, robust

logit civprio lcapshare lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic lmilitary L.polity L.politysq cold dec60 dec70 dec90 peaceyearssmallprio _spline1smallprio _spline2smallprio _spline3smallprio if year>=1960 & western==0, robust

logit civprio lshare1 lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic lmilitary L.polity L.politysq cold dec60 dec70 dec90 peaceyearssmallprio _spline1smallprio _spline2smallprio _spline3smallprio if year>=1960 & western==0, robust

logit civprio L.gini lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic lmilitary L.polity L.politysq cold dec60 dec70 dec90 peaceyearssmallprio _spline1smallprio _spline2smallprio _spline3smallprio if year>=1960 & western==0, robust

	
******************************************************************************

* Redoes Table 2 with a control variable for military regimes (Banks 2014).

**** Table A44: Effect of Inequality on Coups (Military Regimes)

set more off

logit success_pow lcapshare lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic lmilitary L.polity L.politysq cold dec60 dec70 dec90 succpowyears _spline1sucpow _spline2sucpow _spline3sucpow if year>=1960 & western==0, robust

logit success_pow lshare1 lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic lmilitary L.polity L.politysq cold dec60 dec70 dec90 succpowyears _spline1sucpow _spline2sucpow _spline3sucpow if year>=1960 & western==0, robust

logit success_pow L.gini lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic lmilitary L.polity L.politysq cold dec60 dec70 dec90 succpowyears _spline1sucpow _spline2sucpow _spline3sucpow if year>=1960 & western==0, robust

logit success_pow lcapshare lcapsharesq lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic lmilitary L.polity L.politysq cold dec60 dec70 dec90 succpowyears _spline1sucpow _spline2sucpow _spline3sucpow if year>=1960 & western==0, robust

logit success_pow lshare1 lshare1sq lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic lmilitary L.polity L.politysq cold dec60 dec70 dec90 succpowyears _spline1sucpow _spline2sucpow _spline3sucpow if year>=1960 & western==0, robust

logit success_pow L.gini L.ginisq lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic lmilitary L.polity L.politysq cold dec60 dec70 dec90 succpowyears _spline1sucpow _spline2sucpow _spline3sucpow if year>=1960 & western==0, robust

logit failed_pow lcapshare lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic lmilitary L.polity L.politysq cold dec60 dec70 dec90 succpowyears _spline1sucpow _spline2sucpow _spline3sucpow if year>=1960 & western==0, robust

logit failed_pow lshare1 lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic lmilitary L.polity L.politysq cold dec60 dec70 dec90 succpowyears _spline1sucpow _spline2sucpow _spline3sucpow if year>=1960 & western==0, robust

logit failed_pow L.gini lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic lmilitary L.polity L.politysq cold dec60 dec70 dec90 succpowyears _spline1sucpow _spline2sucpow _spline3sucpow if year>=1960 & western==0, robust

	
******************************************************************************

* Redoes Table 3 with a control variable for military regimes (Banks 2014).

**** Table A45: Effect of Inequality on Coup-Proofing (Military Regimes)

set more off

reg effective_number lcapshare lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic lmilitary L.polity L.politysq cold dec60 dec70 dec90 succpowyears if ldempol ==0 & western==0, robust

reg effective_number lshare1 lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic lmilitary L.polity L.politysq cold dec60 dec70 dec90 succpowyears if ldempol ==0 & western==0, robust

reg effective_number L.gini lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic lmilitary L.polity L.politysq cold dec60 dec70  dec90 succpowyears if ldempol ==0 & western==0, robust

	
******************************************************************************

* Redoes Table 4 with a control variable for military regimes (Banks 2014).

**** Table A46: Effect of Coup-Proofing on Civil War Onsets and Coups (Military Regimes)

set more off

logit civpitf L.effective_number lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic lmilitary L.polity L.politysq cold dec60 dec70  dec90 civpitfyears _spline1civpitf _spline2civpitf _spline3civpitf if year>=1960 & ldempol==0 & western==0, robust

logit civprio L.effective_number lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic lmilitary L.polity L.politysq cold dec60 dec70  dec90 peaceyearssmallprio _spline1smallprio _spline2smallprio _spline3smallprio if year>=1960 & ldempol==0 & western==0, robust

logit success_pow L.effective_number lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic lmilitary L.polity L.politysq cold dec60 dec70  dec90 succpowyears _spline1sucpow _spline2sucpow _spline3sucpow if year>=1960 & ldempol==0 & western==0, robust

logit failed_pow L.effective_number lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic lmilitary L.polity L.politysq cold dec60 dec70  dec90 succpowyears _spline1sucpow _spline2sucpow _spline3sucpow if year>=1960 & ldempol==0 & western==0, robust

	
******************************************************************************

* Tests effect of coup-proofing on diverse forms political instability (taken from Banks 2014).

**** Table A47: Effect of Coup-Proofing on Political Instability

set more off

* Strikes

nbreg strikes L.strikes L.effective_number lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lpopulation lethnic L.polity L.politysq cold dec60 dec70 dec90  if year>=1960  & western==0, robust

* Riots
	
nbreg riots L.riots L.effective_number lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 regch3 lopen lethnic lpopulation L.polity L.politysq cold dec60 dec70 dec90  if year>=1960  & western==0, robust

* Revolutions
	
nbreg revolutions L.revolutions L.effective_number lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 lpopulation regch3 lopen lethnic L.polity L.politysq cold dec60 dec70 dec90  if year>=1960  & western==0, robust

* Demonstrations
	
nbreg demonstrations L.demonstrations L.effective_number lgdptreis lonegrowthtreis L.lnoil_gas_valuePOP_2009 lpopulation regch3 lopen lethnic L.polity L.politysq cold dec60 dec70 dec90  if year>=1960  & western==0, robust





***************************************************************************
***************************************************************************
***************************************************************************
***************************************************************************

***************************************
**** RESULTS CITED IN THE ARTICLE *****
***************************************

* on page 16, I write: "Based on Figure I, increasing capital share from 25 (e.g., Macedonia) to 90 (e.g., Bolivia) raises the likelihood of a successful coup from 0.49 to 3.51 percent every year. 
* The same change in inequality only increases the likelihood of war from 0.80 to 1.48 percent."

* These results are calculated below. 

**** Probability of a coup in a country with a capital share of 25  

sort cowcode year

set scheme s1mono

set more off

logit success_pow lcapshare lgdptreis lonegrowthtreis llnoil_gas_valuePOP_2009 regch3 lopen lethnic lpolity lpolitysq cold dec60 dec70 dec90 succpowyears _spline1sucpow _spline2sucpow _spline3sucpow if year>=1960 & western==0, robust


gen SameSample1 = e(sample)
tab SameSample1


logit success_pow lcapshare lgdptreis lonegrowthtreis llnoil_gas_valuePOP_2009 regch3 lopen lethnic lpolity lpolitysq cold dec60 dec70 dec90 succpowyears _spline1sucpow _spline2sucpow _spline3sucpow if year>=1960 & western==0, robust

qui sum lgdptreis if e(SameSample1)
local m_lgdptreis = r(mean) 
qui sum lonegrowthtreis if e(SameSample1)
local m_lonegrowthtreis = r(mean)
qui sum llnoil_gas_valuePOP_2009 if e(SameSample1)
local m_llnoil_gas_valuePOP_2009 = r(mean)
qui sum regch3 if e(SameSample1)
local m_regch3 = r(mean)
qui sum lopen if e(SameSample1)
local m_lopen = r(mean)
qui sum lethnic if e(SameSample1)
local m_lethnic = r(mean)
qui sum lpolity if e(SameSample1)
local m_lpolity = r(mean)
qui sum lpolitysq if e(SameSample1)
local m_lpolitysq = r(mean)
qui sum dec60 if e(SameSample1)
local m_dec60 = r(mean)
qui sum dec70 if e(SameSample1)
local m_dec70 = r(mean)
qui sum dec90 if e(SameSample1)
local m_dec90 = r(mean)
qui sum succpowyears if e(SameSample1)
local m_succpowyears = r(mean) 
qui sum _spline1sucpow if e(SameSample1)
local m__spline1sucpow = r(mean)
qui sum _spline2sucpow if e(SameSample1)
local m__spline2sucpow = r(mean)
qui sum _spline3sucpow if e(SameSample1)
local m__spline3sucpow = r(mean)


local xb1 _b[lcapshare]*25 + _b[lgdptreis]*`m_lgdptreis' + _b[lonegrowthtreis]*`m_lonegrowthtreis' + _b[llnoil_gas_valuePOP_2009]*`m_llnoil_gas_valuePOP_2009' +_b[regch3]*`m_regch3' + _b[lopen]*`m_lopen' ///
+ _b[lethnic]*`m_lethnic'+ _b[lpolity]*`m_lpolity' +  _b[lpolitysq]*`m_lpolitysq'+ _b[cold]*1 +  _b[dec60]*1 + _b[dec70]*0 + _b[dec90]*0 + _b[succpowyears]*`m_succpowyears' /// 
	+ _b[_spline1sucpow]*`m__spline1sucpow' + _b[_spline2sucpow]*`m__spline2sucpow' + _b[_spline3sucpow]*`m__spline3sucpow' + _b[_cons]

predictnl prsuccess = exp(`xb1')/(1+exp(`xb1')), se(se1)

sum prsuccess

drop prsuccess SameSample1 se1




**** Probability of a coup in a country with a capital share of 90  

sort cowcode year

set scheme s1mono

set more off

logit success_pow lcapshare lgdptreis lonegrowthtreis llnoil_gas_valuePOP_2009 regch3 lopen lethnic lpolity lpolitysq cold dec60 dec70 dec90 succpowyears _spline1sucpow _spline2sucpow _spline3sucpow if year>=1960 & western==0, robust


gen SameSample1 = e(sample)
tab SameSample1


logit success_pow lcapshare lgdptreis lonegrowthtreis llnoil_gas_valuePOP_2009 regch3 lopen lethnic lpolity lpolitysq cold dec60 dec70 dec90 succpowyears _spline1sucpow _spline2sucpow _spline3sucpow if year>=1960 & western==0, robust

qui sum lgdptreis if e(SameSample1)
local m_lgdptreis = r(mean) 
qui sum lonegrowthtreis if e(SameSample1)
local m_lonegrowthtreis = r(mean)
qui sum llnoil_gas_valuePOP_2009 if e(SameSample1)
local m_llnoil_gas_valuePOP_2009 = r(mean)
qui sum regch3 if e(SameSample1)
local m_regch3 = r(mean)
qui sum lopen if e(SameSample1)
local m_lopen = r(mean)
qui sum lethnic if e(SameSample1)
local m_lethnic = r(mean)
qui sum lpolity if e(SameSample1)
local m_lpolity = r(mean)
qui sum lpolitysq if e(SameSample1)
local m_lpolitysq = r(mean)
qui sum dec60 if e(SameSample1)
local m_dec60 = r(mean)
qui sum dec70 if e(SameSample1)
local m_dec70 = r(mean)
qui sum dec90 if e(SameSample1)
local m_dec90 = r(mean)
qui sum succpowyears if e(SameSample1)
local m_succpowyears = r(mean) 
qui sum _spline1sucpow if e(SameSample1)
local m__spline1sucpow = r(mean)
qui sum _spline2sucpow if e(SameSample1)
local m__spline2sucpow = r(mean)
qui sum _spline3sucpow if e(SameSample1)
local m__spline3sucpow = r(mean)


local xb1 _b[lcapshare]*90 + _b[lgdptreis]*`m_lgdptreis' + _b[lonegrowthtreis]*`m_lonegrowthtreis' + _b[llnoil_gas_valuePOP_2009]*`m_llnoil_gas_valuePOP_2009' +_b[regch3]*`m_regch3' + _b[lopen]*`m_lopen' ///
+ _b[lethnic]*`m_lethnic'+ _b[lpolity]*`m_lpolity' +  _b[lpolitysq]*`m_lpolitysq'+ _b[cold]*1 +  _b[dec60]*1 + _b[dec70]*0 + _b[dec90]*0 + _b[succpowyears]*`m_succpowyears' /// 
	+ _b[_spline1sucpow]*`m__spline1sucpow' + _b[_spline2sucpow]*`m__spline2sucpow' + _b[_spline3sucpow]*`m__spline3sucpow' + _b[_cons]

predictnl prsuccess = exp(`xb1')/(1+exp(`xb1')), se(se1)

sum prsuccess

drop prsuccess SameSample1 se1



**** Probability of a civil war in a country with a capital share of 25  

sort cowcode year

set scheme s1mono

set more off

logit civpitf lcapshare lgdptreis lonegrowthtreis llnoil_gas_valuePOP_2009 regch3 mountains lpopulation  lopen lethnic lpolity lpolitysq cold dec60 dec70 dec90 civpitfyears _spline1civpitf _spline2civpitf _spline3civpitf if year>=1960 & western==0, robust

gen SameSample2 = e(sample)
tab SameSample2

logit civpitf lcapshare lgdptreis lonegrowthtreis llnoil_gas_valuePOP_2009 regch3 mountains lpopulation  lopen lethnic lpolity lpolitysq cold dec60 dec70 dec90 civpitfyears _spline1civpitf _spline2civpitf _spline3civpitf if year>=1960 & western==0, robust


qui sum lgdptreis if e(SameSample2)
local m_lgdptreis = r(mean) 
qui sum lonegrowthtreis if e(SameSample2)
local m_lonegrowthtreis = r(mean)
qui sum llnoil_gas_valuePOP_2009 if e(SameSample2)
local m_llnoil_gas_valuePOP_2009 = r(mean)
qui sum mountains if e(SameSample2)
local m_mountains = r(mean)
qui sum regch3 if e(SameSample2)
local m_regch3 = r(mean)
qui sum lpopulation if e(SameSample2)
local m_lpopulation = r(mean)
qui sum lopen if e(SameSample2)
local m_lopen = r(mean)
qui sum lethnic if e(SameSample2)
local m_lethnic = r(mean)
qui sum lpolity if e(SameSample2)
local m_lpolity = r(mean)
qui sum lpolitysq if e(SameSample2)
local m_lpolitysq = r(mean)
qui sum cold if e(SameSample2)
local m_cold = r(mean)
qui sum dec60 if e(SameSample2)
local m_dec60 = r(mean)
qui sum dec70 if e(SameSample2)
local m_dec70 = r(mean)
qui sum dec90 if e(SameSample2)
local m_dec90 = r(mean)
qui sum civpitfyears if e(SameSample2)
local m_civpitfyears = r(mean) 
qui sum _spline1civpitf if e(SameSample2)
local m__spline1civpitf = r(mean)
qui sum _spline2civpitf if e(SameSample2)
local m__spline2civpitf = r(mean)
qui sum _spline3civpitf if e(SameSample2)
local m__spline3civpitf = r(mean)


local xb1 _b[lcapshare]*25 + _b[lgdptreis]*`m_lgdptreis' + _b[lonegrowthtreis]*`m_lonegrowthtreis' + _b[llnoil_gas_valuePOP_2009]*`m_llnoil_gas_valuePOP_2009' +_b[regch3]*`m_regch3' +_b[mountains]*`m_mountains'  ///
+ _b[lpopulation]*`m_lpopulation' + _b[lopen]*`m_lopen' + _b[lethnic]*`m_lethnic'+ _b[lpolity]*`m_lpolity' +  _b[lpolitysq]*`m_lpolitysq'+ _b[cold]*1 + _b[dec60]*1 + _b[dec70]*0+ _b[dec90]*0 ///
+ _b[civpitfyears]*`m_civpitfyears' + _b[_spline1civpitf]*`m__spline1civpitf' + _b[_spline2civpitf]*`m__spline2civpitf' + _b[_spline3civpitf]*`m__spline3civpitf' + _b[_cons]
	
predictnl prrevpitf = exp(`xb1')/(1+exp(`xb1')), se(se2)

sum prrevpitf

drop prrevpitf SameSample2 se2




**** Probability of a civil war in a country with a capital share of 90  

sort cowcode year

set scheme s1mono

set more off

logit civpitf lcapshare lgdptreis lonegrowthtreis llnoil_gas_valuePOP_2009 regch3 mountains lpopulation  lopen lethnic lpolity lpolitysq cold dec60 dec70 dec90 civpitfyears _spline1civpitf _spline2civpitf _spline3civpitf if year>=1960 & western==0, robust

gen SameSample2 = e(sample)
tab SameSample2

logit civpitf lcapshare lgdptreis lonegrowthtreis llnoil_gas_valuePOP_2009 regch3 mountains lpopulation  lopen lethnic lpolity lpolitysq cold dec60 dec70 dec90 civpitfyears _spline1civpitf _spline2civpitf _spline3civpitf if year>=1960 & western==0, robust


qui sum lgdptreis if e(SameSample2)
local m_lgdptreis = r(mean) 
qui sum lonegrowthtreis if e(SameSample2)
local m_lonegrowthtreis = r(mean)
qui sum llnoil_gas_valuePOP_2009 if e(SameSample2)
local m_llnoil_gas_valuePOP_2009 = r(mean)
qui sum mountains if e(SameSample2)
local m_mountains = r(mean)
qui sum regch3 if e(SameSample2)
local m_regch3 = r(mean)
qui sum lpopulation if e(SameSample2)
local m_lpopulation = r(mean)
qui sum lopen if e(SameSample2)
local m_lopen = r(mean)
qui sum lethnic if e(SameSample2)
local m_lethnic = r(mean)
qui sum lpolity if e(SameSample2)
local m_lpolity = r(mean)
qui sum lpolitysq if e(SameSample2)
local m_lpolitysq = r(mean)
qui sum cold if e(SameSample2)
local m_cold = r(mean)
qui sum dec60 if e(SameSample2)
local m_dec60 = r(mean)
qui sum dec70 if e(SameSample2)
local m_dec70 = r(mean)
qui sum dec90 if e(SameSample2)
local m_dec90 = r(mean)
qui sum civpitfyears if e(SameSample2)
local m_civpitfyears = r(mean) 
qui sum _spline1civpitf if e(SameSample2)
local m__spline1civpitf = r(mean)
qui sum _spline2civpitf if e(SameSample2)
local m__spline2civpitf = r(mean)
qui sum _spline3civpitf if e(SameSample2)
local m__spline3civpitf = r(mean)


local xb1 _b[lcapshare]*90 + _b[lgdptreis]*`m_lgdptreis' + _b[lonegrowthtreis]*`m_lonegrowthtreis' + _b[llnoil_gas_valuePOP_2009]*`m_llnoil_gas_valuePOP_2009' +_b[regch3]*`m_regch3' +_b[mountains]*`m_mountains'  ///
+ _b[lpopulation]*`m_lpopulation' + _b[lopen]*`m_lopen' + _b[lethnic]*`m_lethnic'+ _b[lpolity]*`m_lpolity' +  _b[lpolitysq]*`m_lpolitysq'+ _b[cold]*1 + _b[dec60]*1 + _b[dec70]*0+ _b[dec90]*0 ///
+ _b[civpitfyears]*`m_civpitfyears' + _b[_spline1civpitf]*`m__spline1civpitf' + _b[_spline2civpitf]*`m__spline2civpitf' + _b[_spline3civpitf]*`m__spline3civpitf' + _b[_cons]
	
predictnl prrevpitf = exp(`xb1')/(1+exp(`xb1')), se(se2)

sum prrevpitf

drop prrevpitf SameSample2 se2


***************************************************************************

* on page 17, I write: "With the PRIO indicator, the predicted probability of a war is 1.91 percent per year in a country with a unified military but 7.18 percent in one in which the military is divided into four branches."

* These results are calculated below. 


**** Unified military

sort cowcode year

set scheme s1mono

set more off

logit civprio leffective_number  lgdptreis lonegrowthtreis llnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic lpolity lpolitysq  cold  dec70  dec90 peaceyearssmallprio _spline1smallprio _spline2smallprio _spline3smallprio if year>=1960 & ldempol==0 & western==0, robust

gen SameSample2 = e(sample)
tab SameSample2

logit civprio leffective_number  lgdptreis lonegrowthtreis llnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic lpolity lpolitysq  cold  dec70  dec90 peaceyearssmallprio _spline1smallprio _spline2smallprio _spline3smallprio if year>=1960 & ldempol==0 & western==0, robust


qui sum lgdptreis if e(SameSample2)
local m_lgdptreis = r(mean) 
qui sum lonegrowthtreis if e(SameSample2)
local m_lonegrowthtreis = r(mean)
qui sum llnoil_gas_valuePOP_2009 if e(SameSample2)
local m_llnoil_gas_valuePOP_2009 = r(mean)
qui sum mountains if e(SameSample2)
local m_mountains = r(mean)
qui sum regch3 if e(SameSample2)
local m_regch3 = r(mean)
qui sum lpopulation if e(SameSample2)
local m_lpopulation = r(mean)
qui sum lopen if e(SameSample2)
local m_lopen = r(mean)
qui sum lethnic if e(SameSample2)
local m_lethnic = r(mean)
qui sum lpolity if e(SameSample2)
local m_lpolity = r(mean)
qui sum lpolitysq if e(SameSample2)
local m_lpolitysq = r(mean)
qui sum cold if e(SameSample2)
local m_cold = r(mean)
qui sum dec60 if e(SameSample2)
local m_dec60 = r(mean)
qui sum dec70 if e(SameSample2)
local m_dec70 = r(mean)
qui sum dec90 if e(SameSample2)
local m_dec90 = r(mean)
qui sum peaceyearssmallprio if e(SameSample2)
local m_peaceyearssmallprio = r(mean) 
qui sum _spline1smallprio if e(SameSample2)
local m__spline1smallprio = r(mean)
qui sum _spline2smallprio if e(SameSample2)
local m__spline2smallprio = r(mean)
qui sum _spline3smallprio if e(SameSample2)
local m__spline3smallprio = r(mean)


local xb1 _b[leffective_number]*1 + _b[lgdptreis]*`m_lgdptreis' + _b[lonegrowthtreis]*`m_lonegrowthtreis' + _b[llnoil_gas_valuePOP_2009]*`m_llnoil_gas_valuePOP_2009' +_b[regch3]*`m_regch3' +_b[mountains]*`m_mountains'  ///
+ _b[lpopulation]*`m_lpopulation' + _b[lopen]*`m_lopen' + _b[lethnic]*`m_lethnic'+ _b[lpolity]*`m_lpolity' +  _b[lpolitysq]*`m_lpolitysq'+ _b[cold]*1 +  _b[dec70]*0+ _b[dec90]*0 ///
+ _b[peaceyearssmallprio]*`m_peaceyearssmallprio' + _b[_spline1smallprio]*`m__spline1smallprio' + _b[_spline2smallprio]*`m__spline2smallprio' + _b[_spline3smallprio]*`m__spline3smallprio' + _b[_cons]
	
predictnl prrevpitf = exp(`xb1')/(1+exp(`xb1')), se(se2)

sum prrevpitf

drop prrevpitf SameSample2 se2




**** Military divided in 4 branches

sort cowcode year

set scheme s1mono

set more off

logit civprio leffective_number  lgdptreis lonegrowthtreis llnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic lpolity lpolitysq  cold  dec70  dec90 peaceyearssmallprio _spline1smallprio _spline2smallprio _spline3smallprio if year>=1960 & ldempol==0 & western==0, robust

gen SameSample2 = e(sample)
tab SameSample2

logit civprio leffective_number  lgdptreis lonegrowthtreis llnoil_gas_valuePOP_2009 regch3 mountains lpopulation lopen lethnic lpolity lpolitysq  cold  dec70  dec90 peaceyearssmallprio _spline1smallprio _spline2smallprio _spline3smallprio if year>=1960 & ldempol==0 & western==0, robust


qui sum lgdptreis if e(SameSample2)
local m_lgdptreis = r(mean) 
qui sum lonegrowthtreis if e(SameSample2)
local m_lonegrowthtreis = r(mean)
qui sum llnoil_gas_valuePOP_2009 if e(SameSample2)
local m_llnoil_gas_valuePOP_2009 = r(mean)
qui sum mountains if e(SameSample2)
local m_mountains = r(mean)
qui sum regch3 if e(SameSample2)
local m_regch3 = r(mean)
qui sum lpopulation if e(SameSample2)
local m_lpopulation = r(mean)
qui sum lopen if e(SameSample2)
local m_lopen = r(mean)
qui sum lethnic if e(SameSample2)
local m_lethnic = r(mean)
qui sum lpolity if e(SameSample2)
local m_lpolity = r(mean)
qui sum lpolitysq if e(SameSample2)
local m_lpolitysq = r(mean)
qui sum cold if e(SameSample2)
local m_cold = r(mean)
qui sum dec60 if e(SameSample2)
local m_dec60 = r(mean)
qui sum dec70 if e(SameSample2)
local m_dec70 = r(mean)
qui sum dec90 if e(SameSample2)
local m_dec90 = r(mean)
qui sum peaceyearssmallprio if e(SameSample2)
local m_peaceyearssmallprio = r(mean) 
qui sum _spline1smallprio if e(SameSample2)
local m__spline1smallprio = r(mean)
qui sum _spline2smallprio if e(SameSample2)
local m__spline2smallprio = r(mean)
qui sum _spline3smallprio if e(SameSample2)
local m__spline3smallprio = r(mean)


local xb1 _b[leffective_number]*4 + _b[lgdptreis]*`m_lgdptreis' + _b[lonegrowthtreis]*`m_lonegrowthtreis' + _b[llnoil_gas_valuePOP_2009]*`m_llnoil_gas_valuePOP_2009' +_b[regch3]*`m_regch3' +_b[mountains]*`m_mountains'  ///
+ _b[lpopulation]*`m_lpopulation' + _b[lopen]*`m_lopen' + _b[lethnic]*`m_lethnic'+ _b[lpolity]*`m_lpolity' +  _b[lpolitysq]*`m_lpolitysq'+ _b[cold]*1 +  _b[dec70]*0+ _b[dec90]*0 ///
+ _b[peaceyearssmallprio]*`m_peaceyearssmallprio' + _b[_spline1smallprio]*`m__spline1smallprio' + _b[_spline2smallprio]*`m__spline2smallprio' + _b[_spline3smallprio]*`m__spline3smallprio' + _b[_cons]
	
predictnl prrevpitf = exp(`xb1')/(1+exp(`xb1')), se(se2)

sum prrevpitf

drop prrevpitf SameSample2 se2

