

use DatCCF1, clear
drop named1

*Tables 3
global i = 1
reg p treat treattop5 top5 if date >= 23, 
	estimate store M$i
	global i = $i + 1
reg p treat treattop5 top5 totaldish lbill sited2-sited4 named* if date >= 23, 
	estimate store M$i
	global i = $i + 1
probit p treat treattop5 top5 if date >= 23, 
	estimate store M$i
	global i = $i + 1
probit p treat treattop5 top5 totaldish lbill named2-named235 sited2-sited4 if date >= 23, 
	estimate store M$i
	global i = $i + 1

quietly suest M1 M2 M3 M4, cluster(billid)
test treat treattop5
matrix F = (r(p), r(drop), r(df), r(chi2), 3)

*Table 5
global i = 1
reg p treatafter treattop5after treat treattop5 after top5 top5after, 
	estimate store M$i
	global i = $i + 1
reg p treatafter treattop5after treat treattop5 after top5 top5after totaldish lbill sited2-sited4 named*, 
	estimate store M$i
	global i = $i + 1
probit p treatafter treattop5after treat treattop5 after top5 top5after, 
	estimate store M$i
	global i = $i + 1
probit p treatafter treattop5after treat treattop5 after top5 top5after totaldish lbill named2-named235 sited2-sited4, 
	estimate store M$i
	global i = $i + 1

quietly suest M1 M2 M3 M4, cluster(billid)
test treatafter treattop5after
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 5)

egen Unit = group(group th table)
bysort Unit: gen N = _n
sort N group Unit
global N = 273
generate Order = _n
generate double U = .
mata Y = st_data((1,$N),"treat")

mata ResF = J($reps,10,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort N group U in 1/$N
	mata st_store((1,$N),"treat",Y)
	sort Unit N
	quietly replace treat = treat[_n-1] if Unit == Unit[_n-1] & N > 1
	quietly replace treattop5 = treat*top5
	quietly replace treatafter = treat*after
	quietly replace treattop5after = treatafter*top5

*Tables 3
global i = 1
quietly reg p treat treattop5 top5 if date >= 23, 
	estimate store M$i
	global i = $i + 1
quietly reg p treat treattop5 top5 totaldish lbill sited2-sited4 named* if date >= 23, 
	estimate store M$i
	global i = $i + 1
quietly probit p treat treattop5 top5 if date >= 23, 
	estimate store M$i
	global i = $i + 1
quietly probit p treat treattop5 top5 totaldish lbill named2-named235 sited2-sited4 if date >= 23, 
	estimate store M$i
	global i = $i + 1

capture suest M1 M2 M3 M4, cluster(billid)
if (_rc == 0) {
	capture test treat treattop5
	if (_rc == 0) {
		mata ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 3)
		}
	}

*Table 5
global i = 1
quietly reg p treatafter treattop5after treat treattop5 after top5 top5after, 
	estimate store M$i
	global i = $i + 1
quietly reg p treatafter treattop5after treat treattop5 after top5 top5after totaldish lbill sited2-sited4 named*, 
	estimate store M$i
	global i = $i + 1
quietly probit p treatafter treattop5after treat treattop5 after top5 top5after, 
	estimate store M$i
	global i = $i + 1
quietly probit p treatafter treattop5after treat treattop5 after top5 top5after totaldish lbill named2-named235 sited2-sited4, 
	estimate store M$i
	global i = $i + 1

capture suest M1 M2 M3 M4, cluster(billid)
if (_rc == 0) {
	capture test treatafter treattop5after
	if (_rc == 0) {
		mata ResF[`c',6..10] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 5)
		}
	}
}


drop _all
set obs $reps
forvalues i = 1/10 {
	quietly generate double ResF`i' = .
	}
mata st_store(.,.,ResF)
svmat double F
gen N = _n
sort N
save ip\FisherSuestCCF1, replace


**************************************


use DatCCF2, clear
drop named1

*Table 4
global i = 1
reg p treat treattop5 top5 if date >= 23, 
	estimate store M$i
	global i = $i + 1
reg p treat treattop5 top5 totaldish lbill sited2 named* if date >= 23, 
	estimate store M$i
	global i = $i + 1
probit p treat treattop5 top5 if date >= 23, 
	estimate store M$i
	global i = $i + 1
probit p treat treattop5 top5 totaldish lbill named2-named115 sited2 if date >= 23, 
	estimate store M$i
	global i = $i + 1

suest M1 M2 M3 M4, cluster(billid)
test treat treattop5
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 4)

*Table 6
global i = 1
reg p treatafter treattop5after treat treattop5 after top5 top5after, 
	estimate store M$i
	global i = $i + 1
reg p treatafter treattop5after treat treattop5 after top5 top5after totaldish lbill sited2 named*, 
	estimate store M$i
	global i = $i + 1
probit p treatafter treattop5after treat treattop5 after top5 top5after, 
	estimate store M$i
	global i = $i + 1
probit p treatafter treattop5after treat treattop5 after top5 top5after totaldish lbill named2-named115 sited2, 
	estimate store M$i
	global i = $i + 1

suest M1 M2 M3 M4, cluster(billid)
test treatafter treattop5after
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 6)

egen Unit = group(group th table)
bysort Unit: gen N = _n
sort N group Unit
global N = 70
generate Order = _n
generate double U = .
mata Y = st_data((1,$N),"treat")

mata ResF = J($reps,10,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort N group U in 1/$N
	mata st_store((1,$N),"treat",Y)
	sort Unit N
	quietly replace treat = treat[_n-1] if Unit == Unit[_n-1] & N > 1
	quietly replace treattop5 = treat*top5
	quietly replace treatafter = treat*after
	quietly replace treattop5after = treatafter*top5

*Table 4
global i = 1
quietly reg p treat treattop5 top5 if date >= 23, 
	estimate store M$i
	global i = $i + 1
quietly reg p treat treattop5 top5 totaldish lbill sited2 named* if date >= 23, 
	estimate store M$i
	global i = $i + 1
quietly probit p treat treattop5 top5 if date >= 23, 
	estimate store M$i
	global i = $i + 1
quietly probit p treat treattop5 top5 totaldish lbill named2-named115 sited2 if date >= 23, 
	estimate store M$i
	global i = $i + 1

capture suest M1 M2 M3 M4, cluster(billid)
if (_rc == 0) {
	capture test treat treattop5
	if (_rc == 0) {
		mata ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 4)
		}
	}

*Table 6
global i = 1
quietly reg p treatafter treattop5after treat treattop5 after top5 top5after, 
	estimate store M$i
	global i = $i + 1
quietly reg p treatafter treattop5after treat treattop5 after top5 top5after totaldish lbill sited2 named*, 
	estimate store M$i
	global i = $i + 1
quietly probit p treatafter treattop5after treat treattop5 after top5 top5after, 
	estimate store M$i
	global i = $i + 1
quietly probit p treatafter treattop5after treat treattop5 after top5 top5after totaldish lbill named2-named115 sited2, 
	estimate store M$i
	global i = $i + 1

capture suest M1 M2 M3 M4, cluster(billid)
if (_rc == 0) {
	capture test treatafter treattop5after
	if (_rc == 0) {
		mata ResF[`c',6..10] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 6)
		}
	}
}


drop _all
set obs $reps
forvalues i = 11/20 {
	quietly generate double ResF`i' = .
	}
mata st_store(.,.,ResF)
svmat double F
gen N = _n
sort N
save ip\FisherSuestCCF2, replace

********************************

*Combining files

use ip\FisherSuestCCF1, clear
merge 1:1 N using ip\FisherSuestCCF2, nogenerate
drop F*
svmat double F
aorder
save results\FisherSuestCCF, replace
















