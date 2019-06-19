/*
use 1930.dta, clear
keep fips state_fips giniy_ubp giniy_nom state_dum* small_ratio small_NS giniy_1890 totrain_anave vfruy_share vcery_share vgarvegy_share  region region_dum* year led_sp_pcy ltaxc_pcy lttlpy county_area giniy vforpdy_share vfruy_share vcery_share vgarvegy_share vvegy_share vothcery_share vfmagr_pfy ubp_sharey pop_densy nwp_sharey shypy ngp_sharey ltotrain_anstd lgrowdegdys_anstd stdev_elev mean_elev totrain_anave stdev_elev_NS ltotrain_anstd_NS lgrowdegdys_anstd_NS NS giniy_NS stdev_elev_sq giniy_1890 ltotrain_anstd_ubp giniy_ubp nom_pcy ltotrain_anstd_nom giniy_nom year
drop if year!=1930
save "1930_table_11.dta", replace  
outsheet using "1930_table.raw", replace
*/

insheet using "1930_table.raw", clear


**urban interaction
ivreg2 led_sp_pcy (giniy giniy_ubp= ltotrain_anstd lgrowdegdys_anstd stdev_elev ltotrain_anstd_ubp) vfmagr_pfy ubp_sharey  pop_densy nwp_sharey ngp_sharey shypy  lttlpy county_area state_dum* region_dum* if year==1930, r   first 
outreg  giniy giniy_ubp using urban, replace nolabel nocons se coefastr 3aster bracket addstat(Overidentification Test, e(j), p-value, e(jp)) adec(2,3)
x_gmm longitude_km latitude_km  longitude_km_cutoff latitude_km_cutoff led_sp_pcy_spa const giniy_spa giniy_ubp_spa vfmagr_pfy_spa ubp_sharey_spa  pop_densy_spa nwp_sharey_spa ngp_sharey_spa shypy_spa lttlpy_spa county_area_spa const ltotrain_anstd_spa lgrowdegdys_anstd_spa stdev_elev_spa ltotrain_anstd_ubp_spa vfmagr_pfy_spa ubp_sharey_spa  pop_densy_spa nwp_sharey_spa ngp_sharey_spa shypy_spa lttlpy_spa county_area_spa , coord(2) xreg(11) inst(13)
drop dis1 dis2 zubar*

 ivreg2 ltaxc_pcy (giniy giniy_ubp= ltotrain_anstd lgrowdegdys_anstd stdev_elev ltotrain_anstd_ubp) vfmagr_pfy ubp_sharey  pop_densy nwp_sharey ngp_sharey shypy  lttlpy county_area state_dum* region_dum* if year==1930, r   first 
outreg  giniy giniy_ubp using urban, append nolabel nocons se coefastr 3aster bracket addstat(Overidentification Test, e(j), p-value, e(jp)) adec(2,3)
x_gmm longitude_km latitude_km  longitude_km_cutoff latitude_km_cutoff ltaxc_pcy_spa const giniy_spa giniy_ubp_spa vfmagr_pfy_spa ubp_sharey_spa  pop_densy_spa nwp_sharey_spa ngp_sharey_spa shypy_spa lttlpy_spa county_area_spa const ltotrain_anstd_spa lgrowdegdys_anstd_spa stdev_elev_spa ltotrain_anstd_ubp_spa vfmagr_pfy_spa ubp_sharey_spa  pop_densy_spa nwp_sharey_spa ngp_sharey_spa shypy_spa lttlpy_spa county_area_spa , coord(2) xreg(11) inst(13)
drop dis1 dis2 zubar*


*per capita manuf
ivreg2 led_sp_pcy (giniy giniy_nom= ltotrain_anstd lgrowdegdys_anstd stdev_elev ltotrain_anstd_nom) nom_pcy vfmagr_pfy ubp_sharey  pop_densy nwp_sharey ngp_sharey shypy  lttlpy county_area state_dum* region_dum* if year==1930, r   
outreg  giniy giniy_nom using urban, append nolabel nocons se coefastr 3aster bracket addstat(Overidentification Test, e(j), p-value, e(jp)) adec(2,3)
x_gmm longitude_km latitude_km  longitude_km_cutoff latitude_km_cutoff led_sp_pcy_spa const giniy_spa giniy_nom_spa nom_pcy_spa vfmagr_pfy_spa ubp_sharey_spa  pop_densy_spa nwp_sharey_spa ngp_sharey_spa shypy_spa lttlpy_spa county_area_spa const ltotrain_anstd_spa lgrowdegdys_anstd_spa stdev_elev_spa ltotrain_anstd_nom_spa nom_pcy_spa vfmagr_pfy_spa ubp_sharey_spa  pop_densy_spa nwp_sharey_spa ngp_sharey_spa shypy_spa lttlpy_spa county_area_spa , coord(2) xreg(12) inst(14)
drop dis1 dis2 zubar*

ivreg2 ltaxc_pcy (giniy giniy_nom= ltotrain_anstd lgrowdegdys_anstd stdev_elev ltotrain_anstd_nom) nom_pcy  vfmagr_pfy ubp_sharey  pop_densy nwp_sharey ngp_sharey shypy  lttlpy county_area state_dum* region_dum* if year==1930, r   first 
outreg  giniy giniy_nom using urban, append nolabel nocons se coefastr 3aster bracket addstat(Overidentification Test, e(j), p-value, e(jp)) adec(2,3)
x_gmm longitude_km latitude_km  longitude_km_cutoff latitude_km_cutoff ltaxc_pcy_spa const giniy_spa giniy_nom_spa nom_pcy_spa vfmagr_pfy_spa ubp_sharey_spa  pop_densy_spa nwp_sharey_spa ngp_sharey_spa shypy_spa lttlpy_spa county_area_spa const ltotrain_anstd_spa lgrowdegdys_anstd_spa stdev_elev_spa ltotrain_anstd_nom_spa nom_pcy_spa vfmagr_pfy_spa ubp_sharey_spa  pop_densy_spa nwp_sharey_spa ngp_sharey_spa shypy_spa lttlpy_spa county_area_spa , coord(2) xreg(12) inst(14)
drop dis1 dis2 zubar*

