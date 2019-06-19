 **an alternative measure of inequality: the small ratio
*first stage
*1930 
use 1930.dta, clear 
drop if fips==6019 | fips==6107 | fips==6039 | fips==6109 | fips==6095 | fips==16067 | fips==41025 | fips==53053

reg small_ratio ltotrain_anstd lgrowdegdys_anstd stdev_elev vfmagr_pfy ubp_sharey  pop_densy nwp_sharey ngp_sharey shypy  lttlpy county_area state_dum*  if year==1930  
outreg  ltotrain_anstd lgrowdegdys_anstd stdev_elev using alt_ins, replace nolabel nocons se coefastr 3aster bracket 
*1920 
use 1920.dta, clear 
reg small_ratio ltotrain_anstd lgrowdegdys_anstd stdev_elev ubp_sharey  pop_densy nwp_sharey ngp_sharey shypy  lttlpy county_area state_dum*  if year==1920  
outreg  ltotrain_anstd lgrowdegdys_anstd stdev_elev using alt_ins, append nolabel nocons se coefastr 3aster bracket 

*second stage
use 1930.dta, clear 
drop if fips==6019 | fips==6107 | fips==6039 | fips==6109 | fips==6095 | fips==16067 | fips==41025 | fips==53053

ivreg2 led_sp_pcy (small_ratio small_NS= ltotrain_anstd lgrowdegdys_anstd stdev_elev ) NS vfmagr_pfy ubp_sharey  pop_densy nwp_sharey ngp_sharey shypy  lttlpy county_area state_dum*  if year==1930  , r   liml
outreg  small_ratio small_NS using alt_ins , append nolabel nocons se coefastr 3aster bracket addstat(Overidentification Test, e(arubin), p-value, e(arubinp)) adec(2,3)

ivreg2 ltaxc_pcy (small_ratio small_NS= ltotrain_anstd lgrowdegdys_anstd stdev_elev ) vfmagr_pfy ubp_sharey  pop_densy nwp_sharey ngp_sharey shypy  lttlpy county_area state_dum*  if year==1930  , r liml
outreg  small_ratio small_NS using alt_ins , append nolabel nocons se coefastr 3aster bracket addstat(Overidentification Test, e(arubin), p-value, e(arubinp)) adec(2,3)

