*Bonferroni

*Regression level
use results\BaseResultsCoef, clear
merge 1:1 paper CoefNum using results\BaseCoef, nogenerate
drop if repeat == 1
foreach var in p1 prc prt pbc pbt pjk {
	quietly gen double `var'red = `var'*reportedcoef if select == 1
	quietly replace `var' = `var'*numbercoefreg
	}
collapse (min) p1 prc prt pbc pbt pjk p1red prcred prtred pbcred pbtred pjkred (mean) reportedcoef numbercoefreg, by(paper RegNum) fast
foreach var in p1 prc prt pbc pbt pjk {
	quietly replace `var' = . if numbercoefreg == 1
	quietly replace `var'red = . if reportedcoef == 1
	}
drop if numbercoefreg == 1
save results\BHReg, replace

*Table level
use results\BaseResultsCoef, clear
merge 1:1 paper CoefNum using results\BaseCoef, nogenerate
merge m:1 paper table using results\BaseTable, nogenerate
foreach var in p1 prc prt pbc pbt pjk {
	quietly gen double `var'red = `var'*repcoeftable if select == 1
	quietly replace `var' = `var'*numbercoeftable
	}
collapse (min) p1 prc prt pbc pbt pjk p1red prcred prtred pbcred pbtred pjkred (mean) repcoeftable numbercoeftable, by(paper table) fast
save results\BHTable, replace


*************************************************************
*************************************************************

*Westfall-Young Regression Level

foreach paper in A ABHOT ABS AKL AL ALO BBLP BL BM CCF CGTTTV CHKL CILS D DDK DHR DKR DR DR2 ER FG FJP FL FPPR GGY GJKM GKB KL LLLPR MMW MMW2 OT R T WDL KMP GKN GMR GRS MSV AFGH CC1 CC2 CL CMS EGN HS LL IZ KN LMW S VDR {
	use results\BaseResultsCoef, clear
	keep if paper == "`paper'"
	gen N = 1
	collapse (min) prt prc pbt pbc (sum) N, by(paper RegNum) fast
	mkmat prt prc pbt pbc N, matrix(p)

	use results\BaseResultsCoef, clear
	merge 1:1 paper CoefNum using results\basecoef
	keep if paper == "`paper'" & select == 1
	gen N = 1
	collapse (min) prt prc pbt pbc (sum) N, by(paper RegNum) fast
	mkmat prt prc pbt pbc N, matrix(pred)

	use `paper'\results\Fisher`paper', clear
	quietly sum F1
	global N1 = r(N)
	quietly sum B1
	global N2 = r(N)
	quietly generate Start = 1 if _n == 1
	quietly replace Start = Start[_n-1] + F4[_n-1] if _n > 1 & F4 ~= .
	quietly generate Finish = Start + F4 - 1
	mkmat Start Finish in 1/$N1, matrix(info)
	foreach matrix in SigRc SigBc SigRt SigBt SigRcred SigBcred SigRtred SigBtred {
		matrix `matrix' = J($N1,3,.)
		}
	capture sum BIV1
	if (_rc == 0) {
		quietly replace B1 = BIV1 if BIV1 ~= .
		}
	mkmat B1 in 1/$N2, matrix(BB)

*Randomization
	use `paper'\results\Fisher`paper', clear
forvalues c = 1/$N1 {
preserve
	local a1 = info[`c',1]
	local a2 = info[`c',2]
	forvalues i = `a1'/`a2' {
		quietly drop if (ResB`i' == . | ResSE`i' == .| ResSE`i' == 0)
		quietly generate double t`i' = abs(ResB`i'/ResSE`i')
		quietly generate double c`i' = abs(ResB`i')
		}
	quietly generate double pt = 1
	quietly generate double pc = 1
	quietly drop Res*

set seed 1
*preparing uniform p-values
	forvalues i = `a1'/`a2' {
		quietly gsort -t`i'
		quietly generate I = (t`i' < t`i'[_n-1]*.99999999)
		quietly generate T`i' = 1
		quietly replace T`i' = T`i'[_n-1] + I if _n > 1
		quietly gsort T`i' -I
		by T`i': egen count = count(T`i')
		quietly generate double cumcount = count
		quietly replace cumcount = cumcount[_n-1] + I*count if _n > 1
		quietly replace count = count/_N
		quietly replace cumcount = cumcount/_N
		quietly generate double pt`i' = cumcount - count*uniform()
		capture drop I count cumcount T`i'

		quietly gsort -c`i'
		quietly generate I = (c`i' < c`i'[_n-1]*.99999999)
		quietly generate C`i' = 1
		quietly replace C`i' = C`i'[_n-1] + I if _n > 1
		quietly gsort C`i' -I
		by C`i': egen count = count(C`i')
		quietly generate double cumcount = count
		quietly replace cumcount = cumcount[_n-1] + I*count if _n > 1
		quietly replace count = count/_N
		quietly replace cumcount = cumcount/_N
		quietly generate double pc`i' = cumcount - count*uniform()
		capture drop I count cumcount C`i'

		quietly replace pt = min(pt,pt`i')
		quietly replace pc = min(pc,pc`i')
		}

	quietly sum pt, detail
	matrix SigRt[`c',1] = r(p1), r(p5)
	quietly sum pt if pt < p[`c',1]
	matrix SigRt[`c',3] = r(N)/_N

	quietly sum pc, detail
	matrix SigRc[`c',1] = r(p1), r(p5)
	quietly sum pc if pc < p[`c',2]
	matrix SigRc[`c',3] = r(N)/_N

restore
	}

*Bootstrap
	use `paper'\results\OBootstrap`paper', clear
forvalues c = 1/$N1 {
preserve
	local a1 = info[`c',1]
	local a2 = info[`c',2]
	forvalues i = `a1'/`a2' {
		quietly drop if (ResB`i' == . | ResSE`i' == .| ResSE`i' == 0)
		quietly generate double t`i' = abs((ResB`i'-BB[`i',1])/ResSE`i')
		quietly generate double c`i' = abs(ResB`i' - BB[`i',1])
		}
	quietly generate double pt = 1
	quietly generate double pc = 1
	quietly drop Res*

set seed 1
*preparing uniform p-values
	forvalues i = `a1'/`a2' {
		quietly gsort -t`i'
		quietly generate I = (t`i' < t`i'[_n-1]*.99999999)
		quietly generate T`i' = 1
		quietly replace T`i' = T`i'[_n-1] + I if _n > 1
		quietly gsort T`i' -I
		by T`i': egen count = count(T`i')
		quietly generate double cumcount = count
		quietly replace cumcount = cumcount[_n-1] + I*count if _n > 1
		quietly replace count = count/_N
		quietly replace cumcount = cumcount/_N
		quietly generate double pt`i' = cumcount - count*uniform()
		capture drop I count cumcount T`i'

		quietly gsort -c`i'
		quietly generate I = (c`i' < c`i'[_n-1]*.99999999)
		quietly generate C`i' = 1
		quietly replace C`i' = C`i'[_n-1] + I if _n > 1
		quietly gsort C`i' -I
		by C`i': egen count = count(C`i')
		quietly generate double cumcount = count
		quietly replace cumcount = cumcount[_n-1] + I*count if _n > 1
		quietly replace count = count/_N
		quietly replace cumcount = cumcount/_N
		quietly generate double pc`i' = cumcount - count*uniform()
		capture drop I count cumcount C`i'

		quietly replace pt = min(pt,pt`i')
		quietly replace pc = min(pc,pc`i')
		}

	quietly sum pt, detail
	matrix SigBt[`c',1] = r(p1), r(p5)
	quietly sum pt if pt < p[`c',3]
	matrix SigBt[`c',3] = r(N)/_N

	quietly sum pc, detail
	matrix SigBc[`c',1] = r(p1), r(p5)
	quietly sum pc if pc < p[`c',4]
	matrix SigBc[`c',3] = r(N)/_N

restore
	}

	capture use `paper'\results\Fisherred`paper', clear
	if (_rc == 0) {
		quietly sum F1
		global N1 = r(N)
		quietly sum B1
		global N2 = r(N)
		quietly generate Start = 1 if _n == 1
		quietly replace Start = Start[_n-1] + F4[_n-1] if _n > 1 & F4 ~= .
		quietly generate Finish = Start + F4 - 1
		mkmat Start Finish in 1/$N1, matrix(info)
		capture sum BIV1
		if (_rc == 0) {
			quietly replace B1 = BIV1 if BIV1 ~= .
			}
		mkmat B1 in 1/$N2, matrix(BB)

*Randomization
	use `paper'\results\Fisherred`paper', clear
	forvalues c = 1/$N1 {
preserve
		local a1 = info[`c',1]
		local a2 = info[`c',2]
		forvalues i = `a1'/`a2' {
			quietly drop if (ResB`i' == . | ResSE`i' == .| ResSE`i' == 0)
			quietly generate double t`i' = abs(ResB`i'/ResSE`i')
			quietly generate double c`i' = abs(ResB`i')
			}
		quietly generate double pt = 1
		quietly generate double pc = 1
		quietly drop Res*

	set seed 1
*preparing uniform p-values
		forvalues i = `a1'/`a2' {
			quietly gsort -t`i'
			quietly generate I = (t`i' < t`i'[_n-1]*.99999999)
			quietly generate T`i' = 1
			quietly replace T`i' = T`i'[_n-1] + I if _n > 1
			quietly gsort T`i' -I
			by T`i': egen count = count(T`i')
			quietly generate double cumcount = count
			quietly replace cumcount = cumcount[_n-1] + I*count if _n > 1
			quietly replace count = count/_N
			quietly replace cumcount = cumcount/_N
			quietly generate double pt`i' = cumcount - count*uniform()
			capture drop I count cumcount T`i'

			quietly gsort -c`i'
			quietly generate I = (c`i' < c`i'[_n-1]*.99999999)
			quietly generate C`i' = 1
			quietly replace C`i' = C`i'[_n-1] + I if _n > 1
			quietly gsort C`i' -I
			by C`i': egen count = count(C`i')
			quietly generate double cumcount = count
			quietly replace cumcount = cumcount[_n-1] + I*count if _n > 1
			quietly replace count = count/_N
			quietly replace cumcount = cumcount/_N
			quietly generate double pc`i' = cumcount - count*uniform()
			capture drop I count cumcount C`i'

			quietly replace pt = min(pt,pt`i')
			quietly replace pc = min(pc,pc`i')
			}

		quietly sum pt, detail
		matrix SigRtred[`c',1] = r(p1), r(p5)
		quietly sum pt if pt < pred[`c',1]
		matrix SigRtred[`c',3] = r(N)/_N

		quietly sum pc, detail
		matrix SigRcred[`c',1] = r(p1), r(p5)
		quietly sum pc if pc < pred[`c',2]
		matrix SigRcred[`c',3] = r(N)/_N

restore
		}

*Bootstrap
	use `paper'\results\OBootstrapred`paper', clear
	forvalues c = 1/$N1 {
preserve
		local a1 = info[`c',1]
		local a2 = info[`c',2]
		forvalues i = `a1'/`a2' {
			quietly drop if (ResB`i' == . | ResSE`i' == .| ResSE`i' == 0)
			quietly generate double t`i' = abs((ResB`i'-BB[`i',1])/ResSE`i')
			quietly generate double c`i' = abs(ResB`i' - BB[`i',1])
			}
		quietly generate double pt = 1
		quietly generate double pc = 1
		quietly drop Res*

	set seed 1
*preparing uniform p-values
		forvalues i = `a1'/`a2' {
			quietly gsort -t`i'
			quietly generate I = (t`i' < t`i'[_n-1]*.99999999)
			quietly generate T`i' = 1
			quietly replace T`i' = T`i'[_n-1] + I if _n > 1
			quietly gsort T`i' -I
			by T`i': egen count = count(T`i')
			quietly generate double cumcount = count
			quietly replace cumcount = cumcount[_n-1] + I*count if _n > 1
			quietly replace count = count/_N
			quietly replace cumcount = cumcount/_N
			quietly generate double pt`i' = cumcount - count*uniform()
			capture drop I count cumcount T`i'
	
			quietly gsort -c`i'
			quietly generate I = (c`i' < c`i'[_n-1]*.99999999)
			quietly generate C`i' = 1
			quietly replace C`i' = C`i'[_n-1] + I if _n > 1
			quietly gsort C`i' -I
			by C`i': egen count = count(C`i')
			quietly generate double cumcount = count
			quietly replace cumcount = cumcount[_n-1] + I*count if _n > 1
			quietly replace count = count/_N
			quietly replace cumcount = cumcount/_N
			quietly generate double pc`i' = cumcount - count*uniform()
			capture drop I count cumcount C`i'
	
			quietly replace pt = min(pt,pt`i')
			quietly replace pc = min(pc,pc`i')
			}

		quietly sum pt, detail
		matrix SigBtred[`c',1] = r(p1), r(p5)
		quietly sum pt if pt < pred[`c',3]
		matrix SigBtred[`c',3] = r(N)/_N
	
		quietly sum pc, detail
		matrix SigBcred[`c',1] = r(p1), r(p5)
		quietly sum pc if pc < pred[`c',4]
		matrix SigBcred[`c',3] = r(N)/_N

restore
		}
	}

	drop _all
	foreach j in SigRc SigRt SigBc SigBt p SigRcred SigRtred SigBcred SigBtred pred {
		svmat double `j'
		}
	quietly generate paper = "`paper'"
	quietly generate RegNum = _n
	save zz\WYReg`paper', replace
	}

drop _all
foreach paper in A ABHOT ABS AKL AL ALO BBLP BL BM CCF CGTTTV CHKL CILS D DDK DHR DKR DR DR2 ER FG FJP FL FPPR GGY GJKM GKB KL LLLPR MMW MMW2 OT R T WDL KMP GKN GMR GRS MSV AFGH CC1 CC2 CL CMS EGN HS LL IZ KN LMW S VDR {
	capture append using zz\WYReg`paper'.dta
	}
foreach var in SigRc SigRt SigBc SigBt {
	forvalues i = 1/3 {
		quietly replace `var'red`i' = `var'`i' if `var'red`i' == .
		}
	}
sort paper RegNum
rename p1 prt
rename p2 prc
rename p3 pbt
rename p4 pbc
rename p5 N
rename pred1 prtred
rename pred2 prcred
rename pred3 pbtred
rename pred4 pbcred
rename pred5 Nred
save results\WYReg, replace

*****************************************************

*Westfall-Young Table Level

foreach paper in A ABHOT ABS AKL AL ALO BBLP BL BM CCF CGTTTV CHKL CILS D DDK DHR DKR DR DR2 ER FG FJP FL FPPR GGY GJKM GKB KL LLLPR MMW MMW2 OT R T WDL KMP GKN GMR GRS MSV AFGH CC1 CC2 CL CMS EGN HS LL IZ KN LMW S VDR {
	use results\BaseResultsCoef, clear
	merge 1:1 paper CoefNum using results\BaseCoef
	keep if paper == "`paper'"
	egen M = group(table)
	quietly sum M
	global M = r(max)
	sort paper CoefNum
	mkmat M, matrix(table)
	gen N = 1
	collapse (mean) table (min) prt prc pbt pbc (sum) N, by(paper M) fast
	mkmat prt prc pbt pbc N M table, matrix(p)

	use results\BaseResultsCoef, clear
	merge 1:1 paper CoefNum using results\BaseCoef
	keep if paper == "`paper'" & select == 1
	egen M = group(table)
	sort paper CoefNum
	mkmat M, matrix(tablered)
	gen N = 1
	collapse (mean) table (min) prt prc pbt pbc (sum) N, by(paper M) fast
	mkmat prt prc pbt pbc N M table, matrix(pred)

	foreach matrix in SigRc SigBc SigRt SigBt SigRcred SigBcred SigRtred SigBtred {
		matrix `matrix' = J($M,3,.)
		}

	use `paper'\results\Fisher`paper', clear
	quietly sum B1
	global N2 = r(N)
	capture sum BIV1
	if (_rc == 0) {
		quietly replace B1 = BIV1 if BIV1 ~= .
		}
	mkmat B1 in 1/$N2, matrix(BB)

*Randomization
	use `paper'\results\Fisher`paper', clear
forvalues table = 1/$M {
preserve
	forvalues i = 1/$N2 {
		if (table[`i',1] == `table') {
			quietly drop if (ResB`i' == . | ResSE`i' == . | ResSE`i' == 0)
			quietly generate double t`i' = abs(ResB`i'/ResSE`i')
			quietly generate double c`i' = abs(ResB`i')
			}
		}
	quietly generate double pt = 1
	quietly generate double pc = 1
	quietly drop Res*

set seed 1
*preparing uniform p-values
	forvalues i = 1/$N2 {
		if (table[`i',1] == `table') {
			quietly gsort -t`i'
			quietly generate I = (t`i' < t`i'[_n-1]*.99999999)
			quietly generate T`i' = 1
			quietly replace T`i' = T`i'[_n-1] + I if _n > 1
			quietly gsort T`i' -I
			by T`i': egen count = count(T`i')
			quietly generate double cumcount = count
			quietly replace cumcount = cumcount[_n-1] + I*count if _n > 1
			quietly replace count = count/_N
			quietly replace cumcount = cumcount/_N
			quietly generate double pt`i' = cumcount - count*uniform()
			capture drop I count cumcount T`i'
		
			quietly gsort -c`i'
			quietly generate I = (c`i' < c`i'[_n-1]*.99999999)
			quietly generate C`i' = 1
			quietly replace C`i' = C`i'[_n-1] + I if _n > 1
			quietly gsort C`i' -I
			by C`i': egen count = count(C`i')
			quietly generate double cumcount = count
			quietly replace cumcount = cumcount[_n-1] + I*count if _n > 1
			quietly replace count = count/_N
			quietly replace cumcount = cumcount/_N
			quietly generate double pc`i' = cumcount - count*uniform()
			capture drop I count cumcount C`i'

			quietly replace pt = min(pt,pt`i')
			quietly replace pc = min(pc,pc`i')
			}
		}

	quietly sum pt, detail
	matrix SigRt[`table',1] = r(p1), r(p5)
	quietly sum pt if pt < p[`table',1]
	matrix SigRt[`table',3] = r(N)/_N

	quietly sum pc, detail
	matrix SigRc[`table',1] = r(p1), r(p5)
	quietly sum pc if pc < p[`table',2]
	matrix SigRc[`table',3] = r(N)/_N

restore
	}

*Bootstrap
	use `paper'\results\OBootstrap`paper', clear
forvalues table = 1/$M {
preserve	
	forvalues i = 1/$N2 {
		if (table[`i',1] == `table') {
			quietly drop if (ResB`i' == . | ResSE`i' == . | ResSE`i' == 0)
			quietly generate double t`i' = abs((ResB`i'-BB[`i',1])/ResSE`i')
			quietly generate double c`i' = abs(ResB`i' - BB[`i',1])
			}
		}
	quietly generate double pt = 1
	quietly generate double pc = 1
	quietly drop Res*

set seed 1
*preparing uniform p-values
	forvalues i = 1/$N2 {
		if (table[`i',1] == `table') {
			quietly gsort -t`i'
			quietly generate I = (t`i' < t`i'[_n-1]*.99999999)
			quietly generate T`i' = 1
			quietly replace T`i' = T`i'[_n-1] + I if _n > 1
			quietly gsort T`i' -I
			by T`i': egen count = count(T`i')
			quietly generate double cumcount = count
			quietly replace cumcount = cumcount[_n-1] + I*count if _n > 1
			quietly replace count = count/_N
			quietly replace cumcount = cumcount/_N
			quietly generate double pt`i' = cumcount - count*uniform()
			capture drop I count cumcount T`i'
	
			quietly gsort -c`i'
			quietly generate I = (c`i' < c`i'[_n-1]*.99999999)
			quietly generate C`i' = 1
			quietly replace C`i' = C`i'[_n-1] + I if _n > 1
			quietly gsort C`i' -I
			by C`i': egen count = count(C`i')
			quietly generate double cumcount = count
			quietly replace cumcount = cumcount[_n-1] + I*count if _n > 1
			quietly replace count = count/_N
			quietly replace cumcount = cumcount/_N
			quietly generate double pc`i' = cumcount - count*uniform()
			capture drop I count cumcount C`i'

			quietly replace pt = min(pt,pt`i')
			quietly replace pc = min(pc,pc`i')
			}
		}


	quietly sum pt, detail
	matrix SigBt[`table',1] = r(p1), r(p5)
	quietly sum pt if pt < p[`table',3]
	matrix SigBt[`table',3] = r(N)/_N

	quietly sum pc, detail
	matrix SigBc[`table',1] = r(p1), r(p5)
	quietly sum pc if pc < p[`table',4]
	matrix SigBc[`table',3] = r(N)/_N

restore
	}

	capture use `paper'\results\Fisherred`paper', clear
if (_rc == 0) {
	quietly sum B1
	global N2 = r(N)
	capture sum BIV1
	if (_rc == 0) {
		quietly replace B1 = BIV1 if BIV1 ~= .
		}
	mkmat B1 in 1/$N2, matrix(BB)

*Randomization
	use `paper'\results\Fisherred`paper', clear
forvalues table = 1/$M {
preserve
	forvalues i = 1/$N2 {
		if (tablered[`i',1] == `table') {
			quietly drop if (ResB`i' == . | ResSE`i' == . | ResSE`i' == 0)
			quietly generate double t`i' = abs(ResB`i'/ResSE`i')
			quietly generate double c`i' = abs(ResB`i')
			}
		}
	quietly generate double pt = 1
	quietly generate double pc = 1
	quietly drop Res*

set seed 1
*preparing uniform p-values
	forvalues i = 1/$N2 {
		if (tablered[`i',1] == `table') {
			quietly gsort -t`i'
			quietly generate I = (t`i' < t`i'[_n-1]*.99999999)
			quietly generate T`i' = 1
			quietly replace T`i' = T`i'[_n-1] + I if _n > 1
			quietly gsort T`i' -I
			by T`i': egen count = count(T`i')
			quietly generate double cumcount = count
			quietly replace cumcount = cumcount[_n-1] + I*count if _n > 1
			quietly replace count = count/_N
			quietly replace cumcount = cumcount/_N
			quietly generate double pt`i' = cumcount - count*uniform()
			capture drop I count cumcount T`i'
		
			quietly gsort -c`i'
			quietly generate I = (c`i' < c`i'[_n-1]*.99999999)
			quietly generate C`i' = 1
			quietly replace C`i' = C`i'[_n-1] + I if _n > 1
			quietly gsort C`i' -I
			by C`i': egen count = count(C`i')
			quietly generate double cumcount = count
			quietly replace cumcount = cumcount[_n-1] + I*count if _n > 1
			quietly replace count = count/_N
			quietly replace cumcount = cumcount/_N
			quietly generate double pc`i' = cumcount - count*uniform()
			capture drop I count cumcount C`i'

			quietly replace pt = min(pt,pt`i')
			quietly replace pc = min(pc,pc`i')
			}
		}

	quietly sum pt, detail
	matrix SigRtred[`table',1] = r(p1), r(p5)
	quietly sum pt if pt < pred[`table',1]
	matrix SigRtred[`table',3] = r(N)/_N

	quietly sum pc, detail
	matrix SigRcred[`table',1] = r(p1), r(p5)
	quietly sum pc if pc < pred[`table',2]
	matrix SigRcred[`table',3] = r(N)/_N

restore
	}

*Bootstrap
	use `paper'\results\OBootstrapred`paper', clear
forvalues table = 1/$M {
preserve	
	forvalues i = 1/$N2 {
		if (tablered[`i',1] == `table') {
			quietly drop if (ResB`i' == . | ResSE`i' == . | ResSE`i' == 0)
			quietly generate double t`i' = abs((ResB`i'-BB[`i',1])/ResSE`i')
			quietly generate double c`i' = abs(ResB`i' - BB[`i',1])
			}
		}
	quietly generate double pt = 1
	quietly generate double pc = 1
	quietly drop Res*

set seed 1
*preparing uniform p-values
	forvalues i = 1/$N2 {
		if (tablered[`i',1] == `table') {
			quietly gsort -t`i'
			quietly generate I = (t`i' < t`i'[_n-1]*.99999999)
			quietly generate T`i' = 1
			quietly replace T`i' = T`i'[_n-1] + I if _n > 1
			quietly gsort T`i' -I
			by T`i': egen count = count(T`i')
			quietly generate double cumcount = count
			quietly replace cumcount = cumcount[_n-1] + I*count if _n > 1
			quietly replace count = count/_N
			quietly replace cumcount = cumcount/_N
			quietly generate double pt`i' = cumcount - count*uniform()
			capture drop I count cumcount T`i'
	
			quietly gsort -c`i'
			quietly generate I = (c`i' < c`i'[_n-1]*.99999999)
			quietly generate C`i' = 1
			quietly replace C`i' = C`i'[_n-1] + I if _n > 1
			quietly gsort C`i' -I
			by C`i': egen count = count(C`i')
			quietly generate double cumcount = count
			quietly replace cumcount = cumcount[_n-1] + I*count if _n > 1
			quietly replace count = count/_N
			quietly replace cumcount = cumcount/_N
			quietly generate double pc`i' = cumcount - count*uniform()
			capture drop I count cumcount C`i'

			quietly replace pt = min(pt,pt`i')
			quietly replace pc = min(pc,pc`i')
			}
		}

	quietly sum pt, detail
	matrix SigBtred[`table',1] = r(p1), r(p5)
	quietly sum pt if pt < pred[`table',3]
	matrix SigBtred[`table',3] = r(N)/_N

	quietly sum pc, detail
	matrix SigBcred[`table',1] = r(p1), r(p5)
	quietly sum pc if pc < pred[`table',4]
	matrix SigBcred[`table',3] = r(N)/_N

restore
	}

	}

	drop _all
	foreach j in SigRc SigRt SigBc SigBt p SigRcred SigRtred SigBcred SigBtred pred {
		svmat double `j'
		}
	quietly generate paper = "`paper'"
	quietly generate Table = _n
	save zz\WYTable`paper', replace
	}

drop _all
foreach paper in A ABHOT ABS AKL AL ALO BBLP BL BM CCF CGTTTV CHKL CILS D DDK DHR DKR DR DR2 ER FG FJP FL FPPR GGY GJKM GKB KL LLLPR MMW MMW2 OT R T WDL KMP GKN GMR GRS MSV AFGH CC1 CC2 CL CMS EGN HS LL IZ KN LMW S VDR {
	capture append using zz\WYTable`paper'
	}
foreach var in SigRc SigRt SigBc SigBt {
	forvalues i = 1/3 {
		quietly replace `var'red`i' = `var'`i' if `var'red`i' == .
		}
	}
drop Table p7 pred6 p6
rename pred7 table
rename p1 prt
rename p2 prc
rename p3 pbt
rename p4 pbc
rename p5 N
rename pred1 prtred
rename pred2 prcred
rename pred3 pbtred
rename pred4 pbcred
rename pred5 Nred
sort paper table
save results\WYTable, replace

