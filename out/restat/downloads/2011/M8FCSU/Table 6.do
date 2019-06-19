*************************************Table 6
use 1930.dta, clear
/*purge state dummies to run xols
xols can be obtained from Tim Conley at Chicago Booth
*/

local allvars "led_sp_pcy ltaxc_pcy lttlpy county_area giniy vforpdy_share vfruy_share vcery_share vgarvegy_share vvegy_share vothcery_share vfmagr_pfy ubp_sharey pop_densy nwp_sharey shypy ngp_sharey ltotrain_anstd lgrowdegdys_anstd stdev_elev mean_elev totrain_anave stdev_elev_NS ltotrain_anstd_NS lgrowdegdys_anstd_NS NS giniy_NS stdev_elev_sq giniy_1890 ltotrain_anstd_ubp giniy_ubp nom_pcy ltotrain_anstd_nom giniy_nom"
local spavarlist = ""
foreach X of local allvars {

	di "X spa: `X'_spa"

      capture qui reg `X' state_dum* region_dum*
      capture predict `X'_spa if e(sample), resid
}
drop if fips==6019 | fips==6107 | fips==6039 | fips==6109 | fips==6095 | fips==16067 | fips==41025 | fips==53053

*col2 
reg giniy stdev_elev ltotrain_anstd lgrowdegdys_anstd lttlpy county_area state_dum* region_dum*  if year==1930, r
qui test stdev_elev ltotrain_anstd lgrowdegdys_anstd
outreg  stdev_elev ltotrain_anstd lgrowdegdys_anstd using first_1930 , replace nolabel nocons se coefastr 3aster bracket addstat(F Test: Weather Risk Variables=0, r(F), p-value, r(p)) adec(2,3)
x_ols  longitude_km latitude_km  longitude_km_cutoff latitude_km_cutoff  giniy_spa stdev_elev_spa ltotrain_anstd_spa lgrowdegdys_anstd_spa lttlpy_spa county_area_spa const, coord(2) xreg(6)
drop epsilon window dis1 dis2

*col3
qui qreg giniy stdev_elev ltotrain_anstd lgrowdegdys_anstd lttlpy vfmagr_pfy ubp_sh  pop_densy nwp_sharey ngp_sharey shypy county_area state_dum*  if year==1930
qui test stdev_elev ltotrain_anstd lgrowdegdys_anstd
outreg  stdev_elev ltotrain_anstd lgrowdegdys_anstd using first_1930 , append nolabel nocons se coefastr 3aster bracket addstat(F Test: Weather Risk Variables=0, r(F), p-value, r(p)) adec(2,3)

*col4
reg giniy stdev_elev ltotrain_anstd lgrowdegdys_anstd lttlpy vfmagr_pfy ubp_sharey  pop_densy nwp_sharey ngp_sharey shypy county_area state_dum*  if year==1930, r
qui test stdev_elev ltotrain_anstd lgrowdegdys_anstd
outreg  stdev_elev ltotrain_anstd lgrowdegdys_anstd using first_1930 , append nolabel nocons se coefastr 3aster bracket addstat(F Test: Weather Risk Variables=0, r(F), p-value, r(p)) adec(2,3)
x_ols  longitude_km latitude_km  longitude_km_cutoff latitude_km_cutoff  giniy_spa stdev_elev_spa ltotrain_anstd_spa lgrowdegdys_anstd_spa vfmagr_pfy_spa ubp_sharey_spa  pop_densy_spa nwp_sharey_spa ngp_sharey_spa shypy_spa lttlpy_spa county_area_spa const, coord(2) xreg(12)
drop epsilon window dis1 dis2

*col5
reg giniy stdev_elev ltotrain_anstd lgrowdegdys_anstd stdev_elev_NS ltotrain_anstd_NS lgrowdegdys_anstd_NS NS lttlpy vfmagr_pfy ubp_sh  pop_densy nwp_sharey ngp_sharey shypy county_area state_dum* region_dum*  if year==1930, r
test stdev_elev ltotrain_anstd lgrowdegdys_anstd
test stdev_elev ltotrain_anstd lgrowdegdys_anstd stdev_elev_NS ltotrain_anstd_NS lgrowdegdys_anstd_NS
outreg  stdev_elev ltotrain_anstd lgrowdegdys_anstd stdev_elev_NS ltotrain_anstd_NS lgrowdegdys_anstd_NS using first_1930 , append nolabel nocons se coefastr 3aster bracket 
x_ols  longitude_km latitude_km  longitude_km_cutoff latitude_km_cutoff  giniy_spa stdev_elev_spa ltotrain_anstd_spa lgrowdegdys_anstd_spa stdev_elev_NS_spa ltotrain_anstd_NS_spa lgrowdegdys_anstd_NS_spa vfmagr_pfy_spa ubp_sharey_spa  pop_densy_spa nwp_sharey_spa ngp_sharey_spa shypy_spa lttlpy_spa county_area_spa const, coord(2) xreg(15)
drop epsilon window dis1 dis2









**create the tennancy interaction term
sort sc_no year
by sc_no: g giniy_nofmte=giniy*nofmte_shy
by sc_no: g ltotrain_anstd_nofmte=ltotrain_anstd*nofmte_shy
**create the share of agriculture in the economy
sort sc_no year
by sc_no: g agr_shy=vfmcropy/(vfmcropy+vmanpdy)
by sc_no: g giniy_agr_shy=giniy*agr_shy
by sc_no: g ltotrain_anstd_agr_shy=ltotrain_anstd*agr_shy
by sc_no: g agr_shy_sq=agr_shy^2
****the program below de trends the state and region dummies from each variable: in order to run x_ols and x_gmm

**call the variables
local allvars "led_sp_pcy ltaxc_pcy lttlpy county_area giniy vforpdy_share vfruy_share vcery_share vgarvegy_share vvegy_share vothcery_share vfmagr_pfy ubp_sharey pop_densy nwp_sharey shypy ngp_sharey ltotrain_anstd lgrowdegdys_anstd stdev_elev mean_elev totrain_anave stdev_elev_NS ltotrain_anstd_NS lgrowdegdys_anstd_NS NS giniy_NS stdev_elev_sq giniy_1890 ltotrain_anstd_ubp giniy_ubp nom_pcy ltotrain_anstd_nom giniy_nom"

local spavarlist = ""
foreach X of local allvars {

	di "X spa: `X'_spa"

      capture qui reg `X' state_dum* region_dum*
      capture predict `X'_spa if e(sample), resid
 }
	

***
***potential outliers (see redistribution ver 3 for determination of outliers******
drop if fips==6019 | fips==6107 | fips==6039 | fips==6109 | fips==6095 | fips==16067 | fips==41025 | fips==53053

/***first stage
qui reg giniy stdev_elev ltotrain_anstd lgrowdegdys_anstd lttlpy county_area state_dum* region_dum*  if year==1930, r
qui test stdev_elev ltotrain_anstd lgrowdegdys_anstd
outreg  stdev_elev ltotrain_anstd lgrowdegdys_anstd using first_1930 , replace nolabel nocons se coefastr 3aster bracket addstat(F Test: Weather Risk Variables=0, r(F), p-value, r(p)) adec(2,3)
x_ols  longitude_km latitude_km  longitude_km_cutoff latitude_km_cutoff  giniy_spa stdev_elev_spa ltotrain_anstd_spa lgrowdegdys_anstd_spa lttlpy_spa county_area_spa const, coord(2) xreg(6)
drop epsilon window dis1 dis2

 reg giniy stdev_elev ltotrain_anstd lgrowdegdys_anstd lttlpy vfmagr_pfy ubp_sharey  pop_densy nwp_sharey ngp_sharey shypy county_area state_dum* region_dum*  if year==1930, r
 pcorr2 giniy stdev_elev ltotrain_anstd lgrowdegdys_anstd lttlpy vfmagr_pfy ubp_sharey  pop_densy nwp_sharey ngp_sharey shypy county_area state_dum* region_dum*  if year==1930
qui test stdev_elev ltotrain_anstd lgrowdegdys_anstd
outreg  stdev_elev ltotrain_anstd lgrowdegdys_anstd using first_1930 , append nolabel nocons se coefastr 3aster bracket addstat(F Test: Weather Risk Variables=0, r(F), p-value, r(p)) adec(2,3)
x_ols  longitude_km latitude_km  longitude_km_cutoff latitude_km_cutoff  giniy_spa stdev_elev_spa ltotrain_anstd_spa lgrowdegdys_anstd_spa vfmagr_pfy_spa ubp_sharey_spa  pop_densy_spa nwp_sharey_spa ngp_sharey_spa shypy_spa lttlpy_spa county_area_spa const, coord(2) xreg(12)
drop epsilon window dis1 dis2

qui qreg giniy stdev_elev ltotrain_anstd lgrowdegdys_anstd lttlpy vfmagr_pfy ubp_sh  pop_densy nwp_sharey ngp_sharey shypy county_area state_dum* region_dum*  if year==1930
qui test stdev_elev ltotrain_anstd lgrowdegdys_anstd
outreg  stdev_elev ltotrain_anstd lgrowdegdys_anstd using first_1930 , append nolabel nocons se coefastr 3aster bracket addstat(F Test: Weather Risk Variables=0, r(F), p-value, r(p)) adec(2,3)

reg giniy stdev_elev ltotrain_anstd lgrowdegdys_anstd stdev_elev_NS ltotrain_anstd_NS lgrowdegdys_anstd_NS NS lttlpy vfmagr_pfy ubp_sh  pop_densy nwp_sharey ngp_sharey shypy county_area state_dum* region_dum*  if year==1930, r
test stdev_elev ltotrain_anstd lgrowdegdys_anstd
test stdev_elev ltotrain_anstd lgrowdegdys_anstd stdev_elev_NS ltotrain_anstd_NS lgrowdegdys_anstd_NS
outreg  stdev_elev ltotrain_anstd lgrowdegdys_anstd stdev_elev_NS ltotrain_anstd_NS lgrowdegdys_anstd_NS using first_1930 , append nolabel nocons se coefastr 3aster bracket 
x_ols  longitude_km latitude_km  longitude_km_cutoff latitude_km_cutoff  giniy_spa stdev_elev_spa ltotrain_anstd_spa lgrowdegdys_anstd_spa stdev_elev_NS_spa ltotrain_anstd_NS_spa lgrowdegdys_anstd_NS_spa vfmagr_pfy_spa ubp_sharey_spa  pop_densy_spa nwp_sharey_spa ngp_sharey_spa shypy_spa lttlpy_spa county_area_spa const, coord(2) xreg(15)
drop epsilon window dis1 dis2



/**********************First regression Table
*ols 1930
 reg led_sp_pcy giniy lttlpy county_area state_dum* region_dum*  if year==1930, r   
outreg  giniy using edu_1930 , replace nolabel nocons se coefastr 3aster bracket 
x_ols  longitude_km latitude_km  longitude_km_cutoff latitude_km_cutoff  led_sp_pcy_spa giniy_spa lttlpy_spa county_area_spa const, coord(2) xreg(4)
drop epsilon window dis1 dis2


*ols 1930
reg ltaxc_pcy giniy lttlpy county_area state_dum* region_dum*  if year==1930 , r   
outreg  giniy using edu_1930 , replace nolabel nocons se coefastr 3aster bracket 
x_ols  longitude_km latitude_km  longitude_km_cutoff latitude_km_cutoff  led_sp_pcy_spa giniy_spa lttlpy_spa county_area_spa const, coord(2) xreg(4)
drop epsilon window dis1 dis2

*ols 1920
reg ltaxc_pcy giniy lttlpy county_area state_dum* region_dum*  if year==1920 , r   
outreg  giniy using edu_1930 , replace nolabel nocons se coefastr 3aster bracket 
x_ols  longitude_km latitude_km  longitude_km_cutoff latitude_km_cutoff  led_sp_pcy_spa giniy_spa lttlpy_spa county_area_spa const, coord(2) xreg(4)
drop epsilon window dis1 dis2

*iv 1930 

ivreg2 led_sp_pcy (giniy=giniy_1890)  lttlpy county_area state_dum* region_dum*  if year==1930, r   first 
outreg  giniy using edu_1930 , append nolabel nocons se coefastr 3aster bracket addstat(Overidentification Test, e(j), p-value, e(jp), R-Squared, e(r2c)) adec(2,3)
reg led_sp_pcy_spa const giniy_spa lttlpy_spa county_area_spa  giniy_1890_spa
keep if e(sample)
x_gmm longitude_km latitude_km  longitude_km_cutoff latitude_km_cutoff led_sp_pcy_spa const giniy_spa lttlpy_spa county_area_spa const giniy_1890_spa lttlpy_spa county_area_spa , coord(2) xreg(4) inst(4)
drop  dis1 dis2 zubar*

*iv 1930
ivreg2 ltaxc_pcy (giniy=giniy_1890)  lttlpy county_area state_dum* region_dum*  if year==1930, r   first 
outreg  giniy using edu_1930 , append nolabel nocons se coefastr 3aster bracket addstat(Overidentification Test, e(j), p-value, e(jp), R-Squared, e(r2c)) adec(2,3)
reg ltaxc_pcy_spa const giniy_spa lttlpy_spa county_area_spa  giniy_1890_spa
keep if e(sample)
x_gmm longitude_km latitude_km  longitude_km_cutoff latitude_km_cutoff ltaxc_pcy_spa const giniy_spa lttlpy_spa county_area_spa const giniy_1890_spa lttlpy_spa county_area_spa , coord(2) xreg(4) inst(4)
drop  dis1 dis2 zubar*

*iv 1920
ivreg2 ltaxc_pcy (giniy=giniy_1890)  lttlpy county_area state_dum* region_dum*  if year==1920, r   first 
outreg  giniy using edu_1930 , append nolabel nocons se coefastr 3aster bracket addstat(Overidentification Test, e(j), p-value, e(jp), R-Squared, e(r2c)) adec(2,3)
reg ltaxc_pcy_spa const giniy_spa lttlpy_spa county_area_spa  giniy_1890_spa
keep if e(sample)
x_gmm longitude_km latitude_km  longitude_km_cutoff latitude_km_cutoff ltaxc_pcy_spa const giniy_spa lttlpy_spa county_area_spa const giniy_1890_spa lttlpy_spa county_area_spa , coord(2) xreg(4) inst(4)
drop  dis1 dis2 zubar*



/*1930 education expenditures
*ols
qui reg led_sp_pcy giniy lttlpy county_area state_dum* region_dum*  if year==1930, r   
outreg  giniy using edu_1930 , replace nolabel nocons se coefastr 3aster bracket 
x_ols  longitude_km latitude_km  longitude_km_cutoff latitude_km_cutoff  led_sp_pcy_spa giniy_spa lttlpy_spa county_area_spa const, coord(2) xreg(4)
drop epsilon window dis1 dis2

*iv min
 ivreg2 led_sp_pcy (giniy=stdev_elev ltotrain_anstd lgrowdegdys_anstd)  lttlpy county_area state_dum* region_dum*  if year==1930, r   first 
outreg  giniy using edu_1930 , append nolabel nocons se coefastr 3aster bracket addstat(Overidentification Test, e(j), p-value, e(jp), R-Squared, e(r2c)) adec(2,3)
x_gmm longitude_km latitude_km  longitude_km_cutoff latitude_km_cutoff led_sp_pcy_spa const giniy_spa lttlpy_spa county_area_spa const ltotrain_anstd_spa lgrowdegdys_anstd_spa stdev_elev_spa lttlpy_spa county_area_spa , coord(2) xreg(4) inst(6)
drop  dis1 dis2 zubar*

*iv max
 ivreg2 led_sp_pcy (giniy=  ltotrain_anstd lgrowdegdys_anstd stdev_elev) vfmagr_pfy ubp_sharey  pop_densy nwp_sharey ngp_sharey shypy lttlpy county_area state_dum* region_dum* if year==1930, r   first 
outreg  giniy using edu_1930 , append nolabel nocons se coefastr 3aster bracket addstat(Overidentification Test, e(j), p-value, e(jp)) adec(2,3)
x_gmm longitude_km latitude_km  longitude_km_cutoff latitude_km_cutoff led_sp_pcy_spa const giniy_spa vfmagr_pfy_spa ubp_sharey_spa  pop_densy_spa nwp_sharey_spa ngp_sharey_spa shypy_spa lttlpy_spa county_area_spa const ltotrain_anstd_spa lgrowdegdys_anstd_spa stdev_elev_spa vfmagr_pfy_spa ubp_sharey_spa  pop_densy_spa nwp_sharey_spa ngp_sharey_spa shypy_spa lttlpy_spa county_area_spa , coord(2) xreg(10) inst(12)
drop  dis1 dis2 zubar*

**NS interaction term
 ivreg2 led_sp_pcy (giniy giniy_NS= ltotrain_anstd lgrowdegdys_anstd stdev_elev stdev_elev_sq) vfmagr_pfy ubp_sharey  pop_densy nwp_sharey ngp_sharey shypy NS lttlpy county_area state_dum* region_dum* if year==1930, r   first 
outreg  giniy giniy_NS using edu_1930 , append nolabel nocons se coefastr 3aster bracket addstat(Overidentification Test, e(j), p-value, e(jp)) adec(2,3)
x_gmm longitude_km latitude_km  longitude_km_cutoff latitude_km_cutoff led_sp_pcy_spa const giniy_spa giniy_NS_spa vfmagr_pfy_spa ubp_sharey_spa  pop_densy_spa nwp_sharey_spa ngp_sharey_spa shypy_spa lttlpy_spa county_area_spa const ltotrain_anstd_spa lgrowdegdys_anstd_spa stdev_elev_spa stdev_elev_sq_spa vfmagr_pfy_spa ubp_sharey_spa  pop_densy_spa nwp_sharey_spa ngp_sharey_spa shypy_spa lttlpy_spa county_area_spa , coord(2) xreg(11) inst(13)
drop dis1 dis2 zubar*

** Texas
 ivreg2 led_sp_pcy (giniy= ltotrain_anstd lgrowdegdys_anstd stdev_elev)   lttlpy county_area state_dum* region_dum* if year==1930 & stateabbrev=="TX", r   first liml
outreg  giniy using edu_1930 , append nolabel nocons se coefastr 3aster bracket addstat(Overidentification Test, e(j), p-value, e(jp)) adec(2,3)

condivreg led_sp_pcy (giniy= ltotrain_anstd lgrowdegdys_anstd stdev_elev)   lttlpy county_area if year==1930 & stateabbrev=="TX",   liml 
outreg  giniy using edu_1930 , append nolabel nocons se coefastr 3aster bracket addstat(Overidentification Test, e(j), p-value, e(jp)) adec(2,3)


/*tax revenues

*ols
qui reg ltaxc_pcy giniy lttlpy county_area state_dum* region_dum*  if year==1930, r   
outreg  giniy using tax_1930 , replace nolabel nocons se coefastr 3aster bracket 
x_ols  longitude_km latitude_km  longitude_km_cutoff latitude_km_cutoff  ltaxc_pcy_spa giniy_spa lttlpy_spa county_area_spa const, coord(2) xreg(4)
drop epsilon window dis1 dis2

*iv min
 ivreg2 ltaxc_pcy (giniy=stdev_elev ltotrain_anstd)  lttlpy county_area state_dum* region_dum*  if year==1930, r   
outreg  giniy using tax_1930 , append nolabel nocons se coefastr 3aster bracket addstat(Overidentification Test, e(j), p-value, e(jp)) adec(2,3)
x_gmm longitude_km latitude_km  longitude_km_cutoff latitude_km_cutoff ltaxc_pcy_spa const giniy_spa lttlpy_spa county_area_spa const ltotrain_anstd_spa lgrowdegdys_anstd_spa stdev_elev_spa lttlpy_spa county_area_spa , coord(2) xreg(4) inst(6)
drop  dis1 dis2 zubar*

*iv max
 ivreg2 ltaxc_pcy (giniy= ltotrain_anstd lgrowdegdys_anstd stdev_elev) vfmagr_pfy ubp_sh  pop_densy nwp_sharey ngp_sharey shypy lttlpy county_area state_dum* region_dum* if year==1930, r   first 
outreg  giniy using tax_1930 , append nolabel nocons se coefastr 3aster bracket addstat(Overidentification Test, e(j), p-value, e(jp)) adec(2,3)
x_gmm longitude_km latitude_km  longitude_km_cutoff latitude_km_cutoff ltaxc_pcy_spa const giniy_spa vfmagr_pfy_spa ubp_sharey_spa  pop_densy_spa nwp_sharey_spa ngp_sharey_spa shypy_spa lttlpy_spa county_area_spa const ltotrain_anstd_spa lgrowdegdys_anstd_spa stdev_elev_spa vfmagr_pfy_spa ubp_sharey_spa  pop_densy_spa nwp_sharey_spa ngp_sharey_spa shypy_spa lttlpy_spa county_area_spa , coord(2) xreg(10) inst(12)
drop  dis1 dis2 zubar*

**NS interaction term
 ivreg2 ltaxc_pcy (giniy giniy_NS= ltotrain_anstd lgrowdegdys_anstd stdev_elev stdev_elev_NS ltotrain_anstd_NS ) vfmagr_pfy ubp_sharey  pop_densy nwp_sharey ngp_sharey shypy NS lttlpy county_area state_dum* region_dum* if year==1930, r   first 
outreg  giniy giniy_NS using tax_1930 , append nolabel nocons se coefastr 3aster bracket addstat(Overidentification Test, e(j), p-value, e(jp)) adec(2,3)
x_gmm longitude_km latitude_km  longitude_km_cutoff latitude_km_cutoff ltaxc_pcy_spa const giniy_spa giniy_NS_spa NS_spa vfmagr_pfy_spa ubp_sharey_spa  pop_densy_spa nwp_sharey_spa ngp_sharey_spa shypy_spa lttlpy_spa county_area_spa const ltotrain_anstd_spa lgrowdegdys_anstd_spa stdev_elev_spa stdev_elev_NS_spa ltotrain_anstd_NS_spa NS_spa vfmagr_pfy_spa ubp_sharey_spa  pop_densy_spa nwp_sharey_spa ngp_sharey_spa shypy_spa lttlpy_spa county_area_spa , coord(2) xreg(12) inst(15)
drop dis1 dis2 zubar*

** Texas
 ivreg2 ltaxc_pcy (giniy= ltotrain_anstd lgrowdegdys_anstd stdev_elev)   lttlpy county_area state_dum* region_dum* if year==1930 & stateabbrev=="TX", r   first 
outreg  giniy using tax_1930 , append nolabel nocons se coefastr 3aster bracket addstat(Overidentification Test, e(j), p-value, e(jp)) adec(2,3)

** iv max 1920
ivreg2 ltaxc_pcy (giniy= ltotrain_anstd lgrowdegdys_anstd stdev_elev) ubp_sha  pop_densy nwp_sharey ngp_sharey shypy  lttlpy county_area state_dum* region_dum* if year==1920, r   first 
outreg  giniy using tax_1930 , append nolabel nocons se coefastr 3aster bracket addstat(Overidentification Test, e(j), p-value, e(jp)) adec(2,3)
x_gmm longitude_km latitude_km  longitude_km_cutoff latitude_km_cutoff ltaxc_pcy_spa const giniy_spa ubp_sharey_spa  pop_densy_spa nwp_sharey_spa ngp_sharey_spa shypy_spa lttlpy_spa county_area_spa const ltotrain_anstd_spa lgrowdegdys_anstd_spa stdev_elev_spa ubp_sharey_spa  pop_densy_spa nwp_sharey_spa ngp_sharey_spa shypy_spa lttlpy_spa county_area_spa , coord(2) xreg(9) inst(11)

**NS interaction term
 ivreg2 ltaxc_pcy (giniy giniy_NS= ltotrain_anstd lgrowdegdys_anstd stdev_elev   stdev_elev_sq) NS ubp_sh  pop_densy nwp_sharey ngp_sharey shypy NS lttlpy county_area state_dum* region_dum* if year==1920, r   first 
outreg  giniy giniy_NS using tax_1930 , append nolabel nocons se coefastr 3aster bracket addstat(Overidentification Test, e(j), p-value, e(jp)) adec(2,3)
x_gmm longitude_km latitude_km  longitude_km_cutoff latitude_km_cutoff ltaxc_pcy_spa const giniy_spa giniy_NS NS ubp_sharey_spa  pop_densy_spa nwp_sharey_spa ngp_sharey_spa shypy_spa lttlpy_spa county_area_spa const ltotrain_anstd_spa lgrowdegdys_anstd_spa stdev_elev_spa stdev_elev_sq_spa NS_spa ubp_sharey_spa  pop_densy_spa nwp_sharey_spa ngp_sharey_spa shypy_spa lttlpy_spa county_area_spa , coord(2) xreg(11) inst(13)

reg giniy ltotrain_anstd lgrowdegdys_anstd stdev_elev ubp_sha  pop_densy nwp_sharey ngp_sharey shypy  lttlpy county_area state_dum* region_dum* if year==1920, r   
predict test if e(sample), xb
reg ltaxc_pcy test ubp_sha  pop_densy nwp_sharey ngp_sharey shypy  lttlpy county_area state_dum* region_dum* if year==1920, r  



**state level

*education per capita
ivreg2 st_sexp_log (st_giniy=st_totrain_anstd st_growdegdys_anstd)  st_ttlpy state_area region if year==1890 ,r  first liml
outreg  st_giniy using st_sexp_ver2 , replace nolabel se coefastr 3aster bracket addstat(Overidentification Test, e(arubin), p-value, e(arubinp)) adec(2,3)

ivreg2 st_sexp_log (st_giniy=st_totrain_anstd st_growdegdys_anstd) st_ttlpy state_area region if year==1910 ,r first liml
outreg  st_giniy using st_sexp_ver2 , append nolabel se coefastr 3aster bracket addstat(Overidentification Test, e(arubin), p-value, e(arubinp)) adec(2,3)

*welfare per capita
ivreg2 st_slwp_log (st_giniy=st_totrain_anstd st_growdegdys_anstd) st_ttlpy state_area region if year==1890 ,r  first liml 
outreg  st_giniy using st_sexp_ver2 , append nolabel se coefastr 3aster bracket addstat(Overidentification Test, e(arubin), p-value, e(arubinp)) adec(2,3)

ivreg2 st_slwp_log (st_giniy=st_totrain_anstd st_growdegdys_anstd) st_ttlpy state_area region if year==1900 ,r  first liml
outreg  st_giniy using st_sexp_ver2 , append nolabel se coefastr 3aster bracket addstat(Overidentification Test, e(arubin), p-value, e(arubinp)) adec(2,3)

ivreg2 st_slwp_log (st_giniy=st_totrain_anstd st_growdegdys_anstd) st_ttlpy state_area region if year==1910 ,r first liml
outreg  st_giniy using st_sexp_ver2 , append nolabel se coefastr 3aster bracket addstat(Overidentification Test, e(arubin), p-value, e(arubinp)) adec(2,3)

ivreg2 st_slwp_log (st_giniy=st_totrain_anstd st_growdegdys_anstd) st_ttlpy state_area region if year==1930 ,r  first liml
outreg  st_giniy using st_sexp_ver2 , append nolabel se coefastr 3aster bracket addstat(Overidentification Test, e(arubin), p-value, e(arubinp)) adec(2,3)

*per capita total expenditures
ivreg2 st_slxp_log (st_giniy=st_totrain_anstd st_growdegdys_anstd) st_ttlpy state_area region if year==1890 ,r liml 
outreg  st_giniy using st_sexp_ver2 , replace nolabel se coefastr 3aster bracket addstat(Overidentification Test, e(arubin), p-value, e(arubinp)) adec(2,3)

ivreg2 st_slxp_log (st_giniy=st_totrain_anstd st_growdegdys_anstd) st_ttlpy state_area region if year==1900 ,r liml  
outreg  st_giniy using st_sexp_ver2 , append nolabel se coefastr 3aster bracket addstat(Overidentification Test, e(arubin), p-value, e(arubinp)) adec(2,3)

ivreg2 st_slxp_log (st_giniy=st_totrain_anstd st_growdegdys_anstd) st_ttlpy state_area region if year==1910 ,r liml 
outreg  st_giniy using st_sexp_ver2 , append nolabel se coefastr 3aster bracket addstat(Overidentification Test, e(arubin), p-value, e(arubinp)) adec(2,3) 

*ad valorem tax per capita
ivreg2 st_atp_log (st_giniy=st_totrain_anstd st_growdegdys_anstd) st_ttlpy state_area region if year==1890 ,r  first liml
outreg  st_giniy using st_sexp_ver2 , append nolabel se coefastr 3aster bracket addstat(Overidentification Test, e(arubin), p-value, e(arubinp)) adec(2,3)

ivreg2 st_atp_log (st_giniy=st_totrain_anstd st_growdegdys_anstd) st_ttlpy state_area region if year==1900 ,r  first liml
outreg  st_giniy using st_sexp_ver2 , append nolabel se coefastr 3aster bracket addstat(Overidentification Test, e(arubin), p-value, e(arubinp)) adec(2,3)

*education as a share of total expenditures
ivreg2 st_sexp_slxp (st_giniy=st_totrain_anstd st_growdegdys_anstd) st_ttlpy state_area region if year==1910 ,r first liml
outreg  st_giniy using st_sexp_ver2 , append nolabel se coefastr 3aster bracket addstat(Overidentification Test, e(arubin), p-value, e(arubinp)) adec(2,3)


****instrument sensitivity
**all instruments

x_ols  longitude_km latitude_km  longitude_km_cutoff latitude_km_cutoff  giniy_spa stdev_elev_spa ltotrain_anstd_spa lgrowdegdys_anstd_spa totrain_anave_spa vfmagr_pfy_spa ubp_sharey_spa  pop_densy_spa nwp_sharey_spa ngp_sharey_spa shypy_spa lttlpy_spa county_area_spa const, coord(2) xreg(13)
drop epsilon window dis1 dis2

ivreg2 led_sp_pcy (giniy=  totrain_anave )  vfmagr_pfy ubp_sharey  pop_densy nwp_sharey ngp_sharey shypy  lttlpy county_area state_dum* region_dum* if year==1930, r   first 
outreg  giniy using ins_sens , replace nolabel nocons se coefastr 3aster bracket addstat(Overidentification Test, e(j), p-value, e(jp)) adec(2,3)
x_gmm longitude_km latitude_km  longitude_km_cutoff latitude_km_cutoff led_sp_pcy_spa const giniy_spa vfmagr_pfy_spa ubp_sharey_spa  pop_densy_spa nwp_sharey_spa ngp_sharey_spa shypy_spa lttlpy_spa county_area_spa const ltotrain_anstd_spa lgrowdegdys_anstd_spa stdev_elev_spa totrain_anave_spa vfmagr_pfy_spa ubp_sharey_spa  pop_densy_spa nwp_sharey_spa ngp_sharey_spa shypy_spa lttlpy_spa county_area_spa , coord(2) xreg(10) inst(13)
drop dis1 dis2 zubar*

ivreg2 ltaxc_pcy (giniy=  totrain_anave ) vfmagr_pfy ubp_sharey  pop_densy nwp_sharey ngp_sharey shypy  lttlpy county_area state_dum* region_dum* if year==1930, r   first 
outreg  giniy using ins_sens , append nolabel nocons se coefastr 3aster bracket addstat(Overidentification Test, e(j), p-value, e(jp)) adec(2,3)
x_gmm longitude_km latitude_km  longitude_km_cutoff latitude_km_cutoff ltaxc_pcy_spa const giniy_spa ubp_sharey_spa  pop_densy_spa nwp_sharey_spa ngp_sharey_spa shypy_spa lttlpy_spa county_area_spa const ltotrain_anstd_spa lgrowdegdys_anstd_spa stdev_elev_spa totrain_anave_spa ubp_sharey_spa  pop_densy_spa nwp_sharey_spa ngp_sharey_spa shypy_spa lttlpy_spa county_area_spa , coord(2) xreg(9) inst(12)
drop dis1 dis2 zubar*


ivreg2 ltaxc_pcy (giniy= totrain_anave )growdegdys_anave ubp_sharey  pop_densy nwp_sharey ngp_sharey shypy  lttlpy county_area state_dum* region_dum* if year==1920, r   first 
outreg  giniy using ins_sens , append nolabel nocons se coefastr 3aster bracket addstat(Overidentification Test, e(j), p-value, e(jp)) adec(2,3)
x_gmm longitude_km latitude_km  longitude_km_cutoff latitude_km_cutoff ltaxc_pcy_spa const giniy_spa ubp_sharey_spa  pop_densy_spa nwp_sharey_spa ngp_sharey_spa shypy_spa lttlpy_spa county_area_spa const ltotrain_anstd_spa lgrowdegdys_anstd_spa stdev_elev_spa totrain_anave_spa ubp_sharey_spa  pop_densy_spa nwp_sharey_spa ngp_sharey_spa shypy_spa lttlpy_spa county_area_spa , coord(2) xreg(9) inst(12)
drop dis1 dis2 zubar*




**examine crops themselves (Friedan's idea)
ivreg2 led_sp_pcy (giniy=stdev_elev ltotrain_anstd lgrowdegdys_anstd) vforpdy_share vfruy_share vcery_share vgarvegy_share vvegy_share vothcery_share vfmagr_pfy ubp_sharey pop_densy nwp_sharey ngp_sharey shypy lttlpy county_area state_dum* region_dum*  if year==1930, r   first 
outreg  giniy vforpdy_share vfruy_share vcery_share vgarvegy_share vvegy_share vothcery_share  using ins_sens , append nolabel nocons se coefastr 3aster bracket 
x_gmm longitude_km latitude_km  longitude_km_cutoff latitude_km_cutoff led_sp_pcy_spa const giniy_spa vforpdy_share_spa vfruy_share_spa vcery_share_spa vgarvegy_share_spa vvegy_share_spa vothcery_share_spa vfmagr_pfy_spa ubp_sharey_spa  pop_densy_spa nwp_sharey_spa ngp_sharey_spa shypy_spa lttlpy_spa county_area_spa const ltotrain_anstd_spa lgrowdegdys_anstd_spa stdev_elev_spa vforpdy_share_spa vfruy_share_spa vcery_share_spa vgarvegy_share_spa vvegy_share_spa vothcery_share_spa vfmagr_pfy_spa ubp_sharey_spa  pop_densy_spa nwp_sharey_spa ngp_sharey_spa shypy_spa lttlpy_spa county_area_spa , coord(2) xreg(16) inst(18)
drop dis1 dis2 zubar*
Results for 2-Step Spatial GMM

number of observations=  2966

crit. fn. test of overid. restrictions=  1.0049109

Dependent variable= led_sp_pcy_spa

variable    2SLS Est.       2SLS SE    Spatial GMM Est.  Spatial GMM SE
-------------   ---------  -------------     --------------	---
const       -2.931e-10      .00582159  -.00001612        .00815935
giniy_spa   -2.2476795      .67001355  -2.1775596        .73295975
vforpdy_share_spa.0009584   .00140952  .00043335         .00268105
vfruy_share_spa.0030694     .00139176  .00293212         .00154591
vcery_share_spa.00083961    .00045539  .00070463         .00060469
vgarvegy_share_spa-.0014581 .00223316  -.00196333        .00341563
vvegy_share_spa.00319962    .00110718  .00304689         .00142502
vothcery_share_spa-.00196673.00120408  -.00194364        .00138791
vfmagr_pfy_spa3.067e-06     4.659e-06  3.468e-06         5.910e-06
ubp_sharey_spa.0016925      .00042414  .00163508         .00055267
pop_densy_spa.00002238      .00004852  .00002305         .00005615
nwp_sharey_spa.38892597     .13960305  .39474636         .17958671
ngp_sharey_spa.30547944     .1035095   .30800122         .15748216
shypy_spa   -.50087804      .33992639  -.49196774        .44717118
lttlpy_spa  -.0649813       .0126146   -.06541805        .01836434
county_area_spa6.348e-06    2.879e-06  6.346e-06         3.030e-06




ivreg2 ltaxc_pcy (giniy=stdev_elev ltotrain_anstd lgrowdegdys_anstd) vforpdy_share vfruy_share vcery_share vgarvegy_share vvegy_share vothcery_share vfmagr_pfy ubp_sharey pop_densy nwp_sharey ngp_sharey shypy lttlpy county_area state_dum* region_dum*  if year==1930, r   first 
outreg  giniy vforpdy_share vfruy_share vcery_share vgarvegy_share vvegy_share vothcery_share  using ins_sens , append nolabel nocons se coefastr 3aster bracket 
x_gmm longitude_km latitude_km  longitude_km_cutoff latitude_km_cutoff ltaxc_pcy_spa const giniy_spa vforpdy_share_spa vfruy_share_spa vcery_share_spa vgarvegy_share_spa vvegy_share_spa vothcery_share_spa vfmagr_pfy_spa ubp_sharey_spa  pop_densy_spa nwp_sharey_spa ngp_sharey_spa shypy_spa lttlpy_spa county_area_spa const ltotrain_anstd_spa lgrowdegdys_anstd_spa stdev_elev_spa vforpdy_share_spa vfruy_share_spa vcery_share_spa vgarvegy_share_spa vvegy_share_spa vothcery_share_spa vfmagr_pfy_spa ubp_sharey_spa  pop_densy_spa nwp_sharey_spa ngp_sharey_spa shypy_spa lttlpy_spa county_area_spa , coord(2) xreg(16) inst(18)
drop dis1 dis2 zubar*


Chi-sq(2) P-val =   0.14408

Instrumented:  giniy
Instruments:   stdev_elev ltotrain_anstd lgrowdegdys_anstd vforpdy_share
vfruy_share vcery_share vgarvegy_share vvegy_share
vothcery_share vfmagr_pfy ubp_sharey pop_densy nwp_sharey
ngp_sharey shypy lttlpy county_area state_dum2 state_dum3
state_dum4 state_dum5 state_dum6 state_dum8 state_dum9
state_dum10 state_dum11 state_dum13 state_dum14 state_dum15
state_dum16 state_dum17 state_dum18 state_dum20 state_dum21
state_dum22 state_dum23 state_dum24 state_dum25 state_dum26
state_dum27 state_dum28 state_dum30 state_dum31 state_dum33
state_dum34 state_dum35 state_dum36 state_dum37 state_dum38
state_dum39 state_dum41 state_dum42 state_dum43 state_dum44
state_dum45 region_dum1 region_dum2 region_dum3 region_dum4
region_dum5 region_dum6 region_dum7




. x_gmm longitude_km latitude_km  longitude_km_cutoff latitude_km_cutoff ltaxc_pcy_spa const giniy_spa vforpdy_share_spa 


Results for 2-Step Spatial GMM

number of observations=  2966

crit. fn. test of overid. restrictions=  3.3453197

Dependent variable= ltaxc_pcy_spa

variable    2SLS Est.       2SLS SE    Spatial GMM Est.  Spatial GMM SE
-------------   ---------  -------------     ------------------
const       -6.412e-10      .00611298  .0012751          .00861845
giniy_spa   -1.0512141      .7035501   -1.0928779        .72797328
vforpdy_share_spa-.00297769 .00148007  -.00244246        .00239611
vfruy_share_spa.00074222    .00146142  .00095005         .00169038
vcery_share_spa-.00015787   .00047818  -.00014429        .00066957
vgarvegy_share_spa.00221511 .00234494  .00171152         .00373226
vvegy_share_spa.00219708    .0011626   .00234567         .00145571
vothcery_share_spa-.00225437.00126435  -.00220298        .00142043
vfmagr_pfy_spa.00001731     4.892e-06  .00001826         6.859e-06
ubp_sharey_spa.0013172      .00044537  .00128151         .00056895
pop_densy_spa.00008371      .00005095  .00008832         .00006033
nwp_sharey_spa-.2591846     .14659066  -.23548979        .18106088
ngp_sharey_spa-.25789338    .10869052  -.22500071        .15566933
shypy_spa   -4.8694158      .3569409   -4.7578955        .52904338
lttlpy_spa  -.1568007       .01324601  -.1578937         .01693686
county_area_spa.00001052    3.023e-06  .00001063         3.656e-06


**use crops as instruments:
ivreg2 led_sp_pcy (giniy=vfruy_share vcery_share vgarvegy_share  )  vfmagr_pfy ubp_sharey pop_densy nwp_sharey ngp_sharey shypy lttlpy county_area state_dum* region_dum*  if year==1930, r   first 

ivreg2 ltaxc_pcy (giniy=vfruy_share vcery_share vgarvegy_share )  vfmagr_pfy ubp_sharey pop_densy nwp_sharey ngp_sharey shypy lttlpy county_area state_dum* region_dum*  if year==1930, r   first 

ivreg2 ltaxc_pcy (giniy=vfruy_share vcery_share vvegy_share  )   ubp_sharey pop_densy nwp_sharey ngp_sharey  lttlpy county_area state_dum* region_dum*  if year==1920, r   first 

**1890 instrument
ivreg2 led_sp_pcy (giniy= giniy_1890) vfmagr_pfy ubp_sh  pop_densy nwp_sharey ngp_sharey shypy  lttlpy county_area state_dum* region_dum* if year==1930, r   first 
outreg  giniy using ins_sens , append nolabel nocons se coefastr 3aster bracket 
x_gmm longitude_km latitude_km  longitude_km_cutoff latitude_km_cutoff led_sp_pcy_spa const giniy_spa vfmagr_pfy_spa ubp_sharey_spa  pop_densy_spa nwp_sharey_spa ngp_sharey_spa shypy_spa lttlpy_spa county_area_spa const giniy_1890_spa vfmagr_pfy_spa ubp_sharey_spa  pop_densy_spa nwp_sharey_spa ngp_sharey_spa shypy_spa lttlpy_spa county_area_spa , coord(2) xreg(10) inst(10)
drop dis1 dis2 zubar*

ivreg2 ltaxc_pcy (giniy= giniy_1890) vfmagr_pfy ubp_sh  pop_densy nwp_sharey ngp_sharey shypy  lttlpy county_area state_dum* region_dum* if year==1930, r   first 
outreg  giniy using ins_sens , append nolabel nocons se coefastr 3aster bracket 
x_gmm longitude_km latitude_km  longitude_km_cutoff latitude_km_cutoff ltaxc_pcy_spa const giniy_spa vfmagr_pfy_spa ubp_sharey_spa  pop_densy_spa nwp_sharey_spa ngp_sharey_spa shypy_spa lttlpy_spa county_area_spa const giniy_1890_spa vfmagr_pfy_spa ubp_sharey_spa  pop_densy_spa nwp_sharey_spa ngp_sharey_spa shypy_spa lttlpy_spa county_area_spa , coord(2) xreg(10) inst(10)
drop dis1 dis2 zubar*

ivreg2 ltaxc_pcy (giniy= giniy_1890) ubp_sh  pop_densy nwp_sharey ngp_sharey shypy  lttlpy county_area state_dum* region_dum* if year==1920, r   first 
outreg  giniy using ins_sens , append nolabel nocons se coefastr 3aster bracket 
x_gmm longitude_km latitude_km  longitude_km_cutoff latitude_km_cutoff ltaxc_pcy_spa const giniy_spa ubp_sharey_spa  pop_densy_spa nwp_sharey_spa ngp_sharey_spa shypy_spa lttlpy_spa county_area_spa const giniy_1890_spa ubp_sharey_spa  pop_densy_spa nwp_sharey_spa ngp_sharey_spa shypy_spa lttlpy_spa county_area_spa , coord(2) xreg(9) inst(9)
drop dis1 dis2 zubar*



**********Showing the reduced form 
reg led_sp_pcy  ltotrain_anstd lgrowdegdys_anstd stdev_elev  lttlpy county_area state_dum* region_dum* if year==1930, r   

reg ltaxc_pcy  ltotrain_anstd lgrowdegdys_anstd stdev_elev lttlpy county_area state_dum* region_dum* if year==1930, r   



***********13 colonies
ivreg2 led_sp_pcy (giniy=  ltotrain_anstd lgrowdegdys_anstd stdev_elev)  vfmagr_pfy ubp_sharey  pop_densy nwp_sharey ngp_sharey shypy  lttlpy county_area state_dum* if year==1930 & stateabbrev=="NY"|stateabbrev=="MA"|stateabbrev=="ME"|stateabbrev=="VA"|stateabbrev=="CT"|stateabbrev=="GA"|stateabbrev=="SC"|stateabbrev=="NC"|stateabbrev=="PA"|stateabbrev=="NH"|stateabbrev=="NJ"|stateabbrev=="MD"|stateabbrev=="DE", r   first 

ivreg2 ltaxc_pcy (giniy=  ltotrain_anstd lgrowdegdys_anstd stdev_elev)  lttlpy county_area state_dum* if year==1930 & stateabbrev=="NY"|stateabbrev=="MA"|stateabbrev=="ME"|stateabbrev=="VA"|stateabbrev=="CT"|stateabbrev=="GA"|stateabbrev=="SC"|stateabbrev=="NC"|stateabbrev=="PA"|stateabbrev=="NH"|stateabbrev=="NJ"|stateabbrev=="MD"|stateabbrev=="DE", r   first 

ivreg2 ltaxc_pcy (giniy=  ltotrain_anstd lgrowdegdys_anstd stdev_elev)   lttlpy county_area state_dum*  if year==1920 & stateabbrev=="NY"|stateabbrev=="MA"|stateabbrev=="ME"|stateabbrev=="VA"|stateabbrev=="CT"|stateabbrev=="GA"|stateabbrev=="SC"|stateabbrev=="NC"|stateabbrev=="PA"|stateabbrev=="NH"|stateabbrev=="NJ"|stateabbrev=="MD"|stateabbrev=="DE", r   first 

************the upper mid west
ivreg2 led_sp_pcy (giniy=  ltotrain_anstd lgrowdegdys_anstd stdev_elev)  vfmagr_pfy ubp_sharey  pop_densy nwp_sharey ngp_sharey shypy  lttlpy county_area state_dum* if year==1930 & region==2|region==3, r   first 

ivreg2 led_sp_pcy (giniy=  giniy_1890)  vfmagr_pfy ubp_sharey  pop_densy nwp_sharey ngp_sharey shypy  lttlpy county_area state_dum* if year==1930 & region==2|region==3, r   first 

ivreg2 ltaxc_pcy (giniy=  giniy_1890)  vfmagr_pfy ubp_sharey  pop_densy nwp_sharey ngp_sharey shypy  lttlpy county_area state_dum* if year==1930 & region==2|region==3, r   first 

ivreg2 ltaxc_pcy (giniy=  giniy_1890)  ubp_sharey  pop_densy nwp_sharey ngp_sharey shypy  lttlpy county_area state_dum* if year==1920 & region==2|region==3, r   first 

ivreg2 ltaxc_pcy (giniy=  ltotrain_anstd lgrowdegdys_anstd stdev_elev)  vfmagr_pfy ubp_sharey  pop_densy nwp_sharey ngp_sharey shypy  lttlpy county_area state_dum* if year==1930 & region==2|region==3, r   first 



***************How does it work?

**urban interaction
qui ivreg2 led_sp_pcy (giniy giniy_ubp= ltotrain_anstd lgrowdegdys_anstd stdev_elev ltotrain_anstd_ubp) vfmagr_pfy ubp_sh  pop_densy nwp_sharey ngp_sharey shypy  lttlpy county_area state_dum* region_dum* if year==1930, r   first 
outreg  giniy giniy_ubp using urban, replace nolabel nocons se coefastr 3aster bracket addstat(Overidentification Test, e(j), p-value, e(jp)) adec(2,3)
x_gmm longitude_km latitude_km  longitude_km_cutoff latitude_km_cutoff led_sp_pcy_spa const giniy_spa giniy_ubp_spa vfmagr_pfy_spa ubp_sharey_spa  pop_densy_spa nwp_sharey_spa ngp_sharey_spa shypy_spa lttlpy_spa county_area_spa const ltotrain_anstd_spa lgrowdegdys_anstd_spa stdev_elev_spa ltotrain_anstd_ubp_spa vfmagr_pfy_spa ubp_sharey_spa  pop_densy_spa nwp_sharey_spa ngp_sharey_spa shypy_spa lttlpy_spa county_area_spa , coord(2) xreg(11) inst(13)
drop dis1 dis2 zubar*

qui ivreg2 ltaxc_pcy (giniy giniy_ubp= ltotrain_anstd lgrowdegdys_anstd stdev_elev ltotrain_anstd_ubp) vfmagr_pfy ubp_sh  pop_densy nwp_sharey ngp_sharey shypy  lttlpy county_area state_dum* region_dum* if year==1930, r   first 
outreg  giniy giniy_ubp using urban, append nolabel nocons se coefastr 3aster bracket addstat(Overidentification Test, e(j), p-value, e(jp)) adec(2,3)
x_gmm longitude_km latitude_km  longitude_km_cutoff latitude_km_cutoff ltaxc_pcy_spa const giniy_spa giniy_ubp_spa vfmagr_pfy_spa ubp_sharey_spa  pop_densy_spa nwp_sharey_spa ngp_sharey_spa shypy_spa lttlpy_spa county_area_spa const ltotrain_anstd_spa lgrowdegdys_anstd_spa stdev_elev_spa ltotrain_anstd_ubp_spa vfmagr_pfy_spa ubp_sharey_spa  pop_densy_spa nwp_sharey_spa ngp_sharey_spa shypy_spa lttlpy_spa county_area_spa , coord(2) xreg(11) inst(13)
drop dis1 dis2 zubar*


qui ivreg2 ltaxc_pcy (giniy giniy_ubp= ltotrain_anstd lgrowdegdys_anstd stdev_elev ltotrain_anstd_ubp) ubp_sh  pop_densy nwp_sharey ngp_sharey shypy  lttlpy county_area state_dum* region_dum* if year==1920, r   first 
outreg  giniy giniy_ubp using urban, append nolabel nocons se coefastr 3aster bracket addstat(Overidentification Test, e(j), p-value, e(jp)) adec(2,3)
x_gmm longitude_km latitude_km  longitude_km_cutoff latitude_km_cutoff ltaxc_pcy_spa const giniy_spa giniy_ubp_spa ubp_sharey_spa  pop_densy_spa nwp_sharey_spa ngp_sharey_spa shypy_spa lttlpy_spa county_area_spa const ltotrain_anstd_spa lgrowdegdys_anstd_spa stdev_elev_spa ltotrain_anstd_ubp_spa ubp_sharey_spa  pop_densy_spa nwp_sharey_spa ngp_sharey_spa shypy_spa lttlpy_spa county_area_spa , coord(2) xreg(10) inst(12)
drop dis1 dis2 zubar*

*per capita manuf
qui ivreg2 led_sp_pcy (giniy giniy_nom= ltotrain_anstd lgrowdegdys_anstd stdev_elev ltotrain_anstd_nom) nom_pcy vfmagr_pfy ubp_sh  pop_densy nwp_sharey ngp_sharey shypy  lttlpy county_area state_dum* region_dum* if year==1930, r   first 
outreg  giniy giniy_nom using urban, append nolabel nocons se coefastr 3aster bracket addstat(Overidentification Test, e(j), p-value, e(jp)) adec(2,3)
x_gmm longitude_km latitude_km  longitude_km_cutoff latitude_km_cutoff led_sp_pcy_spa const giniy_spa giniy_nom_spa nom_pcy_spa vfmagr_pfy_spa ubp_sharey_spa  pop_densy_spa nwp_sharey_spa ngp_sharey_spa shypy_spa lttlpy_spa county_area_spa const ltotrain_anstd_spa lgrowdegdys_anstd_spa stdev_elev_spa ltotrain_anstd_nom_spa nom_pcy_spa vfmagr_pfy_spa ubp_sharey_spa  pop_densy_spa nwp_sharey_spa ngp_sharey_spa shypy_spa lttlpy_spa county_area_spa , coord(2) xreg(12) inst(14)
drop dis1 dis2 zubar*

ivreg2 ltaxc_pcy (giniy giniy_nom= ltotrain_anstd lgrowdegdys_anstd stdev_elev ltotrain_anstd_nom)nom_pcy  vfmagr_pfy ubp_sh  pop_densy nwp_sharey ngp_sharey shypy  lttlpy county_area state_dum* region_dum* if year==1930, r   first 
outreg  giniy giniy_nom using urban, append nolabel nocons se coefastr 3aster bracket addstat(Overidentification Test, e(j), p-value, e(jp)) adec(2,3)
x_gmm longitude_km latitude_km  longitude_km_cutoff latitude_km_cutoff ltaxc_pcy_spa const giniy_spa giniy_nom_spa nom_pcy_spa vfmagr_pfy_spa ubp_sharey_spa  pop_densy_spa nwp_sharey_spa ngp_sharey_spa shypy_spa lttlpy_spa county_area_spa const ltotrain_anstd_spa lgrowdegdys_anstd_spa stdev_elev_spa ltotrain_anstd_nom_spa nom_pcy_spa vfmagr_pfy_spa ubp_sharey_spa  pop_densy_spa nwp_sharey_spa ngp_sharey_spa shypy_spa lttlpy_spa county_area_spa , coord(2) xreg(12) inst(14)
drop dis1 dis2 zubar*

qui ivreg2 ltaxc_pcy (giniy giniy_nom= ltotrain_anstd lgrowdegdys_anstd stdev_elev ltotrain_anstd_nom)nom_pcy  ubp_sh  pop_densy nwp_sharey ngp_sharey shypy  lttlpy county_area state_dum* region_dum* if year==1920, r   first 
outreg  giniy giniy_nom using urban, append nolabel nocons se coefastr 3aster bracket addstat(Overidentification Test, e(j), p-value, e(jp)) adec(2,3)
x_gmm longitude_km latitude_km  longitude_km_cutoff latitude_km_cutoff ltaxc_pcy_spa const giniy_spa giniy_nom_spa nom_pcy_spa ubp_sharey_spa  pop_densy_spa nwp_sharey_spa ngp_sharey_spa shypy_spa lttlpy_spa county_area_spa const ltotrain_anstd_spa lgrowdegdys_anstd_spa stdev_elev_spa ltotrain_anstd_nom_spa nom_pcy_spa ubp_sharey_spa  pop_densy_spa nwp_sharey_spa ngp_sharey_spa shypy_spa lttlpy_spa county_area_spa , coord(2) xreg(11) inst(13)


*tennancy
 ivreg2 led_sp_pcy (giniy = ltotrain_anstd lgrowdegdys_anstd stdev_elev) nofmte_shy vfmagr_pfy ubp_sh  pop_densy nwp_sharey ngp_sharey shypy  lttlpy county_area state_dum* region_dum* if year==1930, r   first 

*agr_shy 
 ivreg2 led_sp_pcy (giniy giniy_agr_shy= ltotrain_anstd lgrowdegdys_anstd stdev_elev ltotrain_anstd_agr_shy ) agr_shy agr_shy_sq   vfmagr_pfy ubp_sh  pop_densy nwp_sharey ngp_sharey shypy  lttlpy county_area state_dum* region_dum* if year==1930, r   first 
 ivreg2 ltaxc_pcy (giniy giniy_agr_shy= ltotrain_anstd lgrowdegdys_anstd stdev_elev ltotrain_anstd_agr_shy ) agr_shy agr_shy_sq vfmagr_pfy ubp_sh  pop_densy nwp_sharey ngp_sharey shypy  lttlpy county_area state_dum* region_dum* if year==1930, r   first 
 ivreg2 ltaxc_pcy (giniy giniy_agr_shy= ltotrain_anstd lgrowdegdys_anstd stdev_elev ltotrain_anstd_agr_shy ) agr_shy agr_shy_sq  ubp_sh  pop_densy nwp_sharey ngp_sharey shypy  lttlpy county_area state_dum* region_dum* if year==1920, r   first 

**an alternative measure of inequality: the small ratio
*first stage
*1930
reg small_ratio ltotrain_anstd lgrowdegdys_anstd stdev_elev vfmagr_pfy ubp_sh  pop_densy nwp_sharey ngp_sharey shypy  lttlpy county_area state_dum*  if year==1930  
outreg  ltotrain_anstd lgrowdegdys_anstd stdev_elev using alt_ins, replace nolabel nocons se coefastr 3aster bracket 
*1920
reg small_ratio ltotrain_anstd lgrowdegdys_anstd stdev_elev ubp_sh  pop_densy nwp_sharey ngp_sharey shypy  lttlpy county_area state_dum*  if year==1920  
outreg  ltotrain_anstd lgrowdegdys_anstd stdev_elev using alt_ins, append nolabel nocons se coefastr 3aster bracket 
*second stage
ivreg2 led_sp_pcy (small_ratio small_NS= ltotrain_anstd lgrowdegdys_anstd stdev_elev )NS vfmagr_pfy ubp_sh  pop_densy nwp_sharey ngp_sharey shypy  lttlpy county_area state_dum*  if year==1930  , r   liml
outreg  small_ratio small_NS using alt_ins , append nolabel nocons se coefastr 3aster bracket addstat(Overidentification Test, e(arubin), p-value, e(arubinp)) adec(2,3)

ivreg2 ltaxc_pcy (small_ratio small_NS= ltotrain_anstd lgrowdegdys_anstd stdev_elev ) vfmagr_pfy ubp_sh  pop_densy nwp_sharey ngp_sharey shypy  lttlpy county_area state_dum*  if year==1930  , r liml
outreg  small_ratio small_NS using alt_ins , append nolabel nocons se coefastr 3aster bracket addstat(Overidentification Test, e(arubin), p-value, e(arubinp)) adec(2,3)

ivreg2 ltaxc_pcy (small_ratio small_NS= ltotrain_anstd lgrowdegdys_anstd stdev_elev ) NS ubp_sh  pop_densy nwp_sharey ngp_sharey shypy  lttlpy county_area state_dum*  if year==1920  , r liml first
outreg  small_ratio small_NS using alt_ins , append nolabel nocons se coefastr 3aster bracket addstat(Overidentification Test, e(arubin), p-value, e(arubinp)) adec(2,3)


*****at the governor level
ivreg2 st_icg (st_giniy=st_totrain_anstd st_growdegdys_anstd)  NS st_ttlpy state_area region if year==1890 ,r first liml 
outreg  st_giniy using gov , replace nolabel se coefastr 3aster bracket addstat(Overidentification Test, e(arubin), p-value, e(arubinp)) adec(2,3)

ivreg2 st_icg (st_giniy=st_totrain_anstd st_growdegdys_anstd) NS st_ttlpy state_area region if year==1900 ,r first liml
outreg  st_giniy using gov , append nolabel se coefastr 3aster bracket addstat(Overidentification Test, e(arubin), p-value, e(arubinp)) adec(2,3)

ivreg2 st_icg (st_giniy=st_totrain_anstd st_growdegdys_anstd) NS st_ttlpy state_area region if year==1910 ,r  first liml
outreg  st_giniy using gov , append nolabel se coefastr 3aster bracket addstat(Overidentification Test, e(arubin), p-value, e(arubinp)) adec(2,3)

ivreg2 st_icg (st_giniy=st_totrain_anstd st_growdegdys_anstd) NS st_ttlpy state_area region if year==1920 ,r  first liml
outreg  st_giniy using gov , append nolabel se coefastr 3aster bracket addstat(Overidentification Test, e(arubin), p-value, e(arubinp)) adec(2,3)


ivreg2 st_icg (st_giniy=st_totrain_anstd st_growdegdys_anstd) NS st_ttlpy state_area region if year==1930 ,r  first liml
outreg  st_giniy using gov , append nolabel se coefastr 3aster bracket addstat(Overidentification Test, e(arubin), p-value, e(arubinp)) adec(2,3)


****at the congressional level
ivreg2 st_comp_cong_absy (st_giniy= st_totrain_anstd st_growdegdys_anstd ) NS  st_ttlpy state_area if year==1930, r first liml
outreg  st_giniy using gov , append nolabel se coefastr 3aster bracket addstat(Overidentification Test, e(arubin), p-value, e(arubinp)) adec(2,3)


ivreg2 st_comp_cong_absy (st_giniy= st_totrain_anstd st_growdegdys_anstd ) NS st_ttlpy state_area if year==1920, r first liml
outreg  st_giniy using gov , append nolabel se coefastr 3aster bracket addstat(Overidentification Test, e(arubin), p-value, e(arubinp)) adec(2,3)


ivreg2 st_comp_cong_absy (st_giniy= st_totrain_anstd st_growdegdys_anstd ) NS  st_ttlpy state_area if year==1910, r first liml
outreg  st_giniy using gov , append nolabel se coefastr 3aster bracket addstat(Overidentification Test, e(arubin), p-value, e(arubinp)) adec(2,3)


ivreg2 st_comp_cong_absy (st_giniy= st_totrain_anstd st_growdegdys_anstd ) NS  st_ttlpy state_area if year==1900, r first liml
outreg  st_giniy using gov , append nolabel se coefastr 3aster bracket addstat(Overidentification Test, e(arubin), p-value, e(arubinp)) adec(2,3)

ivreg2 st_comp_cong_absy (st_giniy= st_totrain_anstd st_growdegdys_anstd ) NS  st_ttlpy state_area if year==1890, r first liml
outreg  st_giniy using gov , append nolabel se coefastr 3aster bracket addstat(Overidentification Test, e(arubin), p-value, e(arubinp)) adec(2,3)

***graphs
scatter  st_atp_log st_comp_cong_absy if year==1900, mlabel(stateabbrev)ytitle(Per Capita Ad Valorem Taxes 1900) xtitle(Congressional Competitiveness) 

scatter  st_slxp_log st_comp_cong_absy if year==1900, mlabel(stateabbrev)ytitle(Total Per Capita State Expenditures 1900) xtitle(Congressional Competitiveness) 

scatter  st_slwp_log st_comp_cong_absy if year==1900, mlabel(stateabbrev)ytitle(Total Per Capita State Expenditures 1900) xtitle(Congressional Competitiveness) 

scatter  st_sexp_log st_comp_cong_absy if year==1900, mlabel(stateabbrev)ytitle(Per Capita State Education Expenditures 1900) xtitle(Congressional Competitiveness) 

scatter  st_slxp_log st_icg if year==1910, mlabel(stateabbrev)ytitle(Per Capita Total Expenditures 1910) xtitle(Gubernatorial Competitiveness) 

scatter  st_slwp_log st_icg if year==1910, mlabel(stateabbrev)ytitle(Per Capita State Welfare Expenditures 1910) xtitle(Gubernatorial Competitiveness) 

scatter  st_sexp_log st_icg if year==1910, mlabel(stateabbrev)ytitle(Per Capita State Education Expenditures 1910) xtitle(Gubernatorial Competitiveness) 




**politcal competition and redistribution

ivreg2 st_atp_log  (st_comp_cong_absy =st_totrain_anstd st_growdegdys_anstd) st_ttlpy state_area region if year==1900 ,r first  
outreg  st_comp_cong_absy  using pc , replace nolabel se coefastr 3aster bracket addstat(Overidentification Test, e(j), p-value, e(jp)) adec(2,3)

ivreg2 st_slxp_log  (st_comp_cong_absy=st_totrain_anstd st_growdegdys_anstd) st_ttlpy state_area region if year==1900 ,r first  
outreg  st_comp_cong_absy  using pc , append nolabel se coefastr 3aster bracket addstat(Overidentification Test, e(j), p-value, e(jp)) adec(2,3)

ivreg2 st_slwp_log  (st_comp_cong_absy=st_totrain_anstd st_growdegdys_anstd) st_ttlpy state_area region if year==1900,r first  
outreg  st_comp_cong_absy  using pc , append nolabel se coefastr 3aster bracket addstat(Overidentification Test, e(j), p-value, e(jp)) adec(2,3) 

ivreg2 st_sexp_log  (st_comp_cong_absy=st_totrain_anstd st_growdegdys_anstd) st_ttlpy state_area region if year==1900 ,r first  
outreg  st_comp_cong_absy  using pc , append nolabel se coefastr 3aster bracket addstat(Overidentification Test, e(j), p-value, e(jp)) adec(2,3)

ivreg2 st_slxp_log  (st_icg=st_totrain_anstd st_growdegdys_anstd) st_ttlpy state_area region if year==1910 ,r first  
outreg  st_icg using pc , append nolabel se coefastr 3aster bracket addstat(Overidentification Test, e(j), p-value, e(jp)) adec(2,3) 

ivreg2 st_slwp_log  (st_icg=st_totrain_anstd st_growdegdys_anstd) st_ttlpy state_area region if year==1910,r first  
outreg  st_icg using pc , append nolabel se coefastr 3aster bracket addstat(Overidentification Test, e(j), p-value, e(jp)) adec(2,3) 

ivreg2 st_sexp_log  (st_icg=st_totrain_anstd st_growdegdys_anstd) st_ttlpy state_area region if year==1910,r first  
outreg  st_icg using pc , append nolabel se coefastr 3aster bracket addstat(Overidentification Test, e(j), p-value, e(jp)) adec(2,3) 














