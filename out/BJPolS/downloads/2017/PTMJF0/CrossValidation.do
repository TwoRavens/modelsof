% Replication file for "The Strategic Origins of Electoral Authoritarianism" in British Journal of Political Science
% Written by Michael K. Miller, George Washington University



% Cross-validation calculation (Figure A1)

% Create separate .dta file

keep if rtxfix==1 & regtrans!=-66 & regtrans!=-77 & regtrans!=96 & regtrans!=98 & frtxfix!=. & p1!=. & demx_trade2!=. & igodem_interp!=. & igo!=.
keep rtxfix regtrans ccode frtxfix p1 p2 p3 loggdp frtxfix_ea frtxfix_dem urban_cow regiondemx regioneax eax_trade2 demx_trade2 igoea_interp igodem_interp igo d_cubdur1-d_cubdur7 bmr_prevauth easpelltotx irreggov5_c irregnongov5_c reg5_c ELF gdp_grow lnpop year
local counter "1"
gen insample = 0
generate random = 0

global base0 "d_cubdur1-d_cubdur7 bmr_prevauth easpelltotx irreggov5_c irregnongov5_c reg5_c ELF gdp_grow lnpop year"


forvalues i1 = 1/2000{

replace random = runiform()
sort random
replace insample = _n/_N < .9 

global base "$base0"
quietly mlogit frtxfix $base if insample==1, base(1)
local pr2 `e(r2_p)'
predict q1 q2 q3
quietly somersd q3 frtxfix_ea if insample==0
local somersd = _b[frtxfix_ea]
quietly somersd frtxfix_ea q3 if insample==0
local somersd_rev = _b[q3]
quietly somersd q2 frtxfix_dem if insample==0
local somersd_dem = _b[frtxfix_dem]
quietly somersd frtxfix_dem q2 if insample==0
local somersd_dem_rev = _b[q2]
local model "base"
if `counter'==1{
regsave using cross_base, addlabel(pr2,`pr2',somersd,`somersd',somersd_dem,`somersd_dem',somersd_rev,`somersd_rev',somersd_dem_rev,`somersd_dem_rev',model,`model')
}
if `counter'>1{
regsave using cross_base, append addlabel(pr2,`pr2',somersd,`somersd',somersd_dem,`somersd_dem',somersd_rev,`somersd_rev',somersd_dem_rev,`somersd_dem_rev',model,`model')
}
drop q1 q2 q3


global base "$base0 loggdp"
quietly mlogit frtxfix $base if insample==1, base(1)
local pr2 `e(r2_p)'
predict q1 q2 q3
quietly somersd q3 frtxfix_ea if insample==0
local somersd = _b[frtxfix_ea]
quietly somersd frtxfix_ea q3 if insample==0
local somersd_rev = _b[q3]
quietly somersd q2 frtxfix_dem if insample==0
local somersd_dem = _b[frtxfix_dem]
quietly somersd frtxfix_dem q2 if insample==0
local somersd_dem_rev = _b[q2]
local model "loggdp"

regsave using cross_base, append addlabel(pr2,`pr2',somersd,`somersd',somersd_dem,`somersd_dem',somersd_rev,`somersd_rev',somersd_dem_rev,`somersd_dem_rev',model,`model')

drop q1 q2 q3


global base "$base0 urban_cow"
quietly mlogit frtxfix $base if insample==1, base(1)
local pr2 `e(r2_p)'
predict q1 q2 q3
quietly somersd q3 frtxfix_ea if insample==0
local somersd = _b[frtxfix_ea]
quietly somersd frtxfix_ea q3 if insample==0
local somersd_rev = _b[q3]
quietly somersd q2 frtxfix_dem if insample==0
local somersd_dem = _b[frtxfix_dem]
quietly somersd frtxfix_dem q2 if insample==0
local somersd_dem_rev = _b[q2]
local model "urban"

regsave using cross_base, append addlabel(pr2,`pr2',somersd,`somersd',somersd_dem,`somersd_dem',somersd_rev,`somersd_rev',somersd_dem_rev,`somersd_dem_rev',model,`model')

drop q1 q2 q3


global base "$base0 regiondemx regioneax"
quietly mlogit frtxfix $base if insample==1, base(1)
local pr2 `e(r2_p)'
predict q1 q2 q3
quietly somersd q3 frtxfix_ea if insample==0
local somersd = _b[frtxfix_ea]
quietly somersd frtxfix_ea q3 if insample==0
local somersd_rev = _b[q3]
quietly somersd q2 frtxfix_dem if insample==0
local somersd_dem = _b[frtxfix_dem]
quietly somersd frtxfix_dem q2 if insample==0
local somersd_dem_rev = _b[q2]
local model "region"

regsave using cross_base, append addlabel(pr2,`pr2',somersd,`somersd',somersd_dem,`somersd_dem',somersd_rev,`somersd_rev',somersd_dem_rev,`somersd_dem_rev',model,`model')

drop q1 q2 q3


global base "$base0 eax_trade2 demx_trade2"
quietly mlogit frtxfix $base if insample==1, base(1)
local pr2 `e(r2_p)'
predict q1 q2 q3
quietly somersd q3 frtxfix_ea if insample==0
local somersd = _b[frtxfix_ea]
quietly somersd frtxfix_ea q3 if insample==0
local somersd_rev = _b[q3]
quietly somersd q2 frtxfix_dem if insample==0
local somersd_dem = _b[frtxfix_dem]
quietly somersd frtxfix_dem q2 if insample==0
local somersd_dem_rev = _b[q2]
local model "trade"

regsave using cross_base, append addlabel(pr2,`pr2',somersd,`somersd',somersd_dem,`somersd_dem',somersd_rev,`somersd_rev',somersd_dem_rev,`somersd_dem_rev',model,`model')

drop q1 q2 q3


global base "$base0 igodem_interp igoea_interp"
quietly mlogit frtxfix $base if insample==1, base(1)
local pr2 `e(r2_p)'
predict q1 q2 q3
quietly somersd q3 frtxfix_ea if insample==0
local somersd = _b[frtxfix_ea]
quietly somersd frtxfix_ea q3 if insample==0
local somersd_rev = _b[q3]
quietly somersd q2 frtxfix_dem if insample==0
local somersd_dem = _b[frtxfix_dem]
quietly somersd frtxfix_dem q2 if insample==0
local somersd_dem_rev = _b[q2]
local model "igodem"

regsave using cross_base, append addlabel(pr2,`pr2',somersd,`somersd',somersd_dem,`somersd_dem',somersd_rev,`somersd_rev',somersd_dem_rev,`somersd_dem_rev',model,`model')

drop q1 q2 q3


global base "$base0 igo"
quietly mlogit frtxfix $base if insample==1, base(1)
local pr2 `e(r2_p)'
predict q1 q2 q3
quietly somersd q3 frtxfix_ea if insample==0
local somersd = _b[frtxfix_ea]
quietly somersd frtxfix_ea q3 if insample==0
local somersd_rev = _b[q3]
quietly somersd q2 frtxfix_dem if insample==0
local somersd_dem = _b[frtxfix_dem]
quietly somersd frtxfix_dem q2 if insample==0
local somersd_dem_rev = _b[q2]
local model "igo"

regsave using cross_base, append addlabel(pr2,`pr2',somersd,`somersd',somersd_dem,`somersd_dem',somersd_rev,`somersd_rev',somersd_dem_rev,`somersd_dem_rev',model,`model')

drop q1 q2 q3


global base "$base0 igo igodem_interp igoea_interp eax_trade2 demx_trade2 regiondemx regioneax loggdp urban_cow"
quietly mlogit frtxfix $base if insample==1, base(1)
local pr2 `e(r2_p)'
predict q1 q2 q3
quietly somersd q3 frtxfix_ea if insample==0
local somersd = _b[frtxfix_ea]
quietly somersd frtxfix_ea q3 if insample==0
local somersd_rev = _b[q3]
quietly somersd q2 frtxfix_dem if insample==0
local somersd_dem = _b[frtxfix_dem]
quietly somersd frtxfix_dem q2 if insample==0
local somersd_dem_rev = _b[q2]
local model "full"

regsave using cross_base, append addlabel(pr2,`pr2',somersd,`somersd',somersd_dem,`somersd_dem',somersd_rev,`somersd_rev',somersd_dem_rev,`somersd_dem_rev',model,`model')

drop q1 q2 q3


global base1 "d_cubdur1-d_cubdur7 bmr_prevauth easpelltotx year"
quietly mlogit frtxfix $base1 if insample==1, base(1)
local pr2 `e(r2_p)'
predict q1 q2 q3
quietly somersd q3 frtxfix_ea if insample==0
local somersd = _b[frtxfix_ea]
quietly somersd frtxfix_ea q3 if insample==0
local somersd_rev = _b[q3]
quietly somersd q2 frtxfix_dem if insample==0
local somersd_dem = _b[frtxfix_dem]
quietly somersd frtxfix_dem q2 if insample==0
local somersd_dem_rev = _b[q2]
local model "min"

regsave using cross_base, append addlabel(pr2,`pr2',somersd,`somersd',somersd_dem,`somersd_dem',somersd_rev,`somersd_rev',somersd_dem_rev,`somersd_dem_rev',model,`model')

drop q1 q2 q3


local counter "2"

}





encode model, gen(model2)
gen model3 = model2
replace model3 = . if model2==6
replace model3 = 2 if model2==9
replace model3 = 3 if model2==5
replace model3 = 4 if model2==7
replace model3 = 5 if model2==3
replace model3 = 6 if model2==8
replace model3 = 7 if model2==4
replace model3 = 8 if model2==2

gen model4 = model2
replace model4 = . if model2==6
replace model4 = 2 if model2==8
replace model4 = 3 if model2==5
replace model4 = 4 if model2==9
replace model4 = 5 if model2==4
replace model4 = 6 if model2==7
replace model4 = 7 if model2==3
replace model4 = 8 if model2==2

set scheme s1color
ciplot somersd_rev, by(model3) hor

ciplot somersd_dem_rev, by(model4) hor



