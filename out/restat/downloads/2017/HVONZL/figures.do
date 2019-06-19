//
// Two-sided Heterogeneity and Trade: Figures
// 

/* Explanatory notes:
 $dfile consists of seller-buyer-country-product-year observations
 impeks=1: imports, impeks=2: exports.
 value=trade flow in current NOK
 abland=destination country
 foretak=firm id, custid=customer id */


// ------------------------------------------------------------------
// FIGURE 1 : Average number of buyers per seller versus market size
// ------------------------------------------------------------------

// Buyers in each market
use "$wdata/$dfile", clear
collapse (sum) value, by(abland year custid)
collapse (sum) value (count) num_buyers=custid, by(abland year)
rename abland iso2
save /tmp/tmp2, replace

use "$wdata/$dfile", clear
collapse (sum) value, by(foretak abland custid year)  // aggregate away products
collapse (sum) value (count) custid, by(foretak abland year)
collapse (sum) value (mean) custid (count) foretak, by(abland year)

keep if year==2006
rename abland iso2
joinby iso2 year using "Penn/pwt71/pwt71", unmatched(none)
gen gdp = cgdp*pop  // pop in 1000 and cgdp in $, so gdp in 1000 $
label var custid "# buyers per firm (mean)"

gen tmp = gdp if iso2=="US"
egen tmp2 = max(tmp)
gen gdpn = gdp/tmp2
drop tmp*
label var gdpn "GDP (US=1)"

// Figure 1
scatter custid gdpn if year==2006, xscale(log) yscale(log) xlab(.0001 .001 .01 .1 1) mlabel(iso2) scheme(lean1) 
graph export "$path/graphs/customers_mkt_size.eps", as(eps) preview(on) replace

// -------------------------------
// FIGURE 2 : The distribution of the number of buyers per exporter
// -------------------------------

use "$wdata/$dfile", clear
keep if impeks==2
collapse (sum) value, by(foretak abland custid year)
collapse (sum) value (count) foretak, by(abland custid year)

bys abland year: cumul foretak, gen (cdf) equal
replace cdf = 1 - cdf
drop if cdf == 1 | cdf==0
label var cdf "Fraction of buyers with at least x exporters"
label var foretak "Exporters per buyer"

graph twoway (line foretak cdf  if abland=="CN" & year==2006, sort) ///
             (line foretak cdf  if abland=="SE" & year==2006, sort) ///
             (line foretak cdf  if abland=="US" & year==2006, sort), ///
             xscale(log) yscale(log) scheme(lean1) legend(ring(0) position(7)  order(1 "China" 2 "Sweden" 3 "USA")) xlab(.001 .01 .1 1) ylab(1 10 100)

graph export "$path/graphs/cdf_firmspercustomer_all.eps", as(eps) preview(on) replace
             
// Slope ( = - Pareto shape parameter)
gen tmp1 = log(foretak)
gen tmp2 = log(cdf)
reg tmp1 tmp2 if abland=="CN" & year==2006 
reg tmp1 tmp2 if abland=="SE" & year==2006 
reg tmp1 tmp2 if abland=="US" & year==2006 

// ------------------------------------------------
// FIGURE 3 : Number of buyers and firm-level exports
// ------------------------------------------------

use $wdata/$dfile, clear
keep if year==2006
collapse (sum) value, by(year foretak custid abland)
collapse (sum) value (count) custid, by(year abland foretak)

gen lnv = log(value)
egen meanval = mean(lnv), by(abland year custid)
gen tmp = meanval if custid==1
egen meanone = max(tmp), by(abland year)
drop tmp meanval

gen lnvn = lnv-meanone
gen lnb = log(custid)

// Total exports
twoway (lpolyci lnvn lnb)  if year==2006, scheme(lean1) legend(off) ///
ytitle("Exports, normalized") xtitle("Number of customers") ///
xscale(range(0 6) noextend) xlabel(0 "1" 2.3 "10" 4.6 "100" 6.2 "500") ///
ylabel(0 "1" 2.3 "10" 4.6 "100" 6.9 "1000" 9.2 "10000")
graph export "$path/graphs/tot_exports_customers_all_norm.eps", as(eps) preview(on) replace


// ------------------------------------------------
// FIGURE 4 : Number of buyers and within-firm dispersion in exports
// ------------------------------------------------

use $wdata/$dfile, clear
keep if year==2006
collapse (sum) value, by(year foretak custid abland)
collapse (sum) value (count) custid (p90) p9v=value (p50) p5v=value (p10) p1v=value ///
(min) min=value (max) max=value, by(year abland foretak)

gen lnv = log(value)
egen meanval = mean(lnv), by(abland year custid)
gen tmp = meanval if custid==1
egen meanone = max(tmp), by(abland year)
drop tmp meanval

// Normalization
gen lnvn = lnv-meanone
gen ln9n = log(p9v)-meanone
gen ln5n = log(p5v)-meanone
gen ln1n = log(p1v)-meanone
gen lnb = log(custid)

// Percentiles
twoway (lpolyci ln9n lnb) (lpolyci ln5n lnb) (lpolyci ln1n lnb)  ///
if year==2006 & custid>9, scheme(lean1) ///
ytitle("Exports, normalized") xtitle("Number of customers") ///
legend(ring(0) position(11)  rows(1) order(2 "P90" 3 "P50" 4 "P10" 1 "95% CI"))  ///
xscale(range(2 6) noextend) xlabel(2.3 "10" 4.6 "100" 6.9 "500") ///
ylabel(-2.3 "0.1" 0 "1" 2.3 "10" 4.6 "100" )
graph export "$path/graphs/within_dispersion_all_norm.eps", as(eps) preview(on) replace

// -------------------
// FIGURE 5 : Matching buyers and sellers across markets
// -------------------
use $wdata/$dfile, clear
collapse (sum) value, by(foretak abland year custid)

egen num_b = count(custid), by(foretak abland year)  // # buyers per seller
egen num_s = count(foretak), by(custid abland year)  // # sellers per buyer
egen marg_s = min(num_s), by(foretak abland year)    // The # connections for the marginal customer
egen val_b = total(value), by(foretak abland year)  // Exports per seller
egen val_s = total(value), by(custid abland year)  // Purchases per buyer

collapse (count) pairs=foretak (mean) num_s val_s (mean) marg_s ///
(median) m50=num_s (p25) m25=num_s (p75) m75=num_s (min) min=num_s (max) max=num_s, by(abland year num_b)

// Take deviations from mean
gen lb = log(num_b)
gen ls = log(num_s)
gen lvals = log(val_s)
egen mb = mean(lb), by(year abland)
egen ms = mean(ls), by(year abland)
egen mvals = mean(lvals), by(year abland)
gen lbm = lb - mb
gen lsm = ls - ms
gen lvalsm = lvals - mvals

// Graph
label var lbm "# buyers/seller"
label var lsm "Avg # sellers/buyer"
graph twoway (lfitci lsm lbm) (scatter lsm lbm) if year==2006, ///
scheme(lean1) ytitle("Avg # sellers/buyer") legend(off) ///
xlabel(-2.3 ".1" 0 "1" 2.3 "10") ///
ylabel(-2.3 ".1" 0 "1" 2.3 "10") 
graph export "$path/graphs/assortative_matching_all.eps", as(eps) preview(on) replace

// Regression
//encode abland, gen(cty)
reg lsm lbm if year==2006
reg lsm lbm if year==2006 & pairs>10
pwcorr lsm lbm if year==2006

// -------------------------------------------------------
// FIGURE 7 : Market shares pi_jkt and pi_nordic,jkt
// -------------------------------------------------------
use mkt_sh, clear
egen ctyind = group(iso2 isicr3)
tsset ctyind year
foreach i of varlist sh* {
  gen ln`i' = log(`i')
}

// Take out country-year fixed effects
egen ybar1 = mean(lnshNOinj), by(iso2 year)
egen ybar2 = mean(lnshNordicinj), by(iso2 year)
gen lnshNOinjm = lnshNOinj-ybar1
gen lnshNordicinjm = lnshNordicinj-ybar2
capture drop ybar*

// Winsorize distributions
bys year: cumul lnshNOinjm, gen (cdf)
drop if cdf>.99 | cdf<.01
drop cdf
bys year: cumul lnshNordicinjm, gen (cdf)
drop if cdf>.99 | cdf<.01 

twoway (lpolyci lnshNOinjm lnshNordicinjm)  if year==2004, scheme(lean1) legend(off) ///
ytitle("Market share in jk, Norway (logs)") xtitle("Market share in jk, other Nordic (logs)") 
graph export mkt_shares.eps, replace preview(on)
graph save mkt_shares.gph, replace 

// -------------------------------------------------------
// FIGURE 9 : Distribution of the number of exporters per buyer
// -------------------------------------------------------

use "$wdata/$dfile", clear
keep if impeks==2
collapse (sum) value, by(foretak abland custid year)
collapse (sum) value (count) foretak, by(abland custid year)


bys abland year: cumul foretak, gen (cdf) equal
replace cdf = 1 - cdf
drop if cdf == 1 | cdf==0
label var cdf "Fraction of buyers with at least x exporters"
label var foretak "Exporters per buyer"

graph twoway (line foretak cdf  if abland=="CN" & year==2006, sort) ///
             (line foretak cdf  if abland=="SE" & year==2006, sort) ///
             (line foretak cdf  if abland=="US" & year==2006, sort), ///
             xscale(log) yscale(log) scheme(lean1) legend(ring(0) position(7)  order(1 "China" 2 "Sweden" 3 "USA")) xlab(.001 .01 .1 1) ylab(1 10 100)

graph export "$path/graphs/cdf_firmspercustomer_all.eps", as(eps) preview(on) replace
             
// Slope ( = - Pareto shape parameter)
gen tmp1 = log(foretak)
gen tmp2 = log(cdf)
reg tmp1 tmp2 if abland=="CN" & year==2006 
reg tmp1 tmp2 if abland=="SE" & year==2006 
reg tmp1 tmp2 if abland=="US" & year==2006 

// -------------------------------------------------------
// FIGURE 10 : Matching buyers and sellers
// -------------------------------------------------------

use $wdata/$dfile, clear
keep if abland=="SE" & year==2006
collapse (sum) value, by(foretak abland year custid)
egen num_b = count(custid), by(foretak abland year)  // # buyers per seller
egen num_s = count(foretak), by(custid abland year)  // # sellers per buyer
egen marg_s = min(num_s), by(foretak abland year)    // The # connections for the marginal customer
egen val_b = total(value), by(foretak abland year)  // Exports per seller
egen val_s = total(value), by(custid abland year)  // Purchases per buyer

gen pb = 1 if num_b==1
replace pb=2 if num_b>=2 & num_b<=3
replace pb=3 if num_b>=4 & num_b<=10
replace pb=4 if num_b>=11
gen ps = 1 if num_s==1
replace ps=2 if num_s>=2 & num_s<=3
replace ps=3 if num_s>=4 & num_s<=10
replace ps=4 if num_s>=11

collapse (count) pairs=foretak, by(abland year pb ps)
egen tot_m = total(pairs), by(pb)
gen sh = pairs/tot_m

lab def kk 1 "1" 2 "2-3" 3 "4-10" 4 "11+", modify
label value pb kk
label value ps kk

label var sh "Share of connections" 
graph bar (asis) sh, over(ps) over(pb)  asyvars stack ///
legend(ring(1) position(6) cols(4) rows(1)) ///
legend(label(1 "1") label(2 "2-3") label(3 "4-10") label(4 "11+ connections")) ///
ylabel(, nogrid) scheme(lean1) 
graph export $path/graphs/assort_share_connections.eps, replace

// -------------------------------------------------------
// FIGURE 11 : Pecking Order Hierarchy across Buyers
// -------------------------------------------------------

// Drop countries with less than 20 firms/customers
use $wdata/$dfile, clear
keep if year==2006
collapse (sum) value, by(foretak abland year)
collapse (count) foretak, by(abland year)
save /tmp/tmpF, replace
use $wdata/$dfile, clear
keep if year==2006
collapse (sum) value, by(custid abland year)
collapse (count) custid, by(abland year)
merge 1:1 abland year using /tmp/tmpF
keep if custid>=20 & foretak>=20
keep abland
save /tmp/cty, replace

// How many firms
use $wdata/$dfile, clear
keep if year==2006
collapse (sum) value, by(foretak abland year)
collapse (count) foretak, by(abland year)
merge 1:1 abland using /tmp/cty
keep if _merge==3
drop _merge
save /tmp/tmp1, replace

// Customer ranks
use $wdata/$dfile, clear
keep if year==2006
collapse (sum) value, by(foretak abland year custid)
collapse (count) nfirms=foretak, by(custid abland year)
egen r = rank(nfirms), by(abland year) field
sort abland r
merge m:1 abland using /tmp/cty
keep if _merge==3
drop _merge
merge m:1 abland year using /tmp/tmp1
drop _merge
gen pr = nfirms/foretak
save /tmp/tmp3, replace

// How many are connecting to r1 and r1+r2, etc.
use $wdata/$dfile, clear
keep if year==2006
collapse (sum) value, by(abland year foretak custid)
merge m:1 abland using /tmp/cty
keep if _merge==3
drop _merge
merge m:1 abland year custid using /tmp/tmp3
drop _merge

forvalues i=1/10 {
  gen tmp`i' = r==`i'
}
gen tmp11 = r>=11
collapse (max) tmp*, by(abland year foretak)

gen upto1 = tmp1 & ~tmp2 & ~tmp3 & ~tmp4 & ~tmp5 & ~tmp6 & ~tmp7 & ~tmp8 & ~tmp9 & ~tmp10 & ~tmp11
gen upto2 = tmp1 & tmp2 & ~tmp3 & ~tmp4 & ~tmp5 & ~tmp6 & ~tmp7 & ~tmp8 & ~tmp9 & ~tmp10 & ~tmp11
gen upto3 = tmp1 & tmp2 & tmp3 & ~tmp4 & ~tmp5 & ~tmp6 & ~tmp7 & ~tmp8 & ~tmp9 & ~tmp10 & ~tmp11
gen upto4 = tmp1 & tmp2 & tmp3 & tmp4 & ~tmp5 & ~tmp6 & ~tmp7 & ~tmp8 & ~tmp9 & ~tmp10 & ~tmp11
gen upto5 = tmp1 & tmp2 & tmp3 & tmp4 & tmp5 & ~tmp6 & ~tmp7 & ~tmp8 & ~tmp9 & ~tmp10 & ~tmp11
gen upto6 = tmp1 & tmp2 & tmp3 & tmp4 & tmp5 & tmp6 & ~tmp7 & ~tmp8 & ~tmp9 & ~tmp10 & ~tmp11
gen upto7 = tmp1 & tmp2 & tmp3 & tmp4 & tmp5 & tmp6 & tmp7 & ~tmp8 & ~tmp9 & ~tmp10 & ~tmp11
gen upto8 = tmp1 & tmp2 & tmp3 & tmp4 & tmp5 & tmp6 & tmp7 & tmp8 & ~tmp9 & ~tmp10 & ~tmp11
gen upto9 = tmp1 & tmp2 & tmp3 & tmp4 & tmp5 & tmp6 & tmp7 & tmp8 & tmp9 & ~tmp10 & ~tmp11
gen upto10 = tmp1 & tmp2 & tmp3 & tmp4 & tmp5 & tmp6 & tmp7 & tmp8 & tmp9 & tmp10 & ~tmp11

collapse (sum) upto* (count) foretak, by(abland year)
gen sh = (upto1+upto2+upto3+upto4+upto5+upto6+upto7+upto8+upto9+upto10)/foretak
save /tmp/tmp4, replace

// Probabilities under independence
use /tmp/tmp3, clear

forvalues i=1/10 {
  gen p`i' = pr if r<=`i'
  replace p`i' = 1-pr if r>`i'
  replace p`i' = log(p`i')  
}
drop pr
collapse (sum) p* (count) custid, by(abland year)
forvalues i=1/10 {
  replace p`i' = exp(p`i')  
}

gen sh_sim = p1+p2+p3+p4+p5+p6+p7+p8+p9+p10
merge 1:1 abland year using /tmp/tmp4
drop _merge
gen lnsh = log(sh)
gen lnsh_sim = log(sh_sim)

gen jj = -10 in 1
replace jj = 0 in 2

twoway scatter lnsh lnsh_sim if foretak>20 & custid>20 & lnsh>-10 & lnsh_sim>-10 , ///
mlabel(abland) || function y=x, range(-10 0) ///
sort scheme(lean1) legend(off) xtitle("Share, under independence") ytitle("Share, data") ///
xlab(-11.5 ".00001" -9.2 ".0001" -6.9 ".001" -4.6 ".01" -2.3 ".1" 0 "1") ///
ylab(-11.5 ".00001" -9.2 ".0001" -6.9 ".001" -4.6 ".01" -2.3 ".1" 0 "1") 

graph export "$path/graphs/pecking_order_new2.eps", as(eps) preview(on) replace

// -------------------------------------------------------
// FIGURE 12 : Firm-level Heterogeneity across Countries
// -------------------------------------------------------

use $path/Orbis/dispersion_emp_50_50+.dta, clear
drop if pareto==.
gen upper = pareto+1.96*pareto_se
gen lower = pareto-1.96*pareto_se
keep if nfirm>1000
sort pareto
gen varcoun = _n
ssc install labutil
labmask varcoun, values(countryisocode)
graph twoway (bar pareto varcoun) (rcap upper lower varcoun), scheme(lean1) legend(off) xtitle("") ytitle("Pareto coefficient")
graph export "$path/graphs/pareto_bar2.eps", preview(on) replace
graph export "$path/graphs/pareto_bar2.pdf", replace
