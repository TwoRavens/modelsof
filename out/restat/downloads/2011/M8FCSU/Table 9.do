 ****instrument sensitivity

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


**1890 instrument
ivreg2 led_sp_pcy (giniy= giniy_1890) vfmagr_pfy ubp_sharey  pop_densy nwp_sharey ngp_sharey shypy  lttlpy county_area state_dum* region_dum* if year==1930, r   first 
outreg  giniy using ins_sens , append nolabel nocons se coefastr 3aster bracket 
x_gmm longitude_km latitude_km  longitude_km_cutoff latitude_km_cutoff led_sp_pcy_spa const giniy_spa vfmagr_pfy_spa ubp_sharey_spa  pop_densy_spa nwp_sharey_spa ngp_sharey_spa shypy_spa lttlpy_spa county_area_spa const giniy_1890_spa vfmagr_pfy_spa ubp_sharey_spa  pop_densy_spa nwp_sharey_spa ngp_sharey_spa shypy_spa lttlpy_spa county_area_spa , coord(2) xreg(10) inst(10)
drop dis1 dis2 zubar*

ivreg2 ltaxc_pcy (giniy= giniy_1890) vfmagr_pfy ubp_sharey  pop_densy nwp_sharey ngp_sharey shypy  lttlpy county_area state_dum* region_dum* if year==1930, r   first 
outreg  giniy using ins_sens , append nolabel nocons se coefastr 3aster bracket 
x_gmm longitude_km latitude_km  longitude_km_cutoff latitude_km_cutoff ltaxc_pcy_spa const giniy_spa vfmagr_pfy_spa ubp_sharey_spa  pop_densy_spa nwp_sharey_spa ngp_sharey_spa shypy_spa lttlpy_spa county_area_spa const giniy_1890_spa vfmagr_pfy_spa ubp_sharey_spa  pop_densy_spa nwp_sharey_spa ngp_sharey_spa shypy_spa lttlpy_spa county_area_spa , coord(2) xreg(10) inst(10)
drop dis1 dis2 zubar*

*Average Rainfall
ivreg2 led_sp_pcy (giniy=  totrain_anave )  vfmagr_pfy ubp_sharey  pop_densy nwp_sharey ngp_sharey shypy  lttlpy county_area state_dum* region_dum* if year==1930, r   first 
outreg  giniy using ins_sens , replace nolabel nocons se coefastr 3aster bracket addstat(Overidentification Test, e(j), p-value, e(jp)) adec(2,3)
x_gmm longitude_km latitude_km  longitude_km_cutoff latitude_km_cutoff led_sp_pcy_spa const giniy_spa vfmagr_pfy_spa ubp_sharey_spa  pop_densy_spa nwp_sharey_spa ngp_sharey_spa shypy_spa lttlpy_spa county_area_spa const ltotrain_anstd_spa lgrowdegdys_anstd_spa stdev_elev_spa totrain_anave_spa vfmagr_pfy_spa ubp_sharey_spa  pop_densy_spa nwp_sharey_spa ngp_sharey_spa shypy_spa lttlpy_spa county_area_spa , coord(2) xreg(10) inst(13)
drop dis1 dis2 zubar*

ivreg2 ltaxc_pcy (giniy=  totrain_anave ) vfmagr_pfy ubp_sharey  pop_densy nwp_sharey ngp_sharey shypy  lttlpy county_area state_dum* region_dum* if year==1930, r   first 
outreg  giniy using ins_sens , append nolabel nocons se coefastr 3aster bracket addstat(Overidentification Test, e(j), p-value, e(jp)) adec(2,3)
x_gmm longitude_km latitude_km  longitude_km_cutoff latitude_km_cutoff ltaxc_pcy_spa const giniy_spa ubp_sharey_spa  pop_densy_spa nwp_sharey_spa ngp_sharey_spa shypy_spa lttlpy_spa county_area_spa const ltotrain_anstd_spa lgrowdegdys_anstd_spa stdev_elev_spa totrain_anave_spa ubp_sharey_spa  pop_densy_spa nwp_sharey_spa ngp_sharey_spa shypy_spa lttlpy_spa county_area_spa , coord(2) xreg(9) inst(12)
drop dis1 dis2 zubar*



**use crops as instruments:
ivreg2 led_sp_pcy (giniy=vfruy_share vcery_share vgarvegy_share  )  vfmagr_pfy ubp_sharey pop_densy nwp_sharey ngp_sharey shypy lttlpy county_area state_dum* region_dum*  if year==1930, r   first 

ivreg2 ltaxc_pcy (giniy=vfruy_share vcery_share vgarvegy_share )  vfmagr_pfy ubp_sharey pop_densy nwp_sharey ngp_sharey shypy lttlpy county_area state_dum* region_dum*  if year==1930, r   first 


