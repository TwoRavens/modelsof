capture mkdir zz

foreach paper in AFGH CC1 CC2 CL CMS EGN HS LL IZ KN LMW S VDR A ABHOT ABS AKL AL ALO BBLP BL BM CCF CGTTTV CHKL CILS D DDK DHR DKR DR DR2 ER FG FJP FL FPPR GGY GJKM GKB KL LLLPR MMW MMW2 OT R T WDL KMP GKN GMR GRS MSV {
	use `paper'\results\Fisher`paper', clear
	quietly sum F1
	global N1 = r(N)
	quietly sum B1
	global N2 = r(N)

	foreach j in rc rt rcalt rtalt rccond rtcond bc bt bcalt btalt bbc bbt B BB BBB Bcond Balt BBalt jk jkalt {
		matrix `j' = J($N2,3,.)
		}
	foreach j in p palt ppalt {
		matrix `j' = J($N2,1,.)
		}

	quietly generate Start = 1 if _n == 1
	quietly replace Start = Start[_n-1] + F4[_n-1] if _n > 1 & F4 ~= .
	quietly generate Finish = Start + F4 - 1
	quietly generate double B3 = abs(B1/B2)
	mkmat Start Finish F4 F3 in 1/$N1, matrix(info)
	mkmat B1 B2 B3 in 1/$N2, matrix(B)

	forvalues i = 1/$N2 {
		quietly replace ResB`i' = . if ResSE`i' == 0
		quietly replace ResSE`i' = abs(ResB`i'/ResSE`i')
		quietly replace ResB`i' = abs(ResB`i')
		}

*Statistics derived from the randomization distribution (randomization-c, randomization-t)
*randomization-t
	forvalues i = 1/$N2 {
		quietly sum ResSE`i'
		global N = r(N)
		quietly sum ResSE`i' if ResSE`i' > B[`i',3]*.999999
		matrix rt[`i',1] = (r(N)+1)/($N+1)
		quietly sum ResSE`i' if ResSE`i' > B[`i',3]*1.000001
		matrix rt[`i',2] = r(N)/($N+1), $N
		}
*randomization-c 
	forvalues i = 1/$N2 {
		quietly sum ResB`i'
		global N = r(N)
		quietly sum ResB`i' if ResB`i' > abs(B[`i',1])*.999999
		matrix rc[`i',1] = (r(N)+1)/($N+1)
		quietly sum ResB`i' if ResB`i' > abs(B[`i',1])*1.000001
		matrix rc[`i',2] = r(N)/($N+1), $N
		}

*Statistics derived from the paper's regressions themselves
	capture sum BIV1
	if (_rc == 0) {
		quietly replace B1 = BIV1 if BIV1 ~= .
		quietly replace B2 = BIV2 if BIV2 ~= .
		quietly replace B3 = abs(B1/B2)
		mkmat B1 B2 B3 in 1/$N2, matrix(B)
		}
	quietly generate DF = .
	forvalues i = 1/$N1 {
		quietly replace DF = F3[`i'] if _n >= info[`i',1] & _n <= info[`i',2]
		}
	quietly generate double p = Ftail(1,DF,(B1/B2)^2) if DF ~= .
	quietly replace p = chi2tail(1,(B1/B2)^2) if DF == .
	mkmat p in 1/$N2, matrix(p)

*Alternate clustering (Fisher using treatment level clustering and randomization for papers that systematically clustered below treatment level)
	capture use `paper'\results\FisherA`paper', clear
	if (_rc == 0) {
		quietly generate double B3 = abs(B1/B2)
		mkmat B1 B2 B3 in 1/$N2, matrix(Balt)
	
		forvalues i = 1/$N2 {
			quietly replace ResB`i' = . if ResSE`i' == 0
			quietly replace ResSE`i' = abs(ResB`i'/ResSE`i')
			quietly replace ResB`i' = abs(ResB`i')
			}
	*Statistics derived from the randomization distribution (randomization-c, randomization-t)
	*randomization-t
		forvalues i = 1/$N2 {
			quietly sum ResSE`i'
			global N = r(N)
			quietly sum ResSE`i' if ResSE`i' > Balt[`i',3]*.999999
			matrix rtalt[`i',1] = (r(N)+1)/($N+1)
			quietly sum ResSE`i' if ResSE`i' > Balt[`i',3]*1.000001
			matrix rtalt[`i',2] = r(N)/($N+1), $N
			}
	*randomization-c 
		forvalues i = 1/$N2 {
			quietly sum ResB`i'
			global N = r(N)
			quietly sum ResB`i' if ResB`i' > abs(Balt[`i',1])*.999999
			matrix rcalt[`i',1] = (r(N)+1)/($N+1)
			quietly sum ResB`i' if ResB`i' > abs(Balt[`i',1])*1.000001
			matrix rcalt[`i',2] = r(N)/($N+1), $N
			}

	*Statistics derived from the paper's regressions themselves
		quietly generate DF = .
		forvalues i = 1/$N1 {
			quietly replace DF = F3[`i'] if _n >= info[`i',1] & _n <= info[`i',2]
			}
		quietly generate double p = Ftail(1,DF,(B1/B2)^2) if DF ~= .
		quietly replace p = chi2tail(1,(B1/B2)^2) if DF == .
		mkmat p in 1/$N2, matrix(palt)
		}

*Conditional randomization p-values (where possible to calculate)
	capture use `paper'\results\FisherCond`paper', clear
	if (_rc == 0) {
		quietly sum F1
		global NC1 = r(N)
		quietly sum B1
		global NC2 = r(N)

		quietly generate double T3 = abs(T1/T2)
		mkmat T1 T2 T3 in 1/$NC2, matrix(Bcond)
	
		forvalues i = 1/$NC2 {
			quietly replace ResB`i' = . if ResSE`i' == 0
			quietly replace ResSE`i' = abs(ResB`i'/ResSE`i')
			quietly replace ResB`i' = abs(ResB`i')
			}
	*Statistics derived from the randomization distribution (randomization-c, randomization-t)
	*randomization-t
		forvalues i = 1/$NC2 {
			quietly sum ResSE`i'
			global N = r(N)
			quietly sum ResSE`i' if ResSE`i' > Bcond[`i',3]*.999999
			matrix rtcond[`i',1] = (r(N)+1)/($N+1)
			quietly sum ResSE`i' if ResSE`i' > Bcond[`i',3]*1.000001
			matrix rtcond[`i',2] = r(N)/($N+1), $N
			}
	*randomization-c 
		forvalues i = 1/$NC2 {
			quietly sum ResB`i'
			global N = r(N)
			quietly sum ResB`i' if ResB`i' > abs(Bcond[`i',1])*.999999
			matrix rccond[`i',1] = (r(N)+1)/($N+1)
			quietly sum ResB`i' if ResB`i' > abs(Bcond[`i',1])*1.000001
			matrix rccond[`i',2] = r(N)/($N+1), $N
			}
		}

*Statistics derived from overall bootstrap
	use `paper'\results\OBootstrap`paper', clear
	quietly generate double B3 = abs(B1/B2)
	mkmat B1 B2 B3 in 1/$N2, matrix(BB)

	forvalues i = 1/$N2 {
		quietly replace ResB`i' = . if ResSE`i' == 0
		quietly replace ResSE`i' = abs((ResB`i'-BB[`i',1])/ResSE`i')
		quietly replace ResB`i' = abs(ResB`i'-BB[`i',1])
		}
*bootstrap-t
	forvalues i = 1/$N2 {
		quietly sum ResSE`i'
		global N = r(N)
		quietly sum ResSE`i' if ResSE`i' > BB[`i',3]*.999999
		matrix bt[`i',1] = (r(N)+1)/($N+1)
		quietly sum ResSE`i' if ResSE`i' > BB[`i',3]*1.000001
		matrix bt[`i',2] = r(N)/($N+1), $N
		}
*bootstrap-c 
	forvalues i = 1/$N2 {
		quietly sum ResB`i'
		global N = r(N)
		quietly sum ResB`i' if ResB`i' > abs(BB[`i',1])*.999999
		matrix bc[`i',1] = (r(N)+1)/($N+1)
		quietly sum ResB`i' if ResB`i' > abs(BB[`i',1])*1.000001
		matrix bc[`i',2] = r(N)/($N+1), $N
		}

*Statistics derived from the paper's regressions themselves 
	quietly generate DF12 = .
	forvalues i = 1/$N1 {
		quietly replace DF12 = F3[`i'] if _n >= info[`i',1] & _n <= info[`i',2]
		}
	quietly generate double p = Ftail(1,DF12,(B1/B2)^2) if DF12 ~= .
	quietly replace p = chi2tail(1,(B1/B2)^2) if DF12 == .
	mkmat p in 1/$N2, matrix(pp)

*Alternate clustering (Bootstrap using treatment groupings in papers that systematically clustered below treatment level)
capture use `paper'\results\OBootstrapA`paper', clear
if (_rc == 0) {
	quietly generate double B3 = abs(B1/B2)
	mkmat B1 B2 B3 in 1/$N2, matrix(BBalt)

	forvalues i = 1/$N2 {
		quietly replace ResB`i' = . if ResSE`i' == 0
		quietly replace ResSE`i' = abs((ResB`i'-BBalt[`i',1])/ResSE`i') 
		quietly replace ResB`i' = abs(ResB`i'-BBalt[`i',1])
		}
*bootstrap-t
	forvalues i = 1/$N2 {
		quietly sum ResSE`i'
		global N = r(N)
		quietly sum ResSE`i' if ResSE`i' > BBalt[`i',3]*.999999
		matrix btalt[`i',1] = (r(N)+1)/($N+1)
		quietly sum ResSE`i' if ResSE`i' > BBalt[`i',3]*1.000001
		matrix btalt[`i',2] = r(N)/($N+1), $N
		}
*bootstrap-c 
	forvalues i = 1/$N2 {
		quietly sum ResB`i'
		global N = r(N)
		quietly sum ResB`i' if ResB`i' > abs(BBalt[`i',1])*.999999
		matrix bcalt[`i',1] = (r(N)+1)/($N+1)
		quietly sum ResB`i' if ResB`i' > abs(BBalt[`i',1])*1.000001
		matrix bcalt[`i',2] = r(N)/($N+1), $N
		}
*Statistics derived from the paper's regressions themselves
	quietly generate DF12 = .
	forvalues i = 1/$N1 {
		quietly replace DF12 = F3[`i'] if _n >= info[`i',1] & _n <= info[`i',2]
		}
	quietly generate double p = Ftail(1,DF12,(B1/B2)^2) if DF12 ~= .
	quietly replace p = chi2tail(1,(B1/B2)^2) if DF12 == .
	mkmat p in 1/$N2, matrix(ppalt)
}

*Statistics derived from the bootstrap - bootstrapping at equation level
	use `paper'\results\Bootstrap`paper', clear
	quietly generate double B3 = abs(B1/B2)
	mkmat B1 B2 B3 in 1/$N2, matrix(BBB)

	forvalues i = 1/$N2 {
		quietly replace ResB`i' = . if ResSE`i' == 0
		quietly replace ResSE`i' = abs((ResB`i'-BBB[`i',1])/ResSE`i')
		quietly replace ResB`i' = abs(ResB`i'-BBB[`i',1])
		}
*bootstrap-t
	forvalues i = 1/$N2 {
		quietly sum ResSE`i'
		global N = r(N)
		quietly sum ResSE`i' if ResSE`i' > BBB[`i',3]*.999999
		matrix bbt[`i',1] = (r(N)+1)/($N+1)
		quietly sum ResSE`i' if ResSE`i' > BBB[`i',3]*1.000001
		matrix bbt[`i',2] = r(N)/($N+1), $N
		}
*bootstrap-c 
	forvalues i = 1/$N2 {
		quietly sum ResB`i'
		global N = r(N)
		quietly sum ResB`i' if ResB`i' > abs(BBB[`i',1])*.999999
		matrix bbc[`i',1] = (r(N)+1)/($N+1)
		quietly sum ResB`i' if ResB`i' > abs(BBB[`i',1])*1.000001
		matrix bbc[`i',2] = r(N)/($N+1), $N
		}

*Statistics derived from the jackknife
	use `paper'\results\JackKnife`paper', clear
	forvalues i = 1/$N2 {
		quietly sum ResB`i' if ResB`i' == 0 & ResSE`i' == 0
		if (r(N) > 0) matrix jk[`i',3] = 1
		quietly replace ResB`i'= (ResB`i' - BB[`i',1])^2
		quietly sum ResB`i' if ResB`i' > 1e-10
		matrix jk[`i',1] = r(N)
		}
	collapse (sum) ResB*, fast
	aorder
	mkmat ResB1-ResB$N2, matrix(a)
	matrix jk[1,2] = a'

*Alternate clustering (at treatment level for papers that systematically cluster below treatment level)
	capture use `paper'\results\JackKnifeA`paper', clear
	if (_rc == 0) {
		forvalues i = 1/$N2 {
			quietly sum ResB`i' if ResB`i' == 0 & ResSE`i' == 0
			if (r(N) > 0) matrix jkalt[`i',3] = 1
			quietly replace ResB`i'= (ResB`i' - BB[`i',1])^2
			quietly sum ResB`i' if ResB`i' > 1e-10
			matrix jkalt[`i',1] = r(N)
			}
		collapse (sum) ResB*, fast
		aorder
		mkmat ResB1-ResB$N2, matrix(a)
		matrix jkalt[1,2] = a'
		}

	drop _all

	foreach j in rc rt rcalt rtalt rccond rtcond bc bt bcalt btalt bbc bbt B BB BBB Balt BBalt Bcond jk jkalt p pp palt ppalt {
		svmat double `j'
		}
	quietly replace jk2 = jk2*(jk1-1)/jk1
	quietly replace jkalt2 = jkalt2*(jkalt1-1)/jkalt1
	generate CoefNum = _n
	generate paper = "`paper'"
	generate RegNum = .
	forvalues i = 1/$N1 {
		quietly replace RegNum = `i' if _n >= info[`i',1] & _n <= info[`i',2]
		}
	save zz\ca`paper', replace
	}

drop _all
foreach paper in AFGH CC1 CC2 CL CMS EGN HS LL IZ KN LMW S VDR A ABHOT ABS AKL AL ALO BBLP BL BM CCF CGTTTV CHKL CILS D DDK DHR DKR DR DR2 ER FG FJP FL FPPR GGY GJKM GKB KL LLLPR MMW MMW2 OT R T WDL KMP GKN GMR GRS MSV {
	append using zz\ca`paper'
	}
*dropping cases where could not calculate conditional randomization p-value but coding above produces a 0 or 1 value
foreach var in rccond rtcond Bcond {
	forvalues i = 1/3 {
		capture replace `var'`i' = . if Bcond3 == .
		}
	}
*doublechecking (should be identical)
forvalues i = 1/3 {
*GGY, where left out cases where authors group bootstrap the eqns
	replace BBB`i' = BB`i' if BBB`i' == .
	}
sum B1-B3 BB1-BB3 BBB1-BBB3 Balt* BBalt*
sum p*
sum B1 Balt1 if Balt1 ~= .
drop BB1-BB3 BBB1-BBB3 pp1 ppalt1 BBalt* Balt*
*These are not true alts, done identically - only first part of paper changed
foreach j in rcalt rtalt bcalt btalt jkalt palt {
	forvalues i = 1/3 {
		capture replace `j'`i' = . if paper == "CGTTTV" & RegNum > 6
		capture replace `j'`i' = . if paper == "GJKM" & RegNum <= 24
		}
	}
sort paper CoefNum
set seed 1
generate U = uniform()
foreach j in rc rt bc bt bbc bbt rcalt rtalt bcalt btalt rccond rtcond {
	quietly generate double p`j' = `j'2 + U*(`j'1-`j'2)
	}
gen pjk = Ftail(1,jk1-1,(B1^2)/jk2) if jk2 ~= .
gen pjkalt = Ftail(1,jkalt1-1,(B1^2)/jkalt2) if jkalt2 ~= .
sum jk* pjk* if jk3 == 1
*None of these unidentified cases (when drop one observation) are close to significance anyway 
sort paper CoefNum
save results\BaseResultsCoef, replace

************************************************
************************************************

drop _all
foreach paper in AFGH CC1 CC2 CL CMS EGN HS LL IZ KN LMW S VDR A ABHOT ABS AKL AL ALO BBLP BL BM CCF CGTTTV CHKL CILS D DDK DHR DKR DR DR2 ER FG FJP FL FPPR GGY GJKM GKB KL LLLPR MMW MMW2 OT R T WDL KMP GKN GMR GRS MSV {
	use `paper'\results\Fisher`paper', clear
	quietly sum F1
	global N1 = r(N)
	quietly sum B1
	global N2 = r(N)

	quietly generate Start = 1 if _n == 1
	quietly replace Start = Start[_n-1] + F4[_n-1] if _n > 1 & F4 ~= .
	quietly generate Finish = Start + F4 - 1
	mkmat Start Finish in 1/$N1, matrix(info)

	matrix R = J($N2,14,.)
	matrix F = J($N1,12,.)
	use `paper'\results\JackKnife`paper', clear
	forvalues i = 1/$N1 {
		local a1 = info[`i',1]
		local a2 = info[`i',2]
		forvalues j = `a1'/`a2' {
			quietly generate double t`j' = ResB`j'/ResSE`j'
			quietly generate double p`j' = Ftail(1,ResDF`i',(ResB`j'/ResSE`j')^2) if ResDF`i' ~= .
			quietly replace p`j' = chi2tail(1,(ResB`j'/ResSE`j')^2) if ResDF`i' == .
			quietly replace p`j' = -1 if ResSE`j' == 0 & ResB`j' ~= 0
			quietly replace p`j' = 10 if ResSE`j' == 0 & ResB`j' == 0
			quietly gsort -p`j'
			matrix R[`j',1] = p`j'[1], ResB`j'[1], t`j'[1], ResDF`i'[1]
			quietly sum p`j'
			matrix R[`j',5] = r(max), r(min), r(N)
			quietly sum ResB`j'
			matrix R[`j',8] = r(N), r(min), r(max)
			quietly sum t`j'
			matrix R[`j',11] = r(min), r(max)
			quietly sum ResDF`i'
			matrix R[`j',13] = r(min), r(max)
			quietly replace ResF`i' = -1 if ResSE`j' == 0 & ResB`j' ~= 0
			quietly replace ResF`i' = 10 if ResSE`j' == 0 & ResB`j' == 0
			quietly replace ResF`i' = -2 if ResF`i' == . & p`j' ~= .
			}
		quietly sum ResF`i'
		matrix F[`i',1] = r(min), r(max), r(N)
		}
	drop _all
	svmat double R
	quietly generate CoefNum = _n
	quietly generate RegNum = .
	forvalues i = 1/3 {
		quietly generate F`i' = .
		}
	forvalues i = 1/$N1 {
		quietly replace RegNum = `i' if _n >= info[`i',1] & _n <= info[`i',2]
		forvalues j = 1/3 {
			quietly replace F`j' = F[`i',`j'] if _n >= info[`i',1] & _n <= info[`i',2]
			}
		}
	quietly generate paper = "`paper'"
	save zz\jks`paper', replace
	}


drop _all
foreach paper in AFGH CC1 CC2 CL CMS EGN HS LL IZ KN LMW S VDR A ABHOT ABS AKL AL ALO BBLP BL BM CCF CGTTTV CHKL CILS D DDK DHR DKR DR DR2 ER FG FJP FL FPPR GGY GJKM GKB KL LLLPR MMW MMW2 OT R T WDL KMP GKN GMR GRS MSV {
	capture append using zz\jks`paper'
	}
sort paper CoefNum
save results\JackKnifeSensitivity, replace


