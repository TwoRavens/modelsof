/*do file name: BeiJing.do,

Analyze land price and FAR data for Beijing only
Created by Junfu Zhang on 4/16/2015

*/

clear matrix


log using BeiJing_log, t replace

set more off


use BeijingResidentialLandData.dta
sort newid

merge m:1 newid using SiteAttributes.dta

tab _merge

//Sunnary stats for distance to Tiananmen / CBD
sum dist2tam dist2cbd, detail
sum dist2tam dist2cbd


//Site attributes: dist2cbd dist2finstr dist2highschool dist2park dist2raistation dist2road dist2tam dist2zgc

ge log_dist2cbd = log(dist2cbd)
ge log_dist2highschool = log(dist2highschool)
ge log_dist2park = log(dist2park)
ge log_dist2road = log(dist2road)
ge log_dist2tam = log(dist2tam)

sort district
by district: sum log_dist2tam

gen lnlandprice=log(landprice)
gen lnmaxfar=log(maxfloorlotratio)


xi: reg lnlandprice lnmaxfar i.year
// *** Table 4, col(1) *** 
xi: reg lnlandprice lnmaxfar log_dist2cbd log_dist2road log_dist2park log_dist2highschool i.year, cl(district) 
// *** Table 4, col(2) *** 
xi: ivregress 2sls lnlandprice log_dist2cbd log_dist2road log_dist2park log_dist2highschool i.year (lnmaxfar = i.district), first cl(district)

xi: ivregress 2sls lnlandprice log_dist2cbd log_dist2road log_dist2park log_dist2highschool i.year (lnmaxfar = i.district), first
estat firststage
estat overid

gen lnmaxfar_log_dist2tam = lnmaxfar*log_dist2tam

xi: ivregress 2sls lnlandprice log_dist2cbd log_dist2road log_dist2park log_dist2highschool i.year ///
(lnmaxfar_log_dist2tam = i.district|log_dist2tam), first cl(district)
estat firststage

xi: ivregress 2sls lnlandprice log_dist2cbd log_dist2road log_dist2park log_dist2highschool i.year ///
(lnmaxfar_log_dist2tam = i.district|log_dist2tam), first
estat firststage
estat overid

// *** Table 4, col(3) *** 
xi: regr lnlandprice lnmaxfar lnmaxfar_log_dist2tam log_dist2cbd log_dist2road log_dist2park log_dist2highschool i.year, ///
cl(district)
// *** Table 4, col(4) *** 
xi: ivregress 2sls lnlandprice log_dist2cbd log_dist2road log_dist2park log_dist2highschool i.year ///
(lnmaxfar lnmaxfar_log_dist2tam = i.district*log_dist2tam), first cl(district)
estat firststage

xi: ivregress 2sls lnlandprice log_dist2cbd log_dist2road log_dist2park log_dist2highschool i.year ///
(lnmaxfar lnmaxfar_log_dist2tam = i.district*log_dist2tam), first
estat firststage
estat overid

xi: ivregress 2sls lnlandprice log_dist2tam log_dist2road log_dist2park log_dist2highschool i.year ///
(lnmaxfar lnmaxfar_log_dist2tam = i.district*log_dist2tam), first cl(district)
estat firststage

gen lnmaxfar_log_dist2cbd = lnmaxfar*log_dist2cbd

xi: ivregress 2sls lnlandprice log_dist2cbd log_dist2road log_dist2park log_dist2highschool i.year ///
(lnmaxfar lnmaxfar_log_dist2cbd = i.district*log_dist2tam), first cl(district)
estat firststage

/*********************************************
Use the matched sample for Beijing, 4/19/2015
**********************************************/

count
sort district year address

ge address12 =  substr( address, 1, 24)
count if district==district[_n-1] & year==year[_n-1] & address12== address12[_n-1]


ge pair = .
replace pair = _n if district==district[_n-1] & year==year[_n-1] & ///
address12== address12[_n-1]

replace pair = _n if district==district[_n+1] & year==year[_n+1] & ///
address12== address12[_n+1]

replace pair = pair[_n-1] if pair != . & pair[_n-1] != . ///
& district==district[_n-1] & year==year[_n-1] & ///
address12== address12[_n-1]

xi: areg lnlandprice lnmaxfar, a(pair)
xi: areg lnlandprice lnmaxfar lnmaxfar_log_dist2tam log_dist2cbd, a(pair)
xi: areg lnlandprice lnmaxfar lnmaxfar_log_dist2tam log_dist2cbd log_dist2road log_dist2park log_dist2highschool, a(pair)

clear
log close
