
foreach paper in AFGH CC1 CC2 CL CMS EGN HS LL IZ KN LMW S VDR A ABHOT ABS AKL AL ALO BBLP BL BM CCF CGTTTV CHKL CILS D DDK DHR DKR DR DR2 ER FG FJP FL FPPR GGY GJKM GKB KL LLLPR MMW MMW2 OT R T WDL KMP GKN GMR GRS MSV {

	use `paper'\results\Fisher`paper', clear
	quietly sum F1
	global N1 = r(N)
	quietly sum B1
	global N2 = r(N)

	quietly generate Start = 1 if _n == 1
	quietly replace Start = Start[_n-1] + F4[_n-1] if _n > 1 & F4 ~= .
	quietly generate Finish = Start + F4 - 1
	mkmat Start Finish F4 in 1/$N1, matrix(info)
	quietly generate double wald = invchi2tail(F4,F1) if F3 == .
	quietly replace wald = F4*invFtail(F4,F3,F1) if F3 ~= .
	mkmat wald in 1/$N1, matrix(wald)
	mkmat B1 in 1/$N2, matrix(B)

	foreach j in rc rw bc bw rcred rwred bcred bwred jk jkred Fred infored {
		matrix `j' = J($N1,3,.)
		}

	forvalues i = 1/$N1 {
		quietly replace ResF`i' = . if ResD`i' ~= 0
		local a = info[`i',1]
		local b = info[`i',2]
		forvalues j = `a'/`b' {
			quietly replace ResF`i' = . if (ResSE`j' == 0 | ResSE`j' == . | ResB`j' == .)
			}
		forvalues j = `a'/`b' {
			quietly replace ResB`j' = . if ResF`i' == .
			}
		}

	aorder 
	mata B = st_data(.,"ResB*")
*randomization-w
	forvalues i = 1/$N1 {
		quietly replace ResF`i' = invchi2tail(info[`i',3],ResF`i') if ResDF`i' == .
		quietly replace ResF`i' = info[`i',3]*invFtail(info[`i',3],ResDF`i',ResF`i') if ResDF`i' ~= .
		quietly sum ResF`i'
		global N = r(N)
		quietly sum ResF`i' if ResF`i' > wald[`i',1]*.999999
		matrix rw[`i',1] = (r(N)+1)/($N+1)
		quietly sum ResF`i' if ResF`i' > wald[`i',1]*1.000001
		matrix rw[`i',2] = r(N)/($N+1), $N
		}
*randomization-c
	forvalues i = 1/$N1 {
		capture drop Dev`i'
		quietly generate double Dev`i' = .
		local a = info[`i',1]
		local b = info[`i',2]
		quietly corr ResB`a'-ResB`b', covariance
		matrix V`i' = r(C)
		mata V`i' = st_matrix("V`i'"); Dev = rowsum(B[.,`a'..`b']*invsym(V`i'):*B[.,`a'..`b']); st_store(.,"Dev`i'",Dev)
		matrix A = B[`a'..`b',1]'*invsym(V`i')*B[`a'..`b',1]
		quietly replace Dev`i' = . if ResF`i' == .
		quietly sum Dev`i'
		global N = r(N)
		quietly sum Dev`i' if Dev`i' > A[1,1]*.999999
		matrix rc[`i',1] = (r(N)+1)/($N+1)
		quietly sum Dev`i' if Dev`i' > A[1,1]*1.000001
		matrix rc[`i',2] = r(N)/($N+1), $N
		}
*Bootstrap
	use `paper'\results\OBootstrap`paper', clear
	quietly generate double wald = invchi2tail(F4,F1) if F3 == .
	quietly replace wald = F4*invFtail(F4,F3,F1) if F3 ~= .
	mkmat wald in 1/$N1, matrix(wald)
	mkmat B1 in 1/$N2, matrix(B)
	mkmat F1-F4 in 1/$N1, matrix(F)

forvalues i = 1/$N1 {
	quietly replace ResFF`i' = . if ResD`i' ~= 0
	local a = info[`i',1]
	local b = info[`i',2]
	forvalues j = `a'/`b' {
		quietly replace ResFF`i' = . if (ResSE`j' == 0 | ResSE`j' == . | ResB`j' == .)
		}
	forvalues j = `a'/`b' {
		quietly replace ResB`j' = . if ResFF`i' == .
		}
	}
	aorder 
	mata B = st_data(.,"ResB*"); BB = st_matrix("B"); B = B:-BB'
*bootstrap-w
	forvalues i = 1/$N1 {
		quietly replace ResFF`i' = invchi2tail(info[`i',3],ResFF`i') if ResDF`i' == .
		quietly replace ResFF`i' = info[`i',3]*invFtail(info[`i',3],ResDF`i',ResFF`i') if ResDF`i' ~= .
		quietly sum ResFF`i'
		global N = r(N)
		quietly sum ResFF`i' if ResFF`i' > wald[`i',1]*.999999
		matrix bw[`i',1] = (r(N)+1)/($N+1)
		quietly sum ResFF`i' if ResFF`i' > wald[`i',1]*1.000001
		matrix bw[`i',2] = r(N)/($N+1), $N
		}
*bootstrap-c
	forvalues i = 1/$N1 {
		capture drop Dev`i'
		quietly generate double Dev`i' = .
		local a = info[`i',1]
		local b = info[`i',2]
		quietly corr ResB`a'-ResB`b', covariance
		matrix V`i' = r(C)
		mata V`i' = st_matrix("V`i'"); Dev = rowsum(B[.,`a'..`b']*invsym(V`i'):*B[.,`a'..`b']); st_store(.,"Dev`i'",Dev)
		matrix A = B[`a'..`b',1]'*invsym(V`i')*B[`a'..`b',1]
		quietly replace Dev`i' = . if ResFF`i' == .
		quietly sum Dev`i'
		global N = r(N)
		quietly sum Dev`i' if Dev`i' > A[1,1]*.999999
		matrix bc[`i',1] = (r(N)+1)/($N+1)
		quietly sum Dev`i' if Dev`i' > A[1,1]*1.000001
		matrix bc[`i',2] = r(N)/($N+1), $N
		}
*Jackknife
	use `paper'\results\JackKnife`paper', clear
	forvalues i = 1/$N2 {
		quietly replace ResB`i' = ResB`i' - B[`i',1]
		}
	forvalues i = 1/$N1 {
		local a = info[`i',1]
		local b = info[`i',2]
		local n = info[`i',3]
		quietly matrix accum V = ResB`a'-ResB`b', noconstant
		capture drop dif
		quietly generate double dif = 0
		forvalues j = `a'/`b' {
			quietly replace dif = dif + ResB`j'^2
			}
		quietly sum dif if dif > 1e-10
		local c = r(N)
		matrix V = V*(`c'-1)/`c'
		matrix jk[`i',1] = B[`a'..`b',1]'*invsym(V)*B[`a'..`b',1], `c', `n'
		}

*Just testing reported variables (select/reduced files)
	capture use `paper'\results\Fisherred`paper', clear
	if (_rc == 0) {
		quietly sum F1
		global N1 = r(N)
		quietly sum B1
		global N2 = r(N)

		quietly generate Start = 1 if _n == 1
		quietly replace Start = Start[_n-1] + F4[_n-1] if _n > 1 & F4 ~= .
		quietly generate Finish = Start + F4 - 1
		mkmat Start Finish F4 in 1/$N1, matrix(infored)
		quietly generate double wald = invchi2tail(F4,F1) if F3 == .
		quietly replace wald = F4*invFtail(F4,F3,F1) if F3 ~= .
		mkmat wald in 1/$N1, matrix(wald)
		mkmat B1 in 1/$N2, matrix(B)

		forvalues i = 1/$N1 {
			quietly replace ResF`i' = . if ResD`i' ~= 0
			local a = infored[`i',1]
			local b = infored[`i',2]
			forvalues j = `a'/`b' {
				quietly replace ResF`i' = . if (ResSE`j' == 0 | ResSE`j' == . | ResB`j' == .)
				}
			forvalues j = `a'/`b' {
				quietly replace ResB`j' = . if ResF`i' == .
				}
			}
		aorder 
		mata B = st_data(.,"ResB*")
*randomization-w
		forvalues i = 1/$N1 {
			quietly replace ResF`i' = invchi2tail(infored[`i',3],ResF`i') if ResDF`i' == .
			quietly replace ResF`i' = infored[`i',3]*invFtail(infored[`i',3],ResDF`i',ResF`i') if ResDF`i' ~= .
			quietly sum ResF`i'
			global N = r(N)
			quietly sum ResF`i' if ResF`i' > wald[`i',1]*.999999
			matrix rwred[`i',1] = (r(N)+1)/($N+1)
			quietly sum ResF`i' if ResF`i' > wald[`i',1]*1.000001
			matrix rwred[`i',2] = r(N)/($N+1), $N
			}
*randomization-c
		forvalues i = 1/$N1 {
			capture drop Dev`i'
			quietly generate double Dev`i' = .
			local a = infored[`i',1]
			local b = infored[`i',2]
			quietly corr ResB`a'-ResB`b', covariance
			matrix V`i' = r(C)
			mata V`i' = st_matrix("V`i'"); Dev = rowsum(B[.,`a'..`b']*invsym(V`i'):*B[.,`a'..`b']); st_store(.,"Dev`i'",Dev)
			matrix A = B[`a'..`b',1]'*invsym(V`i')*B[`a'..`b',1]
			quietly replace Dev`i' = . if ResF`i' == .
			quietly sum Dev`i'
			global N = r(N)
			quietly sum Dev`i' if Dev`i' > A[1,1]*.999999
			matrix rcred[`i',1] = (r(N)+1)/($N+1)
			quietly sum Dev`i' if Dev`i' > A[1,1]*1.000001
			matrix rcred[`i',2] = r(N)/($N+1), $N
			}
*Bootstrap
		use `paper'\results\OBootstrapred`paper', clear
		quietly generate double wald = invchi2tail(F4,F1) if F3 == .
		quietly replace wald = F4*invFtail(F4,F3,F1) if F3 ~= .
		mkmat wald in 1/$N1, matrix(wald)
		mkmat B1 in 1/$N2, matrix(B)
		mkmat F1-F4 in 1/$N1, matrix(Fred)
		forvalues i = 1/$N1 {
			quietly replace ResFF`i' = . if ResD`i' ~= 0
			local a = infored[`i',1]
			local b = infored[`i',2]
			forvalues j = `a'/`b' {
				quietly replace ResFF`i' = . if (ResSE`j' == 0 | ResSE`j' == . | ResB`j' == .)
				}
			forvalues j = `a'/`b' {
				quietly replace ResB`j' = . if ResFF`i' == .
				}
			}
		aorder 
		mata B = st_data(.,"ResB*"); BB = st_matrix("B"); B = B:-BB'
*bootstrap-w
		forvalues i = 1/$N1 {
			quietly replace ResFF`i' = invchi2tail(infored[`i',3],ResFF`i') if ResDF`i' == .
			quietly replace ResFF`i' = infored[`i',3]*invFtail(infored[`i',3],ResDF`i',ResFF`i') if ResDF`i' ~= .
			quietly sum ResFF`i'
			global N = r(N)
			quietly sum ResFF`i' if ResFF`i' > wald[`i',1]*.999999
			matrix bwred[`i',1] = (r(N)+1)/($N+1)
			quietly sum ResFF`i' if ResFF`i' > wald[`i',1]*1.000001
			matrix bwred[`i',2] = r(N)/($N+1), $N
			}
*bootstrap-c
		forvalues i = 1/$N1 {
			capture drop Dev`i'
			quietly generate double Dev`i' = .
			local a = infored[`i',1]
			local b = infored[`i',2]
			quietly corr ResB`a'-ResB`b', covariance
			matrix V`i' = r(C)
			mata V`i' = st_matrix("V`i'"); Dev = rowsum(B[.,`a'..`b']*invsym(V`i'):*B[.,`a'..`b']); st_store(.,"Dev`i'",Dev)
			matrix A = B[`a'..`b',1]'*invsym(V`i')*B[`a'..`b',1]
			quietly replace Dev`i' = . if ResFF`i' == .
			quietly sum Dev`i'
			global N = r(N)
			quietly sum Dev`i' if Dev`i' > A[1,1]*.999999
			matrix bcred[`i',1] = (r(N)+1)/($N+1)
			quietly sum Dev`i' if Dev`i' > A[1,1]*1.000001
			matrix bcred[`i',2] = r(N)/($N+1), $N
			}
*Jackknife
		use `paper'\results\JackKnifered`paper', clear
		forvalues i = 1/$N2 {
			quietly replace ResB`i' = ResB`i' - B[`i',1]
			}
		forvalues i = 1/$N1 {
			local a = infored[`i',1]
			local b = infored[`i',2]
			local n = infored[`i',3]
			quietly matrix accum V = ResB`a'-ResB`b', noconstant
			capture drop dif
			quietly generate double dif = 0
			forvalues j = `a'/`b' {
				quietly replace dif = dif + ResB`j'^2
				}
			quietly sum dif if dif > 1e-10
			local c = r(N)
			matrix V = V*(`c'-1)/`c'
			matrix jkred[`i',1] = B[`a'..`b',1]'*invsym(V)*B[`a'..`b',1], `c', `n'
			}
		}

	drop _all
	foreach j in rc rw bc bw jk info rcred rwred bcred bwred jkred infored F Fred { 
		quietly svmat double `j'
		}
	quietly generate RegNum = _n
	quietly generate paper = "`paper'"
	save zz\reg`paper', replace
	}

drop _all
foreach paper in AFGH CC1 CC2 CL CMS EGN HS LL IZ KN LMW S VDR A ABHOT ABS AKL AL ALO BBLP BL BM CCF CGTTTV CHKL CILS D DDK DHR DKR DR DR2 ER FG FJP FL FPPR GGY GJKM GKB KL LLLPR MMW MMW2 OT R T WDL KMP GKN GMR GRS MSV {
	append using zz\reg`paper'
	}
sort paper RegNum
set seed 1 
generate U = uniform()
foreach j in rc rw bc bw rcred rwred bcred bwred {
	gen double f`j' = `j'2 + U*(`j'1-`j'2)
	}
generate double fjk = Ftail(F4,jk2-1,jk1/F4)
generate double fjkred = Ftail(Fred4,jkred2-1,jkred1/Fred4)
gen double f = F1
gen double fred = Fred1
quietly replace fred = f if fred == . 
foreach var in rc rw bc bw jk {
	replace f`var'red = f`var' if f`var'red == .
	}
forvalues i = 1/4 {
	quietly replace Fred`i' = F`i' if Fred`i' == .
	}
save results\BaseResultsReg, replace


