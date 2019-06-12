*Leverage 

capture program drop mycmd
program define mycmd
	syntax anything [aw pw] [if] [in] [,cluster(string) robust r re mle ll ul hc3 vce(string) absorb(string) baseoutcome(string) quantile(string) iterate(string) cens(string) select(string) twostep logit asis by(string) unequal hetero(string)]
	gettoken testvars anything: anything, match(match)
	gettoken cmd anything: anything
	gettoken dep anything: anything
	unab testvars: `testvars'
	capture unab anything: `anything'
	capture unab select: `select'
	capture unab hetero: `hetero'
	global k = wordcount("`testvars'")
	if ("`hetero'" ~= "") global k = $k + wordcount("`hetero'")
	if ("`cmd'" == "mlogit" | "`select'" ~= "") global k = $k*2
	if ("`cmd'" == "brl" & "`logit'" ~= "") local cmd = "logit"
	if ("`cmd'" == "brl" & "`logit'" == "") local cmd = "reg"
	if ("`cmd'" == "reg" | "`cmd'" == "areg" | "`cmd'" == "regress") {
		if ("`absorb'" ~= "") quietly `cmd' `dep' `anything' [`weight' `exp'] `if' `in', absorb(`absorb')
		if ("`absorb'" == "") quietly `cmd' `dep' `anything' [`weight' `exp'] `if' `in'
		capture drop eee
		quietly gen eee = e(sample)
		if ("`weight'" ~= "") {
			gettoken a ww: exp, parse("=")
			}
		local i = 0
		foreach var in `testvars' {
			local anything1 = subinstr("`anything'","`var'","",1)
		preserve
			quietly keep if eee == 1
			quietly if ("`absorb'" ~= "") areg `var' `anything1' [`weight' `exp'] `if' `in', absorb(`absorb')
			quietly if ("`absorb'" == "") reg `var' `anything1' [`weight' `exp'] `if' `in'
			matrix QQ[$j+`i',8] = e(r2)
			quietly predict double fff, resid
			if ("`weight'" ~= "") quietly replace fff = fff*sqrt(`ww')
			quietly sum fff
			matrix QQ[$j+`i',1] = r(N)
			quietly replace fff = fff*fff
			if ("$cluster" ~= "") collapse (sum) fff, by($cluster) fast
			gsort -fff
			quietly sum fff
			quietly replace fff = fff/r(sum)
			quietly sum fff
			matrix QQ[$j+`i',2] = (r(N),r(max))
			quietly replace fff = fff + fff[_n-1] if _n > 1
			quietly sum fff, detail
			matrix QQ[$j+`i',4] = (r(p1), r(p5), r(p10),$i)
		restore
			local i = `i' + 1
			}
		local i = 0
		foreach var in `testvars' {	
			local anything1 = subinstr("`testvars'","`var'","",1)
		preserve
			quietly keep if eee == 1
			quietly reg `var' `anything1' [`weight' `exp'] `if' `in'
			matrix QQQ[$j+`i',8] = e(r2)
			quietly predict double fff, resid
			if ("`weight'" ~= "") quietly replace fff = fff*sqrt(`ww')
			quietly sum fff
			matrix QQQ[$j+`i',1] = r(N)
			quietly replace fff = fff*fff
			if ("$cluster" ~= "") collapse (sum) fff, by($cluster) fast
			gsort -fff
			quietly sum fff
			quietly replace fff = fff/r(sum)
			quietly sum fff
			matrix QQQ[$j+`i',2] = (r(N),r(max))
			quietly replace fff = fff + fff[_n-1] if _n > 1
			quietly sum fff, detail
			matrix QQQ[$j+`i',4] = (r(p1), r(p5), r(p10),$i)
		restore
			local i = `i' + 1
			}
		}
	else {
		capture drop eee
		if ("`quantile'" ~= "") {
			quietly `cmd' `dep' `anything' `if' `in', quantile(`quantile')
			quietly gen eee = e(sample)
			}
		else if ("`cens'" ~= "") {
			quietly `cmd' `dep' `anything' [`weight' `exp'] `if' `in', cens(`cens')
			quietly gen eee = e(sample)
			}
		else if ("`select'" ~= "") {
			quietly `cmd' `dep' `anything' `if' `in', select(`select') `twostep'
			quietly gen eee = e(sample)
			}
		else if ("`hetero'" ~= "") {
			quietly `cmd' `dep' `anything' `if' `in', hetero(`hetero')
			quietly gen eee = e(sample)
			}
		else if ("`baseoutcome'" ~= "") { 
			quietly `cmd' `dep' `anything' `if' `in', baseoutcome(`baseoutcome')
			quietly gen eee = e(sample)
			}
		else if ("`by'" == "" & "`cmd'" ~= "meadjusted" & "`cmd'" ~= "ate" & "`cmd'" ~= "suest") {
			quietly `cmd' `dep' `anything' [`weight' `exp'] `if' `in', `re' `mle' `ll' `ul' `asis' 
			quietly gen eee = e(sample)
			}
		else if ("`by'" ~= "") {
			quietly `cmd' `dep' `anything', by(`by') `unequal'
			quietly gen eee = (`dep' ~= . & `by' ~= .)
			}
		else if ("`cmd'" == "ate") {
			quietly reg `dep' `anything' `if' `in'
			quietly gen eee = e(sample)
			}
		else if ("`cmd'" == "meadjusted" | "`cmd'" == "suest") {
			quietly areg `dep' `anything' [`weight' `exp'] `if' `in', absorb(`absorb')
			quietly gen eee = e(sample)
			}
		if ("`weight'" ~= "") {
			gettoken a ww: exp, parse("=")
			}
		if ("`cmd'" == "ivreg") {
	 		gettoken testvars anything: anything, match(match)
			gettoken a testvars: testvars, parse("=")
			gettoken a testvars: testvars, parse("=")
			local anything = "`testvars' " + "`anything'"
			}
		if ("`cmd'" == "xtmixed") local anything = subinstr("`anything'","|| session: || id_number:","",1)
		local i = 0
		foreach var in `testvars' {
			local anything1 = subinstr("`anything'","`var'","",1)
		preserve
			quietly keep if eee == 1
			if ("`cmd'" ~= "meadjusted") quietly reg `var' `anything1' [`weight' `exp'] 
			if ("`cmd'" == "meadjusted" | "`cmd'" == "suest") quietly areg `var' `anything1' [`weight' `exp'] , absorb(`absorb')
			matrix QQ[$j+`i',8] = e(r2)
			quietly predict double fff, resid
			if ("`weight'" ~= "") quietly replace fff = fff*sqrt(`ww')
			quietly sum fff
			matrix QQ[$j+`i',1] = r(N)
			quietly replace fff = fff*fff
			if ("$cluster" ~= "") collapse (sum) fff, by($cluster) fast
			gsort -fff
			quietly sum fff
			quietly replace fff = fff/r(sum)
			quietly sum fff
			matrix QQ[$j+`i',2] = (r(N),r(max))
			quietly replace fff = fff + fff[_n-1] if _n > 1
			quietly sum fff, detail
			matrix QQ[$j+`i',4] = (r(p1), r(p5), r(p10),$i)
		restore
			local i = `i' + 1
			if ("`cmd'" == "mlogit") {
				matrix QQ[$j+`i',1] = QQ[$j+`i'-1,1..8]
				local i = `i' + 1
				}
			if ("`select'" ~= "") {
				local anything1 = subinstr("`select'","`var'","",1)
			preserve
				quietly keep if eee == 1
				quietly reg `var' `anything1' 
				matrix QQ[$j+`i',8] = e(r2)
				quietly predict double fff, resid
				quietly sum fff
				matrix QQ[$j+`i',1] = r(N)
				quietly replace fff = fff*fff
				gsort -fff
				quietly sum fff
				quietly replace fff = fff/r(sum)
				quietly sum fff
				matrix QQ[$j+`i',2] = (r(N),r(max))
				quietly replace fff = fff + fff[_n-1] if _n > 1
				quietly sum fff, detail
				matrix QQ[$j+`i',4] = (r(p1), r(p5), r(p10),$i)
			restore
				local i = `i' + 1
				}
			}
		local i = 0
		foreach var in `testvars' {	
			local anything1 = subinstr("`testvars'","`var'","",1)
		preserve
			quietly keep if eee == 1
			quietly reg `var' `anything1' [`weight' `exp'] 
			matrix QQQ[$j+`i',8] = e(r2)
			quietly predict double fff, resid
			if ("`weight'" ~= "") quietly replace fff = fff*sqrt(`ww')
			quietly sum fff
			matrix QQQ[$j+`i',1] = r(N)
			quietly replace fff = fff*fff
			if ("$cluster" ~= "") collapse (sum) fff, by($cluster) fast
			gsort -fff
			quietly sum fff
			quietly replace fff = fff/r(sum)
			quietly sum fff
			matrix QQQ[$j+`i',2] = (r(N),r(max))
			quietly replace fff = fff + fff[_n-1] if _n > 1
			quietly sum fff, detail
			matrix QQQ[$j+`i',4] = (r(p1), r(p5), r(p10),$i)
		restore
			local i = `i' + 1
			if ("`cmd'" == "mlogit" | "`select'" ~= "") {
				matrix QQQ[$j+`i',1] = QQQ[$j+`i'-1,1..8]
				local i = `i' + 1
				}
			}
		if ("`hetero'" ~= "") {
			foreach var in `hetero' {
				local anything1 = subinstr("`hetero'","`var'","",1)
			preserve
				quietly keep if eee == 1
				quietly reg `var' `anything1' 
				matrix QQ[$j+`i',8] = e(r2)
				matrix QQQ[$j+`i',8] = e(r2)
				quietly predict double fff, resid
				quietly sum fff
				matrix QQ[$j+`i',1] = r(N)
				matrix QQQ[$j+`i',1] = r(N)
				quietly replace fff = fff*fff
				if ("$cluster" ~= "") collapse (sum) fff, by($cluster) fast
				gsort -fff
				quietly sum fff
				quietly replace fff = fff/r(sum)
				quietly sum fff
				matrix QQ[$j+`i',2] = (r(N),r(max))
				matrix QQQ[$j+`i',2] = (r(N),r(max))
				quietly replace fff = fff + fff[_n-1] if _n > 1
				quietly sum fff, detail
				matrix QQ[$j+`i',4] = (r(p1), r(p5), r(p10),$i)
				matrix QQQ[$j+`i',4] = (r(p1), r(p5), r(p10),$i)
			restore
				local i = `i' + 1
				}
			}	
		}
	global i = $i + 1
	global j = $j + $k
end

foreach paper in AFGH CC1 CC2 CL CMS EGN HS LL IZ KN LMW S VDR A ABHOT ABS AKL AL ALO BBLP BL BM CCF CGTTTV CHKL CILS D DDK DHR DKR DR DR2 ER FG FJP FL FPPR GGY GJKM GKB KL LLLPR MMW MMW2 OT R T WDL KMP GKN GMR GRS MSV {	
	local dir = "$root" + "\files\" + "`paper'"
	cd `dir'
	use results\Fisher`paper', clear
	quietly sum B1
	global N = r(N)
	matrix QQ = J($N,10,.)
	matrix QQQ = J($N,10,.)
	matrix YN = J($N,1,.)

	if ("`paper'" ~= "MSV") quietly do mycmd`paper'
	if ("`paper'" == "MSV") quietly do LeverageMSV

	drop _all
	foreach matrix in QQ QQQ YN {
		svmat double `matrix'
		}
	generate CoefNum = _n
	generate paper = "`paper'"
	save results\lev`paper', replace
	}


local dir = "$root" + "\files"
cd `dir'
drop _all
foreach paper in AFGH CC1 CC2 CL CMS EGN HS LL IZ KN LMW S VDR A ABHOT ABS AKL AL ALO BBLP BL BM CCF CGTTTV CHKL CILS D DDK DHR DKR DR DR2 ER FG FJP FL FPPR GGY GJKM GKB KL LLLPR MMW MMW2 OT R T WDL KMP GKN GMR GRS MSV {	
	capture append using `paper'\results\lev`paper'
	}
merge 1:1 paper CoefNum using results\basecoef, nogenerate
tab repeat if QQ1 == .
drop if QQ1 == .
sum *8
keep QQ1-QQ6 QQQ1-QQQ6 paper CoefNum RegNum select repeat firsttable interactions 
sort paper CoefNum
save results\Leverage, replace

use results\Leverage, clear
keep if select == 1
collapse (mean) QQ3, by(paper) fast
sort QQ3
gen levgroup = 1 if _n <= 18
replace levgroup = 3 if _n >= 36
replace levgroup = 2 if levgroup == .
sort paper 
save results\Highlev, replace

