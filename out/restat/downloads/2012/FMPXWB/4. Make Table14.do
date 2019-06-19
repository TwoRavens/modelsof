clear *
set mem 200m
set more off
set matsize 800

*********************************************************
* MERGE IN SOME HH-LEVEL DATA
use khds_ind.dta, clear
ren hh hh1
keep if wave<=4
sort cluster hh1 wave pid // NEW CODE WHICH MATTERS!!
bys cluster hh1: keep if _n==1
keep  cluster hh1 head_sex head_age head_ed hieduc goodflr hownhom landcul  ///
	phystock busnvalu durbvalu eqipvalu fbldvalu landvalu lvstvalu odwlvalu udwlvalu ///
	m0_5k m6_15k m16_60k m61k f0_5k f6_15k f16_60k f61k
des
sum
isid cluster hh1, sort
tempfile hh
save `hh'

use growth_data.dta, clear
sort cluster hh1 wave pid 
keep cluster hh1 remote1 mainjob1 farm1 skilled1 
bys cluster hh1: keep if _n==1
isid cluster hh1, sort
merge cluster hh1 using `hh'
tab _m
drop _m
isid cluster hh1, sort
save `hh', replace

use growth_data2.dta,clear
assert cluster~=. & hh1~=.
sort cluster hh1
merge cluster hh1 using `hh'
drop if _m==2
assert _m==3
drop _m
sum
count
des

* DEFINE SOME EXTRA VARS
ren conspc1 conspc
replace conspc   = conspc/1000000
replace landvalu = landvalu/1000000

gen NotFarmHH 	= farm1==2 if farm1~=.
gen FarmHH 		= farm1==1 if farm1~=.
gen SkillHH 	= skilled1==3
gen RemoteCluster = (remote==5) if remote1~=.
gen consXkmbk  	= conspc*kmbukoba
gen consXRemote 	= conspc*RemoteCluster
gen floorXkmbk	= goodflr*kmbukoba
gen floorXRemote 	= goodflr*RemoteCluster
gen landXkmbk 	= landvalu*kmbukoba
gen landXRemote  	= landvalu*RemoteCluster
gen physXkmbk 	= phystock*kmbukoba
gen physXRemote  	= phystock*RemoteCluster
bys cluster: egen clmean_conspc = mean(conspc)
bys cluster: egen clmean_hieduc = mean(hieduc)
bys cluster: egen clmean_FarmHH = mean(FarmHH)

* LABELS
label var hhsize1		"household size"
label var FarmHH		"primary occup is farming"
label var conspc		"consumption pc (in 1m TZS)"
label var landvalu	"value of land (in 1m TZS)"
label var RemoteCluster "remote cmty"
label var clmean_conspc 	"cmty avg: cons pc"
label var clmean_hieduc 	"cmty avg: yrs higest educ in hh"
label var clmean_FarmHH  	"cmty avg: primary occup is farming"
label var consXkmbk 		"cons pc * km to bukoba"
label var consXRemote	 	"cons pc * Remote cmty"
label var floorXkmbk  		"goodflr * km to bukoba"
label var floorXRemote	 	"goodflr * Remote cmty"
label var landXkmbk 		"landvalu * km to bukoba"
label var landXRemote	 	"landvalu* Remote cmty"
label var physXkmbk 		"physical assets * km to bukoba"
label var physXRemote	 	"physical assets * Remote cmty"
label var disdis			"distance to nearest dist cap"

*******************************************************
replace phystock=phystock/10000000

bys cluster: egen clmean_goodflr=mean(goodflr)
bys cluster: egen clmean_phystock=mean(phystock)
bys cluster: egen clmean_landcul=mean(landcul)
bys cluster: egen clmean_hhsize1=mean(hhsize1)
bys cluster: egen clmean_head_sex=mean(head_sex)
bys cluster: egen clmean_head_age=mean(head_age)
bys cluster: egen clmean_head_ed=mean(head_ed)

* INSTRUMENTS AND CONTROLS
global LHS 		dlnconspc
global OLDCONTROLS schooldmed schooldmedsq sex unmar sexXunmar bothdied bothdied15 mgrade1 fgrade1 /*
 */ clh?0_51 clh?6_101 clh?11_151 clh?16_201 clh?21p1 cle1 cle1Xkm age0 age1 age2 age3 age4 age5 age6
global INST       rh_rel12     rh_rel3     sexXrh_rel3     r_agerankXage0     age0XmaleXkm    dr9103Xage0
global HHCONTROLS head_sex head_age head_ed  hhsize1 FarmHH landcul conspc  phystock goodflr 
global CLCONTROLS   kmbukoba RemoteCluster clmean_head_sex clmean_head_age clmean_head_ed   clmean_hhsize1 clmean_FarmHH clmean_landcul clmean_conspc clmean_phystock clmean_goodflr 

xi: dprobit moved1 $OLDCONTROLS $INST $HHCONTROLS $CLCONTROLS 
estimates store col1, title(Probit: moved out of community)

xi: reg lndismoved $OLDCONTROLS $INST $HHCONTROLS $CLCONTROLS 
estimates store col2, title(OLS: Ln(Km moved))

xml_tab col1(dfdx se_dfdx) col2  , save(growth_regression_T14.xml) stats(N) title(Explaining Consumption Change incl household and cmty correlates) /*
	*/ sd2 replace sheet(T14)

* COMMENT ON 1 SD INCREASE
sum conspc  if e(sample)
scalar hhcons = r(sd)
	sum phystock  if e(sample)
	scalar hhphys = r(sd)
sum goodflr  if e(sample)
scalar hhfloor = r(sd)
	sum clmean_conspc  if e(sample)
	scalar clcons = r(sd)
sum clmean_phystock  if e(sample)
scalar clphys = r(sd)
	sum clmean_goodflr  if e(sample)
	scalar clfloor = r(sd)

* FOR DPROBIT (MOVED) REGRESSIONS: -2 PCT POINTS AT CMTY ONLY AND -1 PCT POINTS AT CMTY & HH
xi: dprobit moved1 $OLDCONTROLS $INST $HHCONTROLS $CLCONTROLS 
di 1.20880*clcons - 0.19777*clphys - 0.18082*clfloor
di 1.20880*clcons - 0.19777*clphys - 0.18082*clfloor ///
 - 0.13482*hhcons + 0.02394*hhphys + 0.02193*hhfloor

* FOR DPROBIT (MOVED) REGRESSIONS: -6% AT CMTY ONLY AND -3% AT CMTY & HH
tab moved1
di (1.20880*clcons - 0.19777*clphys - 0.18082*clfloor)/0.3347
di (1.20880*clcons - 0.19777*clphys - 0.18082*clfloor ///
  - 0.13482*hhcons + 0.02394*hhphys + 0.02193*hhfloor)/0.3347

* FOR OLS (LNKM) REGRESSIONS -3% FOR CMTY ONLY AND -2% POINTS CMTY & HH
xi: reg lndismoved $OLDCONTROLS $INST $HHCONTROLS $CLCONTROLS 
di _b[clmean_conspc]*clcons + _b[clmean_phystock]*clphys + _b[clmean_goodflr]*clfloor
di _b[clmean_conspc]*clcons + _b[clmean_phystock]*clphys + _b[clmean_goodflr]*clfloor ///
 + _b[conspc]*hhcons        + _b[phystock]*hhphys        + _b[goodflr]*hhfloor

