
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, re mle]
	tempvar touse xb e S1 S2 S3 S4 sum ssum Ti b c n
	gettoken testvars anything: anything, match(match)
	gettoken cmd anything: anything
	gettoken dep anything: anything
	unab anything: `anything'
	global k = wordcount("`testvars'")
	`cmd' `dep' `anything' `if' `in', `re' `mle'
	gen `touse' = e(sample)
	bysort $cluster `touse' $panelvar: gen `n' = _n
	egen `Ti' = count(`n') if `touse', by($panelvar)
	matrix b = e(b)
	matrix v = e(V)
	global kk = colsof(b)
	global a = 1/(b[1,$kk]^2)
	gen double `b' = (b[1,$kk-1]^2)/(`Ti'*b[1,$kk-1]^2+b[1,$kk]^2) if `touse'
	gen double `c' = 1/(`Ti'*b[1,$kk-1]^2+b[1,$kk]^2) if `touse'
	quietly predict double `xb' if `touse', xb
	quietly gen double `e' = `dep' - `xb' if `touse'
	matrix grad = J($ncluster,$kk,.)
	local anything = "`anything'" + " " + "constant"
	local i = 1
	quietly egen double `S1' = sum(`e') if `touse', by($panelvar)
	quietly egen double `S4' = sum(`e'*`e') if  `touse', by($panelvar)
	foreach var in `anything' {
		quietly egen double `S2' = sum(`e'*`var') if `touse', by($panelvar)
		quietly egen double `S3' = sum(`var') if `touse', by($panelvar)
		quietly gen double `sum' = $a*(`S2' -`b'*`S1'*`S3') if `n' == 1 & `touse' == 1
		quietly replace `sum' = 0 if `touse' == 0 & `n' == 1
		quietly egen double `ssum' = sum(`sum'), by($cluster)
		mkmat `ssum' if nn == 1, matrix(g)
		matrix grad[1,`i'] = g 
		local i = `i' + 1
		capture drop `S2' `S3' `sum' `ssum'
		}
	quietly gen double `sum' = (`b'/b[1,$kk-1])*(`S1'*`S1'*`b'/(b[1,$kk-1]^2) - `Ti') if `n' == 1 & `touse' == 1
	quietly replace `sum' = 0 if `touse' == 0 & `n' == 1
	quietly egen double `ssum' = sum(`sum'), by($cluster)
	mkmat `ssum' if nn == 1, matrix(g)
	matrix grad[1,`i'] = g 
	local i = `i' + 1
	capture drop `sum' `ssum'

	quietly gen double `sum' = -(`Ti'-1)/b[1,$kk] - `c'*b[1,$kk] - `b'*`c'*`S1'*`S1'/b[1,$kk]+(`S4'-`b'*`S1'*`S1')/(b[1,$kk]^3) if `n' == 1 & `touse' == 1
	quietly replace `sum' = 0 if `touse' == 0 & `n' == 1
	quietly egen double `ssum' = sum(`sum'), by($cluster)
	mkmat `ssum' if nn == 1, matrix(g)
	matrix grad[1,`i'] = g 
	local i = `i' + 1
	capture drop `sum' `ssum'

	mata b = st_matrix("b"); v = st_matrix("v"); grad = st_matrix("grad"); select = J(1,$kk,0); select[1,1..$k] = J(1,$k,1)
	if ($i == 1) {
		mata B = b; G = v*grad'; Select = select; dc = J(1,$ncluster,1)*grad; DC = dc*dc'
		}
	else {
		mata B = B, b; G = G \ (v*grad'); Select = Select, select; dc = J(1,$ncluster,1)*grad; DC = DC + dc*dc'
		}
global i = $i + 1
end

****************************************
****************************************

matrix a = (-3.88972, -3.02064, -2.27951, -1.59768, -.947788, -.31424, .31424, .947788, 1.59768, 2.27951, 3.02064, 3.88972)
matrix w = (2.65855e-07, 8.57369e-05, .00390539, .051608, .260492, .570135, .570135, .260492, .051608, .00390539, 8.57369e-05, 2.65855e-07)


capture program drop mycmd1
program define mycmd1
	syntax anything [if] [in] [, re ]
	tempvar touse xb S n nn der sum
	tempvar p1 p2 p3 p4 p5 p6 p7 p8 p9 p10 p11 p12 
	tempvar P1 P2 P3 P4 P5 P6 P7 P8 P9 P10 P11 P12
	tempvar S1 S2 S3 S4 S5 S6 S7 S8 S9 S10 S11 S12
	tempvar d1 d2 d3 d4 d5 d6 d7 d8 d9 d10 d11 d12
	gettoken testvars anything: anything, match(match)
	gettoken cmd anything: anything
	gettoken dep anything: anything
	unab anything: `anything'
	global k = wordcount("`testvars'")
	`cmd' `dep' `anything' `if' `in', `re' intmethod(ghermite)
	gen `touse' = e(sample)
	predict double `xb' if `touse', xb
	quietly replace `xb' = `xb' 
	matrix b = e(b)
	matrix v = e(V)
	global rho = _b[lnsig2u:_cons]
	global rho  = exp($rho)
	global rho = ($rho)/($rho+1)
	bysort $cluster `touse' $panelvar: gen `n' = _n
	egen `nn' = max(`n'), by($cluster `touse' $panelvar)
	forvalues i = 1/12 {
		quietly generate double `p`i'' = normalden((`dep'*2-1)*(`xb'+a[1,`i']*(2*$rho/(1-$rho))^.5)) if `touse'
		quietly generate double `P`i'' = normal((`dep'*2-1)*(`xb'+a[1,`i']*(2*$rho/(1-$rho))^.5)) if `touse'
		quietly egen double `S`i'' = sum(ln(`P`i'')) if `touse', by($panelvar)
		quietly replace `S`i'' = exp(`S`i'')
		quietly generate double `d`i'' = `S`i''*`p`i''/`P`i'' if `touse'
		}
	quietly gen double `S' = 0 if `touse' 
	forvalues i = 1/12 {
		quietly replace `S' = `S' + w[1,`i']*`S`i'' if `touse' 
		}
	local anything = "`anything'" + " " + "constant"
	global kk = wordcount("`anything'") + 1
	matrix b[1,$kk] = $rho
	matrix grad = J($ncluster,$kk,.)
	local k = 1
	foreach var in `anything' {
		quietly generate double `der' = 0 if `touse'
		forvalues i = 1/12 {
			quietly replace `der' = `der' + w[1,`i']*(`dep'*2-1)*`d`i''*`var'/`S' if `touse'
			}
		quietly egen double `sum' = sum(`der'), by($cluster)
		mkmat `sum' if $cluster ~= $cluster[_n-1], matrix(g)
		matrix grad[1,`k'] = g
		local k = `k' + 1
		capture drop `der' `sum'
		}
	quietly generate double `der' = 0 if `touse'
	forvalues i = 1/12 {
		quietly replace `der' = `der' + w[1,`i']*(`dep'*2-1)*`d`i''*a[1,`i']/`S' if `touse'
		}
	quietly replace `der' = `der'/(((2*$rho)*(1-$rho)^3)^.5)
	quietly egen double `sum' = sum(`der'), by($cluster)
	mkmat `sum' if nn == 1, matrix(g)
	matrix grad[1,`k'] = g
	mata b = st_matrix("b"); v = st_matrix("v"); grad = st_matrix("grad"); select = J(1,$kk,0); select[1,1..$k] = J(1,$k,1)
	if ($i == 1) {
		mata B = b; G = v*grad'; Select = select; dc = J(1,$ncluster,1)*grad; DC = dc*dc'
		}
	else {
		mata B = B, b; G = G \ (v*grad'); Select = Select, select; dc = J(1,$ncluster,1)*grad; DC = DC + dc*dc'
		}
global i = $i + 1
end

****************************************
****************************************

use DatS, clear

global cluster = "session"
global panelvar = "ID"
global ncluster = 5
bysort $cluster: gen nn = _n
generate byte constant = 1

*Table 5
global i = 1
foreach X in "" "0" {
	mycmd (trocp`X' treatp`X') xtreg prexp trocp`X' treatp`X' oc`X', re mle 
	}
foreach X in poexp poexp_a {
	mycmd (troca treata) xtreg `X' troca treata oc, re mle
	}

mata gg = select(G,Select'); bb = select(B,Select); v = ($ncluster/($ncluster-1))*gg*gg'; v = invsym(v); test =  bb*v*bb',sum(rowsum(abs(v)):>0)
mata test = chi2tail(test[1,2],test[1,1]), cols(bb)-test[1,2], test[1,2], test[1,1], 5 ; st_matrix("test",test); st_matrix("dc",DC)
matrix F = test
matrix DC = dc

*Table 6 
global i = 1
foreach X in "" "0" {
	mycmd( trocp`X' treatp`X') xtreg prexp trocp`X' treatp`X' oc`X' if p1 == 1, re mle 
	}
foreach X in poexp poexp_a {
	mycmd (troca treata) xtreg `X' troca treata oc if p1 == 1, re mle
	}

mata gg = select(G,Select'); bb = select(B,Select); v = ($ncluster/($ncluster-1))*gg*gg'; v = invsym(v); test =  bb*v*bb',sum(rowsum(abs(v)):>0)
mata test = chi2tail(test[1,2],test[1,1]), cols(bb)-test[1,2], test[1,2], test[1,1], 6 ; st_matrix("test",test); st_matrix("dc",DC)
matrix F = F \ test
matrix DC = DC \ dc

*Table 7 
global i = 1
foreach Y in wexp wgap {
	foreach X in "" "0" {
		mycmd (trocp`X' treatp`X') xtreg `Y' trocp`X' treatp`X' oc`X' if p1 == 1, re mle 
		}
	}

mycmd (troca0 treata0) xtreg investment troca0 treata0 oc if p1==1, re mle
mycmd (troca treata) xtreg reject troca treata oc if p1==1, re mle

mata gg = select(G,Select'); bb = select(B,Select); v = ($ncluster/($ncluster-1))*gg*gg'; v = invsym(v); test =  bb*v*bb',sum(rowsum(abs(v)):>0)
mata test = chi2tail(test[1,2],test[1,1]), cols(bb)-test[1,2], test[1,2], test[1,1], 7 ; st_matrix("test",test); st_matrix("dc",DC)
matrix F = F \ test
matrix DC = DC \ dc

*Table B4
global i = 1
foreach X in "" "dumneg" {
	mycmd1 (wgaptr wgaptroc treat troc) xtprobit investment wgaptr wgaptroc treat troc wgap wgapoc dum23 oc `X' if reject==0 & role==2 , re
	}
foreach X in "" "dumneg" {
	mycmd1 (wgaptr wgaptroc treat troc wexptr wexptroc) xtprobit reject wgaptr wgaptroc treat troc wexptr wexptroc wgap wgapoc oc wexp2 wexpoc dumPC `X' if role==2, re
	}

mata gg = select(G,Select'); bb = select(B,Select); v = ($ncluster/($ncluster-1))*gg*gg'; v = invsym(v); test =  bb*v*bb',sum(rowsum(abs(v)):>0)
mata test = chi2tail(test[1,2],test[1,1]), cols(bb)-test[1,2], test[1,2], test[1,1], 104 ; st_matrix("test",test); st_matrix("dc",DC)
matrix F = F \ test
matrix DC = DC \ dc

*Table B5 
global i = 1
foreach Y in wexp wgap {
	foreach X in "" "0" {
		mycmd (trocp`X' treatp`X') xtreg `Y' trocp`X' treatp`X' oc`X', re mle 
		}
	}
mycmd (troca0 treata0) xtreg investment troca0 treata0 oc, re mle
mycmd (troca treata) xtreg reject troca treata oc, re mle

mata gg = select(G,Select'); bb = select(B,Select); v = ($ncluster/($ncluster-1))*gg*gg'; v = invsym(v); test =  bb*v*bb',sum(rowsum(abs(v)):>0)
mata test = chi2tail(test[1,2],test[1,1]), cols(bb)-test[1,2], test[1,2], test[1,1], 105 ; st_matrix("test",test); st_matrix("dc",DC)
matrix F = F \ test
matrix DC = DC \ dc


drop _all
svmat double F
svmat double DC
save results/SuestS, replace

