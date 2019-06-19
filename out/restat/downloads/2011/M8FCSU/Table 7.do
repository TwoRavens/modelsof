*************************************Table 7: 1930 education expenditures
use "1930_tables.dta", replace 
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

*ols
 reg led_sp_pcy giniy lttlpy county_area state_dum*   if year==1930, r   
outreg  giniy using edu_1930 , replace nolabel nocons se coefastr 3aster bracket 
x_ols  longitude_km latitude_km  longitude_km_cutoff latitude_km_cutoff  led_sp_pcy_spa giniy_spa lttlpy_spa county_area_spa const, coord(2) xreg(4)
drop epsilon window dis1 dis2

*iv min
ivreg2 led_sp_pcy (giniy=stdev_elev ltotrain_anstd lgrowdegdys_anstd)  lttlpy county_area state_dum*   if year==1930, r   first 
outreg  giniy using edu_1930 , append nolabel nocons se coefastr 3aster bracket addstat(Overidentification Test, e(j), p-value, e(jp), R-Squared, e(r2c)) adec(2,3)
x_gmm longitude_km latitude_km  longitude_km_cutoff latitude_km_cutoff led_sp_pcy_spa const giniy_spa lttlpy_spa county_area_spa const ltotrain_anstd_spa lgrowdegdys_anstd_spa stdev_elev_spa lttlpy_spa county_area_spa , coord(2) xreg(4) inst(6)
drop  dis1 dis2 zubar*

*iv max
ivreg2 led_sp_pcy (giniy=  ltotrain_anstd lgrowdegdys_anstd stdev_elev) vfmagr_pfy ubp_sharey  pop_densy nwp_sharey ngp_sharey shypy lttlpy county_area state_dum* if year==1930, r   first 
outreg  giniy using edu_1930 , append nolabel nocons se coefastr 3aster bracket addstat(Overidentification Test, e(j), p-value, e(jp)) adec(2,3)
x_gmm longitude_km latitude_km  longitude_km_cutoff latitude_km_cutoff led_sp_pcy_spa const giniy_spa vfmagr_pfy_spa ubp_sharey_spa  pop_densy_spa nwp_sharey_spa ngp_sharey_spa shypy_spa lttlpy_spa county_area_spa const ltotrain_anstd_spa lgrowdegdys_anstd_spa stdev_elev_spa vfmagr_pfy_spa ubp_sharey_spa  pop_densy_spa nwp_sharey_spa ngp_sharey_spa shypy_spa lttlpy_spa county_area_spa , coord(2) xreg(10) inst(12)
drop  dis1 dis2 zubar*

*NS interaction term
ivreg2 led_sp_pcy (giniy giniy_NS= ltotrain_anstd lgrowdegdys_anstd stdev_elev stdev_elev_sq) vfmagr_pfy ubp_sharey  pop_densy nwp_sharey ngp_sharey shypy NS lttlpy county_area state_dum*  if year==1930, r   first 
outreg  giniy giniy_NS using edu_1930 , append nolabel nocons se coefastr 3aster bracket addstat(Overidentification Test, e(j), p-value, e(jp)) adec(2,3)
x_gmm longitude_km latitude_km  longitude_km_cutoff latitude_km_cutoff led_sp_pcy_spa const giniy_spa giniy_NS_spa vfmagr_pfy_spa ubp_sharey_spa  pop_densy_spa nwp_sharey_spa ngp_sharey_spa shypy_spa lttlpy_spa county_area_spa const ltotrain_anstd_spa lgrowdegdys_anstd_spa stdev_elev_spa stdev_elev_sq_spa vfmagr_pfy_spa ubp_sharey_spa  pop_densy_spa nwp_sharey_spa ngp_sharey_spa shypy_spa lttlpy_spa county_area_spa , coord(2) xreg(11) inst(13)
drop dis1 dis2 zubar*

*Race interaction terms 
sort sc_no year
foreach v in giniy ltotrain_anstd {
foreach c in ngp_sharey nwp_sharey {
by sc_no: g `v'_`c'=`v'*`c'
}
}

*include both black and white
ivreg2 led_sp_pcy (giniy giniy_ngp_sharey =  ltotrain_anstd ltotrain_anstd_nwp_sharey ltotrain_anstd_ngp_sharey lgrowdegdys_anstd stdev_elev)  vfmagr_pfy ubp_sharey  pop_densy  ngp_sharey nwp_sharey shypy lttlpy county_area state_dum* region_dum* if year==1930 , r   first 


** Texas
ivreg2 led_sp_pcy (giniy= ltotrain_anstd lgrowdegdys_anstd stdev_elev)   lttlpy county_area state_dum* region_dum* if year==1930 & stateabbrev=="TX", r   first liml
outreg  giniy using edu_1930 , append nolabel nocons se coefastr 3aster bracket addstat(Overidentification Test, e(j), p-value, e(jp)) adec(2,3)

condivreg led_sp_pcy (giniy= ltotrain_anstd lgrowdegdys_anstd stdev_elev)   lttlpy county_area if year==1930 & stateabbrev=="TX",   liml 
outreg  giniy using edu_1930 , append nolabel nocons se coefastr 3aster bracket addstat(Overidentification Test, e(j), p-value, e(jp)) adec(2,3)

