//
// Two-sided Heterogeneity and Trade : Estimation
// 

use "$wdata/trade0314", clear

//
// Compile estimation dataset
//

// Prelim: Get GDP per capita in 2006
use Penn/pwt71/pwt71, clear
keep if year==2006
gen lngdpcap = log(cgdp/pop)
keep iso2 year cgdp pop
drop if iso2==""
save $tmp/tmpgdp, replace

// Get ISICr3 codes for each export flow
use "$wdata/trade0314", clear
tostring hs8, gen(hs8str)
replace hs8str = "0" + hs8str if strlen(hs8str)==7
gen hs6dig = substr(hs8str,1,6)
collapse (sum) value, by(foretak abland year custid hs6dig)
save $tmp/tmp, replace

use $tmp/tmp, clear
destring hs6dig, replace
gen long hs02 = hs6dig if year>=2002 & year<2007
gen long hs07 = hs6dig if year>=2007
merge m:1 hs02 using  BACI/ISICr3/HS2002_to_ISICrev3.dta, keep(match master)
tab _merge if year<2007
drop _merge
ren isicr3 isirc302
merge m:1 hs07 using  BACI/ISICr3/HS2007_to_ISICrev3.dta, keep(match master) 
tab _merge if year>=2007
drop _merge
replace isicr3 = isirc302 if year<2007

collapse (sum) value, by(foretak abland year custid isicr3)
collapse (sum) value (count) custid (p90) p90s=value ///
(p10) p10s=value (p50) p50s=value (min) mins=value (max) maxs=value, by(foretak abland year isicr3)
gen psratio = p90s/p10s

// Number of firms in each market, in 2005
egen tmp = count(foretak), by(abland year isicr3)
gen tmp2 = tmp if year==2005
egen nfirms05 = max(tmp), by(abland isicr3)
drop tmp*

// Join with Orbis data
rename abland countryisocode
merge n:1 countryisocode using $path/Orbis/dispersion_emp_50_50+.dta, keep(match master) 
tab _merge
drop _merge
rename countryisocode abland
foreach vv of varlist pratio pareto  sdlnL {
  rename `vv'norm `vv'ORB
  rename `vv' `vv'ORB2
}
rename nfirm nfirmORB
ren paretoRnorm paretoRORB

// Join with market share data
ren abland iso2
merge n:1 iso2 year isicr3 using absorption_isicr3/mkt_sh, keep(match master)
drop _merge
ren iso2 cty

// Join with import share data
ren cty abland
merge n:1 abland year isicr3 using $wdata/imp_sh, keep(match master)
drop _merge
ren abland cty

// Join with Exporter Dynamics data
ren cty iso2
merge n:1 iso2 using $wdata/pareto_buyer_exports_2006
drop _merge

// Join with GDP data
merge n:1 iso2 using $tmp/tmpgdp, keep(match master)
drop _merge
ren iso2 cty

gen lnr = log(value)
gen lnnbuyers = log(custid)
ren Output gdp  // Output is nominal output in that ISIC sector
foreach xx of varlist mins maxs p90s p10s p50s sh* gdp abs {
  gen ln`xx' = log(`xx')
}

// ISIC 2 digit
capture drop tmp
tostring isicr3, gen(tmp)
gen isic2dig = substr(tmp,1,2)
destring isic2dig, replace
drop tmp

egen id_firmyear = group(foretak year)
egen id_destyear = group(cty year)       
egen id_firmdest = group(foretak cty)
egen id_destind = group(cty isic2dig)
egen id_firmindyear = group(foretak isic2dig year)
egen id_firmdestyear = group(foretak cty year)
egen id_indyear = group(isic2dig year)
encode cty, gen(cty2)

// Parameters
global vv "lnshNOinj"  
global yy "lnabs"
global iv "lnshNordicinj" 

global cl "vce(cluster foretak)"
global destyear "i.cty2"
global disp "paretoORB"
global nfirms "nfirmORB>1000 & nfirmORB~=. & nfirms05>20 & year>=2004" 
global fe1 "id_firmdest"
global fe2 "id_destyear"
save /tmp/tmp, replace


// Regressions
use /tmp/tmp, clear

set matsize 1000

// Interactions
capture drop inter*
gen inter = $vv*$disp
gen interiv = $iv*$disp

xtivreg lnr $yy ($vv inter = $iv interiv) i.$fe2 if $nfirms, fe i($fe1) 
xtivreg lnnbuyers $yy ($vv inter = $iv interiv) i.$fe2 if $nfirms, fe i($fe1) 
xtivreg lnmins $yy ($vv inter = $iv interiv) i.$fe2 if $nfirms & custid>5, fe i($fe1) 
xtivreg lnp50s $yy ($vv inter = $iv interiv) i.$fe2 if $nfirms & custid>5, fe i($fe1) 

// OLS
xtreg lnr $yy $vv inter i.$fe2 if $nfirms, fe i($fe1) $cl
xtreg lnnbuyers $yy $vv inter i.$fe2 if $nfirms, fe i($fe1) $cl

// First stage
xtreg $vv $yy $iv interiv i.$fe2 if $nfirms, fe i($fe1) $cl
test $yy $iv interiv
xtreg inter $yy $iv interiv i.$fe2 if $nfirms, fe i($fe1) $cl
test $yy $iv interiv

// Alternative measure of dispersion : Stdev of log employment
global disp "sdlnLORB"
capture drop inter*
gen inter = $vv*$disp
gen interiv = $iv*$disp
xtivreg lnr $yy ($vv inter = $iv interiv) i.$fe2 if $nfirms, fe i($fe1) 
xtivreg lnnbuyers $yy ($vv inter = $iv interiv) i.$fe2 if $nfirms, fe i($fe1) 

// Alternative measure of dispersion : Exporter Dynamics Database
global disp "ex_cv" 
global nfirms "nfirms05>20 & year>=2004" 
capture drop inter*
gen inter = $vv*$disp
gen interiv = $iv*$disp
xtivreg lnr $yy ($vv inter = $iv interiv) i.$fe2 if $nfirms, fe i($fe1) 
xtivreg lnnbuyers $yy ($vv inter = $iv interiv) i.$fe2 if $nfirms, fe i($fe1) 

// Alternative instrument: Import share
global disp "paretoORB"
global nfirms "nfirmORB>1000 & nfirmORB~=. & nfirms05>20 & year>=2004 & shimp>.05" 
global iv "lnshimp" 
capture drop inter*
gen inter = $vv*$disp
gen interiv = $iv*$disp
xtivreg lnr $yy ($vv inter = $iv interiv) i.$fe2 if $nfirms, fe i($fe1) 
xtivreg lnnbuyers $yy ($vv inter = $iv interiv) i.$fe2 if $nfirms, fe i($fe1) 

// Robustness : Firm-destination-year, and 2-digit industry FE
capture drop inter*
gen inter = $vv*$disp
gen interiv = $iv*$disp
xtivreg lnr $yy ($vv inter = $iv interiv) i.isic2dig if $nfirms, fe i(id_firmdestyear) 
xtivreg lnnbuyers $yy ($vv inter = $iv interiv) i.isic2dig if $nfirms, fe i(id_firmdestyear) 

// Robustness: Control for GDP per capita 
capture drop inter*
global disp "paretoORB"
gen inter = $vv*$disp
gen interiv = $iv*$disp
gen lngdpcap = log(cgdp/pop)
gen inter2 = $vv * lngdpcap
xtivreg lnr $yy inter2 ($vv inter = $iv interiv) i.$fe2 if $nfirms, fe i($fe1) 
xtivreg lnnbuyers $yy inter2 ($vv inter = $iv interiv) i.$fe2 if $nfirms, fe i($fe1) 

// Which countries are we using in estimation
capture drop xvvar
predict xvvar if e(sample)
tab cty if xvvar~=.
