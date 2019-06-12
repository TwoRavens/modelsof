clear
set memory 80m
set matsize 800
cd "C:\Documents and Settings\Matt Potoski\My Documents\Aseem\FDI paper\Data\"
use isq.dta, clear

/* variables
iso14: ISO 14001 certifications
expgdpl: Exports
cohesion1el: Bilateral Exports weighted by ISO Adoption
fdicoh1l: Bilateral FDI weighted by ISO Adoption
gdp1: GDP
gdp3l: Per Capita GDP
gdp32l: Per Capita GDP (squared)
regu: regulations
so2l: so2 emmissions
neighbl: neighbor context
langl: language
nintl:  intergovernmental organizations
nonl: nongovernmental organizations
fdigdpl: Overall FDI 
iso9l: ISO 9000
c1-c106: country dummies
country: country code
year: year
indx: imputation index
*/

* defining globals (easier to keep track of stuff)
global dv1= "iso14"
global ecglobs= "expgdpl cohesion1el fdicoh1l gdp1 gdp3l gdp32l regu so2l "
global soglob ="neighbl langl nintl nonl fdigdpl  iso9l c1-c106  " 



* RUN THE MODEL 7 TIMES, SAVING THE RESULTS

#delimit ;
keep if indx == 1;
xtgee $dv1 $ecglobs $soglob if indx==1,  i(country) t(year) fam(nb) link(log) corr(ar1)  iterate(10000)  robust  ;
#delimit cr
matrix ab1 = get(_b)
svmat ab1
matrix V = get(VCE)
matrix av1 = vecdiag(V)
svmat av1
ge alpha = e(phi)
ge chisquare= e(chi2)
ge loglik = e(chi2_dis)
predict resids1
test neighbl langl 
ge rtestp = r(p)
ge rtestc = r(chi2)
save isq1a.dta, replace

use isq.dta, replace
keep if indx == 2
#delimit ;
 tsset country year, yearly;
xtgee $dv1 $ecglobs $soglob if indx==2,  i(country) t(year) fam(nb) link(log) corr(ar1) iterate(10000)  robust;
#delimit cr
matrix ab2 = get(_b)
svmat ab2
matrix V = get(VCE)
matrix av2 = vecdiag(V)
svmat av2
gen alpha= e(phi) if indx==2
gen chisquare= e(chi2) if indx==2
gen loglik = e(chi2_dis)   if indx==2
predict resids1
test nintl nonl 
ge rtestp = r(p)
ge rtestc = r(chi2)
sort country year
save isq2a.dta, replace

use isq.dta, replace
keep if indx == 3
#delimit ;
 tsset country year, yearly;
xtgee $dv1 $ecglobs $soglob if indx==3,  i(country) t(year) fam(nb) link(log) corr(ar1) iterate(10000)  robust;
#delimit cr
matrix ab3 = get(_b)
svmat ab3
matrix V = get(VCE)
matrix av3 = vecdiag(V)
svmat av3
gen alpha= e(phi) if indx==3
gen chisquare= e(chi2) if indx==3
gen loglik = e(chi2_dis)   if indx==3
sort country year
predict resids1
test nintl nonl 
ge rtestp = r(p)
ge rtestc = r(chi2)
save isq3a.dta, replace

use isq.dta, replace
keep if indx == 4
#delimit ;
tsset country year, yearly;
xtgee $dv1 $ecglobs $soglob if indx==4,  i(country) t(year) fam(nb) link(log) corr(ar1) iterate(10000)  robust;
#delimit cr
matrix ab4 = get(_b)
svmat ab4
matrix V = get(VCE)
matrix av4 = vecdiag(V)
svmat av4
gen alpha= e(phi) if indx==4
gen chisquare= e(chi2) if indx==4
gen loglik = e(chi2_dis)   if indx==4
predict resids1
test nintl nonl 
ge rtestp = r(p)
ge rtestc = r(chi2)
sort country year
save isq4a.dta, replace

use isq.dta, replace
keep if indx == 5
#delimit ;
tsset country year, yearly;
xtgee $dv1 $ecglobs $soglob if indx==5,  i(country) t(year) fam(nb) link(log) corr(ar1) iterate(10000)  robust;
#delimit cr
matrix ab5 = get(_b)
svmat ab5
matrix V = get(VCE)
matrix av5 = vecdiag(V)
svmat av5
gen alpha= e(phi) if indx==5
gen chisquare= e(chi2) if indx==5
gen loglik = e(chi2_dis)   if indx==5
predict resids1
test nintl nonl 
ge rtestp = r(p)
ge rtestc = r(chi2)
sort country year
save isq5a.dta, replace

use isq.dta, replace
keep if indx == 6
#delimit ;
tsset country year, yearly;
xtgee $dv1 $ecglobs $soglob if indx==6,  i(country) t(year) fam(nb) link(log) corr(ar1) iterate(10000)  robust;
#delimit cr
matrix ab6 = get(_b)
svmat ab6
matrix V = get(VCE)
matrix av6 = vecdiag(V)
svmat av6
gen alpha= e(phi) if indx==6
gen chisquare= e(chi2) if indx==6
gen loglik = e(chi2_dis)   if indx==6
predict resids1
test nintl nonl 
ge rtestp = r(p)
ge rtestc = r(chi2)
sort country year
save isq6a.dta, replace

use isq.dta, replace
keep if indx == 7
#delimit ;
tsset country year, yearly;
xtgee $dv1 $ecglobs $soglob if indx==7,  i(country) t(year) fam(nb) link(log) corr(ar1) iterate(10000)  robust;
#delimit cr
matrix ab7 = get(_b)
svmat ab7
matrix V = get(VCE)
matrix av7 = vecdiag(V)
svmat av7
gen alpha= e(phi) if indx==7
gen chisquare= e(chi2) if indx==7
gen loglik = e(chi2_dis)   if indx==7
predict resids1
test nintl nonl 
ge rtestp = r(p)
ge rtestc = r(chi2)
sort country year
save isq7a.dta, replace

* merging data back together
use isq1a.dta, clear
append using isq2a.dta
append using isq3a.dta
append using isq4a.dta
append using isq5a.dta
append using isq6a.dta
append using isq7a.dta


*  AGGREGATE THE RESULTS ACROSS DATA SETS
matrix point = (ab1 + ab2 + ab3 + ab4 + ab5 + ab6 + ab7 )/7
matrix var = point
local num = 1
while `num' <=colsof(point) {
	#delimit ;
      matrix var[1,`num'] = ((ab1[1,`num']- point[1,`num'])^2 + (ab2[1,`num']- point[1,`num'])^2
                 + (ab3[1,`num']- point[1,`num'])^2 + (ab4[1,`num']- point[1,`num'])^2
                 + (ab5[1,`num']- point[1,`num'])^2 + (ab6[1,`num']- point[1,`num'])^2
                 + (ab7[1,`num']- point[1,`num'])^2 )/6;
      #delimit cr
      local num = `num' + 1
      }
 
matrix var2 = var*11/10 + (av1 + av2 + av3 + av4 + av5 + av6 + av7)/7
matrix se = var2
matrix zz = var2
local nn = 1
while `nn' <=colsof(point) {
	matrix se[1,`nn'] = sqrt(var2[1,`nn'])
      matrix zz[1,`nn'] = point[1,`nn']/se[1,`nn']
      local nn = `nn' + 1
      }

matrix results = point \ se \ zz
log using ISQMainResults.log, replace
matrix list results
summarize alpha if indx!=indx[_n+1]
summarize chisquare if indx!=indx[_n+1]
summarize loglik if indx!=indx[_n+1]
summarize rtestp if indx!=indx[_n+1]
summarize rtestc if indx!=indx[_n+1]
log close

* NOW REPEATING FOR NONDEVELOPED COUNTRIES

use use.dta, clear

drop if nondevelop == 1
* RUN THE MODEL 5 TIMES, SAVING THE RESULTS;
rename code country
save pcse.dta, replace



* RUN THE MODEL 10 TIMES, SAVING THE RESULTS;
#delimit ;
keep if indx == 1;
xtgee $dv1 $ecglobs $soglob $ccs if indx==1,  i(country) t(year) fam(nb) link(log)   corr(ar1)  iterate(10000) robust ;
#delimit cr
matrix ab1 = get(_b)
svmat ab1
matrix V = get(VCE)
matrix av1 = vecdiag(V)
svmat av1
ge alpha = e(phi)
ge chisquare= e(chi2)
ge loglik = e(chi2_dis)
predict resids1
test neighbl langl
ge rtestp = r(p)
ge rtestc = r(chi2)
 save pcse1a.dta, replace

use pcse.dta, replace
keep if indx == 2

#delimit ;
 tsset country year, yearly;
xtgee $dv1 $ecglobs $soglob $ccs if indx==2,  i(country) t(year) fam(nb) link(log)   corr(ar1)  iterate(10000) robust ;

#delimit cr
 
matrix ab2 = get(_b)
svmat ab2
matrix V = get(VCE)
matrix av2 = vecdiag(V)
svmat av2
gen alpha= e(phi) if indx==2
gen chisquare= e(chi2) if indx==2
gen loglik = e(chi2_dis)   if indx==2
predict resids1
test neighbl langl
ge rtestp = r(p)
ge rtestc = r(chi2)
sort country year
 save pcse2a.dta, replace
use pcse.dta, replace
keep if indx == 3

#delimit ;
 tsset country year, yearly;
xtgee $dv1 $ecglobs $soglob $ccs if indx==3,  i(country) t(year) fam(nb) link(log) corr(ar1)  iterate(10000) robust ;
#delimit cr
 
matrix ab3 = get(_b)
svmat ab3
matrix V = get(VCE)
matrix av3 = vecdiag(V)
svmat av3
gen alpha= e(phi) if indx==3
gen chisquare= e(chi2) if indx==3
gen loglik = e(chi2_dis)   if indx==3
sort country year
predict resids1
test neighbl langl
ge rtestp = r(p)
ge rtestc = r(chi2)

 save pcse3a.dta, replace
use pcse.dta, replace
keep if indx == 4
#delimit ;
 tsset country year, yearly;
xtgee $dv1 $ecglobs $soglob $ccs if indx==4,  i(country) t(year) fam(nb) link(log)   corr(ar1)  iterate(10000) robust ;
#delimit cr

matrix ab4 = get(_b)
svmat ab4
matrix V = get(VCE)
matrix av4 = vecdiag(V)
svmat av4
gen alpha= e(phi) if indx==4
gen chisquare= e(chi2) if indx==4
gen loglik = e(chi2_dis)   if indx==4

predict resids1
test neighbl langl
ge rtestp = r(p)
ge rtestc = r(chi2)
sort country year
 save pcse4a.dta, replace
use pcse.dta, replace
keep if indx == 5

#delimit ;
 tsset country year, yearly;
xtgee $dv1 $ecglobs $soglob $ccs if indx==5,  i(country) t(year) fam(nb) link(log)   corr(ar1)  iterate(10000) robust ;
#delimit cr
 
matrix ab5 = get(_b)
svmat ab5
matrix V = get(VCE)
matrix av5 = vecdiag(V)
svmat av5
gen alpha= e(phi) if indx==5
gen chisquare= e(chi2) if indx==5
gen loglik = e(chi2_dis)   if indx==5
 
predict resids1
test neighbl langl
ge rtestp = r(p)
ge rtestc = r(chi2)
sort country year
 save pcse5a.dta, replace
use pcse.dta, replace
 keep if indx == 6
#delimit ;
 tsset country year, yearly;
xtgee $dv1 $ecglobs $soglob $ccs if indx==6,  i(country) t(year) fam(nb) link(log)   corr(ar1)  iterate(10000) robust ;

#delimit cr
 
matrix ab6 = get(_b)
svmat ab6
matrix V = get(VCE)
matrix av6 = vecdiag(V)
svmat av6
gen alpha= e(phi) if indx==6
gen chisquare= e(chi2) if indx==6
gen loglik = e(chi2_dis)   if indx==6
predict resids1
 test neighbl langl
ge rtestp = r(p)
ge rtestc = r(chi2)

sort country year
 save pcse6a.dta, replace
use pcse.dta, replace
keep if indx == 7

#delimit ;
 tsset country year, yearly;
xtgee $dv1 $ecglobs $soglob $ccs if indx==7,  i(country) t(year) fam(nb) link(log)   corr(ar1)  iterate(10000) robust ;

#delimit cr
 
matrix ab7 = get(_b)
svmat ab7
matrix V = get(VCE)
matrix av7 = vecdiag(V)
svmat av7
gen alpha= e(phi) if indx==7
gen chisquare= e(chi2) if indx==7
gen loglik = e(chi2_dis)   if indx==7

predict resids1
test neighbl langl
ge rtestp = r(p)
ge rtestc = r(chi2)
sort country year
  save pcse7a.dta, replace


* merging data back together
use pcse1a.dta, clear
append using pcse2a.dta
append using pcse3a.dta
append using pcse4a.dta
append using pcse5a.dta
append using pcse6a.dta
append using pcse7a.dta


*  AGGREGATE THE RESULTS ACROSS DATA SETS

matrix point = (ab1 + ab2 + ab3 + ab4 + ab5 + ab6 + ab7 )/7

matrix var = point
local num = 1

while `num' <=colsof(point) {
	#delimit ;
      matrix var[1,`num'] = ((ab1[1,`num']- point[1,`num'])^2 + (ab2[1,`num']- point[1,`num'])^2
                 + (ab3[1,`num']- point[1,`num'])^2 + (ab4[1,`num']- point[1,`num'])^2
                 + (ab5[1,`num']- point[1,`num'])^2 + (ab6[1,`num']- point[1,`num'])^2
                 + (ab7[1,`num']- point[1,`num'])^2 )/6;
      #delimit cr
      local num = `num' + 1
      }
 
matrix var2 = var*11/10 + (av1 + av2 + av3 + av4 + av5 + av6 + av7)/7

matrix se = var2
matrix zz = var2

local nn = 1

while `nn' <=colsof(point) {
	matrix se[1,`nn'] = sqrt(var2[1,`nn'])
      matrix zz[1,`nn'] = point[1,`nn']/se[1,`nn']
      local nn = `nn' + 1
      }

matrix results = point \ se \ zz
log using ISQnodevel.log, replace
matrix list results
summarize alpha if indx!=indx[_n+1]
summarize chisquare if indx!=indx[_n+1]
summarize loglik if indx!=indx[_n+1]
summarize rtestp if indx!=indx[_n+1]
summarize rtestc if indx!=indx[_n+1]
log close


