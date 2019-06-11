
foreach paper in AFGH CC1 CC2 CL CMS EGN HS LL IZ KN LMW S VDR A ABHOT ABS AKL AL ALO BBLP BL BM CCF CGTTTV CHKL CILS D DDK DHR DKR DR DR2 ER FG FJP FL FPPR GGY GJKM GKB KL LLLPR MMW MMW2 OT R T WDL KMP GKN GMR GRS MSV {

	foreach matrix in F Fred jk jkred bc bt rc rt bcred btred rcred rtred {
		matrix `matrix' = J(1,5,.)
		}

	capture use `paper'\results\Suest`paper', clear
	if (_rc == 0) {
		mkmat F1-F5 if F1 ~= ., matrix(F)
		global N1 = rowsof(F)

		use results\basecoef, clear
		quietly keep if paper == "`paper'"
		sort CoefNum
		mkmat table suestselect suestselectred, matrix(info)
		global N = _N
		
		use `paper'\results\OJackknife`paper', clear
		forvalues i = 1/$N {
			quietly replace ResB`i' = ResB`i' - B1[`i']
			}
		mkmat B1 in 1/$N, matrix(B)
		keep ResB*
		aorder
		mata ResB = st_data(.,.,.); B = st_matrix("B"); info = st_matrix("info"); F = st_matrix("F"); jk = J($N1,5,.)
		forvalues i = 1/$N1 {
			mata select = (info[1...,1]:==F[`i',5]); select = select:*info[1...,2]; resb = select(ResB,select'); b = select(B,select)
			mata select = (resb[1...,1]:~=.); resb = select(resb,select); v = resb'*resb; n = colsum(rowsum(resb:*resb):>1e-10)
			mata v = v*(n-1)/n; v = invsym(v); n1 = colsum(rowsum(abs(v)):>0); jk[`i',1..4] = b'*v*b, n, cols(resb), n1
			}
		mata st_matrix("jk",jk)

		use `paper'\results\OBootstrap`paper', clear
		forvalues i = 1/$N {
			quietly replace ResB`i' = ResB`i' - B1[`i']
			}
		mkmat B1 in 1/$N, matrix(B)
		keep ResB*
		aorder
		mata ResB = st_data(.,.,.); B = st_matrix("B"); info = st_matrix("info"); F = st_matrix("F"); bc = J($N1,5,.)
		forvalues i = 1/$N1 {
			mata select = (info[1...,1]:==F[`i',5]); select = select:*info[1...,2]; resb = select(ResB,select'); b = select(B,select)
			mata select = (rowsum(resb,1):~=.); resb = select(resb,select); v = resb'*resb
			mata v = invsym(v); n1 = colsum(rowsum(abs(v)):>0); t1 = rowsum((resb*v):*resb); t2 = b'*v*b 
			mata bc[`i',1..5] = colsum(t1:>t2*.999999), colsum(t1:>t2*1.000001), cols(resb), n1, rows(resb)
			}
		mata st_matrix("bc",bc)

		use `paper'\results\Fisher`paper', clear
		mkmat B1 in 1/$N, matrix(B)
		keep ResB*
		aorder
		mata ResB = st_data(.,.,.); B = st_matrix("B"); info = st_matrix("info"); F = st_matrix("F"); rc = J($N1,5,.)
		forvalues i = 1/$N1 {
			mata select = (info[1...,1]:==F[`i',5]); select = select:*info[1...,2]; resb = select(ResB,select'); b = select(B,select)
			mata select = (rowsum(resb,1):~=.); resb = select(resb,select); v = resb'*resb
			mata v = invsym(v); n1 = colsum(rowsum(abs(v)):>0); t1 = rowsum((resb*v):*resb); t2 = b'*v*b 
			mata rc[`i',1..5] = colsum(t1:>t2*.999999), colsum(t1:>t2*1.000001), cols(resb), n1, rows(resb)
			}
		mata st_matrix("rc",rc)

		use `paper'\results\FisherSuest`paper', clear
		mkmat F* in 1/$N1, matrix(f)
		matrix rt = J($N1,5,.)
		forvalues i = 1/$N1 {
			local j2 = (`i'-1)*5 + 2
			local j3 = (`i'-1)*5 + 3
			local j4 = (`i'-1)*5 + 4
			quietly sum ResF`j4' if ResF`j2' == 0 & ResF`j3' == f[`i',3] 
			global N2 = r(N)
			quietly sum ResF`j4' if ResF`j2' == 0 & ResF`j3' == f[`i',3] & ResF`j4' > f[`i',4]*.999999
			matrix rt[`i',1] = r(N)
			quietly sum ResF`j4' if ResF`j2' == 0 & ResF`j3' == f[`i',3] & ResF`j4' > f[`i',4]*1.000001
			matrix rt[`i',2] = r(N), $N2, f[`i',3]
			}

		use `paper'\results\OBootstrapSuest`paper', clear
		mkmat F* in 1/$N1, matrix(f)
		matrix bt = J($N1,5,.)
		forvalues i = 1/$N1 {
			local j2 = (`i'-1)*5 + 2
			local j3 = (`i'-1)*5 + 3
			local j4 = (`i'-1)*5 + 4
			quietly sum ResF`j4' if ResF`j2' == 0 & ResF`j3' == f[`i',3] 
			global N2 = r(N)
			quietly sum ResF`j4' if ResF`j2' == 0 & ResF`j3' == f[`i',3] & ResF`j4' > f[`i',4]*.999999
			matrix bt[`i',1] = r(N)
			quietly sum ResF`j4' if ResF`j2' == 0 & ResF`j3' == f[`i',3] & ResF`j4' > f[`i',4]*1.000001
			matrix bt[`i',2] = r(N), $N2, f[`i',3]
			}
		}

	capture use `paper'\results\Suestred`paper', clear
	if (_rc == 0) {
		mkmat F1-F5 if F1 ~= ., matrix(Fred)
	
		use `paper'\results\OJackknife`paper', clear
		forvalues i = 1/$N {
			quietly replace ResB`i' = ResB`i' - B1[`i']
			}
		mkmat B1 in 1/$N, matrix(B)
		keep ResB*
		aorder
		mata ResB = st_data(.,.,.); B = st_matrix("B"); info = st_matrix("info"); F = st_matrix("F"); jkred = J($N1,5,.)
		forvalues i = 1/$N1 {
			mata select = (info[1...,1]:==F[`i',5]); select = select:*info[1...,3]; resb = select(ResB,select'); b = select(B,select)
			mata select = (resb[1...,1]:~=.); resb = select(resb,select); v = resb'*resb; n = colsum(rowsum(resb:*resb):>1e-10)
			mata v = v*(n-1)/n; v = invsym(v); n1 = colsum(rowsum(abs(v)):>0); jkred[`i',1..4] = b'*v*b, n, cols(resb), n1
			}
		mata st_matrix("jkred",jkred)

		use `paper'\results\OBootstrap`paper', clear
		forvalues i = 1/$N {
			quietly replace ResB`i' = ResB`i' - B1[`i']
			}
		mkmat B1 in 1/$N, matrix(B)
		keep ResB*
		aorder
		mata ResB = st_data(.,.,.); B = st_matrix("B"); info = st_matrix("info"); F = st_matrix("F"); bcred = J($N1,5,.)
		forvalues i = 1/$N1 {
			mata select = (info[1...,1]:==F[`i',5]); select = select:*info[1...,3]; resb = select(ResB,select'); b = select(B,select)
			mata select = (rowsum(resb,1):~=.); resb = select(resb,select); v = resb'*resb
			mata v = invsym(v); n1 = colsum(rowsum(abs(v)):>0); t1 = rowsum((resb*v):*resb); t2 = b'*v*b 
			mata bcred[`i',1..5] = colsum(t1:>t2*.999999), colsum(t1:>t2*1.000001), cols(resb), n1, rows(resb)
			}
		mata st_matrix("bcred",bcred)

		use `paper'\results\Fisher`paper', clear
		mkmat B1 in 1/$N, matrix(B)
		keep ResB*
		aorder
		mata ResB = st_data(.,.,.); B = st_matrix("B"); info = st_matrix("info"); F = st_matrix("F"); rcred = J($N1,5,.)
		forvalues i = 1/$N1 {
			mata select = (info[1...,1]:==F[`i',5]); select = select:*info[1...,3]; resb = select(ResB,select'); b = select(B,select)
			mata select = (rowsum(resb,1):~=.); resb = select(resb,select); v = resb'*resb
			mata v = invsym(v); n1 = colsum(rowsum(abs(v)):>0); t1 = rowsum((resb*v):*resb); t2 = b'*v*b 
			mata rcred[`i',1..5] = colsum(t1:>t2*.999999), colsum(t1:>t2*1.000001), cols(resb), n1, rows(resb)
			}
		mata st_matrix("rcred",rcred)

		use `paper'\results\FisherSuestred`paper', clear
		mkmat F* in 1/$N1, matrix(f)
		matrix rtred = J($N1,5,.)
		forvalues i = 1/$N1 {
			local j2 = (`i'-1)*5 + 2
			local j3 = (`i'-1)*5 + 3
			local j4 = (`i'-1)*5 + 4
			quietly sum ResF`j4' if ResF`j2' == 0 & ResF`j3' == f[`i',3] 
			global N2 = r(N)
			quietly sum ResF`j4' if ResF`j2' == 0 & ResF`j3' == f[`i',3] & ResF`j4' > f[`i',4]*.999999
			matrix rtred[`i',1] = r(N)
			quietly sum ResF`j4' if ResF`j2' == 0 & ResF`j3' == f[`i',3] & ResF`j4' > f[`i',4]*1.000001
			matrix rtred[`i',2] = r(N), $N2, f[`i',3]
			}

		use `paper'\results\OBootstrapSuestred`paper', clear
		mkmat F* in 1/$N1, matrix(f)
		matrix btred = J($N1,5,.)
		forvalues i = 1/$N1 {
			local j2 = (`i'-1)*5 + 2
			local j3 = (`i'-1)*5 + 3
			local j4 = (`i'-1)*5 + 4
			quietly sum ResF`j4' if ResF`j2' == 0 & ResF`j3' == f[`i',3] 
			global N2 = r(N)
			quietly sum ResF`j4' if ResF`j2' == 0 & ResF`j3' == f[`i',3] & ResF`j4' > f[`i',4]*.999999
			matrix btred[`i',1] = r(N)
			quietly sum ResF`j4' if ResF`j2' == 0 & ResF`j3' == f[`i',3] & ResF`j4' > f[`i',4]*1.000001
			matrix btred[`i',2] = r(N), $N2, f[`i',3]
			}
		}

	drop _all
	foreach matrix in F Fred jk jkred bc bcred rc rcred bt btred rt rtred {
		svmat double `matrix'
		}
	generate paper = "`paper'"
	save zz\iptable`paper', replace
	
	}

drop _all
foreach paper in AFGH CC1 CC2 CL CMS EGN HS LL IZ KN LMW S VDR A ABHOT ABS AKL AL ALO BBLP BL BM CCF CGTTTV CHKL CILS D DDK DHR DKR DR DR2 ER FG FJP FL FPPR GGY GJKM GKB KL LLLPR MMW MMW2 OT R T WDL KMP GKN GMR GRS MSV {
	append using zz\iptable`paper'
	}
rename F5 table
sort paper table
set seed 1
gen double u = uniform()
gen double p = F1
gen double pred = Fred1
gen double prw = (rt2 + u*(1+rt1-rt2))/(rt3+1)
gen double prwred = (rtred2 + u*(1+rtred1-rtred2))/(rtred3+1)
gen double pbw = (bt2 + u*(1+bt1-bt2))/(bt3+1) if bt3 > 500
gen double pbwred = (btred2 + u*(1+btred1-btred2))/(btred3+1) if btred3 > 500
gen double prc = (rc2 + u*(1+rc1-rc2))/(rc5+1) if rc3 == rc4
gen double prcred = (rcred2 + u*(1+rcred1-rcred2))/(rcred5+1) if rcred3 == rcred4
gen double pbc = (bc2 + u*(1+bc1-bc2))/(bc5+1) if bc3 == bc4
gen double pbcred = (bcred2 + u*(1+bcred1-bcred2))/(bcred5+1) if bcred3 == bcred4
gen double pjk = Ftail(jk3,jk2-1,jk1/jk3) if jk3 == jk4
gen double pjkred = Ftail(jkred3,jkred2-1,jkred1/jkred3) if jkred3 == jkred4
foreach var in p prw pbw prc pbc pjk {
	replace `var'red = `var' if `var'red == .
	}
*In cases where pred = . because covariance estimate was singular, p = . for same type as well
forvalues i = 1/4 {
	replace Fred`i' = F`i' if Fred`i' == .
	}
save results\baseresultstable, replace

